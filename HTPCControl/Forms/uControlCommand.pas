unit uControlCommand;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Winapi.Shellapi, uDataBase, Vcl.ComCtrls;

type
  TccType = (ccNew, ccAdd, ccEdit);

type
  TfrmControlCommand = class(TForm)
    lCCCommand: TLabel;
    lCCDescription: TLabel;
    edCCCommand: TEdit;
    edCCDescription: TEdit;
    edCCAppFileName: TEdit;
    lCCAppFileName: TLabel;
    btnCCAppFileName: TButton;
    ImageCCApp: TImage;
    pImageApplication: TPanel;
    btnCancel: TButton;
    btnSave: TButton;
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
    pcControlCommand: TPageControl;
    TabKeyboard: TTabSheet;
    TabApplication: TTabSheet;
    TabRepeat: TTabSheet;
    cbCommandRepeat: TCheckBox;
    lKeyboard: TLabel;
    lApplication: TLabel;
    lRepeat: TLabel;
    pTabRepeat: TPanel;
    pTabApplication: TPanel;
    pTabKeyboard: TPanel;
    lCCKeyManualPlus1: TLabel;
    lCCKeyManualPlus2: TLabel;
    procedure FormCreate(Sender: TObject);
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
    procedure FormShow(Sender: TObject);
    procedure edCCCommandKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }

    FKey1: PKeyboard;
    FKey2: PKeyboard;
    FKey3: PKeyboard;

    FCType: TccType;

    procedure LoadIcon(FileName: String; Image: TImage);
  public
    { Public declarations }
    property cType: TccType read FCType write FCType;
  end;

var
  frmControlCommand: TfrmControlCommand;

implementation

{$R *.dfm}

uses uMain, uLanguage, uTypes;

procedure TfrmControlCommand.btnCancelClick(Sender: TObject);
begin
  self.Close;
end;

procedure TfrmControlCommand.btnCCAppFileNameClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(self);
  try
    OpenDialog.Filter := 'Приложения|*.exe';
    if FileExists(edCCAppFileName.Text) then
      OpenDialog.InitialDir := ExtractFileDir(edCCAppFileName.Text)
    else
      OpenDialog.InitialDir := ExtractFileDir(Application.ExeName);

    if (OpenDialog.Execute) and (FileExists(OpenDialog.FileName)) then
    begin
      edCCAppFileName.Text := OpenDialog.FileName;
      LoadIcon(edCCAppFileName.Text, ImageCCApp);
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TfrmControlCommand.btnSaveClick(Sender: TObject);
var
  RCommand: TRemoteCommand;
  Key1, Key2, Key3: integer;
begin

  // if not Assigned(Main.DataBase) or not Main.DataBase.Connected then
  // begin
  // MessageDlg(uLanguage.GetLanguageMsg('msgDBNotConnected', lngRus), mtWarning, [mbOK], 0);
  // exit;
  // end;
  //
  // if Length(Trim(edCCCommand.Text)) = 0 then
  // begin
  // MessageDlg(Format(uLanguage.GetLanguageMsg('msgRCCommandEmpty', lngRus), [lCCCommand.Caption]),
  // mtWarning, [mbOK], 0);
  // exit;
  // end;
  //
  // RCommand.Command := edCCCommand.Text;
  // RCommand.Desc := edCCDescription.Text;
  //
  // try
  // // TabKeyboard
  // if pcControlCommand.ActivePage = TabKeyboard then
  // begin
  // Key1 := 0;
  // Key2 := 0;
  // Key3 := 0;
  //
  // if FKey1 <> nil then
  // Key1 := FKey1.Key;
  // if FKey2 <> nil then
  // Key2 := FKey2.Key;
  // if FKey3 <> nil then
  // Key3 := FKey3.Key;
  //
  // if FCType in [ccNew, ccAdd] then
  // Main.DataBase.CreatePressKeyKeyboard(RCommand, Key1, Key2, cbCCKeyRepeat.Checked)
  // else
  // Main.DataBase.UpdatePressKeyKeyboard(RCommand, Key1, Key2, cbCCKeyRepeat.Checked);
  // end
  // // TabApplication
  // else if pcControlCommand.ActivePage = TabApplication then
  // begin
  // if FCType in [ccNew, ccAdd] then
  // Main.DataBase.CreateRunApplication(RCommand, edCCAppFileName.Text)
  // else
  // Main.DataBase.UpdateRunApplication(RCommand, edCCAppFileName.Text);
  // end
  // // TabRepeat
  // else if pcControlCommand.ActivePage = TabRepeat then
  // begin
  // if FCType in [ccNew, ccAdd] then
  // Main.DataBase.CreateRemoteCommand(RCommand.Command, RCommand.Desc, cbCommandRepeat.Checked)
  // else
  // Main.DataBase.UpdateRemoteCommand(RCommand.Command, RCommand.Desc, cbCommandRepeat.Checked);
  // end
  // // Если не определенная вкладка
  // else
  // raise Exception.Create('Error Message');
  //
  // self.ModalResult := mrOk;
  // // self.Close;
  // except
  // on E: Exception do
  // MessageDlg(E.Message, mtWarning, [mbOK], 0);
  // end;

