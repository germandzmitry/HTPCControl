object frmOPressKeyboard: TfrmOPressKeyboard
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmOPressKeyboard'
  ClientHeight = 166
  ClientWidth = 405
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    405
    166)
  PixelsPerInch = 96
  TextHeight = 13
  object btnSave: TButton
    Left = 241
    Top = 133
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnSave'
    TabOrder = 0
    TabStop = False
    OnClick = btnSaveClick
  end
  object pKeyboard: TPanel
    Left = 0
    Top = 0
    Width = 405
    Height = 89
    BevelOuter = bvNone
    Caption = 'pKeyboard'
    Color = clWhite
    Ctl3D = True
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 322
    Top = 133
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnCancel'
    TabOrder = 2
    TabStop = False
    OnClick = btnCancelClick
  end
end
