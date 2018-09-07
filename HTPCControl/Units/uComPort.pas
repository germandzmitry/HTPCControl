unit uComPort;

interface

uses Winapi.Windows, System.SysUtils, System.Classes;

type

  TReadDataEvent = procedure(Sender: TObject; const Data: string) of object;

  TComEvent = (evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD,
    evRx80Full);
  TComEvents = set of TComEvent;

  // типы асинхронных вызовов
  TOperationKind = (okWrite, okRead);

  TAsync = record
    Overlapped: TOverlapped;
    Kind: TOperationKind;
    Data: Pointer;
    Size: Integer;
  end;

  PAsync = ^TAsync;

  TComPort = class;

  // поток мониторинга порта
  TComThread = class(TThread)
  private
    FComPort: TComPort;
    FStopEvent: THandle;
    FEvents: TComEvents;
    FReadData: string;
  protected
    procedure Execute; override;
    procedure Stop;
    function EventsToInt(const Events: TComEvents): Integer;
    function IntToEvents(Mask: Integer): TComEvents;
  public
    constructor Create(AComPort: TComPort);
    destructor Destroy; override;
  end;

  TComPort = class
    function Open(): boolean;
    function Close(): boolean;
    function WriteStr(Str: string): Integer;
  private
    FEventThread: TComThread;
    FThreadCreated: boolean;
    FPort: string;
    FHandle: NativeUInt;
    FConnected: boolean;
    FBufferInputSize: Integer;
    FBufferOutputSize: Integer;
    FEvents: TComEvents;

    FOnAfterOpen: TNotifyEvent;
    FOnAfterClose: TNotifyEvent;
    FOnReadData: TReadDataEvent;
  protected
    procedure CreateHandle; virtual;
    procedure DestroyHandle; virtual;
    procedure SetupComPort; virtual;
    procedure ApplyDCB; dynamic;
    procedure ApplyTimeouts; dynamic;
    procedure ApplyBuffer; dynamic;
    procedure InitAsync(var AsyncPtr: PAsync);
    procedure DoneAsync(var AsyncPtr: PAsync);
    function WaitForAsync(var AsyncPtr: PAsync): Integer;

    function Read(var Buffer; Count: Integer): Integer;
    function ReadStr(var Str: string; Count: Integer): Integer;
    function ReadAsync(var Buffer; Count: Integer; var AsyncPtr: PAsync): Integer;
    function ReadStrAsync(var Str: Ansistring; Count: Integer; var AsyncPtr: PAsync): Integer;
    function WriteAsync(const Buffer; Count: Integer; var AsyncPtr: PAsync): Integer;
    function WriteStrAsync(var Str: string; var AsyncPtr: PAsync): Integer;

    procedure DoReadData; dynamic;
    procedure DoAfterOpen; dynamic;
    procedure DoAfterClose; dynamic;
  public
    constructor Create(Port: string);
    destructor Destroy;
    procedure ClearBuffer(Input, Output: boolean);
    procedure AbortAllAsync;

    property Port: String read FPort;
    property Handle: NativeUInt read FHandle;
    property Connected: boolean read FConnected default False;
    property Events: TComEvents read FEvents write FEvents;
    property OnReadData: TReadDataEvent read FOnReadData write FOnReadData;

    property onAfterOpen: TNotifyEvent read FOnAfterOpen write FOnAfterOpen;
    property onAfterClose: TNotifyEvent read FOnAfterClose write FOnAfterClose;
  end;

procedure EnumComPorts(Ports: TStrings);
procedure EnumComPortsSpeed(Speed: TStrings);

implementation

procedure EnumComPorts(Ports: TStrings);
var
  KeyHandle: HKEY;
  ErrCode, Index: Integer;
  ValueName, Data: string;
  ValueLen, DataLen, ValueType: DWORD;
  TmpPorts: TStringList;
