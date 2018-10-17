unit uMain;

{ https://sourceforge.net/projects/comport/?source=typ_redirect }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ToolWin, Vcl.ActnMan,
  Vcl.ActnCtrls, Vcl.ActnList, System.Win.Registry, System.Actions,
  Vcl.PlatformDefaultStyleActnCtrls, UCustomPageControl, System.UITypes,
  System.ImageList, Vcl.ImgList, Winapi.shellApi, System.IniFiles,
  uShellApplication, uSettings, uDataBase, uEventKodi, uComPort, Vcl.Menus,
  Vcl.ActnPopup, CommCtrl, uExecuteCommand, System.Notification, Vcl.AppEvnts,
  MMDevApi, Winapi.ActiveX, Vcl.ActnMenus, uTypes, Vcl.Grids, Vcl.Themes,
  uCustomListBox, Vcl.GraphUtil, uCustomCategoryPanelGroup, Vcl.Tabs,
  Vcl.DockTabSet, uLine;

type
  TMain = class(TForm)
    StatusBar: TStatusBar;
    pLeft: TPanel;
    SplitterLeft: TSplitter;
    pClient: TPanel;
    ActionList: TActionList;
    ActHelpAbout: TAction;
    ilSmall: TImageList;
    ActToolsSetting: TAction;
    ActToolsDeviceManager: TAction;
    ActionManager: TActionManager;
    ActRCOpenAccess: TAction;
    ActComPortOpen: TAction;
    ActComPortSend: TAction;
    ActComPortClose: TAction;
    ActComPortOpenClose: TAction;
    lvReadComPort: TListView;
    PopupActReadComPort: TPopupActionBar;
    ActRCAdd: TAction;
    ActRCEdit: TAction;
    ActRCDelete: TAction;
    ActPopupRCAdd: TMenuItem;
    ActPopupRCEdit: TMenuItem;
    ActPopupRCDelete: TMenuItem;
    ActRCRCommandsControl: TAction;
    Tray: TTrayIcon;
    AppEvents: TApplicationEvents;
    ActionMainMenuBar: TActionMainMenuBar;
    ActFileExit: TAction;
    ActFile: TAction;
    ActComPort: TAction;
    ActRC: TAction;
    ActShellApp: TAction;
    ActKodi: TAction;
    ActTools: TAction;
    ActHelp: TAction;
    ActionToolBar1: TActionToolBar;
    ActShellAppStart: TAction;
    ActShellAppStop: TAction;
    ActKodiStart: TAction;
    ActKodiStop: TAction;
    SplitterBottom: TSplitter;
    plvReadComPort: TPanel;

    AppNotification: TNotificationCenter;
    pClientBottom: TPanel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);

    procedure ActHelpAboutExecute(Sender: TObject);
    procedure ActToolsSettingExecute(Sender: TObject);
    procedure ActToolsDeviceManagerExecute(Sender: TObject);
    procedure ActRCOpenAccessExecute(Sender: TObject);
    procedure ActComPortOpenExecute(Sender: TObject);
    procedure ActComPortSendExecute(Sender: TObject);
    procedure ActComPortCloseExecute(Sender: TObject);
    procedure ActComPortOpenCloseExecute(Sender: TObject);
    procedure ActRCAddExecute(Sender: TObject);
    procedure ActRCEditExecute(Sender: TObject);
    procedure ActRCDeleteExecute(Sender: TObject);
    procedure lvReadComPortContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
    procedure ActRCRCommandsControlExecute(Sender: TObject);
    procedure AppEventsMinimize(Sender: TObject);
    procedure TrayDblClick(Sender: TObject);
    procedure ActFileExecute(Sender: TObject);
    procedure ActFileExitExecute(Sender: TObject);
    procedure ActComPortExecute(Sender: TObject);
    procedure ActRCExecute(Sender: TObject);
    procedure ActShellAppExecute(Sender: TObject);
    procedure ActKodiExecute(Sender: TObject);
    procedure ActToolsExecute(Sender: TObject);
    procedure ActHelpExecute(Sender: TObject);
    procedure ActShellAppStartExecute(Sender: TObject);
    procedure ActShellAppStopExecute(Sender: TObject);
    procedure AppEventsMessage(var Msg: tagMSG; var Handled: Boolean);

    procedure lvShellApplicationCustomDrawSubItem(Sender: TCustomListView; Item: TListItem;
      SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ActKodiStartExecute(Sender: TObject);
    procedure ActKodiStopExecute(Sender: TObject);
    procedure lvReadComPortDblClick(Sender: TObject);
    procedure lvReadComPortDrawItem(Sender: TCustomListView; Item: TListItem; Rect: TRect;
      State: TOwnerDrawState);
    procedure lvReadComPortCustomDraw(Sender: TCustomListView; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure cpgStateMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint;
      var Handled: Boolean);
    procedure cpgStateMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint;
      var Handled: Boolean);
    procedure pClientBottomResize(Sender: TObject);
    procedure cpRemoteControlExpand(Sender: TObject);
  private
    { Private declarations }
    plvRemoteControl: TPanel;
    plvShellApplication: TPanel;
    plvEventKodi: TPanel;

    lbRemoteControl: TCustomListBoxRC;
    lvShellApplication: TListView;
    lvEventKodi: TListView;

    cpgState: TCustomCategoryPanelGroup;
    cpRemoteControl: TCustomCategoryPanel;
    cpShellApplication: TCustomCategoryPanel;
    cpKodi: TCustomCategoryPanel;

    pRemoteControlLast: TPanel;
    mRemoteControlLastL: TMemo;
    mRemoteControlLastV: TMemo;
{$IFDEF WIN64}
    pShellApplication_x86: TPanel;
    mShellApplication_x86L: TMemo;
    mShellApplication_x86V: TMemo;
{$ENDIF}
    pShellApplicationFile: TPanel;
    mShellApplicationFileL: TMemo;
    mShellApplicationFileV: TMemo;

    pKodiPlayingLabel: TPanel;
    mKodiPlayingLabelL: TMemo;
    mKodiPlayingLabelV: TMemo;

    pKodiPlayingFile: TPanel;
    mKodiPlayingFileL: TMemo;
    mKodiPlayingFileV: TMemo;

    FArduino: TComPort;
    FExecuteCommand: TExecuteCommand;
    FKodi: TKodi;
    FDataBase: TDataBase;
    FShellApplication: TShellApplications;
    FSetting: TSetting;

    FPageClient: TCustomPageControl;
    FSureExit: Boolean;
    FProcessingEventHandler: Boolean;

{$IFDEF DEBUG}
    edTestReadData: TEdit;
    btnTestReadData: TButton;
    pTestReadData: TPanel;
{$ENDIF}
    procedure LoadWindowSetting();
    procedure SaveWindowSetting();

    procedure TurnTray();
    procedure OpenTray();

    procedure OpenComPort();
    procedure CloseComPort();

    procedure StartEventApplication();
    procedure StopEventApplication();

    procedure StartEventKodi();
    procedure StopEventKodi();

    procedure ShowNotification(const Title, AlertBode: string);

    procedure onComPortBeforeOpen(Sender: TObject);
    procedure onComPortAfterOpen(Sender: TObject);
    procedure onComPortClose(Sender: TObject);
    procedure onComPortReadData(Sender: TObject; const Data: string);

    procedure onShellApplicationRunning(Running: Boolean);
{$IFDEF WIN64}
    procedure onShellApplicationStatus_x86(Sender: TObject; const Line: string;
      const Pipe: TsaPipe);
{$ENDIF}
    procedure onShellApplicationWindowsHook(Sender: TObject; const HSHELL: NativeInt;
      const ApplicationData: TEXEVersionData);

    procedure onExecuteCommandBegin(EIndex: Integer; RCommand: TRemoteCommand; Operations: string;
      OWait: Integer; RepeatPrevious: Boolean);
    procedure onExecuteCommandEnd(EIndex: Integer);
    procedure onExecuteCommandExecuting(EIndex: Integer; Step: Integer);
    procedure onExecuteCommandPrevious(Operations: string);

    procedure onKodiRunning(Running: Boolean);
    procedure onKodiPlayer(Player: string);
    procedure onKodiPlayerState(Player, State: string);
    procedure onKodiPlaying(Player: string; Playing: TPlaying);

    procedure CreateActionMenu();
    procedure CreateComponent();
    procedure SettingComponent();

    function Processing: Boolean;
    procedure SetMemoHeight(AMemo: TMemo);
    procedure SetMemoValue(AMemo: TMemo; Value: string);
    procedure SetCategoryPanelHeight(ACPanel: TCategoryPanel);

