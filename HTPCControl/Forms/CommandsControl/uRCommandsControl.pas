unit uRCommandsControl;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Themes,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Vcl.ToolWin, Vcl.ActnCtrls, uDataBase, Vcl.ExtCtrls, Vcl.ActnColorMaps, uLine,
  CommCtrl;

type
  TfrmRCommandsControl = class(TForm)
    alAllCommand: TActionList;
    amAllCommand: TActionManager;
    ActOEdit: TAction;
    ActODelete: TAction;
    ActTBOperation: TActionToolBar;
    plvRCommands: TPanel;
    pClient: TPanel;
    plvOperation: TPanel;
    pCommandHeader: TPanel;
    lCommand: TLabel;
    lDescription: TLabel;
    cbRepeat: TCheckBox;
    lRepeat: TLabel;
    lvRCommands: TListView;
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
    procedure FormCreate(Sender: TObject);
    procedure ActOEditExecute(Sender: TObject);
    procedure ActODeleteExecute(Sender: TObject);
    procedure lvRCommandsSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure ActOPressKeyboardExecute(Sender: TObject);
    procedure ActRCAddExecute(Sender: TObject);
    procedure ActRCEditExecute(Sender: TObject);
    procedure ActRCDeleteExecute(Sender: TObject);
    procedure ActORunApplicationExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvRCommandsCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvOperationCustomDrawSubItem(Sender: TCustomListView; Item: TListItem;
      SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvOperationDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

uses uMain, uLanguage, uTypes, uRCommand, uORunApplication, uOPressKeyboard;

procedure TfrmRCommandsControl.FormCreate(Sender: TObject);
var
  i: Integer;
  RCommands: TRemoteCommands;
begin
  SettingComponent;
  UpdateLanguage(self, lngRus);

  try
    RCommands := Main.DataBase.GetRemoteCommands;
    lvRCommands.Items.BeginUpdate;
    lvRCommands.Items.Clear;
    for i := 0 to Length(RCommands) - 1 do
      lvRCommands.Items.Add.Caption := RCommands[i].Command;
    lvRCommands.Items.EndUpdate;

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

procedure TfrmRCommandsControl.lvRCommandsCustomDrawItem(Sender: TCustomListView; Item: TListItem;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if (Item.Index mod 2) = 1 then
    Sender.Canvas.Brush.Color := clBtnFace
  else
    Sender.Canvas.Brush.Color := clWhite;
end;

procedure TfrmRCommandsControl.lvOperationCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  Rect: TRect;
  Details: TThemedElementDetails;
begin
  // if SubItem = 1 then
  // begin
  // DefaultDraw := false;
  // if strtoint(Item.SubItems[SubItem - 1]) <> 0 then
  // begin
  // ListView_GetSubItemRect(Sender.Handle, Item.Index, SubItem, LVIR_BOUNDS, @Rect);
  // Details := StyleServices.GetElementDetails(tbCheckBoxCheckedNormal);
  // StyleServices.DrawElement(Sender.Canvas.Handle, Details, Rect);
  // end;
  // SetBkMode(Sender.Canvas.Handle, TRANSPARENT); // <- will effect the next [sub]item
  // end;
end;

procedure TfrmRCommandsControl.lvOperationDblClick(Sender: TObject);
begin
  ActOEditExecute(ActOEdit);
end;

procedure TfrmRCommandsControl.lvRCommandsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected then
    ReadRemoteCommand(Item.Caption);
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

  plvRCommands.Color := clWhite;
  plvRCommands.Align := alLeft;
  plvRCommands.Width := 200;
  lvRCommands.Align := alClient;

  FLineRCommands := TLine.Create(plvRCommands, clBlack, clBlack);
  ActTBCommand.Top := 0;

  pClient.Align := alClient;
  plvOperation.Align := alClient;
  lvOperation.Align := alClient;

  FLineOpearion := TLine.Create(plvOperation, clBlack, clBlack);
  ActTBOperation.Top := 0;

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

  SendMessage(lvRCommands.Handle, WM_UPDATEUISTATE, MakeLong(UIS_SET, UISF_HIDEFOCUS), 0);
  SendMessage(lvOperation.Handle, WM_UPDATEUISTATE, MakeLong(UIS_SET, UISF_HIDEFOCUS), 0);
end;

procedure TfrmRCommandsControl.ActRCAddExecute(Sender: TObject);
var
  frmRCommand: TfrmRCommand;
  LItem: TListItem;
begin
  frmRCommand := TfrmRCommand.Create(self);
  try
    frmRCommand.rcType := rcAdd;
    if frmRCommand.ShowModal = mrOK then
    begin
      lvRCommands.Items.BeginUpdate;
      LItem := lvRCommands.Items.Add;
      LItem.Caption := frmRCommand.edCommand.Text;
      lvRCommands.Items.EndUpdate;

      lvRCommands.Selected := LItem;
      lvRCommands.Items[lvRCommands.Items.Count - 1].MakeVisible(True);
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

  if lvRCommands.SelCount = 0 then
  begin
    MessageDlg(uLanguage.GetLanguageMsg('msgRCSelectCommand', lngRus), mtWarning, [mbOK], 0);
    Exit;
  end;

  try
    RCommand := Main.DataBase.GetRemoteCommand(lvRCommands.Selected.Caption);
  except
    on E: Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOK], 0);
      Exit;
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
      ReadRemoteCommand(RCommand.Command);
  finally
    frmRCommand.Free;
  end;
