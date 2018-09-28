unit uOPressKeyboard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uLine, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Themes, System.ImageList, Vcl.ImgList, Vcl.Buttons, uDatabase,
  System.UITypes, Vcl.Tabs, Vcl.DockTabSet, ShellApi, Vcl.GraphUtil;

type
  TpkType = (pkAdd, pkEdit);

type
  TfrmOPressKeyboard = class(TForm)
    btnSave: TButton;
    pKeyboard: TPanel;
    btnCancel: TButton;
    pTop: TPanel;
    edPSort: TEdit;
    udPSort: TUpDown;
    lPSort: TLabel;
    dtsKeyboardType: TDockTabSet;
    lForApplication: TLabel;
    edForApplication: TEdit;
    sbtnForApplication: TSpeedButton;
    sbtnForApplicationClear: TSpeedButton;
    lDownKey: TLabel;
    edDownKey: TEdit;
    edWait: TEdit;
    udWait: TUpDown;
    lWait: TLabel;
    lWaitSecond: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure KeyboardClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelClick(Sender: TObject);
    procedure sbtnForApplicationClick(Sender: TObject);
    procedure sbtnForApplicationClearClick(Sender: TObject);
    procedure lvKeyboardDblClick(Sender: TObject);
    procedure lvDownKeyDblClick(Sender: TObject);
    procedure sbtnRightClick(Sender: TObject);
    procedure sbtnLeftClick(Sender: TObject);
    procedure sbtnLeftAllClick(Sender: TObject);
    procedure dtsKeyboardTypeClick(Sender: TObject);
    procedure udWaitChangingEx(Sender: TObject; var AllowChange: Boolean; NewValue: Integer;
      Direction: TUpDownDirection);
  private
    { Private declarations }
    FLineTop: TLine;
    FLineBottom: TLine;
    FpkType: TpkType;
    FID: Integer;
    FCommand: string;
    FDownKey: TStringList;
    FlvKeyboard: TListView;
    FlvDownKey: TListView;
    FpKeyboardType: TPanel;

    FKeyboardGroups: TKeyboardGroups;
    FKeyboards: TKeyboards;

    procedure drawKeyboard;
    procedure dropKeyboard;

    procedure drawKeyboardList;
    procedure dropKeyboardList;

    procedure formatDownKey;
  public
    { Public declarations }
    property pkType: TpkType read FpkType write FpkType;
    property Command: string write FCommand;
    property ID: Integer write FID;
    property DownKey: TStringList read FDownKey write FDownKey;
  end;

var
  frmOPressKeyboard: TfrmOPressKeyboard;

implementation

{$R *.dfm}

uses uLanguage, uMain, uIcon;

procedure TfrmOPressKeyboard.FormCreate(Sender: TObject);
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
    begin
      TEdit(self.Components[i]).Text := '';
      TEdit(self.Components[i]).TabStop := False;
      TEdit(self.Components[i]).ReadOnly := True;
    end;
    // Button
    if self.Components[i] is TButton then
      TButton(self.Components[i]).Caption := '';
    // Panel
    if self.Components[i] is TPanel then
      TPanel(self.Components[i]).Caption := '';
  end;

  UpdateLanguage(self, lngRus);

  FDownKey := TStringList.Create;
  FKeyboardGroups := main.DataBase.getKeyboardGroups;
  FKeyboards := main.DataBase.getKeyboards;

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

  Icon := TIcon.Create;
  try
    StockIcon(SIID_DELETE, Icon);
    sbtnForApplicationClear.Glyph.Width := Icon.Width;
    sbtnForApplicationClear.Glyph.Height := Icon.Height;
    sbtnForApplicationClear.Glyph.Canvas.Draw(0, 0, Icon);
    sbtnForApplicationClear.Flat := True;
  finally
    Icon.Free;
  end;

end;

procedure TfrmOPressKeyboard.FormShow(Sender: TObject);
begin
  drawKeyboard;
  FLineTop := TLine.Create(pTop, alBottom, clBlack, clBlack);
  // FLineBottom := TLine.Create(pKeyboard, alBottom, clWhite,
  // RGB(Random(256), Random(256), Random(256)));
  dtsKeyboardType.Top := 0;

  // GetHighlightColor(rgb(217, 217, 220)) = clBtnFace
  dtsKeyboardType.BackgroundColor := rgb(217, 217, 220);

  FpKeyboardType := TPanel.Create(pKeyboard);
  with FpKeyboardType do
  begin
    parent := pKeyboard;
    left := 0;
    Top := dtsKeyboardType.Top;
    Width := dtsKeyboardType.Width;
    Height := 2;
    ParentBackground := False;
    Color := clWhite;
    BevelOuter := bvNone;
    Caption := '';
    BringToFront;
  end;

  if FpkType = pkEdit then
    formatDownKey;
