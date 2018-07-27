unit uSendComPort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmSendComPort = class(TForm)
    eSendText: TEdit;
    btnSend: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSendComPort: TfrmSendComPort;

implementation

{$R *.dfm}

uses uMain, uLanguage, uTypes;

procedure TfrmSendComPort.btnSendClick(Sender: TObject);
begin
  if Assigned(Main.Arduino) and Main.Arduino.Connected then
    try
      Main.Arduino.WriteStr(eSendText.Text + #13);
      Close;
    except
      on E: Exception do
        MessageDlg(E.Message, mtWarning, [mbOK], 0);
    end
end;

procedure TfrmSendComPort.FormCreate(Sender: TObject);
begin
  Constraints.MinHeight := Height;
  Constraints.MaxHeight := Height;
  eSendText.Text := '';

  UpdateLanguage(self, lngRus);
end;

end.
