unit uConexaoDB;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Data.DB, Datasnap.DBClient, Data.Win.ADODB, System.IniFiles,
  LIB, Winapi.OleDB;

  type
    TConfiguracao = class
  private
    FServidor: string;
    FSenha: string;
    FDataBase: string;
    FUsuario: string;
    procedure SetDataBase(const Value: string);
    procedure SetSenha(const Value: string);
    procedure SetServidor(const Value: string);
    procedure SetUsuario(const Value: string);
    public
      property Servidor: string read FServidor write SetServidor;
      property DataBase: string read FDataBase write SetDataBase;
      property Usuario: string read FUsuario write SetUsuario;
      property Senha: string read FSenha write SetSenha;
    end;

    TConexao = class
      private
        Fcon: TADOConnection;

        FConexaoMaster: TADOConnection;
        Fconfiguracao: TConfiguracao;

        procedure Setcon(const Value: TADOConnection);
        procedure CriarEstrutura();
        function TabelaExiste(schema, tablename: string): Boolean;
        procedure CriarTabelaEmail();
        procedure CriarTabelaUsuarioLogado();
        procedure LerConfiguracao();
        procedure CriarTabelaUsuario();
        procedure SetUsuarioLogado(AID: Integer);
        function CriarDataBase: Boolean;
        procedure CriarUsuarioAdmin();
    procedure CriarTabelaUsuarioPemissao();
    procedure CriarTabelaEmailAnexos();
    procedure CriarTabelaProvedor();
    procedure InserirProvedor(Nome, Host: string; porta, RequerAutenticacaoSSL,
      RequerAutenticacao: Integer);
      public
        property con: TADOConnection read Fcon write Setcon;
        function Conectar(): Boolean;
        function Login(ALogin, ASenha : string): Boolean;
    end;

implementation


{ TConexao }

procedure TConexao.LerConfiguracao();
var
  ArqIni: TIniFile;
  lsFileName: string;
begin
  lsFileName:= ExtractFilePath(Application.ExeName) + 'Configuracao.ini';
  if not FileExists(lsFileName) then
    raise Exception.Create('Arquivo de configuração não existe. Verifique!');

  ArqIni := TIniFile.Create(lsFileName);

  if not Assigned(Fconfiguracao) then
    Fconfiguracao:= TConfiguracao.Create;

  try
    Fconfiguracao.Servidor:= ArqIni.ReadString('CONFIG', 'SERVER', '');
    Fconfiguracao.DataBase:= ArqIni.ReadString('CONFIG', 'DATABASE', '');
    Fconfiguracao.Usuario:= ArqIni.ReadString('CONFIG', 'USER', '');
    Fconfiguracao.Senha:= ArqIni.ReadString('CONFIG', 'SENHA', '');
  finally
    FreeAndNil(ArqIni);
  end;
end;


function TConexao.Login(ALogin, ASenha : string): Boolean;
var
  Query: TADOQuery;
begin
  Result:= False;
  if not Conectar() then
    Exit;

  Query:= TADOQuery.Create(nil);
  try
    Query.Connection:= con;
    Query.SQL.Add('SELECT ID, Senha FROM dbo.tblUsuario');
    Query.SQL.Add(Format('WHERE UPPER(Login) = %s', [QuotedStr(AnsiUpperCase(ALogin))]));
    Query.SQL.Add(Format('OR UPPER(Nome) = %s', [QuotedStr(AnsiUpperCase(ALogin))]));
    Query.Open;

    if not Query.IsEmpty then
      begin
        if not AnsiSameStr(Cript(Query.FieldByName('Senha').AsString, toDecript),
                         Cript(ASenha, toDecript)) then
        begin
          Aviso('Senha incorreta. Verifique!');
          Exit;
        end;

        SetUsuarioLogado(Query.FieldByName('ID').AsInteger);
      end
    else
      begin
        Aviso('Usuário inválido. Verifique!');
        Exit;
      end;
  finally
    FreeAndNil(Query);
  end;

  Result:= True;
end;

function TConexao.Conectar(): Boolean;
begin
  Result:= False;

  LerConfiguracao();

  if not CriarDataBase() then
  begin
    Aviso('Base de dados não criada. O sistema será finalizado!');
    Application.Terminate;
  end;

  con.Connected:= False;
  try
    con.ConnectionString:= Format('Provider=SQLOLEDB.1;Password=%s;Persist Security Info=True;User ID=%s;Initial Catalog=%s;Data Source=%s',
                                 [Fconfiguracao.Senha , Fconfiguracao.Usuario, Fconfiguracao.DataBase, Fconfiguracao.Servidor]);
    con.Connected:= True;
  except on e:exception do
    begin
      raise Exception.Create('Erro: '+ e.Message);
      Application.Terminate;
    end;
  end;

  CriarEstrutura();

  FreeAndNil(Fconfiguracao);

  Result:= con.Connected;
end;