end;

procedure TfrmOPressKeyboard.FormDestroy(Sender: TObject);
begin
  FDownKey.Free;
  if Assigned(FpKeyboardType) then
    FpKeyboardType.Free;
  if Assigned(FLineTop) then
    FLineTop.Free;
  if Assigned(FLineBottom) then
    FLineBottom.Free;
end;

procedure TfrmOPressKeyboard.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  FDownKey.Clear;

  if (ssShift in Shift) then
  begin
    if GetAsyncKeyState(VK_LSHIFT) <> 0 then
      FDownKey.AddObject(main.DataBase.GetKeyboard(VK_LSHIFT).Desc, TObject(VK_LSHIFT));
    if GetAsyncKeyState(VK_RSHIFT) <> 0 then
      FDownKey.AddObject(main.DataBase.GetKeyboard(VK_RSHIFT).Desc, TObject(VK_RSHIFT));
  end;

  if (ssCtrl in Shift) then
  begin
    if GetAsyncKeyState(VK_LCONTROL) <> 0 then
      FDownKey.AddObject(main.DataBase.GetKeyboard(VK_LCONTROL).Desc, TObject(VK_LCONTROL));
    if GetAsyncKeyState(VK_RCONTROL) <> 0 then
      FDownKey.AddObject(main.DataBase.GetKeyboard(VK_RCONTROL).Desc, TObject(VK_RCONTROL));
  end;

  if (ssAlt in Shift) then
  begin
    if GetAsyncKeyState(VK_LMENU) <> 0 then
      FDownKey.AddObject(main.DataBase.GetKeyboard(VK_LMENU).Desc, TObject(VK_LMENU));
    if GetAsyncKeyState(VK_RMENU) <> 0 then
      FDownKey.AddObject(main.DataBase.GetKeyboard(VK_RMENU).Desc, TObject(VK_RMENU));
  end;

  if not((Key = VK_SHIFT) or (Key = VK_CONTROL) or (Key = VK_MENU)) then
    FDownKey.AddObject(main.DataBase.GetKeyboard(Key).Desc, TObject(Key));

  formatDownKey;

  Key := 0;
end;

procedure TfrmOPressKeyboard.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmOPressKeyboard.btnSaveClick(Sender: TObject);
var
  Key1, Key2, Key3: Integer;
begin
  Key1 := 0;
  Key2 := 0;
  Key3 := 0;

  if FDownKey.Count = 0 then
    exit;

  if FDownKey.Count >= 1 then
    Key1 := Integer(FDownKey.Objects[0]);
  if FDownKey.Count >= 2 then
    Key2 := Integer(FDownKey.Objects[1]);
  if FDownKey.Count >= 3 then
    Key3 := Integer(FDownKey.Objects[2]);

  try
    case FpkType of
      pkAdd:
        main.DataBase.CreatePressKeyboard(FCommand, udPSort.Position, udWait.Position, Key1, Key2,
          Key3, edForApplication.Text);
      pkEdit:
        main.DataBase.UpdatePressKeyboard(FID, udPSort.Position, udWait.Position, Key1, Key2, Key3,
          edForApplication.Text);
    end;

    self.ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmOPressKeyboard.dtsKeyboardTypeClick(Sender: TObject);
begin
  case dtsKeyboardType.TabIndex of
    0:
      begin
        dropKeyboardList;
        drawKeyboard;
      end;
    1:
      begin
        dropKeyboard;
        drawKeyboardList;
      end;
  end;
  formatDownKey;
end;

procedure TfrmOPressKeyboard.KeyboardClick(Sender: TObject);
var
  i: Integer;
  kk: TKeyboard;
  Key: Integer;
