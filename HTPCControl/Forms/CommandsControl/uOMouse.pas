unit uOMouse;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellApi, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, uDatabase,
  uLine;

type
  TmoType = (moAdd, moEdit);

type
  TfrmOMouse = class(TForm)
    btnSave: TButton;
    btnCancel: TButton;
    pTop: TPanel;
    lPSort: TLabel;
    lForApplication: TLabel;
    sbtnForApplication: TSpeedButton;
    lWait: TLabel;
    lWaitSecond: TLabel;
    edPSort: TEdit;
    udPSort: TUpDown;
    edForApplication: TEdit;
    edWait: TEdit;
    udWait: TUpDown;
    pMouse: TPanel;
    edX: TEdit;
    edY: TEdit;
    lEvent: TLabel;
    lX: TLabel;
    lY: TLabel;
    cbEvent: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure udWaitChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer;
      Direction: TUpDownDirection);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sbtnForApplicationClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FLineTop: TLine;
    FLineBottom: TLine;
    FmoType: TmoType;
    FID: Integer;
    FCommand: string;
  public
    { Public declarations }
    property moType: TmoType read FmoType write FmoType;
    property ID: Integer write FID;
    property Command: string write FCommand;
  end;

var
  frmOMouse: TfrmOMouse;

implementation

{$R *.dfm}

uses uMain, uLanguage, uIcon;

procedure TfrmOMouse.FormCreate(Sender: TObject);
var
  i: Integer;
  Icon: TIcon;
  MouseEvents: TMouseEvents;
begin

  // чистим контролы
  for i := 0 to self.ComponentCount - 1 do
  begin
    // Label
    if self.Components[i] is TLabel then
      TLabel(self.Components[i]).Caption := '';
    // Edit
    if self.Components[i] is TEdit then
    begin
      TEdit(self.Components[i]).Text := '';
      // TEdit(self.Components[i]).TabStop := False;
      // TEdit(self.Components[i]).ReadOnly := True;
    end;
    // Button
    if self.Components[i] is TButton then
      TButton(self.Components[i]).Caption := '';
    // Panel
    if self.Components[i] is TPanel then
      TPanel(self.Components[i]).Caption := '';
  end;

  FLineTop := TLine.Create(pTop, alBottom, clBlack, clBlack);
  FLineBottom := TLine.Create(pMouse, alBottom, clBlack, clBlack);

  UpdateLanguage(self, lngRus);

  Icon := TIcon.Create;
  try
    StockIcon(SIID_FOLDER, Icon);
    sbtnForApplication.Glyph.Width := Icon.Width;
    sbtnForApplication.Glyph.Height := Icon.Height;
    sbtnForApplication.Glyph.Canvas.Draw(0, 0, Icon);
    sbtnForApplication.Flat := True;
  finally
    Icon.Free;
  end;

  MouseEvents := Main.DataBase.getMouseEvents;

  cbEvent.Items.BeginUpdate;
  try
    cbEvent.Items.Clear;
    for i := 0 to length(MouseEvents) - 1 do
      cbEvent.Items.AddObject(MouseEvents[i].Desc, TObject(MouseEvents[i].Event));
  finally
    cbEvent.Items.EndUpdate;
  end;

end;

procedure TfrmOMouse.FormShow(Sender: TObject);
begin
  //
end;

procedure TfrmOMouse.FormDestroy(Sender: TObject);
begin
  FLineTop.Free;
  FLineBottom.Free;
end;

procedure TfrmOMouse.btnSaveClick(Sender: TObject);
begin
  try
    case FmoType of
      moAdd:
        Main.DataBase.CreateMouse(FCommand, udPSort.Position, udWait.Position,
          Integer(cbEvent.Items.Objects[cbEvent.ItemIndex]), strtoint(edX.Text), strtoint(edY.Text),
          0, edForApplication.Text);
      moEdit:
        Main.DataBase.UpdateMouse(FID, udPSort.Position, udWait.Position,
          Integer(cbEvent.Items.Objects[cbEvent.ItemIndex]), strtoint(edX.Text), strtoint(edY.Text),
          0, edForApplication.Text);
    end;

    self.ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmOMouse.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmOMouse.sbtnForApplicationClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(self);
  try
    OpenDialog.Filter := 'Приложении|*.exe';
    if FileExists(edForApplication.Text) then
      OpenDialog.InitialDir := ExtractFileDir(edForApplication.Text)
    else
      OpenDialog.InitialDir := ExtractFileDir(Application.ExeName);

    if (OpenDialog.Execute) and (FileExists(OpenDialog.FileName)) then
      edForApplication.Text := OpenDialog.FileName;
  finally
    OpenDialog.Free;
  end;
end;

procedure TfrmOMouse.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 27 then
    close;
end;

procedure TfrmOMouse.udWaitChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer;
  Direction: TUpDownDirection);
begin
  if (NewValue < TUpDown(Sender).Min) or (NewValue > TUpDown(Sender).Max) then
    exit;

  lWaitSecond.Caption := Format(GetLanguageText(self.Name, 'lWaitSecond', lngRus),
    [FloatToStr(NewValue / 1000)]);
end;

end.