{$IFDEF DEBUG}
    procedure edTestReadDataKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnTestReadDataClick(Sender: TObject);
{$ENDIF}
  public
    { Public declarations }
    property DataBase: TDataBase read FDataBase;
    property Arduino: TComPort read FArduino;
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

uses uAbout, uLanguage, uRCommandsControl, USendComPort, uFastRCommand;

procedure TMain.FormCreate(Sender: TObject);

  procedure SetVolume(Volume: Integer);
  var
    deviceEnumerator: IMMDeviceEnumerator;
    defaultDevice: IMMDevice;
    endpointVolume: IAudioEndpointVolume;
  begin
    endpointVolume := nil;
    CoCreateInstance(CLASS_IMMDeviceEnumerator, nil, CLSCTX_INPROC_SERVER, IID_IMMDeviceEnumerator,
      deviceEnumerator);
    deviceEnumerator.GetDefaultAudioEndpoint(eRender, eConsole, defaultDevice);
    defaultDevice.Activate(IID_IAudioEndpointVolume, CLSCTX_INPROC_SERVER, nil, endpointVolume);
    if endpointVolume <> nil then
      endpointVolume.SetMasterVolumeLevelScalar(Volume / 100, nil);
  end;

begin
  CreateComponent;
  SettingComponent;

  LoadWindowSetting;
  FSetting := uSettings.getSetting();
  UpdateLanguage(self, lngRus);

  // Обработка настроек запуска
  if (ParamStr(1) = '-autorun') then
  begin
    // Установка громкости
    if FSetting.Application.AutoRunSetVolume then
      SetVolume(FSetting.Application.Volume);

    // Сворачивание в трей
    if FSetting.Application.AutoRunTray then
    begin
      Application.ShowMainForm := False;
      Main.Visible := False;
      TurnTray;
    end;
  end;

  onComPortClose(nil);
  onShellApplicationRunning(False);
  onKodiRunning(False);

  try
    // Установка хука при запуске
    if FSetting.EventApplication.Using then
      StartEventApplication;

    // Открытие порта при запуске
    if FSetting.ComPort.OpenRun then
    begin
      OpenComPort;
      if FSetting.Application.AutoRunNotificationCenter then
        ShowNotification(Application.Title, 'Приложение успешно запущенно');
    end;
  except
    on E: Exception do
    begin
      // Если ошибка и запуски в трей, открываем из трея
      if FSetting.Application.AutoRun and FSetting.Application.AutoRunTray then
        OpenTray;

      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TMain.FormShow(Sender: TObject);
begin
  CreateActionMenu;

{$IFDEF WIN32}
  Main.Caption := Application.Title + ' (x86)';
{$ELSE}
  Main.Caption := Application.Title + ' (x64)';
{$ENDIF}
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  if Assigned(FArduino) then
  begin
    if FArduino.Connected then
      FArduino.Close;
    FreeAndNil(FArduino);
  end;

  if Assigned(FKodi) then
  begin
    FKodi.Terminate;
    FreeAndNil(FKodi);
  end;

  if Assigned(FShellApplication) then
  begin
    if FShellApplication.Starting then
      FShellApplication.Stop;
    FreeAndNil(FShellApplication);
  end;

  SaveWindowSetting;
end;

procedure TMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if FSetting.Application.CloseTray and not FSureExit then
  begin
    CanClose := False;
    TurnTray;
  end;
end;

procedure TMain.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvReadComPort.Items.Count - 1 do
    Dispose(lvReadComPort.Items[i].Data);

  for i := 0 to lbRemoteControl.Items.Count - 1 do
    (lbRemoteControl.Items.Objects[i] as TObjectRemoteCommand).Free;

  if Assigned(lbRemoteControl) then
    lbRemoteControl.Free;
  if Assigned(lvShellApplication) then
    lvShellApplication.Free;
  if Assigned(lvEventKodi) then
    lvEventKodi.Free;

  if Assigned(plvRemoteControl) then
    plvRemoteControl.Free;
  if Assigned(plvShellApplication) then
    plvShellApplication.Free;
  if Assigned(plvEventKodi) then
    plvEventKodi.Free;

  FreeAndNil(mRemoteControlLastL);
  FreeAndNil(mRemoteControlLastV);
  FreeAndNil(pRemoteControlLast);
  FreeAndNil(cpRemoteControl);

{$IFDEF WIN64}
  FreeAndNil(mShellApplication_x86L);
  FreeAndNil(mShellApplication_x86V);
  FreeAndNil(pShellApplication_x86);
{$ENDIF}
  FreeAndNil(mShellApplicationFileL);
  FreeAndNil(mShellApplicationFileV);
  FreeAndNil(pShellApplicationFile);
  FreeAndNil(cpShellApplication);

  FreeAndNil(mKodiPlayingLabelL);
  FreeAndNil(mKodiPlayingLabelV);
  FreeAndNil(pKodiPlayingLabel);

  FreeAndNil(mKodiPlayingFileL);
  FreeAndNil(mKodiPlayingFileV);
  FreeAndNil(pKodiPlayingFile);
  FreeAndNil(cpKodi);

  FreeAndNil(cpgState);

  FPageClient.Free;

{$IFDEF DEBUG}
  edTestReadData.Free;
  btnTestReadData.Free;
  pTestReadData.Free;
{$ENDIF}
end;

procedure TMain.ActRCRCommandsControlExecute(Sender: TObject);
var
  frmRCommandsControl: TfrmRCommandsControl;
begin
  if Assigned(FDataBase) and FDataBase.Connected then
  begin
    frmRCommandsControl := TfrmRCommandsControl.Create(self);
    try
      frmRCommandsControl.ShowModal;
    finally
      frmRCommandsControl.Free;
    end;
  end;
end;

procedure TMain.ActRCAddExecute(Sender: TObject);
var
  LFRC: TfrmFastRCommand;
begin
  LFRC := TfrmFastRCommand.Create(self);
  try
    LFRC.frcType := frcAdd;
    LFRC.edCommand.Text := TReadComPort(lvReadComPort.Selected.Data^).Command;
    LFRC.ShowModal;
  finally
    LFRC.Free;
  end;
end;

procedure TMain.ActRCEditExecute(Sender: TObject);
var
  LFRC: TfrmFastRCommand;
  RCommand: TRemoteCommand;
  Operations: TOperations;
begin
  RCommand := DataBase.GetRemoteCommand(TReadComPort(lvReadComPort.Selected.Data^).Command);
  Operations := DataBase.getOperation(RCommand.Command);

  if Length(Operations) <> 1 then
  begin
    if Length(Operations) = 0 then
      MessageDlg(Format(GetLanguageMsg('msgRCCommandZero', lngRus), [RCommand.Command]), mtWarning,
        [mbOK], 0);

    if Length(Operations) > 0 then
      MessageDlg(Format(GetLanguageMsg('msgRCCommandMoreOne', lngRus), [RCommand.Command]),
        mtWarning, [mbOK], 0);

    exit;
  end;

  LFRC := TfrmFastRCommand.Create(self);
  try
    LFRC.frcType := frcEdit;
    LFRC.edCommand.Text := RCommand.Command;
    LFRC.edDescription.Text := RCommand.Desc;
    LFRC.cbLongPress.Checked := RCommand.LongPress;
    LFRC.cbRepeatPrevious.Checked := RCommand.RepeatPrevious;
    LFRC.Operation := Operations[0];
    LFRC.ShowModal;
  finally
    LFRC.Free;
  end;
end;

procedure TMain.ActRCDeleteExecute(Sender: TObject);
var
  LCommand: string;
begin
  LCommand := TReadComPort(lvReadComPort.Selected.Data^).Command;

  if MessageDlg(Format(GetLanguageMsg('msgDBDeleteRemoteCommand', lngRus), [LCommand]),
    mtConfirmation, mbYesNo, 1) = mrYes then
    try
      FDataBase.DeleteRemoteCommand(LCommand);
    except
      on E: Exception do
        MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
end;

procedure TMain.ActRCExecute(Sender: TObject);
begin
  //
end;

procedure TMain.ActRCOpenAccessExecute(Sender: TObject);
begin
  if FileExists(FSetting.RemoteControl.DB.FileName) then
    ShellExecute(Main.Handle, 'open', PWideChar(WideString(FSetting.RemoteControl.DB.FileName)),
      nil, nil, SW_SHOWNORMAL);
end;

procedure TMain.ActShellAppExecute(Sender: TObject);
begin
  //
end;

procedure TMain.ActShellAppStartExecute(Sender: TObject);
begin
  try
    StartEventApplication;
  except
    on E: Exception do
    begin
      FreeAndNil(FShellApplication);
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end
end;

procedure TMain.ActShellAppStopExecute(Sender: TObject);
begin
  try
    StopEventApplication;
  except
    on E: Exception do
    begin
      FreeAndNil(FShellApplication);
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end
end;

