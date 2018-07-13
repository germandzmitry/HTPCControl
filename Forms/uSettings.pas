unit uSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.CheckLst, System.Win.Registry, System.IniFiles, Data.DB, Data.Win.ADODB,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdStack, uSuperObject,
  Vcl.Buttons, System.ImageList, Vcl.ImgList, ShellAPI;

type
  TApplication = Record
    AutoRun: boolean;
    AutoRunTray: boolean;
    AutoRunSetVolume: boolean;
    Volume: integer;
    TurnTray: boolean;
    CloseTray: boolean;
    procedure Default;
  End;

  TComPort = Record
    OpenRun: boolean;
    Port: string;
    Speed: integer;
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
    FileName: string;
    procedure Default;
  End;

  TKodi = Record
    FileName: string;
    Using: boolean;
    UpdateInterval: integer;
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
    gbKodiConnect: TGroupBox;
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
    btnApply: TButton;
    gbDBAccess: TGroupBox;
    edDBFileName: TEdit;
    lDBFilleName: TLabel;
    ilButton: TImageList;
    btnDBSelectFile: TButton;
    btnDBCreate: TButton;
    btnDBTestConnection: TButton;
    lDBTestConnection: TLabel;
    gbDBHelp: TGroupBox;
    llDBDriver1: TLinkLabel;
    llDBDriver2: TLinkLabel;
    cbKodiUsing: TCheckBox;
    gbKodi: TGroupBox;
    lKodiFileName: TLabel;
    edKodiFileName: TEdit;
    btnKodiSelectFile: TButton;
    lKodiUpdateInterval: TLabel;
    edKodiUpdateInterval: TEdit;
    udKodiUpdateInterval: TUpDown;
    cbApplicationAutoRunTray: TCheckBox;
    cbApplicationAutoRunSetVolume: TCheckBox;
    cbApplicationTurnTray: TCheckBox;
    cbApplicationCloseTray: TCheckBox;
    edApplicationAutoRunVolume: TEdit;
    udApplicationAutoRunVolume: TUpDown;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbEventAppicationUsingClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnKodiTestConnectClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnDBSelectFileClick(Sender: TObject);
    procedure btnDBTestConnectionClick(Sender: TObject);
    procedure llDBDriverClick(Sender: TObject);
    procedure btnDBCreateClick(Sender: TObject);
    procedure cbKodiUsingClick(Sender: TObject);
    procedure btnKodiSelectFileClick(Sender: TObject);
    procedure cbApplicationAutoRunClick(Sender: TObject);
    procedure cbApplicationAutoRunSetVolumeClick(Sender: TObject);
  private
    procedure saveSetting();
    procedure setAutorun(AutoRun: boolean);
  public
  end;

function getSetting(): TSetting;

var
  Settings: TSettings;

implementation

{$R *.dfm}

uses uLanguage, uTypes, uComPort, uDataBase;

function getSetting(): TSetting;
var
  IniFile: TIniFile;
  Reg: TRegistry;
