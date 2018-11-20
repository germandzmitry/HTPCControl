unit uTypes;

interface

const
  FileSetting = 'Setting.ini';

type
  TopType = (opKyeboard, opApplication, opMouse);
  TuiType = (uiAnimation, uiIcon, uiNone);

type
  TReadComPort = Record
    Command: string;
    Desc: string;
    Exists: boolean;
  End;

  PReadComPortData = ^TReadComPort;

implementation

end.
