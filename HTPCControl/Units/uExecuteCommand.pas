unit uExecuteCommand;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics,
  uDataBase, uLanguage, uTypes, uShellApplication, SyncObjs;

type
  TExecuteCommandState = (ecBegin, ecExecuting, ecEnd);

type
  TExecuteCommandBeginEvent = procedure(EIndex: integer; RCommand: TRemoteCommand;
    Operations: String; OWait: integer; RepeatPrevious: boolean) of object;
  TExecuteCommandExecutingEvent = procedure(EIndex: integer; Step: integer) of object;
  TExecuteCommandEndEvent = procedure(EIndex: integer) of object;
  TPreviousCommandEvent = procedure(Operations: string) of object;

type
  TExecuteCommand = class
    procedure Execute(RCommand: TRemoteCommand; RepeatPrevious: boolean = false);
    procedure ClearPrevious();
  private
    FDB: TDataBase;
    FCS: TCriticalSection;
    FEIndex: integer;
    FPrevRCommand: PRemoteCommand;

    FOnExecuteBegin: TExecuteCommandBeginEvent;
    FOnExecuteEnd: TExecuteCommandEndEvent;
    FOnExecuting: TExecuteCommandExecutingEvent;
    FOnPreviousCommand: TPreviousCommandEvent;

    procedure onThreadTerminate(Sender: TObject);
    procedure onThreadExecuting(EIndex: integer; Step: integer);

    procedure DoExecuteBegin(EIndex: integer; RCommand: TRemoteCommand; Operations: TOperations;
      RepeatPrevious: boolean); dynamic;
    procedure DoExecuteEnd(EIndex: integer); dynamic;
    procedure DoExecuting(EIndex: integer; Step: integer); dynamic;
    procedure DoPreviousCommand(Operations: string); dynamic;

    procedure SetPrevious(RCommand: TRemoteCommand; Operations: string);
    function LineOperations(Operations: TOperations): string; overload;
    function LineOperations(Operations: TOperations; var OWait: integer): string; overload;

  public
    constructor Create(DB: TDataBase); overload;
    destructor Destroy; override;

    property OnExecuteBegin: TExecuteCommandBeginEvent read FOnExecuteBegin write FOnExecuteBegin;
    property OnExecuteEnd: TExecuteCommandEndEvent read FOnExecuteEnd write FOnExecuteEnd;
    property OnExecuting: TExecuteCommandExecutingEvent read FOnExecuting write FOnExecuting;
    property OnPreviousCommand: TPreviousCommandEvent read FOnPreviousCommand
      write FOnPreviousCommand;
  end;

  TThreadExecuteCommand = class(TThread)
  private
    FCS: TCriticalSection;
    FEIndex: integer;
    FOperations: TOperations;

    FOnExecuting: TExecuteCommandExecutingEvent;

    procedure DoExecuting(EIndex: integer; Step: integer); dynamic;

    procedure RunApplication(Operation: TORunApplication; OText: string);
    procedure PressKeyboard(Operation: TOPressKeyboard; OText: string);
  protected
    procedure Execute; override;
  public
    constructor Create(CriticalSection: TCriticalSection; EIndex: integer;
      Operations: TOperations); overload;
    destructor Destroy; override;

    property OnExecuting: TExecuteCommandExecutingEvent read FOnExecuting write FOnExecuting;
  end;

  TObjectRemoteCommand = class
    FEIndex: integer;
    FCommand: string;
    FState: TExecuteCommandState;
    FIcon: TIcon;
    FAll: integer;
    FCurrent: integer;
  public
    constructor Create(EIndex: integer; Command: string; All: integer);
    destructor Destroy; override;

    property EIndex: integer read FEIndex;
    property Command: string read FCommand write FCommand;
    property State: TExecuteCommandState read FState write FState;
    property Icon: TIcon read FIcon write FIcon;
    property All: integer read FAll;
    property Current: integer read FCurrent write FCurrent;
  end;

implementation

{ TExecuteCommand }

constructor TExecuteCommand.Create(DB: TDataBase);
begin
  FDB := DB;
  FCS := TCriticalSection.Create;
  FEIndex := 0;
end;

destructor TExecuteCommand.Destroy;
begin
  FCS.Free;
  inherited;
end;

procedure TExecuteCommand.DoExecuteBegin(EIndex: integer; RCommand: TRemoteCommand;
  Operations: TOperations; RepeatPrevious: boolean);
var
  OWait: integer;
  OLine: string;
begin

  if Assigned(FOnExecuteBegin) then
  begin
    OLine := LineOperations(Operations, OWait);
    FOnExecuteBegin(EIndex, RCommand, OLine, OWait, RepeatPrevious);
  end;
