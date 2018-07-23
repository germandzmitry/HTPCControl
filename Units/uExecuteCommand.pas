unit uExecuteCommand;

interface

uses Winapi.Windows, System.SysUtils, uDataBase, uLanguage;

type

  TecType = (ecKyeboard, ecApplication);

  TExecuteCommandEvent = procedure(Command, Operation: string; ECType: TecType;
    RepeatPreview: boolean) of object;

type
  TExecuteCommand = class
    procedure Execute(RCommand: TRemoteCommand; RepeatPreview: boolean = false);
  private
    FDB: TDataBase;
    FPrevRCommand: PRemoteCommand;

    FOnExecuteCommand: TExecuteCommandEvent;

    procedure RunApplication(ECommand: TECommand); overload;
    procedure RunApplication(Command, Operation, FileName: string); overload;

    procedure PressKeyboard(ECommand: TECommand; RepeatPreview: boolean = false); overload;

    procedure DoExecuteCommand(Command, Operation: string; ECType: TecType;
      RepeatPreview: boolean); dynamic;

  public
    constructor Create(DB: TDataBase); overload;
    destructor Destroy; override;

    property OnExecuteCommand: TExecuteCommandEvent read FOnExecuteCommand write FOnExecuteCommand;
  end;

implementation

{ TExecuteCommand }

constructor TExecuteCommand.Create(DB: TDataBase);
begin
  FDB := DB;
  FPrevRCommand := nil;
end;

destructor TExecuteCommand.Destroy;
begin
  if (FPrevRCommand <> nil) then
  begin
    Dispatch(FPrevRCommand);
    FPrevRCommand := nil;
  end;

  inherited;
end;

procedure TExecuteCommand.Execute(RCommand: TRemoteCommand; RepeatPreview: boolean = false);
var
  cmd: TECommands;
  i: integer;
  g: TRemoteCommand;
begin

  // Повтор предыдущей команды
  if RCommand.Rep and (FPrevRCommand <> nil) then
  begin
    Execute(TRemoteCommand(FPrevRCommand^), true);
    exit;
  end;

  cmd := FDB.getExecuteCommands(RCommand.Command);

  if Length(cmd) > 0 then
  begin

    if cmd[0].Rep then
    begin
      if FPrevRCommand = nil then
        New(FPrevRCommand);
      FPrevRCommand^ := cmd[0].Command;
    end
    else
    begin
      if FPrevRCommand <> nil then
      begin
        Dispatch(FPrevRCommand);
        FPrevRCommand := nil;
      end;
    end;

    for i := 0 to Length(cmd) - 1 do
    begin
      if cmd[i].CType = tcApplication then
        RunApplication(cmd[i])
      else if cmd[i].CType = tcKeyboard then
        PressKeyboard(cmd[i])
      else
        raise Exception.Create(Format(GetLanguageMsg('msgExecuteCommandTypeNotFound', lngRus),
          [cmd[i].CType]));
    end;
  end;

end;

procedure TExecuteCommand.RunApplication(ECommand: TECommand);
// var
// LECommand: TECommand;
begin
  // LECommand := TECommand(ECommand);
  RunApplication(ECommand.Command.Command, ECommand.Operation, ECommand.Application);
end;

procedure TExecuteCommand.RunApplication(Command, Operation, FileName: string);
var
  Rlst: LongBool;
  Application: PWideChar;
  StartUpInfo: TStartUpInfo;
  ProcessInfo: TProcessInformation;
begin
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

      DoExecuteCommand(Command, Operation, ecApplication, false);
    end
    else
      raise Exception.Create(Format(GetLanguageMsg('msgExecuteCommandRunApplication', lngRus),
        [SysErrorMessage(GetLastError)]));
  end;

end;

procedure TExecuteCommand.PressKeyboard(ECommand: TECommand; RepeatPreview: boolean = false);
begin
  try
    // Кнопка 1
    if ECommand.Key1 <> 0 then
      keybd_event(ECommand.Key1, 0, 0, 0); // Нажатие кнопки.
    // Кнопка 2
    if ECommand.Key2 <> 0 then
      keybd_event(ECommand.Key2, 0, 0, 0); // Нажатие кнопки.

    DoExecuteCommand(ECommand.Command.Command, ECommand.Operation, ecKyeboard, RepeatPreview);
  finally
    keybd_event(ECommand.Key2, 0, KEYEVENTF_KEYUP, 0); // Отпускание кнопки.
    keybd_event(ECommand.Key1, 0, KEYEVENTF_KEYUP, 0); // Отпускание кнопки.
  end;
end;

procedure TExecuteCommand.DoExecuteCommand(Command, Operation: string; ECType: TecType;
  RepeatPreview: boolean);
begin
  if Assigned(FOnExecuteCommand) then
    FOnExecuteCommand(Command, Operation, ECType, RepeatPreview);
end;

end.
