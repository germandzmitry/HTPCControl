﻿unit uRCommandsControl;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Themes,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Vcl.ToolWin, Vcl.ActnCtrls, uDataBase, Vcl.ExtCtrls, Vcl.ActnColorMaps, uLine,
  CommCtrl, System.UITypes, Vcl.GraphUtil;

type
  TfrmRCommandsControl = class(TForm)
    alAllCommand: TActionList;
    amAllCommand: TActionManager;
    ActOEdit: TAction;
    ActODelete: TAction;
    ActTBOperation: TActionToolBar;
    plbRCommands: TPanel;
    pClient: TPanel;
    plvOperation: TPanel;
    pCommandHeader: TPanel;
    lCommand: TLabel;
    lDescription: TLabel;
    cbRepeat: TCheckBox;
    lRepeat: TLabel;
    lvOperation: TListView;
    ActRCAdd: TAction;
    ActRCEdit: TAction;
    ActRCDelete: TAction;
    ActTBCommand: TActionToolBar;
    ActOPressKeyboard: TAction;
    ActORunApplication: TAction;
    lCommandV: TLabel;
    lDescriptionV: TLabel;
    ColorMap: TStandardColorMap;
    cbLongPress: TCheckBox;
    lLongPress: TLabel;
    lbRCommands: TListBox;
    plbRCommandsTitle: TPanel;
    lCommandsTitle: TLabel;
    ActOSendComPort: TAction;
    ActOMouse: TAction;
    plvOperationFooter: TPanel;
    lTotalCommandWait: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ActOEditExecute(Sender: TObject);
    procedure ActODeleteExecute(Sender: TObject);
    procedure ActOPressKeyboardExecute(Sender: TObject);
    procedure ActRCAddExecute(Sender: TObject);
    procedure ActRCEditExecute(Sender: TObject);
    procedure ActRCDeleteExecute(Sender: TObject);
    procedure ActORunApplicationExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvOperationDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lbRCommandsDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure lbRCommandsClick(Sender: TObject);
    procedure lbRCommandsMeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
    procedure lbRCommandsDblClick(Sender: TObject);
    procedure ActOSendComPortExecute(Sender: TObject);
    procedure ActOMouseExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvOperationCustomDraw(Sender: TCustomListView; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure lvOperationDrawItem(Sender: TCustomListView; Item: TListItem; Rect: TRect;
      State: TOwnerDrawState);
  private
    { Private declarations }

    FLineRCommands: TLine;
    FLineOpearion: TLine;

    procedure SettingComponent;

    procedure ReadRemoteCommand(const Command: string);
    procedure ReadOperation(const Command: string);
  public
    { Public declarations }
  end;

var
  frmRCommandsControl: TfrmRCommandsControl;

implementation

{$R *.dfm}

uses uMain, uLanguage, uTypes, uRCommand, uORunApplication, uOPressKeyboard, uOMouse;

procedure TfrmRCommandsControl.FormCreate(Sender: TObject);
var
  i: Integer;
  RCommands: TRemoteCommands;
begin
  SettingComponent;
  UpdateLanguage(self, lngRus);

  try
    RCommands := Main.DataBase.GetRemoteCommands;

    lbRCommands.Items.BeginUpdate;
    lbRCommands.Items.Clear;
    for i := 0 to Length(RCommands) - 1 do
      lbRCommands.Items.AddPair(RCommands[i].Command, RCommands[i].Desc);
    lbRCommands.Items.EndUpdate;

  except
    on E: Exception do
      MessageDlg(E.Message, mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmRCommandsControl.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  FLineRCommands.Free;
  FLineOpearion.Free;

  for i := 0 to lvOperation.Items.Count - 1 do
    Dispose(lvOperation.Items[i].Data);
end;

procedure TfrmRCommandsControl.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 27 then
    close;
end;

procedure TfrmRCommandsControl.FormShow(Sender: TObject);
begin
  pClient.Width := pClient.Width + 1;
  pClient.Width := pClient.Width - 1;
end;

procedure TfrmRCommandsControl.lbRCommandsClick(Sender: TObject);
begin
  if lbRCommands.ItemIndex > -1 then
    ReadRemoteCommand(lbRCommands.Items.Names[lbRCommands.ItemIndex]);
end;

procedure TfrmRCommandsControl.lbRCommandsDblClick(Sender: TObject);
begin
  ActRCEditExecute(ActRCEdit);
end;

procedure TfrmRCommandsControl.lbRCommandsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  DrawRect: TRect;
  LB: TListBox;
begin
  LB := (Control as TListBox);

  if odSelected in State then
    LB.Canvas.Brush.Color := GetShadowColor(clHighlight, 115)
  else
  begin
    if (Index mod 2) = 0 then
      LB.Canvas.Brush.Color := clWhite
    else
      LB.Canvas.Brush.Color := clBtnFace;
  end;

  LB.Canvas.FillRect(Rect);
  LB.Canvas.Font.Color := clBlack;

  // Команда
  DrawRect := Rect;
  DrawRect.Inflate(-6, -3, -2, 0);

  DrawText(LB.Canvas.Handle, PChar(LB.Items.Names[Index]), -1, DrawRect, DT_SINGLELINE or DT_LEFT);

  // Текст к команде
  DrawRect.Inflate(0, -2, 0, 0);
  // inc(DrawRect.Top, 2);
  inc(DrawRect.Top, LB.Canvas.TextHeight((Control as TListBox).Items[Index]));

  LB.Canvas.Font.Style := LB.Canvas.Font.Style + [fsItalic];
  DrawText(LB.Canvas.Handle, PChar(LB.Items.Values[LB.Items.Names[Index]]), -1, DrawRect,
    DT_SINGLELINE or DT_LEFT or DT_WORD_ELLIPSIS);
  LB.Canvas.Font.Style := self.Canvas.Font.Style - [fsItalic];

  if odFocused in State then
    LB.Canvas.DrawFocusRect(Rect);
end;

procedure TfrmRCommandsControl.lbRCommandsMeasureItem(Control: TWinControl; Index: Integer;
  var Height: Integer);
begin
  if Length(trim((Control as TListBox).Items.ValueFromIndex[Index])) > 0 then
    Height := 34
  else
    Height := 19;
end;

procedure TfrmRCommandsControl.lvOperationCustomDraw(Sender: TCustomListView; const ARect: TRect;
  var DefaultDraw: Boolean);
var
  R: TRect;
  S: String;
  H: Integer;
begin
  if Sender.Items.Count > 0 then
    exit;

  if (lbRCommands.ItemIndex > -1) and (cbRepeat.Checked) then
    S := GetLanguageText(self.Name, 'lvOperationTitleRepeatPrevious', lngRus)
  else
    S := GetLanguageText(self.Name, 'lvOperationTitle', lngRus);

  Sender.Canvas.Font.Size := 10;

  R := ARect;
  R.Inflate(-4, -4);
  H := (R.Bottom - R.Top) div 2 + DrawText(Sender.Canvas.Handle, PChar(S), -1, R,
    DT_WORDBREAK or DT_CALCRECT) div 2;

  R := ARect;
  R.Inflate(-4, -4);
  R.Top := (R.Bottom - R.Top) div 2 - H div 2;

  DrawText(Sender.Canvas.Handle, PChar(S), -1, R, DT_CENTER or DT_WORDBREAK);
end;

procedure TfrmRCommandsControl.lvOperationDrawItem(Sender: TCustomListView; Item: TListItem;
  Rect: TRect; State: TOwnerDrawState);
var
  i: Integer;
  SubItemR, DrawR: TRect;
  Format: Cardinal;
  Icon: TIcon;
  Operation: TOperation;
begin

  if Item = nil then
    exit;

  Operation := TOperation(Item.Data^);

  if odSelected in State then
    Sender.Canvas.Brush.Color := GetShadowColor(clHighlight, 115)
  else
  begin
    // if (Item.Index mod 2) = 0 then
    Sender.Canvas.Brush.Color := clWhite
    // else
    // Sender.Canvas.Brush.Color := clBtnFace;
  end;
  Sender.Canvas.Pen.Color := rgb(229, 229, 229); // clBtnFace;
  Sender.Canvas.Font.Color := clWindowText;

  Sender.Canvas.FillRect(Rect);

  DrawR := Rect;
  DrawR.Right := DrawR.Left + Sender.Column[0].Width - 5;
  DrawText(Sender.Canvas.Handle, PChar(Item.Caption), -1, DrawR, DT_VCENTER or DT_RIGHT or
    DT_SINGLELINE);

  // Sender.Canvas.MoveTo(DrawR.Left + Sender.Column[0].Width - 1, DrawR.Top);
  // Sender.Canvas.LineTo(DrawR.Left + Sender.Column[0].Width - 1, DrawR.Bottom);

  for i := 1 to (Sender as TListView).Columns.Count - 1 do
  begin
    ListView_GetSubItemRect(Sender.Handle, Item.Index, i, LVIR_BOUNDS, @SubItemR);

    { if i < (Sender as TListView).Columns.Count - 1 then
      begin
      Sender.Canvas.MoveTo(SubItemR.Right - 1, SubItemR.Top);
      Sender.Canvas.LineTo(SubItemR.Right - 1, SubItemR.Bottom);
      end; }

    case Sender.Column[i].Alignment of
      taLeftJustify:
        Format := DT_LEFT;
      taRightJustify:
        Format := DT_RIGHT;
      taCenter:
        Format := DT_CENTER;
    end;

    SubItemR.Inflate(-5, 0, -5, 0);
    if i = 1 then
    begin
      Icon := TIcon.Create();
      try
        case Operation.OType of
          opKyeboard:
            Main.ilSmall.GetIcon(12, Icon);
          opApplication:
            Main.ilSmall.GetIcon(14, Icon);
          opMouse:
            Main.ilSmall.GetIcon(20, Icon);
        end;

        Sender.Canvas.Draw(SubItemR.Left, SubItemR.Top + 1, Icon);
        SubItemR.Inflate(-5 - Icon.Width, 0, 0, 0);
      finally
        Icon.Free;
      end;
    end;

    DrawText(Sender.Canvas.Handle, PChar(Item.SubItems[i - 1]), -1, SubItemR,
      Format or DT_VCENTER or DT_SINGLELINE or DT_END_ELLIPSIS);
  end;
end;

procedure TfrmRCommandsControl.lvOperationDblClick(Sender: TObject);
begin
  ActOEditExecute(ActOEdit);
end;

procedure TfrmRCommandsControl.SettingComponent;
var
  i: Integer;
begin

  ColorMap.Color := clWhite;
  ColorMap.HighlightColor := clWhite;
  ColorMap.MenuColor := clMenu;
  ColorMap.UnusedColor := clWhite;

  ActTBCommand.ColorMap := ColorMap;
  ActTBOperation.ColorMap := ColorMap;

  plbRCommands.Color := clWhite;
  plbRCommands.Align := alLeft;
  plbRCommands.Width := 200;

  FLineRCommands := TLine.Create(plbRCommands, clBlack, clBlack);
  ActTBCommand.Top := 0;

  plbRCommandsTitle.Color := clWhite;
  plbRCommandsTitle.Height := lCommandsTitle.Height + lCommandsTitle.Margins.Top +
    lCommandsTitle.Margins.Bottom + 6;
  lCommandsTitle.Align := alClient;
  lbRCommands.Align := alClient;

  pClient.Align := alClient;
  plvOperation.Align := alClient;
  lvOperation.Align := alClient;

  FLineOpearion := TLine.Create(plvOperation, clBlack, clBlack);
  ActTBOperation.Top := 0;

  lTotalCommandWait.Align := alClient;
  TLine.Create(plvOperationFooter, clBlack, clBlack);

  // чистим контролы
  for i := 0 to self.ComponentCount - 1 do
  begin
    // Label
    if self.Components[i] is TLabel then
      TLabel(self.Components[i]).Caption := '';
    // Edit
    if self.Components[i] is TEdit then
      TEdit(self.Components[i]).Text := '';
    // Checkbox
    if self.Components[i] is TCheckBox then
      TCheckBox(self.Components[i]).Caption := '';
    // Panel
    if self.Components[i] is TPanel then
      TPanel(self.Components[i]).Caption := '';
  end;

end;

procedure TfrmRCommandsControl.ActRCAddExecute(Sender: TObject);
var
  frmRCommand: TfrmRCommand;
begin
  frmRCommand := TfrmRCommand.Create(self);
  try
    frmRCommand.rcType := rcAdd;
    if frmRCommand.ShowModal = mrOK then
    begin
      lbRCommands.Items.AddPair(frmRCommand.edCommand.Text, frmRCommand.edDescription.Text);
      lbRCommands.Selected[lbRCommands.Items.IndexOfName(frmRCommand.edCommand.Text)] := true;
      lbRCommandsClick(lbRCommands);
    end;
  finally
    frmRCommand.Free;
  end;
end;

procedure TfrmRCommandsControl.ActRCEditExecute(Sender: TObject);
var
  frmRCommand: TfrmRCommand;
  RCommand: TRemoteCommand;
begin

  if lbRCommands.ItemIndex = -1 then
  begin
    MessageDlg(uLanguage.GetLanguageMsg('msgRCSelectCommand', lngRus), mtWarning, [mbOK], 0);
    exit;
  end;

  try
    RCommand := Main.DataBase.GetRemoteCommand(lbRCommands.Items.Names[lbRCommands.ItemIndex]);
  except
    on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      exit;
    end;
  end;

  frmRCommand := TfrmRCommand.Create(self);
  try
    frmRCommand.rcType := rcEdit;
    frmRCommand.edCommand.Text := RCommand.Command;
    frmRCommand.edDescription.Text := RCommand.Desc;
    frmRCommand.cbRepeatPrevious.Checked := RCommand.RepeatPrevious;
    frmRCommand.cbLongPress.Checked := RCommand.LongPress;
    if frmRCommand.ShowModal = mrOK then
    begin
      ReadRemoteCommand(RCommand.Command);
      lbRCommands.Items[lbRCommands.Items.IndexOfName(RCommand.Command)] := RCommand.Command +
        lbRCommands.Items.NameValueSeparator + frmRCommand.edDescription.Text;
    end;
  finally
    frmRCommand.Free;
  end;
end;

procedure TfrmRCommandsControl.ActRCDeleteExecute(Sender: TObject);
var
  SelectedIndex: Integer;
begin
  if lbRCommands.ItemIndex = -1 then
  begin
    MessageDlg(uLanguage.GetLanguageMsg('msgRCSelectCommand', lngRus), mtWarning, [mbOK], 0);
    exit;
  end;

  if MessageDlg(Format(GetLanguageMsg('msgDBDeleteRemoteCommand', lngRus),
    [lbRCommands.Items.Names[lbRCommands.ItemIndex]]), mtConfirmation, mbYesNo, 1) = mrYes then
    try
      Main.DataBase.DeleteRemoteCommand(lbRCommands.Items.Names[lbRCommands.ItemIndex]);

      SelectedIndex := lbRCommands.ItemIndex;
      if (lbRCommands.Items.Count = SelectedIndex + 1) then
        SelectedIndex := SelectedIndex - 1;

      lbRCommands.Items.Delete(lbRCommands.ItemIndex);
      if lbRCommands.Items.Count > 0 then
      begin
        lbRCommands.Selected[SelectedIndex] := true;
        lbRCommandsClick(lbRCommands);
      end;

    except
      on E: Exception do
        MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
end;

procedure TfrmRCommandsControl.ActOPressKeyboardExecute(Sender: TObject);
var
  frmOPressKey: TfrmOPressKeyboard;
begin
  if lbRCommands.ItemIndex = -1 then
  begin
    MessageDlg(uLanguage.GetLanguageMsg('msgRCSelectCommand', lngRus), mtWarning, [mbOK], 0);
    exit;
  end;

  frmOPressKey := TfrmOPressKeyboard.Create(self);
  try
    frmOPressKey.pkType := pkAdd;
    frmOPressKey.Command := lbRCommands.Items.Names[lbRCommands.ItemIndex];
    frmOPressKey.udPSort.Position := lvOperation.Items.Count + 1;
    if frmOPressKey.ShowModal = mrOK then
      ReadOperation(lbRCommands.Items.Names[lbRCommands.ItemIndex]);
  finally
    frmOPressKey.Free;
  end;
end;

procedure TfrmRCommandsControl.ActORunApplicationExecute(Sender: TObject);
var
  frmORunApp: TfrmORunApplication;
begin
  if lbRCommands.ItemIndex = -1 then
  begin
    MessageDlg(uLanguage.GetLanguageMsg('msgRCSelectCommand', lngRus), mtWarning, [mbOK], 0);
    exit;
  end;

  frmORunApp := TfrmORunApplication.Create(self);
  try
    frmORunApp.raType := raAdd;
    frmORunApp.Command := lbRCommands.Items.Names[lbRCommands.ItemIndex];
    frmORunApp.udPSort.Position := lvOperation.Items.Count + 1;
    if frmORunApp.ShowModal = mrOK then
      ReadOperation(lbRCommands.Items.Names[lbRCommands.ItemIndex]);
  finally
    frmORunApp.Free;
  end;
end;

procedure TfrmRCommandsControl.ActOSendComPortExecute(Sender: TObject);
begin
  //
end;

procedure TfrmRCommandsControl.ActOEditExecute(Sender: TObject);
var
  frmORunApp: TfrmORunApplication;
  frmOPressKey: TfrmOPressKeyboard;
  frmOMouse: TfrmOMouse;
  Operation: TOperation;
begin

  if lvOperation.SelCount = 0 then
  begin
    MessageDlg(uLanguage.GetLanguageMsg('msgRCSelectOperation', lngRus), mtWarning, [mbOK], 0);
    exit;
  end;

  Operation := TOperation(lvOperation.Selected.Data^);
  case Operation.OType of
    opKyeboard:
      begin
        frmOPressKey := TfrmOPressKeyboard.Create(self);
        try
          frmOPressKey.pkType := pkEdit;
          frmOPressKey.Id := Operation.PressKeyboard.Id;
          frmOPressKey.Command := Operation.Command;
          frmOPressKey.udPSort.Position := Operation.PressKeyboard.pSort;
          frmOPressKey.udWait.Position := Operation.PressKeyboard.Wait;
          frmOPressKey.edForApplication.Text := Operation.PressKeyboard.ForApplication;
          if Operation.PressKeyboard.Key1 > 0 then
            frmOPressKey.DownKey.AddObject(Main.DataBase.GetKeyboard(Operation.PressKeyboard.Key1)
              .Desc, TObject(Operation.PressKeyboard.Key1));
          if Operation.PressKeyboard.Key2 > 0 then
            frmOPressKey.DownKey.AddObject(Main.DataBase.GetKeyboard(Operation.PressKeyboard.Key2)
              .Desc, TObject(Operation.PressKeyboard.Key2));
          if Operation.PressKeyboard.Key3 > 0 then
            frmOPressKey.DownKey.AddObject(Main.DataBase.GetKeyboard(Operation.PressKeyboard.Key3)
              .Desc, TObject(Operation.PressKeyboard.Key3));

          if frmOPressKey.ShowModal = mrOK then
            ReadOperation(lbRCommands.Items.Names[lbRCommands.ItemIndex]);
        finally
          frmOPressKey.Free;
        end;
      end;
    opApplication:
      begin
        frmORunApp := TfrmORunApplication.Create(self);
        try
          frmORunApp.raType := raEdit;

          frmORunApp.Id := Operation.RunApplication.Id;
          frmORunApp.Command := Operation.Command;
          frmORunApp.udPSort.Position := Operation.RunApplication.pSort;
          frmORunApp.udWait.Position := Operation.RunApplication.Wait;

          frmORunApp.edApplicationFileName.Text := Operation.RunApplication.Application;
          if frmORunApp.ShowModal = mrOK then
            ReadOperation(Operation.Command);
        finally
          frmORunApp.Free;
        end;
      end;
    opMouse:
      begin
        frmOMouse := TfrmOMouse.Create(self);
        try
          frmOMouse.moType := moEdit;

          frmOMouse.Id := Operation.Mouse.Id;
          frmOMouse.Command := Operation.Command;
          frmOMouse.udPSort.Position := Operation.Mouse.pSort;
          frmOMouse.udWait.Position := Operation.Mouse.Wait;
          frmOMouse.edForApplication.Text := Operation.Mouse.ForApplication;

          frmOMouse.MouseEvent := Operation.Mouse.Event;
          frmOMouse.MouseX := Operation.Mouse.X;
          frmOMouse.MouseY := Operation.Mouse.Y;
          frmOMouse.MouseWheel := Operation.Mouse.Wheel;

          if frmOMouse.ShowModal = mrOK then
            ReadOperation(Operation.Command);
        finally
          frmOMouse.Free;
        end;
      end;
  end;
end;

procedure TfrmRCommandsControl.ActOMouseExecute(Sender: TObject);
var
  frmOMouse: TfrmOMouse;
begin
  if lbRCommands.ItemIndex = -1 then
  begin
    MessageDlg(uLanguage.GetLanguageMsg('msgRCSelectCommand', lngRus), mtWarning, [mbOK], 0);
    exit;
  end;

  frmOMouse := TfrmOMouse.Create(self);
  try
    frmOMouse.moType := moAdd;
    frmOMouse.Command := lbRCommands.Items.Names[lbRCommands.ItemIndex];
    frmOMouse.udPSort.Position := lvOperation.Items.Count + 1;
    if frmOMouse.ShowModal = mrOK then
      ReadOperation(lbRCommands.Items.Names[lbRCommands.ItemIndex]);
  finally
    frmOMouse.Free;
  end;

end;

procedure TfrmRCommandsControl.ActODeleteExecute(Sender: TObject);
var
  Operation: TOperation;
begin

  if lvOperation.SelCount = 0 then
  begin
    MessageDlg(uLanguage.GetLanguageMsg('msgRCSelectOperation', lngRus), mtWarning, [mbOK], 0);
    exit;
  end;

  Operation := TOperation(lvOperation.Selected.Data^);

  if MessageDlg(Format(GetLanguageMsg('msgRCDeleteOperation', lngRus),
    [Operation.Operation, Operation.Command]), mtConfirmation, mbYesNo, 1) = mrYes then
    try
      case Operation.OType of
        opKyeboard:
          Main.DataBase.DeletePressKeyboard(Operation.PressKeyboard.Id);
        opApplication:
          Main.DataBase.DeleteRunApplication(Operation.RunApplication.Id);
        opMouse:
          Main.DataBase.DeleteMouse(Operation.Mouse.Id);
      end;
      ReadOperation(Operation.Command);
    except
      on E: Exception do
        MessageDlg(E.Message, mtError, [mbOK], 0);
    end;

end;

procedure TfrmRCommandsControl.ReadRemoteCommand(const Command: string);
var
  RCommand: TRemoteCommand;
begin
  try
    RCommand := Main.DataBase.GetRemoteCommand(Command);
    lCommandV.Caption := RCommand.Command;
    lDescriptionV.Caption := RCommand.Desc;
    cbRepeat.Checked := RCommand.RepeatPrevious;
    cbLongPress.Checked := RCommand.LongPress;

    ActOPressKeyboard.Enabled := not RCommand.RepeatPrevious;
    ActOMouse.Enabled := not RCommand.RepeatPrevious;
    ActORunApplication.Enabled := not RCommand.RepeatPrevious;
    ActOSendComPort.Enabled := not RCommand.RepeatPrevious;
    ActOEdit.Enabled := not RCommand.RepeatPrevious;
    ActODelete.Enabled := not RCommand.RepeatPrevious;

    ReadOperation(Command);
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmRCommandsControl.ReadOperation(const Command: string);
var
  Operations: TOperations;
  i: Integer;
  LItem: TListItem;
  Op: POperation;
  TotalWait: Integer;
begin
  TotalWait := 0;

  try
    Operations := Main.DataBase.getOperation(Command);
    lvOperation.Items.BeginUpdate;

    for i := 0 to lvOperation.Items.Count - 1 do
      Dispose(lvOperation.Items[i].Data);
    lvOperation.Items.Clear;

    for i := 0 to Length(Operations) - 1 do
    begin
      LItem := lvOperation.Items.Add;
      LItem.Caption := inttostr(Operations[i].OSort);
      LItem.SubItems.Add(Operations[i].Operation);
      LItem.SubItems.Add(floattostr(Operations[i].OWait / 1000) + ' с.');

      new(Op);
      Op^ := Operations[i];
      LItem.Data := Op;

      inc(TotalWait, Operations[i].OWait);
    end;
    lvOperation.Items.EndUpdate;

    lTotalCommandWait.Caption := Format(GetLanguageText(self.Name, lTotalCommandWait.Name, lngRus),
      [floattostr(TotalWait / 1000)])

    // StaticText1.Caption := 'Общее время выполнения: ' + floattostr(TotalWait / 1000) + ' с.';

    // lvOperation.Columns[1].Width := -2;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

end.
