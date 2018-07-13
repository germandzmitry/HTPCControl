unit uControlCommand;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Winapi.Shellapi, uDataBase;

type
  TControlCommand = class(TForm)
    lCCCommand: TLabel;
    lCCDescription: TLabel;
    edCCCommand: TEdit;
    edCCDescription: TEdit;
    rbCCPressKeyKeyboard: TRadioButton;
    rbCCRunApplication: TRadioButton;
    edCCAppFileName: TEdit;
    lCCAppFileName: TLabel;
    btnCCAppFileName: TButton;
    ImageCCApp: TImage;
    pImageApplication: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
    pClient: TPanel;
    pKeyboard: TPanel;
    rbCCKeyKeyboard: TRadioButton;
    rbCCKeyManual: TRadioButton;
    cbCCKeyRepeat: TCheckBox;
    edCCKeyKeyboard: TEdit;
    lCCKeyKeyboardHelp: TLabel;
    lCCKeyManualKey1: TLabel;
    lCCKeyManualKey2: TLabel;
    lCCKeyManualKey3: TLabel;
    cbCCKeyManualKey1: TComboBox;
    cbCCKeyManualKey2: TComboBox;
    cbCCKeyManualKey3: TComboBox;
    pApplication: TPanel;
    pRepeat: TPanel;
    rbCCRepeat: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure rbCCPressKeyKeyboardClick(Sender: TObject);
    procedure rbCCRunApplicationClick(Sender: TObject);
    procedure btnCCAppFileNameClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure rbCCKeyKeyboardClick(Sender: TObject);
    procedure rbCCKeyManualClick(Sender: TObject);
    procedure edCCKeyKeyboardKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelClick(Sender: TObject);
    procedure edCCKeyKeyboardKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbCCKeyManualKey1Select(Sender: TObject);
    procedure cbCCKeyManualKey2Select(Sender: TObject);
    procedure cbCCKeyManualKey3Select(Sender: TObject);
    procedure rbCCRepeatClick(Sender: TObject);
  private
    { Private declarations }

    FKey1: PKeyKeyboard;
    FKey2: PKeyKeyboard;
    FKey3: PKeyKeyboard;

    procedure LoadIcon(FileName: String; Image: TImage);
  public
    { Public declarations }
  end;

var
  ControlCommand: TControlCommand;

implementation

{$R *.dfm}

uses uMain, uLanguage, uTypes;

procedure TControlCommand.btnCancelClick(Sender: TObject);
begin
  self.Close;
end;

procedure TControlCommand.btnCCAppFileNameClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(self);
  try
    OpenDialog.InitialDir := ExtractFileDir(Application.ExeName);
    OpenDialog.Filter := 'Приложения|*.exe';

    if (OpenDialog.Execute) and (FileExists(OpenDialog.FileName)) then
    begin
      edCCAppFileName.Text := OpenDialog.FileName;
      LoadIcon(edCCAppFileName.Text, ImageCCApp);
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TControlCommand.btnSaveClick(Sender: TObject);
var
  RCommand: TRemoteCommand;
  Key1, Key2, Key3: integer;
begin

  if not Assigned(Main.DataBase) or not Main.DataBase.Connected then
  begin
    MessageDlg(uLanguage.GetLanguageText('ErrorDBNotConnected', lngRus), mtWarning, [mbOK], 0);
    exit;
  end;

  RCommand.Command := edCCCommand.Text;
  RCommand.Desc := edCCDescription.Text;

  // Запуск приложения
  if rbCCRunApplication.Checked then
    try
      if Main.DataBase.CreateRunApplication(RCommand, edCCAppFileName.Text) then
        self.Close;
    except
      on E: Exception do
        MessageDlg(E.Message, mtWarning, [mbOK], 0);
    end;

  // Эмуляция клавиатуры
  if rbCCPressKeyKeyboard.Checked then

    try
      Key1 := 0;
      Key2 := 0;
      Key3 := 0;

      if FKey1 <> nil then
        Key1 := FKey1.Key;
      if FKey2 <> nil then
        Key2 := FKey2.Key;
      if FKey3 <> nil then
        Key3 := FKey3.Key;

      if Main.DataBase.CreatePressKeyKeyboard(RCommand, Key1, Key2, cbCCKeyRepeat.Checked) then
        self.Close;

    except
      on E: Exception do
        MessageDlg(E.Message, mtWarning, [mbOK], 0);
    end;

  // Повтор предыдущей команды
  if rbCCRepeat.Checked then
    try
      Main.DataBase.CreateRemoteCommand(RCommand.Command, RCommand.Desc, rbCCRepeat.Checked);
      self.Close;
    except
      on E: Exception do
        MessageDlg(E.Message, mtWarning, [mbOK], 0);
    end;

