object ControlCommand: TControlCommand
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'ControlCommand'
  ClientHeight = 466
  ClientWidth = 420
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  DesignSize = (
    420
    466)
  PixelsPerInch = 96
  TextHeight = 13
  object lCCCommand: TLabel
    Left = 27
    Top = 11
    Width = 63
    Height = 13
    Alignment = taRightJustify
    Caption = 'lCCCommand'
  end
  object lCCDescription: TLabel
    Left = 21
    Top = 38
    Width = 69
    Height = 13
    Alignment = taRightJustify
    Caption = 'lCCDescription'
  end
  object edCCCommand: TEdit
    Left = 96
    Top = 8
    Width = 316
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    MaxLength = 100
    TabOrder = 0
    Text = 'edCCCommand'
  end
  object edCCDescription: TEdit
    Left = 96
    Top = 35
    Width = 316
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    MaxLength = 255
    TabOrder = 1
    Text = 'edCCDescription'
  end
  object pClient: TPanel
    Left = 8
    Top = 62
    Width = 404
    Height = 227
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkTile
    BevelOuter = bvNone
    Caption = 'pKeyboard'
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    DesignSize = (
      400
      223)
    object rbCCPressKeyKeyboard: TRadioButton
      Left = 11
      Top = 8
      Width = 366
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'rbCCPressKeyKeyboard'
      TabOrder = 0
      OnClick = rbCCPressKeyKeyboardClick
    end
    object pKeyboard: TPanel
      Left = -2
      Top = 31
      Width = 391
      Height = 194
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      Caption = 'pKeyboard'
      TabOrder = 1
      DesignSize = (
        391
        194)
      object lCCKeyKeyboardHelp: TLabel
        Left = 40
        Top = 23
        Width = 339
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'lCCKeyKeyboardHelp'
        WordWrap = True
        ExplicitWidth = 351
      end
      object lCCKeyManualKey1: TLabel
        Left = 40
        Top = 95
        Width = 92
        Height = 13
        Caption = 'lCCKeyManualKey1'
      end
      object lCCKeyManualKey2: TLabel
        Left = 40
        Top = 122
        Width = 92
        Height = 13
        Caption = 'lCCKeyManualKey2'
      end
      object lCCKeyManualKey3: TLabel
        Left = 40
        Top = 149
        Width = 92
        Height = 13
        Caption = 'lCCKeyManualKey3'
      end
      object rbCCKeyKeyboard: TRadioButton
        Left = 26
        Top = 0
        Width = 353
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'rbCCKeyKeyboard'
        TabOrder = 0
        OnClick = rbCCKeyKeyboardClick
      end
      object rbCCKeyManual: TRadioButton
        Left = 26
        Top = 69
        Width = 353
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'rbCCKeyManual'
        TabOrder = 1
        OnClick = rbCCKeyManualClick
      end
      object cbCCKeyRepeat: TCheckBox
        Left = 26
        Top = 168
        Width = 353
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'cbCCKeyRepeat'
        TabOrder = 2
      end
      object edCCKeyKeyboard: TEdit
        Left = 40
        Top = 42
        Width = 339
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ReadOnly = True
        TabOrder = 3
        Text = 'edCCKeyKeyboard'
        OnKeyDown = edCCKeyKeyboardKeyDown
        OnKeyUp = edCCKeyKeyboardKeyUp
      end
      object cbCCKeyManualKey1: TComboBox
        Left = 152
        Top = 92
        Width = 227
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 4
        OnSelect = cbCCKeyManualKey1Select
      end
      object cbCCKeyManualKey2: TComboBox
        Left = 152
        Top = 119
        Width = 227
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 5
        OnSelect = cbCCKeyManualKey2Select
      end
      object cbCCKeyManualKey3: TComboBox
        Left = 152
        Top = 146
        Width = 227
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 6
        OnSelect = cbCCKeyManualKey3Select
      end
    end
  end
  object btnCancel: TButton
    Left = 337
    Top = 433
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnCancel'
    Default = True
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object btnSave: TButton
    Left = 256
    Top = 433
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnSave'
    TabOrder = 4
    OnClick = btnSaveClick
  end
  object pApplication: TPanel
    Left = 8
    Top = 295
    Width = 404
    Height = 85
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkTile
    BevelOuter = bvNone
    Caption = 'pApplication'
    Color = clWhite
    ParentBackground = False
    TabOrder = 5
    DesignSize = (
      400
      81)
    object lCCAppFileName: TLabel
      Left = 70
      Top = 30
      Width = 74
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      Caption = 'lCCAppFileName'
      ExplicitWidth = 78
    end
    object btnCCAppFileName: TButton
      Left = 354
      Top = 47
      Width = 23
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'btnCCAppFileName'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnCCAppFileNameClick
    end
    object edCCAppFileName: TEdit
      Left = 70
      Top = 49
      Width = 278
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      ReadOnly = True
      TabOrder = 1
      Text = 'edCCAppFileName'
    end
    object pImageApplication: TPanel
      Left = 24
      Top = 30
      Width = 40
      Height = 40
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = 'pImageApplication'
      TabOrder = 2
      object ImageCCApp: TImage
        AlignWithMargins = True
        Left = 2
        Top = 2
        Width = 32
        Height = 32
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 2
        Margins.Bottom = 2
        Align = alClient
        AutoSize = True
        Center = True
        Proportional = True
        ExplicitLeft = 14
        ExplicitTop = 9
      end
    end
    object rbCCRunApplication: TRadioButton
      Left = 11
      Top = 7
      Width = 366
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'rbCCRunApplication'
      TabOrder = 3
      OnClick = rbCCRunApplicationClick
    end
  end
  object pRepeat: TPanel
    Left = 8
    Top = 386
    Width = 404
    Height = 39
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkTile
    BevelOuter = bvNone
    Caption = 'pRepeat'
    Color = clWhite
    ParentBackground = False
    TabOrder = 6
    DesignSize = (
      400
      35)
    object rbCCRepeat: TRadioButton
      Left = 11
      Top = 8
      Width = 366
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'rbCCRepeat'
      TabOrder = 0
      OnClick = rbCCRepeatClick
    end
  end
end
