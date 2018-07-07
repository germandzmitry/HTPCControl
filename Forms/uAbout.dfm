object About: TAbout
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
  ClientHeight = 79
  ClientWidth = 306
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lVersion: TLabel
    Left = 8
    Top = 33
    Width = 37
    Height = 13
    Caption = 'lVersion'
  end
  object lVersionDate: TLabel
    Left = 8
    Top = 52
    Width = 60
    Height = 13
    Caption = 'lVersionDate'
  end
  object lName: TLabel
    Left = 8
    Top = 8
    Width = 52
    Height = 19
    Caption = 'lName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
end
