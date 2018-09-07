unit uOPressKeyboard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uLine, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Themes, System.ImageList, Vcl.ImgList, Vcl.Buttons, uDatabase,
  System.UITypes;

type
  TpkType = (pkAdd, pkEdit);

type
  TfrmOPressKeyboard = class(TForm)
    btnSave: TButton;
    pKeyboard: TPanel;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure KeyboardClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    FLine: TLine;
    FpkType: TpkType;
    FID: integer;
    FCommand: string;
    FDownKey: TStringList;
    FPanelPressKeyboard: TPanel;

    // FKeyboardGroups: TKeyboardGroups;
    // FKeyboards: TKeyboards;

    procedure drawKeyboard;
    procedure formatKeyboard;
  public
    { Public declarations }
    property pkType: TpkType read FpkType write FpkType;
    property Command: string write FCommand;
    property ID: integer write FID;
    property DownKey: TStringList read FDownKey write FDownKey;
  end;

var
  frmOPressKeyboard: TfrmOPressKeyboard;

implementation

{$R *.dfm}

uses uLanguage, uMain;

procedure TfrmOPressKeyboard.FormCreate(Sender: TObject);
begin
  FDownKey := TStringList.Create;

  UpdateLanguage(self, lngRus);

  // FKeyboardGroups := main.DataBase.getKeyboardGroups;
  // FKeyboards := main.DataBase.getKeyboards;
end;

procedure TfrmOPressKeyboard.FormShow(Sender: TObject);
var
  i, j: integer;
begin
  drawKeyboard;
  // FLine := TLine.Create(pKeyboard, alBottom, clWhite, clLime);
  FLine := TLine.Create(pKeyboard, alBottom, clWhite, RGB(Random(256), Random(256), Random(256)));

  if FpkType = pkEdit then
  begin
    for i := 0 to DownKey.Count - 1 do
      for j := 0 to pKeyboard.ComponentCount - 1 do
        if (pKeyboard.Components[j] is TSpeedButton) and
          (TSpeedButton(pKeyboard.Components[j]).Tag = integer(DownKey.Objects[i])) then
        begin
          TSpeedButton(pKeyboard.Components[j]).Down := true;
          Break
        end;
    formatKeyboard;
  end;
end;

procedure TfrmOPressKeyboard.FormDestroy(Sender: TObject);
begin
  FDownKey.Free;
  FLine.Free;
end;

procedure TfrmOPressKeyboard.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  i, j: integer;
  keyboard: TKeyboard;
begin

  FDownKey.Clear;

  for i := 0 to pKeyboard.ComponentCount - 1 do
    if (pKeyboard.Components[i] is TSpeedButton) then
      TSpeedButton(pKeyboard.Components[i]).Down := false;

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

  for i := 0 to pKeyboard.ComponentCount - 1 do
    if (pKeyboard.Components[i] is TSpeedButton) then
      for j := 0 to FDownKey.Count - 1 do
        if (TSpeedButton(pKeyboard.Components[i]).Tag = integer(FDownKey.Objects[j])) then
          TSpeedButton(pKeyboard.Components[i]).Down := true;

  // FPanelPressKeyboard.Caption := IntToHex(Key, 1);
  formatKeyboard;

  Key := 0;
end;

procedure TfrmOPressKeyboard.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmOPressKeyboard.btnSaveClick(Sender: TObject);
var
  Key1, Key2, Key3: integer;
begin
  Key1 := 0;
  Key2 := 0;
  Key3 := 0;

  if FDownKey.Count = 0 then
    exit;

  if FDownKey.Count >= 1 then
    Key1 := integer(FDownKey.Objects[0]);
  if FDownKey.Count >= 2 then
    Key2 := integer(FDownKey.Objects[1]);
  if FDownKey.Count >= 3 then
    Key3 := integer(FDownKey.Objects[2]);

  try
    case FpkType of
      pkAdd:
        main.DataBase.CreatePressKeyboard(FCommand, Key1, Key2, Key3);
      pkEdit:
        main.DataBase.UpdatePressKeyboard(FID, Key1, Key2, Key3);
    end;

    self.ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmOPressKeyboard.KeyboardClick(Sender: TObject);
var
  i: integer;
  kk: TKeyboard;
  Key: integer;
begin

  Key := TSpeedButton(Sender).Tag;

  if TSpeedButton(Sender).Down then
  begin
    kk := main.DataBase.GetKeyboard(Key);
    FDownKey.AddObject(kk.Desc, TObject(kk.Key));
  end
  else
    for i := 0 to FDownKey.Count - 1 do
      if integer(FDownKey.Objects[i]) = Key then
      begin
        FDownKey.Delete(i);
        Break;
      end;

  formatKeyboard;

