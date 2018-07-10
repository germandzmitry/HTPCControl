unit uMain;

// https://sourceforge.net/projects/comport/?source=typ_redirect

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnList, System.Win.Registry,
  Vcl.PlatformDefaultStyleActnCtrls, System.Actions, UCustomPageControl, System.UITypes,
  System.ImageList, Vcl.ImgList, Winapi.shellApi, System.IniFiles, uEventApplication,
  uSettings, uDataBase, uEventKodi, uComPort, Vcl.Menus, Vcl.ActnPopup, CommCtrl;

type
  TMain = class(TForm)
    StatusBar: TStatusBar;
    pComPort: TPanel;
    Splitter: TSplitter;
    pClient: TPanel;
    ActionList: TActionList;
    ActHelpAbout: TAction;
    ilSmall: TImageList;
    ActToolsSetting: TAction;
    ActToolsDeviceManager: TAction;
    ActionManager: TActionManager;
    ActionToolBar: TActionToolBar;
    ActDBOpenAccess: TAction;
    Button1: TButton;
    ActComPortOpen: TAction;
    ActComPortSend: TAction;
    ActComPortClose: TAction;
    ActComPortOpenClose: TAction;
    lvReadComPort: TListView;
    PopupActReadComPort: TPopupActionBar;
    ActDBAdd: TAction;
    ActDBEdit: TAction;
    ActDBDelete: TAction;
    ActAccessAdd1: TMenuItem;
    ActAccessEdit1: TMenuItem;
    ActAccessDelete1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ActHelpAboutExecute(Sender: TObject);
    procedure ActToolsSettingExecute(Sender: TObject);
    procedure ActToolsDeviceManagerExecute(Sender: TObject);
    procedure ActDBOpenAccessExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ActComPortOpenExecute(Sender: TObject);
    procedure ActComPortSendExecute(Sender: TObject);
    procedure ActComPortCloseExecute(Sender: TObject);
    procedure ActComPortOpenCloseExecute(Sender: TObject);
    procedure ActDBAddExecute(Sender: TObject);
    procedure ActDBEditExecute(Sender: TObject);
    procedure ActDBDeleteExecute(Sender: TObject);
    procedure lvReadComPortContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
    lvRemoteControl: TListView;
    lvEventApplication: TListView;
    lvEventKodi: TListView;

    FArduino: TComPort;
    FKodi: TKodi;
    FDataBase: TDataBase;
    FEventApplication: TEventApplications;
    FSetting: TSetting;

    FPageClient: TCustomPageControl;

    procedure LoadWindowSetting();
    procedure SaveWindowSetting();

    procedure onComPortOpen(Sender: TObject);
    procedure onComPortClose(Sender: TObject);
    procedure onComPortReadData(Sender: TObject; const Data: string);

    procedure OnWindowsHook(Sender: TObject; const HSHELL: NativeInt;
      const ApplicationData: TEXEVersionData);

    procedure onAppRunning(Running: Boolean);

    procedure onKodiRunning(Running: Boolean);
    procedure onKodiPlayer(Player: string);
    procedure onKodiPlayerState(Player, State: string);
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

uses uAbout, uControlCommand, uLanguage, uTypes;

procedure TMain.FormCreate(Sender: TObject);

  function CreateTab(aPage: TCustomPageControl; aName: string): TTabSheet;
  begin
    Result := TTabSheet.Create(aPage);
    Result.PageControl := aPage;
    Result.Name := aName;
    Result.Caption := aName;
    Result.DoubleBuffered := True;
  end;

var
  tabRemoteControl, tabEventApplication, tabEventKodi: TTabSheet;
  LColumn: TListColumn;

