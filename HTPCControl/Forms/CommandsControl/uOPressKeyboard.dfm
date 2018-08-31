object frmOPressKeyboard: TfrmOPressKeyboard
  Left = 0
  Top = 0
  Caption = 'frmOPressKeyboard'
  ClientHeight = 515
  ClientWidth = 1018
  Color = clBtnFace
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
    1018
    515)
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 935
    Top = 482
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnCancel'
    TabOrder = 0
    OnClick = btnCancelClick
    ExplicitLeft = 610
    ExplicitTop = 351
  end
  object btnSave: TButton
    Left = 854
    Top = 482
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnSave'
    TabOrder = 1
    OnClick = btnSaveClick
    ExplicitLeft = 529
    ExplicitTop = 351
  end
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 1018
    Height = 170
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pTop'
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    ExplicitWidth = 693
    object cbLongPress: TCheckBox
      Left = 123
      Top = 35
      Width = 325
      Height = 17
      Caption = 'cbLongPress'
      TabOrder = 0
    end
  end
  object pKeyboard: TPanel
    Left = 8
    Top = 176
    Width = 1002
    Height = 297
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'pKeyboard'
    Color = clWhite
    Ctl3D = False
    Padding.Left = 6
    Padding.Top = 6
    Padding.Right = 6
    Padding.Bottom = 6
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 3
    ExplicitWidth = 765
  end
  object edKeyboard: TEdit
    Left = 8
    Top = 484
    Width = 761
    Height = 21
    ReadOnly = True
    TabOrder = 4
    Text = 'edKeyboard'
  end
end
