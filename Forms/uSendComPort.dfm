object frmSendComPort: TfrmSendComPort
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'frmSendComPort'
  ClientHeight = 41
  ClientWidth = 447
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
    447
    41)
  PixelsPerInch = 96
  TextHeight = 13
  object eSendText: TEdit
    Left = 8
    Top = 10
    Width = 350
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'eSendText'
  end
  object btnSend: TButton
    Left = 364
    Top = 8
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'btnSend'
    Default = True
    TabOrder = 1
    OnClick = btnSendClick
  end
end
