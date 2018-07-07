unit uSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.CheckLst, System.Win.Registry, System.IniFiles, Data.DB, Data.Win.ADODB,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdStack, uSuperObject;

type
  TApplication = Record
    AutoRun: boolean;
    procedure Default;
  End;

  TComPort = Record
    procedure Default;
  End;

  TEventApplication = Record
    Using: boolean;
    WINDOWCREATED: boolean;
    WINDOWDESTROYED: boolean;
    ACTIVATESHELLWINDOW: boolean;
    WINDOWACTIVATED: boolean;
    GETMINRECT: boolean;
    REDRAW: boolean;
    TASKMAN: boolean;
    LANGUAGE: boolean;
    ACCESSIBILITYSTATE: boolean;
    APPCOMMAND: boolean;
    WINDOWREPLACED: boolean;
    procedure Default;
  End;

  TDB = Record
    procedure Default;
  End;

  TKodi = Record
    IP: string;
    Port: integer;
    User: string;
    Password: string;
    procedure Default;
  End;

  TSetting = Record
    Application: TApplication;
    ComPort: TComPort;
    EventApplication: TEventApplication;
    DB: TDB;
    Kodi: TKodi;
    procedure Default;
  End;

type
  TSettings = class(TForm)
    pcSettings: TPageControl;
    TabApplication: TTabSheet;
    TabComPort: TTabSheet;
    TabEventApplication: TTabSheet;
    TabDB: TTabSheet;
    TabKodi: TTabSheet;
    pButton: TPanel;
    btnClose: TButton;
    btnSave: TButton;
    gbAplication: TGroupBox;
    cbApplicationAutoRun: TCheckBox;
    gbEventApplication: TGroupBox;
    clbEventApplication: TCheckListBox;
    cbEventAppicationUsing: TCheckBox;
    gbMediaPlayer: TGroupBox;
    edKodiIP: TEdit;
    edKodiPort: TEdit;
    edKodiUser: TEdit;
    edKodiPassword: TEdit;
    lKodiHelp: TLabel;
    lKodiIP: TLabel;
    lKodiPort: TLabel;
    lKodiUser: TLabel;
    lKodiPassword: TLabel;
    btnKodiTestConnect: TButton;
    lKodiTestConnection: TLabel;
    gbComPort: TGroupBox;
    cbComPortPort: TComboBox;
    cbComPortSpeed: TComboBox;
    cbComPortOpenRun: TCheckBox;
    lComPortPort: TLabel;
    lComPortSpeed: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbEventAppicationUsingClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnKodiTestConnectClick(Sender: TObject);
  private
    procedure saveSetting();
  public
  end;

function getSetting(): TSetting;

var
  Settings: TSettings;

implementation

{$R *.dfm}

uses uLanguage, uTypes, uComPort;

function getSetting(): TSetting;
var
  IniFile: TIniFile;
  Reg: TRegistry;
