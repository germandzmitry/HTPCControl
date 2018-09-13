object frmORunApplication: TfrmORunApplication
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmORunApplication'
  ClientHeight = 170
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
    170)
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 337
    Top = 137
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnCancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnSave: TButton
    Left = 256
    Top = 137
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnSave'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object pApplication: TPanel
    Left = 0
    Top = 69
    Width = 420
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pApplication'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      420
      60)
    object lApplicationFileName: TLabel
      Left = 54
      Top = 8
      Width = 358
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'lApplicationFileName'
      ExplicitWidth = 407
    end
    object sbtnApplicationFileName: TSpeedButton
      Left = 389
      Top = 26
      Width = 23
      Height = 24
      OnClick = sbtnApplicationFileNameClick
    end
    object edApplicationFileName: TEdit
      Left = 54
      Top = 27
      Width = 329
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
      TabOrder = 0
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
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 420
    Height = 69
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pTop'
    ParentBackground = False
    TabOrder = 3
    object lPSort: TLabel
      Left = 8
      Top = 17
      Width = 145
      Height = 13
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'lPSort'
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
    object edWait: TEdit
      Left = 159
      Top = 41
      Width = 47
      Height = 21
      Alignment = taCenter
      NumbersOnly = True
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
end
