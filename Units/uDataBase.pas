unit uDataBase;

interface

uses
  System.Variants, System.SysUtils, Data.DB, Data.Win.ADODB, System.Win.ComObj,
  uLanguage, uTypes;

const
  tcApplication = 'A';
  tcKeyboard = 'K';

type

  TKeyKeyboard = record
    Key: integer;
    Desc: String[255];
    Group: integer;
  end;

  PKeyKeyboard = ^TKeyKeyboard;
  TKeyboards = array of TKeyKeyboard;

  TRemoteCommand = record
    Command: string[100];
    Desc: string[255];
    RepeatPreview: boolean;
  end;

  PRemoteCommand = ^TRemoteCommand;

  TVCommand = Record
    Command: string[100];
    Desc: string[255];
    OId: string;
    Operation: string;
    ORepeat: boolean;
    ODescription: string;
    OGroup: integer;
  End;

  TVCommands = array of TVCommand;

  TECommand = Record
    Command: TRemoteCommand;
    ECType: TecType;
    Operation: string;
    Application: string[255];
    Key1: integer;
    Key2: integer;
    Rep: boolean;
  End;

  PECommand = ^TECommand;
  TECommands = array of TECommand;

  TEPCommand = record
    ECommand: TECommand;
    RepeatPreview: boolean;
  end;

  PEPCommand = ^TEPCommand;

  TKeyboardGroup = Record
    Group: integer;
    Descciption: string;
  End;

  TKeyboardGroups = array of TKeyboardGroup;

type
  TDataBase = class
    procedure Connect;
    procedure Disconnect;

    function CommandExists(const ACommand: string; var Command: TRemoteCommand): boolean;
    function GetCommand(const Command: string): TRemoteCommand;
    procedure DeleteCommand(const Command: string);

    function GetVCommands(const Command: string = ''): TVCommands;

    function GetExecuteCommands(const Command: string): TECommands;

    function GetKeyboardKey(Key: integer): PKeyKeyboard;
    function GetKeyboards(): TKeyboards;
    function GetKeyboardGroups(): TKeyboardGroups;

    procedure CreateRunApplication(const RCommand: TRemoteCommand; AppFileName: string);
    procedure UpdateRunApplication(const RCommand: TRemoteCommand; AppFileName: string);

    procedure CreatePressKeyKeyboard(const RCommand: TRemoteCommand; Key1, Key2: integer;
      ARepeat: boolean);
    procedure UpdatePressKeyKeyboard(const RCommand: TRemoteCommand; Key1, Key2: integer;
      ARepeat: boolean);

    function CreateRemoteCommand(const Command, Description: string;
      const ARepeat: boolean = false): string;
    function UpdateRemoteCommand(const Command, Description: string;
      const ARepeat: boolean = false): string;

  private
    FConnection: TADOConnection;
    FFileName: string;

    function GetConnected: boolean;
  public
    constructor Create; overload;
    constructor Create(FileName: string); overload;
    destructor Destroy; override;

    property Connected: boolean read GetConnected;
  end;

procedure CreateDB(FileName: string);

implementation

procedure CreateDB(FileName: string);

  procedure addKeybordGroup(Query: TADOQuery; Group: integer; Description: string);
  begin
    Query.Sql.Text := 'insert into KeyboardGroup([group], [description]) values (' + IntToStr(Group)
      + ', ' + '''' + Description + ''')';
    Query.ExecSQL;
  end;

  procedure addKeybord(Query: TADOQuery; Key: integer; Description: string; Group: integer);
  begin
    Query.Sql.Text := 'insert into Keyboard([key], [description], [group]) values (' + IntToStr(Key)
      + ', ' + '''' + Description + ''', ' + IntToStr(Group) + ')';
    Query.ExecSQL;
  end;

var
  Access: Variant;
  Connection: TADOConnection;
  Query: TADOQuery;
