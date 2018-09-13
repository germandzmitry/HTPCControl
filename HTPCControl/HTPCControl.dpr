program HTPCControl;

uses
  Vcl.Forms,
  Windows,
  uMain in 'Forms\uMain.pas' {Main},
  uComPort in 'Units\uComPort.pas',
  uCustomPageControl in 'Customs\uCustomPageControl.pas',
  uAbout in 'Forms\uAbout.pas' {About},
  uCustomActionDrawDisableImage in 'Customs\uCustomActionDrawDisableImage.pas',
  uSettings in 'Forms\uSettings.pas' {Settings},
  uLanguage in 'Units\uLanguage.pas',
  uShellApplication in 'Units\uShellApplication.pas',
  uTypes in 'Units\uTypes.pas',
  uSuperObject in 'Customs\uSuperObject.pas',
  uDataBase in 'Units\uDataBase.pas',
  uEventKodi in 'Units\uEventKodi.pas',
  uRCommandsControl in 'Forms\CommandsControl\uRCommandsControl.pas' {frmRCommandsControl},
  uExecuteCommand in 'Units\uExecuteCommand.pas',
  MMDevApi in 'Units\MMDevApi.pas',
  uSendComPort in 'Forms\uSendComPort.pas' {frmSendComPort},
  Vcl.Themes,
  Vcl.Styles,
  uRCommand in 'Forms\CommandsControl\uRCommand.pas' {frmRCommand},
  uLine in 'Customs\uLine.pas',
  uORunApplication in 'Forms\CommandsControl\uORunApplication.pas' {frmORunApplication},
  uOPressKeyboard in 'Forms\CommandsControl\uOPressKeyboard.pas' {frmOPressKeyboard},
  uCustomListBox in 'Customs\uCustomListBox.pas',
  uFastRCommand in 'Forms\CommandsControl\uFastRCommand.pas' {frmFastRCommand},
  uIcon in 'Units\uIcon.pas';

{$R *.res}

var
  MutexHandle: THandle;
  MainHandle: HWND;

const
  MutexName = 'HTPCControl';

begin

  MutexHandle := OpenMutex(MUTEX_ALL_ACCESS, false, MutexName);
  if MutexHandle <> 0 then
  begin
    MainHandle := FindWindow('TMain', nil);
    ShowWindow(MainHandle, SW_RESTORE);
    Windows.SetForegroundWindow(MainHandle);
    exit;
  end;

  MutexHandle := CreateMutex(nil, false, MutexName); // Создание Mutex

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'HTPC Control';
  Application.CreateForm(TMain, Main);
  Application.Run;

  CloseHandle(MutexHandle); // Уничтожаем Mutex

end.
