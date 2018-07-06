program HTPCControl;

uses
  Vcl.Forms,
  uMain in 'Forms\uMain.pas' {Main},
  uComPort in 'Units\uComPort.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
