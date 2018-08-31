object frmRCommand: TfrmRCommand
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmRCommand'
  ClientHeight = 128
  ClientWidth = 413
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
    413
    128)
  PixelsPerInch = 96
  TextHeight = 13
  object btnCancel: TButton
    Left = 330
    Top = 95
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnCancel'
    TabOrder = 0
    OnClick = btnCancelClick
    ExplicitTop = 98
  end
  object btnSave: TButton
    Left = 249
    Top = 95
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnSave'
    TabOrder = 1
    OnClick = btnSaveClick
    ExplicitTop = 98
  end
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 413
    Height = 89
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pTop'
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    DesignSize = (
      413
      89)
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
    object cbRepeatPrevious: TCheckBox
      Left = 160
      Top = 62
      Width = 245
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'cbRepeatPrevious'
      TabOrder = 0
    end
    object edCommand: TEdit
      Left = 160
      Top = 8
      Width = 245
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      Text = 'edCommand'
    end
    object edDescription: TEdit
      Left = 160
      Top = 35
      Width = 245
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 2
      Text = 'edDescription'
    end
  end
end
