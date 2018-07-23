object About: TAbout
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
  ClientHeight = 220
  ClientWidth = 544
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
    544
    220)
  PixelsPerInch = 96
  TextHeight = 13
  object pcAbout: TPageControl
    Left = 8
    Top = 8
    Width = 528
    Height = 173
    ActivePage = TabAbout
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object TabAbout: TTabSheet
      Caption = 'TabAbout'
      object pAbout: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 514
        Height = 139
        Align = alClient
        BevelOuter = bvNone
        Caption = 'pAbout'
        ParentBackground = False
        TabOrder = 0
        OnClick = RandomColor
        DesignSize = (
          514
          139)
        object lName: TLabel
          Left = 119
          Top = 8
          Width = 52
          Height = 19
          Caption = 'lName'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          OnClick = RandomColor
        end
        object lVersion: TLabel
          Left = 119
          Top = 41
          Width = 37
          Height = 13
          Caption = 'lVersion'
          OnClick = RandomColor
        end
        object lVersionDate: TLabel
          Left = 119
          Top = 60
          Width = 60
          Height = 13
          Caption = 'lVersionDate'
          OnClick = RandomColor
        end
        object lLicense: TLabel
          Left = 352
          Top = 117
          Width = 154
          Height = 13
          Anchors = [akRight, akBottom]
          Caption = 'GNU General Public License v3.0'
          OnClick = RandomColor
          ExplicitTop = 184
        end
        object ImageLogo: TImage
          Left = 8
          Top = 8
          Width = 105
          Height = 105
          Center = True
          Picture.Data = {
            0954506E67496D61676589504E470D0A1A0A0000000D49484452000000600000
            00600806000000E2987738000000017352474200AECE1CE90000000467414D41
            0000B18F0BFC6105000000097048597300000EC300000EC301C76FA864000004
            EA4944415478DAED5D2170143114FD7595AD037728C0B50E148782CE3043EB40
            71C8BA3208A80214B822EB38575CC115C5A1A82BAEADE21C3870E0206F7633EC
            DCECDD25D9974B96FD6FE64F6FCAF0F6BDBCBD6C36C96E974491144BA905741D
            B905D02FAB094665B5425F6E013C37F5AC21C78B92A715FA720D2054D71F594C
            00347D1A40627D1A40627D1A40627D1A40627D1A40627DB904B0626ACDD41D53
            8F9906C9006F2B03B860EAB6A9CBA6AE95BFB38D5E070D800034EEA6A9BB32BD
            A1A741030804CEF427A6EE959F43A1017862D9D48E148DBF42E0D3003C80B37D
            4F9A9DF193D0001C807EFD8DF8F7EF2ED000E6A06FEA5038DD4D1D3480194097
            83337F3992C9505DB506C9006FD20070A1DD8B64AE0A0DA00668F89D08A6C665
            01BDB2348009B0CEFC2FA6DE9B7A577E8E6E900CBA3E17224C1D7C94F03EFF67
            795034FA78D106C9A0EB9B4784463F95A25B08C1BEA95D29424862900CBABE79
            4418ED0C020E84EE65DBD4716A8364D0F5CD221A4811802FD0E81BE27ED64735
            48065DDF34224C2B7C15FF7EFFC8D496A9DFB9182483AE6F1AD14B534F3DC99B
            367E148364D0F5D511E1ACC7D9EF33B9363675559A357E148364D0F5D511858C
            F96F0A673B20DD2019747D754418765EF120C550733B578364D0F54D126109F1
            D083702C9CAE279A4132E8FA26893ECBBF4573173C32F53A678364D0F5558930
            B7FFC3830C67FD2553DF733648065D5F95C8B7FB796BEA7EEE0673D75725F29D
            6E668D7CA21ACC5D5F95E844DCD777D1ED5C6C83C1DCF55922DC7CFDF220C2D4
            F2561B0CE6AECF12F5A598F377452C937483B9EBB34496D81598ED3C6A83C1DC
            F559A20329763BB86255C2A69B176E30777D9608DD4FDF91642CC5F8BF150673
            D767897CEE8047520C415B6130777D9608D3CF3D4792916800F4003005E1BACD
            7068EA615B0CE6AE6FA9F20FAE188A069034805619CC5D9F0690589F0690581F
            88B0F8FECD83A4550673D707A29E14C3505730D780A31BCC5D9F0D000BF1AE9B
            B086A2A3207A17843BE19E230926E136DA6230777D96C8673166247A279C7432
            EE4C8AAD28AD3098BB3E9D8E4EACCF12E5B020CF32085D9F2268036E48D153D0
            03F0DD9282A75E5E453008614D035804E801F86ECACA75513E77D0B6A58C25CE
            AA1884753600DFEBC0BAD43F6ADA0410D6D900300A3AF0208B312501619D0DA0
            277E7342D89CBB2ABCADE9221D0F00F0B90E00F806EC13054258A703F07D3C09
            D78075A24008EB7400210FE831EF0920ACD301541BC115B806E05B704610688F
            DDE900421ED2C6D3F1D7090221AC9377C29308793710BAA1DD86C620AC937341
            93C063AAA70107683A1389FFDBC9D9D05907F3C550C2972CE906C9A0EB9B47E4
            B35053051EE0C33D82EF9A01DD2019747DF38870413E91B097B2A2F1714DF0B9
            51A31B2483AECF85C877AD6012C7E5415D9EA8A11B2483AECF9588F1C6447C23
            B08EF0A1FC593787443748065D9F2B11EE093053BA49348300EC2BCDF0D8EB79
            F959039881D077C8F94203701011131AC01C0C24EC857EAED0001C80EB014288
            F106750DC011687CFCD50C8C90986F53D7003C811B35BC697140E2D30002B156
            0A6C3A5CD5001A025D13FE6ED8ADF2A7EF5486064006BE19361000D3DDB342D1
            0016088463475203530F9806C900EF7F17405483B9EBD30012EBD30012EBD300
            12EBD30012EBD30012EBCB358026584400347DB905D097B05D18558C24CE0384
            51F4E51640E7A00124C65F44D0877F1C901BC10000000049454E44AE426082}
          OnClick = RandomColor
        end
      end
    end
    object TabHistory: TTabSheet
      Caption = 'TabHistory'
      ImageIndex = 1
      object memoHistory: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 514
        Height = 139
        Align = alClient
        Lines.Strings = (
          'memoHistory')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object btnOK: TButton
    Left = 461
    Top = 187
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'btnOK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object llGitHub: TLinkLabel
    Left = 8
    Top = 191
    Width = 36
    Height = 17
    Hint = 'https://github.com/germandzmitry/HTPCControl'
    Anchors = [akLeft, akRight, akBottom]
    Caption = 
      '<a href="https://github.com/germandzmitry/HTPCControl">GitHub</a' +
      '>'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = llGitHubClick
  end
end