begin
  ErrCode := RegOpenKeyEx(HKEY_LOCAL_MACHINE, 'HARDWARE\DEVICEMAP\SERIALCOMM', 0, KEY_READ,
    KeyHandle);

  if ErrCode <> ERROR_SUCCESS then
    exit;

  TmpPorts := TStringList.Create;
  try
    Index := 0;
    repeat
      ValueLen := 256;
      DataLen := 256;
      SetLength(ValueName, ValueLen);
      SetLength(Data, DataLen);
      ErrCode := RegEnumValue(KeyHandle, Index, PChar(ValueName), Cardinal(ValueLen), nil,
        @ValueType, PByte(PChar(Data)), @DataLen);

      if ErrCode = ERROR_SUCCESS then
      begin
        SetLength(Data, DataLen - 1);
        TmpPorts.Add(Data);
        Inc(Index);
      end
      else if ErrCode <> ERROR_NO_MORE_ITEMS then
        break;

    until (ErrCode <> ERROR_SUCCESS);

    TmpPorts.Sort;
    Ports.Assign(TmpPorts);
  finally
    RegCloseKey(KeyHandle);
    TmpPorts.Free;
  end;
end;

procedure EnumComPortsSpeed(Speed: TStrings);
begin
  Speed.Add('75');
  Speed.Add('110');
  Speed.Add('134');
  Speed.Add('150');
  Speed.Add('300');
  Speed.Add('600');
  Speed.Add('1200');
  Speed.Add('1800');
  Speed.Add('2400');
  Speed.Add('4800');
  Speed.Add('7200');
  Speed.Add('9600');
  Speed.Add('14400');
  Speed.Add('19200');
  Speed.Add('38400');
  Speed.Add('57600');
  Speed.Add('115200');
  Speed.Add('128000');
end;

{ TComThread }

constructor TComThread.Create(AComPort: TComPort);
begin
  inherited Create(False);
  FStopEvent := CreateEvent(nil, True, False, nil);
  FComPort := AComPort;
  Priority := tpNormal;
  FReadData := '';
  // Перевод порта в режим приема данных
  SetCommMask(FComPort.Handle, EventsToInt(FComPort.Events));
end;

destructor TComThread.Destroy;
begin
  Stop;
  inherited;
end;

{ procedure TComThread.Execute;
  var
  EventHandles: array [0 .. 1] of THandle;
  Overlapped: TOverlapped;
  Signaled, BytesTrans, Mask: DWORD;

  Errors: DWORD;
  ComStat: TComStat;
  Buffer: String;
  ReadBytes, i: Integer;
  begin
  FillChar(Overlapped, SizeOf(Overlapped), 0);
  Overlapped.hEvent := CreateEvent(nil, True, True, nil);

  EventHandles[0] := FStopEvent;
  EventHandles[1] := Overlapped.hEvent;

  repeat
  WaitCommEvent(FComPort.Handle, Mask, @Overlapped);
  Signaled := WaitForMultipleObjects(2, @EventHandles, False, INFINITE);
  if (Signaled = WAIT_OBJECT_0 + 1) and GetOverlappedResult(FComPort.Handle, Overlapped,
  BytesTrans, False) then
  begin
  FEvents := IntToEvents(Mask);

  FillChar(Buffer, SizeOf(Buffer), 0);
  ClearCommError(FComPort.Handle, Errors, @ComStat);
  ReadBytes := FComPort.ReadStr(Buffer, ComStat.cbInQue);
  FReadData := FReadData + Buffer;

  if evRxFlag in FEvents then
  begin
  Synchronize(FComPort.DoReadData);
  FReadData := '';
  end;
  end;

  until Signaled <> (WAIT_OBJECT_0 + 1);

  SetCommMask(FComPort.Handle, 0);
  PurgeComm(FComPort.Handle, PURGE_TXCLEAR or PURGE_RXCLEAR);
  CloseHandle(Overlapped.hEvent);
  CloseHandle(FStopEvent);
  end; }