procedure TMain.ActFileExecute(Sender: TObject);
begin
  //
end;

procedure TMain.ActFileExitExecute(Sender: TObject);
begin
  FSureExit := True;
  Close;
end;

procedure TMain.ActComPortExecute(Sender: TObject);
begin
  //
end;

procedure TMain.ActComPortOpenCloseExecute(Sender: TObject);
begin
  try
    if not Assigned(FArduino) or not FArduino.Connected then
      OpenComPort
    else if FArduino.Connected then
      CloseComPort;
  except
    on E: Exception do
    begin
      FreeAndNil(FArduino);
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end
end;

procedure TMain.ActComPortOpenExecute(Sender: TObject);
begin
  try
    OpenComPort;
  except
    on E: Exception do
    begin
      FreeAndNil(FArduino);
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end
end;

procedure TMain.ActComPortCloseExecute(Sender: TObject);
begin
  try
    CloseComPort;
  except
    on E: Exception do
    begin
      FreeAndNil(FArduino);
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end
end;

procedure TMain.ActComPortSendExecute(Sender: TObject);
var
  LSCP: TfrmSendComPort;
begin
  if Assigned(FArduino) and FArduino.Connected then
  begin
    LSCP := TfrmSendComPort.Create(self);
    try
      LSCP.ShowModal;
    finally
      LSCP.Free;
    end;
  end;
end;

procedure TMain.ActHelpAboutExecute(Sender: TObject);
var
  LAbout: TAbout;
begin
  LAbout := TAbout.Create(self);
  try
    LAbout.ShowModal;
  finally
    LAbout.Free;
  end;
end;

procedure TMain.ActHelpExecute(Sender: TObject);
begin
  //
end;

procedure TMain.ActKodiExecute(Sender: TObject);
begin
  //
end;

procedure TMain.ActKodiStartExecute(Sender: TObject);
begin
  try
    StartEventKodi;
  except
    on E: Exception do
    begin
      FreeAndNil(FKodi);
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end
end;

procedure TMain.ActKodiStopExecute(Sender: TObject);
begin
  try
    StopEventKodi;
  except
    on E: Exception do
    begin
      FreeAndNil(FKodi);
      MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end
end;

procedure TMain.ActToolsDeviceManagerExecute(Sender: TObject);
begin
  ShellExecute(Main.Handle, 'open', PWideChar(WideString('devmgmt.msc')), nil, nil, SW_SHOWNORMAL);
end;

procedure TMain.ActToolsExecute(Sender: TObject);
begin
  //
end;

procedure TMain.ActToolsSettingExecute(Sender: TObject);
var
  LSettings: TSettings;
begin
  LSettings := TSettings.Create(self);
  try
    LSettings.ShowModal;
  finally
    LSettings.Free;
    FSetting := uSettings.getSetting();
  end;
end;

procedure TMain.AppEventsMinimize(Sender: TObject);
begin
  if FSetting.Application.TurnTray then
    TurnTray;
end;

{$IFDEF DEBUG}

procedure TMain.edTestReadDataKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Mgs: TMsg;
begin
  if Key = VK_RETURN then
  begin
    btnTestReadDataClick(btnTestReadData);
    // убираем beep
    PeekMessage(Mgs, 0, WM_CHAR, WM_CHAR, PM_REMOVE);
  end;
end;

procedure TMain.btnTestReadDataClick(Sender: TObject);
begin
  onComPortReadData(FArduino, edTestReadData.Text);
end;

{$ENDIF}

procedure TMain.AppEventsMessage(var Msg: tagMSG; var Handled: Boolean);
var
  LComPortConnected: Boolean;
  LDataBaseConnected: Boolean;
  LShellApplicationStarting: Boolean;
  LKodiStarting: Boolean;
begin
  if Processing then
    exit;

  FProcessingEventHandler := True;
  try
    LComPortConnected := Assigned(FArduino) and FArduino.Connected;
    LDataBaseConnected := Assigned(FDataBase) and FDataBase.Connected;
    LShellApplicationStarting := Assigned(FShellApplication) and FShellApplication.Starting;
    LKodiStarting := Assigned(FKodi);

    { ComPort }
    ActComPortOpen.Enabled := not LComPortConnected;
    ActComPortSend.Enabled := LComPortConnected;
    ActComPortClose.Enabled := LComPortConnected;
{$IFDEF DEBUG}
    edTestReadData.Enabled := LComPortConnected;
    btnTestReadData.Enabled := LComPortConnected;
{$ENDIF}
    { DataBase }
    ActRCRCommandsControl.Enabled := LDataBaseConnected;

    { ShellApplication }
    ActShellAppStart.Enabled := not LShellApplicationStarting;
    ActShellAppStop.Enabled := LShellApplicationStarting;

    { Kodi }
    ActKodiStart.Enabled := not LKodiStarting;
    ActKodiStop.Enabled := LKodiStarting;

    FProcessingEventHandler := False;
  except
    FProcessingEventHandler := False;
    { intentionally silent }
  end;
end;

procedure TMain.SetMemoValue(AMemo: TMemo; Value: string);
begin
  AMemo.Lines.Clear;
  AMemo.Lines.Text := Value;
  // AMemo.Lines.Add(Value);
  SetMemoHeight(AMemo);
end;

procedure TMain.SetMemoHeight(AMemo: TMemo);
var
  Can: TCanvas;
begin

  Can := TCanvas.Create;
  Can.Handle := CreateCompatibleDC(GetDC(0));
  try
    Can.Font.Assign(AMemo.Font);
    AMemo.Height := Can.TextHeight('Wg') * AMemo.Lines.Count;
  finally
    DeleteDC(Can.Handle);
    Can.Handle := 0;
    Can.Free;
  end;

  if AMemo.Parent.Parent.Parent is TCategoryPanel then
    SetCategoryPanelHeight(AMemo.Parent.Parent.Parent as TCategoryPanel);
  // scrbFooter.Realign;
end;

procedure TMain.SetCategoryPanelHeight(ACPanel: TCategoryPanel);
var
  i, H: Integer;
begin
  SendMessage(cpgState.Handle, WM_SETREDRAW, 0, 0);
  try
    H := 0;
    for i := 0 to ACPanel.ComponentCount - 1 do
      if ACPanel.Components[i] is TPanel then
        H := H + TPanel(ACPanel.Components[i]).Height + TPanel(ACPanel.Components[i]).Margins.Top +
          TPanel(ACPanel.Components[i]).Margins.Bottom;

    ACPanel.Height := cpgState.HeaderHeight + H;
  finally
    SendMessage(cpgState.Handle, WM_SETREDRAW, 1, 0);
    RedrawWindow(cpgState.Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or
      RDW_ALLCHILDREN);
  end;
end;

procedure TMain.LoadWindowSetting;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFileDir(Application.ExeName) + '\' + FileSetting);
  try
    Main.left := IniFile.ReadInteger('Window', 'Left', Main.left);
    Main.Top := IniFile.ReadInteger('Window', 'Top', Main.Top);
    Main.Width := IniFile.ReadInteger('Window', 'Width', Main.Width);
    Main.Height := IniFile.ReadInteger('Window', 'Height', Main.Height);
    if IniFile.ReadBool('Window', 'Maximized', True) then
      Main.WindowState := wsMaximized;

    Main.pLeft.Width := IniFile.ReadInteger('Window', 'SplitterLeft', Main.pLeft.Width);
    Main.pClientBottom.Height := IniFile.ReadInteger('Window', 'SplitterBottom',
      Main.pClientBottom.Height);

    Main.cpRemoteControl.Collapsed := IniFile.ReadBool('Window', 'RemoteControlCollapsed',
      Main.cpRemoteControl.Collapsed);
    Main.cpShellApplication.Collapsed := IniFile.ReadBool('Window', 'ShellApplicationCollapsed',
      Main.cpShellApplication.Collapsed);
    Main.cpKodi.Collapsed := IniFile.ReadBool('Window', 'KodiCollapsed', Main.cpKodi.Collapsed);
  finally
    IniFile.Free;
  end;
end;

procedure TMain.SaveWindowSetting();
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFileDir(Application.ExeName) + '\' + FileSetting);
  try
    if WindowState = wsMaximized then
      IniFile.WriteBool('Window', 'Maximized', True)
    else
    begin
      IniFile.WriteBool('Window', 'Maximized', False);
      IniFile.WriteInteger('Window', 'Left', Main.left);
      IniFile.WriteInteger('Window', 'Top', Main.Top);
      IniFile.WriteInteger('Window', 'Width', Main.Width);
      IniFile.WriteInteger('Window', 'Height', Main.Height);
    end;
    IniFile.WriteInteger('Window', 'SplitterLeft', Main.pLeft.Width);
    IniFile.WriteInteger('Window', 'SplitterBottom', Main.pClientBottom.Height);
    IniFile.WriteBool('Window', 'RemoteControlCollapsed', Main.cpRemoteControl.Collapsed);
    IniFile.WriteBool('Window', 'ShellApplicationCollapsed', Main.cpShellApplication.Collapsed);
    IniFile.WriteBool('Window', 'KodiCollapsed', Main.cpKodi.Collapsed);
  finally
    IniFile.Free;
  end;
