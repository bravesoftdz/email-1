unit uEntrada;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, IdMessage, IdBaseComponent, IdComponent, IdCustomTCPServer,
  IdMappedPortTCP, IdMappedTelnet, IdMappedPOP3, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, IdSSL, IdSSLOpenSSL, Vcl.ComCtrls, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient, IdIMAP4, Data.DB,
  Datasnap.DBClient, Data.Win.ADODB, IdPOP3, uConexaoDB, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, cxNavigator, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, uUsuarioLogado, Vcl.Menus, cxButtons;

type
  TfrmEntrada = class(TForm)
    lstPrincipal: TListBox;
    Panel1: TPanel;
    IdMappedPOP31: TIdMappedPOP3;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    IdIMAP41: TIdIMAP4;
    StatusBar1: TStatusBar;
    dtsEmails: TDataSource;
    Timer1: TTimer;
    Panel2: TPanel;
    memLog: TMemo;
    cdsEmails: TADODataSet;
    tv: TcxGridDBTableView;
    lv: TcxGridLevel;
    grdEmails: TcxGrid;
    cdsEmailsID: TAutoIncField;
    cdsEmailsremetente: TStringField;
    cdsEmailsassunto: TStringField;
    cdsEmailstexto: TMemoField;
    cdsEmailsIdUsuario: TIntegerField;
    cdsEmailsidEmail: TIntegerField;
    qryUsuarios: TADOQuery;
    cdsEmails_View: TClientDataSet;
    cdsEmails_ViewID: TAutoIncField;
    cdsEmails_Viewremetente: TStringField;
    cdsEmails_Viewassunto: TStringField;
    cdsEmails_ViewLogin: TStringField;
    tvLogin: TcxGridDBColumn;
    tvremetente: TcxGridDBColumn;
    tvassunto: TcxGridDBColumn;
    cdsEmails_ViewIdEmail: TIntegerField;
    cdsEmailsarquivo: TBlobField;
    btnEscrever: TcxButton;
    IdPOP3: TIdPOP3;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnEscreverClick(Sender: TObject);
    procedure tvDblClick(Sender: TObject);
  private
    FoConexaoDB: TConexao;
    FoUsuarioLogado: TUsuarioLogado;

    procedure ReceberEmail(IdUsuario: Integer; Login, Senha: string);
    procedure Log(LogMsg: string);
    procedure CarregarEmails;
    procedure AlimentarClient;
    function CarregarArquivo(IdEmail: Integer): TMemoryStream;
    { Private declarations }
  public
    { Public declarations }
    procedure BeforeDestruction; override;
    procedure AfterConstruction; override;

    property UsuarioLogado: TUsuarioLogado read FoUsuarioLogado;
  end;

var
  frmEntrada: TfrmEntrada;

implementation

{$R *.dfm}

uses uCadastroUsuarios, uEscreverEmail, uLogin, LIB;


procedure TfrmEntrada.AfterConstruction;
begin
  inherited;
  FoConexaoDB:= TConexao.Create;
  FoUsuarioLogado:= TUsuarioLogado.Create;
  FoUsuarioLogado.con:= frmLogin.con;
  FoUsuarioLogado.Execute();
end;

procedure TfrmEntrada.BeforeDestruction;
begin
  FreeAndNil(FoConexaoDB);
  FreeAndNil(FoUsuarioLogado);
  inherited;
end;

procedure TfrmEntrada.btnEscreverClick(Sender: TObject);
begin
  frmEscreverEmail:= TfrmEscreverEmail.Create(nil);
  frmEscreverEmail.UsuarioLogado:= FoUsuarioLogado;
  frmEscreverEmail.ShowModal;
  FreeAndNil(frmEscreverEmail);
end;


procedure TfrmEntrada.Log( LogMsg: string );
begin
  memLog.Lines.Add( LogMsg );
  Application.ProcessMessages;
end;


procedure TfrmEntrada.FormShow(Sender: TObject);
begin
//  FoConexaoDB.con:= frmLogin.con;
//  FoConexaoDB.Conectar();

  lstPrincipal.Items.Add('Entrada');
  lstPrincipal.Items.Add('Enviados');
  lstPrincipal.Items.Add('Lixo');

//  Timer1.Interval:= 1;
//  Timer1.Enabled:= True;
  CarregarEmails();
end;

procedure TfrmEntrada.Timer1Timer(Sender: TObject);
begin
//  CarregarEmails();
end;

