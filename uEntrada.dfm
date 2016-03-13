object frmEntrada: TfrmEntrada
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Entrada'
  ClientHeight = 520
  ClientWidth = 761
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lstPrincipal: TListBox
    Left = 0
    Top = 0
    Width = 129
    Height = 501
    Align = alLeft
    ItemHeight = 13
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 129
    Top = 0
    Width = 632
    Height = 501
    Align = alClient
    TabOrder = 1
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 630
      Height = 34
      Align = alTop
      TabOrder = 0
      object btnEscrever: TcxButton
        Left = 480
        Top = 4
        Width = 143
        Height = 25
        Caption = 'Escrever Email'
        OptionsImage.Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000000000000000000000000000000000000000000008153B50165D
          C1ED1465C2E31565C0E31565C0E31565C0E31565C0E31565C0E31565C0E31565
          C0E3145DBEE31359BCE3135BBCE3135CBEE3145CC1ED08163B50153E90BA1893
          E8FF1285E4FF1487E5FF1487E5FF1487E5FF1487E5FF1487E5FF1487E5FF1485
          E3FF138DE9FF1490E9FF148EE9FF148FEAFF1392EBFF123B90BA2C8BE0FF1CAD
          F6FF095ACEFF095ACEFF095ACEFF095ACEFF095ACEFF095ACEFF095ACEFF095A
          CEFF0E92EEFF14BAFCFF13B4F8FF13B4F8FF13C0FFFF1676DCFF3086D5F226B1
          F1FF0F95E9FF0F95E9FF0F95E9FF0F95E9FF0F95E9FF0F95E9FF0F95E9FF0F95
          E9FF0F95E9FF14BAF7FF12B2F5FF12B2F5FF13BFFAFF1471CFF22F88D6F325C0
          F4FF095ACEFF095ACEFF095ACEFF095ACEFF095ACEFF095ACEFF095ACEFF095A
          CEFF10A1EDFF14C2F7FF12BCF5FF12BBF5FF11C9FAFF1675D3F33089D6F324C9
          F6FF0786DFFF0A8AE1FF0A8AE1FF0A8AE1FF0A8AE1FF0A8AE1FF0A8AE1FF0988
          E0FF00A6F0FF00C0F9FF00BBF7FF00BAF5FF00CBFCFF157CD5F32A86D5F323E2
          FCFF0ED0F9FF11D2F9FF11D2F9FF11D2F9FF11D2F9FF11D2F9FF0FD2FAFF0FD1
          F6FF31B6E9FF31B6E9FF31B6E9FF31B6E9FF31B6E9FF0566C9F32487D6F31CE2
          FCFF0ECBF4FF0FCCF5FF0FCCF5FF0FCCF5FF0FCCF5FF0FCCF5FF09CEF7FF18C3
          F5FFFFD1A7FFFDAD3EFFF9B14EFFFFB84CFFB7D6D2FF005DC5F3258BD6F218E8
          FAFF0BD0F5FF0CD1F5FF0CD1F5FF0CD1F5FF0CD1F5FF0DD1F5FF06D5F7FF11C6
          F7FFF7D7ACFFEBA81DFFE7AD31FFFFB331FFB0E0E0FF0066C7F22F9BE4FF29FC
          FCFF06D5F7FF06D5F7FF06D5F7FF06D5F7FF06D5F7FF06D5F7FF06D5F7FF1AD8
          EEFFFFFBE6FFFFF6CFFFFFF7D4FFFFFCD5FFBDF9EBFF007DD4FF1F4B9EBA29FC
          FCFF29FCFCFF29FCFCFF29FCFCFF29FCFCFF0EE4F7FF0EE4F7FF0EE4F7FF0EE4
          F7FF0EE4F7FF0EE4F7FF0EE4F7FF0EE4F7FF0EE4F7FF134A9EBA091942502E80
          D2ED2781CAE3267EC9E3267EC9E3277EC9E3277EC9E3277EC9E3277EC9E3287F
          C9E31D7BC7E31D7AC7E31C7AC6E31C7DC7E31D78CDED0A194350000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000}
        TabOrder = 0
        OnClick = btnEscreverClick
      end
    end
    object memLog: TMemo
      Left = 1
      Top = 411
      Width = 630
      Height = 89
      Align = alBottom
      TabOrder = 1
    end
    object grdEmails: TcxGrid
      Left = 1
      Top = 35
      Width = 630
      Height = 376
      Align = alClient
      TabOrder = 2
      object tv: TcxGridDBTableView
        OnDblClick = tvDblClick
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = dtsEmails
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        object tvLogin: TcxGridDBColumn
          DataBinding.FieldName = 'Login'
          Visible = False
          GroupIndex = 0
        end
        object tvremetente: TcxGridDBColumn
          DataBinding.FieldName = 'remetente'
          Width = 300
        end
        object tvassunto: TcxGridDBColumn
          DataBinding.FieldName = 'assunto'
          Width = 300
        end
      end
      object lv: TcxGridLevel
        GridView = tv
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 501
    Width = 761
    Height = 19
    Panels = <
      item
        Width = 250
      end
      item
        Width = 50
      end>
  end
  object IdMappedPOP31: TIdMappedPOP3
    Bindings = <>
    Greeting.Code = '+OK'
    Greeting.Text.Strings = (
      'POP3 proxy ready')
    ReplyUnknownCommand.Code = '-ERR'
    ReplyUnknownCommand.Text.Strings = (
      'command must be either USER or QUIT')
    UserHostDelimiter = '#'
    Left = 712
    Top = 208
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 712
    Top = 96
  end
  object IdIMAP41: TIdIMAP4
    SASLMechanisms = <>
    MilliSecsToWaitToClearBuffer = 10
    Left = 712
    Top = 144
  end
  object dtsEmails: TDataSource
    DataSet = cdsEmails_View
    Left = 336
    Top = 8
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 384
    Top = 8
  end
  object cdsEmails: TADODataSet
    Connection = frmLogin.con
    CursorType = ctStatic
    CommandText = 'SELECT * FROM tblEmail'
    Parameters = <>
    Left = 288
    Top = 8
    object cdsEmailsID: TAutoIncField
      FieldName = 'ID'
      ReadOnly = True
    end
    object cdsEmailsremetente: TStringField
      FieldName = 'remetente'
      Size = 255
    end
    object cdsEmailsassunto: TStringField
      FieldName = 'assunto'
      Size = 255
    end
    object cdsEmailstexto: TMemoField
      FieldName = 'texto'
      BlobType = ftMemo
    end
    object cdsEmailsIdUsuario: TIntegerField
      FieldName = 'IdUsuario'
    end
    object cdsEmailsidEmail: TIntegerField
      FieldName = 'idEmail'
    end
    object cdsEmailsarquivo: TBlobField
      FieldName = 'arquivo'
    end
  end
  object qryUsuarios: TADOQuery
    Connection = frmLogin.con
    Parameters = <>
    Left = 544
    Top = 8
  end
  object cdsEmails_View: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 272
    Top = 144
    object cdsEmails_ViewID: TAutoIncField
      FieldName = 'ID'
    end
    object cdsEmails_ViewLogin: TStringField
      FieldName = 'Login'
      Size = 50
    end
    object cdsEmails_Viewremetente: TStringField
      FieldName = 'remetente'
      Size = 255
    end
    object cdsEmails_Viewassunto: TStringField
      FieldName = 'assunto'
      Size = 255
    end
    object cdsEmails_ViewIdEmail: TIntegerField
      FieldName = 'IdEmail'
    end
  end
  object IdPOP3: TIdPOP3
    AutoLogin = True
    SASLMechanisms = <>
    Left = 448
    Top = 16
  end
end
