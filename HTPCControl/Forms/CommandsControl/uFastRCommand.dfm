object frmFastRCommand: TfrmFastRCommand
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmFastRCommand'
  ClientHeight = 269
  ClientWidth = 540
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
  DesignSize = (
    540
    269)
  PixelsPerInch = 96
  TextHeight = 13
  object lCommand: TLabel
    Left = 8
    Top = 11
    Width = 146
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'lCommand'
  end
  object lDescription: TLabel
    Left = 8
    Top = 38
    Width = 146
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'lDescription'
  end
  object btnCancel: TButton
    Left = 457
    Top = 236
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnCancel'
    TabOrder = 0
    OnClick = btnCancelClick
    ExplicitLeft = 460
  end
  object btnSave: TButton
    Left = 376
    Top = 236
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnSave'
    TabOrder = 1
    OnClick = btnSaveClick
    ExplicitLeft = 379
  end
  object pcOperation: TPageControl
    Left = 8
    Top = 108
    Width = 527
    Height = 122
    ActivePage = TabPressKeyboard
    Anchors = [akLeft, akTop, akBottom]
    MultiLine = True
    TabOrder = 2
    ExplicitHeight = 142
    object TabPressKeyboard: TTabSheet
      Caption = 'TabPressKeyboard'
      object lKey1: TLabel
        Left = 0
        Top = 14
        Width = 78
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'lKey1'
      end
      object lKey2: TLabel
        Left = 0
        Top = 41
        Width = 78
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'lKey2'
      end
      object lKey3: TLabel
        Left = 0
        Top = 68
        Width = 78
        Height = 13
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'lKey3'
      end
      object cbGroupKey1: TComboBox
        Left = 84
        Top = 11
        Width = 281
        Height = 21
        Style = csDropDownList
        TabOrder = 0
        OnSelect = cbGroupKey1Select
      end
      object cbKeyboard1: TComboBox
        Left = 371
        Top = 11
        Width = 145
        Height = 21
        Style = csDropDownList
        TabOrder = 1
      end
      object cbGroupKey2: TComboBox
        Left = 84
        Top = 38
        Width = 281
        Height = 21
        Style = csDropDownList
        TabOrder = 2
        OnSelect = cbGroupKey2Select
      end
      object cbGroupKey3: TComboBox
        Left = 84
        Top = 65
        Width = 281
        Height = 21
        Style = csDropDownList
        TabOrder = 3
        OnSelect = cbGroupKey3Select
      end
      object cbKeyboard2: TComboBox
        Left = 371
        Top = 38
        Width = 145
        Height = 21
        Style = csDropDownList
        TabOrder = 4
      end
      object cbKeyboard3: TComboBox
        Left = 371
        Top = 65
        Width = 145
        Height = 21
        Style = csDropDownList
        TabOrder = 5
      end
    end
    object TabRunApplication: TTabSheet
      Caption = 'TabRunApplication'
      ImageIndex = 1
      ExplicitHeight = 96
      DesignSize = (
        519
        94)
      object lApplicationFileName: TLabel
        Left = 54
        Top = 8
        Width = 462
        Height = 13
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'lApplicationFileName'
        ExplicitWidth = 402
      end
      object btnApplicationFileName: TButton
        Left = 493
        Top = 25
        Width = 23
        Height = 25
        Anchors = [akTop, akRight]
        Caption = 'btnApplicationFileName'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = btnApplicationFileNameClick
      end
      object edApplicationFileName: TEdit
        Left = 54
        Top = 27
        Width = 433
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        ReadOnly = True
        TabOrder = 1
        Text = 'edApplicationFileName'
      end
      object pImageApplication: TPanel
        Left = 8
        Top = 8
        Width = 40
        Height = 40
        BevelKind = bkFlat
        BevelOuter = bvNone
        Caption = 'pImageApplication'
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 2
        object ImageApplication: TImage
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
    end
  end
  object cbLongPress: TCheckBox
    Left = 160
    Top = 62
    Width = 372
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'cbLongPress'
    TabOrder = 3
    ExplicitWidth = 375
  end
  object cbRepeatPrevious: TCheckBox
    Left = 160
    Top = 85
    Width = 372
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'cbRepeatPrevious'
    TabOrder = 4
    ExplicitWidth = 375
  end
  object edCommand: TEdit
    Left = 160
    Top = 8
    Width = 372
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    Text = 'edCommand'
    ExplicitWidth = 375
  end
  object edDescription: TEdit
    Left = 160
    Top = 35
    Width = 372
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 6
    Text = 'edDescription'
    ExplicitWidth = 375
  end
end