function TfrmEntrada.CarregarArquivo(IdEmail: Integer):TMemoryStream;
var
  qry: TADOQuery;
begin
  Result:= TMemoryStream.Create;
  qry:= TADOQuery.Create(nil);
  try
    qry.Connection:= frmLogin.con;
    qry.SQL.Text:= Format('SELECT arquivo FROM tblEmail WHERE idEmail = %d', [IdEmail]);
    qry.Open;

    if not qry.IsEmpty then
      TBlobField( qry.FieldByName('arquivo') ).SaveToStream(Result);
  finally
    FreeAndNil(qry);
  end;
end;

procedure TfrmEntrada.tvDblClick(Sender: TObject);
begin
  frmEscreverEmail:= TfrmEscreverEmail.Create(Self);
  try
    frmEscreverEmail.AbrirEmail( CarregarArquivo( cdsEmails_ViewIdEmail.AsInteger ) );
    frmEscreverEmail.ShowModal;
  finally
    FreeAndNil( frmEscreverEmail );
  end;
end;

procedure TfrmEntrada.CarregarEmails();
begin
  cdsEmails.Close;
  cdsEmails.Connection:= frmLogin.con;
  cdsEmails.Open;

//  Timer1.Interval:= 5000;
//  Timer1.Enabled:= False;
  qryUsuarios.Close;
  qryUsuarios.Connection:= frmLogin.con;
  qryUsuarios.SQL.Clear;
  qryUsuarios.SQL.Text:= 'SELECT * FROM dbo.tblUsuario';
  qryUsuarios.Open;

//  qryUsuarios.First;
//  while not qryUsuarios.Eof do
//  begin
//    ReceberEmail( qryUsuarios.FieldByName('ID').AsInteger,
//                  qryUsuarios.FieldByName('Login').AsString,
//                  qryUsuarios.FieldByName('Senha').AsString );
//    qryUsuarios.Next;
//  end;
//
//  AlimentarClient();

  ReceberEmail(0, '', '');
//  Timer1.Enabled:= True;
end;

procedure TfrmEntrada.AlimentarClient();
var
  loQuery: TADOQuery;
begin
  loQuery:= TADOQuery.Create(nil);
  try
    loQuery.Connection:= frmLogin.con;
    loQuery.SQL.Text:= 'SELECT * FROM tblEmail';
    loQuery.Open;

    if cdsEmails_View.Active then
      cdsEmails_View.EmptyDataSet;

    cdsEmails_View.Close;
    cdsEmails_View.CreateDataSet;

    cdsEmails_View.DisableControls;
    loQuery.First;
    while not loQuery.Eof do
    begin
      cdsEmails_View.Append;
      cdsEmails_Viewremetente.AsString:= loQuery.FieldByName('remetente').AsString;
      cdsEmails_Viewassunto.AsString:= loQuery.FieldByName('assunto').AsString;

      if qryUsuarios.Locate('ID', loQuery.FieldByName('IdUsuario').AsInteger, []) then
        cdsEmails_ViewLogin.AsString:= qryUsuarios.FieldByName('Login').AsString;

      cdsEmails_ViewIdEmail.AsInteger:= loQuery.FieldByName('idEmail').AsInteger;
      cdsEmails_View.Post;
      loQuery.Next;
    end;
    cdsEmails_View.EnableControls;
  finally
    FreeAndNil(loQuery);
  end;
end;

procedure TfrmEntrada.ReceberEmail(IdUsuario: Integer; Login, Senha: string);
begin

