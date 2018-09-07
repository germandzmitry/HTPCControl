unit uAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, DateUtils, Vcl.ExtCtrls, Vcl.ComCtrls, ShellAPI,
  Vcl.Imaging.pngimage;

type
  TAbout = class(TForm)
    lVersion: TLabel;
    lVersionDate: TLabel;
    lName: TLabel;
    ImageLogo: TImage;
    pcAbout: TPageControl;
    TabAbout: TTabSheet;
    TabHistory: TTabSheet;
    memoHistory: TMemo;
    pAbout: TPanel;
    btnOK: TButton;
    llGitHub: TLinkLabel;
    lLicense: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure llGitHubClick(Sender: TObject);

    procedure RandomColor(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    pHLeft, pHLine, pHRight: TPanel;
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

procedure TAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TAbout.FormCreate(Sender: TObject);
begin
  pAbout.Caption := '';
  memoHistory.Lines.Clear;

  pHLeft := TPanel.Create(pAbout);
  with pHLeft do
  begin
    Parent := pAbout;
    Left := ImageLogo.Left + 41;
    Top := ImageLogo.Top + 8;
    Width := 14;
    Height := 88;
    BevelOuter := bvNone;
    ParentBackground := false;
    OnClick := RandomColor;
  end;

  pHLine := TPanel.Create(pAbout);
  with pHLine do
  begin
    Parent := pAbout;
    Left := ImageLogo.Left + 55;
    Top := ImageLogo.Top + 62;
    Width := 26;
    Height := 9;
    BevelOuter := bvNone;
    ParentBackground := false;
    OnClick := RandomColor;
  end;

  pHRight := TPanel.Create(pAbout);
  with pHRight do
  begin
    Parent := pAbout;
    Left := ImageLogo.Left + 81;
    Top := ImageLogo.Top + 8;
    Width := 14;
    Height := 88;
    BevelOuter := bvNone;
    ParentBackground := false;
    OnClick := RandomColor;
  end;

  ImageLogo.BringToFront;

  RandomColor(Self);
  UpdateLanguage(Self, lngRus);
end;

procedure TAbout.FormDestroy(Sender: TObject);
begin
  pHLeft.Free;
  pHLine.Free;
  pHRight.Free;
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

procedure TAbout.llGitHubClick(Sender: TObject);
begin
  ShellExecute(Self.handle, 'open', PChar(TLinkLabel(Sender).Hint), nil, nil, SW_SHOW);
end;

procedure TAbout.RandomColor(Sender: TObject);
var
  InverseColor: TColor;
  g: byte;
begin
  pAbout.color := RGB(Random(256), Random(256), Random(256));

  // InverseColor := pAbout.color xor $808080;
  g := pAbout.color shr 8;
  if (g < 160) then
    InverseColor := clWhite
  else
    InverseColor := clBlack;

  lName.Font.color := InverseColor;
  lVersion.Font.color := InverseColor;
  lVersionDate.Font.color := InverseColor;
  lLicense.Font.color := InverseColor;

  pHLeft.color := InverseColor;
  pHLine.color := InverseColor;
  pHRight.color := InverseColor;
end;

end.