end;

procedure TControlCommand.cbCCKeyManualKey1Select(Sender: TObject);
begin
  FKey1 := Main.DataBase.GetKeyboardKey
    (integer(cbCCKeyManualKey1.Items.Objects[cbCCKeyManualKey1.ItemIndex]));
end;

procedure TControlCommand.cbCCKeyManualKey2Select(Sender: TObject);
begin
  FKey2 := Main.DataBase.GetKeyboardKey
    (integer(cbCCKeyManualKey2.Items.Objects[cbCCKeyManualKey2.ItemIndex]));
end;

procedure TControlCommand.cbCCKeyManualKey3Select(Sender: TObject);
begin
  FKey3 := Main.DataBase.GetKeyboardKey
    (integer(cbCCKeyManualKey3.Items.Objects[cbCCKeyManualKey3.ItemIndex]));
end;

procedure TControlCommand.edCCKeyKeyboardKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  btn: string;
  KeyKeyboard: PKeyKeyboard;
begin
  HideCaret(TEdit(Sender).Handle);

  FKey1 := nil;
  FKey2 := nil;
  FKey3 := nil;

  KeyKeyboard := Main.DataBase.GetKeyboardKey(Key);
  if KeyKeyboard <> nil then
    btn := KeyKeyboard.Desc;

  if (ssAlt in Shift) and (btn <> 'Alt') then
  begin
    FKey1 := Main.DataBase.GetKeyboardKey(18);
    FKey2 := KeyKeyboard;
  end
  else if (ssCtrl in Shift) and (btn <> 'Ctrl') then
  begin
    FKey1 := Main.DataBase.GetKeyboardKey(17);
    FKey2 := KeyKeyboard;
  end
  else if (ssShift in Shift) and (btn <> 'Shift') then
  begin
    FKey1 := Main.DataBase.GetKeyboardKey(16);
    FKey2 := KeyKeyboard;
  end
  else
  begin
    FKey1 := KeyKeyboard;
  end;

  // Отмена F10
  if Key = VK_F10 then
    Key := 0;

  // Отмена Alt + F4
  if ((ssAlt in Shift) and (Key = VK_F4)) then
    Key := 0;

  if (ssAlt in Shift) then
    Key := 0;

  if FKey1 <> nil then
    edCCKeyKeyboard.Text := FKey1.Desc;
  if FKey2 <> nil then
    edCCKeyKeyboard.Text := edCCKeyKeyboard.Text + ' + ' + FKey2.Desc;
  if FKey3 <> nil then
    edCCKeyKeyboard.Text := edCCKeyKeyboard.Text + ' + ' + FKey3.Desc;
end;

procedure TControlCommand.edCCKeyKeyboardKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  HideCaret(TEdit(Sender).Handle);
end;

procedure TControlCommand.FormCreate(Sender: TObject);
var
  i: integer;
  Keyboards: TKeyboards;
begin

  // чистим контролы
  for i := 0 to self.ComponentCount - 1 do
  begin
    // Label
    if self.Components[i] is TLabel then
      TLabel(self.Components[i]).Caption := '';
    // Edit
    if self.Components[i] is TEdit then
      TEdit(self.Components[i]).Text := '';
    // Button
    if self.Components[i] is TButton then
      TButton(self.Components[i]).Caption := '';
    // Panel
    if self.Components[i] is TPanel then
      TPanel(self.Components[i]).Caption := '';
  end;

  rbCCPressKeyKeyboard.Checked := True;
  rbCCPressKeyKeyboardClick(rbCCPressKeyKeyboard);
  rbCCKeyKeyboard.Checked := True;
  rbCCKeyKeyboardClick(rbCCKeyKeyboard);

  UpdateLanguage(self, lngRus);

  Keyboards := Main.DataBase.GetKeyboards;
  for i := 0 to length(Keyboards) - 1 do
  begin
    cbCCKeyManualKey1.Items.AddObject(Keyboards[i].Desc, TObject(Keyboards[i].Key));
    cbCCKeyManualKey2.Items.AddObject(Keyboards[i].Desc, TObject(Keyboards[i].Key));
    cbCCKeyManualKey3.Items.AddObject(Keyboards[i].Desc, TObject(Keyboards[i].Key));
  end;
end;

procedure TControlCommand.LoadIcon(FileName: String; Image: TImage);
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