end;

procedure TExecuteCommand.DoExecuteEnd(EIndex: integer);
begin
  if Assigned(FOnExecuteEnd) then
    FOnExecuteEnd(EIndex);
end;

procedure TExecuteCommand.DoExecuting(EIndex: integer; Step: integer);
begin
  if Assigned(FOnExecuting) then
    FOnExecuting(EIndex, Step);
end;

procedure TExecuteCommand.DoPreviousCommand(Operations: string);
begin
  if Assigned(FOnPreviousCommand) then
    FOnPreviousCommand(Operations);
end;

procedure TExecuteCommand.Execute(RCommand: TRemoteCommand; RepeatPrevious: boolean = false);
var
  Operations: TOperations;
  ThreadExecute: TThreadExecuteCommand;
begin

  // Повтор предыдущей команды
  if RCommand.RepeatPrevious and (FPrevRCommand <> nil) then
  begin
    Execute(TRemoteCommand(FPrevRCommand^), True);
    Exit;
  end;

  Operations := FDB.getOperation(RCommand.Command);

  SetPrevious(RCommand, LineOperations(Operations));

  // FPrevRCommand := RCommand;

  if Length(Operations) > 0 then
  begin
    inc(FEIndex);
    ThreadExecute := TThreadExecuteCommand.Create(FCS, FEIndex, Operations);
    ThreadExecute.OnExecuting := onThreadExecuting;
    ThreadExecute.OnTerminate := onThreadTerminate;
    ThreadExecute.FreeOnTerminate := True;
    ThreadExecute.Priority := tpLower;
    ThreadExecute.Start;

    DoExecuteBegin(FEIndex, RCommand, Operations, RepeatPrevious);
  end;

end;

procedure TExecuteCommand.onThreadExecuting(EIndex: integer; Step: integer);
begin
  DoExecuting(EIndex, Step);
end;

procedure TExecuteCommand.onThreadTerminate(Sender: TObject);
begin
  DoExecuteEnd(TThreadExecuteCommand(Sender).FEIndex);
end;

procedure TExecuteCommand.SetPrevious(RCommand: TRemoteCommand; Operations: string);
begin
  if RCommand.LongPress then
  begin
    if FPrevRCommand = nil then
      New(FPrevRCommand);
    FPrevRCommand^ := RCommand;
    DoPreviousCommand(Operations);
  end
  else
    ClearPrevious;
end;

function TExecuteCommand.LineOperations(Operations: TOperations; var OWait: integer): string;
var
  i: integer;

  function OperationLine(O: TOperation): string;
  begin
    Result := inttostr(O.OSort) + ': ' + O.Operation;
    if O.OWait > 0 then
      Result := Result + ' (' + floattostr(O.OWait / 1000) + ' c.)'
  end;

begin
  case Length(Operations) of
    0:
      begin

      end;
    1:
      begin
        Result := Operations[0].Operation;
        OWait := Operations[0].OWait;
        if Operations[0].OWait > 0 then
          Result := Result + ' (' + floattostr(Operations[0].OWait / 1000) + ' c.)'
      end;
  else
    begin
      Result := OperationLine(Operations[0]);
      OWait := Operations[0].OWait;
      for i := 1 to Length(Operations) - 1 do
      begin
        OWait := OWait + Operations[i].OWait;
        Result := Result + #13#10 + OperationLine(Operations[i]);
      end;
    end;
  end;

end;

function TExecuteCommand.LineOperations(Operations: TOperations): string;
var
  OWait: integer;
begin
  Result := LineOperations(Operations, OWait);
end;

procedure TExecuteCommand.ClearPrevious;
begin
  if FPrevRCommand <> nil then
  begin
    Dispose(FPrevRCommand);
    FPrevRCommand := nil;
  end;
  DoPreviousCommand('');
end;

{ TThreadExecuteCommand }

constructor TThreadExecuteCommand.Create(CriticalSection: TCriticalSection; EIndex: integer;
  Operations: TOperations);
begin
  Create(True);
  FCS := CriticalSection;
  FEIndex := EIndex;
  FOperations := Operations;
end;

destructor TThreadExecuteCommand.Destroy;
begin

  inherited;
end;

procedure TThreadExecuteCommand.DoExecuting(EIndex: integer; Step: integer);
begin
  if Assigned(FOnExecuting) then
    FOnExecuting(EIndex, Step);
end;

procedure TThreadExecuteCommand.Execute;
var
  i, sl, slAll: integer;