function TConexao.TabelaExiste(schema, tablename: string): Boolean;
var
  Query: TADOQuery;
begin
  Query:= TADOQuery.Create(nil);
  try
    Query.Connection:= con;
    Query.SQL.Text:= 'SELECT case when EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES'+
                     Format(' WHERE TABLE_SCHEMA = %s AND  TABLE_NAME = %s) then 1 else 0 end', [QuotedStr( schema ), QuotedStr( tablename )]);
    Query.Open;

    Result:= Query.Fields[0].AsInteger = 1;
  finally
    FreeAndNil(Query);
  end;
end;

function TConexao.CriarDataBase(): Boolean;
var
  qry: TADOQuery;
begin
  Result:= False;
  FConexaoMaster:= TADOConnection.Create(nil);
  qry:= TADOQuery.Create(nil);
  try
    try
      FConexaoMaster.LoginPrompt := False;
      FConexaoMaster.ConnectionString:= Format('Provider=SQLOLEDB.1;Password=%s;Persist Security Info=True;User ID=%s;Initial Catalog=%s;Data Source=%s',
                                               [Fconfiguracao.Senha , Fconfiguracao.Usuario, 'Master', Fconfiguracao.Servidor]);

      FConexaoMaster.Connected:= True;

      if FConexaoMaster.Connected then
      begin
        qry.Connection:= FConexaoMaster;
        qry.SQL.Text:= Format('select case when db_id(%s) is not null then 1 else 0 end', [Quotedstr( Fconfiguracao.FDataBase )]);
        qry.Open;

        if not qry.IsEmpty then
        begin
          if qry.Fields[0].AsInteger = 0 then
          begin
            qry.Close;
            qry.Connection:= FConexaoMaster;
            qry.SQL.Clear;
            qry.SQL.Text:= Format('create database %s;', [Fconfiguracao.FDataBase]);
            qry.ExecSQL;
          end;

          Result:= True;
        end;
      end;
    except on e:Exception do
      Aviso(e.Message);
    end;
  finally
    FreeAndNil(qry);
    FreeAndNil(FConexaoMaster);
  end;
end;

procedure TConexao.CriarEstrutura();
begin
  if not TabelaExiste('dbo', 'tblEmail') then
    CriarTabelaEmail();

  if not TabelaExiste('dbo', 'tblEmailAnexos') then
    CriarTabelaEmailAnexos();

  if not TabelaExiste('dbo', 'tblUsuario') then
    CriarTabelaUsuario();

  if not TabelaExiste('dbo', 'tblUsuarioLogado') then
    CriarTabelaUsuarioLogado();

  if not TabelaExiste('dbo', 'tblUsuarioPemissao') then
    CriarTabelaUsuarioPemissao();

  if not TabelaExiste('dbo', 'tblProvedor') then
    CriarTabelaProvedor();
end;

procedure TConexao.CriarTabelaEmail();
var
  Query: TADOQuery;
begin
  Query:= TADOQuery.Create(nil);
  try
    Query.Connection:= con;
    Query.SQL.Add('CREATE TABLE dbo.tblEmail (');
    Query.SQL.Add('	ID INT IDENTITY(1,1) PRIMARY KEY,');
    Query.SQL.Add('	remetente varchar(255),');
    Query.SQL.Add('	assunto varchar(255),');
    Query.SQL.Add('	texto text,');
    Query.SQL.Add('	IdUsuario int NOT NULL,');
    Query.SQL.Add('	idEmail int NOT NULL,');
    Query.SQL.Add('	arquivo image NULL');
    Query.SQL.Add(')');
    Query.ExecSQL;
  finally
    FreeAndNil(Query);
  end;
end;

procedure TConexao.CriarTabelaEmailAnexos();
var
  Query: TADOQuery;
begin
  Query:= TADOQuery.Create(nil);
  try
    Query.Connection:= con;
    Query.SQL.Add('CREATE TABLE dbo.tblEmailAnexos (');
    Query.SQL.Add('	ID INT IDENTITY(1,1) PRIMARY KEY,');
    Query.SQL.Add('	idEmail int NOT NULL,');
    Query.SQL.Add('	arquivo image NULL');
    Query.SQL.Add(')');
    Query.ExecSQL;
  finally
    FreeAndNil(Query);
  end;
end;

procedure TConexao.CriarUsuarioAdmin();
var
  Query: TADOQuery;
begin
  Query:= TADOQuery.Create(nil);
  try
    Query.Connection:= con;
    Query.SQL.Text:= Format('INSERT INTO tblUsuario (Nome, Login, Senha, Administrador, IdProvedor) VALUES (''ADMIN'', ''ADMIN'', %s, 1, 0)', [Quotedstr(Cript('ADMIN', toCript))]);
    Query.ExecSQL;
  finally
    FreeAndNil(Query);
  end;
end;

procedure TConexao.CriarTabelaUsuario();
var
  Query: TADOQuery;