end;

procedure TfrmControlCommand.cbCCKeyManualKey1Select(Sender: TObject);
begin
  // FKey1 := Main.DataBase.GetKeyboardKey
  // (integer(cbCCKeyManualKey1.Items.Objects[cbCCKeyManualKey1.ItemIndex]));
end;

procedure TfrmControlCommand.cbCCKeyManualKey2Select(Sender: TObject);
begin
  // FKey2 := Main.DataBase.GetKeyboardKey
  // (integer(cbCCKeyManualKey2.Items.Objects[cbCCKeyManualKey2.ItemIndex]));
end;

procedure TfrmControlCommand.cbCCKeyManualKey3Select(Sender: TObject);
begin
  // FKey3 := Main.DataBase.GetKeyboardKey
  // (integer(cbCCKeyManualKey3.Items.Objects[cbCCKeyManualKey3.ItemIndex]));
end;

procedure TfrmControlCommand.edCCCommandKeyPress(Sender: TObject; var Key: Char);
begin
  edCCCommand.Text := Trim(edCCCommand.Text);
end;

procedure TfrmControlCommand.edCCKeyKeyboardKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  btn: string;
  KeyKeyboard: PKeyboard;
begin
  // HideCaret(TEdit(Sender).Handle);
  //
  // FKey1 := nil;
  // FKey2 := nil;
  // FKey3 := nil;
  //
  // KeyKeyboard := Main.DataBase.GetKeyboardKey(Key);
  // if KeyKeyboard <> nil then
  // btn := KeyKeyboard.Desc;
  //
  // if (ssAlt in Shift) and (btn <> 'Alt') then
  // begin
  // FKey1 := Main.DataBase.GetKeyboardKey(18);
  // FKey2 := KeyKeyboard;
  // end
  // else if (ssCtrl in Shift) and (btn <> 'Ctrl') then
  // begin
  // FKey1 := Main.DataBase.GetKeyboardKey(17);
  // FKey2 := KeyKeyboard;
  // end
  // else if (ssShift in Shift) and (btn <> 'Shift') then
  // begin
  // FKey1 := Main.DataBase.GetKeyboardKey(16);
  // FKey2 := KeyKeyboard;
  // end
  // else
  // begin
  // FKey1 := KeyKeyboard;
  // end;
  //
  // // Отмена F10
  // if Key = VK_F10 then
  // Key := 0;
  //
  // // Отмена Alt + F4
  // if ((ssAlt in Shift) and (Key = VK_F4)) then
  // Key := 0;
  //
  // if (ssAlt in Shift) then
  // Key := 0;
  //
  // if FKey1 <> nil then
  // edCCKeyKeyboard.Text := FKey1.Desc;
  // if FKey2 <> nil then
  // edCCKeyKeyboard.Text := edCCKeyKeyboard.Text + ' + ' + FKey2.Desc;
  // if FKey3 <> nil then
  // edCCKeyKeyboard.Text := edCCKeyKeyboard.Text + ' + ' + FKey3.Desc;
end;

procedure TfrmControlCommand.edCCKeyKeyboardKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  HideCaret(TEdit(Sender).Handle);
end;

procedure TfrmControlCommand.FormCreate(Sender: TObject);
var
  i: integer;
  Keyboards: TKeyboards;
