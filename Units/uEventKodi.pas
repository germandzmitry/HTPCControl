unit uEventKodi;

interface

uses
  System.Classes, System.SysUtils, uSuperObject, VCL.dialogs, VCL.graphics, VCL.forms, HTTPApp,
  IdHTTP;

const
  NoPlayer: integer = -1;

type
  TKodiRunningEvent = procedure(Running: boolean) of object;
  TKodiPlayerEvent = procedure(Player: string) of object;
  TKodiPlayerStateEvent = procedure(Player, State: string) of object;

type
  TKodi = class(TThread)
  private
    FHTTP: TIdHTTP;
    FUpdateInterval: integer;
    FIP: string;
    FPort: integer;
    FUser, FPassword: string;
    FErrorResponse: integer;

    FOnRunning: TKodiRunningEvent;
    FOnPlayer: TKodiPlayerEvent;
    FOnPlayerState: TKodiPlayerStateEvent;

    function Quit(var Error: boolean): boolean;
    function CurrentPlayer(var PlayerType: string): integer;
    function PlayerState(PlayerId: integer): integer;
    function httpGet(query: string): ISuperObject;

    procedure DoRunning(Running: boolean); dynamic;
    procedure DoPlayer(Player: string); dynamic;
    procedure DoPlayerState(Player: string; State: integer); dynamic;
  protected
    procedure Execute; override;
    procedure DoTerminate; override;
  public
    constructor Create(UpdateInterval: integer; IP: string; Port: integer;
      User, Password: string); overload;
    destructor Destroy; override;

    property OnRunning: TKodiRunningEvent read FOnRunning write FOnRunning;
    property OnPlayer: TKodiPlayerEvent read FOnPlayer write FOnPlayer;
    property OnPlayerState: TKodiPlayerStateEvent read FOnPlayerState write FOnPlayerState;
  end;

implementation

{ TKodi }

constructor TKodi.Create(UpdateInterval: integer; IP: string; Port: integer;
  User, Password: string);
begin
  Create(False);

  FHTTP := TIdHTTP.Create();
  FHTTP.AllowCookies := True;
  FHTTP.Request.Accept := 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';

  FUpdateInterval := UpdateInterval * 1000;
  FIP := IP;
  FPort := Port;
  FUser := User;
  FPassword := Password;

  FErrorResponse := 0;
end;

destructor TKodi.Destroy;
begin
  FHTTP.Free;
  inherited;
end;

procedure TKodi.DoPlayer(Player: string);
begin
  if Assigned(FOnPlayer) then
    FOnPlayer(Player);
end;

procedure TKodi.DoPlayerState(Player: string; State: integer);
var
  strState: string;
begin
  if Assigned(FOnPlayerState) then
  begin
    case State of
      0:
        strState := 'Pause';
      1:
        strState := 'Play';
    else
      strState := inttostr(State);
    end;
    FOnPlayerState(Player, strState);
  end;
end;

procedure TKodi.DoRunning(Running: boolean);
begin
  if Assigned(FOnRunning) then
    FOnRunning(Running);
end;

procedure TKodi.DoTerminate;
begin
  DoRunning(False);
  inherited;
end;

procedure TKodi.Execute;
var
  prevPlayerState, PlayerState: integer;
  prevPlayerId, PlayerId: integer;
  PlayerType: string;
  quitError: boolean;
begin
  prevPlayerState := -1;
  PlayerState := -1;
  prevPlayerId := NoPlayer;
  PlayerId := NoPlayer;
  PlayerType := '';
  quitError := False;

  // что бы приложение успело загрузиться
  // Sleep(5000);

  DoRunning(True);

  FreeOnTerminate := True;

  while not Terminated do
  begin
    Sleep(FUpdateInterval);

    if Quit(quitError) then
    begin
      Terminate;
      Continue;
    end;

    if quitError then
      Continue;

    PlayerId := CurrentPlayer(PlayerType);

    if (PlayerId = NoPlayer) and (prevPlayerId <> PlayerId) then
    begin
      Synchronize(
        procedure
        begin
          DoPlayer('none');
        end);
      PlayerState := -1;
    end
    else if PlayerId <> NoPlayer then
    begin
      // изменился плеер
      if prevPlayerId <> PlayerId then
        Synchronize(
          procedure
          begin
            DoPlayer(PlayerType);
          end);

      PlayerState := self.PlayerState(PlayerId);
      // изменилось состояние плеера
      if prevPlayerState <> PlayerState then
        Synchronize(
          procedure
          begin
            DoPlayerState(PlayerType, PlayerState);
          end);
    end;

    prevPlayerId := PlayerId;
    prevPlayerState := PlayerState;

  end;
end;

function TKodi.Quit(var Error: boolean): boolean;
var
  get, objResult: ISuperObject;
begin
  Result := False;
  Error := False;
  try
    get := httpGet('"XBMC.GetInfoBooleans","params":{"booleans":["System.OnQuit"]}');
    objResult := get.O['result'];
    if (objResult.AsBoolean = True) and (objResult.B['System.OnQuit'] = False) then
      Result := False
    else
      Result := True;

    FErrorResponse := 0;
  except
    on E: Exception do
    begin
      Error := True;
      inc(FErrorResponse);
      if FErrorResponse = 3 then
        Result := True;
    end;
  end;
end;

function TKodi.CurrentPlayer(var PlayerType: string): integer;
var
  get, objResult: ISuperObject;
  ar: TSuperArray;
begin
  try
    get := httpGet('"Player.GetActivePlayers"');
    ar := get.A['result'];
    if ar.Length > 0 then
    begin
      objResult := ar.O[0];
      Result := objResult.i['playerid'];
      PlayerType := objResult.s['type'];
    end
    else
      Result := -1;
  except
    on E: Exception do
    begin
      PlayerType := '';
      Result := -1;
    end;
  end;

end;

function TKodi.PlayerState(PlayerId: integer): integer;
var
  get: ISuperObject;
begin
  Result := -1;
  try
    get := httpGet('"Player.GetProperties","params":{"playerid":' + inttostr(PlayerId) +
      ',"properties":["speed"]}');
    Result := get.O['result'].i['speed'];
  except
    on E: Exception do
      Result := -1;
  end;
end;

function TKodi.httpGet(query: string): ISuperObject;
var
  M: TStringStream;
  get: ISuperObject;
  str: string;
begin
  Result := nil;
  try
    M := TStringStream.Create('');
    str := 'http://' + FIP + ':' + inttostr(FPort) + '/jsonrpc?request={"jsonrpc":"2.0","method":' +
      query + ',"id":1}';
    FHTTP.get(str, M);
    get := so(M.DataString);
    M.Free;
    Result := get;
  except
    on E: Exception do
    begin
      M.Free;
      Result := nil;
      raise Exception.Create(E.Message);
    end;
  end;
end;

end.
