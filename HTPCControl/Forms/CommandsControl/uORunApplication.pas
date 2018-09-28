unit uORunApplication;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, uLine, Winapi.Shellapi,
  Vcl.ComCtrls, Vcl.Buttons, System.UITypes;

type
  TraType = (raAdd, raEdit);

type
  TfrmORunApplication = class(TForm)
    edApplicationFileName: TEdit;
    lApplicationFileName: TLabel;
    pImageApplication: TPanel;
    ImageApplication: TImage;
    btnCancel: TButton;
    btnSave: TButton;
    pApplication: TPanel;
    pTop: TPanel;
    lPSort: TLabel;
    lWait: TLabel;
    lWaitSecond: TLabel;
    edPSort: TEdit;
    udPSort: TUpDown;
    edWait: TEdit;
    udWait: TUpDown;
    sbtnApplicationFileName: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure udWaitChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer;
      Direction: TUpDownDirection);
    procedure sbtnApplicationFileNameClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }

    FLineTop: TLine;
    FLineBottom: TLine;
    FraType: TraType;
    FID: Integer;
    FCommand: string;
  public
    { Public declarations }
    property raType: TraType read FraType write FraType;
    property Command: string write FCommand;
    property ID: Integer write FID;
  end;

var
  frmORunApplication: TfrmORunApplication;

implementation

{$R *.dfm}

uses uLanguage, uMain, uIcon;

procedure TfrmORunApplication.FormCreate(Sender: TObject);
var
  Icon: TIcon;
begin
  pTop.Caption := '';
  pApplication.Caption := '';
  pImageApplication.Caption := '';
  edApplicationFileName.Text := '';

  FLineTop := TLine.Create(pTop, alBottom, clBlack, clBlack);
  FLineBottom := TLine.Create(pApplication, alBottom, clBlack, clBlack);

  UpdateLanguage(self, lngRus);

  Icon := TIcon.Create;
  try
    StockIcon(SIID_FOLDER, Icon);
    sbtnApplicationFileName.Glyph.Width := Icon.Width;
    sbtnApplicationFileName.Glyph.Height := Icon.Height;
    sbtnApplicationFileName.Glyph.Canvas.Draw(0, 0, Icon);
    sbtnApplicationFileName.Flat := True;
  finally
    Icon.Free;
  end;
end;

procedure TfrmORunApplication.FormShow(Sender: TObject);
var
  Icon: TIcon;
begin
  if FraType = raEdit then
  begin
    Icon := TIcon.Create;
    try
      ApplicationIcon(edApplicationFileName.Text, Icon);
      ImageApplication.Picture.Icon := Icon;
    finally
      Icon.Free;
    end;
  end;
end;

procedure TfrmORunApplication.sbtnApplicationFileNameClick(Sender: TObject);
var
  Icon: TIcon;
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
      Icon := TIcon.Create;
      try
        ApplicationIcon(edApplicationFileName.Text, Icon);
        ImageApplication.Picture.Icon := Icon;
      finally
        Icon.Free;
      end;
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TfrmORunApplication.udWaitChangingEx(Sender: TObject; var AllowChange: Boolean;
  NewValue: Integer; Direction: TUpDownDirection);
begin
  if (NewValue < TUpDown(Sender).Min) or (NewValue > TUpDown(Sender).Max) then
    exit;

  lWaitSecond.Caption := Format(GetLanguageText(self.Name, 'lWaitSecond', lngRus),
    [FloatToStr(NewValue / 1000)]);
end;

procedure TfrmORunApplication.FormDestroy(Sender: TObject);
begin
  FLineTop.Free;
  FLineBottom.Free;
end;

procedure TfrmORunApplication.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 27 then
    close;
end;

procedure TfrmORunApplication.btnSaveClick(Sender: TObject);
begin
  try
    case FraType of
      raAdd:
        Main.DataBase.CreateRunApplication(FCommand, udPSort.Position, udWait.Position,
          edApplicationFileName.Text);
      raEdit:
        Main.DataBase.UpdateRunApplication(FID, udPSort.Position, udWait.Position,
          edApplicationFileName.Text);
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

end.
