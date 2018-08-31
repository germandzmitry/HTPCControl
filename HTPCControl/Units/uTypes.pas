unit uTypes;

interface

const
  FileSetting = 'Setting.ini';

type
  TopType = (opKyeboard, opApplication);

type
  TReadComPort = Record
    Command: string;
    Exists: boolean;
    Execute: boolean;
  End;

  PReadComPortData = ^TReadComPort;

implementation

end.