end;

procedure TMain.lvShellApplicationCustomDrawSubItem(Sender: TCustomListView; Item: TListItem;
  SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  ARect: TRect;
  LIcon: TIcon;
  LSubItemText: string;
  LLeft: Integer;
begin
  if (SubItem = 1) then
  begin
    ListView_GetSubItemRect(Sender.Handle, Item.Index, SubItem, LVIR_BOUNDS, @ARect);
    SetBkMode(Sender.Canvas.Handle, TRANSPARENT);
    LSubItemText := Item.SubItems[SubItem - 1];
    LLeft := 0;

    LIcon := TIcon.Create();
    try
      if FileExists(LSubItemText) then
        SmallIconEXE(LSubItemText, LIcon);

      Sender.Canvas.Draw(ARect.left + 5, ARect.Top + 1, LIcon);
      LLeft := LIcon.Width + 5;
    finally
      LIcon.Free;
    end;

    Sender.Canvas.TextOut(ARect.left + 5 + LLeft, ARect.Top + 1, LSubItemText);
    DefaultDraw := False;
  end;
end;

procedure TMain.lvReadComPortContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  HeaderRect: TRect;
  Pos: TPoint;
  CommandExists: Boolean;
  LCommand: string;
begin
  GetWindowRect(ListView_GetHeader(lvReadComPort.Handle), HeaderRect);
  Pos := lvReadComPort.ClientToScreen(MousePos);
  if (not PtInRect(HeaderRect, Pos)) and (lvReadComPort.Selected <> nil) then
  begin

    if not FDataBase.Connected then
    begin
      MessageDlg(GetLanguageMsg('msgDBNotConnected', lngRus), mtWarning, [mbOK], 0);
      exit;
    end;

    LCommand := TReadComPort(lvReadComPort.Selected.Data^).Command;
    CommandExists := FDataBase.RemoteCommandExists(LCommand);
    ActRCAdd.Visible := not CommandExists;
    ActRCEdit.Visible := CommandExists;
    ActRCDelete.Visible := CommandExists;

    PopupActReadComPort.Popup(Pos.X, Pos.Y);
  end;
end;

procedure TMain.lvReadComPortCustomDraw(Sender: TCustomListView; const ARect: TRect;
  var DefaultDraw: Boolean);
var
  R: TRect;
  S: String;
  H: Integer;
begin
  if Sender.Items.Count > 0 then
    exit;

  S := GetLanguageText(self.Name, 'lvReadComPortTitle', lngRus);
  Sender.Canvas.Font.Size := 10;

  R := ARect;
  R.Inflate(-4, -4);
  H := (R.Bottom - R.Top) div 2 + DrawText(Sender.Canvas.Handle, PChar(S), -1, R,
    DT_WORDBREAK or DT_CALCRECT) div 2;

  R := ARect;
  R.Inflate(-4, -4);
  R.Top := (R.Bottom - R.Top) div 2 - H div 2;

  DrawText(Sender.Canvas.Handle, PChar(S), -1, R, DT_CENTER or DT_WORDBREAK);
end;

procedure TMain.lvReadComPortDblClick(Sender: TObject);
var
  LCommand: string;
begin
  if lvReadComPort.Selected <> nil then
  begin

    if not FDataBase.Connected then
    begin
      MessageDlg(GetLanguageMsg('msgDBNotConnected', lngRus), mtWarning, [mbOK], 0);
      exit;
    end;

    LCommand := TReadComPort(lvReadComPort.Selected.Data^).Command;
    if FDataBase.RemoteCommandExists(LCommand) then
      ActRCEditExecute(ActRCEdit)
    else
      ActRCAddExecute(ActRCAdd);
  end;
end;

procedure TMain.lvReadComPortDrawItem(Sender: TCustomListView; Item: TListItem; Rect: TRect;
  State: TOwnerDrawState);
var
  DrawRect: TRect;
  LDetails: TThemedElementDetails;
begin

  if (Item.Index mod 2) = 1 then
    Sender.Canvas.brush.Color := clBtnFace
  else
    Sender.Canvas.brush.Color := clWhite;

  if odSelected in State then
    Sender.Canvas.brush.Color := GetShadowColor(clHighlight, 115);

  Sender.Canvas.FillRect(Rect);

  // Номер операции
  DrawRect := Rect;
  inc(DrawRect.Top, 2);
  DrawRect.Right := 30;
  Sender.Canvas.Font.Size := 6;
  DrawText(Sender.Canvas.Handle, PChar(Item.Caption), -1, DrawRect, DT_VCENTER or DT_SINGLELINE or
    DT_RIGHT);
  Sender.Canvas.Font.Size := 8;

  // Разделитель
  DrawRect := Rect;
  inc(DrawRect.left, 34);
  inc(DrawRect.Top, 2);
  DrawRect.Right := DrawRect.left + 2;
  dec(DrawRect.Bottom, 2);
  LDetails := StyleServices.GetElementDetails(ttbSeparatorDisabled);
  StyleServices.DrawElement(Sender.Canvas.Handle, LDetails, DrawRect);

  // Если команды нету, выводим данные красным
  if not TReadComPort(Item.Data^).Exists then
    Sender.Canvas.Font.Color := clRed;

  Rect.left := 40;

  // Данные
  DrawRect := Rect;
  dec(DrawRect.Right, 4);
  Sender.Canvas.Font.style := Sender.Canvas.Font.style + [fsBold];
  DrawText(Sender.Canvas.Handle, PChar(Item.SubItems[0]), -1, DrawRect,
    DT_VCENTER or DT_SINGLELINE or DT_LEFT or DT_END_ELLIPSIS);
  Sender.Canvas.Font.style := Sender.Canvas.Font.style - [fsBold];
  Sender.Canvas.Font.Color := clBlack;

  // Текст к команде
  if TReadComPort(Item.Data^).Exists and (Length(Trim(TReadComPort(Item.Data^).Desc)) > 0) then
  begin
    DrawRect := Rect;
    Sender.Canvas.Font.style := Sender.Canvas.Font.style + [fsBold];
    DrawRect.left := DrawRect.left + Sender.Canvas.TextWidth(Item.SubItems[0]) + 4;
    Sender.Canvas.Font.style := Sender.Canvas.Font.style - [fsBold];

    if DrawRect.left < Rect.Right then
    begin
      Sender.Canvas.Font.style := Sender.Canvas.Font.style + [fsItalic];
      DrawText(Sender.Canvas.Handle, PChar(TReadComPort(Item.Data^).Desc), -1, DrawRect,
        DT_VCENTER or DT_SINGLELINE or DT_LEFT or DT_END_ELLIPSIS);
      Sender.Canvas.Font.style := Sender.Canvas.Font.style - [fsItalic];
    end;
  end;
end;

procedure TMain.TrayDblClick(Sender: TObject);
begin
  OpenTray;
end;

procedure TMain.TurnTray();
begin
  Tray.Visible := True;
  ShowWindow(Main.Handle, SW_HIDE);
  // Скрываем программу
  ShowWindow(Application.Handle, SW_HIDE); // Скрываем кнопку с TaskBar'а
  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowlong(Application.Handle, GWL_EXSTYLE) or
    (not WS_EX_APPWINDOW));
end;

procedure TMain.OpenTray();
begin
  ShowWindow(Main.Handle, SW_RESTORE);
  SetForegroundWindow(Main.Handle);
  Tray.Visible := False;
  Main.Visible := True;
end;

procedure TMain.pClientBottomResize(Sender: TObject);
begin
  SetMemoHeight(mRemoteControlLastV);

{$IFDEF WIN64}
  SetMemoHeight(mShellApplication_x86V);
{$ENDIF}
  SetMemoHeight(mShellApplicationFileV);

  SetMemoHeight(mKodiPlayingLabelV);
  SetMemoHeight(mKodiPlayingFileV);
end;

function TMain.Processing: Boolean;
begin
  Result := True;
  if FProcessingEventHandler then
    exit;
  Result := False;
end;