end;
//var
//  IMAPClient: TIdIMAP4;
//  UsersFolders: TStringList;
//  OpenSSLHandler: TIdSSLIOHandlerSocketOpenSSL;
//  res: Boolean;
//  i: integer;
//  inbox, currUID: string;
//  cntMsg: integer;
//  msg, msg2: TIdMessage;
//  BodyTexts: TStringList;
//  flags: TIdMessageFlagsSet;
//  fileName_MailSource, TmpFolder: string;
//  fStream: TMemoryStream;
//begin
//  IMAPClient := TIdIMAP4.Create( nil );
//  try
//    OpenSSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create( nil );
//    try
////      IMAPClient.Host := 'imap.gmail.com';
////      IMAPClient.Port := 993;
////      IMAPClient.Username := Login;
////      IMAPClient.Password := Cript(Senha, toDecript);
////      IMAPClient.Username := 'edson.desbravador@gmail.com';
////      IMAPClient.Password := 'bingola1987!';
//
//      if Pos( 'gmail.com', IMAPClient.Host ) > 0 then
//      begin
//        OpenSSLHandler.SSLOptions.Method := sslvSSLv3;
//        IMAPClient.IOHandler := OpenSSLHandler;
//        IMAPClient.UseTLS := utUseImplicitTLS;
//      end;
//
//      if Pos( 'risau.com.br', IMAPClient.Host ) > 0 then
//      begin
//        OpenSSLHandler.SSLOptions.Method := sslvSSLv23;
//        IMAPClient.IOHandler := OpenSSLHandler;
//        IMAPClient.UseTLS := utNoTLSSupport;
//      end;
//
//      try
//        res := IMAPClient.Connect;
//        if not res then begin
//          Log( '  Unsuccessful connection.' );
//          exit;
//        end;
//
//      except on e: Exception do
//        begin
//          Log( '   Unsuccessful connection.' );
//          Log( '  (' + Trim( e.Message ) + ')' );
//          exit;
//        end;
//      end;
//
//      try
//        UsersFolders := TStringList.Create;
//        try
//          res := IMAPClient.ListMailBoxes( UsersFolders );
//          if not res then
//          begin
//            Log( '  ListMailBoxes error.' );
//            exit
//          end;
//        except on e: Exception do
//          begin
//            Log( '  ListMailBoxes error.' );
//            Log( '  (' + Trim( e.Message ) + ')' );
//            exit;
//          end;
//        end;
//
//        Log( 'User folders: ' + IntToStr( UsersFolders.Count ) );
//        for i := 0 to UsersFolders.Count - 1 do
//          Log( '  [' + inttostr( i + 1 ) + '/' + inttostr( UsersFolders.Count ) + '] Folder: "' + UsersFolders[ i ] + '"' );
//
//        IMAPClient.RetrieveOnSelect := rsDisabled;
//        inbox := 'INBOX';
//        Log( 'Opening folder "' + inbox + '"...' );
//        res := IMAPClient.SelectMailBox( inbox );
//        cntMsg := IMAPClient.MailBox.TotalMsgs;
//        Log( 'E-mails to read: ' + IntToStr( cntMsg ) );
//
////        res := IMAPClient.RetrieveAllEnvelopes( AMsgList );
//        if cdsEmails.RecordCount >= cntMsg - 1 then
//          Exit;
//
//        msg := TIdMessage.Create( nil );
//        msg2 := TIdMessage.Create( nil );
//        BodyTexts := TStringList.Create;
//        TmpFolder := 'c:\';
//        res := IMAPClient.CreateMailBox( 'Temp2' );
//        try
//          for I := 0 to cntMsg - 1 do
//          begin
//            Log( '  [' + inttostr( i + 1 ) + '/' + inttostr( cntMsg ) + '] E-mail...' );
//
//            IMAPClient.GetUID( i + 1, currUID );
//
//            Log( '(Downloading message...)' );
//            IMAPClient.UIDRetrieve( currUID, msg );
//
//            fileName_MailSource := TmpFolder + 'Log_Mail_' + currUID + '.eml';
////            msg.SaveToFile( fileName_MailSource, false );
//            fStream:= TMemoryStream.Create;
//            try
//              msg.SaveToStream(fStream);
//
//              if cdsEmails.Locate('idEmail', StrToIntDef(currUID, 0), [loCaseInsensitive]) then
//                Continue;
//
//              cdsEmails.Append;
//              cdsEmailsidEmail.AsInteger:= StrToIntDef(currUID, 0);
//              cdsEmailsremetente.AsString:= msg.From.Text;
//              cdsEmailsassunto.AsString:= msg.Subject;
//              cdsEmailsIdUsuario.AsInteger:= IdUsuario;
//              cdsEmailstexto.AsString:= msg.Body.Text;
//              cdsEmailsarquivo.LoadFromStream(fStream);
//              cdsEmails.Post;
//            finally
//              FreeAndNil(fStream);
//            end;
//
//            // In the final version I will delete the original message
//            // so I have to recreate it from the archived file
//
////            msg2.LoadFromFile( fileName_MailSource );
//
////            res := IMAPClient.AppendMsg( 'Temp2', msg2, msg2.Headers, [] );
//          end;
//        finally
//          FreeAndNil( msg );
//          FreeAndNil( msg2 );
//          FreeAndNil( BodyTexts )
//        end;
//
//      finally
//        IMAPClient.Disconnect;
//      end;
//    finally
//      OpenSSLHandler.Free;
//    end;
//  finally
//    IMAPClient.Free;
//  end;
//end;

end.
