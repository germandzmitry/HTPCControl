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
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    405
    166)
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 322
    Top = 133
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnCancel'
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object btnSave: TButton
    Left = 241
    Top = 133
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnSave'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object pKeyboard: TPanel
    Left = 0
    Top = 0
    Width = 405
    Height = 89
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvNone
    Caption = 'pKeyboard'
    Color = clWhite
    Ctl3D = True
    Padding.Left = 6
    Padding.Top = 6
    Padding.Right = 6
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 2
  end
  object cbLongPress: TCheckBox
    Left = 8
    Top = 137
    Width = 227
    Height = 17
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'cbLongPress'
    TabOrder = 3
  end
end
