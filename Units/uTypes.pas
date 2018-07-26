unit uTypes;

interface

const
  FileSetting = 'Setting.ini';

type
  TecType = (ecKyeboard, ecApplication);

type
  TReadComPort = Record
    Command: string;
    Exists: boolean;
    Execute: boolean;
  End;

  PReadComPortData = ^TReadComPort;

implementation

end.