begin
  Result.Default;

  IniFile := TIniFile.Create(ExtractFileDir(Application.ExeName) + '\' + FileSetting);
  try

    // // Com порт
    // FComPort := IniFile.ReadString('Com', 'COM', 'COM1');
    // FComRunOpen := IniFile.ReadBool('Com', 'RunOpenCom', false);
    // // Общие
    // FAutoRun := IniFile.ReadBool('General', 'AutoRun', false);
    // FAutoRunTray := IniFile.ReadBool('General', 'AutoRunTray', false);
    // FAutoRunSetVolume := IniFile.ReadBool('General', 'AutoRunSetVolume', false);
    // FAutoRunVolume := IniFile.ReadInteger('General', 'AutoRunVolume', 10);
    // FTurnTray := IniFile.ReadBool('General', 'TurnTray', false);
    // FCloseTray := IniFile.ReadBool('General', 'CloseTray', false);

    // События приложений
    Result.EventApplication.Using := IniFile.readBool('EventApplication', 'Using',
      Result.EventApplication.Using);

    // // База данных
    // FPathDB := IniFile.ReadString('DB', 'PathDB', '');

    // Kodi
    Result.Kodi.IP := IniFile.ReadString('Kodi', 'IP', Result.Kodi.IP);
    Result.Kodi.Port := IniFile.ReadInteger('Kodi', 'Port', Result.Kodi.Port);
    Result.Kodi.User := IniFile.ReadString('Kodi', 'User', Result.Kodi.User);
    Result.Kodi.Password := IniFile.ReadString('Kodi', 'Password', Result.Kodi.Password);

  finally
    IniFile.Free;
  end;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKeyReadOnly('\SOFTWARE\HTPCControl') then
    begin
      if Reg.ValueExists('WINDOWCREATED') then
        Result.EventApplication.WINDOWCREATED := Reg.readBool('WINDOWCREATED');
      if Reg.ValueExists('WINDOWDESTROYED') then
        Result.EventApplication.WINDOWDESTROYED := Reg.readBool('WINDOWDESTROYED');
      if Reg.ValueExists('ACTIVATESHELLWINDOW') then
        Result.EventApplication.ACTIVATESHELLWINDOW := Reg.readBool('ACTIVATESHELLWINDOW');
      if Reg.ValueExists('WINDOWACTIVATED') then
        Result.EventApplication.WINDOWACTIVATED := Reg.readBool('WINDOWACTIVATED');
      if Reg.ValueExists('GETMINRECT') then
        Result.EventApplication.GETMINRECT := Reg.readBool('GETMINRECT');
      if Reg.ValueExists('REDRAW') then
        Result.EventApplication.REDRAW := Reg.readBool('REDRAW');
      if Reg.ValueExists('TASKMAN') then
        Result.EventApplication.TASKMAN := Reg.readBool('TASKMAN');
      if Reg.ValueExists('LANGUAGE') then
        Result.EventApplication.LANGUAGE := Reg.readBool('LANGUAGE');
      if Reg.ValueExists('ACCESSIBILITYSTATE') then
        Result.EventApplication.ACCESSIBILITYSTATE := Reg.readBool('ACCESSIBILITYSTATE');
      if Reg.ValueExists('APPCOMMAND') then
        Result.EventApplication.APPCOMMAND := Reg.readBool('APPCOMMAND');
      if Reg.ValueExists('WINDOWREPLACED') then
        Result.EventApplication.WINDOWREPLACED := Reg.readBool('WINDOWREPLACED');
    end;
  finally
    Reg.Free;
  end;
end;

{ TApplication }

procedure TApplication.Default;
begin
  self.AutoRun := false;
end;

{ TComPort }

procedure TComPort.Default;
begin
  //
end;

{ TEventApplication }

procedure TEventApplication.Default;
begin
  self.Using := false;
  self.WINDOWCREATED := false;
  self.WINDOWDESTROYED := false;
  self.ACTIVATESHELLWINDOW := false;
  self.WINDOWACTIVATED := false;
  self.GETMINRECT := false;
  self.REDRAW := false;
  self.TASKMAN := false;
  self.LANGUAGE := false;
  self.ACCESSIBILITYSTATE := false;
  self.APPCOMMAND := false;
  self.WINDOWREPLACED := false;
end;

{ TDB }

procedure TDB.Default;
begin

end;

{ TKodi }

procedure TKodi.Default;
begin
  self.IP := '127.0.0.1';
  self.Port := 8080;
  self.User := 'kodi';
  self.Password := '';
end;

{ TSetting }

procedure TSetting.Default;
begin
  self.Application.Default;
  self.ComPort.Default;
  self.EventApplication.Default;
  self.DB.Default;
  self.Kodi.Default;
end;

{ TSettings }

procedure TSettings.FormCreate(Sender: TObject);
var
  LSetting: TSetting;
  i: integer;
begin

  // чистим все Label
  for i := 0 to self.ComponentCount - 1 do
  begin
    if self.Components[i] is TLabel then
      TLabel(self.Components[i]).Caption := '';
  end;

  cbComPortPort.Style := csDropDownList;
  cbComPortSpeed.Style := csDropDownList;

  EnumComPorts(cbComPortPort.Items);
  EnumComPortsSpeed(cbComPortSpeed.Items);

  UpdateLanguage(self, lngRus);

  pcSettings.ActivePageIndex := 1;

  with clbEventApplication do
  begin
    Items.Add('WINDOWCREATED');
    Items.Add('WINDOWDESTROYED');
    Items.Add('ACTIVATESHELLWINDOW');
    Items.Add('WINDOWACTIVATED');
    Items.Add('GETMINRECT');
    Items.Add('REDRAW');
    Items.Add('TASKMAN');
    Items.Add('LANGUAGE');
    Items.Add('ACCESSIBILITYSTATE');
    Items.Add('APPCOMMAND');
    Items.Add('WINDOWREPLACED');

    AllowGrayed := false;
    MultiSelect := true;
    Style := lbOwnerDrawFixed;
    ItemHeight := 17;
  end;

  LSetting := getSetting();

  // Приложение
  cbApplicationAutoRun.Checked := LSetting.Application.AutoRun;

  // ComPort

  // События приложений
  cbEventAppicationUsing.Checked := LSetting.EventApplication.Using;
  if LSetting.EventApplication.WINDOWCREATED then
    clbEventApplication.State[clbEventApplication.Items.IndexOf('WINDOWCREATED')] := cbChecked;
  if LSetting.EventApplication.WINDOWDESTROYED then
    clbEventApplication.State[clbEventApplication.Items.IndexOf('WINDOWDESTROYED')] := cbChecked;
  if LSetting.EventApplication.ACTIVATESHELLWINDOW then
    clbEventApplication.State[clbEventApplication.Items.IndexOf('ACTIVATESHELLWINDOW')] :=
      cbChecked;
  if LSetting.EventApplication.WINDOWACTIVATED then
    clbEventApplication.State[clbEventApplication.Items.IndexOf('WINDOWACTIVATED')] := cbChecked;
  if LSetting.EventApplication.GETMINRECT then
    clbEventApplication.State[clbEventApplication.Items.IndexOf('GETMINRECT')] := cbChecked;
  if LSetting.EventApplication.REDRAW then
    clbEventApplication.State[clbEventApplication.Items.IndexOf('REDRAW')] := cbChecked;
  if LSetting.EventApplication.TASKMAN then
    clbEventApplication.State[clbEventApplication.Items.IndexOf('TASKMAN')] := cbChecked;
  if LSetting.EventApplication.LANGUAGE then
    clbEventApplication.State[clbEventApplication.Items.IndexOf('LANGUAGE')] := cbChecked;
  if LSetting.EventApplication.ACCESSIBILITYSTATE then
    clbEventApplication.State[clbEventApplication.Items.IndexOf('ACCESSIBILITYSTATE')] := cbChecked;
  if LSetting.EventApplication.APPCOMMAND then
    clbEventApplication.State[clbEventApplication.Items.IndexOf('APPCOMMAND')] := cbChecked;
  if LSetting.EventApplication.WINDOWREPLACED then
    clbEventApplication.State[clbEventApplication.Items.IndexOf('WINDOWREPLACED')] := cbChecked;

  // Kodi
  edKodiIP.Text := LSetting.Kodi.IP;
  edKodiPort.Text := IntToStr(LSetting.Kodi.Port);
  edKodiUser.Text := LSetting.Kodi.User;
  edKodiPassword.Text := LSetting.Kodi.Password;
end;

procedure TSettings.FormShow(Sender: TObject);
begin
  cbEventAppicationUsingClick(cbEventAppicationUsing.Owner);
end;

procedure TSettings.saveSetting;
var
  IniFile: TIniFile;
  Reg: TRegistry;
begin
  IniFile := TIniFile.Create(ExtractFileDir(Application.ExeName) + '\' + FileSetting);
  try

    // События приложений
    IniFile.writeBool('EventApplication', 'Using', cbEventAppicationUsing.Checked);

    // Kodi
    IniFile.WriteString('Kodi', 'IP', edKodiIP.Text);
    IniFile.WriteInteger('Kodi', 'Port', StrToInt(edKodiPort.Text));
    IniFile.WriteString('Kodi', 'User', edKodiUser.Text);
    IniFile.WriteString('Kodi', 'Password', edKodiPassword.Text);

  finally
    IniFile.Free;
  end;

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\SOFTWARE\HTPCControl', true) then
    begin
      Reg.writeBool('WINDOWCREATED', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('WINDOWCREATED')]);
      Reg.writeBool('WINDOWDESTROYED', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('WINDOWDESTROYED')]);
      Reg.writeBool('ACTIVATESHELLWINDOW', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('ACTIVATESHELLWINDOW')]);
      Reg.writeBool('WINDOWACTIVATED', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('WINDOWACTIVATED')]);
      Reg.writeBool('GETMINRECT', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('GETMINRECT')]);
      Reg.writeBool('REDRAW', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('REDRAW')]);
      Reg.writeBool('TASKMAN', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('TASKMAN')]);
      Reg.writeBool('LANGUAGE', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('LANGUAGE')]);
      Reg.writeBool('ACCESSIBILITYSTATE', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('ACCESSIBILITYSTATE')]);
      Reg.writeBool('APPCOMMAND', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('APPCOMMAND')]);
      Reg.writeBool('WINDOWREPLACED', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('WINDOWREPLACED')]);
    end;
  finally
    Reg.Free;
  end;
