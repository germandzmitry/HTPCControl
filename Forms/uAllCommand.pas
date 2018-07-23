unit uAllCommand;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TfrmAllCommand = class(TForm)
    lvAllCommand: TListView;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAllCommand: TfrmAllCommand;

implementation

{$R *.dfm}

uses uMain, uLanguage, uTypes, uDataBase;

procedure TfrmAllCommand.btnCloseClick(Sender: TObject);
begin
  self.Close;
end;

procedure TfrmAllCommand.FormCreate(Sender: TObject);
var
  r: TVCommands;
  g: TKeyboardGroups;
  i: integer;
  LItem: TListItem;
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
      // LGroup.Footer := 'footer';
      // LGroup.Subtitle := 'subtitle';
    end;

    // Команды
    r := Main.DataBase.getVCommands;
    for i := 0 to Length(r) - 1 do
    begin
      LItem := lvAllCommand.Items.Add;
      LItem.GroupID := r[i].OGroup;
      LItem.Caption := r[i].Command;
      if Length(Trim(r[i].Desc)) > 0 then
        LItem.Caption := LItem.Caption + ' (' + r[i].Desc + ')';
      LItem.SubItems.Add(r[i].Operation);
      LItem.SubItems.Add(BoolToStr(r[i].ORepeat));
    end;
  except
    on E: Exception do
      MessageDlg(E.Message, mtWarning, [mbOK], 0);
  end;

end;

end.
