unit uExecuteCommand;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, uDataBase, uLanguage,
  uTypes, uShellApplication, SyncObjs;

type
  TExecuteCommandEvent = procedure(RCommand: TRemoteCommand; Operations: TOperations;
    RepeatPrevious: boolean) of object;
  TRunApplicationEvent = procedure(Operation: TORunApplication; OText: string) of object;
  TPressKeyboardEvent = procedure(Operation: TOPressKeyboard; OText: string) of object;

type
  TExecuteCommand = class
    procedure Execute(RCommand: TRemoteCommand; RepeatPrevious: boolean = false);
  private
    FDB: TDataBase;
    FCS: TCriticalSection;
    FPrevRCommand: TRemoteCommand;

    FOnRunApplication: TRunApplicationEvent;
    FOnPressKeyboard: TPressKeyboardEvent;
    FOnExecuteCommand: TExecuteCommandEvent;

    procedure RunApplication(Operation: TORunApplication; OText: string);
    procedure PressKeyboard(Operation: TOPressKeyboard; OText: string);

    procedure DoExecuteCommand(RCommand: TRemoteCommand; Operations: TOperations;
      RepeatPrevious: boolean); dynamic;
    procedure DoRunApplication(Operation: TORunApplication; OText: string); dynamic;
    procedure DoPressKeyboard(Operation: TOPressKeyboard; OText: string); dynamic;

  public
    constructor Create(DB: TDataBase); overload;
    destructor Destroy; override;

    property OnRunApplication: TRunApplicationEvent read FOnRunApplication write FOnRunApplication;
    property OnPressKeyboard: TPressKeyboardEvent read FOnPressKeyboard write FOnPressKeyboard;
    property OnExecuteCommand: TExecuteCommandEvent read FOnExecuteCommand write FOnExecuteCommand;
  end;

  TThreadExecuteCommand = class(TThread)
  private
    FCS: TCriticalSection;
    FOperations: TOperations;

    procedure RunApplication(Operation: TORunApplication; OText: string);
    procedure PressKeyboard(Operation: TOPressKeyboard; OText: string);
  protected
    procedure Execute; override;
  public
    constructor Create(CriticalSection: TCriticalSection; Operations: TOperations); overload;
    destructor Destroy; override;
  end;

implementation

{ TExecuteCommand }

constructor TExecuteCommand.Create(DB: TDataBase);
begin
  FDB := DB;
  FCS := TCriticalSection.Create;
end;

destructor TExecuteCommand.Destroy;
begin
  FCS.Free;
  inherited;
end;

procedure TExecuteCommand.DoExecuteCommand(RCommand: TRemoteCommand; Operations: TOperations;
  RepeatPrevious: boolean);
begin
  if Assigned(FOnExecuteCommand) then
    FOnExecuteCommand(RCommand, Operations, RepeatPrevious);
end;

procedure TExecuteCommand.DoPressKeyboard(Operation: TOPressKeyboard; OText: string);
begin
  if Assigned(FOnPressKeyboard) then
    FOnPressKeyboard(Operation, OText);
end;

procedure TExecuteCommand.DoRunApplication(Operation: TORunApplication; OText: string);
begin
  if Assigned(FOnRunApplication) then
    FOnRunApplication(Operation, OText);
end;

procedure TExecuteCommand.Execute(RCommand: TRemoteCommand; RepeatPrevious: boolean = false);
var
  i: integer;
  FileName: string;
  Operations: TOperations;
  ThreadExecute: TThreadExecuteCommand;
begin

  // Повтор предыдущей команды
  if RCommand.RepeatPrevious and FPrevRCommand.LongPress then
  begin
    Execute(FPrevRCommand, True);
    exit;
  end;

  FPrevRCommand := RCommand;

  Operations := FDB.getOperation(RCommand.Command);

  if Length(Operations) > 0 then
  begin

    ThreadExecute := TThreadExecuteCommand.Create(FCS, Operations);
    ThreadExecute.FreeOnTerminate := True;
    ThreadExecute.Priority := tpLower;
    ThreadExecute.Resume;

    // FileName := uShellApplication.GetExePath(GetForegroundWindow);

    // for i := 0 to Length(Operations) - 1 do
    // begin
    //
    // // задержка перед выполнением
    // if Operations[i].OWait > 0 then
    // sleep(Operations[i].OWait);
    //
    // case Operations[i].OType of
    // opApplication:
    // RunApplication(Operations[i].RunApplication, Operations[i].Operation);
    // opKyeboard:
    // PressKeyboard(Operations[i].PressKeyboard, Operations[i].Operation);
    // else
    // raise Exception.Create(GetLanguageMsg('msgExecuteCommandTypeNotFound', lngRus));
    // end;
    // end;

    DoExecuteCommand(RCommand, Operations, RepeatPrevious);
  end;

end;

procedure TExecuteCommand.RunApplication(Operation: TORunApplication; OText: string);
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

      DoRunApplication(Operation, OText);
    end
    else
      raise Exception.Create(Format(GetLanguageMsg('msgExecuteCommandRunApplication', lngRus),
        [SysErrorMessage(GetLastError)]));
  end;
end;

procedure TExecuteCommand.PressKeyboard(Operation: TOPressKeyboard; OText: string);
begin
  try
    // Кнопка 1
    if Operation.Key1 <> 0 then
      keybd_event(Operation.Key1, 0, 0, 0); // Нажатие кнопки.
    // Кнопка 2
    if Operation.Key2 <> 0 then
      keybd_event(Operation.Key2, 0, 0, 0); // Нажатие кнопки.
    // Кнопка 3
    if Operation.Key3 <> 0 then
      keybd_event(Operation.Key3, 0, 0, 0); // Нажатие кнопки.

    DoPressKeyboard(Operation, OText);
  finally
    keybd_event(Operation.Key3, 0, KEYEVENTF_KEYUP, 0); // Отпускание кнопки.
    keybd_event(Operation.Key2, 0, KEYEVENTF_KEYUP, 0); // Отпускание кнопки.
    keybd_event(Operation.Key1, 0, KEYEVENTF_KEYUP, 0); // Отпускание кнопки.
  end;
end;

{ TThreadExecuteCommand }

constructor TThreadExecuteCommand.Create(CriticalSection: TCriticalSection;
  Operations: TOperations);
begin
  Create(True);
  FCS := CriticalSection;
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
    FCS.Leave;
  end;
end;

procedure TThreadExecuteCommand.PressKeyboard(Operation: TOPressKeyboard; OText: string);
var
  i, len: integer;
  KeyInputs: array of TInput;

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

end.
