unit uAllCommand;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Vcl.ToolWin, Vcl.ActnCtrls, uDataBase;

type
  TfrmAllCommand = class(TForm)
    lvAllCommand: TListView;
    btnClose: TButton;
    alAllCommand: TActionList;
    amAllCommand: TActionManager;
    ActRCNew: TAction;
    ActRCEdit: TAction;
    ActRCDelete: TAction;
    ActionToolBar1: TActionToolBar;
    ActRCCollapseAll: TAction;
    ActRCExpandAll: TAction;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure ActRCNewExecute(Sender: TObject);
    procedure ActRCEditExecute(Sender: TObject);
    procedure ActRCDeleteExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActRCCollapseAllExecute(Sender: TObject);
    procedure ActRCExpandAllExecute(Sender: TObject);
  private
    { Private declarations }
    procedure AddCommandToList(RCommand: TVCommand; Selected: boolean = false);
  public
    { Public declarations }
  end;

var
  frmAllCommand: TfrmAllCommand;

implementation

{$R *.dfm}

uses uMain, uLanguage, uTypes, uControlCommand;

procedure TfrmAllCommand.FormCreate(Sender: TObject);
var
  r: TVCommands;
  g: TKeyboardGroups;
  i: integer;
  LGroup: TListGroup;
begin
  UpdateLanguage(self, lngRus);

  lvAllCommand.GroupView := True;

  try
    // Группы
    g := Main.DataBase.GetKeyboardGroups;
    for i := 0 to Length(g) - 1 do
    begin
      LGroup := lvAllCommand.Groups.Add;
      LGroup.GroupID := g[i].Group;
      LGroup.Header := g[i].Descciption;
      LGroup.State := [lgsNormal, lgsCollapsible, lgsCollapsed];
    end;

    // Команды
    r := Main.DataBase.getVCommands;
    for i := 0 to Length(r) - 1 do
      AddCommandToList(r[i]);
  except
    on E: Exception do
      MessageDlg(E.Message, mtWarning, [mbOK], 0);
  end;
end;

procedure TfrmAllCommand.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to lvAllCommand.Items.Count - 1 do
    Dispose(lvAllCommand.Items[i].Data);
end;

procedure TfrmAllCommand.btnCloseClick(Sender: TObject);
begin
  self.Close;
end;

procedure TfrmAllCommand.ActRCNewExecute(Sender: TObject);
var
  LCC: TfrmControlCommand;
  r: TVCommands;
  i: integer;
begin
  LCC := TfrmControlCommand.Create(self);
  try
    LCC.cType := ccNew;
    LCC.Caption := GetLanguageText(LCC.Name, 'CaptionAdd', lngRus);
    if LCC.ShowModal = mrOK then
    begin
      lvAllCommand.Items.BeginUpdate;
      r := Main.DataBase.getVCommands(LCC.edCCCommand.Text);
      if Length(r) > 0 then
        for i := 0 to Length(r) - 1 do
          AddCommandToList(r[i], True);
      lvAllCommand.Items.EndUpdate;
    end;
  finally
    LCC.Free;
  end;
end;

procedure TfrmAllCommand.ActRCEditExecute(Sender: TObject);
var
  LCC: TfrmControlCommand;
  r: TVCommands;
  i: integer;
begin

  if lvAllCommand.SelCount = 0 then
  begin
    MessageDlg(uLanguage.GetLanguageMsg('msgACSelectCommand', lngRus), mtWarning, [mbOK], 0);
    exit;
  end;

  LCC := TfrmControlCommand.Create(self);
  try
    LCC.cType := ccEdit;
    LCC.Caption := GetLanguageText(LCC.Name, 'CaptionEdit', lngRus);
    LCC.edCCCommand.Text := string(lvAllCommand.Selected.Data^);
    if LCC.ShowModal = mrOK then
    begin
      lvAllCommand.Items.BeginUpdate;

      Dispose(lvAllCommand.Selected.Data);
      lvAllCommand.Items.Delete(lvAllCommand.Selected.Index);

      r := Main.DataBase.getVCommands(LCC.edCCCommand.Text);
      if Length(r) > 0 then
        for i := 0 to Length(r) - 1 do
          AddCommandToList(r[i], True);
      lvAllCommand.Items.EndUpdate;
    end;
  finally
    LCC.Free;
  end;
