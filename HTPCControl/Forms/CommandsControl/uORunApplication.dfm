object frmORunApplication: TfrmORunApplication
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmORunApplication'
  ClientHeight = 99
  ClientWidth = 469
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
    469
    99)
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 386
    Top = 66
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnCancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object btnSave: TButton
    Left = 305
    Top = 66
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnSave'
    TabOrder = 1
    OnClick = btnSaveClick
  end
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 469
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pTop'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      469
      60)
    object lApplicationFileName: TLabel
      Left = 54
      Top = 8
      Width = 407
      Height = 13
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'lApplicationFileName'
    end
    object btnApplicationFileName: TButton
      Left = 438
      Top = 25
      Width = 23
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'btnApplicationFileName'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnApplicationFileNameClick
    end
    object edApplicationFileName: TEdit
      Left = 54
      Top = 27
      Width = 378
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
end
