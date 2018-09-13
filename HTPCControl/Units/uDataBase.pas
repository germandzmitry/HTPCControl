unit uDataBase;

interface

uses
  System.Variants, System.SysUtils, Data.DB, Data.Win.ADODB, System.Win.ComObj,
  uLanguage, uTypes, Winapi.Windows, System.UITypes;

const
  tcApplication = 'A';
  tcKeyboard = 'K';

type
  // Таблица KeyboardGroup
  TKeyboardGroup = Record
    Group: integer;
    Description: string[255];
  end;

  TKeyboardGroups = array of TKeyboardGroup;

  // Таблица Keyboard
  TKeyboard = record
    Key: integer;
    Desc: String[255];
    Group: integer;
  end;

  PKeyboard = ^TKeyboard;
  TKeyboards = array of TKeyboard;

  // Таблица RemoteCommand
  TRemoteCommand = record
    Command: string[100];
    Desc: string[255];
    LongPress: boolean;
    RepeatPrevious: boolean;
  end;

  PRemoteCommand = ^TRemoteCommand;
  TRemoteCommands = array of TRemoteCommand;

  // Таблица OperationRunApplication
  TORunApplication = record
    id: integer;
    Command: string[100];
    pSort: integer;
    Wait: integer;
    Application: string[255];
  end;

  // Таблица OperationPressKeyboard
  TOPressKeyboard = record
    id: integer;
    Command: string[100];
    pSort: integer;
    Wait: integer;
    Key1: integer;
    Key2: integer;
    Key3: integer;
    ForApplication: string[255];
  end;

  // Все операции для команды
  TOperation = Record
    Command: string[100];
    OSort: integer;
    OWait: integer;
    OType: TopType;
    Operation: string;
    PressKeyboard: TOPressKeyboard;
    RunApplication: TORunApplication;
  End;

  POperation = ^TOperation;
  TOperations = array of TOperation;