procedure TMain.OpenComPort();
begin
  if not Assigned(FArduino) or not FArduino.Connected then
  begin
    FArduino := TComPort.Create(FSetting.ComPort.Port);
    FArduino.onBeforeOpen := onComPortBeforeOpen;
    FArduino.onAfterOpen := onComPortAfterOpen;
    FArduino.onAfterClose := onComPortClose;
    FArduino.onReadData := onComPortReadData;
    FArduino.Open;
  end;
end;

procedure TMain.CloseComPort();
begin
  if Assigned(FArduino) then
    try
      if FArduino.Connected then
        FArduino.Close;
    finally
      FreeAndNil(FArduino);
    end;
end;

procedure TMain.cpgStateMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint;
  var Handled: Boolean);
begin
  (Sender as TCategoryPanelGroup).VertScrollBar.Position := (Sender as TCategoryPanelGroup)
    .VertScrollBar.Position + 4;
end;

procedure TMain.cpgStateMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint;
  var Handled: Boolean);
begin
  (Sender as TCategoryPanelGroup).VertScrollBar.Position := (Sender as TCategoryPanelGroup)
    .VertScrollBar.Position - 4;
end;

procedure TMain.cpRemoteControlExpand(Sender: TObject);
begin
  SetCategoryPanelHeight(Sender as TCategoryPanel);
end;

procedure TMain.StartEventApplication();
begin
  if not Assigned(FShellApplication) or not FShellApplication.Starting then
  begin
    FShellApplication := TShellApplications.Create(Main);
    FShellApplication.OnRunning := onShellApplicationRunning;
{$IFDEF WIN64}
    FShellApplication.OnStatus_x86 := onShellApplicationStatus_x86;
{$ENDIF}
    FShellApplication.OnWindowsHook := onShellApplicationWindowsHook;
    FShellApplication.Start();
    lvShellApplication.Items.Clear;
  end;
end;

procedure TMain.StopEventApplication();
begin
  if Assigned(FShellApplication) then
    try
      if FShellApplication.Starting then
        FShellApplication.Stop;
    finally
      FreeAndNil(FShellApplication);
    end;
end;

procedure TMain.StartEventKodi();
begin
  if not Assigned(FKodi) then
  begin
    FKodi := TKodi.Create(FSetting.Kodi.UpdateInterval, FSetting.Kodi.IP, FSetting.Kodi.Port,
      FSetting.Kodi.User, FSetting.Kodi.Password);

    FKodi.Priority := tpNormal;
    FKodi.OnRunning := onKodiRunning;
    FKodi.OnPlayer := onKodiPlayer;
    FKodi.OnPlayerState := onKodiPlayerState;
    FKodi.OnPlaying := onKodiPlaying;
  end;
end;

procedure TMain.StopEventKodi();
begin
  if Assigned(FKodi) then
    try
      FKodi.Terminate;
    finally
      FreeAndNil(FKodi);
    end;
end;

procedure TMain.CreateActionMenu;
var
  LItem, LItemGlobal: TActionClientItem;
begin
  with ActionManager.ActionBars[0] do
  begin
    { File }
    { ------------------------------------------- }
    LItemGlobal := Items.Add;
    LItemGlobal.Index := 0;
    LItemGlobal.Action := ActFile;
    LItemGlobal.Items.Add.Caption := '-';
    LItemGlobal.Items.Add.Action := ActFileExit;

    { ComPort }
    { ------------------------------------------ }
    LItemGlobal := Items.Add;
    LItemGlobal.Index := 1;
    LItemGlobal.Action := ActComPort;
    LItemGlobal.Items.Add.Action := ActComPortOpen;
    LItemGlobal.Items.Add.Action := ActComPortSend;
    LItemGlobal.Items.Add.Action := ActComPortClose;

    { RemoteControl }
    { ------------------------------------------ }
    LItemGlobal := Items.Add;
    LItemGlobal.Index := 2;
    LItemGlobal.Action := ActRC;
    LItemGlobal.Items.Add.Action := ActRCRCommandsControl;
    // LItemGlobal.Items.Add.Caption := '-';
    // LItemGlobal.Items.Add.Action := ActRCAdd;
    // LItemGlobal.Items.Add.Action := ActRCEdit;
    // LItemGlobal.Items.Add.Action := ActRCDelete;
    LItemGlobal.Items.Add.Caption := '-';
    LItemGlobal.Items.Add.Action := ActRCOpenAccess;

    { ShellApplication }
    { ------------------------------------------ }
    LItemGlobal := Items.Add;
    LItemGlobal.Index := 3;
    LItemGlobal.Action := ActShellApp;
    LItemGlobal.Items.Add.Action := ActShellAppStart;
    LItemGlobal.Items.Add.Action := ActShellAppStop;

    { Kodi }
    { ------------------------------------------ }
    LItemGlobal := Items.Add;
    LItemGlobal.Index := 4;
    LItemGlobal.Action := ActKodi;
    LItemGlobal.Items.Add.Action := ActKodiStart;
    LItemGlobal.Items.Add.Action := ActKodiStop;

    { Tools }
    { ------------------------------------------ }
    LItemGlobal := Items.Add;
    LItemGlobal.Index := 5;
    LItemGlobal.Action := ActTools;
    LItemGlobal.Items.Add.Action := ActToolsSetting;
    LItemGlobal.Items.Add.Caption := '-';
    LItemGlobal.Items.Add.Action := ActToolsDeviceManager;

    { Help }
    { ------------------------------------------ }
    LItemGlobal := Items.Add;
    LItemGlobal.Index := 6;
    LItemGlobal.Action := ActHelp;
    LItemGlobal.Items.Add.Action := ActHelpAbout;
  end;

  with ActionManager.ActionBars[1] do
  begin
    ShowHint := True;

    LItem := Items.Add;
    LItem.Action := ActComPortOpenClose;
    LItem.ShowCaption := True;

    LItem := Items.Add;
    LItem.Action := ActRCRCommandsControl;
    LItem.ShowCaption := True;

    LItem := Items.Add;
    LItem.Caption := '-';
    LItem.CommandStyle := csSeparator;

    LItem := Items.Add;
    LItem.Action := ActToolsSetting;
    LItem.ShowCaption := False;
  end;

  pLeft.Width := pLeft.Width + 1;
  pLeft.Width := pLeft.Width - 1;
end;

procedure TMain.CreateComponent();

  function CreateTab(aPage: TCustomPageControl; aName, aCaption: string): TTabSheet;
  begin
    Result := TTabSheet.Create(aPage);
    Result.PageControl := aPage;
    Result.Name := aName;
    Result.Caption := aCaption;
    Result.DoubleBuffered := True;
  end;

var
  tabRemoteControl, tabShellApplication, tabEventKodi: TTabSheet;
  LColumn: TListColumn;
