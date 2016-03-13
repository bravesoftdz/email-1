unit uCadastroUsuarios;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Tela_Cadastro, Data.DB, Data.Win.ADODB,
  Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin, Vcl.Grids, Vcl.DBGrids, uLogin, uUsuarioLogado,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxContainer,
  cxEdit, cxCheckBox, cxDBEdit, cxMaskEdit, cxSpinEdit, cxTextEdit, Vcl.StdCtrls,
  cxDropDownEdit, cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, LIB,
  Vcl.Mask, Vcl.DBCtrls, Vcl.Menus, cxButtons, Datasnap.DBClient;

type
  TfrmCadastroDeUsuarios = class(TfrmTelaDeCadastro)
    cdsTabelaID: TAutoIncField;
    cdsTabelaNome: TStringField;
    cdsTabelaLogin: TStringField;
    cdsTabelaSenha: TStringField;
    cdsTabelaIdProvedor: TIntegerField;
    cdsTabelaAdministrador: TBooleanField;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblProvedor: TLabel;
    cboProvedor: TcxDBLookupComboBox;
    cdsProvedor: TADODataSet;
    cdsProvedorID: TAutoIncField;
    cdsProvedorNOME: TStringField;
    cdsProvedorHOST: TStringField;
    cdsProvedorPORTA: TIntegerField;
    cdsProvedorRequerAutenticacao: TBooleanField;
    cdsProvedorRequerAutenticacaoSSL: TBooleanField;
    dtsProvedor: TDataSource;
    gpbPermissao: TGroupBox;
    grdUsuariosOut: TDBGrid;
    grdUsuariosIn: TDBGrid;
    btnAddOne: TcxButton;
    btnAddAll: TcxButton;
    btnDeleteAll: TcxButton;
    cdsUsuariosOut: TClientDataSet;
    cdsUsuariosOutNome: TStringField;
    cdsUsuariosOutLogin: TStringField;
    cdsUsuariosOutID: TIntegerField;
    btnDeleteOne: TcxButton;
    dtsUsuariosOut: TDataSource;
    dtsUsuariosIn: TDataSource;
    edtNome: TDBEdit;
    edtEmail: TDBEdit;
    edtSenha: TEdit;
    cdsUsuarioPermissao: TADODataSet;
    cdsUsuarioPermissaoID: TAutoIncField;
    cdsUsuarioPermissaoIdUsuario: TIntegerField;
    cdsUsuarioPermissaoIdUsuario_Permissao: TIntegerField;
    cdsUsuariosIn: TClientDataSet;
    cdsUsuariosInID: TIntegerField;
    cdsUsuariosInNome: TStringField;
    cdsUsuariosInLogin: TStringField;
    procedure cdsTabelaBeforePost(DataSet: TDataSet);
    procedure btnAddOneClick(Sender: TObject);
    procedure btnAddAllClick(Sender: TObject);
    procedure btnDeleteOneClick(Sender: TObject);
    procedure btnDeleteAllClick(Sender: TObject);
    procedure dtsTabelaDataChange(Sender: TObject; Field: TField);
    procedure cdsTabelaNewRecord(DataSet: TDataSet);
    procedure cdsTabelaBeforeEdit(DataSet: TDataSet);
  private
    procedure InserirUsuario(cdsIn, cdsOut: TClientDataSet);
    procedure AddOneUser(cdsIn, cdsOut: TClientDataSet);
    procedure AddAllUser(cdsIn, cdsOut: TClientDataSet);
    procedure CarregarUsuariosInOut(AClientDataSet: TClientDataSet; AOut: Boolean);
    procedure IncluirDeletarUsuarioPermissao();
    { Private declarations }
  public
    procedure AfterConstruction; override;

    { Public declarations }

  end;

var
  frmCadastroDeUsuarios: TfrmCadastroDeUsuarios;

implementation

{$R *.dfm}

{ TfrmCadastroDeUsuarios }

procedure TfrmCadastroDeUsuarios.AfterConstruction;
var
  loUsuarioLogado: TUsuarioLogado;
begin
  inherited;
  Connection:= frmLogin.con;
  loUsuarioLogado:= TUsuarioLogado.Create;
  try
    loUsuarioLogado.con:= Connection;
    loUsuarioLogado.Execute;

    cdsTabela.CommandText := Format('SELECT *  FROM tblUsuario where ID <> %d', [loUsuarioLogado.ID]);

    cdsProvedor.Connection:= Connection;
    cdsProvedor.Open;

    cdsUsuarioPermissao.Connection:= Connection;
    cdsUsuarioPermissao.Open;
  finally
    FreeAndNil(loUsuarioLogado);
  end;
end;

procedure TfrmCadastroDeUsuarios.CarregarUsuariosInOut(AClientDataSet: TClientDataSet; AOut: Boolean);
var
  lQuery: TADOQuery;
  lsFiltro: string;