type
  TDataBase = class
    procedure Connect;
    procedure Disconnect;

    function getKeyboardGroups(): TKeyboardGroups;

    function GetKeyboards(): TKeyboards;
    function GetKeyboard(Key: integer): TKeyboard;

    function GetRemoteCommand(const Command: string): TRemoteCommand;
    function GetRemoteCommands(): TRemoteCommands;
    function RemoteCommandExists(const Command: string): boolean; overload;
    function RemoteCommandExists(const Command: string; var RCommand: TRemoteCommand)
      : boolean; overload;

    function CreateRemoteCommand(const Command, Description: string;
      const RepeatPrevious, LongPress: boolean): string; overload;
    function CreateRemoteCommand(const Command, Description: string;
      const RepeatPrevious, LongPress: boolean; var Exists: boolean): string; overload;
    function UpdateRemoteCommand(const Command, Description: string;
      const RepeatPrevious, LongPress: boolean): string;
    procedure DeleteRemoteCommand(const Command: string);

    procedure CreateRunApplication(const Command: string; const pSort, Wait: integer;
      const AppFileName: string);
    procedure UpdateRunApplication(const id, pSort, Wait: integer; const AppFileName: string);
    procedure DeleteRunApplication(const id: integer);

    procedure CreatePressKeyboard(const Command: string;
      const pSort, Wait, Key1, Key2, Key3: integer; const ForApplication: string);
    procedure UpdatePressKeyboard(const id, pSort, Wait, Key1, Key2, Key3: integer;
      const ForApplication: string);
    procedure DeletePressKeyboard(const id: integer);

    function GetOperation(const Command: string): TOperations;

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
      '  [longPress] bit,                                                            ' +
      '  [repeatPrevious] bit)';
    Query.ExecSQL;

    // Запуск приложений
    Query.Sql.Text :=
      'CREATE TABLE OperationRunApplication(                                         ' +
      '  [id] counter primary key,                                                   ' +
      '  [command] string(100) references RemoteCommand([command]) on delete cascade,' +
      '  [pSort] integer,                                                            ' +
      '  [wait] integer default 0,                                                   ' +
      '  [application] string(255),                                                  ' +
      '  [description] string(255))';
    Query.ExecSQL;

    // Запуск приложений
    Query.Sql.Text :=
      'CREATE TABLE OperationPressKeyboard(                                          ' +
      '  [id] counter primary key,                                                   ' +
      '  [command] string(100) references RemoteCommand([command]) on delete cascade,' +
      '  [pSort] integer,                                                            ' +
      '  [wait] integer default 0,                                                   ' +
      '  [key1] integer default null references Keyboard([key]),                     ' +
      '  [key2] integer default null references Keyboard([key]),                     ' +
      '  [key3] integer default null references Keyboard([key]),                     ' +
      '  [forApplication] string(255),                                               ' +
      '  [description] string(255))';
    Query.ExecSQL;

    addKeybordGroup(Query, 0, 'Функциональные клавиши');
    addKeybord(Query, VK_F1, 'F1', 0);
    addKeybord(Query, VK_F2, 'F2', 0);
    addKeybord(Query, VK_F3, 'F3', 0);
    addKeybord(Query, VK_F4, 'F4', 0);
    addKeybord(Query, VK_F5, 'F5', 0);
    addKeybord(Query, VK_F6, 'F6', 0);
    addKeybord(Query, VK_F7, 'F7', 0);
    addKeybord(Query, VK_F8, 'F8', 0);
    addKeybord(Query, VK_F9, 'F9', 0);
    addKeybord(Query, VK_F10, 'F10', 0);
    addKeybord(Query, VK_F11, 'F11', 0);
    addKeybord(Query, VK_F12, 'F12', 0);

    addKeybordGroup(Query, 1, 'Служебные клавиши');
    addKeybord(Query, VK_ESCAPE, 'Esc', 1);
    addKeybord(Query, VK_LCONTROL, 'Левый Ctrl', 1);
    addKeybord(Query, VK_RCONTROL, 'Правый Ctrl', 1);
    addKeybord(Query, VK_LMENU, 'Левый Alt', 1);
    addKeybord(Query, VK_RMENU, 'Правый Alt', 1);
    addKeybord(Query, VK_LWIN, 'Левый Win', 1);
    addKeybord(Query, VK_RWIN, 'Правый Win', 1);
    addKeybord(Query, VK_APPS, 'Доп. меню', 1);
    addKeybord(Query, VK_LSHIFT, 'Левый Shift', 1);
    addKeybord(Query, VK_RSHIFT, 'Правый Shift', 1);
    addKeybord(Query, VK_CAPITAL, 'CapsLock', 1);
    addKeybord(Query, VK_BACK, 'BackSpace', 1);
    addKeybord(Query, VK_TAB, 'Tab', 1);
    addKeybord(Query, VK_RETURN, 'Enter', 1);
    addKeybord(Query, VK_SPACE, 'Пробел', 1);
    addKeybord(Query, VK_INSERT, 'Insert', 1);
    addKeybord(Query, VK_DELETE, 'Delete', 1);

    addKeybordGroup(Query, 2, 'Клавиши для ввода данных (буквенно-цифровые)');
    addKeybord(Query, vk0, '0', 2);
    addKeybord(Query, vk1, '1', 2);
    addKeybord(Query, vk2, '2', 2);
    addKeybord(Query, vk3, '3', 2);
    addKeybord(Query, vk4, '4', 2);
    addKeybord(Query, vk5, '5', 2);
    addKeybord(Query, vk6, '6', 2);
    addKeybord(Query, vk7, '7', 2);
    addKeybord(Query, vk8, '8', 2);
    addKeybord(Query, vk9, '9', 2);
    addKeybord(Query, vkA, 'A', 2);
    addKeybord(Query, vkB, 'B', 2);
    addKeybord(Query, vkC, 'C', 2);
    addKeybord(Query, vkD, 'D', 2);
    addKeybord(Query, vkE, 'E', 2);
    addKeybord(Query, vkF, 'F', 2);
    addKeybord(Query, vkG, 'G', 2);
    addKeybord(Query, vkH, 'H', 2);
    addKeybord(Query, vkI, 'I', 2);
    addKeybord(Query, vkJ, 'J', 2);
    addKeybord(Query, vkK, 'K', 2);
    addKeybord(Query, vkL, 'L', 2);
    addKeybord(Query, vkM, 'M', 2);
    addKeybord(Query, vkN, 'N', 2);
    addKeybord(Query, vkO, 'O', 2);
    addKeybord(Query, vkP, 'P', 2);
    addKeybord(Query, vkQ, 'Q', 2);
    addKeybord(Query, vkR, 'R', 2);
    addKeybord(Query, vkS, 'S', 2);
    addKeybord(Query, vkT, 'T', 2);
    addKeybord(Query, vkU, 'U', 2);
    addKeybord(Query, vkV, 'V', 2);
    addKeybord(Query, vkW, 'W', 2);
    addKeybord(Query, vkX, 'X', 2);
    addKeybord(Query, vkY, 'Y', 2);
    addKeybord(Query, vkZ, 'Z', 2);
    addKeybord(Query, VK_OEM_1, ';', 2);
    addKeybord(Query, VK_OEM_PLUS, '=', 2);
    addKeybord(Query, VK_OEM_COMMA, ',', 2);
    addKeybord(Query, VK_OEM_MINUS, '-', 2);
    addKeybord(Query, VK_OEM_PERIOD, '.', 2);
    addKeybord(Query, VK_OEM_2, '/', 2);
    addKeybord(Query, VK_OEM_3, '`', 2);
    addKeybord(Query, VK_OEM_4, '[', 2);
    addKeybord(Query, VK_OEM_5, '\', 2);
    addKeybord(Query, VK_OEM_6, ']', 2);
    addKeybord(Query, VK_OEM_7, '''''', 2);

    addKeybordGroup(Query, 3, 'Цифровая клавиатура');
    addKeybord(Query, VK_NUMLOCK, 'NumLock', 3);
    addKeybord(Query, VK_DIVIDE, '/', 3);
    addKeybord(Query, VK_MULTIPLY, '*', 3);
    addKeybord(Query, VK_SUBTRACT, '-', 3);
    addKeybord(Query, VK_ADD, '+', 3);
    addKeybord(Query, VK_DECIMAL, '.', 3);
    addKeybord(Query, VK_NUMPAD0, '0', 3);
    addKeybord(Query, VK_NUMPAD1, '1', 3);
    addKeybord(Query, VK_NUMPAD2, '2', 3);
    addKeybord(Query, VK_NUMPAD3, '3', 3);
    addKeybord(Query, VK_NUMPAD4, '4', 3);
    addKeybord(Query, VK_NUMPAD5, '5', 3);
    addKeybord(Query, VK_NUMPAD6, '6', 3);
    addKeybord(Query, VK_NUMPAD7, '7', 3);
    addKeybord(Query, VK_NUMPAD8, '8', 3);
    addKeybord(Query, VK_NUMPAD9, '9', 3);

    addKeybordGroup(Query, 4, 'Клавиши перемещения');
    addKeybord(Query, VK_PRIOR, 'PageUp', 4);
    addKeybord(Query, VK_NEXT, 'PageDown', 4);
    addKeybord(Query, VK_END, 'End', 4);
    addKeybord(Query, VK_HOME, 'Home', 4);
    addKeybord(Query, VK_LEFT, 'Стрелка назад', 4);
    addKeybord(Query, VK_UP, 'Стрелка вверх', 4);
    addKeybord(Query, VK_RIGHT, 'Стрелка вперед', 4);
    addKeybord(Query, VK_DOWN, 'Стрелка вниз', 4);

    addKeybordGroup(Query, 5, 'Вспомогательные клавиши');
    addKeybord(Query, VK_SCROLL, 'ScrollLock', 5);
    addKeybord(Query, VK_SNAPSHOT, 'PrintScreen', 5);
    addKeybord(Query, VK_PAUSE, 'PauseBreak', 5);

    addKeybordGroup(Query, 6, 'Мультимедиа');
    addKeybord(Query, VK_VOLUME_MUTE, 'Звук - безвучно', 6);
    addKeybord(Query, VK_VOLUME_DOWN, 'Звук - уменьшить', 6);
    addKeybord(Query, VK_VOLUME_UP, 'Звук - увеличить', 6);
    addKeybord(Query, VK_MEDIA_NEXT_TRACK, 'Слудующий трек', 6);
    addKeybord(Query, VK_MEDIA_PREV_TRACK, 'Предыдущий трек', 6);
    addKeybord(Query, VK_MEDIA_STOP, 'Стоп', 6);
    addKeybord(Query, VK_MEDIA_PLAY_PAUSE, 'Играть/Пауза', 6);

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

function TDataBase.getKeyboardGroups(): TKeyboardGroups;
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
      KeyboardGroups[Query.RecNo - 1].Description := Query.FieldByName('description').AsString;
      Query.Next;
    end;
    Result := KeyboardGroups;
  finally
    Query.Active := false;
    Query.Free;
  end;
end;

function TDataBase.GetKeyboards(): TKeyboards;
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

function TDataBase.GetKeyboard(Key: integer): TKeyboard;
var
  Query: TADOQuery;
begin
  if not FConnection.Connected then
    exit;

  try
    Query := TADOQuery.Create(nil);
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'select key, description, group from Keyboard where key = ' + IntToStr(Key);
    Query.ExecSQL;
    Query.Active := True;
    Query.First;
    while not Query.Eof do
    begin
      Result.Key := Query.FieldByName('key').AsInteger;
      Result.Desc := Query.FieldByName('description').AsString;
      Result.Group := Query.FieldByName('group').AsInteger;
      Query.Next;
    end;
  finally
    Query.Active := false;
    Query.Free;
  end;
end;

function TDataBase.GetRemoteCommand(const Command: string): TRemoteCommand;
var
  RCommand: TRemoteCommand;
begin
  if RemoteCommandExists(Command, RCommand) then
    Result := RCommand;
end;

function TDataBase.GetRemoteCommands(): TRemoteCommands;
var
  Query: TADOQuery;
begin
  Result := nil;

  if not FConnection.Connected then
    exit;

  try
    Query := TADOQuery.Create(nil);
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text :=
      'select command, description, repeatPrevious from RemoteCommand order by command';
    Query.ExecSQL;
    Query.Active := True;
    Query.First;
    while not Query.Eof do
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Query.RecNo - 1].Command := Query.FieldByName('command').AsString;
      Result[Query.RecNo - 1].Desc := Query.FieldByName('description').AsString;
      Result[Query.RecNo - 1].RepeatPrevious := Query.FieldByName('repeatPrevious').AsBoolean;
      Query.Next;
    end;
  finally
    Query.Active := false;
    Query.Free;
  end;
