unit uControlCommand;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TControlCommand = class(TForm)
    lCCCommand: TLabel;
    lCCDescription: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ControlCommand: TControlCommand;

implementation

{$R *.dfm}

uses uLanguage, uTypes;

procedure TControlCommand.FormCreate(Sender: TObject);
begin
  UpdateLanguage(self, lngRus);
end;

end.