begin
  Result.Default;

  IniFile := TIniFile.Create(ExtractFileDir(Application.ExeName) + '\' + FileSetting);
  try

    // Приложение
    Result.Application.AutoRun := IniFile.ReadBool('Application', 'AutoRun',
      Result.Application.AutoRun);
    Result.Application.AutoRunTray := IniFile.ReadBool('Application', 'AutoRunTray',
      Result.Application.AutoRunTray);
    Result.Application.AutoRunSetVolume := IniFile.ReadBool('Application', 'AutoRunSetVolume',
      Result.Application.AutoRunSetVolume);
    Result.Application.Volume := IniFile.ReadInteger('Application', 'Volume',
      Result.Application.Volume);
    Result.Application.TurnTray := IniFile.ReadBool('Application', 'TurnTray',
      Result.Application.TurnTray);
    Result.Application.CloseTray := IniFile.ReadBool('Application', 'CloseTray',
      Result.Application.CloseTray);

    // Com порт
    Result.ComPort.OpenRun := IniFile.ReadBool('Com', 'OpenRun', Result.ComPort.OpenRun);
    Result.ComPort.Port := IniFile.ReadString('Com', 'COM', Result.ComPort.Port);
    Result.ComPort.Speed := IniFile.ReadInteger('Com', 'Speed', Result.ComPort.Speed);

    // События приложений
    Result.EventApplication.Using := IniFile.ReadBool('EventApplication', 'Using',
      Result.EventApplication.Using);

    // База данных
    Result.DB.FileName := IniFile.ReadString('DB', 'FileName', Result.DB.FileName);

    // Kodi
    Result.Kodi.FileName := IniFile.ReadString('Kodi', 'FileName', Result.Kodi.FileName);
    Result.Kodi.Using := IniFile.ReadBool('Kodi', 'Using', Result.Kodi.Using);
    Result.Kodi.UpdateInterval := IniFile.ReadInteger('Kodi', 'UpdateInterval',
      Result.Kodi.UpdateInterval);
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
        Result.EventApplication.WINDOWCREATED := Reg.ReadBool('WINDOWCREATED');
      if Reg.ValueExists('WINDOWDESTROYED') then
        Result.EventApplication.WINDOWDESTROYED := Reg.ReadBool('WINDOWDESTROYED');
      if Reg.ValueExists('ACTIVATESHELLWINDOW') then
        Result.EventApplication.ACTIVATESHELLWINDOW := Reg.ReadBool('ACTIVATESHELLWINDOW');
      if Reg.ValueExists('WINDOWACTIVATED') then
        Result.EventApplication.WINDOWACTIVATED := Reg.ReadBool('WINDOWACTIVATED');
      if Reg.ValueExists('GETMINRECT') then
        Result.EventApplication.GETMINRECT := Reg.ReadBool('GETMINRECT');
      if Reg.ValueExists('REDRAW') then
        Result.EventApplication.REDRAW := Reg.ReadBool('REDRAW');
      if Reg.ValueExists('TASKMAN') then
        Result.EventApplication.TASKMAN := Reg.ReadBool('TASKMAN');
      if Reg.ValueExists('LANGUAGE') then
        Result.EventApplication.LANGUAGE := Reg.ReadBool('LANGUAGE');
      if Reg.ValueExists('ACCESSIBILITYSTATE') then
        Result.EventApplication.ACCESSIBILITYSTATE := Reg.ReadBool('ACCESSIBILITYSTATE');
      if Reg.ValueExists('APPCOMMAND') then
        Result.EventApplication.APPCOMMAND := Reg.ReadBool('APPCOMMAND');
      if Reg.ValueExists('WINDOWREPLACED') then
        Result.EventApplication.WINDOWREPLACED := Reg.ReadBool('WINDOWREPLACED');
    end;
  finally
    Reg.Free;
  end;
end;

{ TApplication }

procedure TApplication.Default;
begin
  self.AutoRun := false;
  self.AutoRunTray := false;
  self.AutoRunSetVolume := false;
  self.Volume := 10;
  self.TurnTray := false;
  self.CloseTray := false;
end;

{ TComPort }

procedure TComPort.Default;
begin
  self.OpenRun := false;
  self.Port := '';
  self.Speed := 9600;
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
  self.FileName := '';
end;

{ TKodi }

procedure TKodi.Default;
begin
  self.FileName := '';
  self.Using := false;
  self.UpdateInterval := 5;
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

  // чистим контролы
  for i := 0 to self.ComponentCount - 1 do
  begin
    // Label
    if self.Components[i] is TLabel then
      TLabel(self.Components[i]).Caption := '';
    // Edit
    if self.Components[i] is TEdit then
      TEdit(self.Components[i]).Text := '';
    // Button
    if self.Components[i] is TButton then
      TButton(self.Components[i]).Caption := '';
  end;

  cbComPortPort.Style := csDropDownList;
  cbComPortSpeed.Style := csDropDownList;

  EnumComPorts(cbComPortPort.Items);
  EnumComPortsSpeed(cbComPortSpeed.Items);

  UpdateLanguage(self, lngRus);

  pcSettings.ActivePageIndex := 0;

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
  cbApplicationAutoRunTray.Checked := LSetting.Application.AutoRunTray;
  cbApplicationAutoRunSetVolume.Checked := LSetting.Application.AutoRunSetVolume;
  udApplicationAutoRunVolume.Position := LSetting.Application.Volume;
  cbApplicationTurnTray.Checked := LSetting.Application.TurnTray;
  cbApplicationCloseTray.Checked := LSetting.Application.CloseTray;

  // Com порт
  cbComPortOpenRun.Checked := LSetting.ComPort.OpenRun;
  cbComPortPort.ItemIndex := cbComPortPort.Items.IndexOf(LSetting.ComPort.Port);
  cbComPortSpeed.ItemIndex := cbComPortSpeed.Items.IndexOf(IntToStr(LSetting.ComPort.Speed));

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

  // База данных
  edDBFileName.Text := LSetting.DB.FileName;

  // Kodi
  edKodiFileName.Text := LSetting.Kodi.FileName;
  cbKodiUsing.Checked := LSetting.Kodi.Using;
  udKodiUpdateInterval.Position := LSetting.Kodi.UpdateInterval;
  edKodiIP.Text := LSetting.Kodi.IP;
  edKodiPort.Text := IntToStr(LSetting.Kodi.Port);
  edKodiUser.Text := LSetting.Kodi.User;
  edKodiPassword.Text := LSetting.Kodi.Password;
end;

procedure TSettings.FormShow(Sender: TObject);
begin
  cbApplicationAutoRunClick(cbApplicationAutoRun);
  cbEventAppicationUsingClick(cbEventAppicationUsing);
  cbKodiUsingClick(cbKodiUsing);
end;

procedure TSettings.llDBDriverClick(Sender: TObject);
begin
  ShellExecute(self.handle, 'open', PCHAR(TLinkLabel(Sender).Hint), nil, nil, SW_SHOW);
end;

procedure TSettings.saveSetting;
var
  IniFile: TIniFile;
  Reg: TRegistry;
begin

  setAutorun(cbApplicationAutoRun.Checked);

  IniFile := TIniFile.Create(ExtractFileDir(Application.ExeName) + '\' + FileSetting);
  try

    // Приложение
    IniFile.WriteBool('Application', 'AutoRun', cbApplicationAutoRun.Checked);
    IniFile.WriteBool('Application', 'AutoRunTray', cbApplicationAutoRunTray.Checked);
    IniFile.WriteBool('Application', 'AutoRunSetVolume', cbApplicationAutoRunSetVolume.Checked);
    IniFile.WriteInteger('Application', 'Volume', udApplicationAutoRunVolume.Position);
    IniFile.WriteBool('Application', 'TurnTray', cbApplicationTurnTray.Checked);
    IniFile.WriteBool('Application', 'CloseTray', cbApplicationCloseTray.Checked);

    // Com порт
    IniFile.WriteBool('Com', 'OpenRun', cbComPortOpenRun.Checked);
    IniFile.WriteString('Com', 'COM', cbComPortPort.Text);
    IniFile.WriteInteger('Com', 'Speed', StrToInt(cbComPortSpeed.Text));

    // События приложений
    IniFile.WriteBool('EventApplication', 'Using', cbEventAppicationUsing.Checked);

    // База данных
    IniFile.WriteString('DB', 'FileName', edDBFileName.Text);

    // Kodi
    IniFile.WriteString('Kodi', 'FileName', edKodiFileName.Text);
    IniFile.WriteBool('Kodi', 'Using', cbKodiUsing.Checked);
    IniFile.WriteInteger('Kodi', 'UpdateInterval', udKodiUpdateInterval.Position);
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
    if Reg.OpenKey('\SOFTWARE\' + Application.Title, true) then
    begin
      Reg.WriteBool('WINDOWCREATED', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('WINDOWCREATED')]);
      Reg.WriteBool('WINDOWDESTROYED', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('WINDOWDESTROYED')]);
      Reg.WriteBool('ACTIVATESHELLWINDOW', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('ACTIVATESHELLWINDOW')]);
      Reg.WriteBool('WINDOWACTIVATED', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('WINDOWACTIVATED')]);
      Reg.WriteBool('GETMINRECT', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('GETMINRECT')]);
      Reg.WriteBool('REDRAW', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('REDRAW')]);
      Reg.WriteBool('TASKMAN', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('TASKMAN')]);
      Reg.WriteBool('LANGUAGE', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('LANGUAGE')]);
      Reg.WriteBool('ACCESSIBILITYSTATE', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('ACCESSIBILITYSTATE')]);
      Reg.WriteBool('APPCOMMAND', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('APPCOMMAND')]);
      Reg.WriteBool('WINDOWREPLACED', clbEventApplication.Checked
        [clbEventApplication.Items.IndexOf('WINDOWREPLACED')]);
    end;
  finally
    Reg.Free;
  end;
