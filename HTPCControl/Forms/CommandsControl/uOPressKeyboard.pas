unit uOPressKeyboard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uLine, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Themes, System.ImageList, Vcl.ImgList, Vcl.Buttons, uDatabase;

type
  TpkType = (pkAdd, pkEdit);

type
  TfrmOPressKeyboard = class(TForm)
    btnCancel: TButton;
    btnSave: TButton;
    pTop: TPanel;
    pKeyboard: TPanel;
    edKeyboard: TEdit;
    cbLongPress: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure KeyboardClick(Sender: TObject);
  private
    { Private declarations }
    FLine: TLine;
    FpkType: TpkType;
    FID: integer;
    FCommand: string;
    FList: TStringList;

    FKeyboardGroups: TKeyboardGroups;
    FKeyboards: TKeyboards;

    procedure drawKeyboard;
  public
    { Public declarations }
    property pkType: TpkType read FpkType write FpkType;
    property Command: string write FCommand;
    property ID: integer write FID;
  end;

var
  frmOPressKeyboard: TfrmOPressKeyboard;

implementation

{$R *.dfm}

uses uLanguage, uMain;

procedure TfrmOPressKeyboard.FormCreate(Sender: TObject);
var
  i: integer;
begin
  pTop.Caption := '';

  FLine := TLine.Create(pTop, alBottom, clWhite, clLime);
  FList := TStringList.Create;

  UpdateLanguage(self, lngRus);

  FKeyboardGroups := main.DataBase.getKeyboardGroups;
  FKeyboards := main.DataBase.getKeyboards;
end;

procedure TfrmOPressKeyboard.FormShow(Sender: TObject);
begin
  drawKeyboard;
end;

procedure TfrmOPressKeyboard.KeyboardClick(Sender: TObject);
var
  i: integer;
  kk: TKeyboard;
  key: integer;
begin

  key := TSpeedButton(Sender).Tag;

  if TSpeedButton(Sender).Down then
  begin
    kk := main.DataBase.GetKeyboard(key);
    FList.AddObject(kk.Desc, TObject(kk.key));
  end
  else
  begin
    for i := 0 to FList.Count - 1 do
      if integer(FList.Objects[i]) = key then
      begin
        FList.Delete(i);
        Break;
      end;
  end;

  edKeyboard.Text := '';

  for i := 0 to FList.Count - 1 do
    if i = 0 then
      edKeyboard.Text := FList[i]
    else
      edKeyboard.Text := edKeyboard.Text + ' + ' + FList[i];

  if FList.Count >= 3 then
  begin
    for i := 0 to pKeyboard.ComponentCount - 1 do
      if (pKeyboard.Components[i] is TSpeedButton) and not TSpeedButton(pKeyboard.Components[i]).Down
      then
        TSpeedButton(pKeyboard.Components[i]).Enabled := false;
  end
  else
    for i := 0 to pKeyboard.ComponentCount - 1 do
      if (pKeyboard.Components[i] is TSpeedButton) and not TSpeedButton(pKeyboard.Components[i]).Down
      then
        TSpeedButton(pKeyboard.Components[i]).Enabled := true;

end;

procedure TfrmOPressKeyboard.FormDestroy(Sender: TObject);
begin
  FList.Free;
  FLine.Free;
end;

procedure TfrmOPressKeyboard.btnSaveClick(Sender: TObject);
var
  Key1, Key2, Key3: integer;
begin
  Key1 := 0;
  Key2 := 0;
  Key3 := 0;

  if FList.Count = 0 then
    exit;
  try
    Key1 := integer(FList.Objects[0]);
    Key2 := integer(FList.Objects[1]);
    Key3 := integer(FList.Objects[2]);
  except
  end;

  try
    case FpkType of
      pkAdd:
        main.DataBase.CreatePressKeyKeyboard(FCommand, Key1, Key2, Key3, cbLongPress.Checked);
      // pkEdit:
      // Main.DataBase.UpdateRunApplication(FID, edApplicationFileName.Text);
    end;

    self.ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmOPressKeyboard.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmOPressKeyboard.drawKeyboard;
var
  ALeft, ATop, DefWidth, DefHeight, DefSpace, AllWidth: integer;

  procedure drawButton(btnKey: integer; btnCaption: string; var btnLeft: integer; btnWidth: integer;
    btnHeight: integer = 40); overload;
  begin
    with TSpeedButton.Create(pKeyboard) do
    begin
      parent := pKeyboard;
      Left := btnLeft;
      top := ATop;
      width := btnWidth;
      height := btnHeight;
      Caption := btnCaption;
      GroupIndex := btnKey;
      AllowAllUp := true;
      Tag := btnKey;

      OnClick := KeyboardClick;
    end;

    btnLeft := btnLeft + btnWidth + DefSpace;
  end;