begin

  Key := TSpeedButton(Sender).Tag;

  if TSpeedButton(Sender).Down then
  begin
    kk := main.DataBase.GetKeyboard(Key);
    FDownKey.AddObject(kk.Desc, TObject(kk.Key));
  end
  else
    for i := 0 to FDownKey.Count - 1 do
      if Integer(FDownKey.Objects[i]) = Key then
      begin
        FDownKey.Delete(i);
        Break;
      end;

  formatDownKey;
end;

procedure TfrmOPressKeyboard.lvKeyboardDblClick(Sender: TObject);
begin
  sbtnRightClick(Sender);
end;

procedure TfrmOPressKeyboard.lvDownKeyDblClick(Sender: TObject);
begin
  sbtnLeftClick(Sender);
end;

procedure TfrmOPressKeyboard.sbtnRightClick(Sender: TObject);
var
  Key: TKeyboard;
begin
  if FlvKeyboard.SelCount = 0 then
    exit;

  Key := main.DataBase.GetKeyboard(Integer(FlvKeyboard.Selected.Data));
  FDownKey.AddObject(Key.Desc, TObject(Key.Key));
  FlvKeyboard.ItemIndex := -1;

  formatDownKey;
end;

procedure TfrmOPressKeyboard.sbtnLeftClick(Sender: TObject);
var
  i: Integer;
  Key: Integer;
begin
  if FlvDownKey.SelCount = 0 then
    exit;

  Key := Integer(FlvDownKey.Selected.Data);

  for i := 0 to FDownKey.Count - 1 do
    if Integer(FDownKey.Objects[i]) = Key then
    begin
      FDownKey.Delete(i);
      Break;
    end;

  formatDownKey;
end;

procedure TfrmOPressKeyboard.sbtnLeftAllClick(Sender: TObject);
begin
  FDownKey.Clear;
  formatDownKey;
end;

procedure TfrmOPressKeyboard.sbtnForApplicationClearClick(Sender: TObject);
begin
  edForApplication.Text := '';
end;

procedure TfrmOPressKeyboard.sbtnForApplicationClick(Sender: TObject);
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

procedure TfrmOPressKeyboard.udWaitChangingEx(Sender: TObject; var AllowChange: Boolean;
  NewValue: Integer; Direction: TUpDownDirection);
begin
  if (NewValue < TUpDown(Sender).Min) or (NewValue > TUpDown(Sender).Max) then
    exit;

  lWaitSecond.Caption := Format(GetLanguageText(self.Name, 'lWaitSecond', lngRus),
    [FloatToStr(NewValue / 1000)]);
end;

procedure TfrmOPressKeyboard.drawKeyboard;
var
  ALeft, ATop, DefLeft, DefWidth, DefHeight, DefSpaceWidth, DefSpaceHeight, AllWidth: Integer;

  procedure drawButton(btnKey: Integer; btnCaption: string; var btnLeft: Integer; btnWidth: Integer;
    btnHeight: Integer); overload;
  begin
    with TSpeedButton.Create(pKeyboard) do
    begin
      parent := pKeyboard;
      left := btnLeft;
      Top := ATop;
      Width := btnWidth;
      Height := btnHeight;
      // Caption := btnCaption;
      Hint := btnCaption;
      ShowHint := True;
      GroupIndex := btnKey;
      AllowAllUp := True;
      Tag := btnKey;
      // flat := true;

      OnClick := KeyboardClick;
    end;

    btnLeft := btnLeft + btnWidth + DefSpaceWidth;
  end;

  procedure drawButton(btnKey: Integer; btnCaption: string; var btnLeft: Integer;
    btnWidth: Integer); overload;
  begin
    drawButton(btnKey, btnCaption, btnLeft, btnWidth, DefHeight);
  end;

