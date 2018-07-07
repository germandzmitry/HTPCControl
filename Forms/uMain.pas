unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnList, System.Win.Registry,
  Vcl.PlatformDefaultStyleActnCtrls, System.Actions, UCustomPageControl,
  System.ImageList, Vcl.ImgList, Winapi.shellApi, System.IniFiles, uEventApplication,
  uSettings;

type
  TMain = class(TForm)
    StatusBar: TStatusBar;
    pComPort: TPanel;
    Splitter: TSplitter;
    pClient: TPanel;
    mReadComPort: TMemo;
    ActionList: TActionList;
    ActHelpAbout: TAction;
    ilSmall: TImageList;
    ActToolsSetting: TAction;
    ActToolsDeviceManager: TAction;
    ActionManager: TActionManager;
    ActionToolBar: TActionToolBar;
    ListView1: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ActHelpAboutExecute(Sender: TObject);
    procedure ActToolsSettingExecute(Sender: TObject);
    procedure ActToolsDeviceManagerExecute(Sender: TObject);
  private
    { Private declarations }
    lvEventApplication: TListView;

    FEventApplication: TEventApplications;
    FSetting: TSetting;

    FPageClient: TCustomPageControl;

    procedure LoadWindowSetting();
    procedure SaveWindowSetting();

    procedure OnWindowsHook(Sender: TObject; const HSHELL: NativeInt;
      const ApplicationData: TEXEVersionData);
  public
    { Public declarations }
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

uses uAbout, uLanguage, uTypes;

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
  tabEventApplication: TTabSheet;
  LColumn: TListColumn;
  LItem: TListItem;

begin
  LoadWindowSetting;
  FSetting := uSettings.getSetting();

  Main.Caption := Application.Title;
  Main.mReadComPort.Align := alClient;

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
  end;
  SendMessage(FPageClient.Handle, WM_UPDATEUISTATE, MakeLong(UIS_SET, UISF_HIDEFOCUS), 0);
  CreateTab(FPageClient, 'TabRemoteControl');

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

  CreateTab(FPageClient, 'TabKodi');

  // События приложений
  FEventApplication := TEventApplications.Create(Main);
  FEventApplication.OnWindowsHook := OnWindowsHook;

  UpdateLanguage(self, lngRus);
end;

procedure TMain.FormShow(Sender: TObject);
begin
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
  SaveWindowSetting;

  lvEventApplication.Free;
  FPageClient.Free;
  FEventApplication.Free;
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

procedure TMain.OnWindowsHook(Sender: TObject; const HSHELL: NativeInt;
  const ApplicationData: TEXEVersionData);
var
  LItem: TListItem;
begin
  LItem := lvEventApplication.Items.Add;
  case HSHELL of
    HSHELL_WINDOWCREATED:
      LItem.Caption := 'WindowCreated';
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
