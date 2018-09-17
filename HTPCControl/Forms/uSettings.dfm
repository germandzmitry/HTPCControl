object Settings: TSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 400
  ClientWidth = 645
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
    645
    400)
  PixelsPerInch = 96
  TextHeight = 13
  object btnApply: TButton
    Left = 481
    Top = 367
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'btnApply'
    TabOrder = 3
    OnClick = btnApplyClick
    ExplicitLeft = 303
  end
  object btnClose: TButton
    Left = 562
    Top = 367
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnClose'
    Default = True
    TabOrder = 4
    OnClick = btnCloseClick
    ExplicitLeft = 384
  end
  object btnSave: TButton
    Left = 400
    Top = 367
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnSave'
    TabOrder = 2
    OnClick = btnSaveClick
    ExplicitLeft = 554
  end
  object tvSettings: TTreeView
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 166
    Height = 357
    Margins.Bottom = 40
    Align = alLeft
    Ctl3D = False
    HideSelection = False
    Indent = 19
    ParentCtl3D = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    OnChange = tvSettingsChange
    OnChanging = tvSettingsChanging
    Items.NodeData = {
      0302000000200000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      000000000001013100200000000000000000000000FFFFFFFFFFFFFFFF000000
      00000000000100000001013200200000000000000000000000FFFFFFFFFFFFFF
      FF00000000000000000000000001013300}
  end
  object pClient: TPanel
    AlignWithMargins = True
    Left = 175
    Top = 3
    Width = 467
    Height = 357
    Margins.Bottom = 40
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'pClient'
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 1
    ExplicitTop = 8
    ExplicitWidth = 242
    ExplicitHeight = 242
    object pcSettings: TPageControl
      Left = 4
      Top = 7
      Width = 451
      Height = 338
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 40
      ActivePage = TabEventApplication
      MultiLine = True
      Style = tsFlatButtons
      TabOrder = 0
      object TabApplication: TTabSheet
        Caption = 'TabApplication'
        DesignSize = (
          443
          283)
        object gbAplication: TGroupBox
          Left = 3
          Top = 3
          Width = 437
          Height = 166
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbAplication'
          TabOrder = 0
          DesignSize = (
            437
            166)
          object cbApplicationAutoRun: TCheckBox
            Left = 16
            Top = 24
            Width = 403
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbApplicationAutoRun'
            TabOrder = 0
            OnClick = cbApplicationAutoRunClick
          end
          object cbApplicationAutoRunTray: TCheckBox
            Left = 32
            Top = 47
            Width = 387
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbApplicationAutoRunTray'
            TabOrder = 1
          end
          object cbApplicationAutoRunSetVolume: TCheckBox
            Left = 32
            Top = 70
            Width = 288
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbApplicationAutoRunSetVolume'
            TabOrder = 2
            OnClick = cbApplicationAutoRunSetVolumeClick
          end
          object cbApplicationTurnTray: TCheckBox
            Left = 16
            Top = 116
            Width = 403
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbApplicationTurnTray'
            TabOrder = 3
          end
          object cbApplicationCloseTray: TCheckBox
            Left = 16
            Top = 139
            Width = 403
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbApplicationCloseTray'
            TabOrder = 4
          end
          object edApplicationAutoRunVolume: TEdit
            Left = 365
            Top = 68
            Width = 38
            Height = 19
            Alignment = taCenter
            Anchors = [akTop, akRight]
            TabOrder = 5
            Text = '0'
          end
          object udApplicationAutoRunVolume: TUpDown
            Left = 403
            Top = 68
            Width = 16
            Height = 19
            Anchors = [akTop, akRight]
            Associate = edApplicationAutoRunVolume
            TabOrder = 6
          end
          object cbApplicationAutoRunNotificationCenter: TCheckBox
            Left = 32
            Top = 93
            Width = 387
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbApplicationAutoRunNotificationCenter'
            TabOrder = 7
          end
        end
      end
      object TabComPort: TTabSheet
        Caption = 'TabComPort'
        ImageIndex = 1
        DesignSize = (
          443
          283)
        object gbComPort: TGroupBox
          Left = 3
          Top = 3
          Width = 437
          Height = 142
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbComPort'
          TabOrder = 0
          DesignSize = (
            437
            142)
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
          object lComPortShowLast: TLabel
            Left = 17
            Top = 104
            Width = 184
            Height = 26
            AutoSize = False
            Caption = 'lComPortShowLast'
            Layout = tlCenter
            WordWrap = True
          end
          object cbComPortPort: TComboBox
            Left = 207
            Top = 53
            Width = 145
            Height = 21
            TabOrder = 0
            Text = 'cbComPortPort'
          end
          object cbComPortSpeed: TComboBox
            Left = 207
            Top = 80
            Width = 74
            Height = 21
            TabOrder = 1
            Text = 'cbComPortSpeed'
          end
          object cbComPortOpenRun: TCheckBox
            Left = 16
            Top = 24
            Width = 407
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbComPortOpenRun'
            TabOrder = 2
          end
          object edComPortShowLast: TEdit
            Left = 207
            Top = 107
            Width = 41
            Height = 19
            Alignment = taCenter
            NumbersOnly = True
            TabOrder = 3
            Text = '100'
            OnChange = edComPortShowLastChange
          end
          object udComPortShowLast: TUpDown
            Left = 248
            Top = 107
            Width = 16
            Height = 19
            Associate = edComPortShowLast
            Max = 1000
            Position = 100
            TabOrder = 4
          end
        end
      end
      object TabEventApplication: TTabSheet
        Caption = 'TabEventApplication'
        ImageIndex = 2
        DesignSize = (
          443
          283)
        object gbEventApplication: TGroupBox
          Left = 3
          Top = 3
          Width = 437
          Height = 270
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbEventApplication'
          TabOrder = 0
          DesignSize = (
            437
            270)
          object clbEventApplication: TCheckListBox
            Left = 24
            Top = 47
            Width = 395
            Height = 210
            Anchors = [akLeft, akTop, akRight]
            ItemHeight = 13
            TabOrder = 0
          end
          object cbEventAppicationUsing: TCheckBox
            Left = 16
            Top = 24
            Width = 403
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
          443
          283)
        object gbDBAccess: TGroupBox
          Left = 3
          Top = 3
          Width = 437
          Height = 94
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbDBAccess'
          TabOrder = 0
          DesignSize = (
            437
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
            Width = 276
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
            Width = 276
            Height = 19
            Anchors = [akLeft, akTop, akRight]
            ReadOnly = True
            TabOrder = 0
            Text = 'edDBFileName'
          end
          object btnDBSelectFile: TButton
            Left = 377
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
            Left = 406
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
          Width = 437
          Height = 74
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbDBHelp'
          TabOrder = 1
          DesignSize = (
            437
            74)
          object llDBDriver1: TLinkLabel
            Left = 16
            Top = 24
            Width = 403
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
            Width = 403
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
          443
          283)
        object gbKodiConnect: TGroupBox
          Left = 3
          Top = 63
          Width = 437
          Height = 242
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbKodiConnect'
          TabOrder = 0
          DesignSize = (
            437
            242)
          object lKodiHelp: TLabel
            Left = 16
            Top = 24
            Width = 403
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
            Left = 317
            Top = 124
            Width = 42
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = 'lKodiPort'
            ExplicitLeft = 326
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
            Width = 268
            Height = 25
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 'lKodiTestConnection'
            Layout = tlCenter
            WordWrap = True
            ExplicitWidth = 277
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
            Height = 19
            Alignment = taCenter
            MaxLength = 15
            TabOrder = 0
            Text = 'edKodiIP'
          end
          object edKodiPort: TEdit
            Left = 365
            Top = 121
            Width = 54
            Height = 19
            Alignment = taCenter
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
            Height = 19
            TabOrder = 2
            Text = 'edKodiUser'
          end
          object edKodiPassword: TEdit
            Left = 128
            Top = 175
            Width = 161
            Height = 19
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
            Width = 403
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbKodiUsing'
            TabOrder = 5
            OnClick = cbKodiUsingClick
          end
          object edKodiUpdateInterval: TEdit
            Left = 365
            Top = 94
            Width = 38
            Height = 19
            Alignment = taCenter
            Anchors = [akTop, akRight]
            NumbersOnly = True
            TabOrder = 6
            Text = '0'
          end
          object udKodiUpdateInterval: TUpDown
            Left = 403
            Top = 94
            Width = 16
            Height = 19
            Anchors = [akTop, akRight]
            Associate = edKodiUpdateInterval
            TabOrder = 7
          end
        end
        object gbKodi: TGroupBox
          Left = 3
          Top = 3
          Width = 437
          Height = 54
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbKodi'
          TabOrder = 1
          DesignSize = (
            437
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
            Width = 313
            Height = 19
            Anchors = [akLeft, akTop, akRight]
            ReadOnly = True
            TabOrder = 0
            Text = 'edKodiFileName'
          end
          object btnKodiSelectFile: TButton
            Left = 406
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
      object TabRemoteControl: TTabSheet
        Caption = 'TabRemoteControl'
        ImageIndex = 5
        DesignSize = (
          443
          283)
        object gbRemoteControl: TGroupBox
          Left = 3
          Top = 3
          Width = 437
          Height = 62
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbRemoteControl'
          TabOrder = 0
          object lRemoteControlShowLast: TLabel
            Left = 17
            Top = 24
            Width = 224
            Height = 26
            AutoSize = False
            Caption = 'lRemoteControlShowLast'
            Layout = tlCenter
            WordWrap = True
          end
          object edRemoteControlShowLast: TEdit
            Left = 247
            Top = 28
            Width = 41
            Height = 19
            Alignment = taCenter
            NumbersOnly = True
            TabOrder = 0
            Text = '100'
            OnChange = edComPortShowLastChange
          end
          object udRemoteControlShowLast: TUpDown
            Left = 288
            Top = 28
            Width = 16
            Height = 19
            Associate = edRemoteControlShowLast
            Max = 1000
            Position = 100
            TabOrder = 1
          end
        end
      end
    end
  end
  object ilButton: TImageList
    Left = 16
    Top = 344
    Bitmap = {
      494C010101000800480010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
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
