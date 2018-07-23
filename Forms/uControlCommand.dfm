object frmControlCommand: TfrmControlCommand
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmControlCommand'
  ClientHeight = 351
  ClientWidth = 387
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
  OnShow = FormShow
  DesignSize = (
    387
    351)
  PixelsPerInch = 96
  TextHeight = 13
  object lCCCommand: TLabel
    Left = 23
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
    Width = 283
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    MaxLength = 100
    TabOrder = 0
    Text = 'edCCCommand'
    ExplicitWidth = 280
  end
  object edCCDescription: TEdit
    Left = 96
    Top = 35
    Width = 283
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    MaxLength = 255
    TabOrder = 1
    Text = 'edCCDescription'
    ExplicitWidth = 280
  end
  object btnCancel: TButton
    Left = 304
    Top = 318
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnCancel'
    Default = True
    TabOrder = 2
    OnClick = btnCancelClick
    ExplicitLeft = 301
    ExplicitTop = 305
  end
  object btnSave: TButton
    Left = 223
    Top = 318
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnSave'
    TabOrder = 3
    OnClick = btnSaveClick
    ExplicitLeft = 220
    ExplicitTop = 305
  end
  object pcControlCommand: TPageControl
    Left = 8
    Top = 62
    Width = 371
    Height = 250
    ActivePage = TabKeyboard
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 4
    ExplicitWidth = 368
    ExplicitHeight = 347
    object TabKeyboard: TTabSheet
      Caption = 'TabKeyboard'
      ExplicitWidth = 360
      ExplicitHeight = 207
      DesignSize = (
        363
        222)
      object lCCKeyKeyboardHelp: TLabel
        Left = 32
        Top = 84
        Width = 316
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'lCCKeyKeyboardHelp'
        WordWrap = True
        ExplicitWidth = 313
      end
      object lCCKeyManualKey1: TLabel
        Left = 32
        Top = 153
        Width = 92
        Height = 13
        Caption = 'lCCKeyManualKey1'
      end
      object lCCKeyManualKey2: TLabel
        Left = 144
        Top = 153
        Width = 92
        Height = 13
        Caption = 'lCCKeyManualKey2'
      end
      object lCCKeyManualKey3: TLabel
        Left = 256
        Top = 153
        Width = 92
        Height = 13
        Caption = 'lCCKeyManualKey3'
      end
      object lKeyboard: TLabel
        Left = 11
        Top = 9
        Width = 337
        Height = 39
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'lKeyboard'
        Layout = tlCenter
        WordWrap = True
        ExplicitWidth = 334
      end
      object lCCKeyManualPlus1: TLabel
        Left = 130
        Top = 175
        Width = 8
        Height = 13
        Caption = '+'
      end
      object lCCKeyManualPlus2: TLabel
        Left = 242
        Top = 175
        Width = 8
        Height = 13
        Caption = '+'
      end
      object cbCCKeyManualKey1: TComboBox
        Left = 32
        Top = 172
        Width = 92
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnSelect = cbCCKeyManualKey1Select
      end
      object cbCCKeyManualKey2: TComboBox
        Left = 144
        Top = 172
        Width = 92
        Height = 21
        Style = csDropDownList
        TabOrder = 1
        OnSelect = cbCCKeyManualKey2Select
      end
      object cbCCKeyManualKey3: TComboBox
        Left = 256
        Top = 172
        Width = 92
        Height = 21
        Style = csDropDownList
        TabOrder = 2
        OnSelect = cbCCKeyManualKey3Select
      end
      object cbCCKeyRepeat: TCheckBox
        Left = 11
        Top = 199
        Width = 337
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'cbCCKeyRepeat'
        TabOrder = 3
      end
      object edCCKeyKeyboard: TEdit
        Left = 32
        Top = 103
        Width = 316
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ReadOnly = True
        TabOrder = 4
        Text = 'edCCKeyKeyboard'
        OnKeyDown = edCCKeyKeyboardKeyDown
        OnKeyUp = edCCKeyKeyboardKeyUp
        ExplicitWidth = 313
      end
      object rbCCKeyKeyboard: TRadioButton
        Left = 11
        Top = 61
        Width = 337
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'rbCCKeyKeyboard'
        TabOrder = 5
        OnClick = rbCCKeyKeyboardClick
        ExplicitWidth = 334
      end
      object rbCCKeyManual: TRadioButton
        Left = 11
        Top = 130
        Width = 337
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'rbCCKeyManual'
        TabOrder = 6
        OnClick = rbCCKeyManualClick
        ExplicitWidth = 334
      end
      object pTabKeyboard: TPanel
        Left = 11
        Top = 54
        Width = 337
        Height = 1
        Anchors = [akLeft, akTop, akRight]
        Caption = 'pTabKeyboard'
        TabOrder = 7
        ExplicitWidth = 334
      end
    end
    object TabApplication: TTabSheet
      Caption = 'TabApplication'
      ImageIndex = 1
      ExplicitWidth = 360
      ExplicitHeight = 207
      DesignSize = (
        363
        222)
      object lCCAppFileName: TLabel
        Left = 57
        Top = 61
        Width = 291
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'lCCAppFileName'
        ExplicitWidth = 288
      end
      object lApplication: TLabel
        Left = 11
        Top = 9
        Width = 337
        Height = 39
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'lApplication'
        Layout = tlCenter
        WordWrap = True
        ExplicitWidth = 334
      end
      object pImageApplication: TPanel
        Left = 11
        Top = 61
        Width = 40
        Height = 40
        BevelKind = bkTile
        BevelOuter = bvNone
        Caption = 'pImageApplication'
        TabOrder = 0
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
      object btnCCAppFileName: TButton
        Left = 325
        Top = 78
        Width = 23
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'btnCCAppFileName'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = btnCCAppFileNameClick
        ExplicitLeft = 322
      end
      object edCCAppFileName: TEdit
        Left = 57
        Top = 80
        Width = 262
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ReadOnly = True
        TabOrder = 2
        Text = 'edCCAppFileName'
        ExplicitWidth = 259
      end
      object pTabApplication: TPanel
        Left = 11
        Top = 54
        Width = 337
        Height = 1
        Anchors = [akLeft, akTop, akRight]
        Caption = 'pTabApplication'
        TabOrder = 3
        ExplicitWidth = 334
      end
    end
    object TabRepeat: TTabSheet
      Caption = 'TabRepeat'
      ImageIndex = 2
      ExplicitWidth = 360
      ExplicitHeight = 207
      DesignSize = (
        363
        222)
      object lRepeat: TLabel
        Left = 11
        Top = 9
        Width = 337
        Height = 39
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'lRepeat'
        Layout = tlCenter
        WordWrap = True
        ExplicitWidth = 334
      end
      object cbCommandRepeat: TCheckBox
        Left = 11
        Top = 61
        Width = 337
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'cbCommandRepeat'
        TabOrder = 0
        ExplicitWidth = 334
      end
      object pTabRepeat: TPanel
        Left = 11
        Top = 54
        Width = 337
        Height = 1
        Anchors = [akLeft, akTop, akRight]
        Caption = 'pTabRepeat'
        TabOrder = 1
        ExplicitWidth = 334
      end
    end
  end
end
