unit uRCommand;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uLine, Vcl.ExtCtrls;

type
  TrcType = (rcAdd, rcEdit);

type
  TfrmRCommand = class(TForm)
    btnCancel: TButton;
    btnSave: TButton;
    edCommand: TEdit;
    edDescription: TEdit;
    cbRepeatPrevious: TCheckBox;
    lCommand: TLabel;
    lDescription: TLabel;
    pTop: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FLine: TLine;
    FRCType: TrcType;
  public
    { Public declarations }
    property rcType: TrcType read FRCType write FRCType;
  end;

var
  frmRCommand: TfrmRCommand;

implementation

{$R *.dfm}

uses uLanguage, uMain; // uTypes, uControlCommand;

procedure TfrmRCommand.FormCreate(Sender: TObject);
begin
  edCommand.Text := '';
  edDescription.Text := '';
  cbRepeatPrevious.Checked := false;
  pTop.Caption := '';

  FLine := TLine.Create(pTop, alBottom, clWhite, clHotLight);

  UpdateLanguage(self, lngRus);
end;

procedure TfrmRCommand.FormDestroy(Sender: TObject);
begin
  FLine.Free;
end;

procedure TfrmRCommand.FormShow(Sender: TObject);
begin
  case FRCType of
    rcAdd:
      begin
        edCommand.ReadOnly := false;
      end;
    rcEdit:
      begin
        edCommand.ReadOnly := true;
      end;
  end;
end;

procedure TfrmRCommand.btnSaveClick(Sender: TObject);
var
  RCommandExists: boolean;
begin
  try
    if Length(Trim(edCommand.Text)) = 0 then
      raise Exception.CreateFmt(uLanguage.GetLanguageMsg('msgRCCommandEmpty', lngRus),
        [lCommand.Caption]);

    case FRCType of
      rcAdd:
        begin
          Main.DataBase.CreateRemoteCommand(edCommand.Text, edDescription.Text,
            cbRepeatPrevious.Checked, RCommandExists);

          if RCommandExists then
            raise Exception.CreateFmt(uLanguage.GetLanguageMsg('msgRCCommandExists', lngRus),
              [edCommand.Text]);
        end;
      rcEdit:
        begin
          Main.DataBase.UpdateRemoteCommand(edCommand.Text, edDescription.Text,
            cbRepeatPrevious.Checked);
        end;
    end;

    self.ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;

end;

procedure TfrmRCommand.btnCancelClick(Sender: TObject);
begin
  self.Close;
end;

end.
