unit uDataBase;

interface

uses
  System.Variants, System.SysUtils, Data.DB, Data.Win.ADODB, System.Win.ComObj,
  uLanguage, uTypes;

type
  TDataBase = class
    procedure Connect;
    procedure Disconnect;

    function Connected: boolean;
  private
    FConnection: TADOConnection;
    FFileName: string;
  public
    constructor Create; overload;
    constructor Create(FileName: string); overload;
    destructor Destroy; override;
  end;

procedure CreateDB(FileName: string);

implementation

procedure CreateDB(FileName: string);

  procedure addButtobPc(Query: TADOQuery; Key: integer; description: string; Group: integer);
  begin
    Query.Sql.Text := 'insert into Keyboard([key], [description], [group]) values (' + inttostr(Key)
      + ', ' + '''' + description + ''', ' + inttostr(Group) + ')';
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
    Connection.Connected := true;

    {
      Создаем таблицы
    }
    Query := TADOQuery.Create(nil);
    Query.Connection := Connection;

    // Справочник - Клавиатура
    Query.Sql.Text := 'CREATE TABLE Keyboard(' + '[key] integer primary key, ' +
      '[description] string (255), ' + '[group] integer)';
    Query.ExecSQL;

    // Справочник - Кнопки пульта
    Query.Sql.Text := 'CREATE TABLE RemoteControl(' + '[command] string(100) primary key, ' +
      '[description] string(255))';
    Query.ExecSQL;

    // Запуск приложений
    Query.Sql.Text := 'CREATE TABLE RunApplication(' + '[id] counter primary key, ' +
      '[command] string(100) references RemoteControl([command]), ' + '[application] string(255), '
      + '[description] string(255))';
    Query.ExecSQL;

    // Запуск приложений
    Query.Sql.Text := 'CREATE TABLE PressKeyKeyboard(' + '[id] counter primary key, ' +
      '[command] string(100) references RemoteControl([command]), ' +
      '[key1] integer references Keyboard([key]), ' + '[key2] integer references Keyboard([key]), '
      + '[repeat] bit, ' + '[for_application] string(255), ' + '[description] string(255))';
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

destructor TDataBase.Destroy;
begin
  if Connected then
    Disconnect;
  FConnection.Free;

  inherited;
end;

procedure TDataBase.Connect;
begin
  if not Connected then
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
  if Connected then
    FConnection.Close;
end;

function TDataBase.Connected: boolean;
begin
  result := FConnection.Connected;
end;

end.
