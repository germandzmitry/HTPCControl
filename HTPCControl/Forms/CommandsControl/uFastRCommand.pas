unit uFastRCommand;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  uDataBase, Vcl.GraphUtil, Vcl.Themes;

type
  TfrcType = (frcAdd, frcEdit);

type
  TfrmFastRCommand = class(TForm)
    btnCancel: TButton;
    btnSave: TButton;
    lCommand: TLabel;
    lDescription: TLabel;
    cbRepeatPrevious: TCheckBox;
    edCommand: TEdit;
    edDescription: TEdit;
    cbLongPress: TCheckBox;
    pcOperation: TPageControl;
    TabPressKeyboard: TTabSheet;
    TabRunApplication: TTabSheet;
    lApplicationFileName: TLabel;
    btnApplicationFileName: TButton;
    edApplicationFileName: TEdit;
    pImageApplication: TPanel;
    ImageApplication: TImage;
    cbGroupKey1: TComboBox;
    cbKeyboard1: TComboBox;
    cbGroupKey2: TComboBox;
    cbGroupKey3: TComboBox;
    cbKeyboard2: TComboBox;
    cbKeyboard3: TComboBox;
    lKey1: TLabel;
    lKey2: TLabel;
    lKey3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnApplicationFileNameClick(Sender: TObject);
    procedure cbGroupKey1Select(Sender: TObject);
    procedure cbGroupKey2Select(Sender: TObject);
    procedure cbGroupKey3Select(Sender: TObject);
  private
    { Private declarations }
    FFRCType: TfrcType;
    FOperation: TOperation;

    FKeyboardGroups: TKeyboardGroups;
    FKeyboards: TKeyboards;

    procedure GroupKeyboardSelect(Group: Integer; ComboBox: TComboBox);
  public
    { Public declarations }
    property frcType: TfrcType read FFRCType write FFRCType;
    property Operation: TOperation write FOperation;
  end;

var
  frmFastRCommand: TfrmFastRCommand;

implementation

{$R *.dfm}

uses uLanguage, uShellApplication, uMain, uTypes;

procedure TfrmFastRCommand.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  edCommand.Text := '';
  edDescription.Text := '';
  cbLongPress.Checked := false;
  cbRepeatPrevious.Checked := false;

  pcOperation.ActivePage := TabPressKeyboard;

  pImageApplication.Caption := '';
  edApplicationFileName.Text := '';

  UpdateLanguage(self, lngRus);

  try
    FKeyboardGroups := main.DataBase.getKeyboardGroups;
    FKeyboards := main.DataBase.GetKeyboards;

    cbGroupKey1.Items.BeginUpdate;
    cbGroupKey2.Items.BeginUpdate;
    cbGroupKey3.Items.BeginUpdate;
    cbGroupKey1.Items.Clear;
    cbGroupKey2.Items.Clear;
    cbGroupKey3.Items.Clear;
    cbGroupKey1.Items.AddObject('', TObject(-1));
    cbGroupKey2.Items.AddObject('', TObject(-1));
    cbGroupKey3.Items.AddObject('', TObject(-1));
    for i := 0 to Length(FKeyboardGroups) - 1 do
    begin
      cbGroupKey1.Items.AddObject(FKeyboardGroups[i].Description,
        TObject(FKeyboardGroups[i].Group));
      cbGroupKey2.Items.AddObject(FKeyboardGroups[i].Description,
        TObject(FKeyboardGroups[i].Group));
      cbGroupKey3.Items.AddObject(FKeyboardGroups[i].Description,
        TObject(FKeyboardGroups[i].Group));
    end;
    cbGroupKey1.Items.EndUpdate;
    cbGroupKey2.Items.EndUpdate;
    cbGroupKey3.Items.EndUpdate;
  except
    on E: Exception do
      MessageDlg(E.Message, mtWarning, [mbOK], 0);
  end;

  // for i := 0 to Length(FKeyboardGroups) - 1 do
  // with ListView1.Groups.Add do
  // begin
  // State := State + [lgsCollapsible];
  // GroupID := FKeyboardGroups[i].Group;
  // Header := FKeyboardGroups[i].Description;
  // end;
  //
  // for i := 0 to Length(FKeyboards) - 1 do
  // with ListView1.Items.Add do
  // begin
  // GroupID := FKeyboards[i].Group;
  // Caption := FKeyboards[i].Desc;
  // end;

end;

procedure TfrmFastRCommand.FormShow(Sender: TObject);
var
  i: Integer;