begin
  AClientDataSet.Close;
  AClientDataSet.CreateDataSet;

  lsFiltro:= '';
  if AOut then
    lsFiltro:= 'not';

  lQuery:= TADOQuery.Create(nil);
  try
    lQuery.Connection:= Connection;
    lQuery.SQL.Text:= Format('SELECT * FROM tblUsuario A WHERE A.Administrador <> 1 and A.ID <> %d '+
                             ' AND A.ID %s in (SELECT B.IdUsuario_Permissao FROM tblUsuarioPemissao B WHERE B.IdUsuario = %d)',
                             [cdsTabelaID.AsInteger, lsFiltro, cdsTabelaID.AsInteger]);
    lQuery.Open;

    AClientDataSet.DisableControls;
    lQuery.First;
    while not lQuery.Eof do
    begin
      AClientDataSet.Append;
      AClientDataSet.FieldByName('ID').AsInteger:= lQuery.FieldByName('ID').AsInteger;
      AClientDataSet.FieldByName('Nome').AsString:= lQuery.FieldByName('Nome').AsString;
      AClientDataSet.FieldByName('Login').AsString:= lQuery.FieldByName('Login').AsString;
      AClientDataSet.Post;
      lQuery.Next;
    end;
    AClientDataSet.EnableControls;
  finally
    FreeAndNil(lQuery);
  end;
end;

procedure TfrmCadastroDeUsuarios.InserirUsuario(cdsIn, cdsOut: TClientDataSet);
begin
  if cdsIn.IsEmpty and cdsOut.IsEmpty then
    Exit;

  if not cdsIn.Locate('ID', VarArrayOf([cdsOut.FieldByName('ID').AsInteger]), [loCaseInsensitive]) then
  begin
    cdsIn.Append;
    cdsIn.FieldByName('ID').AsInteger:= cdsOut.FieldByName('ID').AsInteger;
    cdsIn.FieldByName('Nome').AsString:= cdsOut.FieldByName('Nome').AsString;
    cdsIn.FieldByName('Login').AsString:= cdsOut.FieldByName('Login').AsString;
    cdsIn.Post;
  end;
end;

procedure TfrmCadastroDeUsuarios.AddOneUser(cdsIn, cdsOut: TClientDataSet);
begin
  InserirUsuario(cdsIn, cdsOut);

  if not cdsOut.IsEmpty then
    cdsOut.Delete;
end;

procedure TfrmCadastroDeUsuarios.AddAllUser(cdsIn, cdsOut: TClientDataSet);
begin
  cdsOut.DisableControls;
  cdsIn.DisableControls;
  while not cdsOut.IsEmpty do
  begin
    InserirUsuario(cdsIn, cdsOut);
    cdsOut.Delete;
  end;
  cdsIn.EnableControls;
  cdsOut.EnableControls;
end;

procedure TfrmCadastroDeUsuarios.btnAddOneClick(Sender: TObject);
begin
  inherited;

  AddOneUser(cdsUsuariosIn, cdsUsuariosOut);
end;

procedure TfrmCadastroDeUsuarios.btnDeleteAllClick(Sender: TObject);
begin
  inherited;
  AddAllUser(cdsUsuariosOut, cdsUsuariosIn);
end;

procedure TfrmCadastroDeUsuarios.btnDeleteOneClick(Sender: TObject);
begin
  inherited;

  AddOneUser(cdsUsuariosOut, cdsUsuariosIn);
end;

procedure TfrmCadastroDeUsuarios.btnAddAllClick(Sender: TObject);
begin
  inherited;
  AddAllUser(cdsUsuariosIn, cdsUsuariosOut);
end;

procedure TfrmCadastroDeUsuarios.cdsTabelaBeforeEdit(DataSet: TDataSet);
begin
  inherited;

  CarregarUsuariosInOut(cdsUsuariosOut, True);
  CarregarUsuariosInOut(cdsUsuariosIn, False);

  edtSenha.Text:= cdsTabelaSenha.AsString;
end;

procedure TfrmCadastroDeUsuarios.cdsTabelaBeforePost(DataSet: TDataSet);
begin
  inherited;

  cdsTabelaSenha.AsString:= Cript(edtSenha.Text, toCript);
  cdsTabelaAdministrador.AsBoolean:= False;

  if not cdsUsuariosIn.Active then
    Exit;

  IncluirDeletarUsuarioPermissao();
end;

procedure TfrmCadastroDeUsuarios.IncluirDeletarUsuarioPermissao();
begin
  cdsUsuariosIn.First;
  while not cdsUsuariosIn.Eof do
  begin
    cdsUsuarioPermissao.Append;
    cdsUsuarioPermissaoIdUsuario.AsInteger:= cdsTabelaID.AsInteger;
    cdsUsuarioPermissaoIdUsuario_Permissao.AsInteger:= cdsUsuariosInID.AsInteger;
    cdsUsuarioPermissao.Post;
    cdsUsuariosIn.Next;
  end;

  cdsUsuariosOut.First;
  while not cdsUsuariosOut.Eof do
  begin
    if cdsUsuarioPermissao.Locate('IdUsuario;IdUsuario_Permissao',
                                  VarArrayOf([cdsTabelaID.AsInteger, cdsUsuariosOutID.AsInteger]),
                                  [loCaseInsensitive]) then
      cdsUsuarioPermissao.Delete;

    cdsUsuariosOut.Next;
  end;
end;

procedure TfrmCadastroDeUsuarios.cdsTabelaNewRecord(DataSet: TDataSet);
begin
  inherited;
  edtSenha.Clear;
end;

procedure TfrmCadastroDeUsuarios.dtsTabelaDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;
  gpbPermissao.Visible:= cdsTabela.State = dsEdit;
end;

end.
