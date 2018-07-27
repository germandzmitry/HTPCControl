program HTPCControl;

uses
  Vcl.Forms,
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
  uControlCommand in 'Forms\uControlCommand.pas' {frmControlCommand},
  uAllCommand in 'Forms\uAllCommand.pas' {frmAllCommand},
  uExecuteCommand in 'Units\uExecuteCommand.pas',
  MMDevApi in 'Units\MMDevApi.pas',
  uSendComPort in 'Forms\uSendComPort.pas' {frmSendComPort};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'HTPC Control';
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