end;

procedure TSettings.setAutorun(AutoRun: boolean);
var
  Reg: TRegistry;
  AddPath: string;
begin
  if AutoRun then
  begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', false);
    Reg.WriteString(Application.Title, '"' + Application.ExeName + '" -autorun');
    Reg.Free;
  end
  else
  begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', false);
    Reg.DeleteValue(Application.Title);
    Reg.Free;
  end;
end;

procedure TSettings.cbApplicationAutoRunClick(Sender: TObject);
begin
  cbApplicationAutoRunTray.Enabled := cbApplicationAutoRun.Checked;
  cbApplicationAutoRunSetVolume.Enabled := cbApplicationAutoRun.Checked;
  edApplicationAutoRunVolume.Enabled := cbApplicationAutoRun.Checked;
  udApplicationAutoRunVolume.Enabled := cbApplicationAutoRun.Checked;

  if cbApplicationAutoRun.Checked then
    cbApplicationAutoRunSetVolumeClick(cbApplicationAutoRunSetVolume);
end;

procedure TSettings.cbApplicationAutoRunSetVolumeClick(Sender: TObject);
begin
  edApplicationAutoRunVolume.Enabled := cbApplicationAutoRunSetVolume.Checked;
  udApplicationAutoRunVolume.Enabled := cbApplicationAutoRunSetVolume.Checked;