begin
  // ---------------------------------------------------------------------------
  // Панель с вкладками
  // ---------------------------------------------------------------------------
  FPageClient := TCustomPageControl.Create(self);
  with FPageClient do
  begin
    left := 10;
    Top := 10;
    Width := 20;
    Height := 20;
    Parent := pClient;
    Name := 'pcClient';

    Visible := True;
    Align := alClient;
    OwnerDraw := True;
    TabPosition := TTabPosition.tpTop;
    TextFormat := [tfCenter];
    DoubleBuffered := True;
    style := tsButtons;
    TabHeight := 24;
  end;
  SendMessage(FPageClient.Handle, WM_UPDATEUISTATE, MakeLong(UIS_SET, UISF_HIDEFOCUS), 0);

  // ---------------------------------------------------------------------------
  // Вкладка - RemoteControl
  // ---------------------------------------------------------------------------
  tabRemoteControl := CreateTab(FPageClient, 'TabRemoteControl',
    GetLanguageText(Main.Name, 'TabRemoteControl', lngRus));

  plvRemoteControl := TPanel.Create(tabRemoteControl);
  with plvRemoteControl do
  begin
    left := 10;
    Top := 10;
    Width := 20;
    Height := 20;
    Parent := tabRemoteControl;
    Align := alClient;
    Ctl3D := False;
    BevelOuter := bvNone;
    BorderStyle := bsSingle;
    AlignWithMargins := True;
    Margins.left := 0;
    Margins.Bottom := 0;
  end;

  lbRemoteControl := TCustomListBoxRC.Create(plvRemoteControl);
  with lbRemoteControl do
  begin
    Parent := plvRemoteControl;
    Align := alClient;
    TabStop := False;
    DoubleBuffered := True;
    BorderStyle := bsNone;

    Title := GetLanguageText(self.Name, 'lbRemoteControlTitle', lngRus);
  end;

  // ---------------------------------------------------------------------------
  // Вкладка - ShellApplication
  // ---------------------------------------------------------------------------
  tabShellApplication := CreateTab(FPageClient, 'TabShellApplication',
    GetLanguageText(Main.Name, 'TabShellApplication', lngRus));

  plvShellApplication := TPanel.Create(tabShellApplication);
  with plvShellApplication do
  begin
    left := 10;
    Top := 10;
    Width := 20;
    Height := 20;
    Parent := tabShellApplication;
    Align := alClient;
    Ctl3D := False;
    BevelOuter := bvNone;
    BorderStyle := bsSingle;
    AlignWithMargins := True;
    Margins.left := 0;
    Margins.Bottom := 0;
  end;

  lvShellApplication := TListView.Create(plvShellApplication);
  with lvShellApplication do
  begin
    left := 10;
    Top := 10;
    Width := 20;
    Height := 20;
    Parent := plvShellApplication;
    Align := alClient;
    BorderStyle := bsNone;
    ViewStyle := vsReport;
    ReadOnly := True;
    RowSelect := True;
    ColumnClick := False;
    OnCustomDrawSubItem := lvShellApplicationCustomDrawSubItem;

    LColumn := Columns.Add;
    LColumn.Caption := GetLanguageText(Main.Name, 'lvShellApplication:0', lngRus);
    LColumn.Width := 100;

    LColumn := Columns.Add;
    LColumn.Caption := GetLanguageText(Main.Name, 'lvShellApplication:1', lngRus);
    LColumn.AutoSize := True;
  end;
  SendMessage(lvShellApplication.Handle, WM_UPDATEUISTATE, MakeLong(UIS_SET, UISF_HIDEFOCUS), 0);

  // ---------------------------------------------------------------------------
  // Вкладка - EventKodi
  // ---------------------------------------------------------------------------
  tabEventKodi := CreateTab(FPageClient, 'TabEventKodi',
    GetLanguageText(Main.Name, 'TabEventKodi', lngRus));

  plvEventKodi := TPanel.Create(tabEventKodi);
  with plvEventKodi do
  begin
    left := 10;
    Top := 10;
    Width := 20;
    Height := 20;
    Parent := tabEventKodi;
    Align := alClient;
    Ctl3D := False;
    BevelOuter := bvNone;
    BorderStyle := bsSingle;
    AlignWithMargins := True;
    Margins.left := 0;
    Margins.Bottom := 0;
  end;

  lvEventKodi := TListView.Create(plvEventKodi);
  with lvEventKodi do
  begin
    left := 10;
    Top := 10;
    Width := 20;
    Height := 20;
    Parent := plvEventKodi;
    Align := alClient;
    BorderStyle := bsNone;
    ViewStyle := vsReport;
    ReadOnly := True;
    RowSelect := True;
    ColumnClick := False;

    LColumn := Columns.Add;
    LColumn.Caption := GetLanguageText(Main.Name, 'lvEventKodi:0', lngRus);
    LColumn.Width := 100;

    LColumn := Columns.Add;
    LColumn.Caption := GetLanguageText(Main.Name, 'lvEventKodi:1', lngRus);
    LColumn.AutoSize := True;
  end;
  SendMessage(lvEventKodi.Handle, WM_UPDATEUISTATE, MakeLong(UIS_SET, UISF_HIDEFOCUS), 0);

  // ---------------------------------------------------------------------------
  // Состояние приложения
  // ---------------------------------------------------------------------------
  cpgState := TCustomCategoryPanelGroup.Create(pClientBottom);
  with cpgState do
  begin
    Parent := pClientBottom;
    Align := alClient;
    Color := clWhite;
    Ctl3D := False;
    HeaderFont.style := HeaderFont.style + [fsBold];
    GradientBaseColor := clWhite;
    GradientColor := clWhite;
    DoubleBuffered := True;

    onMouseWheelDown := cpgStateMouseWheelDown;
    onMouseWheelUp := cpgStateMouseWheelUp;
  end;

  // ---------------------------------------------------------------------------
  // Состояние приложения - Управление
  // ---------------------------------------------------------------------------
  cpRemoteControl := TCustomCategoryPanel.Create(cpgState);
  with cpRemoteControl do
  begin
    Parent := cpgState;
    PanelGroup := cpgState;
    Caption := GetLanguageText(Main.Name, 'cpRemoteControl', lngRus);
    Color := cpgState.Color;
    Height := 100;
    Name := 'cpRemoteControl';
    FullRepaint := False;
    DoubleBuffered := True;
    onExpand := cpRemoteControlExpand;
  end;

  // ---------------------------------------------------------------------------
  // Состояние приложения - Управление - Последняя команда
  // ---------------------------------------------------------------------------

  pRemoteControlLast := TPanel.Create(cpRemoteControl);
  with pRemoteControlLast do
  begin
    Parent := cpRemoteControl;
    Align := alTop;
  end;

  mRemoteControlLastL := TMemo.Create(pRemoteControlLast);
  with mRemoteControlLastL do
  begin
    Parent := pRemoteControlLast;
    Text := GetLanguageText(self.Name, 'mRemoteControlLastL', lngRus);
  end;

  mRemoteControlLastV := TMemo.Create(pRemoteControlLast);
  with mRemoteControlLastV do
  begin
    Parent := pRemoteControlLast;
    Lines.Add('mRemoteControlLastV');
  end;

  // ---------------------------------------------------------------------------
  // Состояние приложения - Приложения
  // ---------------------------------------------------------------------------
  cpShellApplication := TCustomCategoryPanel.Create(cpgState);
  with cpShellApplication do
  begin
    Parent := cpgState;
    PanelGroup := cpgState;
    Caption := GetLanguageText(Main.Name, 'cpShellApplication', lngRus);
    Color := cpgState.Color;
    Height := 100;
    Name := 'cpShellApplication';
    FullRepaint := False;
    DoubleBuffered := True;
    onExpand := cpRemoteControlExpand;
  end;

  // ---------------------------------------------------------------------------
  // Состояние приложения - Приложения - File
  // ---------------------------------------------------------------------------
  pShellApplicationFile := TPanel.Create(cpShellApplication);
  with pShellApplicationFile do
  begin
    Parent := cpShellApplication;
    Align := alTop;
  end;

  mShellApplicationFileL := TMemo.Create(pShellApplicationFile);
  with mShellApplicationFileL do
  begin
    Parent := pShellApplicationFile;
    Text := GetLanguageText(self.Name, 'mShellApplicationFileL', lngRus);
  end;

  mShellApplicationFileV := TMemo.Create(pShellApplicationFile);
  with mShellApplicationFileV do
  begin
    Parent := pShellApplicationFile;
    Lines.Add('mShellApplicationFileV');
  end;

{$IFDEF WIN64}
  // ---------------------------------------------------------------------------
  // Состояние приложения - Приложения - x86
  // ---------------------------------------------------------------------------
  pShellApplication_x86 := TPanel.Create(cpShellApplication);
  with pShellApplication_x86 do
  begin
    Parent := cpShellApplication;
    Align := alTop;
    Top := 0;
  end;

  mShellApplication_x86L := TMemo.Create(pShellApplication_x86);
  with mShellApplication_x86L do
  begin
    Parent := pShellApplication_x86;
    Text := GetLanguageText(self.Name, 'mShellApplication_x86L', lngRus);
  end;

  mShellApplication_x86V := TMemo.Create(pShellApplication_x86);
  with mShellApplication_x86V do
  begin
    Parent := pShellApplication_x86;
    Lines.Add('mShellApplication_x86V');
  end;
{$ENDIF}
  // ---------------------------------------------------------------------------
  // Состояние приложения - Kodi
  // ---------------------------------------------------------------------------
  cpKodi := TCustomCategoryPanel.Create(cpgState);
  with cpKodi do
  begin
    Parent := cpgState;
    PanelGroup := cpgState;
    Caption := GetLanguageText(Main.Name, 'cpKodi', lngRus);
    Color := cpgState.Color;
    Height := 100;
    Name := 'cpKodi';
    FullRepaint := False;
    DoubleBuffered := True;
    onExpand := cpRemoteControlExpand;
  end;
  // ---------------------------------------------------------------------------
  // Состояние приложения - Kodi - Label
  // ---------------------------------------------------------------------------
  pKodiPlayingLabel := TPanel.Create(cpKodi);
  with pKodiPlayingLabel do
  begin
    Parent := cpKodi;
    Align := alTop;
  end;

  mKodiPlayingLabelL := TMemo.Create(pKodiPlayingLabel);
  with mKodiPlayingLabelL do
  begin
    Parent := pKodiPlayingLabel;
    Text := GetLanguageText(self.Name, 'mKodiPlayingLabelL', lngRus);
  end;

  mKodiPlayingLabelV := TMemo.Create(pKodiPlayingLabel);
  with mKodiPlayingLabelV do
  begin
    Parent := pKodiPlayingLabel;
    Lines.Add('mKodiPlayingLabelV');
  end;

  // ---------------------------------------------------------------------------
  // Состояние приложения - Kodi - File
  // ---------------------------------------------------------------------------
  pKodiPlayingFile := TPanel.Create(cpKodi);
  with pKodiPlayingFile do
  begin
    Parent := cpKodi;
    Align := alTop;
  end;

  mKodiPlayingFileL := TMemo.Create(pKodiPlayingFile);
  with mKodiPlayingFileL do
  begin
    Parent := pKodiPlayingFile;
    Text := GetLanguageText(self.Name, 'mKodiPlayingFileL', lngRus);
  end;

  mKodiPlayingFileV := TMemo.Create(pKodiPlayingFile);
  with mKodiPlayingFileV do
  begin
    Parent := pKodiPlayingFile;
    Lines.Add('mKodiPlayingFileV');
  end;

