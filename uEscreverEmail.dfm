object frmEscreverEmail: TfrmEscreverEmail
  Left = 0
  Top = 0
  Caption = 'Escrever'
  ClientHeight = 525
  ClientWidth = 633
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object TPanel
    Left = 0
    Top = 0
    Width = 633
    Height = 59
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 9
      Top = 8
      Width = 26
      Height = 13
      Caption = 'Para:'
    end
    object Label2: TLabel
      Left = 9
      Top = 35
      Width = 43
      Height = 13
      Caption = 'Assunto:'
    end
    object edtPara: TEdit
      Left = 72
      Top = 5
      Width = 393
      Height = 21
      TabOrder = 0
    end
    object edtAssunto: TEdit
      Left = 72
      Top = 32
      Width = 393
      Height = 21
      TabOrder = 1
    end
    object btnEnviar: TcxButton
      Left = 473
      Top = 3
      Width = 79
      Height = 50
      Caption = 'Enviar'
      OptionsImage.Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        00000000000000000000C6751BFFD69334FFD18420FFCC7C15FFCA7606FFC26A
        00FFA96100FF904000FF00000000000000000000000000000000000000000000
        00000000000000000000DFA442FFFBFFFFFFF8D772FFF5C75BFFF1BD41FFEDAE
        25FFD59000FFB05005FF00000000000000000000000000000000000000000000
        00000000000000000000EDAB2AFFEDAB2AFFE59E29FFE29B25FFDE9323FFDA8F
        22FFD4841CFFD3831CFF00000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000DD982CFFDEA13AFFDA9228FFD48924FFD08322FFCC7B
        1BFFC0680EFFB05503FF00000000000000000000000000000000000000000000
        00000000000000000000E09E36FFFBFFFFFFFBE18AFFF8DE81FFF6D270FFF5C9
        5FFFE5A630FFAE5202FF00000000000000000000000000000000000000000000
        00000000000000000000DC9A32FFFAFFFFFFF6D575FFF3CB68FFF2C257FFF1BB
        43FFE0951BFFAE5001FF00000000000000000000000000000000F1B538FFEBAD
        31FFE2941FFFDD8E1CFFD9962FFFF9FFFFFFF5CD6AFFF3C35FFFF1C04CFFEEB4
        3AFFDC9212FFAB4C00FFA54C00FF984500FF8E4300FF8F4400FFF0B134FFE9AD
        36FFF6F0D4FFF5E6BEFFF4D678FFF9E39EFFF4CB64FFF1C155FFEEB943FFEBB0
        33FFE49A08FFD08100FFC17700FFCA7D00FFA24600FF8E4300FF00000000EAA8
        2BFFE9AD36FFF9F5E3FFF5E6BEFFF6D777FFF2C659FFF1BD46FFEFB237FFEAAA
        26FFE39500FFCC8600FFC68200FFAB5607FF8C4200FF00000000000000000000
        0000DD8E21FFDB9528FFEEECE1FFF5E6BEFFF0BC45FFEDB135FFEAA622FFE79D
        0DFFC88200FFECB93EFFAB5607FF944200FF0000000000000000000000000000
        000000000000D7891BFFD68D24FFEDE3D7FFEEB334FFEAAB2BFFE7A116FFE59A
        00FFE8B830FFC0680EFF9C4400FF000000000000000000000000000000000000
        00000000000000000000D38017FFD0831FFFF1C35EFFE9A119FFE79907FFE8AD
        18FFC0680EFFA34A00FF00000000000000000000000000000000000000000000
        0000000000000000000000000000CE7811FFCE8836FFE9B939FFE29000FFC068
        0EFFA94C00FF0000000000000000000000000000000000000000000000000000
        000000000000000000000000000000000000BF6005FFCE8836FFC0680EFFB052
        00FF000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000BA5F07FFB65904FF0000
        0000000000000000000000000000000000000000000000000000}
      TabOrder = 2
      OnClick = btnEnviarClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 59
    Width = 633
    Height = 447
    Align = alClient
    TabOrder = 1
    object Gauge1: TGauge
      Left = 5
      Top = 3
      Width = 625
      Height = 2
      Progress = 0
    end
    object RichEdit1: TRichEdit
      Left = 5
      Top = 11
      Width = 625
      Height = 306
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object gpxAnexos: TGroupBox
      Left = 5
      Top = 320
      Width = 625
      Height = 121
      Caption = 'Anexos '
      TabOrder = 1
      object lstAnexos: TListBox
        Left = 5
        Top = 17
        Width = 613
        Height = 68
        Hint = 'Para excluir clique com o bot'#227'o direito do mouse.'
        ItemHeight = 13
        PopupMenu = ppAnexos
        TabOrder = 0
      end
      object btnAnexar: TcxButton
        Left = 5
        Top = 90
        Width = 132
        Height = 25
        Caption = 'Anexar Arquivo'
        OptionsImage.Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          20000000000000040000000000000000000000000000000000005E5B5AB1ACA9
          A8F7AEABABF3ADABA9F3ADABA9F3ADABA9F3ADABA9F3ADABA9F3ADABA9F3ADAB
          A9F3ADABA9F3ADABA9F3ADABA9F3AEABAAF3ACA9A8F75E5B5AB1B6B4B1FFE2E1
          E0FFADAAA7FFB3B0AEFFB3B0AEFFB3B0AEFFB3B0AEFFB3B0AEFFB3B0AEFFB3B0
          AEFFB3B0AEFFB3B0ADFFB4B1AEFFB0ADA9FFE2E0E0FFB6B4B1FFB7B5B2F2EDEC
          EBFFD1CFCEFFD4D4D1FFD4D4D1FFD4D4D1FFD4D4D1FFD4D4D1FFD4D4D1FFD4D4
          D1FFD4D3D1FFD6D4D1FFE2D7DDFFE7D3DDFFFBF3F9FFB6B4B1F2C2BFBDF3FFFF
          FFFFFAF9F9FFFBFBFAFFFBFBFAFFFBFBFAFFFBFBFAFFFBFBFAFFFBFBFAFFFBFB
          FAFFFAFAF9FFFFFFFFFFB2DABAFF19A83CFFD1E5CEFFCEC6C9F3D4D2D1F8FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFBDE9C8FF10C154FFD4F0D6FFE1D6DCF8BFBDBBF4F6F6
          F6FFF0EFF0FFF0EFF0FFF0EFF0FFF0EFF0FFF0EFF0FFF0F0F1FFE9F3F8F8E8F2
          F6F6E9F3F5F5EAF3F5F5EFF5F5F5F1F0F2FFFFF8FDFFBFBDBCF4100F0F164443
          41623A3938543B3A38553B3A38553B3A38553B393854393A3B516F5A4AA16150
          48945E4D4A925E4D4A9266514A994645476044444560100F0F16000000000000
          0000000000000000000000000000000000000000000000000000C66818FFDF94
          23FFCC6A00FFD17100FFB24000FF000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000D0955AFFF6D5
          6DFFE7A520FFEEAF2BFFC9771FFF000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000D59A5AFFF3D5
          7AFFE7AE36FFECB741FFCC7E26FF000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000D8985AFFF6DF
          94FFECBD4CFFF1C759FFD18328FF000000000000000000000000000000000000
          0000000000000000000000000000412B0E4CDFA141FFEBC982FFECC56FFFF5D9
          84FFF1CB68FFF1CD6AFFE8B653FFE1A745FFCA7926FF7A4615A0000000000000
          0000000000000000000000000000000000002519072AECBE67FFFBF0BCFFF5D9
          7DFFF4D57BFFF5D77DFFF8DF84FFE2A541FF633C117B00000000000000000000
          0000000000000000000000000000000000000000000021160425ECC772FFFCF4
          CEFFF9E08CFFF9E898FFE8B24CFF6F4615840000000000000000000000000000
          0000000000000000000000000000000000000000000000000000281D082CF1CC
          7EFFFDF6CBFFF1C860FF6D4B157B000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000001C15
          061EEEC563FF73571E7D00000000000000000000000000000000}
        TabOrder = 1
        OnClick = btnAnexarClick
      end
      object btnDesanexar: TcxButton
        Left = 148
        Top = 90
        Width = 133
        Height = 25
        Caption = 'Excluir Anexo'
        OptionsImage.Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000001511
          93B91C17C2F41B17C3F41C16C2F41A14BFF41914BFF41913BFF41A14BFF41A13
          BEF41A13BEF41B14C1F41812BDF41B14C1F4140F93B90000000019199BB92E2D
          FBFF2423EFFF0B06B6FF201DE5FF2B29FAFF2824F4FF2824F4FF2723F4FF2722
          F4FF2925FCFF130DCEFF0A05B0FF211AEFFF2921FBFF161498B92322D4FE272B
          EFFF1312B1FF6A67BFFF1B1AB0FF1F20E2FF2D2EF4FF282AEDFF2929EEFF2C2D
          F4FF0E0DCAFF3F3CB5FF9090CEFF1210B1FF2321EEFF1F1BD0FE2121C9F4100E
          BBFF918ED3FFFFFFFFFFADAAE0FF100FB2FF1C20E0FF3036F4FF2F35F4FF0D0D
          CEFF3835B8FFECECF8FFFFFFFFFF6A67C6FF0F0DC0FF201ECAF42428D0F41D24
          D7FF433DC3FFEBEAF8FFFFFFFFFFAFADE3FF1D1BB9FF1D24DEFF171CD7FF3934
          BEFFEEEDF9FFFFFFFFFFACAAE4FF1F1BBDFF252CE7FF2221CDF4252AD1F4384F
          FAFF161ED4FF3A32C5FFEDEDF9FFFFFFFFFFD0CEF0FF201FC1FF1E1DC0FFE2E2
          F6FFFFFFFFFFB3B1E8FF1511BFFF232DE5FF3241F7FF2324CDF42228D2F4364F
          F3FF3950F3FF151DD8FF3E35CCFFDEDBF6FFFFFFFFFFCFCDF2FFCFCEF3FFFFFF
          FFFFD4D3F3FF2321C7FF202CE3FF3447F4FF3144F2FF2023D0F4454BD9F43B55
          F3FF334BEFFF3852F4FF1F2ADFFF211DCBFFCDCCF4FFFFFFFFFFFFFFFFFFCDCB
          F4FF2120CDFF2232E3FF354DF4FF2F44EEFF364DF2FF4247D7F46366DFF46E82
          F7FF556AF2FF4862F3FF2B3BE8FF221FD2FFCDCBF3FFFFFFFFFFFFFFFFFFCDCB
          F4FF201DD2FF242FE4FF445DF3FF5366F2FF6A7DF6FF6064DDF46064E1F47388
          F7FF788CF6FF6472F1FF514BE0FFD5D2F7FFFFFFFFFFDCDAF8FFDCDAF8FFFFFF
          FFFFDCDAF8FF655EE2FF575EEAFF7588F6FF6F83F6FF5D62DFF46166E3F47891
          F7FF6779F2FF5550E6FFCAC6F6FFFFFFFFFFE9E8FCFF5851E6FF5954E6FFE0DE
          FAFFFFFFFFFFF6F5FDFF6F69E9FF575FECFF748CF7FF5F64E2F4636AE4F46F82
          F3FF5E59EBFFC2BFF7FFFFFFFFFFF2F1FDFF6E66ECFF5D68EFFF6472F1FF5E57
          EBFFC5C1F8FFFFFFFFFFF1F0FDFF7670ECFF616BF1FF6268E4F4646CE6F45A5C
          EFFF928BF3FFFFFFFFFFF1F0FEFF6F68F0FF5B64EFFF7A92F6FF7A91F6FF6775
          F2FF5551EDFFC3BFF9FFFFFFFFFFAFA8F7FF5857F0FF6165E4F46B74F1FE7A91
          F6FF5A57F0FFAEA8F7FF7771F3FF5F68F2FF7D96F6FF798EF5FF788EF5FF7C94
          F6FF6D7FF4FF5F5BF0FF948CF5FF5956F1FF758BF6FF6972EFFE4E54B0B985A1
          F7FF7C94F6FF5B5BF3FF6975F5FF84A1F8FF8099F7FF7F98F7FF7F98F7FF7E97
          F6FF819CF6FF7588F5FF5C5FF3FF7990F5FF819DF7FF4C53AEB9000000005055
          B1B96970E9F4666CE9F46971E9F4676EE9F4676EE9F4666EE9F4666EE9F4676E
          E9F4666DE9F4676FE9F4676FE9F4676EE9F44E53B0B900000000}
        TabOrder = 2
        OnClick = Excluir1Click
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 506
    Width = 633
    Height = 19
    Panels = <>
  end
  object ppAnexos: TPopupMenu
    Left = 512
    Top = 464
    object Excluir1: TMenuItem
      Caption = 'Excluir'
      OnClick = Excluir1Click
    end
  end
  object dlgAnexos: TOpenDialog
    Left = 424
    Top = 424
  end
end