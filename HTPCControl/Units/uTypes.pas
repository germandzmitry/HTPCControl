unit uTypes;

interface

const
  FileSetting = 'Setting.ini';

type
  TopType = (opKyeboard, opApplication, opMouse);

type
  TReadComPort = Record
    Command: string;
    Desc: string;
    Exists: boolean;
  End;

  PReadComPortData = ^TReadComPort;

implementation

end.
