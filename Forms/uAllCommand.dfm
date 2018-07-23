object frmAllCommand: TfrmAllCommand
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'frmAllCommand'
  ClientHeight = 332
  ClientWidth = 665
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
    665
    332)
  PixelsPerInch = 96
  TextHeight = 13
  object lvAllCommand: TListView
    Left = 8
    Top = 8
    Width = 649
    Height = 285
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Width = 250
      end
      item
        AutoSize = True
      end
      item
        Width = 30
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object btnClose: TButton
    Left = 582
    Top = 299
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnClose'
    TabOrder = 1
    OnClick = btnCloseClick
  end
end
