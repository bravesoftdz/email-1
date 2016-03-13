unit uEscreverEmail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Samples.Gauges, System.StrUtils, uUsuarioLogado
 ,  IdText
 , IdBaseComponent
 , IdComponent // Units Genéricas do Indy
 , IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL // Objeto SSL
 , IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP // Objeto SMTP
 , IdMessage // Objeto de Mensagem
 , IdAttachmentFile, IdSASL, IdSASLUserPass, IdSASLLogin, IdSASL_CRAM_MD5,
  IdSASL_CRAMBase, IdSASL_CRAM_SHA1, IdSASLSKey, IdSASLOTP, IdSASLExternal,
  IdSASLAnonymous, IdUserPassProvider, IdGlobal, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, cxButtons; // Objeto de Arquivos Anexos

type
  TfrmEscreverEmail = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edtPara: TEdit;
    edtAssunto: TEdit;
    Gauge1: TGauge;
    RichEdit1: TRichEdit;
    gpxAnexos: TGroupBox;
    StatusBar: TStatusBar;
    lstAnexos: TListBox;
    btnAnexar: TcxButton;
    ppAnexos: TPopupMenu;
    Excluir1: TMenuItem;
    dlgAnexos: TOpenDialog;
    btnEnviar: TcxButton;
    btnDesanexar: TcxButton;
    procedure btnEnviarClick(Sender: TObject);
    procedure Excluir1Click(Sender: TObject);
    procedure btnAnexarClick(Sender: TObject);
  private
    FUsuarioLogado: TUsuarioLogado;
    function EnviarEmail(aHost : String; aPort : Integer; aLogin, aSenha,aListaEmail, aAssunto, aCorpo : String; aAuthSSL, RequerAutenticacao : Boolean) : Boolean;overload;
    function RetornarProvedor(Value: string): string;
    function StrIsEmpty(Value: string): Boolean;
    procedure SetUsuarioLogado(const Value: TUsuarioLogado);
    function Validar(): Boolean;

    { Private declarations }
  public
    { Public declarations }
    procedure AbrirEmail(Arquivo: TMemoryStream);

    property UsuarioLogado: TUsuarioLogado read FUsuarioLogado write SetUsuarioLogado;

  end;

var
  frmEscreverEmail: TfrmEscreverEmail;

implementation

{$R *.dfm}

uses uEmail, uEntrada, LIB;

{ TfrmEscreverEmail }

procedure TfrmEscreverEmail.AbrirEmail(Arquivo: TMemoryStream);
begin
//  if Assigned(Arquivo) then
    //RichEdit1.Lines.LoadFromStream(Arquivo);
//    Arquivo.SaveToFile('c:\edson.txt');
end;

function TfrmEscreverEmail.RetornarProvedor(Value: string):string;
begin
  Delete(Value, 1, Pos('@', Value));
  Result:= AnsiUpperCase(Copy(Value, 1, Pos('.', Value)-1));
end;

procedure TfrmEscreverEmail.SetUsuarioLogado(const Value: TUsuarioLogado);
begin
  FUsuarioLogado := Value;
end;

function TfrmEscreverEmail.StrIsEmpty(Value: string): Boolean;
begin
  Result:= AnsiSameStr(Value, '');
end;

procedure TfrmEscreverEmail.btnAnexarClick(Sender: TObject);
begin
  if dlgAnexos.Execute then
  begin
    lstAnexos.Items.Add(dlgAnexos.FileName);
  end;
end;

function TfrmEscreverEmail.Validar(): Boolean;
begin
  Result:= False;

  if UsuarioLogado.Usuario = '' then
  begin
    Aviso('Usuário inválido. Verifique!');
    Exit;
  end;

  if UsuarioLogado.Senha = '' then
  begin
    Aviso('Senha inválida. Verifique!');
    Exit;
  end;

  if UsuarioLogado.Provedor.Host = '' then
  begin
    Aviso('Provedor com o smtp inválido. Verifique!');
    Exit;
  end;

  if UsuarioLogado.Provedor.Porta = 0 then
  begin
    Aviso('Provedor com a porta inválida. Verifique!');
    Exit;
  end;

  if edtPara.Text = '' then
  begin
    Aviso('Remetente não preenchido. Verifique!');
    edtPara.SetFocus;
    Exit;
  end;

  if edtAssunto.Text = '' then
  begin
    if not Confirma('Campo assunto não preenchido. Deseja continuar assim mesmo?') then
    begin
      edtAssunto.SetFocus;
      Exit;
    end;
  end;

  Result:= True;
end;


