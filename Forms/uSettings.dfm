object Settings: TSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 400
  ClientWidth = 466
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
  PixelsPerInch = 96
  TextHeight = 13
  object pcSettings: TPageControl
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 460
    Height = 362
    ActivePage = TabKodi
    Align = alClient
    TabOrder = 0
    object TabApplication: TTabSheet
      Caption = 'TabApplication'
      DesignSize = (
        452
        334)
      object gbAplication: TGroupBox
        Left = 3
        Top = 3
        Width = 446
        Height = 142
        Anchors = [akLeft, akTop, akRight]
        Caption = 'gbAplication'
        TabOrder = 0
        DesignSize = (
          446
          142)
        object cbApplicationAutoRun: TCheckBox
          Left = 16
          Top = 24
          Width = 412
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'cbApplicationAutoRun'
          TabOrder = 0
          OnClick = cbApplicationAutoRunClick
        end
        object cbApplicationAutoRunTray: TCheckBox
          Left = 32
          Top = 47
          Width = 396
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'cbApplicationAutoRunTray'
          TabOrder = 1
        end
        object cbApplicationAutoRunSetVolume: TCheckBox
          Left = 32
          Top = 70
          Width = 297
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'cbApplicationAutoRunSetVolume'
          TabOrder = 2
          OnClick = cbApplicationAutoRunSetVolumeClick
        end
        object cbApplicationTurnTray: TCheckBox
          Left = 16
          Top = 93
          Width = 412
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'cbApplicationTurnTray'
          TabOrder = 3
        end
        object cbApplicationCloseTray: TCheckBox
          Left = 16
          Top = 116
          Width = 412
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'cbApplicationCloseTray'
          TabOrder = 4
        end
        object edApplicationAutoRunVolume: TEdit
          Left = 374
          Top = 68
          Width = 38
          Height = 21
          Anchors = [akTop, akRight]
          TabOrder = 5
          Text = '0'
        end
        object udApplicationAutoRunVolume: TUpDown
          Left = 412
          Top = 68
          Width = 16
          Height = 21
          Anchors = [akTop, akRight]
          Associate = edApplicationAutoRunVolume
          TabOrder = 6
        end
      end
    end
    object TabComPort: TTabSheet
      Caption = 'TabComPort'
      ImageIndex = 1
      DesignSize = (
        452
        334)
      object gbComPort: TGroupBox
        Left = 3
        Top = 3
        Width = 446
        Height = 110
        Anchors = [akLeft, akTop, akRight]
        Caption = 'gbComPort'
        TabOrder = 0
        DesignSize = (
          446
          110)
        object lComPortPort: TLabel
          Left = 16
          Top = 56
          Width = 63
          Height = 13
          Caption = 'lComPortPort'
        end
        object lComPortSpeed: TLabel
          Left = 17
          Top = 83
          Width = 73
          Height = 13
          Caption = 'lComPortSpeed'
        end
        object cbComPortPort: TComboBox
          Left = 144
          Top = 53
          Width = 145
          Height = 21
          TabOrder = 0
          Text = 'cbComPortPort'
        end
        object cbComPortSpeed: TComboBox
          Left = 144
          Top = 80
          Width = 74
          Height = 21
          TabOrder = 1
          Text = 'cbComPortSpeed'
        end
        object cbComPortOpenRun: TCheckBox
          Left = 16
          Top = 24
          Width = 416
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'cbComPortOpenRun'
          TabOrder = 2
        end
      end
    end
    object TabEventApplication: TTabSheet
      Caption = 'TabEventApplication'
      ImageIndex = 2
      DesignSize = (
        452
        334)
      object gbEventApplication: TGroupBox
        Left = 3
        Top = 3
        Width = 446
        Height = 270
        Anchors = [akLeft, akTop, akRight]
        Caption = 'gbEventApplication'
        TabOrder = 0
        DesignSize = (
          446
          270)
        object clbEventApplication: TCheckListBox
          Left = 24
          Top = 47
          Width = 404
          Height = 210
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 0
        end
        object cbEventAppicationUsing: TCheckBox
          Left = 16
          Top = 24
          Width = 412
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'cbEventAppicationUsing'
          TabOrder = 1
          OnClick = cbEventAppicationUsingClick
        end
      end
    end
    object TabDB: TTabSheet
      Caption = 'TabDB'
      ImageIndex = 3
      DesignSize = (
        452
        334)
      object gbDBAccess: TGroupBox
        Left = 3
        Top = 3
        Width = 446
        Height = 94
        Anchors = [akLeft, akTop, akRight]
        Caption = 'gbDBAccess'
        TabOrder = 0
        DesignSize = (
          446
          94)
        object lDBFilleName: TLabel
          Left = 16
          Top = 27
          Width = 60
          Height = 13
          Caption = 'lDBFilleName'
        end
        object lDBTestConnection: TLabel
          Left = 143
          Top = 59
          Width = 285
          Height = 25
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'lDBTestConnection'
          Layout = tlCenter
          WordWrap = True
          ExplicitWidth = 270
        end
        object edDBFileName: TEdit
          Left = 95
          Top = 24
          Width = 285
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          ReadOnly = True
          TabOrder = 0
          Text = 'edDBFileName'
        end
        object btnDBSelectFile: TButton
          Left = 386
          Top = 22
          Width = 23
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'btnDBSelectFile'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = btnDBSelectFileClick
        end
        object btnDBCreate: TButton
          Left = 415
          Top = 22
          Width = 23
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'btnDBCreate'
          ImageIndex = 0
          Images = ilButton
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = btnDBCreateClick
        end
        object btnDBTestConnection: TButton
          Left = 16
          Top = 59
          Width = 121
          Height = 25
          Caption = 'btnDBTestConnection'
          TabOrder = 3
          OnClick = btnDBTestConnectionClick
        end
      end
      object gbDBHelp: TGroupBox
        Left = 3
        Top = 103
        Width = 446
        Height = 74
        Anchors = [akLeft, akTop, akRight]
        Caption = 'gbDBHelp'
        TabOrder = 1
        DesignSize = (
          446
          74)
        object llDBDriver1: TLinkLabel
          Left = 16
          Top = 24
          Width = 412
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'llDBDriver1'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          OnClick = llDBDriverClick
        end
        object llDBDriver2: TLinkLabel
          Left = 16
          Top = 47
          Width = 412
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'llDBDriver2'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = llDBDriverClick
        end
      end
    end
    object TabKodi: TTabSheet
      Caption = 'TabKodi'
      ImageIndex = 4
      DesignSize = (
        452
        334)
      object gbKodiConnect: TGroupBox
        Left = 3
        Top = 63
        Width = 446
        Height = 242
        Anchors = [akLeft, akTop, akRight]
        Caption = 'gbKodiConnect'
        TabOrder = 0
        DesignSize = (
          446
          242)
        object lKodiHelp: TLabel
          Left = 16
          Top = 24
          Width = 412
          Height = 41
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'lKodiHelp'
          WordWrap = True
          ExplicitWidth = 397
        end
        object lKodiIP: TLabel
          Left = 24
          Top = 124
          Width = 32
          Height = 13
          Caption = 'lKodiIP'
        end
        object lKodiPort: TLabel
          Left = 326
          Top = 124
          Width = 42
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = 'lKodiPort'
        end
        object lKodiUser: TLabel
          Left = 24
          Top = 151
          Width = 44
          Height = 13
          Caption = 'lKodiUser'
        end
        object lKodiPassword: TLabel
          Left = 24
          Top = 178
          Width = 68
          Height = 13
          Caption = 'lKodiPassword'
        end
        object lKodiTestConnection: TLabel
          Left = 151
          Top = 210
          Width = 277
          Height = 25
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'lKodiTestConnection'
          Layout = tlCenter
          WordWrap = True
        end
        object lKodiUpdateInterval: TLabel
          Left = 25
          Top = 97
          Width = 95
          Height = 13
          Caption = 'lKodiUpdateInterval'
        end
        object edKodiIP: TEdit
          Left = 128
          Top = 121
          Width = 121
          Height = 21
          MaxLength = 15
          TabOrder = 0
          Text = 'edKodiIP'
        end
        object edKodiPort: TEdit
          Left = 374
          Top = 121
          Width = 54
          Height = 21
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          MaxLength = 4
          NumbersOnly = True
          TabOrder = 1
          Text = 'edKodiPort'
        end
        object edKodiUser: TEdit
          Left = 128
          Top = 148
          Width = 161
          Height = 21
          TabOrder = 2
          Text = 'edKodiUser'
        end
        object edKodiPassword: TEdit
          Left = 128
          Top = 175
          Width = 161
          Height = 21
          TabOrder = 3
          Text = 'edKodiPassword'
        end
        object btnKodiTestConnect: TButton
          Left = 24
          Top = 210
          Width = 121
          Height = 25
          Caption = 'btnKodiTestConnect'
          TabOrder = 4
          OnClick = btnKodiTestConnectClick
        end
        object cbKodiUsing: TCheckBox
          Left = 16
          Top = 71
          Width = 412
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'cbKodiUsing'
          TabOrder = 5
          OnClick = cbKodiUsingClick
        end
        object edKodiUpdateInterval: TEdit
          Left = 374
          Top = 94
          Width = 38
          Height = 21
          Anchors = [akTop, akRight]
          NumbersOnly = True
          TabOrder = 6
          Text = '0'
        end
        object udKodiUpdateInterval: TUpDown
          Left = 412
          Top = 94
          Width = 16
          Height = 21
          Associate = edKodiUpdateInterval
          TabOrder = 7
        end
      end
      object gbKodi: TGroupBox
        Left = 3
        Top = 3
        Width = 446
        Height = 54
        Anchors = [akLeft, akTop, akRight]
        Caption = 'gbKodi'
        TabOrder = 1
        DesignSize = (
          446
          54)
        object lKodiFileName: TLabel
          Left = 16
          Top = 27
          Width = 65
          Height = 13
          Caption = 'lKodiFileName'
        end
        object edKodiFileName: TEdit
          Left = 87
          Top = 24
          Width = 322
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          ReadOnly = True
          TabOrder = 0
          Text = 'edKodiFileName'
        end
        object btnKodiSelectFile: TButton
          Left = 415
          Top = 22
          Width = 23
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'btnKodiSelectFile'
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = btnKodiSelectFileClick
        end
      end
    end
  end
  object pButton: TPanel
    Left = 0
    Top = 368
    Width = 466
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      466
      32)
    object btnClose: TButton
      Left = 384
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'btnClose'
      Default = True
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object btnSave: TButton
      Left = 222
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'btnSave'
      TabOrder = 1
      OnClick = btnSaveClick
    end
    object btnApply: TButton
      Left = 303
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'btnApply'
      TabOrder = 2
      OnClick = btnApplyClick
    end
  end
  object ilButton: TImageList
    Left = 16
    Top = 344
    Bitmap = {
      494C010101000800300010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000090A468FF90A468FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000727272FF7272
      72FF727272FF727272FF727272FF727272FF727272FF00000000000000000000
      000090A468FF90A468FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000727272FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000090A468FF90A4
      68FF90A468FF90A468FF90A468FF90A468FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000727272FFFFFF
      FFFFFFFFFFFFC4E2F5FF97CCEDFF82C2EAFF97CCEDFF0000000090A468FF90A4
      68FF90A468FF90A468FF90A468FF90A468FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000727272FFFFFF
      FFFFFFFFFFFF82C2EAFF82C2EAFF82C2EAFF82C2EAFF00000000000000000000
      000090A468FF90A468FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000727272FFFFFF
      FFFFFFFFFFFF82C2EAFF82C2EAFF82C2EAFF82C2EAFF82C2EAFFFFFFFFFF0000
      000090A468FF90A468FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000727272FFFFFF
      FFFFFFFFFFFF82C2EAFF82C2EAFF82C2EAFF82C2EAFF82C2EAFFFFFFFFFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000727272FFFFFF
      FFFFFFFFFFFFBDDFF4FFEAF5FCFFFFFFFFFFEAF5FCFFBDDFF4FFFFFFFFFFFFFF
      FFFF727272FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000727272FFFFFF
      FFFFFFFFFFFFABD6F1FF97CCEDFF82C2EAFF97CCEDFFABD6F1FFFFFFFFFFFFFF
      FFFF727272FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000727272FFFFFF
      FFFFFFFFFFFFBBDEF4FF9ACDEEFF82C2EAFF9ACDEEFFBBDEF4FFFFFFFFFFFFFF
      FFFF727272FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000727272FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFF727272FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000727272FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF727272FF727272FF7272
      72FF727272FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000727272FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF727272FFFFFFFFFF8080
      80F1C8C8C8600000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000727272FFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF727272FF808080F1CACA
      CA5D000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000727272FF7272
      72FF727272FF727272FF727272FF727272FF727272FF727272FFCCCCCC5A0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFF3000000000000C073000000000000
      C040000000000000C040000000000000C073000000000000C013000000000000
      C01F000000000000C007000000000000C007000000000000C007000000000000
      C007000000000000C007000000000000C007000000000000C00F000000000000
      C01F000000000000FFFF00000000000000000000000000000000000000000000
      000000000000}
  end
end