{$IFDEF DEBUG}
  // ---------------------------------------------------------------------------
  // Поле ввода + кнопка для теста принятых данных
  // ---------------------------------------------------------------------------
  pTestReadData := TPanel.Create(pLeft);
  with pTestReadData do
  begin
    Parent := pLeft;
    BevelOuter := bvNone;
    BorderStyle := bsSingle;
    Ctl3D := False;
    Color := clWhite;
    ParentBackground := False;
    Align := alBottom;
    Height := 23;
    AlignWithMargins := True;
    Margins.Right := 0;
  end;

  btnTestReadData := TButton.Create(pTestReadData);
  with btnTestReadData do
  begin
    Parent := pTestReadData;
    OnClick := btnTestReadDataClick;
    Align := alRight;
    Width := 80;
    Caption := 'Тест';
    Hint := 'Тест получения данных от COM порта';
  end;

  edTestReadData := TEdit.Create(pTestReadData);
  with edTestReadData do
  begin
    Parent := pTestReadData;
    Align := alClient;
    BorderStyle := bsNone;
    AlignWithMargins := True;
    OnKeyDown := edTestReadDataKeyDown;
  end;
{$ENDIF}
end;

procedure TMain.SettingComponent();
var
  LLeft, LWidth, i: Integer;

  procedure SettingPanel(APanel: TPanel);
  begin
    with APanel do
    begin
      AutoSize := True;
      Enabled := False;
      BevelOuter := bvNone;
      AlignWithMargins := True;
      ParentBackground := True;
      Margins.Bottom := 0;
      Margins.left := 0;
      Margins.Right := 3;
      Margins.Top := 3;
    end;
  end;

  procedure SettingLabel(AMemo: TMemo);
  begin
    with AMemo do
    begin
      Alignment := taRightJustify;
      Top := 0;
      left := LLeft * 3;
      Width := LWidth;
      Height := 13;
      BorderStyle := bsNone;
      ReadOnly := True;

      // ParentColor := False;
      // Color := clGreen;
    end;
  end;

  procedure SettingValue(AMemo: TMemo);
  begin
    with AMemo do
    begin
      Top := 0;
      left := (LLeft * 3) + LWidth + 4;
      Width := Parent.Width - AMemo.left - 5;
      Height := 13;
      Anchors := [akLeft, akTop, akRight];
      BorderStyle := bsNone;
      ReadOnly := True;

      // ParentColor := False;
      // Color := clRed;
    end;
  end;

begin
  LLeft := 8;
  LWidth := 150;

  // RemoteControl
  SettingPanel(pRemoteControlLast);
  SettingLabel(mRemoteControlLastL);
  SettingValue(mRemoteControlLastV);

  // ShellApplication
{$IFDEF WIN64}
  SettingPanel(pShellApplication_x86);
  SettingLabel(mShellApplication_x86L);
  SettingValue(mShellApplication_x86V);
{$ENDIF}
  //
  SettingPanel(pShellApplicationFile);
  SettingLabel(mShellApplicationFileL);
  SettingValue(mShellApplicationFileV);

  // Kodi
  SettingPanel(pKodiPlayingLabel);
  SettingLabel(mKodiPlayingLabelL);
  SettingValue(mKodiPlayingLabelV);

  SettingPanel(pKodiPlayingFile);
  SettingLabel(mKodiPlayingFileL);
  SettingValue(mKodiPlayingFileV);

  plvReadComPort.Align := alClient;
  lvReadComPort.Align := alClient;
  SendMessage(lvReadComPort.Handle, WM_UPDATEUISTATE, MakeLong(UIS_SET, UISF_HIDEFOCUS), 0);

  Tray.Icon := Application.Icon;
  pClient.Align := alClient;

  // чистим контролы
  for i := 0 to self.ComponentCount - 1 do
  begin
    // Label
    // if self.Components[i] is TLabel then
    // TLabel(self.Components[i]).Caption := '';
    // Memo
    // if self.Components[i] is TMemo then
    // TMemo(self.Components[i]).Lines.Clear;
    // Panel
    if self.Components[i] is TPanel then
      TPanel(self.Components[i]).Caption := '';
  end;

end;

procedure TMain.onShellApplicationWindowsHook(Sender: TObject; const HSHELL: NativeInt;
  const ApplicationData: TEXEVersionData);
var
  LItem: TListItem;
begin
  lvShellApplication.Items.BeginUpdate;
  try
    LItem := lvShellApplication.Items.Add;
    case HSHELL of
      HSHELL_WINDOWCREATED:
        begin
          LItem.Caption := 'WindowCreated';
          if (FSetting.Kodi.Using) and (ApplicationData.FileName = FSetting.Kodi.FileName) and
            not Assigned(FKodi) then
            StartEventKodi;
        end;
      HSHELL_WINDOWDESTROYED:
        LItem.Caption := 'WindowDestroyed';
      HSHELL_ACTIVATESHELLWINDOW:
        LItem.Caption := 'ActivateShellWindow';
      HSHELL_WINDOWACTIVATED:
        LItem.Caption := 'WindowActivated';
      HSHELL_GETMINRECT:
        LItem.Caption := 'GetMinRect';
      HSHELL_REDRAW:
        LItem.Caption := 'ReDraw';
      HSHELL_TASKMAN:
        LItem.Caption := 'TaskMan';
      HSHELL_LANGUAGE:
        LItem.Caption := 'Language';
      HSHELL_ACCESSIBILITYSTATE:
        LItem.Caption := 'AccessibilityState';
      HSHELL_APPCOMMAND:
        LItem.Caption := 'AppCommand';
      HSHELL_WINDOWREPLACED:
        LItem.Caption := 'WindowReplaced';
    end;
    LItem.SubItems.Add(ApplicationData.FileName);

    lvShellApplication.Selected := LItem;
    lvShellApplication.Items[lvShellApplication.Items.Count - 1].MakeVisible(True);
  finally
    lvShellApplication.Items.EndUpdate;
  end;

  if (GetWindowlong(lvShellApplication.Handle, GWL_STYLE) and WS_HSCROLL) > 0 then
    lvShellApplication.Perform(CM_RecreateWnd, 0, 0);

  SetMemoValue(mShellApplicationFileV, ApplicationData.FileName);
end;

procedure TMain.onShellApplicationRunning(Running: Boolean);
begin
  if Running then
    StatusBar.Panels[1].Text := GetLanguageMsg('msgSatusBarAppWorking', lngRus)
  else
  begin
{$IFDEF WIN64}
    SetMemoValue(mShellApplication_x86V, '');
{$ENDIF}
    SetMemoValue(mShellApplicationFileV, '');
    StatusBar.Panels[1].Text := GetLanguageMsg('msgSatusBarAppNotWorking', lngRus);
  end;
end;

{$IFDEF WIN64}

procedure TMain.onShellApplicationStatus_x86(Sender: TObject; const Line: string;
  const Pipe: TsaPipe);
begin
  SetMemoValue(mShellApplication_x86V, Line);
end;
{$ENDIF}

