unit uShellApplication;

interface

uses
  Winapi.Messages, Winapi.windows, System.SysUtils, System.Classes, Winapi.PsApi,
  Vcl.Controls, Vcl.Forms, Vcl.Graphics, uLanguage, Vcl.ExtCtrls, Winapi.Shellapi;

const
  WM_ShellApplication = WM_USER + 177;

{$IFDEF WIN64}

type
  TsaPipe = (saRead, saWrite);
  TShellApplicationPipeEvent = procedure(Line: string; Pipe: TsaPipe) of object;

  TThreadShellApplication_x86 = class(TThread)
  private
    FStartUpInfo: TStartUpInfo;
    FProcessInfo: TProcessInformation;
    FInWrite, FInRead: THandle;
    FOutWrite, FOutRead: THandle;

    FOnPipe: TShellApplicationPipeEvent;

    procedure DoPipe(Line: string; Pipe: TsaPipe); dynamic;
  protected
    procedure Execute; override;
  public
    constructor Create(Wnd: HWND; ShowConsole: boolean = false);

    property OnPipe: TShellApplicationPipeEvent read FOnPipe write FOnPipe;
  end;
{$ENDIF}

type
  TEXEVersionData = record
    Handle: HWND;
    FileName: string;
    Icon: TIcon;
    CompanyName: string;
    FileDescription: string;
    FileVersion: string;
    InternalName: string;
    LegalCopyright: string;
    LegalTrademarks: string;
    OriginalFileName: string;
    ProductName: string;
    ProductVersion: string;
    Comments: string;
    PrivateBuild: string;
    SpecialBuild: string;
  end;

  TAppRunningEvent = procedure(Running: boolean) of object;
  TAppEvent = procedure(Sender: TObject; const ApplicationData: TEXEVersionData) of object;
  TAppEvents = procedure(Sender: TObject; const HSHELL: NativeInt;
    const ApplicationData: TEXEVersionData) of object;
{$IFDEF WIN64}
  TAppStatus_x86 = procedure(Sender: TObject; const Line: string; const Pipe: TsaPipe) of object;
{$ENDIF}
  PHICON = ^HICON;

type
  TShellApplications = class(TWinControl)
    procedure Start();
    procedure Stop();
    function Starting(): boolean;
  private
    FHook: THandle;
    SetHook: function(Wnd: HWND; var Error: Cardinal): BOOL; stdcall;
    RemoveHook: function(var Error: Cardinal): BOOL; stdcall;
{$IFDEF WIN64}
    Fx86: TThreadShellApplication_x86;
{$ENDIF}
    FOnRunning: TAppRunningEvent;
    FOnWindowsHook: TAppEvents;
{$IFDEF WIN64}
    FOnStatus_x86: TAppStatus_x86;
{$ENDIF}
    FOnWindowCreated: TAppEvent;
    FOnWindowDestroyed: TAppEvent;
    FOnActivateShellWindow: TAppEvent;
    FOnWindowActivated: TAppEvent;
    FOnGetMinRect: TAppEvent;
    FOnReDraw: TAppEvent;
    FOnTaskMan: TAppEvent;
    FOnLanguage: TAppEvent;
    FOnAccessibilityState: TAppEvent;
    FOnAppCommand: TAppEvent;
    FOnWindowReplaced: TAppEvent;

    procedure ShellApplication(var Msg: TMessage); message WM_ShellApplication;

    procedure DoRunning(Running: boolean); dynamic;
{$IFDEF WIN64}
    procedure DoStatus_x86(Line: string; Pipe: TsaPipe); dynamic;
{$ENDIF}
    procedure DoWindowsHook(HSHELL: NativeInt; ApplicationData: TEXEVersionData); dynamic;
    procedure DoWindowCreated(ApplicationData: TEXEVersionData); dynamic;
    procedure DoWindowDestroyed(ApplicationData: TEXEVersionData); dynamic;
    procedure DoActivateShellWindow(ApplicationData: TEXEVersionData); dynamic;
    procedure DoWindowActivated(ApplicationData: TEXEVersionData); dynamic;
    procedure DoGetMinRect(ApplicationData: TEXEVersionData); dynamic;
    procedure DoReDraw(ApplicationData: TEXEVersionData); dynamic;
    procedure DoTaskMan(ApplicationData: TEXEVersionData); dynamic;
    procedure DoLanguage(ApplicationData: TEXEVersionData); dynamic;
    procedure DoAccessibilityState(ApplicationData: TEXEVersionData); dynamic;
    procedure DoAppCommand(ApplicationData: TEXEVersionData); dynamic;
    procedure DoWindowReplaced(ApplicationData: TEXEVersionData); dynamic;

    function GetEXEVersionData(const ProcessHandle: HWND): TEXEVersionData;

