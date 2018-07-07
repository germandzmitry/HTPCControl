library EventApplicationHook;

// http://vsokovikov.narod.ru/New_MSDN_API/Hook/fn_shellproc.htm
// https://msdn.microsoft.com/en-us/library/windows/desktop/ms644991(v=vs.85).aspx

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, System.Win.Registry;

{$R *.res}

const
  HookMap = '{F3E25943-FCC7-43E5-BE22-7CF35EA5FCC6}';

const
  WM_EventApplication = WM_USER + 177;

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

procedure SaveLog(str: String);
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
end;

procedure SendMsg(WindowHandle, Event: NativeInt);
begin
  SendMessage(HookData^.AppWnd, WM_EventApplication, WindowHandle, Event);
  //SaveLog(IntToStr(Event));
end;

function UsingEvent(Key: string): boolean;
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
  // WH_SHELL
  // HSHELL_WINDOWCREATED = 1
  // HSHELL_WINDOWDESTROYED = 2
  // HSHELL_ACTIVATESHELLWINDOW = 3
  // HSHELL_WINDOWACTIVATED = 4
  // HSHELL_GETMINRECT = 5
  // HSHELL_REDRAW = 6
  // HSHELL_TASKMAN = 7
  // HSHELL_LANGUAGE = 8
  // HSHELL_ACCESSIBILITYSTATE = 11
  // HSHELL_APPCOMMAND = 12
  // HSHELL_WINDOWREPLACED = 13

  if code >= 0 then
  begin
    case code of
      HSHELL_WINDOWCREATED:
        if UsingEvent('WINDOWCREATED') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_WINDOWDESTROYED:
        if UsingEvent('WINDOWDESTROYED') and (IsWindow(wParam)) and (GetParent(wParam) = 0) then
          SendMsg(wParam, code);
      HSHELL_ACTIVATESHELLWINDOW:
        if UsingEvent('ACTIVATESHELLWINDOW') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_WINDOWACTIVATED:
        if UsingEvent('WINDOWACTIVATED') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_GETMINRECT:
        if UsingEvent('GETMINRECT') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_REDRAW:
        if UsingEvent('REDRAW') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_TASKMAN:
        if UsingEvent('TASKMAN') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_LANGUAGE:
        if UsingEvent('LANGUAGE') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_ACCESSIBILITYSTATE:
        if UsingEvent('ACCESSIBILITYSTATE') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_APPCOMMAND:
        if UsingEvent('APPCOMMAND') and IsWindow(wParam) then
          SendMsg(wParam, code);
      HSHELL_WINDOWREPLACED:
        if UsingEvent('WINDOWREPLACED') and IsWindow(wParam) then
          SendMsg(wParam, code);
    end;

    Result := 0;
  end
  else
    Result := CallNextHookEx(HookData^.OldHook, code, wParam, lParam);
end;

function SetHook(wnd: HWND): BOOL; stdcall;
begin
  if HookData <> nil then
  begin
    HookData^.AppWnd := wnd;
    HookData^.OldHook := SetWindowsHookEx(WH_SHELL, @SysExecProc, HInstance, 0);
    Result := (HookData^.OldHook <> 0);
  end
  else
    Result := false;
end;

function RemoveHook: BOOL; stdcall;
begin
  Result := UnhookWindowsHookEx(HookData^.OldHook);
end;

exports SetHook, RemoveHook;

begin
  if @DLLProc = nil then
    DLLProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);

end.
