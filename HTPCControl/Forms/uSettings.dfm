object Settings: TSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 410
  ClientWidth = 645
  Color = clBtnFace
  DoubleBuffered = True
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
    410)
  PixelsPerInch = 96
  TextHeight = 13
  object btnApply: TButton
    Left = 481
    Top = 377
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnApply'
    TabOrder = 2
    OnClick = btnApplyClick
    ExplicitTop = 391
  end
  object btnClose: TButton
    Left = 562
    Top = 377
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnClose'
    Default = True
    TabOrder = 3
    OnClick = btnCloseClick
    ExplicitTop = 367
  end
  object btnSave: TButton
    Left = 400
    Top = 377
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnSave'
    TabOrder = 1
    OnClick = btnSaveClick
    ExplicitTop = 367
  end
  object pClient: TPanel
    AlignWithMargins = True
    Left = 185
    Top = 3
    Width = 457
    Height = 367
    Margins.Bottom = 40
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'pClient'
    Color = clWhite
    Ctl3D = False
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 0
    ExplicitLeft = 175
    ExplicitWidth = 467
    ExplicitHeight = 357
    DesignSize = (
      455
      365)
    object pcSettings: TPageControl
      Left = 4
      Top = 7
      Width = 441
      Height = 345
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 40
      ActivePage = TabKodi
      Anchors = [akLeft, akTop, akRight, akBottom]
      MultiLine = True
      Style = tsFlatButtons
      TabHeight = 21
      TabOrder = 0
      ExplicitWidth = 432
      object TabApplication: TTabSheet
        Caption = 'TabApplication'
        ExplicitWidth = 443
        ExplicitHeight = 283
        DesignSize = (
          433
          290)
        object gbAplication: TGroupBox
          Left = 3
          Top = 3
          Width = 427
          Height = 166
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbAplication'
          TabOrder = 0
          ExplicitWidth = 437
          DesignSize = (
            427
            166)
          object cbApplicationAutoRun: TCheckBox
            Left = 16
            Top = 24
            Width = 393
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbApplicationAutoRun'
            TabOrder = 0
            OnClick = cbApplicationAutoRunClick
            ExplicitWidth = 403
          end
          object cbApplicationAutoRunTray: TCheckBox
            Left = 32
            Top = 47
            Width = 377
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbApplicationAutoRunTray'
            TabOrder = 1
            ExplicitWidth = 387
          end
          object cbApplicationAutoRunSetVolume: TCheckBox
            Left = 32
            Top = 70
            Width = 278
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbApplicationAutoRunSetVolume'
            TabOrder = 2
            OnClick = cbApplicationAutoRunSetVolumeClick
            ExplicitWidth = 288
          end
          object cbApplicationTurnTray: TCheckBox
            Left = 16
            Top = 116
            Width = 393
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbApplicationTurnTray'
            TabOrder = 3
            ExplicitWidth = 403
          end
          object cbApplicationCloseTray: TCheckBox
            Left = 16
            Top = 139
            Width = 393
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbApplicationCloseTray'
            TabOrder = 4
            ExplicitWidth = 403
          end
          object edApplicationAutoRunVolume: TEdit
            Left = 355
            Top = 68
            Width = 38
            Height = 19
            Alignment = taCenter
            Anchors = [akTop, akRight]
            TabOrder = 5
            Text = '0'
            ExplicitLeft = 365
          end
          object udApplicationAutoRunVolume: TUpDown
            Left = 393
            Top = 68
            Width = 16
            Height = 19
            Anchors = [akTop, akRight]
            Associate = edApplicationAutoRunVolume
            TabOrder = 6
            ExplicitLeft = 403
          end
          object cbApplicationAutoRunNotificationCenter: TCheckBox
            Left = 32
            Top = 93
            Width = 377
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbApplicationAutoRunNotificationCenter'
            TabOrder = 7
            ExplicitWidth = 387
          end
        end
      end
      object TabComPort: TTabSheet
        Caption = 'TabComPort'
        ImageIndex = 1
        ExplicitWidth = 443
        ExplicitHeight = 283
        DesignSize = (
          433
          290)
        object gbComPort: TGroupBox
          Left = 3
          Top = 3
          Width = 427
          Height = 102
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbComPort'
          TabOrder = 0
          ExplicitWidth = 437
          DesignSize = (
            427
            102)
          object lComPortPort: TLabel
            Left = 16
            Top = 50
            Width = 185
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'lComPortPort'
          end
          object lComPortSpeed: TLabel
            Left = 17
            Top = 77
            Width = 184
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'lComPortSpeed'
          end
          object cbComPortPort: TComboBox
            Left = 207
            Top = 47
            Width = 145
            Height = 21
            TabOrder = 0
            Text = 'cbComPortPort'
          end
          object cbComPortSpeed: TComboBox
            Left = 207
            Top = 74
            Width = 74
            Height = 21
            TabOrder = 1
            Text = 'cbComPortSpeed'
          end
          object cbComPortOpenRun: TCheckBox
            Left = 16
            Top = 24
            Width = 397
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbComPortOpenRun'
            TabOrder = 2
            ExplicitWidth = 407
          end
        end
        object gbComPortData: TGroupBox
          Left = 3
          Top = 111
          Width = 427
          Height = 50
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbComPortData'
          TabOrder = 1
          ExplicitWidth = 437
          DesignSize = (
            427
            50)
          object lComPortShowLast: TLabel
            Left = 16
            Top = 24
            Width = 344
            Height = 13
            AutoSize = False
            Caption = 'lComPortShowLast'
            Layout = tlCenter
          end
          object edComPortShowLast: TEdit
            Left = 356
            Top = 22
            Width = 41
            Height = 19
            Alignment = taCenter
            Anchors = [akTop, akRight]
            NumbersOnly = True
            TabOrder = 0
            Text = '100'
            OnChange = edComPortShowLastChange
            ExplicitLeft = 366
          end
          object udComPortShowLast: TUpDown
            Left = 397
            Top = 22
            Width = 16
            Height = 19
            Anchors = [akTop, akRight]
            Associate = edComPortShowLast
            Max = 1000
            Position = 100
            TabOrder = 1
            ExplicitLeft = 407
          end
        end
      end
      object TabEventApplication: TTabSheet
        Caption = 'TabEventApplication'
        ImageIndex = 2
        ExplicitWidth = 443
        ExplicitHeight = 283
        DesignSize = (
          433
          290)
        object gbEventApplication: TGroupBox
          Left = 3
          Top = 3
          Width = 427
          Height = 270
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbEventApplication'
          TabOrder = 0
          ExplicitWidth = 437
          DesignSize = (
            427
            270)
          object clbEventApplication: TCheckListBox
            Left = 24
            Top = 47
            Width = 385
            Height = 210
            Anchors = [akLeft, akTop, akRight]
            ItemHeight = 13
            TabOrder = 0
            ExplicitWidth = 395
          end
          object cbEventAppicationUsing: TCheckBox
            Left = 16
            Top = 24
            Width = 393
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbEventAppicationUsing'
            TabOrder = 1
            OnClick = cbEventAppicationUsingClick
            ExplicitWidth = 403
          end
        end
      end
      object TabDB: TTabSheet
        Caption = 'TabDB'
        ImageIndex = 3
        ExplicitWidth = 443
        ExplicitHeight = 283
        DesignSize = (
          433
          290)
        object gbDBAccess: TGroupBox
          Left = 3
          Top = 3
          Width = 427
          Height = 86
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbDBAccess'
          TabOrder = 0
          ExplicitWidth = 437
          DesignSize = (
            427
            86)
          object lDBFilleName: TLabel
            Left = 16
            Top = 27
            Width = 73
            Height = 13
            AutoSize = False
            Caption = 'lDBFilleName'
          end
          object lDBTestConnection: TLabel
            Left = 143
            Top = 49
            Width = 266
            Height = 25
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 'lDBTestConnection'
            Layout = tlCenter
            WordWrap = True
            ExplicitWidth = 276
          end
          object sbtnDBSelectFile: TSpeedButton
            Left = 367
            Top = 22
            Width = 23
            Height = 23
            Anchors = [akTop, akRight]
            ParentShowHint = False
            ShowHint = True
            OnClick = sbtnDBSelectFileClick
            ExplicitLeft = 377
          end
          object sbtnDBCreate: TSpeedButton
            Left = 396
            Top = 22
            Width = 23
            Height = 23
            Anchors = [akTop, akRight]
            ParentShowHint = False
            ShowHint = True
            OnClick = sbtnDBCreateClick
            ExplicitLeft = 406
          end
          object edDBFileName: TEdit
            Left = 95
            Top = 24
            Width = 266
            Height = 19
            Anchors = [akLeft, akTop, akRight]
            ReadOnly = True
            TabOrder = 0
            Text = 'edDBFileName'
            ExplicitWidth = 276
          end
          object btnDBTestConnection: TButton
            Left = 16
            Top = 49
            Width = 121
            Height = 25
            Caption = 'btnDBTestConnection'
            TabOrder = 1
            OnClick = btnDBTestConnectionClick
          end
        end
        object gbDBHelp: TGroupBox
          Left = 3
          Top = 95
          Width = 427
          Height = 74
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbDBHelp'
          TabOrder = 1
          ExplicitWidth = 437
          DesignSize = (
            427
            74)
          object llDBDriver1: TLinkLabel
            Left = 16
            Top = 24
            Width = 393
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 'llDBDriver1'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = llDBDriverClick
            ExplicitWidth = 403
          end
          object llDBDriver2: TLinkLabel
            Left = 16
            Top = 47
            Width = 393
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 'llDBDriver2'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = llDBDriverClick
            ExplicitWidth = 403
          end
        end
      end
      object TabKodi: TTabSheet
        Caption = 'TabKodi'
        ImageIndex = 4
        ExplicitWidth = 443
        ExplicitHeight = 283
        DesignSize = (
          433
          290)
        object gbKodiConnect: TGroupBox
          Left = 3
          Top = 63
          Width = 427
          Height = 226
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbKodiConnect'
          TabOrder = 0
          ExplicitWidth = 437
          DesignSize = (
            427
            226)
          object lKodiHelp: TLabel
            Left = 16
            Top = 24
            Width = 393
            Height = 41
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 'lKodiHelp'
            WordWrap = True
            ExplicitWidth = 397
          end
          object lKodiIP: TLabel
            Left = 24
            Top = 121
            Width = 98
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'lKodiIP'
          end
          object lKodiPort: TLabel
            Left = 294
            Top = 121
            Width = 42
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            AutoSize = False
            Caption = 'lKodiPort'
            ExplicitLeft = 304
          end
          object lKodiUser: TLabel
            Left = 24
            Top = 146
            Width = 98
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'lKodiUser'
          end
          object lKodiPassword: TLabel
            Left = 24
            Top = 171
            Width = 98
            Height = 13
            Alignment = taRightJustify
            AutoSize = False
            Caption = 'lKodiPassword'
          end
          object lKodiTestConnection: TLabel
            Left = 151
            Top = 193
            Width = 273
            Height = 25
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 'lKodiTestConnection'
            Layout = tlCenter
            WordWrap = True
            ExplicitWidth = 264
          end
          object lKodiUpdateInterval: TLabel
            Left = 25
            Top = 96
            Width = 95
            Height = 13
            Caption = 'lKodiUpdateInterval'
          end
          object edKodiIP: TEdit
            Left = 128
            Top = 119
            Width = 160
            Height = 19
            Alignment = taCenter
            Anchors = [akLeft, akTop, akRight]
            MaxLength = 15
            TabOrder = 0
            Text = 'edKodiIP'
            ExplicitWidth = 170
          end
          object edKodiPort: TEdit
            Left = 342
            Top = 119
            Width = 67
            Height = 19
            Alignment = taCenter
            Anchors = [akTop, akRight]
            MaxLength = 4
            NumbersOnly = True
            TabOrder = 1
            Text = 'edKodiPort'
            ExplicitLeft = 352
          end
          object edKodiUser: TEdit
            Left = 128
            Top = 144
            Width = 281
            Height = 19
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 2
            Text = 'edKodiUser'
            ExplicitWidth = 291
          end
          object edKodiPassword: TEdit
            Left = 128
            Top = 169
            Width = 281
            Height = 19
            Anchors = [akLeft, akTop, akRight]
            TabOrder = 3
            Text = 'edKodiPassword'
            ExplicitWidth = 291
          end
          object btnKodiTestConnect: TButton
            Left = 24
            Top = 194
            Width = 121
            Height = 25
            Caption = 'btnKodiTestConnect'
            TabOrder = 4
            OnClick = btnKodiTestConnectClick
          end
          object cbKodiUsing: TCheckBox
            Left = 16
            Top = 71
            Width = 393
            Height = 17
            Anchors = [akLeft, akTop, akRight]
            Caption = 'cbKodiUsing'
            TabOrder = 5
            OnClick = cbKodiUsingClick
            ExplicitWidth = 403
          end
          object edKodiUpdateInterval: TEdit
            Left = 355
            Top = 94
            Width = 38
            Height = 19
            Alignment = taCenter
            Anchors = [akTop, akRight]
            NumbersOnly = True
            TabOrder = 6
            Text = '0'
            ExplicitLeft = 365
          end
          object udKodiUpdateInterval: TUpDown
            Left = 393
            Top = 94
            Width = 16
            Height = 19
            Anchors = [akTop, akRight]
            Associate = edKodiUpdateInterval
            TabOrder = 7
            ExplicitLeft = 403
          end
        end
        object gbKodi: TGroupBox
          Left = 3
          Top = 3
          Width = 427
          Height = 54
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbKodi'
          TabOrder = 1
          ExplicitWidth = 437
          DesignSize = (
            427
            54)
          object lKodiFileName: TLabel
            Left = 16
            Top = 27
            Width = 73
            Height = 13
            AutoSize = False
            Caption = 'lKodiFileName'
          end
          object sbtnKodiSelectFile: TSpeedButton
            Left = 396
            Top = 22
            Width = 23
            Height = 23
            Anchors = [akTop, akRight]
            ParentShowHint = False
            ShowHint = True
            OnClick = sbtnKodiSelectFileClick
            ExplicitLeft = 406
          end
          object edKodiFileName: TEdit
            Left = 95
            Top = 24
            Width = 295
            Height = 19
            Anchors = [akLeft, akTop, akRight]
            ReadOnly = True
            TabOrder = 0
            Text = 'edKodiFileName'
            ExplicitWidth = 305
          end
        end
      end
      object TabRemoteControl: TTabSheet
        Caption = 'TabRemoteControl'
        ImageIndex = 5
        ExplicitWidth = 443
        ExplicitHeight = 283
        DesignSize = (
          433
          290)
        object gbRemoteControl: TGroupBox
          Left = 3
          Top = 3
          Width = 427
          Height = 54
          Anchors = [akLeft, akTop, akRight]
          Caption = 'gbRemoteControl'
          TabOrder = 0
          ExplicitWidth = 437
          DesignSize = (
            427
            54)
          object lRemoteControlShowLast: TLabel
            Left = 17
            Top = 24
            Width = 333
            Height = 13
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 'lRemoteControlShowLast'
            Layout = tlCenter
            ExplicitWidth = 343
          end
          object edRemoteControlShowLast: TEdit
            Left = 356
            Top = 22
            Width = 41
            Height = 19
            Alignment = taCenter
            Anchors = [akTop, akRight]
            NumbersOnly = True
            TabOrder = 0
            Text = '100'
            OnChange = edComPortShowLastChange
            ExplicitLeft = 366
          end
          object udRemoteControlShowLast: TUpDown
            Left = 397
            Top = 22
            Width = 16
            Height = 19
            Anchors = [akTop, akRight]
            Associate = edRemoteControlShowLast
            Max = 1000
            Position = 100
            TabOrder = 1
            ExplicitLeft = 407
          end
        end
      end
    end
  end
  object pLeft: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 176
    Height = 367
    Margins.Bottom = 40
    Align = alLeft
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = 'pLeft'
    Color = clWhite
    Ctl3D = False
    Padding.Top = 3
    Padding.Bottom = 3
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 4
    object tvSettings: TTreeView
      Left = 11
      Top = 25
      Width = 142
      Height = 216
      Margins.Bottom = 40
      HideSelection = False
      Indent = 19
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      OnAdvancedCustomDrawItem = tvSettingsAdvancedCustomDrawItem
      OnChange = tvSettingsChange
      OnCustomDrawItem = tvSettingsCustomDrawItem
      Items.NodeData = {
        0302000000200000000000000000000000FFFFFFFFFFFFFFFF00000000000000
        000000000001013100200000000000000000000000FFFFFFFFFFFFFFFF000000
        00000000000100000001013200200000000000000000000000FFFFFFFFFFFFFF
        FF00000000000000000000000001013300}
    end
  end
  object ilButton: TImageList
    Left = 16
    Top = 344
    Bitmap = {
      494C0101010008004C0010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
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
