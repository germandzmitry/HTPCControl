unit uAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DateUtils;

type
  TAbout = class(TForm)
    lVersion: TLabel;
    lVersionDate: TLabel;
    lName: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  About: TAbout;

implementation

{$R *.dfm}

uses uLanguage;

function FileVersion(AMask: string; const FileName: TFileName; out Release: Word;
  out Build: Word): String;
var
  VerInfoSize: Cardinal;
  VerValueSize: Cardinal;
  Dummy: Cardinal;
  PVerInfo: Pointer;
  PVerValue: PVSFixedFileInfo;
begin
  Result := '';
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  GetMem(PVerInfo, VerInfoSize);
  try
    if GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, PVerInfo) then
      if VerQueryValue(PVerInfo, '\', Pointer(PVerValue), VerValueSize) then
        with PVerValue^ do
        begin
          Release := HiWord(dwFileVersionLS);
          Build := LoWord(dwFileVersionLS);
          Result := Format(AMask, // Mask
            [HiWord(dwFileVersionMS), // Major
            LoWord(dwFileVersionMS), // Minor
            HiWord(dwFileVersionLS), // Release
            LoWord(dwFileVersionLS)]); // Build
        end;
  finally
    FreeMem(PVerInfo, VerInfoSize);
  end;
end;

procedure TAbout.FormCreate(Sender: TObject);
begin
  UpdateLanguage(self, lngRus);
end;

procedure TAbout.FormShow(Sender: TObject);
var
  LRelease, LBuild: Word;
  LCap: string;
begin
  LCap := lVersion.Caption;
  lVersion.Caption := FileVersion(LCap, Application.ExeName, LRelease, LBuild);

  lVersionDate.Caption := Format(lVersionDate.Caption,
    [DateToStr(IncDay(EncodeDate(2000, 01, 01), LRelease))]);
{$IFDEF DEBUG}
  lName.Caption := 'HTPC Control (Debug)';
{$ELSE}
  lName.Caption := 'HTPC Control';
{$IFEND}
end;

end.
