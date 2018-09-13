unit uIcon;

interface

uses System.SysUtils, Vcl.Graphics, Vcl.ExtCtrls, ShellApi;

procedure StockIcon(SIID: integer; Icon: TIcon);
procedure ApplicationIcon(FileName: String; Icon: TIcon); overload;
procedure ApplicationIcon(FileName: String; Image: TImage); overload;

implementation

procedure StockIcon(SIID: integer; Icon: TIcon);
var
  SSII: TSHStockIconInfo;
begin
  SSII.cbSize := SizeOf(SSII);
  SHGetStockIconInfo(SIID, SHGSI_ICON or SHGSI_SMALLICON, SSII);
  Icon.Handle := SSII.hIcon;
end;

procedure ApplicationIcon(FileName: String; Icon: TIcon);
var
  FileInfo: SHFILEINFO;
begin
  if FileExists(FileName) then
  begin
    SHGetFileInfo(PChar(FileName), 0, FileInfo, SizeOf(FileInfo), SHGFI_ICON);
    Icon.Handle := FileInfo.hIcon;
  end;
end;

procedure ApplicationIcon(FileName: String; Image: TImage);
var
  Icon: TIcon;
begin
  Icon := TIcon.Create;
  try
    ApplicationIcon(FileName, Icon);
    Image.Picture.Icon := Icon;
  finally
    Icon.Free;
  end;
end;

end.
