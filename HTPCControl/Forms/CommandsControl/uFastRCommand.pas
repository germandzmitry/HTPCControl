unit uFastRCommand;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  uDataBase, Vcl.GraphUtil, Vcl.Themes, Vcl.Buttons, ShellApi, Vcl.Tabs,
  Vcl.DockTabSet, Vcl.ButtonGroup, uLine;

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
    pcOperationType: TPageControl;
    TabPressKeyboard: TTabSheet;
    TabRunApplication: TTabSheet;
    lApplicationFileName: TLabel;
    edApplicationFileName: TEdit;
    pImageApplication: TPanel;
    ImageApplication: TImage;
    pOperationHeader: TPanel;
    lPSort: TLabel;
    lWait: TLabel;
    lWaitSecond: TLabel;
    edPSort: TEdit;
    udPSort: TUpDown;
    edWait: TEdit;
    udWait: TUpDown;
    lvKeyboard: TListView;
    lvDownKey: TListView;
    edForApplication: TEdit;
    lForApplication: TLabel;
    sbtnForApplication: TSpeedButton;
    sbtnForApplicationClear: TSpeedButton;
    pCommand: TPanel;
    lCommandHeader: TLabel;
    lOperationHeader: TLabel;
    pOperationType: TPanel;
    dtsOperationType: TDockTabSet;
    sbtnApplicationFileName: TSpeedButton;
    sbtnRight: TSpeedButton;
    sbtnLeft: TSpeedButton;
    sbtnLeftAll: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvKeyboardDblClick(Sender: TObject);
    procedure lvDownKeyDblClick(Sender: TObject);
    procedure udWaitChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer;
      Direction: TUpDownDirection);
    procedure tsOperationChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure dtsOperationTypeClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbtnForApplicationClick(Sender: TObject);
    procedure sbtnForApplicationClearClick(Sender: TObject);
    procedure sbtnApplicationFileNameClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbRepeatPreviousClick(Sender: TObject);
    procedure sbtnRightClick(Sender: TObject);
    procedure sbtnLeftClick(Sender: TObject);
    procedure sbtnLeftAllClick(Sender: TObject);
  private
    { Private declarations }
    FFRCType: TfrcType;
    FOperation: TOperation;
    FLineCommand: TLine;
    FLineOperation: TLine;
    FLineOperationType: TLine;
    FpOperationType: TPanel;

    FKeyboardGroups: TKeyboardGroups;
    FKeyboards: TKeyboards;
  public
    { Public declarations }
    property frcType: TfrcType read FFRCType write FFRCType;
    property Operation: TOperation write FOperation;
  end;

var
  frmFastRCommand: TfrmFastRCommand;

implementation

{$R *.dfm}

uses uLanguage, uShellApplication, uMain, uTypes, uIcon;

