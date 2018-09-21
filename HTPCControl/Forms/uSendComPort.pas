unit uSendComPort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.UITypes;

type
  TfrmSendComPort = class(TForm)
    eSendText: TEdit;
    btnSend: TButton;
    mSentText: TMemo;
    cbSendTextEnd: TComboBox;
    btnClose: TButton;
    cbClearSendText: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
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

procedure TfrmSendComPort.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmSendComPort.btnSendClick(Sender: TObject);
var
  send: string;
begin
  if Assigned(Main.Arduino) and Main.Arduino.Connected then
    try
      send := eSendText.Text;
      case cbSendTextEnd.ItemIndex of
        0:
          send := send;
        1:
          send := send + #10;
        2:
          send := send + #13;
        3:
          send := send + #13#10;
      end;

      Main.Arduino.WriteStr(send);
      mSentText.Lines.Add(eSendText.Text);

      if cbClearSendText.Checked then
        eSendText.Text := '';
    except
      on E: Exception do
        MessageDlg(E.Message, mtError, [mbOK], 0);
    end
end;

procedure TfrmSendComPort.FormCreate(Sender: TObject);
begin
  // Constraints.MinHeight := Height;
  // Constraints.MaxHeight := Height;
  eSendText.Text := '';
  mSentText.Lines.Clear;
  cbSendTextEnd.ItemIndex := 0;

  UpdateLanguage(self, lngRus);
end;

end.
