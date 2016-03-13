unit uEmail;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Samples.Gauges, System.StrUtils,

  IdMessage, IdSMTP, WinInet, // componemtes envio de email
  IdBaseComponent, IdComponent, IdIOHandler, IdIOHandlerSocket, IdSSLOpenSSL, // componentes SSL
  IdAttachmentFile, IdIOHandlerStack, IdSSL, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase; // anexo delphi 2010

type
  TEmail = class

  private
  public
    function EnviaMail(Email, Conta, Senha, Autentica, Smtp, Auth_SSL,
      Nom_exibe, Porta_smtp, Corpo, Destinatario, Assunto,
      Anexo: String): String;

  end;

implementation


{ TEmail }

function TEmail.EnviaMail(Email, Conta, Senha, Autentica, Smtp, Auth_SSL, Nom_exibe, Porta_smtp, Corpo, Destinatario, Assunto, Anexo : String) : String;

var
Mensagem: TIdMessage;
cnxSMTP: TIdSMTP;
AuthSSL: TIdSSLIOHandlerSocketOpenSSL;
begin
Result := '';
try

Mensagem := TIdMessage.Create(nil);
cnxSMTP  := TIdSMTP.Create(nil);



Mensagem.From.Name := Nom_exibe; // Nome do Remetente
Mensagem.From.Address := Email; // E-mail do Remetente = email valido...
Mensagem.Recipients.EMailAddresses := Destinatario;  // destinatario
Mensagem.Priority := mpHighest;
Mensagem.Subject := Assunto; // Assunto do E-mail

cnxSMTP.Host := Smtp;  // smtp terra}
cnxSMTP.Username := Conta;
cnxSMTP.Password := Senha;
if Autentica = 'S' then
cnxSMTP.AuthType := satDefault;
if Autentica = 'N' then
cnxSMTP.AuthType := satNone;


if Auth_SSL = 'S' then
 begin
  AuthSSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  cnxSMTP.IOHandler := AuthSSL;
  cnxSMTP.UseTLS := utUseImplicitTLS;
  AuthSSL.DefaultPort := StrToInt(Porta_smtp);
  AuthSSL.SSLOptions.Method := sslvSSLv3;
  AuthSSL.SSLOptions.Mode := sslmClient;
 end;

cnxSMTP.Port := StrToInt(Porta_smtp);


if trim(Anexo) <> '' then
 begin
  TIdAttachmentFile.Create(Mensagem.MessageParts, TFileName(Anexo));
 end;

Mensagem.Body.Clear;
Mensagem.Body.Add(Corpo);
cnxSMTP.UseEhlo := true;
cnxSMTP.UseVerp := false;


cnxSMTP.ReadTimeout := 10000;
cnxSMTP.Connect;
sleep(1000);
cnxSMTP.Authenticate;
sleep(1000);
Try
if cnxSMTP.Connected then
 cnxSMTP.Send(Mensagem)
 else
  begin
   Result := 'Mensagem não pode ser enviada.';
   exit;
  end;
except
  cnxSMTP.Disconnect;
  cnxSMTP.Host := Smtp;   // smtp
  cnxSMTP.AuthType := satNone;
  cnxSMTP.Connect;
  try
    cnxSMTP.Send(Mensagem);
  except
   begin
    Result := 'Não pode enviar o email para ' + Destinatario +  '. Verifique as configurações da conta!';
   end;
  end;
  cnxSMTP.Disconnect;
end;
cnxSMTP.Disconnect;


finally
FreeAndNil(Mensagem);
FreeAndNil(cnxSMTP);
if Auth_SSL = 'S' then
 FreeAndNil(AuthSSL);
end;

if Result = '' then
 Result := 'E-Mail enviado para ' + Destinatario;

end;
{
para testar:
}
//procedure TForm1.Button1Click(Sender: TObject);
//begin
//showmessage(
// EnviaMail('Email',
//           'Conta',
//           'Senha',
//           'S',//Autentica
//           'Smtp.provedor.com.br',
//           'S',//Auth_SSL
//           'Nom_exibe',
//           '25',// Porta_smtp, padrao 25, ssl 465
//           '', // Corpo do email
//           'Destinatario@dominio.com.br',
//           'Assunto',
//           '',//Anexo caso tenha anexo preencha: 'c:arquivo.txt' por ex.
//       ));
//end;

end.
