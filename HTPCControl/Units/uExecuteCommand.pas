unit uExecuteCommand;

interface

uses Winapi.Windows, System.SysUtils, uDataBase, uLanguage, uTypes, uShellApplication;

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
    FPrevRCommand: TRemoteCommand;

    FOnRunApplication: TRunApplicationEvent;
    FOnPressKeyboard: TPressKeyboardEvent;
    FOnExecuteCommand: TExecuteCommandEvent;

    procedure RunApplication(Operation: TORunApplication; OText: string); overload;
    procedure PressKeyboard(Operation: TOPressKeyboard; OText: string); overload;

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

implementation

{ TExecuteCommand }

constructor TExecuteCommand.Create(DB: TDataBase);
begin
  FDB := DB;
end;

destructor TExecuteCommand.Destroy;
begin
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
begin

  // Повтор предыдущей команды
  if RCommand.RepeatPrevious and FPrevRCommand.LongPress then
  begin
    Execute(FPrevRCommand, true);
    exit;
  end;

  FPrevRCommand := RCommand;

  Operations := FDB.getOperation(RCommand.Command);

  if Length(Operations) > 0 then
  begin

    // FileName := uShellApplication.GetExePath(GetForegroundWindow);

    for i := 0 to Length(Operations) - 1 do
    begin
      sleep(Operations[i].OWait);
      case Operations[i].OType of
        opApplication:
          RunApplication(Operations[i].RunApplication, Operations[i].Operation);
        opKyeboard:
          PressKeyboard(Operations[i].PressKeyboard, Operations[i].Operation);
      else
        raise Exception.Create(GetLanguageMsg('msgExecuteCommandTypeNotFound', lngRus));
      end;
    end;

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

end.