end;

procedure TfrmAllCommand.ActRCDeleteExecute(Sender: TObject);
var
  LCommand: string;
begin

  if lvAllCommand.SelCount = 0 then
  begin
    MessageDlg(uLanguage.GetLanguageMsg('msgACSelectCommand', lngRus), mtWarning, [mbOK], 0);
    exit;
  end;

  LCommand := string(lvAllCommand.Selected.Data^);

  if MessageDlg(Format(GetLanguageMsg('msgDBDeleteRemoteCommand', lngRus), [LCommand]),
    mtConfirmation, mbOKCancel, 1) = mrOK then
    try
      Main.DataBase.DeleteCommand(LCommand);

      Dispose(lvAllCommand.Selected.Data);
      lvAllCommand.Items.Delete(lvAllCommand.Selected.Index);

      MessageDlg(GetLanguageMsg('msgDBDeleteRemoteCommandSuccess', lngRus), mtInformation,
        [mbOK], 0);

    except
      on E: Exception do
        MessageDlg(E.Message, mtError, [mbOK], 0);
    end;

end;

procedure TfrmAllCommand.ActRCCollapseAllExecute(Sender: TObject);
var
  i: integer;
begin
  lvAllCommand.Items.BeginUpdate;
  for i := 0 to lvAllCommand.Groups.Count - 1 do
    if not(lgsCollapsed in lvAllCommand.Groups[i].State) then
      lvAllCommand.Groups[i].State := lvAllCommand.Groups[i].State + [lgsCollapsed];
  lvAllCommand.Perform(CM_RecreateWnd, 0, 0);
  lvAllCommand.Items.EndUpdate;
end;

procedure TfrmAllCommand.ActRCExpandAllExecute(Sender: TObject);
var
  i: integer;
begin
  lvAllCommand.Items.BeginUpdate;
  for i := 0 to lvAllCommand.Groups.Count - 1 do
    if lgsCollapsed in lvAllCommand.Groups[i].State then
      lvAllCommand.Groups[i].State := lvAllCommand.Groups[i].State - [lgsCollapsed];
  lvAllCommand.Perform(CM_RecreateWnd, 0, 0);
  lvAllCommand.Items.EndUpdate;
end;

procedure TfrmAllCommand.AddCommandToList(RCommand: TVCommand; Selected: boolean = false);
var
  LItem: TListItem;
  d: ^string;
  i: integer;
begin
  LItem := lvAllCommand.Items.Add;

  new(d);
  d^ := RCommand.Command;
  LItem.Data := d;

  LItem.GroupID := RCommand.OGroup;
  LItem.Caption := RCommand.Command;
  if Length(Trim(RCommand.Desc)) > 0 then
    LItem.Caption := LItem.Caption + ' (' + RCommand.Desc + ')';
  LItem.SubItems.Add(RCommand.Operation);
  LItem.SubItems.Add(BoolToStr(RCommand.ORepeat));

  if Selected then
  begin

    for i := 0 to lvAllCommand.Groups.Count - 1 do
      if lvAllCommand.Groups[i].ID = RCommand.OGroup then
      begin
        if lgsCollapsed in lvAllCommand.Groups[i].State then
          lvAllCommand.Groups[i].State := lvAllCommand.Groups[i].State - [lgsCollapsed];
        Break;
      end;

    lvAllCommand.Selected := LItem;
    lvAllCommand.Selected.MakeVisible(True);

  end;
end;

end.
