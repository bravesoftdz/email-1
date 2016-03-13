unit uLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, dxGDIPlusClasses, Vcl.ExtCtrls,
  Vcl.StdCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  cxButtons, Data.DB, Data.Win.ADODB, Vcl.OleConst;

type
  TfrmLogin = class(TForm)
    Image1: TImage;
    edtUsuario: TEdit;
    edtSenha: TEdit;
    btnOK: TcxButton;
    btnCancelar: TcxButton;
    con: TADOConnection;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}

uses uConexaoDB, uEntrada, LIB, uUsuarioLogado, uCadastroUsuarios;

procedure TfrmLogin.btnCancelarClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmLogin.btnOKClick(Sender: TObject);
var
  loLogin: TConexao;
  loUsuarioLogado: TUsuarioLogado;
begin
  loLogin:= TConexao.Create;
  loUsuarioLogado:= TUsuarioLogado.Create;
  try
    loLogin.con:= con;
    if loLogin.Login(edtUsuario.Text, edtSenha.Text) then
    begin
      loUsuarioLogado.con:= con;
      loUsuarioLogado.Execute;

      if not loUsuarioLogado.Administrador then
        CriaForm(TfrmEntrada, taShowModal)
      else
        CriaForm(TfrmCadastroDeUsuarios, taShowModal);
    end;
  finally
    FreeAndNil(loLogin);
    FreeAndNil(loUsuarioLogado);
  end;
end;

procedure TfrmLogin.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    perform(wm_nextdlgctl,0,0);
  end;
end;

end.
