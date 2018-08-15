unit uMain;

{ https://sourceforge.net/projects/comport/?source=typ_redirect }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnList, System.Win.Registry,
  Vcl.PlatformDefaultStyleActnCtrls, System.Actions, UCustomPageControl, System.UITypes,
  System.ImageList, Vcl.ImgList, Winapi.shellApi, System.IniFiles, uShellApplication,
  uSettings, uDataBase, uEventKodi, uComPort, Vcl.Menus, Vcl.ActnPopup, CommCtrl, uExecuteCommand,
  System.Notification, Vcl.AppEvnts, MMDevApi, Winapi.ActiveX, Vcl.ActnMenus,
  uTypes;

type
  TMain = class(TForm)
    StatusBar: TStatusBar;
    pComPort: TPanel;
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
    ActRCAllCommand: TAction;
    Tray: TTrayIcon;
    AppNotification: TNotificationCenter;
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
    lKodiPlayingLabel: TLabel;
    ActKodiStart: TAction;
    ActKodiStop: TAction;
    SplitterBottom: TSplitter;
    scrbFooter: TScrollBox;
    plvReadComPort: TPanel;
    lKodiPlayingFile: TLabel;
    pKodiPlayingFile: TPanel;
    pKodiHeader: TPanel;
    pKodiPlayingLabel: TPanel;
    pShellApplicationHeader: TPanel;
    pShellApplication_x86: TPanel;
    lShellApplication_x86: TLabel;
    pShellApplicationFile: TPanel;
    lShellApplicationFile: TLabel;
    pRemoteControlHeader: TPanel;
    pRemoteControlLast: TPanel;
    mShellApplicationFileV: TMemo;
    mShellApplication_x86V: TMemo;
    mKodiPlayingLabelV: TMemo;
    mKodiPlayingFileV: TMemo;
    mRemoteControlLastV: TMemo;
    mRemoteControlLastL: TMemo;
    mRemoteControlH: TMemo;
    mShellApplicationH: TMemo;
    mKodiH: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
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
    procedure FormDestroy(Sender: TObject);
    procedure ActRCAllCommandExecute(Sender: TObject);
    procedure AppEventsMinimize(Sender: TObject);
    procedure TrayClick(Sender: TObject);
    procedure TrayDblClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ActFileExecute(Sender: TObject);
    procedure ActFileExitExecute(Sender: TObject);
    procedure ActComPortExecute(Sender: TObject);
    procedure ActRCExecute(Sender: TObject);
    procedure ActShellAppExecute(Sender: TObject);
    procedure ActKodiExecute(Sender: TObject);
    procedure ActToolsExecute(Sender: TObject);
    procedure ActHelpExecute(Sender: TObject);
    procedure lvReadComPortCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ActShellAppStartExecute(Sender: TObject);
    procedure ActShellAppStopExecute(Sender: TObject);
    procedure AppEventsMessage(var Msg: tagMSG; var Handled: Boolean);

    procedure lvRemoteControlCustomDrawSubItem(Sender: TCustomListView; Item: TListItem;
      SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvShellApplicationCustomDrawSubItem(Sender: TCustomListView; Item: TListItem;
      SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ActKodiStartExecute(Sender: TObject);
    procedure ActKodiStopExecute(Sender: TObject);
    procedure scrbFooterResize(Sender: TObject);
  private
    { Private declarations }
    plvRemoteControl: TPanel;
    plvShellApplication: TPanel;
    plvEventKodi: TPanel;

    lvRemoteControl: TListView;
    lvShellApplication: TListView;
    lvEventKodi: TListView;

    FArduino: TComPort;
    FExecuteCommand: TExecuteCommand;
    FKodi: TKodi;
    FDataBase: TDataBase;
    FShellApplication: TShellApplications;
    FSetting: TSetting;

    FPageClient: TCustomPageControl;
    FSureExit: Boolean;
    FProcessingEventHandler: Boolean;

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

    procedure onComPortOpen(Sender: TObject);
    procedure onComPortClose(Sender: TObject);
    procedure onComPortReadData(Sender: TObject; const Data: string);

    procedure onShellApplicationRunning(Running: Boolean);
    procedure onShellApplicationStatus_x86(Sender: TObject; const Line: string;
      const Pipe: TsaPipe);
    procedure OnShellApplicationWindowsHook(Sender: TObject; const HSHELL: NativeInt;
      const ApplicationData: TEXEVersionData);

    procedure onExecuteCommand(ECommand: TECommand; ECType: TecType; RepeatPreview: Boolean);
    procedure onExecuteCommandSetPreviewCommand(RCommand: PRemoteCommand; Opearion: string);

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
  public
    { Public declarations }
    property DataBase: TDataBase read FDataBase;
    property Arduino: TComPort read FArduino;
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

uses uAbout, uControlCommand, uLanguage, uAllCommand, USendComPort;

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

  for i := 0 to lvRemoteControl.Items.Count - 1 do
    Dispose(lvRemoteControl.Items[i].Data);

  if Assigned(lvRemoteControl) then
    lvRemoteControl.Free;
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

  FPageClient.Free;
end;

procedure TMain.ActRCAllCommandExecute(Sender: TObject);
var
  LAC: TfrmAllCommand;
begin
  if Assigned(FDataBase) and FDataBase.Connected then
  begin
    LAC := TfrmAllCommand.Create(self);
    try
      LAC.ShowModal;
    finally
      LAC.Free;
    end;
  end;
end;

procedure TMain.ActRCAddExecute(Sender: TObject);
var
  LCC: TfrmControlCommand;
begin
  LCC := TfrmControlCommand.Create(self);
  try
    LCC.cType := ccAdd;
    LCC.Caption := GetLanguageText(LCC.Name, 'CaptionAdd', lngRus);
    LCC.edCCCommand.Text := TReadComPort(lvReadComPort.Selected.Data^).Command;
    LCC.ShowModal;
  finally
    LCC.Free;
  end;
end;

procedure TMain.ActRCEditExecute(Sender: TObject);
var
  LCC: TfrmControlCommand;
begin
  LCC := TfrmControlCommand.Create(self);
  try
    LCC.cType := ccEdit;
    LCC.Caption := GetLanguageText(LCC.Name, 'CaptionEdit', lngRus);
    LCC.edCCCommand.Text := TReadComPort(lvReadComPort.Selected.Data^).Command;
    LCC.ShowModal;
  finally
    LCC.Free;
  end;
end;

procedure TMain.ActRCDeleteExecute(Sender: TObject);
var
  LCommand: string;
begin
  LCommand := TReadComPort(lvReadComPort.Selected.Data^).Command;

  if MessageDlg(Format(GetLanguageMsg('msgDBDeleteRemoteCommand', lngRus), [LCommand]),
    mtConfirmation, mbOKCancel, 1) = mrOk then
    try
      FDataBase.DeleteCommand(LCommand);
      MessageDlg(GetLanguageMsg('msgDBDeleteRemoteCommandSuccess', lngRus), mtInformation,
        [mbOK], 0);
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
  if FileExists(FSetting.DB.FileName) then
    ShellExecute(Main.Handle, 'open', PWideChar(WideString(FSetting.DB.FileName)), nil, nil,
      SW_SHOWNORMAL);
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

procedure TMain.AppEventsMessage(var Msg: tagMSG; var Handled: Boolean);
var
  LComPortConnected: Boolean;
  LDataBaseConnected: Boolean;
  LShellApplicationStarting: Boolean;
  LKodiStarting: Boolean;
begin
  if Processing then
    Exit;

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

    { DataBase }
    ActRCAllCommand.Enabled := LDataBaseConnected;

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

// procedure TMain.SetLabelHeight(ALabel: TLabel);
// var
// Rect: TRect;
// begin
// // if ALabel.Canvas.TextWidth(Text) < ALabel.Width then
// // begin
// Rect.Left := 0;
// Rect.Top := 0;
// Rect.Right := ALabel.Width;
// Rect.Bottom := ALabel.Height;
//
// ALabel.Height := DrawText(ALabel.Canvas.Handle, PChar(ALabel.Caption), -1, Rect,
// DT_CALCRECT or DT_WORDBREAK);
// // end;
// end;

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
end;

procedure TMain.SetMemoValue(AMemo: TMemo; Value: string);
begin
  AMemo.Lines.Clear;
  // AMemo.
  // AMemo.Lines.Add(Value);
  // SetScrollPos(AMemo.Handle, SB_VERT, 0, False);
  AMemo.Lines.Text := Value;
  // AMemo.Lines.CommaText := Value;
  SetMemoHeight(AMemo);
end;

procedure TMain.LoadWindowSetting;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(ExtractFileDir(Application.ExeName) + '\' + FileSetting);
  try
    Main.Left := IniFile.ReadInteger('Window', 'Left', Main.Left);
    Main.Top := IniFile.ReadInteger('Window', 'Top', Main.Top);
    Main.Width := IniFile.ReadInteger('Window', 'Width', Main.Width);
    Main.Height := IniFile.ReadInteger('Window', 'Height', Main.Height);
    if IniFile.ReadBool('Window', 'Maximized', True) then
      Main.WindowState := wsMaximized;

    Main.pComPort.Width := IniFile.ReadInteger('Window', 'SplitterLeft', Main.pComPort.Width);
    Main.scrbFooter.Height := IniFile.ReadInteger('Window', 'SplitterBottom',
      Main.scrbFooter.Height);
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
      IniFile.WriteInteger('Window', 'Left', Main.Left);
      IniFile.WriteInteger('Window', 'Top', Main.Top);
      IniFile.WriteInteger('Window', 'Width', Main.Width);
      IniFile.WriteInteger('Window', 'Height', Main.Height);
    end;
    IniFile.WriteInteger('Window', 'SplitterLeft', Main.pComPort.Width);
    IniFile.WriteInteger('Window', 'SplitterBottom', Main.scrbFooter.Height);
  finally
    IniFile.Free;
  end;
end;

procedure TMain.scrbFooterResize(Sender: TObject);
begin
  SetMemoHeight(mRemoteControlLastV);

  SetMemoHeight(mShellApplication_x86V);
  SetMemoHeight(mShellApplicationFileV);

  SetMemoHeight(mKodiPlayingLabelV);
  SetMemoHeight(mKodiPlayingFileV);
end;

procedure TMain.lvRemoteControlCustomDrawSubItem(Sender: TCustomListView; Item: TListItem;
  SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  aRect: TRect;
  LIcon: TIcon;
  LSubItemText: string;
  LLeft: Integer;
  LEPCommand: TEPCommand;
begin
  if (SubItem = 1) then
  begin
    LEPCommand := TEPCommand(Item.Data^);
    ListView_GetSubItemRect(Sender.Handle, Item.Index, SubItem, LVIR_BOUNDS, @aRect);
    SetBkMode(Sender.Canvas.Handle, TRANSPARENT);
    LSubItemText := Item.SubItems[SubItem - 1];
    LLeft := 0;

    LIcon := TIcon.Create();
    try
      case LEPCommand.ECommand.ECType of
        ecKyeboard:
          if LEPCommand.RepeatPreview then
            ilSmall.GetIcon(13, LIcon)
          else
            ilSmall.GetIcon(12, LIcon);
        ecApplication:
          if FileExists(String(LEPCommand.ECommand.Application)) then
            SmallIconEXE(String(LEPCommand.ECommand.Application), LIcon)
            // SmallIconFromExecutableFile(LEPCommand.ECommand.Application, LIcon)
      end;

      Sender.Canvas.Draw(aRect.Left + 5, aRect.Top + 1, LIcon);
      LLeft := LIcon.Width + 5;
    finally
      LIcon.Free;
    end;

    Sender.Canvas.TextOut(aRect.Left + 5 + LLeft, aRect.Top + 1, LSubItemText);
    DefaultDraw := False;
  end;
end;

procedure TMain.lvShellApplicationCustomDrawSubItem(Sender: TCustomListView; Item: TListItem;
  SubItem: Integer; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  aRect: TRect;
  LIcon: TIcon;
  LSubItemText: string;
  LLeft: Integer;
begin
  if (SubItem = 1) then
  begin
    ListView_GetSubItemRect(Sender.Handle, Item.Index, SubItem, LVIR_BOUNDS, @aRect);
    SetBkMode(Sender.Canvas.Handle, TRANSPARENT);
    LSubItemText := Item.SubItems[SubItem - 1];
    LLeft := 0;

    LIcon := TIcon.Create();
    try

      if FileExists(LSubItemText) then
        SmallIconEXE(LSubItemText, LIcon);
      // SmallIconFromExecutableFile(LSubItemText, LIcon);

      Sender.Canvas.Draw(aRect.Left + 5, aRect.Top + 1, LIcon);
      LLeft := LIcon.Width + 5;
    finally
      LIcon.Free;
    end;

    Sender.Canvas.TextOut(aRect.Left + 5 + LLeft, aRect.Top + 1, LSubItemText);
    DefaultDraw := False;
  end;
end;

procedure TMain.lvReadComPortContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  HeaderRect: TRect;
  Pos: TPoint;
  RCommand: TRemoteCommand;
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
      Exit;
    end;

    LCommand := TReadComPort(lvReadComPort.Selected.Data^).Command;
    CommandExists := FDataBase.CommandExists(LCommand, RCommand);
    ActRCAdd.Enabled := not CommandExists;
    ActRCEdit.Enabled := CommandExists;
    ActRCDelete.Enabled := CommandExists;

    PopupActReadComPort.Popup(Pos.X, Pos.Y);
  end;
end;

procedure TMain.lvReadComPortCustomDrawItem(Sender: TCustomListView; Item: TListItem;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if (Item.Index mod 2) = 1 then
    Sender.Canvas.Brush.Color := clBtnFace
  else
    Sender.Canvas.Brush.Color := clWhite;

  if not TReadComPort(Item.Data^).Exists then
    Sender.Canvas.Font.Color := clRed;

  // DefaultDraw := False;
end;

procedure TMain.TrayClick(Sender: TObject);
begin
  // OpenTray;
end;

procedure TMain.TrayDblClick(Sender: TObject);
begin
  OpenTray;
end;

procedure TMain.TurnTray();
begin
  Tray.Visible := True;
  ShowWindow(Main.Handle, SW_HIDE); // Скрываем программу
  ShowWindow(Application.Handle, SW_HIDE); // Скрываем кнопку с TaskBar'а
  SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle, GWL_EXSTYLE) or
    (not WS_EX_APPWINDOW));
end;

procedure TMain.OpenTray();
begin
  ShowWindow(Main.Handle, SW_RESTORE);
  SetForegroundWindow(Main.Handle);
  Tray.Visible := False;
  Main.Visible := True;
end;

function TMain.Processing: Boolean;
begin
  Result := True;
  if FProcessingEventHandler then
    Exit;
  Result := False;
end;

procedure TMain.OpenComPort();
begin
  if not Assigned(FArduino) or not FArduino.Connected then
  begin
    FArduino := TComPort.Create(FSetting.ComPort.Port);
    FArduino.onAfterOpen := onComPortOpen;
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

procedure TMain.StartEventApplication();
begin
  if not Assigned(FShellApplication) or not FShellApplication.Starting then
  begin
    FShellApplication := TShellApplications.Create(Main);
    FShellApplication.OnRunning := onShellApplicationRunning;
    FShellApplication.OnStatus_x86 := onShellApplicationStatus_x86;
    FShellApplication.OnWindowsHook := OnShellApplicationWindowsHook;
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
    LItemGlobal.Items.Add.Action := ActRCAllCommand;
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
    LItem.Action := ActRCAllCommand;
    LItem.ShowCaption := True;

    LItem := Items.Add;
    LItem.Caption := '-';
    LItem.CommandStyle := csSeparator;

    LItem := Items.Add;
    LItem.Action := ActToolsSetting;
    LItem.ShowCaption := False;
  end;

  pComPort.Width := pComPort.Width + 1;
  pComPort.Width := pComPort.Width - 1;
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
  // Панель
  FPageClient := TCustomPageControl.Create(self);
  with FPageClient do
  begin
    Left := 10;
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
    Style := tsButtons;
    TabHeight := 24;
  end;
  SendMessage(FPageClient.Handle, WM_UPDATEUISTATE, MakeLong(UIS_SET, UISF_HIDEFOCUS), 0);

  // Вкладка - RemoteControl
  tabRemoteControl := CreateTab(FPageClient, 'TabRemoteControl',
    GetLanguageText(Main.Name, 'TabRemoteControl', lngRus));

  plvRemoteControl := TPanel.Create(tabRemoteControl);
  with plvRemoteControl do
  begin
    Left := 10;
    Top := 10;
    Width := 20;
    Height := 20;
    Parent := tabRemoteControl;
    Align := alClient;
    Ctl3D := False;
    BevelOuter := bvNone;
    BorderStyle := bsSingle;
    AlignWithMargins := True;
    Margins.Left := 0;
    Margins.Bottom := 0;
  end;

  lvRemoteControl := TListView.Create(plvRemoteControl);
  with lvRemoteControl do
  begin
    Left := 10;
    Top := 10;
    Width := 20;
    Height := 20;
    Parent := plvRemoteControl;
    Align := alClient;
    BorderStyle := bsNone;
    ViewStyle := vsReport;
    ReadOnly := True;
    RowSelect := True;
    ColumnClick := False;
    OnCustomDrawSubItem := lvRemoteControlCustomDrawSubItem;

    LColumn := Columns.Add;
    LColumn.Caption := GetLanguageText(Main.Name, 'lvRemoteControl:0', lngRus);
    LColumn.Width := 100;

    LColumn := Columns.Add;
    LColumn.Caption := GetLanguageText(Main.Name, 'lvRemoteControl:1', lngRus);
    LColumn.AutoSize := True;
  end;
  SendMessage(lvRemoteControl.Handle, WM_UPDATEUISTATE, MakeLong(UIS_SET, UISF_HIDEFOCUS), 0);

  // Вкладка - ShellApplication
  tabShellApplication := CreateTab(FPageClient, 'TabShellApplication',
    GetLanguageText(Main.Name, 'TabShellApplication', lngRus));

  plvShellApplication := TPanel.Create(tabShellApplication);
  with plvShellApplication do
  begin
    Left := 10;
    Top := 10;
    Width := 20;
    Height := 20;
    Parent := tabShellApplication;
    Align := alClient;
    Ctl3D := False;
    BevelOuter := bvNone;
    BorderStyle := bsSingle;
    AlignWithMargins := True;
    Margins.Left := 0;
    Margins.Bottom := 0;
  end;

  lvShellApplication := TListView.Create(plvShellApplication);
  with lvShellApplication do
  begin
    Left := 10;
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

  // Вкладка - EventKodi
  tabEventKodi := CreateTab(FPageClient, 'TabEventKodi',
    GetLanguageText(Main.Name, 'TabEventKodi', lngRus));

  plvEventKodi := TPanel.Create(tabEventKodi);
  with plvEventKodi do
  begin
    Left := 10;
    Top := 10;
    Width := 20;
    Height := 20;
    Parent := tabEventKodi;
    Align := alClient;
    Ctl3D := False;
    BevelOuter := bvNone;
    BorderStyle := bsSingle;
    AlignWithMargins := True;
    Margins.Left := 0;
    Margins.Bottom := 0;
  end;

  lvEventKodi := TListView.Create(plvEventKodi);
  with lvEventKodi do
  begin
    Left := 10;
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
end;

procedure TMain.SettingComponent();
var
  LLeft, LWidth, i: Integer;

  procedure SettingPanelHeader(APanel: TPanel);
  begin
    with APanel do
    begin
      AutoSize := True;
      Enabled := False;
      BevelOuter := bvNone;
      AlignWithMargins := True;
      ParentBackground := True;
      Margins.Bottom := 0;
      Margins.Left := 0;
      Margins.Right := 0;
      Margins.Top := 6;
    end;
  end;

  procedure SettingLabelHeader(AMemo: TMemo);
  begin
    with AMemo do
    begin
      Top := 0;
      Left := LLeft;
      Width := Parent.Width - LLeft;
      Height := 13;
      Font.Style := [fsBold];
      BorderStyle := bsNone;
    end;
  end;

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
      Margins.Left := 0;
      Margins.Right := 3;
      Margins.Top := 6;
    end;
  end;

  procedure SettingLabel(ALabel: TLabel); overload;
  begin
    with ALabel do
    begin
      Alignment := taRightJustify;
      AutoSize := False;
      Top := 0;
      Left := LLeft * 2;
      Width := LWidth;
      Height := 13;
      WordWrap := True;

      // ParentColor := False;
      // TRANSPARENT := False;
      // Color := clGreen;
    end;
  end;

  procedure SettingLabel(AMemo: TMemo); overload;
  begin
    with AMemo do
    begin
      Alignment := taRightJustify;
      Top := 0;
      Left := LLeft * 2;
      Width := LWidth;
      Height := 13;
      BorderStyle := bsNone;
      ReadOnly := True;

      // ParentColor := False;
      // Color := clGreen;
    end;
  end;

// procedure SettingValue(ALabel: TLabel);
// begin
// with ALabel do
// begin
// AutoSize := False;
// Top := 0;
// Left := (LLeft * 2) + LWidth + 4;
// Width := scrbFooter.Width - ALabel.Left - 10;
// Height := 13;
// WordWrap := True;
// Anchors := [akLeft, akTop, akRight];
//
// // ParentColor := False;
// // TRANSPARENT := False;
// // Color := clRed;
// end;
// end;

  procedure SettingValue(AMemo: TMemo);
  begin
    with AMemo do
    begin
      Top := 0;
      Left := (LLeft * 2) + LWidth + 4;
      Width := scrbFooter.Width - AMemo.Left - 10;
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
  SettingPanelHeader(pRemoteControlHeader);
  SettingLabelHeader(mRemoteControlH);

  SettingPanel(pRemoteControlLast);
  SettingLabel(mRemoteControlLastL);
  SettingValue(mRemoteControlLastV);

  // ShellApplication
  SettingPanelHeader(pShellApplicationHeader);
  SettingLabelHeader(mShellApplicationH);

  SettingPanel(pShellApplication_x86);
  SettingLabel(lShellApplication_x86);
  SettingValue(mShellApplication_x86V);

  SettingPanel(pShellApplicationFile);
  SettingLabel(lShellApplicationFile);
  SettingValue(mShellApplicationFileV);

  // Kodi
  SettingPanelHeader(pKodiHeader);
  SettingLabelHeader(mKodiH);

  SettingPanel(pKodiPlayingLabel);
  SettingLabel(lKodiPlayingLabel);
  SettingValue(mKodiPlayingLabelV);

  SettingPanel(pKodiPlayingFile);
  SettingLabel(lKodiPlayingFile);
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
    if self.Components[i] is TLabel then
      TLabel(self.Components[i]).Caption := '';
    // Memo
    if self.Components[i] is TMemo then
      TMemo(self.Components[i]).Lines.Clear;
    // Panel
    if self.Components[i] is TPanel then
      TPanel(self.Components[i]).Caption := '';
  end;

end;

procedure TMain.OnShellApplicationWindowsHook(Sender: TObject; const HSHELL: NativeInt;
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

  if (GetWindowLong(lvShellApplication.Handle, GWL_STYLE) and WS_HSCROLL) > 0 then
    lvShellApplication.Perform(CM_RecreateWnd, 0, 0);

  SetMemoValue(mShellApplicationFileV, ApplicationData.FileName);

end;

procedure TMain.onShellApplicationRunning(Running: Boolean);
begin
  if Running then
    StatusBar.Panels[1].Text := GetLanguageMsg('msgSatusBarAppWorking', lngRus)
  else
  begin
    SetMemoValue(mShellApplication_x86V, '');
    StatusBar.Panels[1].Text := GetLanguageMsg('msgSatusBarAppNotWorking', lngRus);
  end;
end;

procedure TMain.onShellApplicationStatus_x86(Sender: TObject; const Line: string;
  const Pipe: TsaPipe);
begin
  SetMemoValue(mShellApplication_x86V, Line);
end;

procedure TMain.onComPortOpen(Sender: TObject);
var
  i: Integer;
begin
  ActComPortOpenClose.ImageIndex := 4;
  ActComPortOpenClose.Caption := GetLanguageText(Main.Name, 'ActComPortClose', lngRus);

  for i := 0 to lvReadComPort.Items.Count - 1 do
    Dispose(lvReadComPort.Items[i].Data);
  lvReadComPort.Items.Clear;

  StatusBar.Panels[0].Text := Format(GetLanguageMsg('msgSatusBarComPortConnected', lngRus),
    [TComPort(Sender).Port]);

  try
    // Соединение с БД
    if not Assigned(FDataBase) then
      FDataBase := TDataBase.Create(FSetting.DB.FileName);

    if not FDataBase.Connected then
      FDataBase.Connect;

    // Выполнение команд
    if not Assigned(FExecuteCommand) then
      FExecuteCommand := TExecuteCommand.Create(FDataBase);

    FExecuteCommand.onExecuteCommand := onExecuteCommand;
    FExecuteCommand.onSetPreviewCommand := onExecuteCommandSetPreviewCommand;
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
  d: PReadComPortData;
  num: Integer;
begin
  lvReadComPort.Items.BeginUpdate;
  try

    if lvReadComPort.Items.Count >= FSetting.ComPort.ShowLast - 1 then
    begin
      Dispose(lvReadComPort.Items[0].Data);
      lvReadComPort.Items.Delete(0);
    end;

    if lvReadComPort.Items.Count = 0 then
      num := 1
    else
      num := StrToInt(lvReadComPort.Items[lvReadComPort.Items.Count - 1].Caption) + 1;

    LItem := lvReadComPort.Items.Add;
    LItem.Caption := inttostr(num);

    new(d);
    d^.Command := Data;
    d^.Exists := False;
    d^.Execute := False;

    LItem.Data := d;
    LItem.SubItems.Add(Data);

    lvReadComPort.Selected := LItem;
    lvReadComPort.Items[lvReadComPort.Items.Count - 1].MakeVisible(True);

    try
      if FDataBase.Connected and FDataBase.CommandExists(Data, RCommand) then
      begin
        TReadComPort(LItem.Data^).Exists := True;

        if length(Trim(String(RCommand.Desc))) > 0 then
          LItem.SubItems[0] := Data + ' (' + String(RCommand.Desc) + ')';

        FExecuteCommand.Execute(RCommand);
      end;
    except
      on E: Exception do
        MessageDlg(E.Message, mtError, [mbOK], 0);
    end;

  finally
    lvReadComPort.Items.EndUpdate;
  end;

  if (GetWindowLong(lvReadComPort.Handle, GWL_STYLE) and WS_HSCROLL) > 0 then
    lvReadComPort.Perform(CM_RecreateWnd, 0, 0);
end;

procedure TMain.onExecuteCommand(ECommand: TECommand; ECType: TecType; RepeatPreview: Boolean);
var
  LItem: TListItem;
  LEPCommand: PEPCommand;
begin
  lvRemoteControl.Items.BeginUpdate;
  try
    LItem := lvRemoteControl.Items.Add;
    LItem.Caption := String(ECommand.Command.Command);

    new(LEPCommand);
    LEPCommand^.ECommand := ECommand;
    LEPCommand^.RepeatPreview := RepeatPreview;
    LItem.Data := LEPCommand;

    case ECType of
      ecKyeboard:
        LItem.SubItems.Add(ECommand.Operation);
      ecApplication:
        LItem.SubItems.Add(ExtractFileName(ECommand.Operation));
    end;

    lvRemoteControl.Selected := LItem;
    lvRemoteControl.Items[lvRemoteControl.Items.Count - 1].MakeVisible(True);
  finally
    lvRemoteControl.Items.EndUpdate;
  end;

  if (GetWindowLong(lvRemoteControl.Handle, GWL_STYLE) and WS_HSCROLL) > 0 then
    lvRemoteControl.Perform(CM_RecreateWnd, 0, 0);
end;

procedure TMain.onExecuteCommandSetPreviewCommand(RCommand: PRemoteCommand; Opearion: string);
begin
  if RCommand = nil then
    SetMemoValue(mRemoteControlLastV, '')
  else
    SetMemoValue(mRemoteControlLastV, Opearion);
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

  if (GetWindowLong(lvEventKodi.Handle, GWL_STYLE) and WS_HSCROLL) > 0 then
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

  if (GetWindowLong(lvEventKodi.Handle, GWL_STYLE) and WS_HSCROLL) > 0 then
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