begin

  // // чистим контролы
  // for i := 0 to self.ComponentCount - 1 do
  // begin
  // // Label
  // if self.Components[i] is TLabel then
  // TLabel(self.Components[i]).Caption := '';
  // // Edit
  // if self.Components[i] is TEdit then
  // TEdit(self.Components[i]).Text := '';
  // // Button
  // if self.Components[i] is TButton then
  // TButton(self.Components[i]).Caption := '';
  // // Panel
  // if self.Components[i] is TPanel then
  // TPanel(self.Components[i]).Caption := '';
  // end;
  //
  // pcControlCommand.ActivePageIndex := 0;
  // rbCCKeyKeyboard.Checked := True;
  // rbCCKeyKeyboardClick(rbCCKeyKeyboard);
  //
  // UpdateLanguage(self, lngRus);
  //
  // Keyboards := Main.DataBase.GetKeyboards;
  // for i := 0 to Length(Keyboards) - 1 do
  // begin
  // cbCCKeyManualKey1.Items.AddObject(Keyboards[i].Desc, TObject(Keyboards[i].Key));
  // cbCCKeyManualKey2.Items.AddObject(Keyboards[i].Desc, TObject(Keyboards[i].Key));
  // cbCCKeyManualKey3.Items.AddObject(Keyboards[i].Desc, TObject(Keyboards[i].Key));
  // end;
end;

procedure TfrmControlCommand.FormShow(Sender: TObject);
// var
// RCommand: TRemoteCommand;
// ECommand: TECommand;
// ECommands: TECommands;
begin
  // case FCType of
  // ccNew: // Новая команда
  // begin
  // edCCCommand.ReadOnly := False;
  // edCCCommand.SetFocus;
  // end;
  // ccAdd: // Добавляем принятую команду из COM порта
  // begin
  // edCCCommand.ReadOnly := True;
  // edCCDescription.SetFocus;
  // end;
  // ccEdit: // Изменить команду
  // begin
  // edCCCommand.ReadOnly := True;
  // edCCDescription.SetFocus;
  //
  // TabKeyboard.TabVisible := False;
  // TabApplication.TabVisible := False;
  // TabRepeat.TabVisible := False;
  //
  // RCommand := Main.DataBase.GetRemoteCommand(edCCCommand.Text);
  // ECommands := Main.DataBase.getExecuteCommands(edCCCommand.Text);
  // edCCDescription.Text := RCommand.Desc;
  //
  // if RCommand.RepeatPreview or (Length(ECommands) = 0) then
  // begin
  // pcControlCommand.ActivePage := TabRepeat;
  // cbCommandRepeat.Checked := RCommand.RepeatPreview;
  // exit;
  // end;
  //
  // ECommand := ECommands[0];
  // case ECommand.ECType of
  // ecKyeboard:
  // begin
  // pcControlCommand.ActivePage := TabKeyboard;
  //
  // rbCCKeyManual.Checked := True;
  // rbCCKeyManualClick(rbCCKeyManual);
  //
  // cbCCKeyManualKey1.ItemIndex := cbCCKeyManualKey1.Items.IndexOfObject
  // (TObject(ECommand.Key1));
  // cbCCKeyManualKey1Select(cbCCKeyManualKey1);
  //
  // if ECommand.Key2 > 0 then
  // begin
  // cbCCKeyManualKey2.ItemIndex := cbCCKeyManualKey2.Items.IndexOfObject
  // (TObject(ECommand.Key2));
  // cbCCKeyManualKey2Select(cbCCKeyManualKey2);
  // end;
  //
  // cbCCKeyRepeat.Checked := ECommand.Rep;
  // end;
  // ecApplication:
  // begin
  // pcControlCommand.ActivePage := TabApplication;
  // edCCAppFileName.Text := ECommand.Application;
  // LoadIcon(ECommand.Application, ImageCCApp);
  // end
  // end;
  //
  // end;
  // end;
end;

procedure TfrmControlCommand.LoadIcon(FileName: String; Image: TImage);
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

procedure TfrmControlCommand.rbCCKeyKeyboardClick(Sender: TObject);
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

procedure TfrmControlCommand.rbCCKeyManualClick(Sender: TObject);
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

end.