end;

function TDataBase.RemoteCommandExists(const Command: string): boolean;
var
  RCommand: TRemoteCommand;
begin
  Result := RemoteCommandExists(Command, RCommand);
end;

function TDataBase.RemoteCommandExists(const Command: string; var RCommand: TRemoteCommand)
  : boolean;
var
  Query: TADOQuery;
  LCommand: String;
begin
  Result := false;
  if not FConnection.Connected then
    exit;

  LCommand := Command;

  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text :=
      'select command, description, repeatPrevious, longPress from RemoteCommand where command = "'
      + Command + '"';
    Query.ExecSQL;
    Query.Active := True;
    if Query.RecordCount > 0 then
    begin
      Query.First;

      Result := True;
      RCommand.Command := Query.FieldByName('command').AsString;
      RCommand.Desc := Query.FieldByName('description').AsString;
      RCommand.RepeatPrevious := Query.FieldByName('repeatPrevious').AsBoolean;
      RCommand.LongPress := Query.FieldByName('longPress').AsBoolean;
    end;
  finally
    Query.Active := false;
    Query.Free;
  end;
end;

function TDataBase.CreateRemoteCommand(const Command, Description: string;
  const RepeatPrevious, LongPress: boolean): string;
var
  Query: TADOQuery;
  RCommand: TRemoteCommand;