begin
  LoadWindowSetting;
  FSetting := uSettings.getSetting();

  Main.Caption := Application.Title;

  SendMessage(lvReadComPort.Handle, WM_UPDATEUISTATE, MakeLong(UIS_SET, UISF_HIDEFOCUS), 0);
  Main.lvReadComPort.Align := alClient;

  // Панель
  FPageClient := TCustomPageControl.Create(self);
  with FPageClient do
  begin
    Left := 10;
    Top := 10;
    Width := 20;
    Height := 20;
    Parent := pClient;

    Visible := True;
    Align := alClient;
    OwnerDraw := True;
    TabHeight := 23;
    TabPosition := TTabPosition.tpTop;
    TextFormat := [tfCenter];
    DoubleBuffered := True;
    Style := tsButtons;
    TabHeight := 24;
  end;
  SendMessage(FPageClient.Handle, WM_UPDATEUISTATE, MakeLong(UIS_SET, UISF_HIDEFOCUS), 0);

  // Вкладка - RemoteControl
  tabRemoteControl := CreateTab(FPageClient, 'TabRemoteControl');
  lvRemoteControl := TListView.Create(tabRemoteControl);
  with lvRemoteControl do
  begin
    Left := 10;
    Top := 10;
    Width := 20;
    Height := 20;
    Parent := tabRemoteControl;
    Align := alClient;
    BorderStyle := bsNone;
    ViewStyle := vsReport;
    ReadOnly := True;
    RowSelect := True;
    ColumnClick := False;

    LColumn := Columns.Add;
    LColumn.Caption := 'Команда';
    LColumn.Width := 100;

    LColumn := Columns.Add;
    LColumn.Caption := 'Операция';
    LColumn.AutoSize := True;
  end;

  // Вкладка - EventApplication
  tabEventApplication := CreateTab(FPageClient, 'TabEventApplication');
  lvEventApplication := TListView.Create(tabEventApplication);
  with lvEventApplication do
  begin
    Left := 10;
    Top := 10;
    Width := 20;
    Height := 20;
    Parent := tabEventApplication;
    Align := alClient;
    BorderStyle := bsNone;
    ViewStyle := vsReport;
    ReadOnly := True;
    RowSelect := True;
    ColumnClick := False;

    LColumn := Columns.Add;
    LColumn.Caption := 'Событие';
    LColumn.Width := 100;

    LColumn := Columns.Add;
    LColumn.Caption := 'Приложение';
    LColumn.AutoSize := True;
  end;

  // Вкладка - EventKodi
  tabEventKodi := CreateTab(FPageClient, 'TabEventKodi');
  lvEventKodi := TListView.Create(tabEventKodi);
  with lvEventKodi do
  begin
    Left := 10;
    Top := 10;
    Width := 20;
    Height := 20;
    Parent := tabEventKodi;
    Align := alClient;
    BorderStyle := bsNone;
    ViewStyle := vsReport;
    ReadOnly := True;
    RowSelect := True;
    ColumnClick := False;

    LColumn := Columns.Add;
    LColumn.Caption := 'Плеер';
    LColumn.Width := 100;

    LColumn := Columns.Add;
    LColumn.Caption := 'Состояние';
    LColumn.AutoSize := True;
  end;

  // События приложений
  FEventApplication := TEventApplications.Create(Main);
  FEventApplication.OnRunning := onAppRunning;
  FEventApplication.OnWindowsHook := OnWindowsHook;

  UpdateLanguage(self, lngRus);
end;

procedure TMain.FormShow(Sender: TObject);
begin

  onComPortClose(nil);
  onAppRunning(False);
  onKodiRunning(False);

  if FSetting.EventApplication.Using then
    try
      FEventApplication.Start();
    except
      on E: Exception do
        MessageDlg(E.Message, mtWarning, [mbOK], 0);
    end;
end;

procedure TMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  if Assigned(FArduino) then
  begin
    if FArduino.Connected then
      FArduino.Close;
    FArduino.Free;
  end;

  if Assigned(FKodi) then
    FKodi.Terminate;

  if Assigned(FDataBase) then
    FDataBase.Free;

  if Assigned(FEventApplication) then
  begin
    if FEventApplication.Starting then
      FEventApplication.Stop;
    FEventApplication.Free;
  end;

  SaveWindowSetting;

  if Assigned(lvRemoteControl) then
    lvRemoteControl.Free;
  if Assigned(lvEventApplication) then
    lvEventApplication.Free;
  if Assigned(lvEventKodi) then
    lvEventKodi.Free;
  FPageClient.Free;
end;

procedure TMain.ActDBAddExecute(Sender: TObject);
var
  LCC: TControlCommand;