procedure TControlCommand.rbCCKeyKeyboardClick(Sender: TObject);
begin
  lCCKeyKeyboardHelp.Font.Color := clWindowText;
  edCCKeyKeyboard.Enabled := True;

  lCCKeyManualKey1.Font.Color := clGrayText;
  lCCKeyManualKey2.Font.Color := clGrayText;
  lCCKeyManualKey3.Font.Color := clGrayText;
  cbCCKeyManualKey1.Enabled := False;
  cbCCKeyManualKey2.Enabled := False;
  cbCCKeyManualKey3.Enabled := False;

  FKey1 := nil;
  FKey2 := nil;
  FKey3 := nil;
  edCCKeyKeyboard.Text := '';

end;

procedure TControlCommand.rbCCKeyManualClick(Sender: TObject);
begin
  lCCKeyKeyboardHelp.Font.Color := clGrayText;
  edCCKeyKeyboard.Enabled := False;

  lCCKeyManualKey1.Font.Color := clWindowText;
  lCCKeyManualKey2.Font.Color := clWindowText;
  lCCKeyManualKey3.Font.Color := clWindowText;
  cbCCKeyManualKey1.Enabled := True;
  cbCCKeyManualKey2.Enabled := True;
  cbCCKeyManualKey3.Enabled := True;

  FKey1 := nil;
  FKey2 := nil;
  FKey3 := nil;
  cbCCKeyManualKey1.ItemIndex := -1;
  cbCCKeyManualKey2.ItemIndex := -1;
  cbCCKeyManualKey3.ItemIndex := -1;
end;

procedure TControlCommand.rbCCPressKeyKeyboardClick(Sender: TObject);
begin
  rbCCRunApplication.Checked := False;
  rbCCRepeat.Checked := False;

  // Клавиатура
  rbCCKeyKeyboard.Enabled := True;
  rbCCKeyManual.Enabled := True;
  cbCCKeyRepeat.Enabled := True;

  if rbCCKeyKeyboard.Checked then
    rbCCKeyKeyboardClick(rbCCKeyKeyboard);
  if rbCCKeyManual.Checked then
    rbCCKeyManualClick(rbCCKeyManual);

  // Приложение
  lCCAppFileName.Font.Color := clGrayText;
  edCCAppFileName.Enabled := False;
  btnCCAppFileName.Enabled := False;
  ImageCCApp.Enabled := False;
end;

procedure TControlCommand.rbCCRunApplicationClick(Sender: TObject);
begin
  rbCCPressKeyKeyboard.Checked := False;
  rbCCRepeat.Checked := False;

  // Клавиатура
  rbCCKeyKeyboard.Enabled := False;
  lCCKeyKeyboardHelp.Font.Color := clGrayText;
  edCCKeyKeyboard.Enabled := False;

  rbCCKeyManual.Enabled := False;
  lCCKeyManualKey1.Font.Color := clGrayText;
  lCCKeyManualKey2.Font.Color := clGrayText;
  lCCKeyManualKey3.Font.Color := clGrayText;
  cbCCKeyManualKey1.Enabled := False;
  cbCCKeyManualKey2.Enabled := False;
  cbCCKeyManualKey3.Enabled := False;

  cbCCKeyRepeat.Enabled := False;

  // Приложение
  lCCAppFileName.Font.Color := clWindowText;
  edCCAppFileName.Enabled := True;
  btnCCAppFileName.Enabled := True;
  ImageCCApp.Enabled := False;
end;

procedure TControlCommand.rbCCRepeatClick(Sender: TObject);
begin
  rbCCPressKeyKeyboard.Checked := False;
  rbCCRunApplication.Checked := False;

  // Клавиатура
  rbCCKeyKeyboard.Enabled := False;
  lCCKeyKeyboardHelp.Font.Color := clGrayText;
  edCCKeyKeyboard.Enabled := False;

  rbCCKeyManual.Enabled := False;
  lCCKeyManualKey1.Font.Color := clGrayText;
  lCCKeyManualKey2.Font.Color := clGrayText;
  lCCKeyManualKey3.Font.Color := clGrayText;
  cbCCKeyManualKey1.Enabled := False;
  cbCCKeyManualKey2.Enabled := False;
  cbCCKeyManualKey3.Enabled := False;

  cbCCKeyRepeat.Enabled := False;

  // Приложение
  lCCAppFileName.Font.Color := clGrayText;
  edCCAppFileName.Enabled := False;
  btnCCAppFileName.Enabled := False;
  ImageCCApp.Enabled := False;
end;

end.
