unit uShellApplication;

interface

uses
  Winapi.Messages, Winapi.windows, System.SysUtils, System.Classes, Winapi.PsApi,
  Vcl.Controls, Vcl.Forms, Vcl.Graphics, uLanguage;

const
  WM_ShellApplication = WM_USER + 177;

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

  PHICON = ^HICON;

type
  TShellApplications = class(TWinControl)
    procedure Start();
    procedure Stop();
    function Starting(): boolean;
  private
    FHook: THandle;
    FWindow: HWND;

    SetHook: function(Wnd: HWND): BOOL; stdcall;
    RemoveHook: function(var Error: Cardinal): BOOL; stdcall;

    FOnRunning: TAppRunningEvent;
    FOnWindowsHook: TAppEvents;
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
    function GetExePath(const ProcessHandle: HWND): string;
    function GetSmallIconEXE(const FileName: string): TIcon;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property OnRunning: TAppRunningEvent read FOnRunning write FOnRunning;
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

implementation

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

procedure TShellApplications.Start();
begin
  if not Starting then
  begin
    FHook := LoadLibrary('ShellApplication.dll');
    if FHook <> 0 then
    begin
      @SetHook := GetProcAddress(FHook, 'SetHook');
      if (@SetHook <> nil) and (SetHook(Self.Handle)) then
        DoRunning(true)
      else
        raise Exception.Create(GetLanguageMsg('msgEventAppLoadHook', lngRus));
    end
    else
      raise Exception.CreateFmt(GetLanguageMsg('msgEventAppFileNotFound', lngRus),
        ['ShellApplication.dll']);
  end
  else
    raise Exception.Create(GetLanguageMsg('msgEventAppHookIsLoad', lngRus));
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
  if Starting then
  begin
    @RemoveHook := GetProcAddress(FHook, 'RemoveHook');
    if @RemoveHook <> nil then
      if RemoveHook(LError) then
      begin
        DoRunning(false);
        FreeLibrary(FHook);
        FHook := INVALID_HANDLE_VALUE;
      end
      else
        raise Exception.CreateFmt(GetLanguageMsg('MsgEventAppUnloadHook', lngRus),
          [SysErrorMessage(LError)]);
  end
  else
    raise Exception.CreateFmt(GetLanguageMsg('MsgEventAppFileNotFound', lngRus),
      ['ShellApplication.dll']);
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

function TShellApplications.GetExePath(const ProcessHandle: HWND): String;
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

function TShellApplications.GetEXEVersionData(const ProcessHandle: HWND): TEXEVersionData;
type
  PLandCodepage = ^TLandCodepage;

  TLandCodepage = record
    wLanguage, wCodePage: word;
  end;
var
  dummy, len: Cardinal;
  buf, pntr: pointer;
  lang: string;
begin
  Result.Handle := ProcessHandle;
  Result.FileName := GetExePath(ProcessHandle);

  try

    Result.Icon := GetSmallIconEXE(Result.FileName);

    len := GetFileVersionInfoSize(PChar(Result.FileName), dummy);
    if len = 0 then
      RaiseLastOSError;
    GetMem(buf, len);

    if not GetFileVersionInfo(PChar(Result.FileName), 0, len, buf) then
      RaiseLastOSError;

    if not VerQueryValue(buf, '\VarFileInfo\Translation\', pntr, len) then
      RaiseLastOSError;

    lang := Format('%.4x%.4x', [PLandCodepage(pntr)^.wLanguage, PLandCodepage(pntr)^.wCodePage]);

    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\CompanyName'), pntr, len)
    { and (@len <> nil) } then
      Result.CompanyName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\FileDescription'), pntr, len)
    { and (@len <> nil) } then
      Result.FileDescription := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\FileVersion'), pntr, len)
    { and (@len <> nil) } then
      Result.FileVersion := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\InternalName'), pntr, len)
    { and (@len <> nil) } then
      Result.InternalName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\LegalCopyright'), pntr, len)
    { and (@len <> nil) } then
      Result.LegalCopyright := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\LegalTrademarks'), pntr, len)
    { and (@len <> nil) } then
      Result.LegalTrademarks := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\OriginalFileName'), pntr, len)
    { and (@len <> nil) } then
      Result.OriginalFileName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\ProductName'), pntr, len)
    { and (@len <> nil) } then
      Result.ProductName := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\ProductVersion'), pntr, len)
    { and (@len <> nil) } then
      Result.ProductVersion := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\Comments'), pntr, len)
    { and (@len <> nil) } then
      Result.Comments := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\PrivateBuild'), pntr, len)
    { and (@len <> nil) } then
      Result.PrivateBuild := PChar(pntr);
    if VerQueryValue(buf, PChar('\StringFileInfo\' + lang + '\SpecialBuild'), pntr, len)
    { and (@len <> nil) } then
      Result.SpecialBuild := PChar(pntr);
    FreeMem(buf);
  except
    on E: Exception do
    begin
      FreeMem(buf);
      Result.FileDescription := ExtractFileName(Result.FileName);
    end;
  end;
end;

function TShellApplications.GetSmallIconEXE(const FileName: string): TIcon;
var
  Icon: HICON;
  ExtractedIconCount: UINT;
begin
  Result := nil;
  try
    ExtractedIconCount := ExtractIconEx(PChar(FileName), 0, nil, @Icon, 1);
    Win32Check(ExtractedIconCount = 1);
    Result := TIcon.Create;
    Result.Handle := Icon;
  except
    Result.Free;
    raise;
  end;
end;

end.