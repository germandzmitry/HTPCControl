unit uAllCommand;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TAllCommand = class(TForm)
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
  AllCommand: TAllCommand;

implementation

{$R *.dfm}

uses uMain, uLanguage, uTypes, uDataBase;

procedure TAllCommand.btnCloseClick(Sender: TObject);
begin
  self.Close;
end;

procedure TAllCommand.FormCreate(Sender: TObject);
var
  r: TVCommands;
  i: integer;
  LItem: TListItem;
begin
  UpdateLanguage(self, lngRus);

  try
    r := Main.DataBase.getVCommands;
    for i := 0 to Length(r) - 1 do
    begin
      LItem := lvAllCommand.Items.Add;
      LItem.Caption := r[i].Command;
      LItem.SubItems.Add(r[i].Desc);
      LItem.SubItems.Add(r[i].Operation);
      LItem.SubItems.Add(BoolToStr(r[i].ORepeat));
    end;
  except
    on E: Exception do
      MessageDlg(E.Message, mtWarning, [mbOK], 0);
  end;

end;

end.