procedure TfrmFastRCommand.FormCreate(Sender: TObject);
var
  i: Integer;
  Icon: TIcon;
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
    // Panel
    if self.Components[i] is TPanel then
      TPanel(self.Components[i]).Caption := '';
    // CheckBox
    if self.Components[i] is TCheckBox then
      TCheckBox(self.Components[i]).Checked := false;
  end;

  sbtnForApplication.Flat := true;
  sbtnForApplicationClear.Flat := true;

  // GetHighlightColor(rgb(217, 217, 220)) = clBtnFace
  dtsOperationType.BackgroundColor := rgb(217, 217, 220);
  TabPressKeyboard.TabVisible := false;
  TabRunApplication.TabVisible := false;
  pcOperationType.ActivePage := TabPressKeyboard;

  UpdateLanguage(self, lngRus);

  Icon := TIcon.Create;
  try
    StockIcon(SIID_FOLDER, Icon);
    sbtnForApplication.Glyph.Width := Icon.Width;
    sbtnForApplication.Glyph.Height := Icon.Height;
    sbtnForApplication.Glyph.Canvas.Draw(0, 0, Icon);
    sbtnForApplication.Flat := true;
  finally
    Icon.Free;
  end;

  Icon := TIcon.Create;
  try
    StockIcon(SIID_DELETE, Icon);
    sbtnForApplicationClear.Glyph.Width := Icon.Width;
    sbtnForApplicationClear.Glyph.Height := Icon.Height;
    sbtnForApplicationClear.Glyph.Canvas.Draw(0, 0, Icon);
    sbtnForApplicationClear.Flat := true;
  finally
    Icon.Free;
  end;

  Icon := TIcon.Create;
  try
    StockIcon(SIID_FOLDER, Icon);
    sbtnApplicationFileName.Glyph.Width := Icon.Width;
    sbtnApplicationFileName.Glyph.Height := Icon.Height;
    sbtnApplicationFileName.Glyph.Canvas.Draw(0, 0, Icon);
    sbtnApplicationFileName.Flat := true;
  finally
    Icon.Free;
  end;

  Icon := TIcon.Create;
  try
    Main.ilSmall.GetIcon(17, Icon);
    sbtnRight.Glyph.Width := Icon.Width;
    sbtnRight.Glyph.Height := Icon.Height;
    sbtnRight.Glyph.Canvas.Draw(0, 0, Icon);
  finally
    Icon.Free;
  end;

  Icon := TIcon.Create;
  try
    Main.ilSmall.GetIcon(16, Icon);
    sbtnLeft.Glyph.Width := Icon.Width;
    sbtnLeft.Glyph.Height := Icon.Height;
    sbtnLeft.Glyph.Canvas.Draw(0, 0, Icon);
  finally
    Icon.Free;
  end;

  Icon := TIcon.Create;
  try
    Main.ilSmall.GetIcon(15, Icon);
    sbtnLeftAll.Glyph.Width := Icon.Width;
    sbtnLeftAll.Glyph.Height := Icon.Height;
    sbtnLeftAll.Glyph.Canvas.Draw(0, 0, Icon);
  finally
    Icon.Free;
  end;

  try
    FKeyboardGroups := Main.DataBase.getKeyboardGroups;
    FKeyboards := Main.DataBase.GetKeyboards;

    for i := 0 to Length(FKeyboardGroups) - 1 do
      with lvKeyboard.Groups.Add do
      begin
        Header := FKeyboardGroups[i].Description;
        GroupID := FKeyboardGroups[i].Group;
      end;

    lvKeyboard.Items.BeginUpdate;
    for i := 0 to Length(FKeyboards) - 1 do
      with lvKeyboard.Items.Add do
      begin
        Caption := FKeyboards[i].Desc;
        GroupID := FKeyboards[i].Group;
        Data := Pointer(FKeyboards[i].Key);
      end;
    lvKeyboard.Items.EndUpdate;

  except
    on E: Exception do
      MessageDlg(E.Message, mtWarning, [mbOK], 0);
  end;

  FLineCommand := TLine.Create(pCommand, alBottom, clBlack, clBlack);
  FLineOperationType := TLine.Create(pOperationType, alBottom, clBlack, clBlack);
end;

procedure TfrmFastRCommand.FormShow(Sender: TObject);
// var
// Key: TKeyboard;
begin

  case FFRCType of
    frcAdd:
      begin
        FpOperationType := TPanel.Create(self);
        with FpOperationType do
        begin
          parent := self;
          left := 0;
          Top := dtsOperationType.Top + dtsOperationType.Height - 2;
          Width := dtsOperationType.Width;
          Height := 2;
          ParentBackground := false;
          Color := clWhite;
          BevelOuter := bvNone;
          Caption := '';
          BringToFront;
        end;

        edCommand.ReadOnly := false;
      end;
    frcEdit:
      begin
        FLineOperation := TLine.Create(pOperationHeader, alBottom, clBlack, clBlack);

        edCommand.ReadOnly := true;
        udPSort.Position := FOperation.OSort;
        udWait.Position := FOperation.OWait;
        dtsOperationType.Visible := false;

        case FOperation.OType of
          opKyeboard:
            begin
              pcOperationType.ActivePage := TabPressKeyboard;

              edForApplication.Text := FOperation.PressKeyboard.forApplication;

              with lvDownKey.Items.Add do
              begin
                Caption := Main.DataBase.GetKeyboard(FOperation.PressKeyboard.Key1).Desc;
                Data := Pointer(FOperation.PressKeyboard.Key1);
              end;

              if FOperation.PressKeyboard.Key2 > 0 then
                with lvDownKey.Items.Add do
                begin
                  Caption := Main.DataBase.GetKeyboard(FOperation.PressKeyboard.Key2).Desc;
                  Data := Pointer(FOperation.PressKeyboard.Key2);
                end;

              if FOperation.PressKeyboard.Key3 > 0 then
                with lvDownKey.Items.Add do
                begin
                  Caption := Main.DataBase.GetKeyboard(FOperation.PressKeyboard.Key3).Desc;
                  Data := Pointer(FOperation.PressKeyboard.Key3);
                end;

              lvKeyboard.Enabled := not(lvDownKey.Items.Count >= 3);

            end;
          opApplication:
            begin
              pcOperationType.ActivePage := TabRunApplication;
              edApplicationFileName.Text := FOperation.RunApplication.Application;
            end;
        end;

      end;
  end;
  edDescription.SetFocus;

  pcOperationType.Height := pcOperationType.Height - pcOperationType.TabHeight;
  pOperationType.Height := pOperationType.Height - pcOperationType.TabHeight + 1;
  self.ClientHeight := pOperationType.Top + pOperationType.Height + 8 + btnSave.Height + 8;

  cbRepeatPreviousClick(cbRepeatPrevious);