{$IFDEF WIN64}
    procedure Start_x86();
    procedure Stop_x86();
    procedure onShellApplicationPipe(Line: string; Pipe: TsaPipe);
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property OnRunning: TAppRunningEvent read FOnRunning write FOnRunning;
{$IFDEF WIN64}
    property OnStatus_x86: TAppStatus_x86 read FOnStatus_x86 write FOnStatus_x86;
{$ENDIF}
    property OnWindowsHook: TAppEvents read FOnWindowsHook write FOnWindowsHook;
    property OnWindowCreated: TAppEvent read FOnWindowCreated write FOnWindowCreated;
    property OnWindowDestroyed: TAppEvent read FOnWindowDestroyed write FOnWindowDestroyed;
    property OnActivateShellWindow: TAppEvent read FOnActivateShellWindow
      write FOnActivateShellWindow;
    property OnWindowActivated: TAppEvent read FOnWindowActivated write FOnWindowActivated;
    property OnGetMinRect: TAppEvent read FOnGetMinRect write FOnGetMinRect;
    property OnReDraw: TAppEvent read FOnReDraw write FOnReDraw;
    property OnTaskMan: TAppEvent read FOnTaskMan write FOnTaskMan;
    property OnLanguage: TAppEvent read FOnLanguage write FOnLanguage;
    property OnAccessibilityState: TAppEvent read FOnAccessibilityState write FOnAccessibilityState;
    property OnAppCommand: TAppEvent read FOnAppCommand write FOnAppCommand;
    property OnWindowReplaced: TAppEvent read FOnWindowReplaced write FOnWindowReplaced;

  end;

function ExtractIconEx(lpszFile: LPCWSTR; nIconIndex: Integer; phiconLarge, phiconSmall: PHICON;
  nIcons: UINT): UINT; stdcall; external 'shell32.dll' name 'ExtractIconExW';
procedure SmallIconEXE(const FileName: string; var Icon: TIcon);
function GetExePath(const ProcessHandle: HWND): string;
procedure LoadIcon(FileName: String; Image: TImage);

implementation

{$IFDEF WIN64}
{ TThreadShellApplication_x86 }

constructor TThreadShellApplication_x86.Create(Wnd: HWND; ShowConsole: boolean);
var
  CommandLine: String;
  CreationFlags: DWORD;
  SecurityAttr: TSecurityAttributes;
