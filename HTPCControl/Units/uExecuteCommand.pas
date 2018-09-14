unit uExecuteCommand;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics,
  uDataBase, uLanguage, uTypes, uShellApplication, SyncObjs;

type
  TExecuteCommandState = (ecBegin, ecEnd);

type
  TExecuteCommandBeginEvent = procedure(EIndex: integer; RCommand: TRemoteCommand;
    Operations: String; RepeatPrevious: boolean) of object;
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

    FOnExecuteCommandBegin: TExecuteCommandBeginEvent;
    FOnExecuteCommandEnd: TExecuteCommandEndEvent;
    FOnPreviousCommand: TPreviousCommandEvent;

    procedure onThreadTerminate(Sender: TObject);

    procedure DoExecuteCommandBegin(EIndex: integer; RCommand: TRemoteCommand;
      Operations: TOperations; RepeatPrevious: boolean); dynamic;
    procedure DoExecuteCommandEnd(EIndex: integer); dynamic;
    procedure DoPreviousCommand(Operations: string); dynamic;

    procedure SetPrevious(RCommand: TRemoteCommand; Operations: string);
    function LineOperations(Operations: TOperations): string;

  public
    constructor Create(DB: TDataBase); overload;
    destructor Destroy; override;

    property OnExecuteCommandBegin: TExecuteCommandBeginEvent read FOnExecuteCommandBegin
      write FOnExecuteCommandBegin;
    property OnExecuteCommandEnd: TExecuteCommandEndEvent read FOnExecuteCommandEnd
      write FOnExecuteCommandEnd;
    property OnPreviousCommand: TPreviousCommandEvent read FOnPreviousCommand
      write FOnPreviousCommand;
  end;

  TThreadExecuteCommand = class(TThread)
  private
    FCS: TCriticalSection;
    FEIndex: integer;
    FOperations: TOperations;

    procedure RunApplication(Operation: TORunApplication; OText: string);
    procedure PressKeyboard(Operation: TOPressKeyboard; OText: string);
  protected
    procedure Execute; override;
  public
    constructor Create(CriticalSection: TCriticalSection; EIndex: integer;
      Operations: TOperations); overload;
    destructor Destroy; override;
  end;

  TObjectRemoteCommand = class
    FEIndex: integer;
    FCommand: string;
    FState: TExecuteCommandState;
    FIcon: TIcon;
  public
    constructor Create(EIndex: integer; Command: string);
    destructor Destroy;

    property EIndex: integer read FEIndex;
    property Command: string read FCommand write FCommand;
    property State: TExecuteCommandState read FState write FState;
    property Icon: TIcon read FIcon write FIcon;
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

procedure TExecuteCommand.DoExecuteCommandBegin(EIndex: integer; RCommand: TRemoteCommand;
  Operations: TOperations; RepeatPrevious: boolean);
begin
  if Assigned(FOnExecuteCommandBegin) then
    FOnExecuteCommandBegin(EIndex, RCommand, LineOperations(Operations), RepeatPrevious);
end;

procedure TExecuteCommand.DoExecuteCommandEnd(EIndex: integer);
begin
  if Assigned(FOnExecuteCommandEnd) then
    FOnExecuteCommandEnd(EIndex);
end;

procedure TExecuteCommand.DoPreviousCommand(Operations: string);
begin
  if Assigned(FOnPreviousCommand) then
    FOnPreviousCommand(Operations);
end;

procedure TExecuteCommand.Execute(RCommand: TRemoteCommand; RepeatPrevious: boolean = false);
var
  EIndex: integer;
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
    ThreadExecute.OnTerminate := onThreadTerminate;
    ThreadExecute.FreeOnTerminate := True;
    ThreadExecute.Priority := tpLower;
    ThreadExecute.Resume;

    DoExecuteCommandBegin(FEIndex, RCommand, Operations, RepeatPrevious);
  end;

end;

procedure TExecuteCommand.onThreadTerminate(Sender: TObject);
begin
  DoExecuteCommandEnd(TThreadExecuteCommand(Sender).FEIndex);
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

function TExecuteCommand.LineOperations(Operations: TOperations): string;
var
  i: integer;

  function OperationLine(O: TOperation): string;
  begin
    Result := inttostr(O.OSort) + ': ' + O.Operation;
    if O.OWait > 0 then
      Result := Result + ' (' + floattostr(O.OWait / 1000) + ' c.)'
  end;

begin
  if Length(Operations) > 0 then
  begin
    Result := OperationLine(Operations[0]);
    for i := 1 to Length(Operations) - 1 do
      Result := Result + #13#10 + OperationLine(Operations[i]);
  end;
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

procedure TThreadExecuteCommand.Execute;
var
  i: integer;
begin
  FCS.Enter;
  try
    for i := 0 to Length(FOperations) - 1 do
    begin

      // задержка перед выполнением
      if FOperations[i].OWait > 0 then
        sleep(FOperations[i].OWait);

      case FOperations[i].OType of
        opApplication:
          RunApplication(FOperations[i].RunApplication, FOperations[i].Operation);
        opKyeboard:
          PressKeyboard(FOperations[i].PressKeyboard, FOperations[i].Operation);
      end;
    end;
  finally
    if Assigned(FCS) then
      FCS.Leave;
  end;
end;

procedure TThreadExecuteCommand.PressKeyboard(Operation: TOPressKeyboard; OText: string);
var
  i, len: integer;
  KeyInputs: array of TInput;
  FileName: string;

  procedure keyDown(Key: integer);
  begin
    if Key <> 0 then
    begin
      SetLength(KeyInputs, Length(KeyInputs) + 1);
      KeyInputs[Length(KeyInputs) - 1].Itype := INPUT_KEYBOARD;
      KeyInputs[Length(KeyInputs) - 1].ki.wVk := Key;
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

  SendInput(Length(KeyInputs), KeyInputs[0], SizeOf(TInput));
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

constructor TObjectRemoteCommand.Create(EIndex: integer; Command: string);
begin
  Self.FEIndex := EIndex;
  Self.FCommand := Command;
  Self.FState := ecBegin;
  Self.FIcon := TIcon.Create();
end;

destructor TObjectRemoteCommand.Destroy;
begin
  Self.FIcon.Free;
end;

end.