end;

procedure TfrmFastRCommand.FormDestroy(Sender: TObject);
begin
  if Assigned(FpOperationType) then
    FpOperationType.Free;
  if Assigned(FLineCommand) then
    FLineCommand.Free;
  if Assigned(FLineOperation) then
    FLineOperation.Free;
  if Assigned(FLineOperationType) then
    FLineOperationType.Free;
end;

procedure TfrmFastRCommand.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 27 then
    close;
end;

procedure TfrmFastRCommand.btnSaveClick(Sender: TObject);
var
  RCommandExists: Boolean;
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
          Main.DataBase.CreateRemoteCommand(edCommand.Text, edDescription.Text,
            cbRepeatPrevious.Checked, cbLongPress.Checked, RCommandExists);

          if RCommandExists then
            raise Exception.CreateFmt(uLanguage.GetLanguageMsg('msgRCCommandExists', lngRus),
              [edCommand.Text]);
        end;
      frcEdit:
        begin
          Main.DataBase.UpdateRemoteCommand(edCommand.Text, edDescription.Text,
            cbRepeatPrevious.Checked, cbLongPress.Checked);
        end;
    end;

    if cbRepeatPrevious.Checked then
      self.ModalResult := mrOk;

    Command := edCommand.Text;

    // Клавиатура
    if pcOperationType.ActivePage = TabPressKeyboard then
    begin
      Key1 := 0;
      Key2 := 0;
      Key3 := 0;

      if lvDownKey.Items.Count >= 1 then
        Key1 := Integer(lvDownKey.Items[0].Data);
      if lvDownKey.Items.Count >= 2 then
        Key2 := Integer(lvDownKey.Items[1].Data);
      if lvDownKey.Items.Count >= 3 then
        Key3 := Integer(lvDownKey.Items[2].Data);

      case FFRCType of
        frcAdd:
          Main.DataBase.CreatePressKeyboard(Command, udPSort.Position, udWait.Position, Key1, Key2,
            Key3, edForApplication.Text);
        frcEdit:
          Main.DataBase.UpdatePressKeyboard(FOperation.PressKeyboard.id, udPSort.Position,
            udWait.Position, Key1, Key2, Key3, edForApplication.Text);
      end;
    end
    // Запуск приложения
    else if pcOperationType.ActivePage = TabRunApplication then
    begin
      case FFRCType of
        frcAdd:
          Main.DataBase.CreateRunApplication(Command, udPSort.Position, udWait.Position,
            edApplicationFileName.Text);
        frcEdit:
          Main.DataBase.UpdateRunApplication(FOperation.RunApplication.id, udPSort.Position,
            udWait.Position, edApplicationFileName.Text);
      end;
    end;

    self.ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmFastRCommand.cbRepeatPreviousClick(Sender: TObject);
var
  LEnabled: Boolean;
  LColor, LVColor: TColor;
