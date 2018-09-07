library ShellApplication;

// http://vsokovikov.narod.ru/New_MSDN_API/Hook/fn_shellproc.htm
// https://msdn.microsoft.com/en-us/library/windows/desktop/ms644991(v=vs.85).aspx

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, System.Win.Registry;

{$R *.res}

const
{$IFDEF WIN32}
  HookMap = '{F3E25943-FCC7-43E5-BE22-7CF35EA5FCC6x86}';
{$ELSE}
  HookMap = '{F3E25943-FCC7-43E5-BE22-7CF35EA5FCC6x64}';
{$IFEND}

const
  WM_ShellApplication = WM_USER + 177;

type
  PHookData = ^THookData;

  THookData = packed record
    AppWnd: HWND;
    OldHook: HHOOK;
  end;

var
  hMap: THandle = 0;
  HookData: PHookData = nil;

procedure DLLEntryPoint(dwReason: DWORD);
begin
  case dwReason of
    DLL_PROCESS_ATTACH:
      begin
        hMap := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0,
          SizeOf(THookData), HookMap);
        HookData := MapViewOfFile(hMap, FILE_MAP_ALL_ACCESS, 0, 0, SizeOf(THookData));
      end;
    DLL_PROCESS_DETACH:
      begin
        UnMapViewOfFile(HookData);
        CloseHandle(hMap);
      end
  end
end;

{ procedure SaveLog(str: String);
  var
  f: TextFile;
  const
  filedir: String = 'd:\stat.log';
  begin
  AssignFile(f, filedir);
  if not(FileExists(filedir)) then
  begin
  Rewrite(f);
  CloseFile(f);
  end;
  Append(f);
  Writeln(f, str);
  Flush(f);
  CloseFile(f);
  end; }

procedure SendMsg(WindowHandle, HSHELL: NativeInt);
begin
  SendMessage(HookData^.AppWnd, WM_ShellApplication, WindowHandle, HSHELL);
  // SaveLog(IntToStr(HSHELL));
end;

function UsingHSHELL(Key: string): boolean;
var
  Reg: TRegistry;
begin
  Result := false;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKeyReadOnly('\SOFTWARE\HTPCControl') and Reg.ValueExists(Key) then
      Result := Reg.ReadBool(Key);
    // SaveLog(Key + '-' + BoolToStr(Result));
  finally
    Reg.Free;
  end;
end;

function SysExecProc(code: integer; wParam: integer; lParam: longint): longint; export; stdcall;
var
  wndheader: array [0 .. MAX_PATH - 1] of char;
begin
  if code >= 0 then
  begin
    case code of
      HSHELL_WINDOWCREATED:
        if UsingHSHELL('WINDOWCREATED') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_WINDOWDESTROYED:
        if UsingHSHELL('WINDOWDESTROYED') and (IsWindow(wParam)) and (GetParent(wParam) = 0) then
          SendMsg(wParam, code);
      HSHELL_ACTIVATESHELLWINDOW:
        if UsingHSHELL('ACTIVATESHELLWINDOW') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_WINDOWACTIVATED:
        if UsingHSHELL('WINDOWACTIVATED') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_GETMINRECT:
        if UsingHSHELL('GETMINRECT') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_REDRAW:
        if UsingHSHELL('REDRAW') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_TASKMAN:
        if UsingHSHELL('TASKMAN') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_LANGUAGE:
        if UsingHSHELL('LANGUAGE') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_ACCESSIBILITYSTATE:
        if UsingHSHELL('ACCESSIBILITYSTATE') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_APPCOMMAND:
        if UsingHSHELL('APPCOMMAND') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_WINDOWREPLACED:
        if UsingHSHELL('WINDOWREPLACED') and IsWindow(wParam) then
          SendMsg(wParam, code);
    end;

    Result := 0;
  end
  else
    Result := CallNextHookEx(HookData^.OldHook, code, wParam, lParam);
end;

function SetHook(wnd: HWND; var Error: Cardinal): BOOL; stdcall;
begin
  if HookData <> nil then
  begin
    HookData^.AppWnd := wnd;
    HookData^.OldHook := SetWindowsHookEx(WH_SHELL, @SysExecProc, HInstance, 0);
    if HookData^.OldHook = 0 then
      Error := GetLastError;

    Result := (HookData^.OldHook <> 0);
  end
  else
    Result := false;
end;

function RemoveHook(var Error: Cardinal): BOOL; stdcall;
begin
  Result := UnhookWindowsHookEx(HookData^.OldHook);
  if not Result then
    Error := GetLastError;
end;

exports SetHook, RemoveHook;

begin
  if @DLLProc = nil then
    DLLProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);

end.
