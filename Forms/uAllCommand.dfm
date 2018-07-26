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
  OnDestroy = FormDestroy
  DesignSize = (
    665
    332)
  PixelsPerInch = 96
  TextHeight = 13
  object lvAllCommand: TListView
    AlignWithMargins = True
    Left = 8
    Top = 26
    Width = 649
    Height = 266
    Margins.Left = 8
    Margins.Top = 0
    Margins.Right = 8
    Margins.Bottom = 40
    Align = alClient
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
  object pTop: TPanel
    Left = 0
    Top = 0
    Width = 665
    Height = 26
    Margins.Left = 8
    Margins.Top = 0
    Margins.Right = 8
    Margins.Bottom = 0
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Caption = 'pTop'
    TabOrder = 2
    object ActionToolBar: TActionToolBar
      Left = 0
      Top = 0
      Width = 536
      Height = 26
      ActionManager = amAllCommand
      Align = alClient
      Caption = 'ActionToolBar'
      Color = clMenuBar
      ColorMap.DisabledFontColor = 7171437
      ColorMap.HighlightColor = clWhite
      ColorMap.BtnSelectedFont = clBlack
      ColorMap.UnusedColor = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      HorzMargin = 8
      ParentFont = False
      Spacing = 0
    end
    object edSearch: TEdit
      AlignWithMargins = True
      Left = 536
      Top = 3
      Width = 121
      Height = 20
      Margins.Left = 0
      Margins.Right = 8
      Align = alRight
      TabOrder = 1
      Text = 'edSearch'
      ExplicitHeight = 21
    end
  end
  object alAllCommand: TActionList
    Images = Main.ilSmall
    Left = 224
    Top = 120
    object ActRCNew: TAction
      Category = 'RemoteControl'
      Caption = 'ActRCNew'
      ImageIndex = 5
      OnExecute = ActRCNewExecute
    end
    object ActRCEdit: TAction
      Category = 'RemoteControl'
      Caption = 'ActRCEdit'
      ImageIndex = 6
      OnExecute = ActRCEditExecute
    end
    object ActRCDelete: TAction
      Category = 'RemoteControl'
      Caption = 'ActRCDelete'
      ImageIndex = 7
      OnExecute = ActRCDeleteExecute
    end
    object ActRCCollapseAll: TAction
      Category = 'RemoteControl'
      Caption = 'ActRCCollapseAll'
      ImageIndex = 10
      OnExecute = ActRCCollapseAllExecute
    end
    object ActRCExpandAll: TAction
      Category = 'RemoteControl'
      Caption = 'ActRCExpandAll'
      ImageIndex = 11
      OnExecute = ActRCExpandAllExecute
    end
  end
  object amAllCommand: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = ActRCNew
            Caption = '&ActRCNew'
            ImageIndex = 5
          end
          item
            Caption = '-'
          end
          item
            Action = ActRCEdit
            Caption = 'A&ctRCEdit'
            ImageIndex = 6
          end
          item
            Action = ActRCDelete
            Caption = 'Ac&tRCDelete'
            ImageIndex = 7
          end
          item
            Caption = '-'
          end
          item
            Action = ActRCCollapseAll
            Caption = 'Act&RCCollapseAll'
            ImageIndex = 10
          end
          item
            Action = ActRCExpandAll
            Caption = 'ActRC&ExpandAll'
            ImageIndex = 11
          end>
        ActionBar = ActionToolBar
      end>
    LinkedActionLists = <
      item
        ActionList = alAllCommand
        Caption = 'alAllCommand'
      end>
    Images = Main.ilSmall
    Left = 136
    Top = 120
    StyleName = 'Platform Default'
  end
end
