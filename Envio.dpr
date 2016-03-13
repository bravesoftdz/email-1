program Envio;

uses
  Vcl.Forms,
  uEntrada in 'uEntrada.pas' {frmEntrada},
  uEscreverEmail in 'uEscreverEmail.pas' {frmEscreverEmail},
  uConexaoDB in 'uConexaoDB.pas',
  uEmail in 'uEmail.pas',
  uLogin in 'uLogin.pas' {frmLogin},
  Wcrypt2 in 'base\Pas\Wcrypt2.pas',
  LIB in 'LIB.pas',
  uUsuarioLogado in 'uUsuarioLogado.pas',
  Tela_Cadastro_MasterDetail in 'base\Tela_Cadastro_MasterDetail.pas' {frmCadastro_MasterDetail},
  Tela_Cadastro in 'base\Tela_Cadastro.pas' {frmTelaDeCadastro},
  uCadastroUsuarios in 'uCadastroUsuarios.pas' {frmCadastroDeUsuarios};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;
end.