begin
  pKeyboard.Caption := '';

  DefLeft := 8;
  DefWidth := 18;
  DefHeight := 18;
  DefSpaceWidth := 0;
  DefSpaceHeight := 2;
  AllWidth := (DefWidth * 15) + (DefSpaceWidth * 14);

  ATop := 8;
  ALeft := DefLeft;
  drawButton(VK_ESCAPE, 'Esc', ALeft, DefWidth + round((DefWidth + DefSpaceWidth) / 2));
  ALeft := AllWidth - (12 * DefWidth) - (11 * DefSpaceWidth) - round(DefWidth / 2) + 1;
  drawButton(VK_F1, 'F1', ALeft, DefWidth);
  drawButton(VK_F2, 'F2', ALeft, DefWidth);
  drawButton(VK_F3, 'F3', ALeft, DefWidth);
  drawButton(VK_F4, 'F4', ALeft, DefWidth);
  ALeft := ALeft + round(DefWidth / 4);
  drawButton(VK_F5, 'F5', ALeft, DefWidth);
  drawButton(VK_F6, 'F6', ALeft, DefWidth);
  drawButton(VK_F7, 'F7', ALeft, DefWidth);
  drawButton(VK_F8, 'F8', ALeft, DefWidth);
  ALeft := ALeft + round(DefWidth / 4);
  drawButton(VK_F9, 'F9', ALeft, DefWidth);
  drawButton(VK_F10, 'F10', ALeft, DefWidth);
  drawButton(VK_F11, 'F11', ALeft, DefWidth);
  drawButton(VK_F12, 'F12', ALeft, DefWidth);
  ALeft := ALeft + (DefSpaceHeight * 4);
  drawButton(VK_SNAPSHOT, 'Prtint' + #13#10 + 'Screen', ALeft, DefWidth);
  drawButton(VK_SCROLL, 'Scroll' + #13#10 + 'Lock', ALeft, DefWidth);
  drawButton(-1, 'Pause' + #13#10 + 'Break', ALeft, DefWidth);

  ATop := ATop + DefHeight + (DefSpaceHeight * 4);
  ALeft := DefLeft;
  drawButton(VK_OEM_3, '`', ALeft, DefWidth);
  drawButton(VK1, '1', ALeft, DefWidth);
  drawButton(VK2, '2', ALeft, DefWidth);
  drawButton(VK3, '3', ALeft, DefWidth);
  drawButton(VK4, '4', ALeft, DefWidth);
  drawButton(VK5, '5', ALeft, DefWidth);
  drawButton(VK6, '6', ALeft, DefWidth);
  drawButton(VK7, '7', ALeft, DefWidth);
  drawButton(VK8, '8', ALeft, DefWidth);
  drawButton(VK9, '9', ALeft, DefWidth);
  drawButton(VK0, '0', ALeft, DefWidth);
  drawButton(VK_OEM_MINUS, '-', ALeft, DefWidth);
  drawButton(VK_OEM_PLUS, '=', ALeft, DefWidth);
  drawButton(VK_BACK, 'Backspace', ALeft, AllWidth - ALeft);
  ALeft := ALeft + (DefSpaceHeight * 4);
  drawButton(VK_INSERT, 'Insert', ALeft, DefWidth);
  drawButton(VK_HOME, 'Home', ALeft, DefWidth);
  drawButton(VK_PRIOR, 'Page' + #13#10 + 'Up', ALeft, DefWidth);
  ALeft := ALeft + (DefSpaceHeight * 4);
  drawButton(VK_NUMLOCK, 'Num' + #13#10 + 'Lock', ALeft, DefWidth);
  drawButton(VK_DIVIDE, '/', ALeft, DefWidth);
  drawButton(VK_MULTIPLY, '*', ALeft, DefWidth);
  drawButton(VK_SUBTRACT, '-', ALeft, DefWidth);

  ATop := ATop + DefHeight + DefSpaceHeight;
  ALeft := DefLeft;
  drawButton(VK_TAB, 'Tab', ALeft, DefWidth + round((DefWidth + DefSpaceWidth) / 2));
  drawButton(vkQ, 'Q', ALeft, DefWidth);
  drawButton(vkW, 'W', ALeft, DefWidth);
  drawButton(vkE, 'E', ALeft, DefWidth);
  drawButton(vkR, 'R', ALeft, DefWidth);
  drawButton(vkT, 'T', ALeft, DefWidth);
  drawButton(vkY, 'Y', ALeft, DefWidth);
  drawButton(vkU, 'U', ALeft, DefWidth);
  drawButton(vkI, 'I', ALeft, DefWidth);
  drawButton(vkO, 'O', ALeft, DefWidth);
  drawButton(vkP, 'P', ALeft, DefWidth);
  drawButton(VK_OEM_4, '[', ALeft, DefWidth);
  drawButton(VK_OEM_6, ']', ALeft, DefWidth);
  drawButton(VK_OEM_5, '\', ALeft, AllWidth - ALeft);
  ALeft := ALeft + (DefSpaceHeight * 4);
  drawButton(VK_DELETE, 'Delete', ALeft, DefWidth);
  drawButton(VK_END, 'End', ALeft, DefWidth);
  drawButton(VK_NEXT, 'Page' + #13#10 + 'Down', ALeft, DefWidth);
  ALeft := ALeft + (DefSpaceHeight * 4);
  drawButton(VK_NUMPAD7, '7', ALeft, DefWidth);
  drawButton(VK_NUMPAD8, '8', ALeft, DefWidth);
  drawButton(VK_NUMPAD9, '9', ALeft, DefWidth);
  drawButton(VK_ADD, '+', ALeft, DefWidth, DefHeight + DefSpaceHeight + DefHeight);

  ATop := ATop + DefHeight + DefSpaceHeight;
  ALeft := DefLeft;
  drawButton(VK_CAPITAL, 'Caps Lock', ALeft, (DefWidth * 2) + DefSpaceWidth);
  drawButton(vkA, 'A', ALeft, DefWidth);
  drawButton(vkS, 'S', ALeft, DefWidth);
  drawButton(vkD, 'D', ALeft, DefWidth);
  drawButton(vkF, 'F', ALeft, DefWidth);
  drawButton(vkG, 'G', ALeft, DefWidth);
  drawButton(vkH, 'H', ALeft, DefWidth);
  drawButton(vkJ, 'J', ALeft, DefWidth);
  drawButton(vkK, 'K', ALeft, DefWidth);
  drawButton(vkL, 'L', ALeft, DefWidth);
  drawButton(VK_OEM_1, ';', ALeft, DefWidth);
  drawButton(VK_OEM_7, '''', ALeft, DefWidth);
  drawButton(VK_RETURN, 'Enter', ALeft, AllWidth - ALeft);
  ALeft := ALeft + (DefSpaceHeight * 4);
  // DefWidth := 38;
  ALeft := ALeft + (DefWidth * 3);
  // DefWidth := 36;
  ALeft := ALeft + (DefSpaceHeight * 4);
  drawButton(VK_NUMPAD4, '4', ALeft, DefWidth);
  drawButton(VK_NUMPAD5, '5', ALeft, DefWidth);
  drawButton(VK_NUMPAD6, '6', ALeft, DefWidth);

  ATop := ATop + DefHeight + DefSpaceHeight;
  ALeft := DefLeft;
  drawButton(VK_LSHIFT, 'Shift', ALeft, (DefWidth * 2) + DefSpaceWidth +
    round((DefWidth + DefSpaceWidth) / 2));
  drawButton(vkZ, 'Z', ALeft, DefWidth);
  drawButton(vkX, 'X', ALeft, DefWidth);
  drawButton(vkC, 'C', ALeft, DefWidth);
  drawButton(vkV, 'V', ALeft, DefWidth);
  drawButton(vkB, 'B', ALeft, DefWidth);
  drawButton(vkN, 'N', ALeft, DefWidth);
  drawButton(vkM, 'M', ALeft, DefWidth);
  drawButton(VK_OEM_COMMA, ',', ALeft, DefWidth);
  drawButton(VK_OEM_PERIOD, '.', ALeft, DefWidth);
  drawButton(VK_OEM_2, '/', ALeft, DefWidth);
  drawButton(VK_RSHIFT, 'Shift', ALeft, AllWidth - ALeft);
  ALeft := ALeft + (DefSpaceHeight * 4) + DefWidth + DefSpaceWidth;
  ALeft := ALeft + DefSpaceWidth;
  drawButton(VK_UP, '↑', ALeft, DefWidth);
  ALeft := ALeft + DefSpaceWidth;
  ALeft := ALeft + (DefSpaceHeight * 4) + DefWidth + DefSpaceWidth;
  drawButton(VK_NUMPAD1, '1', ALeft, DefWidth);
  drawButton(VK_NUMPAD2, '2', ALeft, DefWidth);
  drawButton(VK_NUMPAD3, '3', ALeft, DefWidth);
  drawButton(VK_RETURN, 'Enter', ALeft, DefWidth, DefHeight + DefSpaceHeight + DefHeight);

  ATop := ATop + DefHeight + DefSpaceHeight;
  ALeft := DefLeft;
  drawButton(VK_LCONTROL, 'Ctrl', ALeft, DefWidth + round(DefWidth / 2) - DefSpaceWidth);
  drawButton(VK_LWIN, 'Win', ALeft, DefWidth + round(DefWidth / 2) - DefSpaceWidth);
  drawButton(VK_LMENU, 'Alt', ALeft, DefWidth + round(DefWidth / 2) - DefSpaceWidth);
  drawButton(VK_SPACE, 'Пробел', ALeft, AllWidth - ((DefWidth + round(DefWidth / 2)) * 7) -
    DefSpaceWidth);
  drawButton(VK_RMENU, 'Alt', ALeft, DefWidth + round(DefWidth / 2) - DefSpaceWidth);
  drawButton(VK_RWIN, 'Win', ALeft, DefWidth + round(DefWidth / 2) - DefSpaceWidth);
  drawButton(VK_APPS, 'Ξ', ALeft, DefWidth + round(DefWidth / 2) - DefSpaceWidth);
  drawButton(VK_RCONTROL, 'Ctrl', ALeft, AllWidth - ALeft);
  ALeft := ALeft + (DefSpaceHeight * 4);
  drawButton(VK_LEFT, '←', ALeft, DefWidth);
  drawButton(VK_DOWN, '↓', ALeft, DefWidth);
  drawButton(VK_RIGHT, '→', ALeft, DefWidth);
  ALeft := ALeft + (DefSpaceHeight * 4);
  drawButton(VK_NUMPAD0, '0', ALeft, DefWidth + DefSpaceWidth + DefWidth);
  drawButton(VK_DECIMAL, '.', ALeft, DefWidth);

  // pKeyboard.Width := ALeft + DefWidth + 8;
  pKeyboard.Height := ATop + DefHeight + 8 + dtsKeyboardType.Height;
  self.ClientWidth := ALeft + DefWidth + 8;
  self.ClientHeight := pKeyboard.Top + pKeyboard.Height + btnCancel.Height + 8 + 8 - 22;
  btnSave.BringToFront;
end;

procedure TfrmOPressKeyboard.dropKeyboard;
var
  i: Integer;
begin
  for i := pKeyboard.ComponentCount - 1 downto 0 do
    if (pKeyboard.Components[i] is TSpeedButton) then
      TSpeedButton(pKeyboard.Components[i]).Free;
end;

procedure TfrmOPressKeyboard.drawKeyboardList;
var
  i, LClientHieght, sm: Integer;
  LColumn: TListColumn;
  Icon: TIcon;
begin

  sm := 20;
  LClientHieght := pKeyboard.Height - 8 - 8 - dtsKeyboardType.Height;

  FlvKeyboard := TListView.Create(pKeyboard);
  with FlvKeyboard do
  begin
    left := 8;
    Top := 8;
    Width := round(pKeyboard.Width / 2) - 18 - 8 + sm;
    Height := LClientHieght;
    parent := pKeyboard;

    // BorderStyle := bsNone;
    ViewStyle := vsReport;
    ReadOnly := True;
    RowSelect := True;
    ColumnClick := False;
    ShowColumnHeaders := False;
    GroupView := True;
    TabStop := False;
    OnDblClick := lvKeyboardDblClick;

    LColumn := Columns.Add;
    LColumn.Width := Width - 21;

    for i := 0 to length(FKeyboardGroups) - 1 do
      with Groups.Add do
      begin
        Header := FKeyboardGroups[i].Description;
        GroupID := FKeyboardGroups[i].Group;
        State := State + [lgsCollapsible];
      end;

    Items.BeginUpdate;
    for i := 0 to length(FKeyboards) - 1 do
      with Items.Add do
      begin
        Caption := FKeyboards[i].Desc;
        GroupID := FKeyboards[i].Group;
        Data := Pointer(FKeyboards[i].Key);
      end;
    Items.EndUpdate;
  end;

  FlvDownKey := TListView.Create(pKeyboard);
  with FlvDownKey do
  begin
    left := round(pKeyboard.Width / 2) + 18 + sm;
    Top := 8;
    Width := round(pKeyboard.Width / 2) - 18 - 8 - sm;
    Height := LClientHieght;
    parent := pKeyboard;

    ViewStyle := vsReport;
    ReadOnly := True;
    RowSelect := True;
    ColumnClick := False;
    ShowColumnHeaders := False;
    GroupView := False;
    TabStop := False;
    OnDblClick := lvDownKeyDblClick;

    LColumn := Columns.Add;
    LColumn.Width := Width - 4;
  end;

  with TSpeedButton.Create(pKeyboard) do
  begin
    parent := pKeyboard;
    left := round(pKeyboard.Width / 2) - 18 + 6 + sm;
    Top := round(LClientHieght / 2) - 35 + 8;
    Width := 24;
    Height := 22;
    OnClick := sbtnRightClick;

    Icon := TIcon.Create;
    try
      main.ilSmall.GetIcon(17, Icon);
      Glyph.Width := Icon.Width;
      Glyph.Height := Icon.Height;
      Glyph.Canvas.Draw(0, 0, Icon);
    finally
      Icon.Free;
    end;
  end;

  with TSpeedButton.Create(pKeyboard) do
  begin
    parent := pKeyboard;
    left := round(pKeyboard.Width / 2) - 18 + 6 + sm;
    Top := round(LClientHieght / 2) - 11 + 8;
    Width := 24;
    Height := 22;
    OnClick := sbtnLeftClick;

    Icon := TIcon.Create;
    try
      main.ilSmall.GetIcon(16, Icon);
      Glyph.Width := Icon.Width;
      Glyph.Height := Icon.Height;
      Glyph.Canvas.Draw(0, 0, Icon);
    finally
      Icon.Free;
    end;
  end;

  with TSpeedButton.Create(pKeyboard) do
  begin
    parent := pKeyboard;
    left := round(pKeyboard.Width / 2) - 18 + 6 + sm;
    Top := round(LClientHieght / 2) + 13 + 8;
    Width := 24;
    Height := 22;
    OnClick := sbtnLeftAllClick;

    Icon := TIcon.Create;
    try
      main.ilSmall.GetIcon(15, Icon);
      Glyph.Width := Icon.Width;
      Glyph.Height := Icon.Height;
      Glyph.Canvas.Draw(0, 0, Icon);
    finally
      Icon.Free;
    end;
  end;

end;

procedure TfrmOPressKeyboard.dropKeyboardList;
var
  i: Integer;
begin
  for i := pKeyboard.ComponentCount - 1 downto 0 do
    if (pKeyboard.Components[i] is TSpeedButton) or (pKeyboard.Components[i] is TListView) then
      pKeyboard.Components[i].Free;
end;

procedure TfrmOPressKeyboard.formatDownKey;
var
  i, j: Integer;
begin
  if FDownKey.Count = 0 then
    edDownKey.Text := 'Нажмите кнопку'
  else
    for i := 0 to FDownKey.Count - 1 do
      if i = 0 then
        edDownKey.Text := FDownKey[i]
      else
        edDownKey.Text := edDownKey.Text + ' + ' + FDownKey[i];

  case dtsKeyboardType.TabIndex of
    0: // Клавиатура
      begin

        for i := 0 to pKeyboard.ComponentCount - 1 do
          if (pKeyboard.Components[i] is TSpeedButton) then
            TSpeedButton(pKeyboard.Components[i]).Down := False;

        // нажимаю кнопки
        for i := 0 to pKeyboard.ComponentCount - 1 do
          if (pKeyboard.Components[i] is TSpeedButton) then
            for j := 0 to FDownKey.Count - 1 do
              if (TSpeedButton(pKeyboard.Components[i]).Tag = Integer(FDownKey.Objects[j])) then
              begin
                TSpeedButton(pKeyboard.Components[i]).Down := True;
                TSpeedButton(pKeyboard.Components[i]).Enabled := True;
                Break;
              end;

        for i := 0 to pKeyboard.ComponentCount - 1 do
          if (pKeyboard.Components[i] is TSpeedButton) and
            not(TSpeedButton(pKeyboard.Components[i]).Down) then
            TSpeedButton(pKeyboard.Components[i]).Enabled := not(FDownKey.Count >= 3);
      end;
    1: // Ручной режим
      begin
        FlvDownKey.Items.BeginUpdate;
        FlvDownKey.Items.Clear;
        for i := 0 to FDownKey.Count - 1 do
          with FlvDownKey.Items.Add do
          begin
            Caption := FDownKey[i];
            Data := Pointer(Integer(FDownKey.Objects[i]));
          end;
        FlvDownKey.Items.EndUpdate;

        FlvKeyboard.Enabled := not(FDownKey.Count >= 3);
        if FDownKey.Count >= 3 then
          FlvKeyboard.Color := clBtnFace
        else
          FlvKeyboard.Color := clWhite;

      end;
  end;

end;

end.