begin
  Result := '';
  if not FConnection.Connected then
    exit;

  // проверка существования команды
  if RemoteCommandExists(Command, RCommand) then
  begin
    Result := RCommand.Command;
    exit;
  end;

  // Создание команды
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text :=
      'insert into RemoteCommand (command, description, repeatPrevious, longPress) values ("' +
      Command + '", "' + Description + '", ' + BoolToStr(RepeatPrevious) + ', ' +
      BoolToStr(LongPress) + ')';
    Query.ExecSQL;

    Result := Command;
  finally
    Query.Free;
  end;
end;

function TDataBase.CreateRemoteCommand(const Command, Description: string;
  const RepeatPrevious, LongPress: boolean; var Exists: boolean): string;
var
  RCommand: TRemoteCommand;
begin
  Result := '';
  Exists := false;

  if not FConnection.Connected then
    exit;

  // проверка существования команды
  if RemoteCommandExists(Command, RCommand) then
  begin
    Result := RCommand.Command;
    Exists := True;
    exit;
  end;

  Result := CreateRemoteCommand(Command, Description, RepeatPrevious, LongPress);
end;

function TDataBase.UpdateRemoteCommand(const Command, Description: string;
  const RepeatPrevious, LongPress: boolean): string;
var
  Query: TADOQuery;
  RCommand: TRemoteCommand;
