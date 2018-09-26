object frmOPressKeyboard: TfrmOPressKeyboard
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmOPressKeyboard'
  ClientHeight = 299
  ClientWidth = 424
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
    424
    299)
  PixelsPerInch = 96
  TextHeight = 13
  object btnSave: TButton
    Left = 260
    Top = 266
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
    Top = 123
    Width = 424
    Height = 128
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pKeyboard'
    Color = clWhite
    Ctl3D = True
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 1
    object dtsKeyboardType: TDockTabSet
      Left = 0
      Top = 103
      Width = 424
      Height = 25
      Align = alBottom
      DitherBackground = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      SelectedColor = clWhite
      SoftTop = True
      Style = tsModernTabs
      Tabs.Strings = (
        'Keyboard'
        'Manual')
      TabIndex = 0
      UnselectedColor = clBtnFace
      OnClick = dtsKeyboardTypeClick
    end
  end
  object btnCancel: TButton
    Left = 341
    Top = 266
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnCancel'
    TabOrder = 2
    TabStop = False
    OnClick = btnCancelClick
  end
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 424
    Height = 123
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pTop'
    ParentBackground = False
    TabOrder = 3
    DesignSize = (
      424
      123)
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
      Left = 371
      Top = 67
      Width = 23
      Height = 24
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      OnClick = sbtnForApplicationClick
    end
    object sbtnForApplicationClear: TSpeedButton
      Left = 393
      Top = 67
      Width = 23
      Height = 24
      Anchors = [akTop, akRight]
      ParentShowHint = False
      ShowHint = True
      OnClick = sbtnForApplicationClearClick
    end
    object lDownKey: TLabel
      Left = 8
      Top = 98
      Width = 145
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lDownKey'
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
      Width = 206
      Height = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 2
      Text = 'edForApplication'
    end
    object edDownKey: TEdit
      Left = 159
      Top = 95
      Width = 257
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
      Text = 'edDownKey'
    end
    object edWait: TEdit
      Left = 159
      Top = 41
      Width = 47
      Height = 21
      Alignment = taCenter
      NumbersOnly = True
      TabOrder = 4
      Text = '0'
    end
    object udWait: TUpDown
      Left = 206
      Top = 41
      Width = 17
      Height = 21
      Associate = edWait
      Max = 100000
      Increment = 100
      TabOrder = 5
      OnChangingEx = udWaitChangingEx
    end
  end
end