begin
  FCS.Enter;
  sl := 0;
  slAll := 0;

  try
    for i := 0 to Length(FOperations) - 1 do
    begin

      // задержка перед выполнением
      if FOperations[i].OWait > 0 then
      begin
        sl := 0;
        while sl < FOperations[i].OWait do
        begin
          sleep(100);
          sl := sl + 100;
          DoExecuting(FEIndex, slAll + sl);
        end;
      end;
      slAll := slAll + FOperations[i].OWait;

      case FOperations[i].OType of
        opApplication:
          RunApplication(FOperations[i].RunApplication, FOperations[i].Operation);
        opKyeboard:
          PressKeyboard(FOperations[i].PressKeyboard, FOperations[i].Operation);
      end;
    end;
  finally
    FCS.Leave;
  end;
end;

procedure TThreadExecuteCommand.PressKeyboard(Operation: TOPressKeyboard; OText: string);
var
  i, len, si: integer;
  KeyInputs: array of TInput;
  FileName: string;

  procedure keyDown(Key: integer);
  begin
    if Key <> 0 then
    begin
      SetLength(KeyInputs, Length(KeyInputs) + 1);
      KeyInputs[Length(KeyInputs) - 1].Itype := INPUT_KEYBOARD;
      KeyInputs[Length(KeyInputs) - 1].ki.wVk := Key;

      KeyInputs[Length(KeyInputs) - 1].ki.wScan := MapVirtualKey(Key, 0);
      KeyInputs[Length(KeyInputs) - 1].ki.time := 0;
      KeyInputs[Length(KeyInputs) - 1].ki.dwExtraInfo := 0;

      KeyInputs[Length(KeyInputs) - 1].ki.dwFlags := KEYEVENTF_EXTENDEDKEY;
    end;
  end;

begin

  if (Length(Operation.ForApplication) > 0) and FileExists(Operation.ForApplication) then
  begin
    // текущее актуальное приложение
    try
      FileName := uShellApplication.GetExePath(GetForegroundWindow);
      if FileName <> Operation.ForApplication then
        Exit;
    except
      on E: Exception do
    end;
  end;

  // Нажимаю кнопки
  keyDown(Operation.Key1);
  keyDown(Operation.Key2);
  keyDown(Operation.Key3);

  // Отпускаю кнопки в обратной последовательности
  len := Length(KeyInputs) - 1;
  for i := len downto 0 do
  begin
    SetLength(KeyInputs, Length(KeyInputs) + 1);
    KeyInputs[Length(KeyInputs) - 1] := KeyInputs[i];
    KeyInputs[Length(KeyInputs) - 1].ki.dwFlags := KeyInputs[Length(KeyInputs) - 1].ki.dwFlags or
      KEYEVENTF_KEYUP;
  end;

  si := SendInput(Length(KeyInputs), KeyInputs[0], SizeOf(TInput));

  // showmessage(inttostr());
end;

procedure TThreadExecuteCommand.RunApplication(Operation: TORunApplication; OText: string);
var
  Rlst: LongBool;
  Application: PWideChar;
  StartUpInfo: TStartUpInfo;
  ProcessInfo: TProcessInformation;
  FileName: string;
begin
  FileName := Operation.Application;
  if (Length(FileName) > 0) and FileExists(FileName) then
  begin
    Application := PWideChar(WideString(FileName));
    FillChar(StartUpInfo, SizeOf(TStartUpInfo), 0);
    StartUpInfo.cb := SizeOf(TStartUpInfo);
    StartUpInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
    StartUpInfo.wShowWindow := SW_SHOWNORMAL;
    Rlst := CreateProcess(Application, nil, nil, nil, false, NORMAL_PRIORITY_CLASS, nil, nil,
      StartUpInfo, ProcessInfo);
    if Rlst then
    begin
      WaitForInputIdle(ProcessInfo.hProcess, INFINITE); // ждем завершения инициализации
      CloseHandle(ProcessInfo.hThread); // закрываем дескриптор процесса
      CloseHandle(ProcessInfo.hProcess); // закрываем дескриптор потока

      // DoRunApplication(Operation, OText);
    end
    else
      raise Exception.Create(Format(GetLanguageMsg('msgExecuteCommandRunApplication', lngRus),
        [SysErrorMessage(GetLastError)]));
  end;
end;

{ TObjectRemoteCommand }

constructor TObjectRemoteCommand.Create(EIndex: integer; Command: string; All: integer);
begin
  Self.FEIndex := EIndex;
  Self.FCommand := Command;
  Self.FState := ecBegin;
  Self.FIcon := TIcon.Create();
  Self.FAll := All;
end;

destructor TObjectRemoteCommand.Destroy;
begin
  Self.FIcon.Free;
end;

end.
