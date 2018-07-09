unit uEventKodi;

interface

uses
  System.Classes, System.SysUtils, uSuperObject, VCL.dialogs, VCL.graphics, VCL.forms, HTTPApp,
  IdHTTP;

const
  NoPlayer: integer = -1;

type
  TKodiPlayerEvent = procedure(Player: string) of object;
  TKodiPlayerStateEvent = procedure(Player, State: string) of object;

type
  TKodi = class(TThread)
  private
    FHTTP: TIdHTTP;
    FIP: string;
    FPort: integer;
    FUser, FPassword: string;
    FErrorResponse: integer;

    FOnPlayer: TKodiPlayerEvent;
    FOnPlayerState: TKodiPlayerStateEvent;

    function Quit(): boolean;
    function CurrentPlayer(var PlayerType: string): integer;
    function PlayerState(PlayerId: integer): integer;
    function httpGet(query: string): ISuperObject;

    procedure DoPlayer(Player: string); dynamic;
    procedure DoPlayerState(Player: string; State: integer); dynamic;
  protected
    procedure Execute; override;
    procedure DoTerminate; override;
  public
    constructor Create(IP: string; Port: integer; User, Password: string); overload;
    destructor Destroy; override;

    property OnPlayer: TKodiPlayerEvent read FOnPlayer write FOnPlayer;
    property OnPlayerState: TKodiPlayerStateEvent read FOnPlayerState write FOnPlayerState;
  end;

implementation

{ TKodi }

constructor TKodi.Create(IP: string; Port: integer; User, Password: string);
begin
  Create(False);

  FHTTP := TIdHTTP.Create();
  FHTTP.AllowCookies := true;
  FHTTP.Request.Accept := 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8';

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
        strState := 'Play'
    end;
    FOnPlayerState(Player, strState);
  end;
end;

procedure TKodi.DoTerminate;
begin
  inherited;
end;

procedure TKodi.Execute;
var
  PrevPlayerState, PlayerState: integer;
  PrevPlayerId, PlayerId: integer;
  PlayerType: string;
begin
  PrevPlayerState := -1;
  PlayerState := -1;
  PrevPlayerId := NoPlayer;
  PlayerId := NoPlayer;
  PlayerType := '';

  // что бы приложение успело загрузиться
  // Sleep(5000);

  FreeOnTerminate := true;

  while not Terminated do
  begin
    Sleep(5000);

    if Quit then
    begin
      Terminate;
      Continue;
    end;

    PlayerId := CurrentPlayer(PlayerType);

    if (PlayerId = NoPlayer) and (PrevPlayerId <> PlayerId) then
      DoPlayer('none')
    else if PlayerId <> NoPlayer then
    begin
      // изменился плеер
      if PrevPlayerId <> PlayerId then
        DoPlayer(PlayerType);

      PlayerState := self.PlayerState(PlayerId);
      if PrevPlayerState <> PlayerState then
        DoPlayerState(PlayerType, PlayerState);
    end;

    PrevPlayerId := PlayerId;
    PrevPlayerState := PlayerState;

  end;
end;

function TKodi.Quit(): boolean;
var
  get, objResult: ISuperObject;
begin
  Result := False;
  try
    get := httpGet('"XBMC.GetInfoBooleans","params":{"booleans":["System.OnQuit"]}');
    objResult := get.O['result'];
    if (objResult.AsBoolean = true) and (objResult.B['System.OnQuit'] = False) then
      Result := False
    else
      Result := true;

    FErrorResponse := 0;
  except
    on E: Exception do
    begin
      inc(FErrorResponse);
      if FErrorResponse = 3 then
        Result := true;
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