end;

procedure TfrmRCommandsControl.ActRCDeleteExecute(Sender: TObject);
var
  SelectedIndex: Integer;
begin
  if lvRCommands.SelCount = 0 then
  begin
    MessageDlg(uLanguage.GetLanguageMsg('msgRCSelectCommand', lngRus), mtWarning, [mbOK], 0);
    Exit;
  end;

  if MessageDlg(Format(GetLanguageMsg('msgDBDeleteRemoteCommand', lngRus),
    [lvRCommands.Selected.Caption]), mtConfirmation, mbYesNo, 1) = mrYes then
    try
      Main.DataBase.DeleteRemoteCommand(lvRCommands.Selected.Caption);
      // MessageDlg(GetLanguageMsg('msgDBDeleteRemoteCommandSuccess', lngRus), mtInformation,
      // [mbOK], 0);

      SelectedIndex := lvRCommands.Selected.Index;
      if (lvRCommands.Items.Count = SelectedIndex + 1) then
        SelectedIndex := SelectedIndex - 1;

      lvRCommands.Items.Delete(lvRCommands.Selected.Index);
      if lvRCommands.Items.Count > 0 then
      begin
        lvRCommands.Selected := lvRCommands.Items[SelectedIndex];
        lvRCommands.Items[SelectedIndex].MakeVisible(True);
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
  if lvRCommands.SelCount = 0 then
  begin
    MessageDlg(uLanguage.GetLanguageMsg('msgRCSelectCommand', lngRus), mtWarning, [mbOK], 0);
    Exit;
  end;

  frmOPressKey := TfrmOPressKeyboard.Create(self);
  try
    frmOPressKey.pkType := pkAdd;
    frmOPressKey.Command := lvRCommands.Selected.Caption;
    frmOPressKey.udPSort.Position := lvOperation.Items.Count + 1;
    if frmOPressKey.ShowModal = mrOK then
      ReadOperation(lvRCommands.Selected.Caption);
  finally
    frmOPressKey.Free;
  end;
end;

procedure TfrmRCommandsControl.ActORunApplicationExecute(Sender: TObject);
var
  frmORunApp: TfrmORunApplication;
begin
  if lvRCommands.SelCount = 0 then
  begin
    MessageDlg(uLanguage.GetLanguageMsg('msgRCSelectCommand', lngRus), mtWarning, [mbOK], 0);
    Exit;
  end;

  frmORunApp := TfrmORunApplication.Create(self);
  try
    frmORunApp.raType := raAdd;
    frmORunApp.Command := lvRCommands.Selected.Caption;
    frmORunApp.udPSort.Position := lvOperation.Items.Count + 1;
    if frmORunApp.ShowModal = mrOK then
      ReadOperation(lvRCommands.Selected.Caption);
  finally
    frmORunApp.Free;
  end;
end;

procedure TfrmRCommandsControl.ActOEditExecute(Sender: TObject);
var
  frmORunApp: TfrmORunApplication;
  frmOPressKey: TfrmOPressKeyboard;
  Operation: TOperation;
begin

  if lvOperation.SelCount = 0 then
  begin
    MessageDlg(uLanguage.GetLanguageMsg('msgRCSelectOperation', lngRus), mtWarning, [mbOK], 0);
    Exit;
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
            frmOPressKey.DownKey.addObject(Main.DataBase.GetKeyboard(Operation.PressKeyboard.Key1)
              .Desc, TObject(Operation.PressKeyboard.Key1));
          if Operation.PressKeyboard.Key2 > 0 then
            frmOPressKey.DownKey.addObject(Main.DataBase.GetKeyboard(Operation.PressKeyboard.Key2)
              .Desc, TObject(Operation.PressKeyboard.Key2));
          if Operation.PressKeyboard.Key3 > 0 then
            frmOPressKey.DownKey.addObject(Main.DataBase.GetKeyboard(Operation.PressKeyboard.Key3)
              .Desc, TObject(Operation.PressKeyboard.Key3));

          if frmOPressKey.ShowModal = mrOK then
            ReadOperation(lvRCommands.Selected.Caption);
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
  end;
end;

procedure TfrmRCommandsControl.ActODeleteExecute(Sender: TObject);
var
  Operation: TOperation;
begin

  if lvOperation.SelCount = 0 then
  begin
    MessageDlg(uLanguage.GetLanguageMsg('msgRCSelectOperation', lngRus), mtWarning, [mbOK], 0);
    Exit;
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
      end;
      ReadOperation(Operation.Command);
      // Dispose(lvOperation.Selected.Data);
      // lvOperation.Items.Delete(lvOperation.Selected.Index);
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
    ActORunApplication.Enabled := not RCommand.RepeatPrevious;
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
begin
  try
    Operations := Main.DataBase.getOperation(Command);
    lvOperation.Items.BeginUpdate;

    for i := 0 to lvOperation.Items.Count - 1 do
      Dispose(lvOperation.Items[i].Data);
    lvOperation.Items.Clear;

    for i := 0 to Length(Operations) - 1 do
    begin
      LItem := lvOperation.Items.Add;
      LItem.Caption := IntToStr(Operations[i].OSort);
      LItem.SubItems.Add(Operations[i].Operation);
      LItem.SubItems.Add(floattostr(Operations[i].OWait / 1000) + ' с.');

      new(Op);
      Op^ := Operations[i];
      LItem.Data := Op;
    end;
    lvOperation.Items.EndUpdate;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

end.