procedure TfrmEscreverEmail.btnEnviarClick(Sender: TObject);
//var
//  lsProvedor: string;
//  lEmail: TEmail;
begin
//  lsProvedor:= RetornarProvedor(UsuarioLogado.Usuario);
//  case AnsiIndexStr(lsProvedor, ['GMAIL', 'RISAU']) of
//    0: EnviarEmail('smtp.gmail.com', 465, UsuarioLogado.Usuario, UsuarioLogado.Senha, edtPara.Text, edtAssunto.Text, 'CORPO DA MENSAGEM', True, True);
//    1: EnviarEmail('smtp.risau.com.br', 587, UsuarioLogado.Usuario, UsuarioLogado.Senha, edtPara.Text, edtAssunto.Text, 'CORPO DA MENSAGEM', True, False);
//  end;
  if Validar() then
  begin
    EnviarEmail(UsuarioLogado.Provedor.Host,
                UsuarioLogado.Provedor.Porta,
                UsuarioLogado.Usuario,
                UsuarioLogado.Senha,
                edtPara.Text,
                edtAssunto.Text,
                'CORPO DA MENSAGEM',
                UsuarioLogado.Provedor.RequerAutenticacaoSSL,
                UsuarioLogado.Provedor.RequerAutenticacao);
  end;
end;

function TfrmEscreverEmail.EnviarEmail(aHost : String; aPort : Integer; aLogin, aSenha,aListaEmail, aAssunto, aCorpo : String; aAuthSSL, RequerAutenticacao : Boolean) : Boolean;
var
 SSL: TIdSSLIOHandlerSocketOpenSSL;
 IdSMTP: TIdSMTP;
 IdMessage: TIdMessage;
 IdTexto: TidText;
 i: Integer;
begin
  Result:= False;
  IdSMTP    := TIdSMTP.Create(nil);
  IdMessage := TIdMessage.Create(nil);
  try
    try
      IdTexto := TIdText.Create(IdMessage.MessageParts);
      IdTexto.ContentType := 'text/html';
      IdTexto.Body.Text := 'Data/Hora: ' + FormatDateTime('dd/MM/yyyy HH:mm:ss', Now) +
                           #13#10#13#10 +
                           aCorpo;

      IdMessage.CharSet:= 'ISO-8859-1';
      IdMessage.ContentType:= 'multipart/mixed';
      IdMessage.Encoding:= meMIME;
      IdMessage.Priority:= mpHigh;
      IdMessage.ConvertPreamble:= True;
      IdMessage.From.Text               := aLogin;
//      IdMsgSend.ReplyTo.EMailAddresses:= aLogin;
      IdMessage.Recipients.EMailAddresses  := aListaEmail;
      IdMessage.Subject                    := aAssunto;

      IdMessage.ReceiptRecipient.Address:= aLogin;
      IdMessage.ReceiptRecipient.Name:= aLogin;

      IdMessage.Body.Text := 'Data/Hora: ' + FormatDateTime('dd/MM/yyyy HH:mm:ss', Now) +
                           #13#10#13#10 +
                           aCorpo;

      if lstAnexos.Items.Count > 0 then
      begin
        IdMessage.AttachmentEncoding:= 'MIME';
        IdMessage.MessageParts.Clear; // Limpa os anexos da lista
        for i := 0 to lstAnexos.Items.Count -1 do
        begin
          if FileExists(lstAnexos.Items.Strings[i]) then
          begin
            TIdAttachmentFile.Create(IdMessage.MessageParts, TFileName(lstAnexos.Items.Strings[i])); // adiciona anexo na lista, pode ser utilizado com looping
          end;
        end;
      end;

      IdSMTP.Host     := aHost;
      IdSMTP.Port     := aPort;
      IdSMTP.AuthType := satDefault;
      IdSMTP.Username := aLogin;
      IdSMTP.Password := aSenha;

      if aAuthSSL then
        begin
          SSL:= TIdSSLIOHandlerSocketOpenSSL.Create(Self);
          SSL.Destination:= aHost + ':' + IntToStr(aPort);
          SSL.Port:= aPort;
          SSL.SSLOptions.Method:= sslvSSLv23;
          SSL.SSLOptions.SSLVersions:= [sslvSSLv2, sslvSSLv3, sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
          SSL.SSLOptions.Mode:= sslmClient;
          SSL.SSLOptions.VerifyMode:= [];
          SSL.SSLOptions.VerifyDepth:= 0;
          SSL.DefaultPort:= 0;
          SSL.MaxLineAction:= maException;
          IdSMTP.IOHandler:= SSL;

          if not RequerAutenticacao then
            IdSMTP.UseTLS := utNoTLSSupport
          else
            IdSMTP.UseTLS := utUseImplicitTLS;

          IdSMTP.AuthType := satDefault
        end
      else
        IdSMTP.AuthType := satNone;

      IdSMTP.Connect;

      IdSMTP.Authenticate;
      IdSMTP.Send(IdMessage);
      Informacao('E-Mail Enviado com sucesso para: ' +  aListaEmail);
      Close;
    except on E: Exception do
      begin
        Aviso('Erro ao enviar E-Mail:'+#13#10+e.Message);
        Exit;
      end;
    end;
  finally
    IdSMTP.Disconnect;
    FreeAndNil(IdSMTP);
    FreeAndNil(IdMessage);
    if Assigned( SSL ) then
      FreeAndNil(SSL);
  end;
  Result:= True;
end;
procedure TfrmEscreverEmail.Excluir1Click(Sender: TObject);
begin
  if lstAnexos.Items.Count > 0 then
  begin
    lstAnexos.DeleteSelected;
  end;
end;

end.
