unit uExecuteCommand;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics,
  uDataBase, uLanguage, uTypes, uShellApplication, SyncObjs;

{ https://docs.microsoft.com/ru-ru/windows/desktop/inputdev/about-keyboard-input#extended-key-flag }
{ Extended-Key Flag
  The extended-key flag indicates whether the keystroke message originated from
  one of the additional keys on the enhanced keyboard.
  The extended keys consist of the ALT and CTRL keys on the right-hand side of the keyboard;
  the INS, DEL, HOME, END, PAGE UP, PAGE DOWN, and arrow keys in the clusters to the left of the numeric keypad;
  the NUM LOCK key;
  the BREAK (CTRL+PAUSE) key;
  the PRINT SCRN key;
  and the divide (/) and ENTER keys in the numeric keypad.
  The extended-key flag is set if the key is an extended key. }
const
  ExtendedKeys: set of Byte = [VK_RCONTROL, VK_RMENU, VK_INSERT, VK_DELETE, VK_HOME, VK_END,
    VK_PRIOR, VK_NEXT, VK_LEFT, VK_UP, VK_RIGHT, VK_DOWN, VK_NUMLOCK, VK_PAUSE, VK_SNAPSHOT,
    VK_DIVIDE];

type
  TExecuteCommandState = (ecCreating, ecWaiting, ecExecuting, ecEnd);

type
  TExecuteCommandCreatingEvent = procedure(EIndex: integer; RCommand: TRemoteCommand;
    Operations: String; OWait: integer; RepeatPrevious: boolean) of object;
  TExecuteCommandWaitingEvent = procedure(EIndex: integer) of object;
  TExecuteCommandExecutingEvent = procedure(EIndex: integer; Step: integer) of object;
  TExecuteCommandEndEvent = procedure(EIndex: integer) of object;
  TPreviousCommandEvent = procedure(Operations: string) of object;
  TCommandInQueueEvent = procedure(Queue: integer) of object;

type
  TExecuteCommand = class
    procedure Execute(RCommand: TRemoteCommand; RepeatPrevious: boolean = false);
    procedure ExecuteInCurrentThread(Operations: TOperations);
    procedure ClearPrevious();
  private
    FDB: TDataBase;
    FCS: TCriticalSection;
    FEIndex: integer;
    FPrevRCommand: PRemoteCommand;
    FInCurrentThread: boolean;
    FCommandInQueue: integer;

    FOnCreating: TExecuteCommandCreatingEvent;
    FOnWaiting: TExecuteCommandWaitingEvent;
    FOnExecuting: TExecuteCommandExecutingEvent;
    FOnExecuteEnd: TExecuteCommandEndEvent;
    FOnPreviousCommand: TPreviousCommandEvent;
    FOnCommandInQueue: TCommandInQueueEvent;

    procedure onThreadTerminate(Sender: TObject);
    procedure onThreadWaiting(EIndex: integer);
    procedure onThreadExecuting(EIndex: integer; Step: integer);

    procedure DoCreating(EIndex: integer; RCommand: TRemoteCommand; Operations: TOperations;
      RepeatPrevious: boolean); dynamic;
    procedure DoWaiting(EIndex: integer); dynamic;
    procedure DoExecuting(EIndex: integer; Step: integer); dynamic;
    procedure DoExecuteEnd(EIndex: integer); dynamic;
    procedure DoPreviousCommand(Operations: string); dynamic;
    procedure DoCommandInQueue(Queue: integer); dynamic;

    procedure SetPrevious(RCommand: TRemoteCommand; Operations: string);
    function LineOperations(Operations: TOperations): string; overload;
    function LineOperations(Operations: TOperations; var OWait: integer): string; overload;

    procedure SetInCurrentThread(const Value: boolean);
    procedure IncCommandInQueue();
    procedure DecCommandInQueue();

  public
    constructor Create(DB: TDataBase); overload;
    destructor Destroy; override;

    property InCurrentThread: boolean read FInCurrentThread write SetInCurrentThread;

    property OnCreating: TExecuteCommandCreatingEvent read FOnCreating write FOnCreating;
    property OnWaiting: TExecuteCommandWaitingEvent read FOnWaiting write FOnWaiting;
    property OnExecuting: TExecuteCommandExecutingEvent read FOnExecuting write FOnExecuting;
    property OnExecuteEnd: TExecuteCommandEndEvent read FOnExecuteEnd write FOnExecuteEnd;
    property OnPreviousCommand: TPreviousCommandEvent read FOnPreviousCommand
      write FOnPreviousCommand;
    property OnCommandInQueue: TCommandInQueueEvent read FOnCommandInQueue write FOnCommandInQueue;
  end;

  TThreadExecuteCommand = class(TThread)
  private
    FCS: TCriticalSection;
    FEIndex: integer;
    FOperations: TOperations;

    FOnWaiting: TExecuteCommandWaitingEvent;
    FOnExecuting: TExecuteCommandExecutingEvent;

    procedure DoWaiting(EIndex: integer); dynamic;
    procedure DoExecuting(EIndex: integer; Step: integer); dynamic;
  protected
    procedure Execute; override;
  public
    constructor Create(var CriticalSection: TCriticalSection; EIndex: integer;
      Operations: TOperations); overload;
    destructor Destroy; override;

    property OnWaiting: TExecuteCommandWaitingEvent read FOnWaiting write FOnWaiting;
    property OnExecuting: TExecuteCommandExecutingEvent read FOnExecuting write FOnExecuting;
  end;

  TObjectRemoteCommand = class
    FEIndex: integer;
    FCommand: string;
    FOperations: string;
    FState: TExecuteCommandState;
    FIcon: TIcon;
    FAll: integer;
    FCurrent: integer;
  public
    constructor Create(EIndex: integer; Command, Operations: string; All: integer);
    destructor Destroy; override;

    property EIndex: integer read FEIndex;
    property Command: string read FCommand; // write FCommand;
    property Operations: string read FOperations; // write FOperations;
    property State: TExecuteCommandState read FState write FState;
    property Icon: TIcon read FIcon write FIcon;
    property All: integer read FAll;
    property Current: integer read FCurrent write FCurrent;
  end;

procedure RunApplication(Operation: TORunApplication; OText: string);
procedure PressKeyboard(Operation: TOPressKeyboard; OText: string);
procedure Mouse(Operation: TOMouse; OText: string);

implementation

{ TExecuteCommand }

constructor TExecuteCommand.Create(DB: TDataBase);
begin
  FDB := DB;
  FCS := TCriticalSection.Create;
  FEIndex := 0;
  FCommandInQueue := 0;
end;

destructor TExecuteCommand.Destroy;
begin
  FCS.Free;
  inherited;
end;

procedure TExecuteCommand.DoCreating(EIndex: integer; RCommand: TRemoteCommand;
  Operations: TOperations; RepeatPrevious: boolean);
var
  OWait: integer;
  OLine: string;
begin

  if Assigned(FOnCreating) then
  begin
    OLine := LineOperations(Operations, OWait);
    FOnCreating(EIndex, RCommand, OLine, OWait, RepeatPrevious);
  end;
end;

procedure TExecuteCommand.DoWaiting(EIndex: integer);
begin
  if Assigned(FOnWaiting) then
    FOnWaiting(EIndex);
end;

procedure TExecuteCommand.DoExecuting(EIndex: integer; Step: integer);
begin
  if Assigned(FOnExecuting) then
    FOnExecuting(EIndex, Step);
end;

procedure TExecuteCommand.DoExecuteEnd(EIndex: integer);
begin
  if Assigned(FOnExecuteEnd) then
    FOnExecuteEnd(EIndex);
end;

procedure TExecuteCommand.DoPreviousCommand(Operations: string);
begin
  if Assigned(FOnPreviousCommand) then
    FOnPreviousCommand(Operations);
end;

procedure TExecuteCommand.DoCommandInQueue(Queue: integer);
begin
  if Assigned(FOnCommandInQueue) then
    FOnCommandInQueue(Queue);
end;

procedure TExecuteCommand.Execute(RCommand: TRemoteCommand; RepeatPrevious: boolean = false);
var
  Operations: TOperations;
  ThreadExecute: TThreadExecuteCommand;
  TotalWait: integer;
begin

  // Повтор предыдущей команды
  if RCommand.RepeatPrevious and (FPrevRCommand <> nil) then
  begin
    Execute(TRemoteCommand(FPrevRCommand^), True);
    Exit;
  end;

  Operations := FDB.getOperation(RCommand.Command, TotalWait);
  SetPrevious(RCommand, LineOperations(Operations));

  if Length(Operations) > 0 then
  begin
    inc(FEIndex);
    DoCreating(FEIndex, RCommand, Operations, RepeatPrevious);

    // Если есть настройка и возможность выполнить операции в основном потоке, выполняем
    if FInCurrentThread and (TotalWait = 0) and (FCommandInQueue = 0) then
    begin
      ExecuteInCurrentThread(Operations);
    end
    else
    begin
      IncCommandInQueue;
      ThreadExecute := TThreadExecuteCommand.Create(FCS, FEIndex, Operations);
      ThreadExecute.OnWaiting := onThreadWaiting;
      ThreadExecute.OnExecuting := onThreadExecuting;
      ThreadExecute.OnTerminate := onThreadTerminate;
      ThreadExecute.FreeOnTerminate := True;
      ThreadExecute.Priority := tpLower;
      ThreadExecute.Start;
    end;
  end;

end;

procedure TExecuteCommand.ExecuteInCurrentThread(Operations: TOperations);
var
  i: integer;
begin
  for i := 0 to Length(Operations) - 1 do
  begin
    case Operations[i].OType of
      opApplication:
        RunApplication(Operations[i].RunApplication, Operations[i].Operation);
      opKyeboard:
        PressKeyboard(Operations[i].PressKeyboard, Operations[i].Operation);
      opMouse:
        Mouse(Operations[i].Mouse, Operations[i].Operation);
    end;
  end;
  DoExecuteEnd(FEIndex);
end;

procedure TExecuteCommand.onThreadWaiting(EIndex: integer);
begin
  DoWaiting(EIndex);
end;

procedure TExecuteCommand.onThreadExecuting(EIndex: integer; Step: integer);
begin
  DoExecuting(EIndex, Step);
end;

procedure TExecuteCommand.onThreadTerminate(Sender: TObject);
begin
  DecCommandInQueue;
  DoExecuteEnd(TThreadExecuteCommand(Sender).FEIndex);
end;

procedure TExecuteCommand.IncCommandInQueue;
begin
  inc(FCommandInQueue);
  DoCommandInQueue(FCommandInQueue);
end;

procedure TExecuteCommand.DecCommandInQueue;
begin
  dec(FCommandInQueue);
  if FCommandInQueue < 0 then
    FCommandInQueue := 0;

  DoCommandInQueue(FCommandInQueue);
end;

procedure TExecuteCommand.SetInCurrentThread(const Value: boolean);
begin
  FInCurrentThread := Value;
end;

procedure TExecuteCommand.SetPrevious(RCommand: TRemoteCommand; Operations: string);
begin
  if RCommand.LongPress then
  begin
    if FPrevRCommand = nil then
      New(FPrevRCommand);
    FPrevRCommand^ := RCommand;
    DoPreviousCommand(Operations);
  end
  else
    ClearPrevious;
end;

function TExecuteCommand.LineOperations(Operations: TOperations; var OWait: integer): string;
var
  i: integer;

  function OperationLine(O: TOperation): string;
  begin
    Result := inttostr(O.OSort) + ': ' + O.Operation;
    if O.OWait > 0 then
      Result := Result + ' (' + floattostr(O.OWait / 1000) + ' c.)'
  end;

begin
  case Length(Operations) of
    0:
      begin

      end;
    1:
      begin
        Result := Operations[0].Operation;
        OWait := Operations[0].OWait;
        if Operations[0].OWait > 0 then
          Result := Result + ' (' + floattostr(Operations[0].OWait / 1000) + ' c.)'
      end;
  else
    begin
      Result := OperationLine(Operations[0]);
      OWait := Operations[0].OWait;
      for i := 1 to Length(Operations) - 1 do
      begin
        OWait := OWait + Operations[i].OWait;
        Result := Result + #13#10 + OperationLine(Operations[i]);
      end;
    end;
  end;

end;

function TExecuteCommand.LineOperations(Operations: TOperations): string;
var
  OWait: integer;
begin
  Result := LineOperations(Operations, OWait);
end;

procedure TExecuteCommand.ClearPrevious;
begin
  if FPrevRCommand <> nil then
  begin
    Dispose(FPrevRCommand);
    FPrevRCommand := nil;
  end;
  DoPreviousCommand('');
end;

{ TThreadExecuteCommand }

constructor TThreadExecuteCommand.Create(var CriticalSection: TCriticalSection; EIndex: integer;
  Operations: TOperations);
begin
  Create(True);
  FCS := CriticalSection;
  FEIndex := EIndex;
  FOperations := Operations;
end;

destructor TThreadExecuteCommand.Destroy;
begin

  inherited;
end;

procedure TThreadExecuteCommand.DoWaiting(EIndex: integer);
begin
  if Assigned(FOnWaiting) then
    FOnWaiting(EIndex);
end;

procedure TThreadExecuteCommand.DoExecuting(EIndex: integer; Step: integer);
begin
  if Assigned(FOnExecuting) then
    FOnExecuting(EIndex, Step);
end;

procedure TThreadExecuteCommand.Execute;
var
  i, sl, slAll: integer;
begin
  // Если TryEnter = true, метод Enter выполняется сам внутри (если я правильно понял)
  if not FCS.TryEnter then
  begin
    DoWaiting(FEIndex);
    FCS.Enter;
  end;

  sl := 0;
  slAll := 0;

  try
    for i := 0 to Length(FOperations) - 1 do
    begin

      // задержка перед выполнением
      if FOperations[i].OWait > 0 then
      begin
        sl := 0;
        while sl < FOperations[i].OWait do
        begin
          sleep(100);
          sl := sl + 100;
          DoExecuting(FEIndex, slAll + sl);
        end;
      end;
      slAll := slAll + FOperations[i].OWait;

      case FOperations[i].OType of
        opApplication:
          RunApplication(FOperations[i].RunApplication, FOperations[i].Operation);
        opKyeboard:
          PressKeyboard(FOperations[i].PressKeyboard, FOperations[i].Operation);
        opMouse:
          Mouse(FOperations[i].Mouse, FOperations[i].Operation);
      end;
    end;
  finally
    FCS.Leave;
  end;
end;

procedure Mouse(Operation: TOMouse; OText: string);
var
  KeyInputs: array of TInput;
  FileName: string;
begin

  if (Length(Operation.ForApplication) > 0) and FileExists(Operation.ForApplication) then
  begin
    // текущее актуальное приложение
    try
      FileName := uShellApplication.GetExePath(GetForegroundWindow);
      if FileName <> Operation.ForApplication then
        Exit;
    except
      on E: Exception do
    end;
  end;

  case Operation.Event of
    meMoveMouse:
      begin
        SetLength(KeyInputs, Length(KeyInputs) + 1);
        KeyInputs[Length(KeyInputs) - 1].Itype := INPUT_MOUSE;
        KeyInputs[Length(KeyInputs) - 1].mi.dx := Operation.X;
        KeyInputs[Length(KeyInputs) - 1].mi.dy := Operation.Y;
        KeyInputs[Length(KeyInputs) - 1].mi.dwFlags := MOUSEEVENTF_MOVE;
        KeyInputs[Length(KeyInputs) - 1].mi.time := 0;
        KeyInputs[Length(KeyInputs) - 1].mi.dwExtraInfo := 0;
      end;
    meLeftCLick:
      begin
        SetLength(KeyInputs, Length(KeyInputs) + 1);
        KeyInputs[Length(KeyInputs) - 1].Itype := INPUT_MOUSE;
        KeyInputs[Length(KeyInputs) - 1].mi.dwFlags := MOUSEEVENTF_LEFTDOWN;
        KeyInputs[Length(KeyInputs) - 1].mi.time := 0;
        KeyInputs[Length(KeyInputs) - 1].mi.dwExtraInfo := 0;

        SetLength(KeyInputs, Length(KeyInputs) + 1);
        KeyInputs[Length(KeyInputs) - 1].Itype := INPUT_MOUSE;
        KeyInputs[Length(KeyInputs) - 1].mi.dwFlags := MOUSEEVENTF_LEFTUP;
        KeyInputs[Length(KeyInputs) - 1].mi.time := 0;
        KeyInputs[Length(KeyInputs) - 1].mi.dwExtraInfo := 0;
      end;
    meRightCLick:
      begin
        SetLength(KeyInputs, Length(KeyInputs) + 1);
        KeyInputs[Length(KeyInputs) - 1].Itype := INPUT_MOUSE;
        KeyInputs[Length(KeyInputs) - 1].mi.dwFlags := MOUSEEVENTF_RIGHTDOWN;
        KeyInputs[Length(KeyInputs) - 1].mi.time := 0;
        KeyInputs[Length(KeyInputs) - 1].mi.dwExtraInfo := 0;

        SetLength(KeyInputs, Length(KeyInputs) + 1);
        KeyInputs[Length(KeyInputs) - 1].Itype := INPUT_MOUSE;
        KeyInputs[Length(KeyInputs) - 1].mi.dwFlags := MOUSEEVENTF_RIGHTUP;
        KeyInputs[Length(KeyInputs) - 1].mi.time := 0;
        KeyInputs[Length(KeyInputs) - 1].mi.dwExtraInfo := 0;
      end;
    meScrollWheel:
      begin
        SetLength(KeyInputs, Length(KeyInputs) + 1);
        KeyInputs[Length(KeyInputs) - 1].Itype := INPUT_MOUSE;
        KeyInputs[Length(KeyInputs) - 1].mi.mouseData := Operation.Wheel;
        KeyInputs[Length(KeyInputs) - 1].mi.dwFlags := MOUSEEVENTF_WHEEL;
        KeyInputs[Length(KeyInputs) - 1].mi.time := 0;
        KeyInputs[Length(KeyInputs) - 1].mi.dwExtraInfo := 0;
      end;
    meWheelClick:
      begin
        SetLength(KeyInputs, Length(KeyInputs) + 1);
        KeyInputs[Length(KeyInputs) - 1].Itype := INPUT_MOUSE;
        KeyInputs[Length(KeyInputs) - 1].mi.dwFlags := MOUSEEVENTF_MIDDLEDOWN;
        KeyInputs[Length(KeyInputs) - 1].mi.time := 0;
        KeyInputs[Length(KeyInputs) - 1].mi.dwExtraInfo := 0;

        SetLength(KeyInputs, Length(KeyInputs) + 1);
        KeyInputs[Length(KeyInputs) - 1].Itype := INPUT_MOUSE;
        KeyInputs[Length(KeyInputs) - 1].mi.dwFlags := MOUSEEVENTF_MIDDLEUP;
        KeyInputs[Length(KeyInputs) - 1].mi.time := 0;
        KeyInputs[Length(KeyInputs) - 1].mi.dwExtraInfo := 0;
      end;
  end;

  SendInput(Length(KeyInputs), KeyInputs[0], SizeOf(TInput));
end;

procedure PressKeyboard(Operation: TOPressKeyboard; OText: string);
var
  i, len, si: integer;
  KeyInputs: array of TInput;
  FileName: string;

  procedure keyDown(Key: integer);
  begin
    if Key <> 0 then
    begin
      SetLength(KeyInputs, Length(KeyInputs) + 1);
      KeyInputs[Length(KeyInputs) - 1].Itype := INPUT_KEYBOARD;

      KeyInputs[Length(KeyInputs) - 1].ki.wVk := Key;
      KeyInputs[Length(KeyInputs) - 1].ki.wScan := 0; // MapVirtualKey(Key, 0);
      KeyInputs[Length(KeyInputs) - 1].ki.time := 0;
      KeyInputs[Length(KeyInputs) - 1].ki.dwExtraInfo := 0;

      if Key in ExtendedKeys then
        KeyInputs[Length(KeyInputs) - 1].ki.dwFlags := KEYEVENTF_EXTENDEDKEY;
    end;
  end;

begin

  if (Length(Operation.ForApplication) > 0) and FileExists(Operation.ForApplication) then
  begin
    // текущее актуальное приложение
    try
      FileName := uShellApplication.GetExePath(GetForegroundWindow);
      if FileName <> Operation.ForApplication then
        Exit;
    except
      on E: Exception do
    end;
  end;

  // Нажимаю кнопки
  keyDown(Operation.Key1);
  keyDown(Operation.Key2);
  keyDown(Operation.Key3);

  // Отпускаю кнопки в обратной последовательности
  len := Length(KeyInputs) - 1;
  for i := len downto 0 do
  begin
    SetLength(KeyInputs, Length(KeyInputs) + 1);
    KeyInputs[Length(KeyInputs) - 1] := KeyInputs[i];
    KeyInputs[Length(KeyInputs) - 1].ki.dwFlags := KeyInputs[Length(KeyInputs) - 1].ki.dwFlags or
      KEYEVENTF_KEYUP;
  end;

  si := SendInput(Length(KeyInputs), KeyInputs[0], SizeOf(TInput));
end;

procedure RunApplication(Operation: TORunApplication; OText: string);
var
  Rlst: LongBool;
  Application: PWideChar;
  StartUpInfo: TStartUpInfo;
  ProcessInfo: TProcessInformation;
  FileName: string;
begin
  FileName := Operation.Application;
  if (Length(FileName) > 0) and FileExists(FileName) then
  begin
    Application := PWideChar(WideString(FileName));
    FillChar(StartUpInfo, SizeOf(TStartUpInfo), 0);
    StartUpInfo.cb := SizeOf(TStartUpInfo);
    StartUpInfo.dwFlags := STARTF_USESHOWWINDOW or STARTF_FORCEONFEEDBACK;
    StartUpInfo.wShowWindow := SW_SHOWNORMAL;
    Rlst := CreateProcess(Application, nil, nil, nil, false, NORMAL_PRIORITY_CLASS, nil, nil,
      StartUpInfo, ProcessInfo);
    if Rlst then
    begin
      WaitForInputIdle(ProcessInfo.hProcess, INFINITE); // ждем завершения инициализации
      CloseHandle(ProcessInfo.hThread); // закрываем дескриптор процесса
      CloseHandle(ProcessInfo.hProcess); // закрываем дескриптор потока

      // DoRunApplication(Operation, OText);
    end
    else
      raise Exception.Create(Format(GetLanguageMsg('msgExecuteCommandRunApplication', lngRus),
        [SysErrorMessage(GetLastError)]));
  end;
end;

{ TObjectRemoteCommand }

constructor TObjectRemoteCommand.Create(EIndex: integer; Command, Operations: string; All: integer);
begin
  Self.FEIndex := EIndex;
  Self.FCommand := Command;
  Self.FOperations := Operations;
  Self.FState := ecCreating;
  Self.FIcon := TIcon.Create();
  Self.FAll := All;
end;

destructor TObjectRemoteCommand.Destroy;
begin
  Self.FIcon.Free;
end;

end.