begin
  Result := '';
  if not FConnection.Connected then
    exit;

  // проверка существования команды
  if not RemoteCommandExists(Command, RCommand) then
  begin
    raise Exception.Create(Format(GetLanguageMsg('msgDBRemoteCommandNotFound', lngRus), [Command]));
  end;

  // Изменение команды
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'update RemoteCommand set description = "' + Description + '",' +
      'repeatPrevious = ' + BoolToStr(RepeatPrevious) + ', longPress = ' + BoolToStr(LongPress) +
      ' where command = "' + Command + '"';
    Query.ExecSQL;

    Result := Command;
  finally
    Query.Free;
  end;
end;

procedure TDataBase.DeleteRemoteCommand(const Command: string);
var
  Query: TADOQuery;
  RCommand: TRemoteCommand;
begin
  if not FConnection.Connected then
    exit;

  // проверка существования команды
  if not RemoteCommandExists(Command, RCommand) then
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

procedure TDataBase.CreateRunApplication(const Command: string; const pSort, Wait: integer;
  const AppFileName: string);
var
  Query: TADOQuery;
  // LCommand: string;
begin
  if not FConnection.Connected then
    exit;

  if not FileExists(AppFileName) then
    raise Exception.Create(Format(GetLanguageMsg('msgDBRunApplicationFileNotFound', lngRus),
      [AppFileName]));

  if not RemoteCommandExists(Command) then
    raise Exception.CreateFmt(GetLanguageMsg('msgDBRemoteCommandNotFound', lngRus), [Command]);

  // Создание запуска приложения
  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text :=
      'insert into OperationRunApplication (command, pSort, wait, application) values ("' + Command
      + '", ' + IntToStr(pSort) + ', ' + IntToStr(Wait) + ', "' + AppFileName + '")';
    Query.ExecSQL;

  finally
    Query.Free;
  end;

end;

procedure TDataBase.UpdateRunApplication(const id, pSort, Wait: integer; const AppFileName: string);
var
  Query: TADOQuery;