begin

  inherited Create(true);
  FreeOnTerminate := false;

  FillChar(SecurityAttr, SizeOf(SecurityAttr), #0);
  SecurityAttr.nLength := SizeOf(SecurityAttr);
  SecurityAttr.lpSecurityDescriptor := nil;
  SecurityAttr.bInheritHandle := true;

  if not CreatePipe(FInRead, FInWrite, @SecurityAttr, 0) then
    raise Exception.Create(SysErrorMessage(GetLastError));

  if not CreatePipe(FOutRead, FOutWrite, @SecurityAttr, 0) then
    raise Exception.Create(SysErrorMessage(GetLastError));

  FillChar(FStartUpInfo, SizeOf(TStartUpInfo), 0);
  with FStartUpInfo do
  begin
    cb := SizeOf(FStartUpInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := SW_SHOW;
  end;

  if ShowConsole then
    CreationFlags := NORMAL_PRIORITY_CLASS
  else
  begin
    FStartUpInfo.dwFlags := FStartUpInfo.dwFlags + STARTF_USESTDHANDLES;
    FStartUpInfo.hStdInput := FInRead;
    FStartUpInfo.hStdOutput := FOutWrite;
    FStartUpInfo.hStdError := FOutWrite;
    CreationFlags := CREATE_NO_WINDOW;
  end;

  CommandLine := 'sa86.exe ' + inttostr(Wnd);
  // CommandLine := 'cmd /?';

  UniqueString(CommandLine);

  if CreateProcess(nil, PWideChar(CommandLine), nil, nil, true, CreationFlags, nil, nil,
    FStartUpInfo, FProcessInfo) then
    WaitForInputIdle(FProcessInfo.hProcess, INFINITE)
  else
    raise Exception.Create(SysErrorMessage(GetLastError));
end;

procedure TThreadShellApplication_x86.Execute;

  function StrOemToAnsi(const aStr: AnsiString): AnsiString;
  var
    Len: Integer;
  begin
    Len := Length(aStr);
    SetLength(Result, Len);
    OemToCharBuffA(PAnsiChar(aStr), PAnsiChar(Result), Len);
  end;

var
  ExitCode, BytesRead, BufSize: Cardinal;
  Buffer: array [0 .. 1024] of AnsiChar;
  Str: AnsiString;
begin

  while not Terminated do
  begin

    // получаем состояние дочернего процесса
    GetExitCodeProcess(FProcessInfo.hProcess, ExitCode);
    // Если процес завершен, завершаем поток
    if ExitCode <> STILL_ACTIVE then
    begin
      Terminate;
      Sleep(50);
    end;

    // Смотрим сколько данных должны прочитать
    if PeekNamedPipe(FOutRead, nil, 0, nil, @BufSize, nil) then
    begin
      // Если есть что читать, читаем
      if BufSize > 0 then
      begin
        FillChar(Buffer, 1024, #0);

        if BufSize > 1024 then
          BufSize := 1024;

        // Читаем данные из консоли
        ReadFile(FOutRead, Buffer, BufSize, BytesRead, nil);

        // Возвращаем кодировку
        SetLength(Str, BufSize);
        OemToCharBuffA(PAnsiChar(AnsiString(Buffer)), PAnsiChar(Str), BufSize);

        Synchronize(
          procedure
          begin
            DoPipe(String(Str), saRead);
          end);
      end
      // Если нечего читать, ждем, иначе поток съедает 25-30% процесора
      else
        Sleep(10);
    end;

  end;

  GetExitCodeProcess(FProcessInfo.hProcess, ExitCode);
  // Если процес не завершен, завершаем его
  if ExitCode = STILL_ACTIVE then
    TerminateProcess(FProcessInfo.hProcess, NO_ERROR);

  CloseHandle(FProcessInfo.hThread);
  CloseHandle(FProcessInfo.hProcess);
  CloseHandle(FInRead);
  CloseHandle(FInWrite);
  CloseHandle(FOutRead);
  CloseHandle(FOutWrite);
end;

procedure TThreadShellApplication_x86.DoPipe(Line: string; Pipe: TsaPipe);
begin
  if Assigned(FOnPipe) then
    FOnPipe(Trim(Line), Pipe);
end;

{$ENDIF}
{ TShellApplications }

constructor TShellApplications.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Parent := TWinControl(AOwner);
  FHook := INVALID_HANDLE_VALUE;
end;

destructor TShellApplications.Destroy;
begin
  if Starting then
    Stop;
  inherited;
end;

procedure TShellApplications.Start();
var
  LError: Cardinal;
begin
  if Starting then
    raise Exception.Create(GetLanguageMsg('msgEventAppHookIsLoad', lngRus));

{$IFDEF WIN32}
  FHook := LoadLibrary('ShellApplication.dll');
{$ELSE}
  FHook := LoadLibrary('ShellApplication.64.dll');
{$ENDIF}
  if FHook = 0 then
    raise Exception.CreateFmt(GetLanguageMsg('msgEventAppLoadLibrary', lngRus),
      [SysErrorMessage(GetLastError)]);

  @SetHook := GetProcAddress(FHook, 'SetHook');
  if @SetHook = nil then
  begin
    LError := GetLastError;
    FreeLibrary(FHook);
    FHook := INVALID_HANDLE_VALUE;
    raise Exception.CreateFmt(GetLanguageMsg('msgEventAppGetProcAddress', lngRus),
      ['SetHook', SysErrorMessage(LError)]);
  end;

  if SetHook(Self.Handle, LError) then
  begin
    DoRunning(true);
{$IFDEF WIN64}
    Start_x86();
{$ENDIF}
  end
  else
    raise Exception.CreateFmt(GetLanguageMsg('msgEventAppLoadHook', lngRus),
      [SysErrorMessage(LError)]);

end;

function TShellApplications.Starting: boolean;
begin
  if FHook = INVALID_HANDLE_VALUE then
    Result := false
  else
    Result := true;
end;

procedure TShellApplications.Stop();
var
  LError: Cardinal;
begin
  if not Starting then
    Exit;

{$IFDEF WIN64}
  Stop_x86();
{$ENDIF}
  @RemoveHook := GetProcAddress(FHook, 'RemoveHook');
  if @RemoveHook = nil then
  begin
    LError := GetLastError;
    FreeLibrary(FHook);
    FHook := INVALID_HANDLE_VALUE;
    raise Exception.CreateFmt(GetLanguageMsg('msgEventAppGetProcAddress', lngRus),
      ['RemoveHook', SysErrorMessage(LError)]);
  end;

  if RemoveHook(LError) then
  begin
    DoRunning(false);
    FreeLibrary(FHook);
    FHook := INVALID_HANDLE_VALUE;
  end
  else
    raise Exception.CreateFmt(GetLanguageMsg('MsgEventAppUnloadHook', lngRus),
      [SysErrorMessage(LError)]);
end;

{$IFDEF WIN64}

procedure TShellApplications.Start_x86();
begin
  Fx86 := TThreadShellApplication_x86.Create(Self.Handle, false);
  Fx86.Priority := tpLowest;
  Fx86.OnPipe := onShellApplicationPipe;
  Fx86.Start;
end;

procedure TShellApplications.Stop_x86();
begin
  if not Assigned(Fx86) then
    Exit;

  Fx86.Terminate;
  Sleep(50);
  FreeAndNil(Fx86);
  Sleep(50);
end;

procedure TShellApplications.onShellApplicationPipe(Line: string; Pipe: TsaPipe);
begin
  DoStatus_x86(Line, Pipe);
end;

{$ENDIF}

procedure TShellApplications.DoAccessibilityState(ApplicationData: TEXEVersionData);
begin
  if Assigned(FOnActivateShellWindow) then
    FOnAccessibilityState(Self, ApplicationData);
end;

procedure TShellApplications.DoActivateShellWindow(ApplicationData: TEXEVersionData);
begin
  if Assigned(FOnActivateShellWindow) then
    FOnActivateShellWindow(Self, ApplicationData);
end;

procedure TShellApplications.DoAppCommand(ApplicationData: TEXEVersionData);
begin
  if Assigned(FOnAppCommand) then
    FOnAppCommand(Self, ApplicationData);
end;

procedure TShellApplications.DoGetMinRect(ApplicationData: TEXEVersionData);
begin
  if Assigned(FOnGetMinRect) then
    FOnGetMinRect(Self, ApplicationData);
end;

procedure TShellApplications.DoLanguage(ApplicationData: TEXEVersionData);
begin
  if Assigned(FOnLanguage) then
    FOnLanguage(Self, ApplicationData);
end;

procedure TShellApplications.DoReDraw(ApplicationData: TEXEVersionData);
begin
  if Assigned(FOnReDraw) then
    FOnReDraw(Self, ApplicationData);
end;

procedure TShellApplications.DoRunning(Running: boolean);
begin
  if Assigned(FOnRunning) then
    FOnRunning(Running);
end;

{$IFDEF WIN64}

procedure TShellApplications.DoStatus_x86(Line: string; Pipe: TsaPipe);
begin
  if Assigned(FOnStatus_x86) then
    FOnStatus_x86(Self, Line, Pipe);
end;
{$ENDIF}

procedure TShellApplications.DoTaskMan(ApplicationData: TEXEVersionData);
begin
  if Assigned(FOnTaskMan) then
    FOnTaskMan(Self, ApplicationData);
end;

procedure TShellApplications.DoWindowActivated(ApplicationData: TEXEVersionData);
begin
  if Assigned(FOnWindowActivated) then
    FOnWindowActivated(Self, ApplicationData);
end;

procedure TShellApplications.DoWindowCreated(ApplicationData: TEXEVersionData);
begin
  if Assigned(FOnWindowCreated) then
    FOnWindowCreated(Self, ApplicationData);
end;

procedure TShellApplications.DoWindowDestroyed(ApplicationData: TEXEVersionData);
begin
  if Assigned(FOnWindowDestroyed) then
    FOnWindowDestroyed(Self, ApplicationData);
end;

procedure TShellApplications.DoWindowsHook(HSHELL: NativeInt; ApplicationData: TEXEVersionData);
begin
  if Assigned(FOnWindowsHook) then
    FOnWindowsHook(Self, HSHELL, ApplicationData);
end;

procedure TShellApplications.DoWindowReplaced(ApplicationData: TEXEVersionData);
begin
  if Assigned(FOnWindowReplaced) then
    FOnWindowReplaced(Self, ApplicationData);
end;

procedure TShellApplications.ShellApplication(var Msg: TMessage);
var
  ApplicationData: TEXEVersionData;
begin
  if IsWindow(Msg.WParam) then
  begin
    ApplicationData := GetEXEVersionData(Msg.WParam);

    DoWindowsHook(Msg.LParam, ApplicationData);

    case Msg.LParam of
      HSHELL_WINDOWCREATED:
        DoWindowCreated(ApplicationData);
      HSHELL_WINDOWDESTROYED:
        DoWindowDestroyed(ApplicationData);
      HSHELL_ACTIVATESHELLWINDOW:
        DoActivateShellWindow(ApplicationData);
      HSHELL_WINDOWACTIVATED:
        DoWindowActivated(ApplicationData);
      HSHELL_GETMINRECT:
        DoGetMinRect(ApplicationData);
      HSHELL_REDRAW:
        DoReDraw(ApplicationData);
      HSHELL_TASKMAN:
        DoTaskMan(ApplicationData);
      HSHELL_LANGUAGE:
        DoLanguage(ApplicationData);
      HSHELL_ACCESSIBILITYSTATE:
        DoAccessibilityState(ApplicationData);
      HSHELL_APPCOMMAND:
        DoAppCommand(ApplicationData);
      HSHELL_WINDOWREPLACED:
        DoWindowReplaced(ApplicationData);
    end;

  end;
  Msg.Result := 1;
end;

function TShellApplications.GetEXEVersionData(const ProcessHandle: HWND): TEXEVersionData;
type
  PLandCodepage = ^TLandCodepage;

  TLandCodepage = record
    wLanguage, wCodePage: word;
  end;
var
  dummy, Len: Cardinal;
  buf, pntr: pointer;
  lang: string;
begin
  Result.Handle := ProcessHandle;
  Result.FileName := GetExePath(ProcessHandle);

  try
    Result.Icon := TIcon.Create();
    SmallIconEXE(Result.FileName, Result.Icon);
  except

  end;

  Len := GetFileVersionInfoSize(PChar(Result.FileName), dummy);
  if Len = 0 then
    Exit;

  GetMem(buf, Len);
  try

    try
      if not GetFileVersionInfo(PChar(Result.FileName), 0, Len, buf) then
        Exit;
      // RaiseLastOSError;

      if not VerQueryValue(buf, '\VarFileInfo\Translation\', pntr, Len) then
        Exit;
      // RaiseLastOSError;

      lang := Format('%.4x%.4x', [PLandCodepage(pntr)^.wLanguage, PLandCodepage(pntr)^.wCodePage]);

      if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\CompanyName'), pntr, Len)
      { and (@len <> nil) } then
        Result.CompanyName := PChar(pntr);
      if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\FileDescription'), pntr, Len)
      { and (@len <> nil) } then
        Result.FileDescription := PChar(pntr);
      if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\FileVersion'), pntr, Len)
      { and (@len <> nil) } then
        Result.FileVersion := PChar(pntr);
      if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\InternalName'), pntr, Len)
      { and (@len <> nil) } then
        Result.InternalName := PChar(pntr);
      if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\LegalCopyright'), pntr, Len)
      { and (@len <> nil) } then
        Result.LegalCopyright := PChar(pntr);
      if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\LegalTrademarks'), pntr, Len)
      { and (@len <> nil) } then
        Result.LegalTrademarks := PChar(pntr);
      if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\OriginalFileName'), pntr, Len)
      { and (@len <> nil) } then
        Result.OriginalFileName := PChar(pntr);
      if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\ProductName'), pntr, Len)
      { and (@len <> nil) } then
        Result.ProductName := PChar(pntr);
      if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\ProductVersion'), pntr, Len)
      { and (@len <> nil) } then
        Result.ProductVersion := PChar(pntr);
      if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\Comments'), pntr, Len)
      { and (@len <> nil) } then
        Result.Comments := PChar(pntr);
      if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\PrivateBuild'), pntr, Len)
      { and (@len <> nil) } then
        Result.PrivateBuild := PChar(pntr);
      if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\SpecialBuild'), pntr, Len)
      { and (@len <> nil) } then
        Result.SpecialBuild := PChar(pntr);
    except
      on E: Exception do
        Result.FileDescription := ExtractFileName(Result.FileName);
    end;

  finally
    FreeMem(buf);
  end;
  // RaiseLastOSError;

end;

{ }
procedure SmallIconEXE(const FileName: string; var Icon: TIcon);
var
  LIcon: HICON;
  ExtractedIconCount: UINT;
begin
  try
    ExtractedIconCount := ExtractIconEx(PChar(FileName), 0, nil, @LIcon, 1);
    // Win32Check(ExtractedIconCount = 1);
    if ExtractedIconCount > 0 then
      Icon.Handle := LIcon;
    // DestroyIcon(LIcon);
  except
    raise;
  end;
end;

function GetExePath(const ProcessHandle: HWND): String;
var
  ph: THandle;
  FileName: array [0 .. MAX_PATH - 1] of Char;
  pid: Cardinal;
begin
  Result := '';
  GetWindowThreadProcessId(ProcessHandle, @pid);
  ph := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, false, pid);
  if ph <> 0 then
    try
      if GetModuleFileNameEx(ph, 0, FileName, SizeOf(FileName)) > 0 then
        Result := FileName;
    finally
      CloseHandle(ph);
    end;
end;

procedure LoadIcon(FileName: String; Image: TImage);
var
  Icon: TIcon;
  FileInfo: SHFILEINFO;
begin
  if FileExists(FileName) then
  begin
    Icon := TIcon.Create;
    try
      SHGetFileInfo(PChar(FileName), 0, FileInfo, SizeOf(FileInfo), SHGFI_ICON);
      Icon.Handle := FileInfo.HICON;
      Image.Picture.Icon := Icon;
    finally
      Icon.Free;
    end;
  end;
end;

end.