begin
  LCC := TControlCommand.Create(self);
  try
    LCC.Caption := 'Добавить команду';
    LCC.ShowModal;
  finally
    LCC.Free;
    // FSetting := uSettings.getSetting();
  end;
end;

procedure TMain.ActDBDeleteExecute(Sender: TObject);
begin
  //
end;

procedure TMain.ActDBEditExecute(Sender: TObject);
begin
  //
end;

procedure TMain.ActDBOpenAccessExecute(Sender: TObject);
begin
  if FileExists(FSetting.DB.FileName) then
    ShellExecute(Main.Handle, 'open', PWideChar(WideString(FSetting.DB.FileName)), nil, nil,
      SW_SHOWNORMAL);
end;

procedure TMain.ActComPortOpenCloseExecute(Sender: TObject);
begin
  if not Assigned(FArduino) or not FArduino.Connected then
    try
      FArduino := TComPort.Create();
      FArduino.onAfterOpen := onComPortOpen;
      FArduino.onAfterClose := onComPortClose;
      FArduino.onReadData := onComPortReadData;
      FArduino.Port := FSetting.ComPort.Port;
      FArduino.Open;
    except
      on E: Exception do
      begin
        FreeAndNil(FArduino);
        MessageDlg(E.Message, mtWarning, [mbOK], 0);
      end;
    end
  else if FArduino.Connected then
    try
      FArduino.Close;
    finally
      FreeAndNil(FArduino);
    end;
end;

procedure TMain.ActComPortOpenExecute(Sender: TObject);
begin
  if not Assigned(FArduino) or not FArduino.Connected then
    try
      FArduino := TComPort.Create();
      FArduino.onAfterOpen := onComPortOpen;
      FArduino.onAfterClose := onComPortClose;
      FArduino.onReadData := onComPortReadData;
      FArduino.Port := FSetting.ComPort.Port;
      FArduino.Open;
    except
      on E: Exception do
      begin
        FreeAndNil(FArduino);
        MessageDlg(E.Message, mtWarning, [mbOK], 0);
      end;
    end
end;

procedure TMain.ActComPortCloseExecute(Sender: TObject);
begin
  if Assigned(FArduino) and FArduino.Connected then
    try
      FArduino.Close;
    finally
      FreeAndNil(FArduino);
    end;
end;