begin
  if not FConnection.Connected then
    exit;

  if not FileExists(AppFileName) then
    raise Exception.Create(Format(GetLanguageMsg('msgDBRunApplicationFileNotFound', lngRus),
      [AppFileName]));

  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'update OperationRunApplication set application = "' + AppFileName +
      '", pSort = ' + IntToStr(pSort) + ', wait = ' + IntToStr(Wait) + ' where id = ' +
      IntToStr(id);
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TDataBase.DeleteRunApplication(const id: integer);
var
  Query: TADOQuery;
begin
  if not FConnection.Connected then
    exit;

  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'delete from OperationRunApplication where id = ' + IntToStr(id);
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TDataBase.CreatePressKeyboard(const Command: string;
  const pSort, Wait, Key1, Key2, Key3: integer; const ForApplication: string);
var
  Query: TADOQuery;
  sKey1, sKey2, sKey3: string;
begin
  if not FConnection.Connected then
    exit;

  sKey1 := 'null';
  sKey2 := 'null';
  sKey3 := 'null';

  if Key1 > 0 then
    sKey1 := IntToStr(Key1);
  if Key2 > 0 then
    sKey2 := IntToStr(Key2);
  if Key3 > 0 then
    sKey3 := IntToStr(Key3);

  try
    // Создание запуска приложения
    Query := TADOQuery.Create(nil);
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text :=
      'insert into OperationPressKeyboard (command, pSort, wait, key1, key2, key3, forApplication) values ("'
      + Command + '", ' + IntToStr(pSort) + ', ' + IntToStr(Wait) + ', ' + sKey1 + ', ' + sKey2 +
      ', ' + sKey3 + ', "' + ForApplication + '")';
    Query.ExecSQL;

  finally
    Query.Free;
  end;
end;

procedure TDataBase.UpdatePressKeyboard(const id, pSort, Wait, Key1, Key2, Key3: integer;
  const ForApplication: string);
var
  Query: TADOQuery;
  sKey1, sKey2, sKey3: string;
begin
  if not FConnection.Connected then
    exit;

  sKey1 := 'null';
  sKey2 := 'null';
  sKey3 := 'null';

  if Key1 > 0 then
    sKey1 := IntToStr(Key1);
  if Key2 > 0 then
    sKey2 := IntToStr(Key2);
  if Key3 > 0 then
    sKey3 := IntToStr(Key3);

  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'update OperationPressKeyboard set pSort = ' + IntToStr(pSort) + ', wait = ' +
      IntToStr(Wait) + ', key1 = ' + sKey1 + ',  key2 = ' + sKey2 + ',  key3 = ' + sKey3 +
      ', forApplication = "' + ForApplication + '" where id = ' + IntToStr(id);
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

procedure TDataBase.DeletePressKeyboard(const id: integer);
var
  Query: TADOQuery;
begin
  if not FConnection.Connected then
    exit;

  Query := TADOQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'delete from OperationPressKeyboard where id = ' + IntToStr(id);
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

function TDataBase.GetOperation(const Command: string): TOperations;
var
  Query: TADOQuery;
