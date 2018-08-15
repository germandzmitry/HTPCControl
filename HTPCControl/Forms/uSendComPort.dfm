object frmSendComPort: TfrmSendComPort
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'frmSendComPort'
  ClientHeight = 231
  ClientWidth = 456
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    456
    231)
  PixelsPerInch = 96
  TextHeight = 13
  object eSendText: TEdit
    Left = 8
    Top = 10
    Width = 359
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'eSendText'
    ExplicitWidth = 350
  end
  object btnSend: TButton
    Left = 373
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'btnSend'
    Default = True
    TabOrder = 1
    OnClick = btnSendClick
    ExplicitLeft = 364
  end
  object mSentText: TMemo
    Left = 8
    Top = 37
    Width = 440
    Height = 155
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'mSentText')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
    ExplicitHeight = 216
  end
  object cbSendTextEnd: TComboBox
    Left = 222
    Top = 200
    Width = 145
    Height = 21
    Style = csDropDownList
    Anchors = [akRight, akBottom]
    TabOrder = 3
    Items.Strings = (
      #1053#1077#1090' '#1082#1086#1085#1094#1072' '#1089#1090#1088#1086#1082#1080
      'NL ('#1053#1086#1074#1072#1103' '#1089#1090#1088#1086#1082#1072')'
      'CR ('#1042#1086#1079#1074#1088#1072#1090' '#1082#1072#1088#1077#1090#1082#1080')'
      'NL & CR')
    ExplicitTop = 261
  end
  object btnClose: TButton
    Left = 373
    Top = 198
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnClose'
    TabOrder = 4
    OnClick = btnCloseClick
    ExplicitTop = 259
  end
  object cbClearSendText: TCheckBox
    Left = 8
    Top = 202
    Width = 97
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'cbClearSendText'
    TabOrder = 5
    ExplicitTop = 263
  end
end
