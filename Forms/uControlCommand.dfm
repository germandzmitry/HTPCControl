object ControlCommand: TControlCommand
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ControlCommand'
  ClientHeight = 234
  ClientWidth = 442
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lCCCommand: TLabel
    Left = 8
    Top = 8
    Width = 63
    Height = 13
    Caption = 'lCCCommand'
  end
  object lCCDescription: TLabel
    Left = 8
    Top = 27
    Width = 69
    Height = 13
    Caption = 'lCCDescription'
  end
end