begin
  if FileExists(FileName) then
    raise Exception.Create(Format(GetLanguageMsg('msgDBFileNameExists', lngRus), [FileName]));

  // Создаем файл бд
  try
    Access := CreateOleObject('ADOX.Catalog');
    Access.Create('Provider=Microsoft.ACE.OLEDB.12.0; Data Source=' + FileName + ';');
    Access := Unassigned;
  except
    Access := Unassigned;
    raise;
  end;

  try
    // конектимся к новой бд
    Connection := TADOConnection.Create(nil);
    Connection.ConnectionString := 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=' + FileName +
      ';Persist Security Info=False';
    Connection.Connected := True;

    {
      Создаем таблицы
    }
    Query := TADOQuery.Create(nil);
    Query.Connection := Connection;

    // Справочник - Группы клавиатуры
    Query.Sql.Text :=
      'CREATE TABLE KeyboardGroup(                                                   ' +
      '  [group] integer primary key,                                                ' +
      '  [description] string (255))';
    Query.ExecSQL;

    // Справочник - Клавиатура
    Query.Sql.Text :=
      'CREATE TABLE Keyboard(                                                        ' +
      '  [key] integer primary key,                                                  ' +
      '  [description] string (255),                                                 ' +
      '  [group] integer references KeyboardGroup([group]))';
    Query.ExecSQL;

    // Справочник - Кнопки пульта
    Query.Sql.Text :=
      'CREATE TABLE RemoteCommand(                                                   ' +
      '  [command] string(100) primary key,                                          ' +
      '  [description] string(255),                                                  ' +
      '  [repeat] bit)';
    Query.ExecSQL;

    // Запуск приложений
    Query.Sql.Text :=
      'CREATE TABLE RunApplication(                                                  ' +
      '  [id] counter primary key,                                                   ' +
      '  [command] string(100) references RemoteCommand([command]) on delete cascade,' +
      '  [application] string(255),                                                  ' +
      '  [description] string(255))';
    Query.ExecSQL;

    // Запуск приложений
    Query.Sql.Text :=
      'CREATE TABLE PressKeyKeyboard(                                                ' +
      '  [id] counter primary key,                                                   ' +
      '  [command] string(100) references RemoteCommand([command]) on delete cascade,' +
      '  [key1] integer default null references Keyboard([key]),                     ' +
      '  [key2] integer default null references Keyboard([key]),                     ' +
      '  [repeat] bit,                                                               ' +
      '  [for_application] string(255),                                              ' +
      '  [description] string(255))';
    Query.ExecSQL;

    addKeybordGroup(Query, 0, 'Функциональные клавиши');
    addKeybord(Query, 112, 'F1', 0);
    addKeybord(Query, 113, 'F2', 0);
    addKeybord(Query, 114, 'F3', 0);
    addKeybord(Query, 115, 'F4', 0);
    addKeybord(Query, 116, 'F5', 0);
    addKeybord(Query, 117, 'F6', 0);
    addKeybord(Query, 118, 'F7', 0);
    addKeybord(Query, 119, 'F8', 0);
    addKeybord(Query, 120, 'F9', 0);
    addKeybord(Query, 121, 'F10', 0);
    addKeybord(Query, 122, 'F11', 0);
    addKeybord(Query, 123, 'F12', 0);

    addKeybordGroup(Query, 1, 'Управляющие клавишы');
    addKeybord(Query, 27, 'Esc', 1);
    addKeybord(Query, 17, 'Ctrl', 1);
    addKeybord(Query, 18, 'Alt', 1);
    addKeybord(Query, 91, 'Win', 1);
    addKeybord(Query, 93, 'Доп. меню', 1);
    addKeybord(Query, 145, 'ScrollLock', 1);
    addKeybord(Query, 44, 'PrintScreen', 1);

    addKeybordGroup(Query, 2, 'Клавиши для ввода данных (буквенно-цифровые)');
    addKeybord(Query, 8, 'BackSpace', 2);
    addKeybord(Query, 9, 'Tab', 2);
    addKeybord(Query, 13, 'Enter', 2);
    addKeybord(Query, 16, 'Shift', 2);
    addKeybord(Query, 20, 'CapsLock', 2);
    addKeybord(Query, 32, 'Пробел', 2);
    addKeybord(Query, 48, '0', 2);
    addKeybord(Query, 49, '1', 2);
    addKeybord(Query, 50, '2', 2);
    addKeybord(Query, 51, '3', 2);
    addKeybord(Query, 52, '4', 2);
    addKeybord(Query, 53, '5', 2);
    addKeybord(Query, 54, '6', 2);
    addKeybord(Query, 55, '7', 2);
    addKeybord(Query, 56, '8', 2);
    addKeybord(Query, 57, '9', 2);
    addKeybord(Query, 65, 'A', 2);
    addKeybord(Query, 66, 'B', 2);
    addKeybord(Query, 67, 'C', 2);
    addKeybord(Query, 68, 'D', 2);
    addKeybord(Query, 69, 'E', 2);
    addKeybord(Query, 70, 'F', 2);
    addKeybord(Query, 71, 'G', 2);
    addKeybord(Query, 72, 'H', 2);
    addKeybord(Query, 73, 'I', 2);
    addKeybord(Query, 74, 'J', 2);
    addKeybord(Query, 75, 'K', 2);
    addKeybord(Query, 76, 'L', 2);
    addKeybord(Query, 77, 'M', 2);
    addKeybord(Query, 78, 'N', 2);
    addKeybord(Query, 79, 'O', 2);
    addKeybord(Query, 80, 'P', 2);
    addKeybord(Query, 81, 'Q', 2);
    addKeybord(Query, 82, 'R', 2);
    addKeybord(Query, 83, 'S', 2);
    addKeybord(Query, 84, 'T', 2);
    addKeybord(Query, 85, 'U', 2);
    addKeybord(Query, 86, 'V', 2);
    addKeybord(Query, 87, 'W', 2);
    addKeybord(Query, 88, 'X', 2);
    addKeybord(Query, 89, 'Y', 2);
    addKeybord(Query, 90, 'Z', 2);
    addKeybord(Query, 186, ';', 2);
    addKeybord(Query, 187, '=', 2);
    addKeybord(Query, 188, ',', 2);
    addKeybord(Query, 189, '-', 2);
    addKeybord(Query, 190, '.', 2);
    addKeybord(Query, 191, '/', 2);
    addKeybord(Query, 192, '`', 2);
    addKeybord(Query, 219, '[', 2);
    addKeybord(Query, 220, '\', 2);
    addKeybord(Query, 221, ']', 2);
    addKeybord(Query, 222, '''''', 2);

    addKeybordGroup(Query, 3, 'Цифровая клавиатура');
    addKeybord(Query, 144, 'NumLock', 3);

    addKeybordGroup(Query, 4, 'Клавиши перемещения');
    addKeybord(Query, 33, 'PageUp', 4);
    addKeybord(Query, 34, 'PageDown', 4);
    addKeybord(Query, 35, 'End', 4);
    addKeybord(Query, 36, 'Home', 4);
    addKeybord(Query, 45, 'Insert', 4);
    addKeybord(Query, 46, 'Delete', 4);
    addKeybord(Query, 37, 'Стрелка назад', 4);
    addKeybord(Query, 38, 'Стрелка вверх', 4);
    addKeybord(Query, 39, 'Стрелка вперед', 4);
    addKeybord(Query, 40, 'Стрелка вниз', 4);

    addKeybordGroup(Query, 6, 'Мультимедиа');
    addKeybord(Query, 173, 'Звук - безвучно', 6);
    addKeybord(Query, 174, 'Звук - уменьшить', 6);
    addKeybord(Query, 175, 'Звук - увеличить', 6);
    addKeybord(Query, 176, 'Слудующий трек', 6);
    addKeybord(Query, 177, 'Предыдущий трек', 6);
    addKeybord(Query, 178, 'Стоп', 6);
    addKeybord(Query, 179, 'Играть/Пауза', 6);

    addKeybordGroup(Query, 9, 'Запуск приложений');

    Connection.Connected := false;
    Query.Free;
    Connection.Free;
  except
    Connection.Connected := false;
    Query.Free;
    Connection.Free;
    raise;
  end;
end;

{ TDataBase }

constructor TDataBase.Create;
begin
  FConnection := TADOConnection.Create(nil);
  FFileName := '';
end;

constructor TDataBase.Create(FileName: string);
begin
  Create;

  if FileExists(FileName) then
    FFileName := FileName;
end;

procedure TDataBase.CreatePressKeyKeyboard(const RCommand: TRemoteCommand; Key1, Key2: integer;
  ARepeat: boolean);
var
  Query: TADOQuery;
  LCommand, sKey1, sKey2: string;
begin
  if not FConnection.Connected then
    exit;

  sKey1 := 'null';
  sKey2 := 'null';

  if Key1 > 0 then
    sKey1 := IntToStr(Key1);
  if Key2 > 0 then
    sKey2 := IntToStr(Key2);

  LCommand := CreateRemoteCommand(RCommand.Command, RCommand.Desc);

  try
    // Создание запуска приложения
    Query := TADOQuery.Create(nil);
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'insert into PressKeyKeyboard (command, key1, key2, repeat) values ("' +
      RCommand.Command + '", ' + sKey1 + ', ' + sKey2 + ', ' + BoolToStr(ARepeat) + ')';
    Query.ExecSQL;

  finally
    Query.Free;
  end;
end;

procedure TDataBase.UpdatePressKeyKeyboard(const RCommand: TRemoteCommand; Key1, Key2: integer;
  ARepeat: boolean);
var
  Query: TADOQuery;
  LCommand, sKey1, sKey2: string;
begin
  if not FConnection.Connected then
    exit;

  sKey1 := 'null';
  sKey2 := 'null';

  if Key1 > 0 then
    sKey1 := IntToStr(Key1);
  if Key2 > 0 then
    sKey2 := IntToStr(Key2);

  LCommand := UpdateRemoteCommand(RCommand.Command, RCommand.Desc);

  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'update PressKeyKeyboard set key1 = ' + sKey1 + ',  key2 = ' + sKey2 +
      ', repeat = ' + BoolToStr(ARepeat) + ' where command = ' + QuotedStr(LCommand);
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

function TDataBase.CreateRemoteCommand(const Command, Description: string;
  const ARepeat: boolean = false): string;
var
  Query: TADOQuery;
  RCommand: TRemoteCommand;
begin
  Result := '';
  if not FConnection.Connected then
    exit;

  // проверка существования команды
  if CommandExists(Command, RCommand) then
  begin
    Result := RCommand.Command;
    exit;
  end;

  // Создание команды
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'insert into RemoteCommand (command, description, repeat) values ("' + Command
      + '", "' + Description + '", ' + BoolToStr(ARepeat) + ')';
    Query.ExecSQL;

    Result := Command;
  finally
    Query.Free;
  end;
end;

function TDataBase.UpdateRemoteCommand(const Command, Description: string;
  const ARepeat: boolean = false): string;
var
  Query: TADOQuery;
  RCommand: TRemoteCommand;
begin
  Result := '';
  if not FConnection.Connected then
    exit;

  // проверка существования команды
  if not CommandExists(Command, RCommand) then
  begin
    raise Exception.Create(Format(GetLanguageMsg('msgDBRemoteCommandNotFound', lngRus), [Command]));
  end;

  // Изменение команды
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'update RemoteCommand set description = "' + Description + '",' + 'repeat = '
      + BoolToStr(ARepeat) + ' where command = "' + Command + '"';
    Query.ExecSQL;

    Result := Command;
  finally
    Query.Free;
  end;
end;

procedure TDataBase.CreateRunApplication(const RCommand: TRemoteCommand; AppFileName: string);
var
  Query: TADOQuery;
  LCommand: string;
begin
  if not FConnection.Connected then
    exit;

  if not FileExists(AppFileName) then
    raise Exception.Create(Format(GetLanguageMsg('msgDBRunApplicationFileNotFound', lngRus),
      [AppFileName]));

  LCommand := CreateRemoteCommand(RCommand.Command, RCommand.Desc);

  // Создание запуска приложения
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'insert into RunApplication (command, application) values ("' +
      RCommand.Command + '", "' + AppFileName + '")';
    Query.ExecSQL;

  finally
    Query.Free;
  end;

end;

procedure TDataBase.UpdateRunApplication(const RCommand: TRemoteCommand; AppFileName: string);
var
  Query: TADOQuery;
  LCommand: string;
begin
  if not FConnection.Connected then
    exit;

  if not FileExists(AppFileName) then
    raise Exception.Create(Format(GetLanguageMsg('msgDBRunApplicationFileNotFound', lngRus),
      [AppFileName]));

  LCommand := UpdateRemoteCommand(RCommand.Command, RCommand.Desc);

  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'update RunApplication set application = "' + AppFileName +
      '" where command= "' + LCommand + '"';
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

destructor TDataBase.Destroy;
begin
  if FConnection.Connected then
    Disconnect;
  FConnection.Free;

  inherited;
end;

procedure TDataBase.Connect;
begin
  if not FConnection.Connected then
  begin
    try
      FConnection.ConnectionString := 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=' + FFileName +
        ';Persist Security Info=False';
      FConnection.Open;
    except
      raise;
    end;
  end;
end;

procedure TDataBase.Disconnect;
begin
  if FConnection.Connected then
    FConnection.Close;
end;

function TDataBase.GetConnected: boolean;
begin
  Result := FConnection.Connected;
end;

function TDataBase.GetKeyboardGroups: TKeyboardGroups;
var
  Query: TADOQuery;
  KeyboardGroups: TKeyboardGroups;
begin

  if not FConnection.Connected then
    exit;

  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'select group, description from KeyboardGroup';
    Query.ExecSQL;
    Query.Active := True;
    Query.First;
    while not Query.Eof do
    begin
      SetLength(KeyboardGroups, Length(KeyboardGroups) + 1);
      KeyboardGroups[Query.RecNo - 1].Group := Query.FieldByName('group').AsInteger;
      KeyboardGroups[Query.RecNo - 1].Descciption := Query.FieldByName('description').AsString;
      Query.Next;
    end;
    Result := KeyboardGroups;
  finally
    Query.Active := false;
    Query.Free;
  end;
end;

function TDataBase.GetKeyboardKey(Key: integer): PKeyKeyboard;
var
  Query: TADOQuery;
begin
  Result := nil;
  if not FConnection.Connected then
    exit;

  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'SELECT Key, description, group from Keyboard where key = ' + IntToStr(Key);
    Query.ExecSQL;
    Query.Active := True;
    if Query.RecordCount > 0 then
    begin
      Query.First;
      new(Result);
      Result.Key := Query.FieldByName('Key').AsInteger;
      Result.Desc := Query.FieldByName('description').AsString;
      Result.Group := Query.FieldByName('group').AsInteger;
    end;
  finally
    Query.Active := false;
    Query.Free;
  end;
end;

function TDataBase.GetKeyboards: TKeyboards;
var
  Query: TADOQuery;
  Keyboards: TKeyboards;
begin
  Result := nil;

  if not FConnection.Connected then
    exit;

  try
    Query := TADOQuery.Create(nil);
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'select key, description, group from Keyboard';
    Query.ExecSQL;
    Query.Active := True;
    Query.First;
    while not Query.Eof do
    begin
      SetLength(Keyboards, Length(Keyboards) + 1);
      Keyboards[Query.RecNo - 1].Key := Query.FieldByName('key').AsInteger;
      Keyboards[Query.RecNo - 1].Desc := Query.FieldByName('description').AsString;
      Keyboards[Query.RecNo - 1].Group := Query.FieldByName('group').AsInteger;
      Query.Next;
    end;
    Result := Keyboards;
  finally
    Query.Active := false;
    Query.Free;
  end;
end;

function TDataBase.GetVCommands(const Command: string = ''): TVCommands;
var
  Query: TADOQuery;
  ResVCommands: TVCommands;
begin
  Result := nil;

  if not FConnection.Connected then
    exit;

  try
    Query := TADOQuery.Create(nil);
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text :=
      'select rc.command,                                                           ' +
      '       rc.description,                                                       ' +
      '       em.id, em.operation, em.repeat, em.grp                                ' +
      '  from remotecommand as rc                                                   ' +
      '  left join(                                                                 ' +
      '    select "' + tcKeyboard + '" & pk.id as id,                               ' +
      '           pk.command as command,                                            ' +
      '           k1.description                                                    ' +
      '            & IIF(isNull(pk.key2), "", " + " &  k2.description) as operation,' +
      '           pk.repeat as repeat,                                              ' +
      '           k1.group as grp                                                   ' +
      '      from (                                                                 ' +
      '        PressKeyKeyboard as pk                                               ' +
      '          inner join keyboard as k1 on k1.key = pk.key1                      ' +
      '      )                                                                      ' +
      '    left join keyboard as k2 on k2.key = pk.key2                             ' +
      '    union all                                                                ' +
      '    select "' + tcApplication + '" & ra.id as id,                            ' +
      '           ra.command as command,                                            ' +
      '           ra.application as operation,                                      ' +
      '           null as repeat,                                                   ' +
      '           9 as grp                                                          ' +
      '      from runapplication AS ra                                              ' +
      '  ) as em on rc.command = em.command';

    if Length(trim(Command)) > 0 then
    begin
      Query.Sql.Text := Query.Sql.Text + ' where rc.command = "' + Command + '"';
    end;
    Query.Sql.Text := Query.Sql.Text + ' order by rc.command';
    Query.ExecSQL;
    Query.Active := True;
    Query.First;
    while not Query.Eof do
    begin
      SetLength(ResVCommands, Length(ResVCommands) + 1);
      ResVCommands[Query.RecNo - 1].Command := Query.FieldByName('command').AsString;
      ResVCommands[Query.RecNo - 1].Desc := Query.FieldByName('description').AsString;
      ResVCommands[Query.RecNo - 1].OId := Query.FieldByName('id').AsString;
      ResVCommands[Query.RecNo - 1].Operation := Query.FieldByName('operation').AsString;
      ResVCommands[Query.RecNo - 1].ORepeat := Query.FieldByName('repeat').AsBoolean;
      ResVCommands[Query.RecNo - 1].OGroup := Query.FieldByName('grp').AsInteger;
      Query.Next;
    end;
    Result := ResVCommands;
  finally
    Query.Active := false;
    Query.Free;
  end;
end;

function TDataBase.GetExecuteCommands(const Command: string): TECommands;
var
  Query: TADOQuery;
  ResECommands: TECommands;
begin
  Result := nil;

  if not FConnection.Connected then
    exit;

  try
    Query := TADOQuery.Create(nil);
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'select * from (                                              ' +
      '    select rc.command,                                                       ' +
      '           rc.description,                                                   ' +
      '           rc.repeat as rcrepeat,                                            ' +
      '           "' + tcKeyboard + '" as type,                                     ' +
      '           null as application,                                              ' +
      '           pk.key1 as key1,                                                  ' +
      '           pk.key2 as key2,                                                  ' +
      '           pk.repeat as repeat,                                              ' +
      '           opk2.operation as operation                                       ' +
      '      from (                                                                 ' +
      '        remotecommand as rc                                                  ' +
      '          inner join pressKeyKeyboard as pk on pk.command = rc.command       ' +
      '      )                                                                      ' +
      '      inner join (                                                           ' +
      '                  select opk.command as command,                             ' +
      '                         k1.description & IIF(isNull(opk.key2),              ' +
      '                                               "",                           ' +
      '                                               " + " &  k2.description       ' +
      '                                             ) as operation                  ' +
      '                    from (                                                   ' +
      '                      PressKeyKeyboard as opk                                ' +
      '                        inner join keyboard as k1 on k1.key = opk.key1       ' +
      '                    )                                                        ' +
      '                    left join keyboard as k2 on k2.key = opk.key2            ' +
      '                 ) as opk2 on opk2.command = rc.command                      ' +
      '    union all                                                                ' +
      '    select rc.command,                                                       ' +
      '           rc.description,                                                   ' +
      '           rc.repeat as rcrepeat,                                            ' +
      '           "' + tcApplication + '" as type,                                  ' +
      '           ra.application,                                                   ' +
      '           null as key1,                                                     ' +
      '           null as key2,                                                     ' +
      '           null as repeat,                                                   ' +
      '           ra.application as operation                                       ' +
      '      from remotecommand as rc                                               ' +
      '      inner join runapplication as ra on ra.command = rc.command             ' +
      ')                                                                            ' +
      'where command = "' + Command + '"';

    Query.ExecSQL;
    Query.Active := True;
    Query.First;
    while not Query.Eof do
    begin
      SetLength(ResECommands, Length(ResECommands) + 1);
      ResECommands[Query.RecNo - 1].Command.Command := Query.FieldByName('command').AsString;
      ResECommands[Query.RecNo - 1].Command.Desc := Query.FieldByName('description').AsString;
      ResECommands[Query.RecNo - 1].Command.RepeatPreview := Query.FieldByName('rcrepeat')
        .AsBoolean;
      if Query.FieldByName('type').AsString = tcApplication then
        ResECommands[Query.RecNo - 1].ECType := ecApplication
      else if Query.FieldByName('type').AsString = tcKeyboard then
        ResECommands[Query.RecNo - 1].ECType := ecKyeboard;
      ResECommands[Query.RecNo - 1].Application := Query.FieldByName('application').AsString;
      ResECommands[Query.RecNo - 1].Key1 := Query.FieldByName('key1').AsInteger;
      ResECommands[Query.RecNo - 1].Key2 := Query.FieldByName('key2').AsInteger;
      ResECommands[Query.RecNo - 1].Rep := Query.FieldByName('repeat').AsBoolean;
      ResECommands[Query.RecNo - 1].Operation := Query.FieldByName('operation').AsString;
      Query.Next;
    end;
    Result := ResECommands;
  finally
    Query.Active := false;
    Query.Free;
  end;
end;

function TDataBase.CommandExists(const ACommand: string; var Command: TRemoteCommand): boolean;
var
  Query: TADOQuery;
  LCommand: String;
begin
  Result := false;
  if not FConnection.Connected then
    exit;

  LCommand := ACommand;

  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'select command, description, repeat from RemoteCommand where command = "' +
      ACommand + '"';
    Query.ExecSQL;
    Query.Active := True;
    if Query.RecordCount > 0 then
    begin
      Query.First;

      Result := True;
      Command.Command := Query.FieldByName('command').AsString;
      Command.Desc := Query.FieldByName('description').AsString;
      Command.RepeatPreview := Query.FieldByName('repeat').AsBoolean;
    end;
  finally
    Query.Active := false;
    Query.Free;
  end;
end;

function TDataBase.GetCommand(const Command: string): TRemoteCommand;
var
  RCommand: TRemoteCommand;
begin
  if CommandExists(Command, RCommand) then
    Result := RCommand;
end;

procedure TDataBase.DeleteCommand(const Command: string);
var
  Query: TADOQuery;
  RCommand: TRemoteCommand;
begin
  if not FConnection.Connected then
    exit;

  // проверка существования команды
  if not CommandExists(Command, RCommand) then
  begin
    raise Exception.Create(Format(GetLanguageMsg('msgDBRemoteCommandNotFound', lngRus), [Command]));
  end;

  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'delete from RemoteCommand where command = "' + Command + '"';
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

end.