begin
  LEnabled := not TCheckBox(Sender).Checked;
  if LEnabled then
  begin
    LColor := clBlack;
    LVColor := clWhite;
  end
  else
  begin
    LColor := clGrayText;
    LVColor := clBtnFace;
  end;

  edPSort.Enabled := LEnabled;
  udPSort.Enabled := LEnabled;
  edWait.Enabled := LEnabled;
  udWait.Enabled := LEnabled;

  dtsOperationType.Enabled := LEnabled;

  sbtnForApplication.Flat := LEnabled;
  sbtnForApplicationClear.Flat := LEnabled;
  sbtnApplicationFileName.Flat := LEnabled;
  sbtnRight.Flat := LEnabled;
  sbtnLeft.Flat := LEnabled;
  sbtnLeftAll.Flat := LEnabled;

  sbtnForApplication.Enabled := LEnabled;
  sbtnForApplicationClear.Enabled := LEnabled;
  sbtnApplicationFileName.Enabled := LEnabled;
  sbtnRight.Enabled := LEnabled;
  sbtnLeft.Enabled := LEnabled;
  sbtnLeftAll.Enabled := LEnabled;

  edForApplication.Enabled := LEnabled;
  edApplicationFileName.Enabled := LEnabled;

  lPSort.Font.Color := LColor;
  lWait.Font.Color := LColor;
  lWaitSecond.Font.Color := LColor;
  lForApplication.Font.Color := LColor;
  lApplicationFileName.Font.Color := LColor;
  dtsOperationType.Font.Color := LColor;

  lvDownKey.Enabled := LEnabled;
  lvDownKey.Color := LVColor;

  if lvDownKey.Items.Count < 3 then
  begin
    lvKeyboard.Enabled := LEnabled;
    lvKeyboard.Color := LVColor;
  end;
end;

procedure TfrmFastRCommand.dtsOperationTypeClick(Sender: TObject);
begin
  pcOperationType.ActivePageIndex := TDockTabSet(Sender).TabIndex;
end;

procedure TfrmFastRCommand.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmFastRCommand.lvDownKeyDblClick(Sender: TObject);
begin
  sbtnLeftClick(sbtnLeft);
end;

procedure TfrmFastRCommand.lvKeyboardDblClick(Sender: TObject);
begin
  sbtnRightClick(sbtnRight);
end;

procedure TfrmFastRCommand.sbtnForApplicationClick(Sender: TObject);
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

procedure TfrmFastRCommand.sbtnLeftAllClick(Sender: TObject);
begin
  lvDownKey.Items.Clear;
  lvKeyboard.Enabled := true;
  lvKeyboard.Color := clWhite;
end;

procedure TfrmFastRCommand.sbtnLeftClick(Sender: TObject);
begin
  if lvDownKey.Selected = nil then
    exit;

  lvDownKey.Items.Delete(lvDownKey.ItemIndex);
  lvDownKey.ItemIndex := -1;

  lvKeyboard.Enabled := not(lvDownKey.Items.Count >= 3);
  if lvDownKey.Items.Count >= 3 then
    lvKeyboard.Color := clBtnFace
  else
    lvKeyboard.Color := clWhite;
end;

procedure TfrmFastRCommand.sbtnRightClick(Sender: TObject);
begin
  if lvKeyboard.SelCount = 0 then
    exit;

  lvDownKey.Items.Add.Assign(lvKeyboard.Selected);
  lvKeyboard.ItemIndex := -1;

  lvKeyboard.Enabled := not(lvDownKey.Items.Count >= 3);
  if lvDownKey.Items.Count >= 3 then
    lvKeyboard.Color := clBtnFace
  else
    lvKeyboard.Color := clWhite;
end;

procedure TfrmFastRCommand.sbtnApplicationFileNameClick(Sender: TObject);
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
      ApplicationIcon(edApplicationFileName.Text, ImageApplication);
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TfrmFastRCommand.sbtnForApplicationClearClick(Sender: TObject);
begin
  edForApplication.Text := '';
end;

procedure TfrmFastRCommand.tsOperationChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  pcOperationType.ActivePageIndex := NewTab;
end;

procedure TfrmFastRCommand.udWaitChangingEx(Sender: TObject; var AllowChange: Boolean;
  NewValue: Integer; Direction: TUpDownDirection);
begin
  if (NewValue < TUpDown(Sender).Min) or (NewValue > TUpDown(Sender).Max) then
    exit;

  lWaitSecond.Caption := Format(GetLanguageText(self.Name, 'lWaitSecond', lngRus),
    [FloatToStr(NewValue / 1000)]);
end;

end.