end;

procedure TSettings.cbEventAppicationUsingClick(Sender: TObject);
begin
  clbEventApplication.Enabled := cbEventAppicationUsing.Checked;
end;

procedure TSettings.btnKodiTestConnectClick(Sender: TObject);
var
  http: TIdHTTP;
  LoginInfo: TStringList;
  M: TStringStream;
  obj, obj_r, obj_v: ISuperObject;
begin
  lKodiTestConnection.Caption := '';
  try
    http := TIdHTTP.Create(nil);
    http.HandleRedirects := true;
    http.ProtocolVersion := pv1_0;
    M := TStringStream.Create('');
    http.Get('http://' + edKodiIP.Text + ':' + edKodiPort.Text +
      '/jsonrpc?request={"jsonrpc":"2.0","method":"Application.GetProperties","params":{"properties":["name","version"]},"id":1}',
      M);
    obj := so(M.DataString);
    M.Free;
    http.Free;

    lKodiTestConnection.Font.Color := clBlue;

    obj_r := obj.O['result'];
    obj_v := obj_r.O['version'];
    lKodiTestConnection.Caption := obj_r.S['name'] + ' ' + IntToStr(obj_v.i['major']) + '.' +
      IntToStr(obj_v.i['minor']);
    if Length(obj_v.S['tag']) > 0 then
      lKodiTestConnection.Caption := lKodiTestConnection.Caption + ' - ' + obj_v.S['tag'] +
        obj_v.S['tagversion'];

  except
    on E: EIdSocketError do
    begin
      M.Free;
      http.Free;
      if E.LastError = 10061 then
      begin
        lKodiTestConnection.Font.Color := clRed;
        lKodiTestConnection.Caption :=
          'Не удалось установить соединение с приложением. Возможно, приложение не запущено.';
      end
      else
        MessageDlg(E.Message, mtWarning, [mbOK], 0);
    end;
    on E: Exception do
    begin
      M.Free;
      http.Free;
      MessageDlg(E.Message, mtWarning, [mbOK], 0);
    end;
  end;
end;

procedure TSettings.btnSaveClick(Sender: TObject);
begin
  saveSetting;
end;

procedure TSettings.btnCloseClick(Sender: TObject);
begin
  self.Close;
end;

end.
