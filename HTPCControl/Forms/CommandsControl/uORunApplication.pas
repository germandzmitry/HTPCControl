unit uORunApplication;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, uLine, Winapi.Shellapi;

type
  TraType = (raAdd, raEdit);

type
  TfrmORunApplication = class(TForm)
    btnApplicationFileName: TButton;
    edApplicationFileName: TEdit;
    lApplicationFileName: TLabel;
    pImageApplication: TPanel;
    ImageApplication: TImage;
    btnCancel: TButton;
    btnSave: TButton;
    pTop: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnApplicationFileNameClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }

    FLine: TLine;
    FraType: TraType;
    FID: integer;
    FCommand: string;
    procedure LoadIcon(FileName: String; Image: TImage);
  public
    { Public declarations }
    property raType: TraType read FraType write FraType;
    property Command: string write FCommand;
    property ID: integer write FID;
  end;

var
  frmORunApplication: TfrmORunApplication;

implementation

{$R *.dfm}

uses uLanguage, uMain;

procedure TfrmORunApplication.FormCreate(Sender: TObject);
begin
  pTop.Caption := '';
  pImageApplication.Caption := '';
  edApplicationFileName.Text := '';

  FLine := TLine.Create(pTop, alBottom, clWhite, clRed);

  UpdateLanguage(self, lngRus);
end;

procedure TfrmORunApplication.FormShow(Sender: TObject);
begin
  if FraType = raEdit then
    LoadIcon(edApplicationFileName.Text, ImageApplication);
end;

procedure TfrmORunApplication.FormDestroy(Sender: TObject);
begin
  FLine.Free;
end;

procedure TfrmORunApplication.btnApplicationFileNameClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(self);
  try
    OpenDialog.Filter := 'Приложения|*.exe';
    if FileExists(edApplicationFileName.Text) then
      OpenDialog.InitialDir := ExtractFileDir(edApplicationFileName.Text)
    else
      OpenDialog.InitialDir := ExtractFileDir(Application.ExeName);

    if (OpenDialog.Execute) and (FileExists(OpenDialog.FileName)) then
    begin
      edApplicationFileName.Text := OpenDialog.FileName;
      LoadIcon(edApplicationFileName.Text, ImageApplication);
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TfrmORunApplication.btnSaveClick(Sender: TObject);
begin
  try
    case FraType of
      raAdd:
        Main.DataBase.CreateRunApplication(FCommand, edApplicationFileName.Text);
      raEdit:
        Main.DataBase.UpdateRunApplication(FID, edApplicationFileName.Text);
    end;

    self.ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmORunApplication.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmORunApplication.LoadIcon(FileName: String; Image: TImage);
var
  Icon: TIcon;
  FileInfo: SHFILEINFO;
begin
  if FileExists(FileName) then
  begin
    Icon := TIcon.Create;
    try
      SHGetFileInfo(PChar(FileName), 0, FileInfo, SizeOf(FileInfo), SHGFI_ICON);
      Icon.Handle := FileInfo.hIcon;
      Image.Picture.Icon := Icon;
    finally
      Icon.Free;
    end;
  end;
end;

end.