procedure TMain.onComPortBeforeOpen(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvReadComPort.Items.Count - 1 do
    Dispose(lvReadComPort.Items[i].Data);
  lvReadComPort.Items.Clear;

  for i := 0 to lbRemoteControl.Items.Count - 1 do
    (lbRemoteControl.Items.Objects[i] as TObjectRemoteCommand).Free;
  lbRemoteControl.Items.Clear();
end;

procedure TMain.onComPortAfterOpen(Sender: TObject);

begin
  ActComPortOpenClose.ImageIndex := 4;
  ActComPortOpenClose.Caption := GetLanguageText(Main.Name, 'ActComPortClose', lngRus);

  StatusBar.Panels[0].Text := Format(GetLanguageMsg('msgSatusBarComPortConnected', lngRus),
    [TComPort(Sender).Port]);

  try
    // Соединение с БД
    if not Assigned(FDataBase) then
      FDataBase := TDataBase.Create(FSetting.RemoteControl.DB.FileName);

    if not FDataBase.Connected then
      FDataBase.Connect;

    // Выполнение команд
    if not Assigned(FExecuteCommand) then
      FExecuteCommand := TExecuteCommand.Create(FDataBase);

    FExecuteCommand.onExecuteBegin := onExecuteCommandBegin;
    FExecuteCommand.OnExecuting := onExecuteCommandExecuting;
    FExecuteCommand.onExecuteEnd := onExecuteCommandEnd;
    FExecuteCommand.OnPreviousCommand := onExecuteCommandPrevious;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;

end;

procedure TMain.onComPortClose(Sender: TObject);
begin
  ActComPortOpenClose.ImageIndex := 3;
  ActComPortOpenClose.Caption := GetLanguageText(Main.Name, 'ActComPortOpen', lngRus);

  StatusBar.Panels[0].Text := GetLanguageMsg('msgSatusBarComPortNotConnected', lngRus);
  SetMemoValue(mRemoteControlLastV, '');

  try
    if Assigned(FDataBase) and FDataBase.Connected then
    begin
      FDataBase.Disconnect;
    end;
  finally
    FreeAndNil(FDataBase);
  end;

  FreeAndNil(FExecuteCommand);
end;

procedure TMain.onComPortReadData(Sender: TObject; const Data: string);
var
  LItem: TListItem;
  RCommand: TRemoteCommand;
  D: PReadComPortData;
  Num: Integer;
  R: TRect;
begin

  lvReadComPort.Items.BeginUpdate;
  try

    if lvReadComPort.Items.Count >= FSetting.ComPort.ShowLast then
    begin
      Dispose(lvReadComPort.Items[0].Data);
      lvReadComPort.Items.Delete(0);
    end;

    if lvReadComPort.Items.Count = 0 then
      Num := 1
    else
      Num := strtoint(lvReadComPort.Items[lvReadComPort.Items.Count - 1].Caption) + 1;

    LItem := lvReadComPort.Items.Add;
    LItem.Caption := inttostr(Num);

    new(D);
    D^.Command := Data;
    D^.Exists := False;

    LItem.Data := D;
    LItem.SubItems.Add(Data);

    lvReadComPort.Selected := LItem;
    lvReadComPort.Items[lvReadComPort.Items.Count - 1].MakeVisible(True);
    lvReadComPort.Columns[0].Width := -2;
  finally
    lvReadComPort.Items.EndUpdate;
  end;
  lvReadComPort.Update;

  try
    if Assigned(FDataBase) and FDataBase.Connected then
    begin

      if FDataBase.RemoteCommandExists(Data, RCommand) then
      begin
        D^.Exists := True;
        D^.Desc := RCommand.Desc;

        // Обновляем область с Item
        ListView_GetItemRect(lvReadComPort.Handle, LItem.Index, R, 0);
        InvalidateRect(lvReadComPort.Handle, R, True);

        FExecuteCommand.Execute(RCommand);
      end
      else
        FExecuteCommand.ClearPrevious();

    end;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TMain.onExecuteCommandBegin(EIndex: Integer; RCommand: TRemoteCommand; Operations: string;
  OWait: Integer; RepeatPrevious: Boolean);
var
  ObjRCommand: TObjectRemoteCommand;
begin

  lbRemoteControl.Items.BeginUpdate;
  try
    if (lbRemoteControl.Items.Count > 0) and
      (lbRemoteControl.Items.Count >= FSetting.RemoteControl.ShowLast) and
      ((lbRemoteControl.Items.Objects[0] as TObjectRemoteCommand).State = ecEnd) then
    begin
      (lbRemoteControl.Items.Objects[0] as TObjectRemoteCommand).Free;
      lbRemoteControl.Items.Delete(0);
    end;

    ObjRCommand := TObjectRemoteCommand.Create(EIndex, string(RCommand.Command), OWait);
    if RepeatPrevious then
      ilSmall.GetIcon(13, ObjRCommand.Icon);
    lbRemoteControl.Items.AddObject(Operations, ObjRCommand);
  finally
    lbRemoteControl.Items.EndUpdate;
  end;

  lbRemoteControl.ItemIndex := lbRemoteControl.Items.Count - 1;
end;

procedure TMain.onExecuteCommandEnd(EIndex: Integer);
var
  i: Integer;
  ObjRCommand: TObjectRemoteCommand;
begin
  ObjRCommand := nil;

  for i := 0 to lbRemoteControl.Items.Count - 1 do
    if TObjectRemoteCommand(lbRemoteControl.Items.Objects[i]).EIndex = EIndex then
    begin
      ObjRCommand := (lbRemoteControl.Items.Objects[i] as TObjectRemoteCommand);
      break;
    end;

  if ObjRCommand = nil then
    exit;

  ObjRCommand.State := ecEnd;

  InvalidateRect(lbRemoteControl.Handle, lbRemoteControl.ItemRect(i), True);

  if (lbRemoteControl.Items.Count > 0) and
    (lbRemoteControl.Items.Count >= FSetting.RemoteControl.ShowLast + 1) and
    ((lbRemoteControl.Items.Objects[0] as TObjectRemoteCommand).State = ecEnd) then
  begin
    (lbRemoteControl.Items.Objects[0] as TObjectRemoteCommand).Free;
    lbRemoteControl.Items.Delete(0);
  end;
end;

procedure TMain.onExecuteCommandExecuting(EIndex: Integer; Step: Integer);
var
  i: Integer;
  ObjRCommand: TObjectRemoteCommand;
begin
  ObjRCommand := nil;

  for i := 0 to lbRemoteControl.Items.Count - 1 do
    if TObjectRemoteCommand(lbRemoteControl.Items.Objects[i]).EIndex = EIndex then
    begin
      ObjRCommand := (lbRemoteControl.Items.Objects[i] as TObjectRemoteCommand);
      break;
    end;

  if ObjRCommand = nil then
    exit;

  ObjRCommand.State := ecExecuting;
  ObjRCommand.Current := Step;
  InvalidateRect(lbRemoteControl.Handle, lbRemoteControl.ItemRect(i), True);
end;

procedure TMain.onExecuteCommandPrevious(Operations: string);
begin
  SetMemoValue(mRemoteControlLastV, Operations);
end;

procedure TMain.onKodiPlayer(Player: string);
var
  LItem: TListItem;
begin
  lvEventKodi.Items.BeginUpdate;
  try
    LItem := lvEventKodi.Items.Add;
    LItem.Caption := Player;

    lvEventKodi.Selected := LItem;
    lvEventKodi.Items[lvEventKodi.Items.Count - 1].MakeVisible(True);
  finally
    lvEventKodi.Items.EndUpdate;
  end;

  if (GetWindowlong(lvEventKodi.Handle, GWL_STYLE) and WS_HSCROLL) > 0 then
    lvEventKodi.Perform(CM_RecreateWnd, 0, 0);
end;

procedure TMain.onKodiPlayerState(Player, State: string);
var
  LItem: TListItem;
begin
  lvEventKodi.Items.BeginUpdate;
  try
    LItem := lvEventKodi.Items.Add;
    LItem.Caption := Player;
    LItem.SubItems.Add(State);

    lvEventKodi.Selected := LItem;
    lvEventKodi.Items[lvEventKodi.Items.Count - 1].MakeVisible(True);
  finally
    lvEventKodi.Items.EndUpdate;
  end;

  if (GetWindowlong(lvEventKodi.Handle, GWL_STYLE) and WS_HSCROLL) > 0 then
    lvEventKodi.Perform(CM_RecreateWnd, 0, 0);
end;

procedure TMain.onKodiPlaying(Player: string; Playing: TPlaying);
begin
  SetMemoValue(mKodiPlayingLabelV, Playing.PLabel);
  SetMemoValue(mKodiPlayingFileV, Playing.PFile);
end;

procedure TMain.onKodiRunning(Running: Boolean);
begin
  if Running then
    StatusBar.Panels[2].Text := GetLanguageMsg('msgSatusBarKodiWorking', lngRus)
  else
  begin
    StatusBar.Panels[2].Text := GetLanguageMsg('msgSatusBarKodiNotWorking', lngRus);
    SetMemoValue(mKodiPlayingLabelV, '');
    SetMemoValue(mKodiPlayingFileV, '');
  end;
end;

procedure TMain.ShowNotification(const Title, AlertBode: string);
var
  Notif: TNotification;
begin
  Notif := AppNotification.CreateNotification;
  try
    Notif.Name := 'HTPCControl';
    Notif.Title := Title;
    Notif.AlertBody := AlertBode;

    AppNotification.PresentNotification(Notif);
  finally
    Notif.Free;
  end;
end;

end.
