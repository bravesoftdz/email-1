unit uUsuarioLogado;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Samples.Gauges, System.StrUtils, Data.Win.ADODB;

type
  TProvedor = class
  private
    FRequerAutenticacaoSSL: Boolean;
    FHost: string;
    FPorta: Integer;
    FRequerAutenticacao: Boolean;
    procedure SetHost(const Value: string);
    procedure SetPorta(const Value: Integer);
    procedure SetRequerAutenticacao(const Value: Boolean);
    procedure SetRequerAutenticacaoSSL(const Value: Boolean);

  public
    property Host: string read FHost write SetHost;
    property Porta: Integer read FPorta write SetPorta;
    property RequerAutenticacao: Boolean read FRequerAutenticacao write SetRequerAutenticacao;
    property RequerAutenticacaoSSL: Boolean read FRequerAutenticacaoSSL write SetRequerAutenticacaoSSL;
  end;

  TUsuarioLogado = class
    private
      FSenha: string;
      FUsuario: string;
      Fcon: TADOConnection;
      FAdministrador: Boolean;
      FID: Integer;
      FProvedor: TProvedor;
      FNome: string;
      procedure Setcon(const Value: TADOConnection);
      procedure SetProvedor(const Value: TProvedor);
    public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
      property ID: Integer read FID;
      property Nome: string read FNome;
      property Usuario: string read FUsuario;
      property Senha: string read FSenha;
      property Administrador: Boolean read FAdministrador;
      property Provedor: TProvedor read FProvedor write SetProvedor;

      property con: TADOConnection read Fcon write Setcon;

      procedure Execute();


  end;

implementation

{ TUsuarioLogado }

uses LIB;

procedure TUsuarioLogado.AfterConstruction;
begin
  inherited;
  FProvedor:= TProvedor.Create;
end;

procedure TUsuarioLogado.BeforeDestruction;
begin
  inherited;
  FreeAndNil(FProvedor);
end;

procedure TUsuarioLogado.Execute();
var
  qry: TADOQuery;
begin
  inherited;

  qry:= TADOQuery.Create(nil);
  try
    qry.Connection:= con;
    qry.SQL.Add('SELECT TOP 1 B.ID');
    qry.SQL.Add('     , B.Nome');
    qry.SQL.Add('     , B.Login');
    qry.SQL.Add('     , B.Senha');
    qry.SQL.Add('     , B.Administrador');
    qry.SQL.Add('     , C.HOST');
    qry.SQL.Add('     , C.PORTA');
    qry.SQL.Add('     , C.RequerAutenticacao');
    qry.SQL.Add('     , C.RequerAutenticacaoSSL');
    qry.SQL.Add('from dbo.tblUsuarioLogado A');
    qry.SQL.Add('inner join dbo.tblUsuario B on (B.ID = A.IdUsuario)');
    qry.SQL.Add('left join dbo.tblProvedor C on (C.ID = B.IdProvedor)');
    qry.Open;

    if not qry.IsEmpty then
    begin
      FID:= qry.FieldByName('ID').AsInteger;
      FNome:= qry.FieldByName('Nome').AsString;
      FUsuario:= qry.FieldByName('Login').AsString;
      FSenha:=  Cript( qry.FieldByName('Senha').AsString, toDecript );
      FAdministrador:= qry.FieldByName('Administrador').AsBoolean;

      Provedor.Host:= qry.FieldByName('HOST').AsString;
      Provedor.Porta:= qry.FieldByName('PORTA').AsInteger;
      Provedor.RequerAutenticacao:= qry.FieldByName('RequerAutenticacao').AsBoolean;
      Provedor.RequerAutenticacaoSSL:= qry.FieldByName('RequerAutenticacaoSSL').AsBoolean;
    end;
  finally
    FreeAndNil(qry);
  end;
end;

procedure TUsuarioLogado.Setcon(const Value: TADOConnection);
begin
  Fcon := Value;
end;

procedure TUsuarioLogado.SetProvedor(const Value: TProvedor);
begin
  FProvedor := Value;
end;

{ TProvedor }

procedure TProvedor.SetHost(const Value: string);
begin
  FHost := Value;
end;


procedure TProvedor.SetPorta(const Value: Integer);
begin
  FPorta := Value;
end;

procedure TProvedor.SetRequerAutenticacao(const Value: Boolean);
begin
  FRequerAutenticacao := Value;
end;

procedure TProvedor.SetRequerAutenticacaoSSL(const Value: Boolean);
begin
  FRequerAutenticacaoSSL := Value;
end;

end.