begin

  case FFRCType of
    frcAdd:
      edCommand.ReadOnly := false;
    frcEdit:
      begin
        edCommand.ReadOnly := true;

        case FOperation.OType of
          opKyeboard:
            begin
              pcOperation.ActivePage := TabPressKeyboard;
              TabRunApplication.tabVisible := false;

              for i := 0 to Length(FKeyboards) - 1 do
                if FKeyboards[i].Key = FOperation.PressKeyboard.Key1 then
                begin
                  cbGroupKey1.ItemIndex := cbGroupKey1.Items.IndexOfObject
                    (TObject(FKeyboards[i].Group));
                  cbGroupKey1Select(cbGroupKey1);
                  cbKeyboard1.ItemIndex := cbKeyboard1.Items.IndexOfObject
                    (TObject(FOperation.PressKeyboard.Key1));
                  Break;
                end;

              if FOperation.PressKeyboard.Key2 > 0 then
                for i := 0 to Length(FKeyboards) - 1 do
                  if FKeyboards[i].Key = FOperation.PressKeyboard.Key2 then
                  begin
                    cbGroupKey2.ItemIndex := cbGroupKey2.Items.IndexOfObject
                      (TObject(FKeyboards[i].Group));
                    cbGroupKey2Select(cbGroupKey2);
                    cbKeyboard2.ItemIndex := cbKeyboard2.Items.IndexOfObject
                      (TObject(FOperation.PressKeyboard.Key2));
                    Break;
                  end;

              if FOperation.PressKeyboard.Key3 > 0 then
                for i := 0 to Length(FKeyboards) - 1 do
                  if FKeyboards[i].Key = FOperation.PressKeyboard.Key3 then
                  begin
                    cbGroupKey3.ItemIndex := cbGroupKey3.Items.IndexOfObject
                      (TObject(FKeyboards[i].Group));
                    cbGroupKey3Select(cbGroupKey3);
                    cbKeyboard3.ItemIndex := cbKeyboard3.Items.IndexOfObject
                      (TObject(FOperation.PressKeyboard.Key3));
                    Break;
                  end;

            end;
          opApplication:
            begin
              pcOperation.ActivePage := TabRunApplication;
              TabPressKeyboard.tabVisible := false;
              edApplicationFileName.Text := FOperation.RunApplication.Application;
            end;
        end;

      end;
  end;
  edDescription.SetFocus;
end;

procedure TfrmFastRCommand.btnApplicationFileNameClick(Sender: TObject);
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

procedure TfrmFastRCommand.btnSaveClick(Sender: TObject);
var
  RCommandExists: boolean;
  Command: string;
  Key1, Key2, Key3: Integer;
begin
  try
    if Length(Trim(edCommand.Text)) = 0 then
      raise Exception.CreateFmt(uLanguage.GetLanguageMsg('msgRCCommandEmpty', lngRus),
        [lCommand.Caption]);

    // Команда
    case FFRCType of
      frcAdd:
        begin
          main.DataBase.CreateRemoteCommand(edCommand.Text, edDescription.Text,
            cbRepeatPrevious.Checked, cbLongPress.Checked, RCommandExists);

          if RCommandExists then
            raise Exception.CreateFmt(uLanguage.GetLanguageMsg('msgRCCommandExists', lngRus),
              [edCommand.Text]);
        end;
      frcEdit:
        begin
          main.DataBase.UpdateRemoteCommand(edCommand.Text, edDescription.Text,
            cbRepeatPrevious.Checked, cbLongPress.Checked);
        end;
    end;

    Command := edCommand.Text;

    // Клавиатура
    if pcOperation.ActivePage = TabPressKeyboard then
    begin
      Key1 := 0;
      Key2 := 0;
      Key3 := 0;

      if cbKeyboard1.ItemIndex <= 0 then
        exit;

      if cbKeyboard1.ItemIndex > 0 then
        Key1 := Integer(cbKeyboard1.Items.Objects[cbKeyboard1.ItemIndex]);
      if cbKeyboard2.ItemIndex > 0 then
        Key2 := Integer(cbKeyboard2.Items.Objects[cbKeyboard2.ItemIndex]);
      if cbKeyboard3.ItemIndex > 0 then
        Key3 := Integer(cbKeyboard3.Items.Objects[cbKeyboard3.ItemIndex]);

      case FFRCType of
        frcAdd:
          main.DataBase.CreatePressKeyboard(Command, Key1, Key2, Key3);
        frcEdit:
          main.DataBase.UpdatePressKeyboard(FOperation.PressKeyboard.id, Key1, Key2, Key3);
      end;
    end
    // Запуск приложения
    else if pcOperation.ActivePage = TabRunApplication then
    begin
      case FFRCType of
        frcAdd:
          main.DataBase.CreateRunApplication(Command, edApplicationFileName.Text);
        frcEdit:
          main.DataBase.UpdateRunApplication(FOperation.RunApplication.id,
            edApplicationFileName.Text);
      end;
    end;

    self.ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmFastRCommand.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFastRCommand.cbGroupKey1Select(Sender: TObject);
begin
  GroupKeyboardSelect(Integer(TComboBox(Sender).Items.Objects[TComboBox(Sender).ItemIndex]),
    cbKeyboard1);
end;

procedure TfrmFastRCommand.cbGroupKey2Select(Sender: TObject);
begin
  GroupKeyboardSelect(Integer(TComboBox(Sender).Items.Objects[TComboBox(Sender).ItemIndex]),
    cbKeyboard2);
end;

procedure TfrmFastRCommand.cbGroupKey3Select(Sender: TObject);
begin
  GroupKeyboardSelect(Integer(TComboBox(Sender).Items.Objects[TComboBox(Sender).ItemIndex]),
    cbKeyboard3);
end;

procedure TfrmFastRCommand.GroupKeyboardSelect(Group: Integer; ComboBox: TComboBox);
var
  i: Integer;
begin
  ComboBox.Items.BeginUpdate;
  ComboBox.Items.Clear;
  ComboBox.Items.AddObject('', TObject(-1));
  for i := 0 to Length(FKeyboards) - 1 do
    if FKeyboards[i].Group = Group then
      ComboBox.Items.AddObject(FKeyboards[i].Desc, TObject(FKeyboards[i].Key));
  ComboBox.Items.EndUpdate;
end;

end.
