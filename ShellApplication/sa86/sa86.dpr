program sa86;

{ https://www.experts-exchange.com/questions/20720668/Need-to-disable-StdOut-buffer-for-a-console-app-in-delphi.html }

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils, Winapi.Windows;

function ToOem(const AStr: String): AnsiString;
begin
  SetLength(Result, Length(AStr));
  CharToOemBuff(PChar(AStr), PAnsiChar(Result), Length(AStr));
end;

procedure WriteLn(const Str: String);
var
  hOut: THandle;
  dwWritten, BufSize: DWORD;
  Buf: array of AnsiChar;
  i: integer;
  strWrite: AnsiString;
begin
  hOut := GetStdHandle(STD_OUTPUT_HANDLE);
  BufSize := Length(Str) + 2;
  SetLength(Buf, BufSize);

  strWrite := ToOem(Str);
  for i := 1 to BufSize - 2 do
    Buf[i - 1] := strWrite[i];

  Buf[BufSize - 2] := #13;
  Buf[BufSize - 1] := #10;

  WriteFile(hOut, PAnsiChar(Buf)^, BufSize, dwWritten, nil);
end;

var
  Handle: HWND;
  FHook: THandle;
  HookError: Cardinal;
  SetHook: function(Wnd: HWND; var Error: Cardinal): BOOL; stdcall;

begin
  try

    if Length(ParamStr(1)) = 0 then
    begin
      WriteLn('Параметр на найден');
      // Readln;
      exit;
    end;

    Handle := StrToInt(ParamStr(1));

    // загружаем библиотеку
    FHook := LoadLibrary('ShellApplication.dll');
    if FHook = 0 then
    begin
      WriteLn(SysErrorMessage(GetLastError));
      // Readln;
      exit;
    end;

    // получаем адресс функции
    @SetHook := GetProcAddress(FHook, 'SetHook');
    if @SetHook = nil then
    begin
      WriteLn(SysErrorMessage(GetLastError));
      FreeLibrary(FHook);
      // Readln;
      exit;
    end;

    // устанавливаем хук
    if not SetHook(Handle, HookError) then
    begin
      WriteLn(SysErrorMessage(HookError));
      FreeLibrary(FHook);
      // Readln;
      exit;
    end;

    WriteLn('OK');
    Readln;
  except
    on E: Exception do
      WriteLn(E.ClassName + ': ' + E.Message);
  end;

end.