procedure TComThread.Execute;
var
  EventHandles: array [0 .. 1] of THandle;
  Overlapped: TOverlapped;
  Signaled, BytesTrans, Mask: DWORD;

  Errors: DWORD;
  ComStat: TComStat;
  Buffer: array [1 .. 20] of byte;
  ReadBytes, i: Integer;
begin
  FillChar(Overlapped, SizeOf(Overlapped), 0);
  Overlapped.hEvent := CreateEvent(nil, True, True, nil);

  EventHandles[0] := FStopEvent;
  EventHandles[1] := Overlapped.hEvent;

  repeat
    WaitCommEvent(FComPort.Handle, Mask, @Overlapped);
    Signaled := WaitForMultipleObjects(2, @EventHandles, False, INFINITE);
    if (Signaled = WAIT_OBJECT_0 + 1) and GetOverlappedResult(FComPort.Handle, Overlapped,
      BytesTrans, False) then
    begin
      FEvents := IntToEvents(Mask);

      FillChar(Buffer, SizeOf(Buffer), 0);
      ClearCommError(FComPort.Handle, Errors, @ComStat);
      ReadBytes := FComPort.Read(Buffer, ComStat.cbInQue);

      for i := 1 to ReadBytes do
        if (Buffer[i] <> 10) and (Buffer[i] <> 13) then
          FReadData := FReadData + chr(Buffer[i]);

      if evRxFlag in FEvents then
      begin
        Synchronize(FComPort.DoReadData);
        FReadData := '';
      end;
    end;

  until Signaled <> (WAIT_OBJECT_0 + 1);

  SetCommMask(FComPort.Handle, 0);
  PurgeComm(FComPort.Handle, PURGE_TXCLEAR or PURGE_RXCLEAR);
  CloseHandle(Overlapped.hEvent);
  CloseHandle(FStopEvent);
end;

procedure TComThread.Stop;
begin
  SetEvent(FStopEvent);
  Sleep(0);
end;

function TComThread.EventsToInt(const Events: TComEvents): Integer;
begin
  Result := 0;
  if evRxChar in Events then
    Result := Result or EV_RXCHAR;
  if evRxFlag in Events then
    Result := Result or EV_RXFLAG;
  if evTxEmpty in Events then
    Result := Result or EV_TXEMPTY;
  if evRing in Events then
    Result := Result or EV_RING;
  if evCTS in Events then
    Result := Result or EV_CTS;
  if evDSR in Events then
    Result := Result or EV_DSR;
  if evRLSD in Events then
    Result := Result or EV_RLSD;
  if evError in Events then
    Result := Result or EV_ERR;
  if evBreak in Events then
    Result := Result or EV_BREAK;
  if evRx80Full in Events then
    Result := Result or EV_RX80FULL;
end;

function TComThread.IntToEvents(Mask: Integer): TComEvents;
begin
  Result := [];
  if (EV_RXCHAR and Mask) <> 0 then
    Result := Result + [evRxChar];
  if (EV_TXEMPTY and Mask) <> 0 then
    Result := Result + [evTxEmpty];
  if (EV_BREAK and Mask) <> 0 then
    Result := Result + [evBreak];
  if (EV_RING and Mask) <> 0 then
    Result := Result + [evRing];
  if (EV_CTS and Mask) <> 0 then
    Result := Result + [evCTS];
  if (EV_DSR and Mask) <> 0 then
    Result := Result + [evDSR];
  if (EV_RXFLAG and Mask) <> 0 then
    Result := Result + [evRxFlag];
  if (EV_RLSD and Mask) <> 0 then
    Result := Result + [evRLSD];
  if (EV_ERR and Mask) <> 0 then
    Result := Result + [evError];
  if (EV_RX80FULL and Mask) <> 0 then
    Result := Result + [evRx80Full];
end;

{ TComPort }