procedure TMain.ActComPortSendExecute(Sender: TObject);
begin
  if Assigned(FArduino) and FArduino.Connected then
    try
      FArduino.WriteStr('test' + #13);
    except
      on E: Exception do
        MessageDlg(E.Message, mtWarning, [mbOK], 0);
    end
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

procedure TMain.ActToolsDeviceManagerExecute(Sender: TObject);
begin
  ShellExecute(Main.Handle, 'open', PWideChar(WideString('devmgmt.msc')), nil, nil, SW_SHOWNORMAL);
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

procedure TMain.Button1Click(Sender: TObject);
begin
  onComPortReadData(nil, '259784151');
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
    Main.pComPort.Width := IniFile.ReadInteger('Window', 'Splitter', Main.pComPort.Width);
  finally
    IniFile.Free;
  end;
end;

procedure TMain.lvReadComPortContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
var
  HeaderRect: TRect;
  Pos: TPoint;
begin
  GetWindowRect(ListView_GetHeader(lvReadComPort.Handle), HeaderRect);
  Pos := lvReadComPort.ClientToScreen(MousePos);
  if (not PtInRect(HeaderRect, Pos)) and (lvReadComPort.Selected <> nil) then
  begin

    if lvReadComPort.Selected.Data = nil then
    begin
      ActDBAdd.Enabled := True;
      ActDBEdit.Enabled := False;
      ActDBDelete.Enabled := False;
    end
    else
    begin
      ActDBAdd.Enabled := False;
      ActDBEdit.Enabled := True;
      ActDBDelete.Enabled := True;
    end;

    PopupActReadComPort.Popup(Pos.X, Pos.Y);
  end;
end;

procedure TMain.OnWindowsHook(Sender: TObject; const HSHELL: NativeInt;
  const ApplicationData: TEXEVersionData);
var
  LItem: TListItem;
begin
  LItem := lvEventApplication.Items.Add;
  case HSHELL of
    HSHELL_WINDOWCREATED:
      begin
        LItem.Caption := 'WindowCreated';
        if (FSetting.Kodi.Using) and (ApplicationData.FileName = FSetting.Kodi.FileName) and
          not Assigned(FKodi) then
        begin
          FKodi := TKodi.Create(FSetting.Kodi.UpdateInterval, FSetting.Kodi.IP, FSetting.Kodi.Port,
            FSetting.Kodi.User, FSetting.Kodi.Password);

          FKodi.Priority := tpNormal;
          FKodi.OnRunning := onKodiRunning;
          FKodi.OnPlayer := onKodiPlayer;
          FKodi.OnPlayerState := onKodiPlayerState;
        end;
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
end;

procedure TMain.onAppRunning(Running: Boolean);
begin
  if Running then
    StatusBar.Panels[1].Text := GetLanguageText('SatusBarAppWorking', lngRus)
  else
    StatusBar.Panels[1].Text := GetLanguageText('SatusBarAppNotWorking', lngRus);
end;

procedure TMain.onComPortOpen(Sender: TObject);
begin
  ActComPortOpenClose.ImageIndex := 4;
  ActComPortOpenClose.Caption := GetLanguageText(Main.Name, 'ActComPortClose', lngRus);
  ActComPortOpen.Enabled := False;
  ActComPortSend.Enabled := True;
  ActComPortClose.Enabled := True;

  lvReadComPort.Items.Clear;
  StatusBar.Panels[0].Text := GetLanguageText('SatusBarComPortConnected', lngRus);

  { try
    if not Assigned(FDataBase) then
    FDataBase := TDataBase.Create(FSetting.DB.FileName);

    if not FDataBase.Connected then
    FDataBase.Connect;
    except
    on E: Exception do
    MessageDlg(E.Message, mtWarning, [mbOK], 0);
    end; }

end;

procedure TMain.onComPortClose(Sender: TObject);
begin
  ActComPortOpenClose.ImageIndex := 3;
  ActComPortOpenClose.Caption := GetLanguageText(Main.Name, 'ActComPortOpen', lngRus);
  ActComPortOpen.Enabled := True;
  ActComPortSend.Enabled := False;
  ActComPortClose.Enabled := False;

  StatusBar.Panels[0].Text := GetLanguageText('SatusBarComPortNotConnected', lngRus);

  { try
    if Assigned(FDataBase) and FDataBase.Connected then
    FDataBase.Disconnect;
    finally
    FreeAndNil(FDataBase);
    end; }

end;

procedure TMain.onComPortReadData(Sender: TObject; const Data: string);
var
  LItem: TListItem;
  RCommand: TRemoteCommand;
  PRCommand: PRemoteCommand;
begin
  LItem := lvReadComPort.Items.Add;
  LItem.Caption := IntToStr(lvReadComPort.Items.Count);
  LItem.SubItems.Add(Data);

  lvReadComPort.Selected := LItem;
  lvReadComPort.Items[lvReadComPort.Items.Count - 1].MakeVisible(True);

  { if FDataBase.Connected and FDataBase.CommandExists(Data, RCommand) then
    begin
    New(PRCommand);
    PRCommand^ := RCommand;
    LItem.Data := PRCommand;
    end; }

end;

procedure TMain.onKodiPlayer(Player: string);
var
  LItem: TListItem;
begin
  LItem := lvEventKodi.Items.Add;
  LItem.Caption := Player;
end;

procedure TMain.onKodiPlayerState(Player, State: string);
var
  LItem: TListItem;
begin
  LItem := lvEventKodi.Items.Add;
  LItem.Caption := Player;
  LItem.SubItems.Add(State);
end;

procedure TMain.onKodiRunning(Running: Boolean);
begin
  if Running then
    StatusBar.Panels[2].Text := GetLanguageText('SatusBarKodiWorking', lngRus)
  else
    StatusBar.Panels[2].Text := GetLanguageText('SatusBarKodiNotWorking', lngRus);
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
    IniFile.WriteInteger('Window', 'Splitter', Main.pComPort.Width);
  finally
    IniFile.Free;
  end;
end;

end.
