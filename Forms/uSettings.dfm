object Settings: TSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 400
  ClientWidth = 451
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
    Width = 445
    Height = 362
    ActivePage = TabComPort
    Align = alClient
    TabOrder = 0
    object TabApplication: TTabSheet
      Caption = 'TabApplication'
      DesignSize = (
        437
        334)
      object gbAplication: TGroupBox
        Left = 3
        Top = 3
        Width = 431
        Height = 142
        Anchors = [akLeft, akTop, akRight]
        Caption = 'gbAplication'
        TabOrder = 0
        DesignSize = (
          431
          142)
        object cbApplicationAutoRun: TCheckBox
          Left = 16
          Top = 24
          Width = 397
          Height = 17
          Anchors = [akLeft, akTop, akRight]
          Caption = 'cbApplicationAutoRun'
          TabOrder = 0
        end
      end
    end
    object TabComPort: TTabSheet
      Caption = 'TabComPort'
      ImageIndex = 1
      DesignSize = (
        437
        334)
      object gbComPort: TGroupBox
        Left = 3
        Top = 3
        Width = 431
        Height = 118
        Anchors = [akLeft, akTop, akRight]
        Caption = 'gbComPort'
        TabOrder = 0
        DesignSize = (
          431
          118)
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
          Width = 401
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
        437
        334)
      object gbEventApplication: TGroupBox
        Left = 3
        Top = 3
        Width = 431
        Height = 286
        Anchors = [akLeft, akTop, akRight]
        Caption = 'gbEventApplication'
        TabOrder = 0
        DesignSize = (
          431
          286)
        object clbEventApplication: TCheckListBox
          Left = 24
          Top = 47
          Width = 389
          Height = 210
          Anchors = [akLeft, akTop, akRight]
          ItemHeight = 13
          TabOrder = 0
        end
        object cbEventAppicationUsing: TCheckBox
          Left = 16
          Top = 24
          Width = 397
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
    end
    object TabKodi: TTabSheet
      Caption = 'TabKodi'
      ImageIndex = 4
      DesignSize = (
        437
        334)
      object gbMediaPlayer: TGroupBox
        Left = 3
        Top = 3
        Width = 431
        Height = 206
        Anchors = [akLeft, akTop, akRight]
        Caption = 'gbMediaPlayer'
        TabOrder = 0
        DesignSize = (
          431
          206)
        object lKodiHelp: TLabel
          Left = 16
          Top = 24
          Width = 397
          Height = 41
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'lKodiHelp'
          WordWrap = True
        end
        object lKodiIP: TLabel
          Left = 16
          Top = 82
          Width = 32
          Height = 13
          Caption = 'lKodiIP'
        end
        object lKodiPort: TLabel
          Left = 325
          Top = 82
          Width = 42
          Height = 13
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          Caption = 'lKodiPort'
        end
        object lKodiUser: TLabel
          Left = 16
          Top = 109
          Width = 44
          Height = 13
          Caption = 'lKodiUser'
        end
        object lKodiPassword: TLabel
          Left = 16
          Top = 136
          Width = 68
          Height = 13
          Caption = 'lKodiPassword'
        end
        object lKodiTestConnection: TLabel
          Left = 143
          Top = 168
          Width = 270
          Height = 25
          Anchors = [akLeft, akTop, akRight]
          AutoSize = False
          Caption = 'lKodiTestConnection'
          Layout = tlCenter
          WordWrap = True
        end
        object edKodiIP: TEdit
          Left = 120
          Top = 79
          Width = 121
          Height = 21
          MaxLength = 15
          TabOrder = 0
          Text = 'edKodiIP'
        end
        object edKodiPort: TEdit
          Left = 373
          Top = 79
          Width = 40
          Height = 21
          Alignment = taRightJustify
          Anchors = [akTop, akRight]
          MaxLength = 4
          NumbersOnly = True
          TabOrder = 1
          Text = 'edKodiPort'
        end
        object edKodiUser: TEdit
          Left = 120
          Top = 106
          Width = 161
          Height = 21
          TabOrder = 2
          Text = 'edKodiUser'
        end
        object edKodiPassword: TEdit
          Left = 120
          Top = 133
          Width = 161
          Height = 21
          TabOrder = 3
          Text = 'edKodiPassword'
        end
        object btnKodiTestConnect: TButton
          Left = 16
          Top = 168
          Width = 121
          Height = 25
          Caption = 'btnKodiTestConnect'
          TabOrder = 4
          OnClick = btnKodiTestConnectClick
        end
      end
    end
  end
  object pButton: TPanel
    Left = 0
    Top = 368
    Width = 451
    Height = 32
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      451
      32)
    object btnClose: TButton
      Left = 369
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'btnClose'
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object btnSave: TButton
      Left = 288
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'btnSave'
      TabOrder = 1
      OnClick = btnSaveClick
    end
  end
end
