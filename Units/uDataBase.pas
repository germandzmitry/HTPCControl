unit uDataBase;

interface

uses
  System.Variants, System.SysUtils, Data.DB, Data.Win.ADODB, System.Win.ComObj,
  uLanguage, uTypes;

const
  tcApplication = 'A';

const
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
    Rep: boolean;
  end;

  PRemoteCommand = ^TRemoteCommand;

  TVCommand = Record
    Command: string[100];
    Desc: string[255];
    OId: string;
    Operation: string;
    ORepeat: boolean;
    ODescription: string;
  End;

  TVCommands = array of TVCommand;

  TECommand = Record
    Command: TRemoteCommand;
    CType: string[1];
    Operation: string;
    Application: string[255];
    Key1: integer;
    Key2: integer;
    Rep: boolean;
  End;

  PECommand = ^TECommand;
  TECommands = array of TECommand;

type
  TDataBase = class
    procedure Connect;
    procedure Disconnect;

    function CommandExists(const ACommand: string; var Command: TRemoteCommand): boolean;
    function getVCommands(): TVCommands;
    function getExecuteCommands(Command: string): TECommands;

    function GetKeyboardKey(Key: integer): PKeyKeyboard;
    function GetKeyboards(): TKeyboards;

    function CreateRunApplication(const RCommand: TRemoteCommand; AppFileName: string): boolean;
    function CreatePressKeyKeyboard(const RCommand: TRemoteCommand; Key1, Key2: integer;
      ARepeat: boolean): boolean;

    function CreateRemoteCommand(const Command, Description: string;
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

  procedure addButtobPc(Query: TADOQuery; Key: integer; Description: string; Group: integer);
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
    raise Exception.Create(Format(GetLanguageText('ErrorDBFileNameExists', lngRus), [FileName]));

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

    // Справочник - Клавиатура
    Query.Sql.Text :=
      'CREATE TABLE Keyboard(                                                       ' +
      '  [key] integer primary key,                                                 ' +
      '  [description] string (255),                                                ' +
      '  [group] integer)';
    Query.ExecSQL;

    // Справочник - Кнопки пульта
    Query.Sql.Text :=
      'CREATE TABLE RemoteCommand(                                                  ' +
      '  [command] string(100) primary key,                                         ' +
      '  [description] string(255),                                                 ' +
      '  [repeat] bit)';
    Query.ExecSQL;

    // Запуск приложений
    Query.Sql.Text :=
      'CREATE TABLE RunApplication(                                                 ' +
      '  [id] counter primary key,                                                  ' +
      '  [command] string(100) references RemoteCommand([command]),                 ' +
      '  [application] string(255),                                                 ' +
      '  [description] string(255))';
    Query.ExecSQL;

    // Запуск приложений
    Query.Sql.Text :=
      'CREATE TABLE PressKeyKeyboard(                                               ' +
      '  [id] counter primary key,                                                  ' +
      '  [command] string(100) references RemoteCommand([command]),                 ' +
      '  [key1] integer default null references Keyboard([key]),                    ' +
      '  [key2] integer default null references Keyboard([key]),                    ' +
      '  [repeat] bit,                                                              ' +
      '  [for_application] string(255),                                             ' +
      '  [description] string(255))';
    Query.ExecSQL;

    // Наполнение справочника - Клавиатура
    addButtobPc(Query, 8, 'BackSpace', 2);
    addButtobPc(Query, 9, 'Tab', 2);
    addButtobPc(Query, 13, 'Enter', 2);
    addButtobPc(Query, 16, 'Shift', 2);
    addButtobPc(Query, 17, 'Ctrl', 2);
    addButtobPc(Query, 18, 'Alt', 2);
    addButtobPc(Query, 20, 'CapsLock', 2);
    addButtobPc(Query, 27, 'Esc', 2);
    addButtobPc(Query, 32, 'Пробел', 2);
    addButtobPc(Query, 33, 'PageUp', 2);
    addButtobPc(Query, 34, 'PageDown', 2);
    addButtobPc(Query, 35, 'End', 2);
    addButtobPc(Query, 36, 'Home', 2);
    addButtobPc(Query, 37, 'Стрелка назад', 2);
    addButtobPc(Query, 38, 'Стрелка вверх', 2);
    addButtobPc(Query, 39, 'Стрелка вперед', 2);
    addButtobPc(Query, 40, 'Стрелка вниз', 2);
    addButtobPc(Query, 44, 'PrintScreen', 2);
    addButtobPc(Query, 45, 'Insert', 2);
    addButtobPc(Query, 46, 'Delete', 2);
    addButtobPc(Query, 48, '0', 3);
    addButtobPc(Query, 49, '1', 3);
    addButtobPc(Query, 50, '2', 3);
    addButtobPc(Query, 51, '3', 3);
    addButtobPc(Query, 52, '4', 3);
    addButtobPc(Query, 53, '5', 3);
    addButtobPc(Query, 54, '6', 3);
    addButtobPc(Query, 55, '7', 3);
    addButtobPc(Query, 56, '8', 3);
    addButtobPc(Query, 57, '9', 3);
    addButtobPc(Query, 65, 'A', 4);
    addButtobPc(Query, 66, 'B', 4);
    addButtobPc(Query, 67, 'C', 4);
    addButtobPc(Query, 68, 'D', 4);
    addButtobPc(Query, 69, 'E', 4);
    addButtobPc(Query, 70, 'F', 4);
    addButtobPc(Query, 71, 'G', 4);
    addButtobPc(Query, 72, 'H', 4);
    addButtobPc(Query, 73, 'I', 4);
    addButtobPc(Query, 74, 'J', 4);
    addButtobPc(Query, 75, 'K', 4);
    addButtobPc(Query, 76, 'L', 4);
    addButtobPc(Query, 77, 'M', 4);
    addButtobPc(Query, 78, 'N', 4);
    addButtobPc(Query, 79, 'O', 4);
    addButtobPc(Query, 80, 'P', 4);
    addButtobPc(Query, 81, 'Q', 4);
    addButtobPc(Query, 82, 'R', 4);
    addButtobPc(Query, 83, 'S', 4);
    addButtobPc(Query, 84, 'T', 4);
    addButtobPc(Query, 85, 'U', 4);
    addButtobPc(Query, 86, 'V', 4);
    addButtobPc(Query, 87, 'W', 4);
    addButtobPc(Query, 88, 'X', 4);
    addButtobPc(Query, 89, 'Y', 4);
    addButtobPc(Query, 90, 'Z', 4);
    addButtobPc(Query, 91, 'Win', 2);
    addButtobPc(Query, 93, 'Доп. меню', 2);
    addButtobPc(Query, 112, 'F1', 0);
    addButtobPc(Query, 113, 'F2', 0);
    addButtobPc(Query, 114, 'F3', 0);
    addButtobPc(Query, 115, 'F4', 0);
    addButtobPc(Query, 116, 'F5', 0);
    addButtobPc(Query, 117, 'F6', 0);
    addButtobPc(Query, 118, 'F7', 0);
    addButtobPc(Query, 119, 'F8', 0);
    addButtobPc(Query, 120, 'F9', 0);
    addButtobPc(Query, 121, 'F10', 0);
    addButtobPc(Query, 122, 'F11', 0);
    addButtobPc(Query, 123, 'F12', 0);
    addButtobPc(Query, 144, 'NumLock', 2);
    addButtobPc(Query, 145, 'ScrollLock', 2);
    addButtobPc(Query, 173, 'Звук - безвучно', 1);
    addButtobPc(Query, 174, 'Звук - уменьшить', 1);
    addButtobPc(Query, 175, 'Звук - увеличить', 1);
    addButtobPc(Query, 176, 'Слудующий трек', 1);
    addButtobPc(Query, 177, 'Предыдущий трек', 1);
    addButtobPc(Query, 178, 'Стоп', 1);
    addButtobPc(Query, 179, 'Играть/Пауза', 1);
    addButtobPc(Query, 186, ';', 2);
    addButtobPc(Query, 187, '=', 2);
    addButtobPc(Query, 188, ',', 2);
    addButtobPc(Query, 189, '-', 2);
    addButtobPc(Query, 190, '.', 2);
    addButtobPc(Query, 191, '/', 2);
    addButtobPc(Query, 192, '`', 2);
    addButtobPc(Query, 219, '[', 2);
    addButtobPc(Query, 220, '\', 2);
    addButtobPc(Query, 221, ']', 2);
    addButtobPc(Query, 222, '''''', 2);

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

function TDataBase.CreatePressKeyKeyboard(const RCommand: TRemoteCommand; Key1, Key2: integer;
  ARepeat: boolean): boolean;
var
  Query: TADOQuery;
  LCommand, sKey1, sKey2: string;
begin
  Result := false;
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

    Result := True;
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

  try
    // проверка существования команды
    if CommandExists(Command, RCommand) then
    begin
      Result := RCommand.Command;
      exit;
    end;

    // Создание команды
    Query := TADOQuery.Create(nil);
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

function TDataBase.CreateRunApplication(const RCommand: TRemoteCommand;
  AppFileName: string): boolean;
var
  Query: TADOQuery;
  LCommand: string;
begin
  Result := false;
  if not FConnection.Connected then
    exit;

  if not FileExists(AppFileName) then
    raise Exception.Create(Format(GetLanguageText('ErrorDBRunApplicationFileNotFound', lngRus),
      [AppFileName]));

  LCommand := CreateRemoteCommand(RCommand.Command, RCommand.Desc);

  try

    // Создание запуска приложения
    Query := TADOQuery.Create(nil);
    Query.Connection := FConnection;
    Query.Sql.Clear;
    Query.Sql.Text := 'insert into RunApplication (command, application) values ("' +
      RCommand.Command + '", "' + AppFileName + '")';
    Query.ExecSQL;

    Result := True;
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

function TDataBase.GetKeyboardKey(Key: integer): PKeyKeyboard;
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

function TDataBase.getVCommands: TVCommands;
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
      '       em.id, em.operation, em.repeat                                        ' +
      '  from remotecommand as rc                                                   ' +
      '  left join(                                                                 ' +
      '    select "' + tcKeyboard + '" & pk.id as id,                               ' +
      '           pk.command as command,                                            ' +
      '           k1.description                                                    ' +
      '            & IIF(isNull(pk.key2), "", " + " &  k2.description) as operation,' +
      '           pk.repeat as repeat                                               ' +
      '      from (                                                                 ' +
      '        PressKeyKeyboard as pk                                               ' +
      '          inner join keyboard as k1 on k1.key = pk.key1                      ' +
      '      )                                                                      ' +
      '    left join keyboard as k2 on k2.key = pk.key2                             ' +
      '    union all                                                                ' +
      '    select "' + tcApplication + '" & ra.id as id,                            ' +
      '           ra.command as command,                                            ' +
      '           ra.application as operation,                                      ' +
      '           null as repeat                                                    ' +
      '      from runapplication AS ra                                              ' +
      '  ) as em on rc.command = em.command                                         ' +
      'order by rc.command';
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
      Query.Next;
    end;
    Result := ResVCommands;
  finally
    Query.Active := false;
    Query.Free;
  end;
end;

function TDataBase.getExecuteCommands(Command: string): TECommands;
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
    { Query.Sql.Text := 'select * from (                                              ' +
      '    select rc.command,                                                       ' +
      '           "' + tcKeyboard + '" as type,                                     ' +
      '           null as application,                                              ' +
      '           pk.key1 as key1,                                                  ' +
      '           pk.key2 as key2,                                                  ' +
      '           pk.repeat as repeat,                                              ' +
      '           pk.key1 & " + " & pk.key2 as operation                            ' +
      '      from remotecommand as rc                                               ' +
      '      inner join pressKeyKeyboard as pk on pk.command = rc.command           ' +
      '    union all                                                                ' +
      '    select rc.command,                                                       ' +
      '           "' + tcApplication + '" as type,                                  ' +
      '           ra.application,                                                   ' +
      '           null as key1,                                                     ' +
      '           null as key2,                                                     ' +
      '           null as repeat,                                                   ' +
      '           ra.application as operation                                       ' +
      '      from remotecommand as rc                                               ' +
      '      inner join runapplication as ra on ra.command = rc.command             ' +
      '  )                                                                          ' +
      'where command = "' + Command + '"'; }

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
      ResECommands[Query.RecNo - 1].Command.Rep := Query.FieldByName('rcrepeat').AsBoolean;
      ResECommands[Query.RecNo - 1].CType := Query.FieldByName('type').AsString;
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
begin
  Result := false;
  if not FConnection.Connected then
    exit;

  try
    Query := TADOQuery.Create(nil);
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
      Command.Rep := Query.FieldByName('repeat').AsBoolean;
    end;
  finally
    Query.Active := false;
    Query.Free;
  end;
end;

end.