end;

procedure TfrmOPressKeyboard.drawKeyboard;
var
  ALeft, ATop, DefWidth, DefHeight, DefSpace, AllWidth, DefLeft: integer;

  procedure drawButton(btnKey: integer; btnCaption: string; var btnLeft: integer; btnWidth: integer;
    btnHeight: integer); overload;
  begin
    with TSpeedButton.Create(pKeyboard) do
    begin
      parent := pKeyboard;
      Left := btnLeft;
      top := ATop;
      Width := btnWidth;
      height := btnHeight;
      Caption := btnCaption;
      GroupIndex := btnKey;
      AllowAllUp := true;
      Tag := btnKey;
      flat := false;

      OnClick := KeyboardClick;
    end;

    btnLeft := btnLeft + btnWidth + DefSpace;
  end;

  procedure drawButton(btnKey: integer; btnCaption: string; var btnLeft: integer;
    btnWidth: integer); overload;
  begin
    drawButton(btnKey, btnCaption, btnLeft, btnWidth, DefHeight);
  end;

begin
  pKeyboard.Caption := '';

  DefLeft := 8;
  DefWidth := 36;
  DefHeight := 36;
  DefSpace := 2;
  AllWidth := (DefWidth * 15) + (DefSpace * 14);

  ATop := 8;
  ALeft := DefLeft;
  drawButton(VK_ESCAPE, 'Esc', ALeft, DefWidth + round((DefWidth + DefSpace) / 2));
  ALeft := AllWidth - (12 * DefWidth) - (11 * DefSpace) - round(DefWidth / 2);
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

  FPanelPressKeyboard := TPanel.Create(pKeyboard);
  with FPanelPressKeyboard do
  begin
    parent := pKeyboard;
    BevelOuter := bvNone;
    BorderStyle := bsSingle;
    Ctl3D := false;
    Left := ALeft + (DefSpace * 4) + 1;
    top := ATop + 1;
    Width := (DefWidth * 7) + (DefSpace * 5) + (DefSpace * 4) + 6;
    height := DefHeight - 2;
    font.Size := 11;
    font.Style := [fsBold];
  end;

  ATop := ATop + DefHeight + (DefSpace * 4);
  ALeft := DefLeft;
  drawButton(VK_OEM_3, '`', ALeft, DefWidth);
  drawButton(VK1, '!' + #13#10 + '1', ALeft, DefWidth);
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
  ALeft := ALeft + (DefSpace * 4);
  DefWidth := 38;
  drawButton(VK_SNAPSHOT, 'Prtint' + #13#10 + 'Screen', ALeft, DefWidth);
  drawButton(VK_SCROLL, 'Scroll' + #13#10 + 'Lock', ALeft, DefWidth);
  drawButton(-1, 'Pause' + #13#10 + 'Break', ALeft, DefWidth);
  DefWidth := 36;
  ALeft := ALeft + (DefSpace * 4);
  drawButton(VK_NUMLOCK, 'Num' + #13#10 + 'Lock', ALeft, DefWidth);
  drawButton(VK_DIVIDE, '/', ALeft, DefWidth);
  drawButton(VK_MULTIPLY, '*', ALeft, DefWidth);
  drawButton(VK_SUBTRACT, '-', ALeft, DefWidth);

  ATop := ATop + DefHeight + DefSpace;
  ALeft := DefLeft;
  drawButton(VK_TAB, 'Tab', ALeft, DefWidth + round((DefWidth + DefSpace) / 2));
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
  ALeft := ALeft + (DefSpace * 4);
  DefWidth := 38;
  drawButton(VK_INSERT, 'Insert', ALeft, DefWidth);
  drawButton(VK_HOME, 'Home', ALeft, DefWidth);
  drawButton(VK_PRIOR, 'Page' + #13#10 + 'Up', ALeft, DefWidth);
  DefWidth := 36;
  ALeft := ALeft + (DefSpace * 4);
  drawButton(VK_NUMPAD7, '7', ALeft, DefWidth);
  drawButton(VK_NUMPAD8, '8', ALeft, DefWidth);
  drawButton(VK_NUMPAD9, '9', ALeft, DefWidth);
  drawButton(VK_ADD, '+', ALeft, DefWidth, DefHeight + DefSpace + DefHeight);

  ATop := ATop + DefHeight + DefSpace;
  ALeft := DefLeft;
  drawButton(VK_CAPITAL, 'Caps Lock', ALeft, (DefWidth * 2) + DefSpace);
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
  ALeft := ALeft + (DefSpace * 4);
  DefWidth := 38;
  drawButton(VK_DELETE, 'Delete', ALeft, DefWidth);
  drawButton(VK_END, 'End', ALeft, DefWidth);
  drawButton(VK_NEXT, 'Page' + #13#10 + 'Down', ALeft, DefWidth);
  DefWidth := 36;
  ALeft := ALeft + (DefSpace * 4);
  drawButton(VK_NUMPAD4, '4', ALeft, DefWidth);
  drawButton(VK_NUMPAD5, '5', ALeft, DefWidth);
  drawButton(VK_NUMPAD6, '6', ALeft, DefWidth);

  ATop := ATop + DefHeight + DefSpace;
  ALeft := DefLeft;
  drawButton(VK_LSHIFT, 'Shift', ALeft, (DefWidth * 2) + DefSpace +
    round((DefWidth + DefSpace) / 2));
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
  ALeft := ALeft + (DefSpace * 4) + DefWidth + DefSpace;
  DefWidth := 38;
  ALeft := ALeft + 2;
  drawButton(VK_UP, '↑', ALeft, DefWidth);
  ALeft := ALeft + 2;
  DefWidth := 36;
  ALeft := ALeft + (DefSpace * 4) + DefWidth + DefSpace;
  drawButton(VK_NUMPAD1, '1', ALeft, DefWidth);
  drawButton(VK_NUMPAD2, '2', ALeft, DefWidth);
  drawButton(VK_NUMPAD3, '3', ALeft, DefWidth);
  drawButton(VK_RETURN, 'Enter', ALeft, DefWidth, DefHeight + DefSpace + DefHeight);

  ATop := ATop + DefHeight + DefSpace;
  ALeft := DefLeft;
  drawButton(VK_LCONTROL, 'Ctrl', ALeft, DefWidth + round(DefWidth / 2) - DefSpace);
  drawButton(VK_LWIN, 'Win', ALeft, DefWidth + round(DefWidth / 2) - DefSpace);
  drawButton(VK_LMENU, 'Alt', ALeft, DefWidth + round(DefWidth / 2) - DefSpace);
  drawButton(VK_SPACE, 'Пробел', ALeft, AllWidth - ((DefWidth + round(DefWidth / 2)) * 7) -
    DefSpace);
  drawButton(VK_RMENU, 'Alt', ALeft, DefWidth + round(DefWidth / 2) - DefSpace);
  drawButton(VK_RWIN, 'Win', ALeft, DefWidth + round(DefWidth / 2) - DefSpace);
  drawButton(VK_APPS, '_', ALeft, DefWidth + round(DefWidth / 2) - DefSpace);
  drawButton(VK_RCONTROL, 'Ctrl', ALeft, AllWidth - ALeft);
  ALeft := ALeft + (DefSpace * 4);
  DefWidth := 38;
  drawButton(VK_LEFT, '←', ALeft, DefWidth);
  drawButton(VK_DOWN, '↓', ALeft, DefWidth);
  drawButton(VK_RIGHT, '→', ALeft, DefWidth);
  DefWidth := 36;
  ALeft := ALeft + (DefSpace * 4);
  drawButton(VK_NUMPAD0, '0', ALeft, DefWidth + DefSpace + DefWidth);
  drawButton(VK_DECIMAL, '.', ALeft, DefWidth);

  pKeyboard.Width := ALeft + DefWidth + 8;
  pKeyboard.height := ATop + DefHeight + 8;
  self.ClientWidth := pKeyboard.Width;
  self.ClientHeight := pKeyboard.height + btnCancel.height + 8 + 8;
end;

procedure TfrmOPressKeyboard.formatKeyboard;
var
  i: integer;
begin
  if FDownKey.Count = 0 then
    FPanelPressKeyboard.Caption := 'Нажмите кнопку'
  else
    FPanelPressKeyboard.Caption := '';

  for i := 0 to FDownKey.Count - 1 do
    if i = 0 then
      FPanelPressKeyboard.Caption := FDownKey[i]
    else
      FPanelPressKeyboard.Caption := FPanelPressKeyboard.Caption + ' + ' + FDownKey[i];

  if FDownKey.Count >= 3 then
  begin
    for i := 0 to pKeyboard.ComponentCount - 1 do
      if (pKeyboard.Components[i] is TSpeedButton) and not TSpeedButton(pKeyboard.Components[i]).Down
      then
        TSpeedButton(pKeyboard.Components[i]).Enabled := false;
  end
  else
    for i := 0 to pKeyboard.ComponentCount - 1 do
      if (pKeyboard.Components[i] is TSpeedButton) then
        TSpeedButton(pKeyboard.Components[i]).Enabled := true;
end;

end.
