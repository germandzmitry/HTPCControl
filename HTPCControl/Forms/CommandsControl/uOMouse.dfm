object frmOMouse: TfrmOMouse
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmOMouse'
  ClientHeight = 239
  ClientWidth = 420
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
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  DesignSize = (
    420
    239)
  PixelsPerInch = 96
  TextHeight = 13
  object btnSave: TButton
    Left = 256
    Top = 206
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnSave'
    TabOrder = 2
    TabStop = False
    OnClick = btnSaveClick
    ExplicitLeft = 454
    ExplicitTop = 292
  end
  object btnCancel: TButton
    Left = 337
    Top = 206
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnCancel'
    TabOrder = 3
    TabStop = False
    OnClick = btnCancelClick
    ExplicitLeft = 535
    ExplicitTop = 292
  end
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 420
    Height = 97
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pTop'
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 645
    DesignSize = (
      420
      97)
    object lPSort: TLabel
      Left = 8
      Top = 17
      Width = 145
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lPSort'
    end
    object lForApplication: TLabel
      Left = 8
      Top = 71
      Width = 145
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lForApplication'
    end
    object sbtnForApplication: TSpeedButton
      Left = 389
      Top = 67
      Width = 23
      Height = 24
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      OnClick = sbtnForApplicationClick
      ExplicitLeft = 440
    end
    object lWait: TLabel
      Left = 8
      Top = 44
      Width = 145
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lWait'
    end
    object lWaitSecond: TLabel
      Left = 229
      Top = 44
      Width = 59
      Height = 13
      Caption = 'lWaitSecond'
    end
    object edPSort: TEdit
      Left = 159
      Top = 14
      Width = 47
      Height = 21
      TabStop = False
      Alignment = taCenter
      NumbersOnly = True
      ReadOnly = True
      TabOrder = 0
      Text = '1'
    end
    object udPSort: TUpDown
      Left = 206
      Top = 14
      Width = 16
      Height = 21
      Associate = edPSort
      Min = 1
      Position = 1
      TabOrder = 1
    end
    object edForApplication: TEdit
      Left = 159
      Top = 68
      Width = 224
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 4
      Text = 'edForApplication'
      ExplicitWidth = 275
    end
    object edWait: TEdit
      Left = 159
      Top = 41
      Width = 47
      Height = 21
      Alignment = taCenter
      NumbersOnly = True
      ReadOnly = True
      TabOrder = 2
      Text = '0'
    end
    object udWait: TUpDown
      Left = 206
      Top = 41
      Width = 16
      Height = 21
      Associate = edWait
      Max = 100000
      Increment = 100
      TabOrder = 3
      OnChangingEx = udWaitChangingEx
    end
  end
  object pMouse: TPanel
    Left = 0
    Top = 97
    Width = 420
    Height = 101
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Caption = 'pMouse'
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    ExplicitHeight = 235
    object lEvent: TLabel
      Left = 8
      Top = 16
      Width = 145
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lEvent'
    end
    object lX: TLabel
      Left = 8
      Top = 43
      Width = 145
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lX'
    end
    object lY: TLabel
      Left = 8
      Top = 70
      Width = 145
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lY'
    end
    object edX: TEdit
      Left = 159
      Top = 40
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'edX'
    end
    object edY: TEdit
      Left = 159
      Top = 67
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'edY'
    end
    object cbEvent: TComboBox
      Left = 159
      Top = 13
      Width = 224
      Height = 21
      Style = csDropDownList
      TabOrder = 0
    end
  end
end