begin
  if not FConnection.Connected then
    exit;

  try
    Query := TADOQuery.Create(nil);
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'SELECT * FROM (                                                ' +
      '    SELECT opk.command          as command,                                    ' +
      '        opk.psort               as psort,                                      ' +
      '        opk.wait                as wait,                                       ' +
      '        opk.id                  as id,                                         ' +
      '        "' + tcKeyboard + '"    as type,                                       ' +
      '        opk.key1                as key1,                                       ' +
      '        opk.key2                as key2,                                       ' +
      '        opk.key3                as key3,                                       ' +
      '        opk.forApplication      as forApplication,                             ' +
      '        null                    as application,                                ' +
      '        kk1.Description                                                        ' +
      '          & IIF(isNull(opk.Key2), "", " + " & kk2.Description)                 ' +
      '          & IIF(isNull(opk.Key3), "", " + " & kk3.Description)                 ' +
      '          & IIF(len(opk.forApplication) > 0,                                   ' +
      '                  " (" & opk.forApplication & ")"                              ' +
      '               )                as operation                                   ' +
      '      FROM (( Keyboard AS kk1                                                  ' +
      '        INNER JOIN OperationPressKeyboard AS opk ON kk1.Key = opk.Key1 )       ' +
      '        LEFT JOIN Keyboard AS kk2 ON opk.Key2 = kk2.Key )                      ' +
      '        LEFT JOIN Keyboard AS kk3 ON opk.Key3 = kk3.Key                        ' +
      '    UNION ALL                                                                  ' +
      '    SELECT ora.command          as command,                                    ' +
      '        ora.psort               as psort,                                      ' +
      '        ora.wait                as wait,                                       ' +
      '        ora.id                  as id,                                         ' +
      '        "' + tcApplication + '" as type,                                       ' +
      '        null                    as key1,                                       ' +
      '        null                    as key2,                                       ' +
      '        null                    as key3,                                       ' +
      '        null                    as forApplication,                             ' +
      '        ora.application         as application,                                ' +
      '        ora.Application         as operation                                   ' +
      '      FROM OperationRunApplication as ora                                      ' +
      '  )                                                                            ' +
      '  WHERE command = "' + Command + '"                                            ' +
      '  ORDER BY psort, type, operation                                              ';

    Query.ExecSQL;
    Query.Active := True;
    Query.First;
    while not Query.Eof do
    begin
      SetLength(Result, Length(Result) + 1);
      Result[Query.RecNo - 1].Command := Query.FieldByName('command').AsString;
      Result[Query.RecNo - 1].OSort := Query.FieldByName('psort').AsInteger;
      Result[Query.RecNo - 1].OWait := Query.FieldByName('wait').AsInteger;
      Result[Query.RecNo - 1].Operation := Query.FieldByName('operation').AsString;

      if Query.FieldByName('type').AsString = tcApplication then
      begin
        Result[Query.RecNo - 1].OType := opApplication;
        Result[Query.RecNo - 1].RunApplication.id := Query.FieldByName('id').AsInteger;
        Result[Query.RecNo - 1].RunApplication.Command := Result[Query.RecNo - 1].Command;
        Result[Query.RecNo - 1].RunApplication.pSort := Query.FieldByName('psort').AsInteger;
        Result[Query.RecNo - 1].RunApplication.Wait := Query.FieldByName('wait').AsInteger;
        Result[Query.RecNo - 1].RunApplication.Application :=
          Query.FieldByName('application').AsString;
      end
      else if Query.FieldByName('type').AsString = tcKeyboard then
      begin
        Result[Query.RecNo - 1].OType := opKyeboard;
        Result[Query.RecNo - 1].PressKeyboard.id := Query.FieldByName('id').AsInteger;
        Result[Query.RecNo - 1].PressKeyboard.Command := Result[Query.RecNo - 1].Command;
        Result[Query.RecNo - 1].PressKeyboard.pSort := Query.FieldByName('psort').AsInteger;
        Result[Query.RecNo - 1].PressKeyboard.Wait := Query.FieldByName('wait').AsInteger;
        Result[Query.RecNo - 1].PressKeyboard.Key1 := Query.FieldByName('key1').AsInteger;
        Result[Query.RecNo - 1].PressKeyboard.Key2 := Query.FieldByName('key2').AsInteger;
        Result[Query.RecNo - 1].PressKeyboard.Key3 := Query.FieldByName('key3').AsInteger;
        Result[Query.RecNo - 1].PressKeyboard.ForApplication :=
          Query.FieldByName('forApplication').AsString;
      end;

      Query.Next;
    end;
  finally
    Query.Active := false;
    Query.Free;
  end;

end;

end.