end;

procedure TSettings.cbEventAppicationUsingClick(Sender: TObject);
begin
  clbEventApplication.Enabled := cbEventAppicationUsing.Checked;
end;

procedure TSettings.cbKodiUsingClick(Sender: TObject);
begin
  edKodiUpdateInterval.Enabled := cbKodiUsing.Checked;
  udKodiUpdateInterval.Enabled := cbKodiUsing.Checked;
  edKodiIP.Enabled := cbKodiUsing.Checked;
  edKodiPort.Enabled := cbKodiUsing.Checked;
  edKodiUser.Enabled := cbKodiUsing.Checked;
  edKodiPassword.Enabled := cbKodiUsing.Checked;
  btnKodiTestConnect.Enabled := cbKodiUsing.Checked;
end;

procedure TSettings.btnKodiSelectFileClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(self);
  try
    if FileExists(edKodiFileName.Text) then
      OpenDialog.InitialDir := ExtractFileDir(edKodiFileName.Text)
    else
      OpenDialog.InitialDir := ExtractFileDir(Application.ExeName);

    OpenDialog.Filter := 'Приложения|*.exe';

    if (OpenDialog.Execute) and (FileExists(OpenDialog.FileName)) then
      edKodiFileName.Text := OpenDialog.FileName;
  finally
    OpenDialog.Free;
  end;
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
  self.Close;
end;

procedure TSettings.btnApplyClick(Sender: TObject);
begin
  saveSetting;
end;

procedure TSettings.btnCloseClick(Sender: TObject);
begin
  self.Close;
end;

procedure TSettings.btnDBCreateClick(Sender: TObject);
var
  DBSaveDialog: TSaveDialog;
begin
  DBSaveDialog := TSaveDialog.Create(self);
  try
    DBSaveDialog.Filter := 'Базы данных Microsoft Access 2007-2013|*.accdb';
    DBSaveDialog.DefaultExt := '*.accdb';
    DBSaveDialog.FileName := 'db';
    DBSaveDialog.InitialDir := ExtractFilePath(Application.ExeName);

    if DBSaveDialog.Execute then
      try
        uDataBase.CreateDB(DBSaveDialog.FileName);
        edDBFileName.Text := DBSaveDialog.FileName;
      except
        on E: Exception do
          MessageDlg(E.Message, mtWarning, [mbOK], 0);
      end;

  finally
    DBSaveDialog.Free;
  end;
end;

procedure TSettings.btnDBSelectFileClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
  OpenDialog := TOpenDialog.Create(self);
  try
    if FileExists(edDBFileName.Text) then
      OpenDialog.InitialDir := ExtractFileDir(edDBFileName.Text)
    else
      OpenDialog.InitialDir := ExtractFileDir(Application.ExeName);

    OpenDialog.Filter :=
      'Базы данных Microsoft Access 2007-2013|*.accdb|Базы данных Microsoft Access 2003|*.mdb';

    if (OpenDialog.Execute) and (FileExists(OpenDialog.FileName)) then
      edDBFileName.Text := OpenDialog.FileName;
  finally
    OpenDialog.Free;
  end;
end;

procedure TSettings.btnDBTestConnectionClick(Sender: TObject);
var
  Con: TADOConnection;
begin
  lDBTestConnection.Caption := '';
  Con := TADOConnection.Create(nil);
  try
    Con.ConnectionString := 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=' + edDBFileName.Text +
      ';Persist Security Info=False';
    try
      Con.Connected := true;
      lDBTestConnection.Font.Color := clBlue;
      lDBTestConnection.Caption := 'Соединение успешно установлено.';
      Con.Connected := false;
    except
      on E: Exception do
      begin
        lDBTestConnection.Font.Color := clRed;
        lDBTestConnection.Caption := E.Message;
        // MessageDlg(E.Message, mtWarning, [mbOK], 0);
      end;
    end;
  finally
    Con.Free;
  end;
end;

end.