constructor TComPort.Create(Port: string);
begin
  FPort := Port;
  FHandle := INVALID_HANDLE_VALUE;
  FConnected := False;
  FBufferInputSize := 1024;
  FBufferOutputSize := 1024;
  FEvents := [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD,
    evRx80Full];
end;

destructor TComPort.Destroy;
begin
  { if FConnected then
    DestroyHandle; }
  Close;
  inherited Destroy;
end;

procedure TComPort.ClearBuffer(Input, Output: boolean);
var
  Flag: DWORD;
begin
  Flag := 0;
  if Input then
    Flag := PURGE_RXCLEAR;
  if Output then
    Flag := Flag or PURGE_TXCLEAR;

  if not PurgeComm(FHandle, Flag) then
    raise Exception.Create('Ошибка очистки буфера: ' + SysErrorMessage(GetLastError));
end;

procedure TComPort.AbortAllAsync;
begin
  if not PurgeComm(FHandle, PURGE_TXABORT or PURGE_RXABORT) then
    raise Exception.Create('Ошибка отмены всех задач: ' + SysErrorMessage(GetLastError));
end;

procedure TComPort.CreateHandle;
begin
  FHandle := CreateFile(PChar('\\.\' + FPort), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING,
    FILE_FLAG_OVERLAPPED, 0);

  if FHandle = INVALID_HANDLE_VALUE then
    raise Exception.Create('Ошибка открытия COM порта: ' + SysErrorMessage(GetLastError));
end;

procedure TComPort.DestroyHandle;
begin
  if FHandle <> INVALID_HANDLE_VALUE then
  begin
    if CloseHandle(FHandle) then
      FHandle := INVALID_HANDLE_VALUE;
  end;
end;

function TComPort.Open: boolean;
begin
  // Если соединеие уже установленно, ничего не делаем
  if not FConnected then
  begin
    // открытие порта
    CreateHandle;
    FConnected := True;
    try
      // Параметры порта
      SetupComPort;
      // Очистка буфера порта
      ClearBuffer(True, True);
    except
      DestroyHandle;
      FConnected := False;
      raise;
    end;

    FEventThread := TComThread.Create(Self);
    FThreadCreated := True;

    DoAfterOpen;
  end;
end;

function TComPort.Close: boolean;
begin
  if FConnected then
  begin
    AbortAllAsync;
    // Остановка потока
    if FThreadCreated then
    begin
      // Очистка буфера порта
      ClearBuffer(True, True);
      FEventThread.Free;
      // Sleep(2000);
      FThreadCreated := False;
    end;
    // Закрытие порта
    DestroyHandle;
    FConnected := False;

    DoAfterClose;
  end;
end;

procedure TComPort.ApplyBuffer;
begin
  if FConnected then
    if not SetupComm(FHandle, FBufferInputSize, FBufferOutputSize) then
      raise Exception.Create('Ошибка установки буфера: ' + SysErrorMessage(GetLastError));
end;

procedure TComPort.ApplyDCB;
var
  Dcb: TDcb;
begin
  if FConnected then
  begin
    FillChar(Dcb, SizeOf(Dcb), 0);
    if not GetCommState(FHandle, Dcb) then
      raise Exception.Create('Ошибка чтения параметров COM порта: ' +
        SysErrorMessage(GetLastError));

    // Dcb.DCBlength := SizeOf(TDcb);
    // Dcb.XonLim := FBufferInputSize div 4;
    // Dcb.XoffLim := Dcb.XonLim;
    // Dcb.EvtChar := AnsiChar(FEventChar);
    // Dcb.Flags := $00000001;

    Dcb.BaudRate := CBR_9600;
    Dcb.Parity := NOPARITY;
    Dcb.ByteSize := 8;
    Dcb.StopBits := ONESTOPBIT;
    Dcb.EvtChar := chr(13);

    if not SetCommState(FHandle, Dcb) then
      raise Exception.Create('Ошибка установки параметров: ' + SysErrorMessage(GetLastError));
  end;
end;

procedure TComPort.ApplyTimeouts;
var
  Timeouts: TCommTimeouts;

  function GetTOValue(const Value: Integer): DWORD;
  begin
    if Value = -1 then
      Result := MAXDWORD
    else
      Result := Value;
  end;

begin
  if FConnected then
  begin
    // Timeouts.ReadIntervalTimeout := GetTOValue(50);
    // Timeouts.ReadTotalTimeoutMultiplier := GetTOValue(70);
    // Timeouts.ReadTotalTimeoutConstant := GetTOValue(100);
    // Timeouts.WriteTotalTimeoutMultiplier := GetTOValue(60);
    // Timeouts.WriteTotalTimeoutConstant := GetTOValue(100);

    // Timeouts.ReadIntervalTimeout := GetTOValue(20);
    // Timeouts.ReadTotalTimeoutMultiplier := GetTOValue(10);
    // Timeouts.ReadTotalTimeoutConstant := GetTOValue(100);
    // Timeouts.WriteTotalTimeoutMultiplier := GetTOValue(10);
    // Timeouts.WriteTotalTimeoutConstant := GetTOValue(100);

    // apply settings
    if not SetCommTimeouts(FHandle, Timeouts) then
      raise Exception.Create('Ошибка установки таймаутов: ' + SysErrorMessage(GetLastError));
  end;
end;

procedure TComPort.SetupComPort;
begin
  ApplyBuffer;
  ApplyDCB;
  ApplyTimeouts;
end;

function TComPort.Read(var Buffer; Count: Integer): Integer;
var
  AsyncPtr: PAsync;
begin
  InitAsync(AsyncPtr);
  try
    ReadAsync(Buffer, Count, AsyncPtr);
    Result := WaitForAsync(AsyncPtr);
  finally
    DoneAsync(AsyncPtr);
  end;
end;

function TComPort.ReadAsync(var Buffer; Count: Integer; var AsyncPtr: PAsync): Integer;
var
  Success: boolean;
  BytesTrans: DWORD;
begin
  if AsyncPtr = nil then
    raise Exception.Create('Неправильные параметры Async: ' + SysErrorMessage(GetLastError));

  AsyncPtr^.Kind := okRead;
  if FHandle = INVALID_HANDLE_VALUE then
    raise Exception.Create('Порт не открыт: ' + SysErrorMessage(GetLastError));

  Success := ReadFile(FHandle, Buffer, Count, BytesTrans, @AsyncPtr^.Overlapped) or
    (GetLastError = ERROR_IO_PENDING);

  if not Success then
    raise Exception.Create('Ошибка чтения: ' + SysErrorMessage(GetLastError));

  Result := BytesTrans;
end;

function TComPort.ReadStr(var Str: string; Count: Integer): Integer;
var
  AsyncPtr: PAsync;
  sa: Ansistring;
  i: Integer;
begin
  InitAsync(AsyncPtr);
  try
    ReadStrAsync(sa, Count, AsyncPtr);
    Result := WaitForAsync(AsyncPtr);
    SetLength(sa, Result);
    SetLength(Str, Result);
{$IFDEF Unicode}
    if length(sa) > 0 then
      for i := 1 to length(sa) do
        Str[i] := char(byte(sa[i]))
{$ELSE}
    Str := sa;
{$ENDIF}
  finally
    DoneAsync(AsyncPtr);
  end;
end;

function TComPort.ReadStrAsync(var Str: Ansistring; Count: Integer; var AsyncPtr: PAsync): Integer;
begin
  SetLength(Str, Count);
  if Count > 0 then
    Result := ReadAsync(Str[1], Count, AsyncPtr)
  else
    Result := 0;
end;

function TComPort.WaitForAsync(var AsyncPtr: PAsync): Integer;
var
  BytesTrans, Signaled: DWORD;
  Success: boolean;
begin
  if AsyncPtr = nil then
    // raise EComPort.CreateNoWinCode
    raise Exception.Create('Неправильные параметры Async: ' + SysErrorMessage(GetLastError));

  Signaled := WaitForSingleObject(AsyncPtr^.Overlapped.hEvent, INFINITE);
  Success := (Signaled = WAIT_OBJECT_0) and
    (GetOverlappedResult(FHandle, AsyncPtr^.Overlapped, BytesTrans, False));

  if not Success then
    raise Exception.Create('Ошибка Async: ' + SysErrorMessage(GetLastError));

  Result := BytesTrans;
end;

// prepare PAsync variable for read/write operation
procedure PrepareAsync(AKind: TOperationKind; const Buffer; Count: Integer; AsyncPtr: PAsync);
begin
  with AsyncPtr^ do
  begin
    Kind := AKind;
    if Data <> nil then
      FreeMem(Data);
    GetMem(Data, Count);
    Move(Buffer, Data^, Count);
    Size := Count;
  end;
end;

function TComPort.WriteAsync(const Buffer; Count: Integer; var AsyncPtr: PAsync): Integer;
var
  Success: boolean;
  BytesTrans: DWORD;
begin
  if AsyncPtr = nil then
    raise Exception.Create('Неправильные параметры Async: ' + SysErrorMessage(GetLastError));

  if FHandle = INVALID_HANDLE_VALUE then
    raise Exception.Create('Порт не открыт: ' + SysErrorMessage(GetLastError));

  PrepareAsync(okWrite, Buffer, Count, AsyncPtr);

  Success := WriteFile(FHandle, Buffer, Count, BytesTrans, @AsyncPtr^.Overlapped) or
    (GetLastError = ERROR_IO_PENDING);

  if not Success then
    raise Exception.Create('Ошибка записи: ' + SysErrorMessage(GetLastError));

  Result := BytesTrans;
end;

function TComPort.WriteStr(Str: string): Integer;
var
  AsyncPtr: PAsync;
begin
  InitAsync(AsyncPtr);
  try
    WriteStrAsync(Str, AsyncPtr);
    Result := WaitForAsync(AsyncPtr);
  finally
    DoneAsync(AsyncPtr);
  end;
end;

function TComPort.WriteStrAsync(var Str: string; var AsyncPtr: PAsync): Integer;
var
  sa: Ansistring;
var
  i: Integer;
begin
  if length(Str) > 0 then
  begin
    SetLength(sa, length(Str));
{$IFDEF Unicode}
    if length(sa) > 0 then
    begin
      for i := 1 to length(Str) do
        sa[i] := ansichar(byte(Str[i]));
      Move(sa[1], Str[1], length(sa));
    end;
{$ENDIF}
    Result := WriteAsync(Str[1], length(Str), AsyncPtr)
  end
  else
    Result := 0;
end;

procedure TComPort.InitAsync(var AsyncPtr: PAsync);
begin
  New(AsyncPtr);
  with AsyncPtr^ do
  begin
    FillChar(Overlapped, SizeOf(TOverlapped), 0);
    Overlapped.hEvent := CreateEvent(nil, True, True, nil);
    Data := nil;
    Size := 0;
  end;
end;

procedure TComPort.DoAfterClose;
begin
  if Assigned(FOnAfterClose) then
    FOnAfterClose(Self);
end;

procedure TComPort.DoAfterOpen;
begin
  if Assigned(FOnAfterOpen) then
    FOnAfterOpen(Self);
end;

procedure TComPort.DoneAsync(var AsyncPtr: PAsync);
begin
  with AsyncPtr^ do
  begin
    CloseHandle(Overlapped.hEvent);
    if Data <> nil then
      FreeMem(Data);
  end;
  Dispose(AsyncPtr);
  AsyncPtr := nil;
end;

procedure TComPort.DoReadData;
begin
  if Assigned(FOnReadData) then
    FOnReadData(Self, FEventThread.FReadData);
end;

end.