begin
  pKeyboard.Caption := '';

  DefWidth := 40;
  DefHeight := 40;
  DefSpace := 2;
  AllWidth := (DefWidth * 15) + (DefSpace * 14);

  ATop := 3;
  ALeft := 3;
  drawButton(27, 'Esc', ALeft, DefWidth + round((DefWidth + DefSpace) / 2));
  ALeft := AllWidth - (12 * DefWidth) - (11 * DefSpace) - round(DefWidth / 2);
  drawButton(112, 'F1', ALeft, DefWidth);
  drawButton(113, 'F2', ALeft, DefWidth);
  drawButton(114, 'F3', ALeft, DefWidth);
  drawButton(115, 'F4', ALeft, DefWidth);
  ALeft := ALeft + round(DefWidth / 4);
  drawButton(116, 'F5', ALeft, DefWidth);
  drawButton(117, 'F6', ALeft, DefWidth);
  drawButton(118, 'F7', ALeft, DefWidth);
  drawButton(119, 'F8', ALeft, DefWidth);
  ALeft := ALeft + round(DefWidth / 4);
  drawButton(120, 'F9', ALeft, DefWidth);
  drawButton(121, 'F10', ALeft, DefWidth);
  drawButton(122, 'F11', ALeft, DefWidth);
  drawButton(123, 'F12', ALeft, DefWidth);

  ATop := ATop + DefHeight + (DefSpace * 4);
  ALeft := 3;
  drawButton(192, '`', ALeft, DefWidth);
  drawButton(49, '1', ALeft, DefWidth);
  drawButton(50, '2', ALeft, DefWidth);
  drawButton(51, '3', ALeft, DefWidth);
  drawButton(52, '4', ALeft, DefWidth);
  drawButton(53, '5', ALeft, DefWidth);
  drawButton(54, '6', ALeft, DefWidth);
  drawButton(55, '7', ALeft, DefWidth);
  drawButton(56, '8', ALeft, DefWidth);
  drawButton(57, '9', ALeft, DefWidth);
  drawButton(48, '0', ALeft, DefWidth);
  drawButton(189, '-', ALeft, DefWidth);
  drawButton(187, '=', ALeft, DefWidth);
  drawButton(8, 'Backspace', ALeft, AllWidth - ALeft);
  ALeft := ALeft + (DefSpace * 4);
  drawButton(44, 'PrtScr' + #13#10 + 'SysRq', ALeft, DefWidth);
  drawButton(145, 'Scroll' + #13#10 + 'Lock', ALeft, DefWidth);
  drawButton(-1, 'Pause' + #13#10 + 'Break', ALeft, DefWidth);
  ALeft := ALeft + (DefSpace * 4);
  drawButton(144, 'Num' + #13#10 + 'Lock', ALeft, DefWidth);
  drawButton(-1, '/', ALeft, DefWidth);
  drawButton(-1, '*', ALeft, DefWidth);
  drawButton(-1, '-', ALeft, DefWidth);

  ATop := ATop + DefHeight + DefSpace;
  ALeft := 3;
  drawButton(9, 'Tab', ALeft, DefWidth + round((DefWidth + DefSpace) / 2));
  drawButton(81, 'Q', ALeft, DefWidth);
  drawButton(87, 'W', ALeft, DefWidth);
  drawButton(69, 'E', ALeft, DefWidth);
  drawButton(82, 'R', ALeft, DefWidth);
  drawButton(84, 'T', ALeft, DefWidth);
  drawButton(89, 'Y', ALeft, DefWidth);
  drawButton(85, 'U', ALeft, DefWidth);
  drawButton(73, 'I', ALeft, DefWidth);
  drawButton(79, 'O', ALeft, DefWidth);
  drawButton(80, 'P', ALeft, DefWidth);
  drawButton(219, '[', ALeft, DefWidth);
  drawButton(221, ']', ALeft, DefWidth);
  drawButton(220, '\', ALeft, AllWidth - ALeft);
  ALeft := ALeft + (DefSpace * 4);
  drawButton(45, 'Insert', ALeft, DefWidth);
  drawButton(36, 'Home', ALeft, DefWidth);
  drawButton(33, 'Page' + #13#10 + 'Up', ALeft, DefWidth);
  ALeft := ALeft + (DefSpace * 4);
  drawButton(55, '7', ALeft, DefWidth);
  drawButton(56, '8', ALeft, DefWidth);
  drawButton(57, '9', ALeft, DefWidth);
  drawButton(-1, '+', ALeft, DefWidth, DefHeight + DefSpace + DefHeight);

  ATop := ATop + DefHeight + DefSpace;
  ALeft := 3;
  drawButton(20, 'Caps Lock', ALeft, (DefWidth * 2) + DefSpace);
  drawButton(65, 'A', ALeft, DefWidth);
  drawButton(83, 'S', ALeft, DefWidth);
  drawButton(68, 'D', ALeft, DefWidth);
  drawButton(70, 'F', ALeft, DefWidth);
  drawButton(71, 'G', ALeft, DefWidth);
  drawButton(72, 'H', ALeft, DefWidth);
  drawButton(74, 'J', ALeft, DefWidth);
  drawButton(75, 'K', ALeft, DefWidth);
  drawButton(76, 'L', ALeft, DefWidth);
  drawButton(186, ';', ALeft, DefWidth);
  drawButton(222, '''', ALeft, DefWidth);
  drawButton(13, 'Enter', ALeft, AllWidth - ALeft);
  ALeft := ALeft + (DefSpace * 4);
  drawButton(46, 'Delete', ALeft, DefWidth);
  drawButton(35, 'End', ALeft, DefWidth);
  drawButton(34, 'Page' + #13#10 + 'Down', ALeft, DefWidth);
  ALeft := ALeft + (DefSpace * 4);
  drawButton(52, '4', ALeft, DefWidth);
  drawButton(53, '5', ALeft, DefWidth);
  drawButton(54, '6', ALeft, DefWidth);

  ATop := ATop + DefHeight + DefSpace;
  ALeft := 3;
  drawButton(16, 'Shift', ALeft, (DefWidth * 2) + DefSpace + round((DefWidth + DefSpace) / 2));
  drawButton(90, 'Z', ALeft, DefWidth);
  drawButton(88, 'X', ALeft, DefWidth);
  drawButton(67, 'C', ALeft, DefWidth);
  drawButton(86, 'V', ALeft, DefWidth);
  drawButton(66, 'B', ALeft, DefWidth);
  drawButton(78, 'N', ALeft, DefWidth);
  drawButton(77, 'M', ALeft, DefWidth);
  drawButton(188, ',', ALeft, DefWidth);
  drawButton(190, '.', ALeft, DefWidth);
  drawButton(191, '/', ALeft, DefWidth);
  drawButton(16, 'Shift', ALeft, AllWidth - ALeft);
  ALeft := ALeft + (DefSpace * 4) + DefWidth + DefSpace;
  drawButton(38, '↑', ALeft, DefWidth);
  ALeft := ALeft + (DefSpace * 4) + DefWidth + DefSpace;
  drawButton(49, '1', ALeft, DefWidth);
  drawButton(50, '2', ALeft, DefWidth);
  drawButton(51, '3', ALeft, DefWidth);
  drawButton(13, 'Enter', ALeft, DefWidth, DefHeight + DefSpace + DefHeight);

  ATop := ATop + DefHeight + DefSpace;
  ALeft := 3;
  drawButton(17, 'Ctrl', ALeft, DefWidth + round(DefWidth / 2) - DefSpace);
  drawButton(91, 'Win', ALeft, DefWidth + round(DefWidth / 2) - DefSpace);
  drawButton(18, 'Alt', ALeft, DefWidth + round(DefWidth / 2) - DefSpace);
  drawButton(32, 'Пробел', ALeft, AllWidth - ((DefWidth + round(DefWidth / 2)) * 7) - DefSpace);
  drawButton(18, 'Alt', ALeft, DefWidth + round(DefWidth / 2) - DefSpace);
  drawButton(91, 'Win', ALeft, DefWidth + round(DefWidth / 2) - DefSpace);
  drawButton(93, '_', ALeft, DefWidth + round(DefWidth / 2) - DefSpace);
  drawButton(17, 'Ctrl', ALeft, AllWidth - ALeft);
  ALeft := ALeft + (DefSpace * 4);
  drawButton(37, '←', ALeft, DefWidth);
  drawButton(40, '↓', ALeft, DefWidth);
  drawButton(39, '→', ALeft, DefWidth);
  ALeft := ALeft + (DefSpace * 4);
  drawButton(48, '0', ALeft, DefWidth + DefSpace + DefWidth);
  drawButton(190, '.', ALeft, DefWidth);

  pKeyboard.AutoSize := true;

end;

end.
