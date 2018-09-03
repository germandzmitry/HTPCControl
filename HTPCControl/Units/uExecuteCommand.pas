unit uExecuteCommand;

interface

uses Winapi.Windows, System.SysUtils, uDataBase, uLanguage, uTypes;

type

  TExecuteCommandEvent = procedure(ECommand: TECommand; ECType: TopType; RepeatPreview: boolean)
    of object;
  TSetPreviewCommandEvent = procedure(RCommand: PRemoteCommand; Opearion: string) of object;

type
  TExecuteCommand = class
    procedure Execute(RCommand: TRemoteCommand; RepeatPreview: boolean = false);
  private
    FDB: TDataBase;
    FPrevRCommand: PRemoteCommand;

    FOnExecuteCommand: TExecuteCommandEvent;
    FOnSetPreviewCommand: TSetPreviewCommandEvent;

    procedure RunApplication(ECommand: TECommand); overload;
    procedure PressKeyboard(ECommand: TECommand; RepeatPreview: boolean = false); overload;

    procedure DoExecuteCommand(ECommand: TECommand; ECType: TopType;
      RepeatPreview: boolean); dynamic;
    procedure DoSetPreviewCommand(RCommand: PRemoteCommand; Opearion: string); dynamic;

  public
    constructor Create(DB: TDataBase); overload;
    destructor Destroy; override;

    property OnExecuteCommand: TExecuteCommandEvent read FOnExecuteCommand write FOnExecuteCommand;
    property OnSetPreviewCommand: TSetPreviewCommandEvent read FOnSetPreviewCommand
      write FOnSetPreviewCommand;

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
// var
// ECommands: TECommands;
// i: integer;
// g: TRemoteCommand;
// LOperation: string;
begin

  // // Повтор предыдущей команды
  // if RCommand.RepeatPreview and (FPrevRCommand <> nil) then
  // begin
  // Execute(TRemoteCommand(FPrevRCommand^), true);
  // exit;
  // end;
  //
  // ECommands := FDB.getExecuteCommands(RCommand.Command);
  //
  // if Length(ECommands) > 0 then
  // begin
  //
  // if ECommands[0].Rep then
  // begin
  // if FPrevRCommand = nil then
  // New(FPrevRCommand);
  // FPrevRCommand^ := ECommands[0].Command;
  // LOperation := ECommands[0].Operation;
  // end
  // else
  // begin
  // if FPrevRCommand <> nil then
  // begin
  // Dispose(FPrevRCommand);
  // FPrevRCommand := nil;
  // end;
  // end;
  // DoSetPreviewCommand(FPrevRCommand, LOperation);
  //
  // for i := 0 to Length(ECommands) - 1 do
  // if ECommands[i].ECType = ecApplication then
  // RunApplication(ECommands[i])
  // else if ECommands[i].ECType = ecKyeboard then
  // PressKeyboard(ECommands[i], RepeatPreview)
  // else
  // raise Exception.Create(GetLanguageMsg('msgExecuteCommandTypeNotFound', lngRus));
  //
  // end;

end;

procedure TExecuteCommand.RunApplication(ECommand: TECommand);
// RunApplication(ECommand.Command.Command, ECommand.Operation, ECommand.Application);
var
  Rlst: LongBool;
  Application: PWideChar;
  StartUpInfo: TStartUpInfo;
  ProcessInfo: TProcessInformation;
  FileName: string;
begin
  FileName := ECommand.Operation;
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

      DoExecuteCommand(ECommand, opApplication, false);
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

    DoExecuteCommand(ECommand, opKyeboard, RepeatPreview);
  finally
    keybd_event(ECommand.Key2, 0, KEYEVENTF_KEYUP, 0); // Отпускание кнопки.
    keybd_event(ECommand.Key1, 0, KEYEVENTF_KEYUP, 0); // Отпускание кнопки.
  end;
end;

procedure TExecuteCommand.DoExecuteCommand(ECommand: TECommand; ECType: TopType;
  RepeatPreview: boolean);
begin
  if Assigned(FOnExecuteCommand) then
    FOnExecuteCommand(ECommand, ECType, RepeatPreview);
end;

procedure TExecuteCommand.DoSetPreviewCommand(RCommand: PRemoteCommand; Opearion: string);
begin
  if Assigned(FOnSetPreviewCommand) then
    FOnSetPreviewCommand(RCommand, Opearion);
end;

end.