begin
  Query:= TADOQuery.Create(nil);
  try
    Query.Connection:= con;
    Query.SQL.Add('CREATE TABLE dbo.tblUsuario (');
    Query.SQL.Add('	ID INT IDENTITY(1,1) PRIMARY KEY,');
    Query.SQL.Add('	Nome varchar(50),');
    Query.SQL.Add('	Login varchar(50),');
    Query.SQL.Add('	Senha varchar(50),');
    Query.SQL.Add('	IdProvedor int NOT NULL,');
    Query.SQL.Add('	Administrador bit NOT NULL');
    Query.SQL.Add(')');
    Query.ExecSQL;
  finally
    FreeAndNil(Query);
  end;

  CriarUsuarioAdmin();
end;

procedure TConexao.CriarTabelaUsuarioLogado();
var
  Query: TADOQuery;
begin
  Query:= TADOQuery.Create(nil);
  try
    Query.Connection:= con;
    Query.SQL.Add('CREATE TABLE dbo.tblUsuarioLogado (');
    Query.SQL.Add('	ID INT IDENTITY(1,1) PRIMARY KEY,');
    Query.SQL.Add('	IdUsuario int NOT NULL');
    Query.SQL.Add(')');
    Query.ExecSQL;
  finally
    FreeAndNil(Query);
  end;
end;

procedure TConexao.CriarTabelaUsuarioPemissao();
var
  Query: TADOQuery;
begin
  Query:= TADOQuery.Create(nil);
  try
    Query.Connection:= con;
    Query.SQL.Add('CREATE TABLE dbo.tblUsuarioPemissao (');
    Query.SQL.Add('	ID INT IDENTITY(1,1) PRIMARY KEY,');
    Query.SQL.Add('	IdUsuario int NOT NULL,');
    Query.SQL.Add('	IdUsuario_Permissao int NOT NULL');
    Query.SQL.Add(')');
    Query.ExecSQL;
  finally
    FreeAndNil(Query);
  end;
end;

procedure TConexao.CriarTabelaProvedor();
var
  Query: TADOQuery;
begin
  Query:= TADOQuery.Create(nil);
  try
    Query.Connection:= con;
    Query.SQL.Add('CREATE TABLE dbo.tblProvedor (');
    Query.SQL.Add('	ID INT IDENTITY(1,1) PRIMARY KEY,');
    Query.SQL.Add('	NOME varchar(30),');
    Query.SQL.Add('	HOST varchar(50),');
    Query.SQL.Add('	PORTA int NOT NULL,');
    Query.SQL.Add('	RequerAutenticacao bit NOT NULL,');
    Query.SQL.Add('	RequerAutenticacaoSSL bit NOT NULL');
    Query.SQL.Add(')');
    Query.ExecSQL;
  finally
    FreeAndNil(Query);
  end;

  InserirProvedor('GMAIL', 'smtp.gmail.com', 465, 1, 1);
  InserirProvedor('RISAU', 'smtp.risau.com.br', 587, 1, 0);
end;

procedure TConexao.InserirProvedor(Nome, Host: string; porta, RequerAutenticacaoSSL, RequerAutenticacao: Integer);
var
  Query: TADOQuery;
begin
  Query:= TADOQuery.Create(nil);
  try
    Query.Connection:= con;
    Query.SQL.Text:= 'INSERT INTO tblProvedor (NOME, HOST, PORTA, RequerAutenticacao, RequerAutenticacaoSSL)'+
                     Format(' VALUES (%s, %s, %d, %d, %d)', [QuotedStr(Nome), QuotedStr(Host), porta, RequerAutenticacao, RequerAutenticacaoSSL]);
    Query.ExecSQL;
  finally
    FreeAndNil(Query);
  end;
end;

procedure TConexao.Setcon(const Value: TADOConnection);
begin
  Fcon := Value;
end;

procedure TConexao.SetUsuarioLogado(AID: Integer);
var
  Query: TADOQuery;
begin
  Query:= TADOQuery.Create(nil);
  try
    Query.Connection:= con;
    Query.SQL.Add(Format('UPDATE dbo.tblUsuarioLogado SET IdUsuario = %d;', [AID]));
    Query.ExecSQL;

    if Query.RowsAffected = 0 then
    begin
      Query.Close;
      Query.Connection:= con;
      Query.SQL.Clear;
      Query.SQL.Add(Format('INSERT INTO dbo.tblUsuarioLogado (IdUsuario) VALUES (%d);', [AID]));
      Query.ExecSQL;
    end;
  finally
    FreeAndNil(Query);
  end;
end;

{ TConfiguracao }

procedure TConfiguracao.SetDataBase(const Value: string);
begin
  FDataBase := Value;
end;

procedure TConfiguracao.SetSenha(const Value: string);
begin
  FSenha := Value;
end;

procedure TConfiguracao.SetServidor(const Value: string);
begin
  FServidor := Value;
end;

procedure TConfiguracao.SetUsuario(const Value: string);
begin
  FUsuario := Value;
end;

end.
