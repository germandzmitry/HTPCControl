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
  uEventApplication in 'Units\uEventApplication.pas',
  uTypes in 'Units\uTypes.pas',
  uSuperObject in 'Customs\uSuperObject.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
