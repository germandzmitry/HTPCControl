object frmFastRCommand: TfrmFastRCommand
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmFastRCommand'
  ClientHeight = 455
  ClientWidth = 420
  Color = clBtnFace
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
    420
    455)
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 337
    Top = 422
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnCancel'
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object btnSave: TButton
    Left = 256
    Top = 422
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnSave'
    TabOrder = 3
    OnClick = btnSaveClick
  end
  object pOperationHeader: TPanel
    Left = 0
    Top = 123
    Width = 420
    Height = 78
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pOperationHeader'
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 1
    object lPSort: TLabel
      Left = 9
      Top = 27
      Width = 145
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lPSort'
    end
    object lWait: TLabel
      Left = 9
      Top = 52
      Width = 145
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lWait'
    end
    object lWaitSecond: TLabel
      Left = 229
      Top = 52
      Width = 183
      Height = 13
      AutoSize = False
      Caption = 'lWaitSecond'
    end
    object lOperationHeader: TLabel
      Left = 8
      Top = 6
      Width = 404
      Height = 13
      AutoSize = False
      Caption = 'lOperationHeader'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edPSort: TEdit
      Left = 160
      Top = 25
      Width = 47
      Height = 19
      Alignment = taCenter
      NumbersOnly = True
      ReadOnly = True
      TabOrder = 0
      Text = '1'
    end
    object udPSort: TUpDown
      Left = 207
      Top = 25
      Width = 16
      Height = 19
      Associate = edPSort
      Min = 1
      Position = 1
      TabOrder = 1
    end
    object edWait: TEdit
      Left = 160
      Top = 50
      Width = 47
      Height = 19
      Alignment = taCenter
      NumbersOnly = True
      TabOrder = 2
      Text = '0'
    end
    object udWait: TUpDown
      Left = 207
      Top = 50
      Width = 16
      Height = 19
      Associate = edWait
      Max = 100000
      Increment = 100
      TabOrder = 3
      OnChangingEx = udWaitChangingEx
    end
  end
  object pCommand: TPanel
    Left = 0
    Top = 0
    Width = 420
    Height = 123
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pCommand'
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    DesignSize = (
      420
      123)
    object lCommand: TLabel
      Left = 8
      Top = 27
      Width = 146
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lCommand'
    end
    object lDescription: TLabel
      Left = 8
      Top = 53
      Width = 146
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lDescription'
    end
    object lCommandHeader: TLabel
      Left = 8
      Top = 6
      Width = 404
      Height = 13
      AutoSize = False
      Caption = 'lCommandHeader'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cbLongPress: TCheckBox
      Left = 160
      Top = 75
      Width = 252
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'cbLongPress'
      TabOrder = 2
    end
    object cbRepeatPrevious: TCheckBox
      Left = 160
      Top = 98
      Width = 252
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'cbRepeatPrevious'
      TabOrder = 3
      OnClick = cbRepeatPreviousClick
    end
    object edCommand: TEdit
      Left = 160
      Top = 25
      Width = 252
      Height = 19
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      Text = 'edCommand'
    end
    object edDescription: TEdit
      Left = 160
      Top = 50
      Width = 252
      Height = 19
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      Text = 'edDescription'
    end
  end
  object pOperationType: TPanel
    Left = 0
    Top = 223
    Width = 420
    Height = 195
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pOperationType'
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    DesignSize = (
      420
      195)
    object pcOperationType: TPageControl
      Left = 0
      Top = 1
      Width = 420
      Height = 194
      ActivePage = TabPressKeyboard
      Anchors = [akLeft, akTop, akRight]
      MultiLine = True
      Style = tsButtons
      TabHeight = 22
      TabOrder = 0
      object TabPressKeyboard: TTabSheet
        Caption = 'TabPressKeyboard'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        DesignSize = (
          412
          162)
        object lForApplication: TLabel
          Left = 3
          Top = 3
          Width = 101
          Height = 26
          Alignment = taRightJustify
          AutoSize = False
          Caption = 'lForApplication'
          Layout = tlCenter
          WordWrap = True
        end
        object sbtnForApplication: TSpeedButton
          Left = 364
          Top = 5
          Width = 23
          Height = 24
          Anchors = [akTop, akRight]
          ParentShowHint = False
          ShowHint = True
          OnClick = sbtnForApplicationClick
        end
        object sbtnForApplicationClear: TSpeedButton
          Left = 385
          Top = 5
          Width = 23
          Height = 24
          Anchors = [akTop, akRight]
          ParentShowHint = False
          ShowHint = True
          OnClick = sbtnForApplicationClearClick
        end
        object sbtnRight: TSpeedButton
          Left = 214
          Top = 62
          Width = 24
          Height = 22
          OnClick = sbtnRightClick
        end
        object sbtnLeft: TSpeedButton
          Left = 214
          Top = 86
          Width = 24
          Height = 22
          OnClick = sbtnLeftClick
        end
        object sbtnLeftAll: TSpeedButton
          Left = 214
          Top = 110
          Width = 24
          Height = 22
          OnClick = sbtnLeftAllClick
        end
        object lvKeyboard: TListView
          Left = 4
          Top = 35
          Width = 204
          Height = 124
          Color = clWhite
          Columns = <
            item
              Width = 183
            end>
          ColumnClick = False
          GroupView = True
          ReadOnly = True
          RowSelect = True
          ShowColumnHeaders = False
          TabOrder = 0
          TabStop = False
          ViewStyle = vsReport
          OnDblClick = lvKeyboardDblClick
        end
        object lvDownKey: TListView
          Left = 244
          Top = 35
          Width = 164
          Height = 124
          Columns = <
            item
              AutoSize = True
            end>
          ReadOnly = True
          RowSelect = True
          ShowColumnHeaders = False
          TabOrder = 1
          TabStop = False
          ViewStyle = vsReport
          OnDblClick = lvDownKeyDblClick
        end
        object edForApplication: TEdit
          Left = 110
          Top = 6
          Width = 248
          Height = 21
          TabStop = False
          Anchors = [akLeft, akTop, akRight]
          ReadOnly = True
          TabOrder = 2
          Text = 'edForApplication'
        end
      end
      object TabRunApplication: TTabSheet
        Caption = 'TabRunApplication'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        DesignSize = (
          412
          162)
        object lApplicationFileName: TLabel
          Left = 54
          Top = 8
          Width = 355
          Height = 13
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'lApplicationFileName'
        end
        object sbtnApplicationFileName: TSpeedButton
          Left = 386
          Top = 26
          Width = 23
          Height = 24
          Anchors = [akTop, akRight]
          ParentShowHint = False
          ShowHint = True
          OnClick = sbtnApplicationFileNameClick
        end
        object edApplicationFileName: TEdit
          Left = 54
          Top = 27
          Width = 326
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          ReadOnly = True
          TabOrder = 0
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
          TabOrder = 1
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
  end
  object dtsOperationType: TDockTabSet
    Left = 0
    Top = 201
    Width = 420
    Height = 22
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    SelectedColor = clWhite
    Style = tsModernTabs
    Tabs.Strings = (
      'PressKeyboard'
      'RunApplication')
    TabIndex = 0
    TabPosition = tpTop
    OnClick = dtsOperationTypeClick
  end
end
