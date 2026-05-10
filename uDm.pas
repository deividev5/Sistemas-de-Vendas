unit uDm;

interface

uses
  System.SysUtils, System.Classes, Data.DB, DBAccess, Ora, MemDS, Vcl.Dialogs;

type
  TDM = class(TDataModule)
    OraSession: TOraSession;
    // Clientes
    qryClientes: TOraQuery;
    dsClientes: TOraDataSource;
    // Produtos
    qryProdutos: TOraQuery;
    dsProdutos: TOraDataSource;
    // Pedidos
    qryPedidos: TOraQuery;
    dsPedidos: TOraDataSource;
    dsItens: TOraDataSource;
    qryItens: TOraQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure ConfigurarConexao;
    procedure CarregarClientes;
    procedure CarregarProdutos;
    procedure CarregarPedidos;
  public
    procedure AtualizarClientes(const AFiltro: string = '');
    procedure AtualizarProdutos(const AFiltro: string = '');
    procedure AtualizarPedidos(const AFiltro: string = '');
    procedure CarregarItensDoPedido(AIdPedido: Integer);
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  ConfigurarConexao;
  CarregarClientes;
  CarregarProdutos;
  CarregarPedidos;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  if OraSession.Connected then
    OraSession.Close;
end;

procedure TDM.ConfigurarConexao;
begin
  OraSession.Server   := 'localhost:1521/XE';
  OraSession.Username := 'C##curso_app';
  OraSession.Password := 'deivissonxd';

  // Direct Mode = n�o precisa do Oracle Client instalado!
  OraSession.Options.Direct := True;

  try
    OraSession.Open;
  except
    on E: Exception do
      raise Exception.Create('Falha ao conectar no Oracle: ' + E.Message);
  end;
end;

procedure TDM.CarregarClientes;
begin
  qryClientes.Session  := OraSession;
  qryClientes.SQL.Text :=
    'SELECT ID_CLIENTE, NM_NOME, NR_CPF, DS_EMAIL, ' +
    '       NR_TELEFONE, FL_ATIVO, DT_CADASTRO ' +
    'FROM TB_CLIENTE ' +
    'ORDER BY NM_NOME';
  qryClientes.Open;
end;

procedure TDM.CarregarProdutos;
begin
  qryProdutos.Session  := OraSession;
  qryProdutos.SQL.Text :=
    'SELECT ID_PRODUTO, DS_DESCRICAO, VL_PRECO, NR_ESTOQUE, FL_ATIVO ' +
    'FROM TB_PRODUTO ' +
    'ORDER BY DS_DESCRICAO';
  qryProdutos.Open;
end;

procedure TDM.CarregarPedidos;
begin
  qryPedidos.Session  := OraSession;
  qryPedidos.SQL.Text :=
    'SELECT P.ID_PEDIDO, C.NM_NOME AS NM_CLIENTE, ' +
    '       P.DT_PEDIDO, P.VL_TOTAL, P.DS_STATUS ' +
    'FROM TB_PEDIDO P ' +
    'JOIN TB_CLIENTE C ON C.ID_CLIENTE = P.ID_CLIENTE ' +
    'ORDER BY P.DT_PEDIDO DESC';
  qryPedidos.Open;
end;

procedure TDM.AtualizarClientes(const AFiltro: string = '');
begin
  qryClientes.Close;
  if AFiltro = '' then
    qryClientes.SQL.Text :=
      'SELECT ID_CLIENTE, NM_NOME, NR_CPF, DS_EMAIL, ' +
      '       NR_TELEFONE, FL_ATIVO, DT_CADASTRO ' +
      'FROM TB_CLIENTE ORDER BY NM_NOME'
  else
  begin
    qryClientes.SQL.Text :=
      'SELECT ID_CLIENTE, NM_NOME, NR_CPF, DS_EMAIL, ' +
      '       NR_TELEFONE, FL_ATIVO, DT_CADASTRO ' +
      'FROM TB_CLIENTE ' +
      'WHERE UPPER(NM_NOME) LIKE UPPER(:p_filtro) ' +
      '   OR NR_CPF LIKE :p_filtro ' +
      'ORDER BY NM_NOME';
    qryClientes.ParamByName('p_filtro').AsString := '%' + AFiltro + '%';
  end;
  qryClientes.Open;
end;

procedure TDM.AtualizarProdutos(const AFiltro: string = '');
begin
  qryProdutos.Close;
  if AFiltro = '' then
    qryProdutos.SQL.Text :=
      'SELECT ID_PRODUTO, DS_DESCRICAO, VL_PRECO, NR_ESTOQUE, FL_ATIVO ' +
      'FROM TB_PRODUTO ORDER BY DS_DESCRICAO'
  else
  begin
    qryProdutos.SQL.Text :=
      'SELECT ID_PRODUTO, DS_DESCRICAO, VL_PRECO, NR_ESTOQUE, FL_ATIVO ' +
      'FROM TB_PRODUTO ' +
      'WHERE UPPER(DS_DESCRICAO) LIKE UPPER(:p_filtro) ' +
      'ORDER BY DS_DESCRICAO';
    qryProdutos.ParamByName('p_filtro').AsString := '%' + AFiltro + '%';
  end;
  qryProdutos.Open;
end;

procedure TDM.AtualizarPedidos(const AFiltro: string = '');
begin
  qryPedidos.Close;
  if AFiltro = '' then
    qryPedidos.SQL.Text :=
      'SELECT P.ID_PEDIDO, C.NM_NOME AS NM_CLIENTE, ' +
      '       P.DT_PEDIDO, P.VL_TOTAL, P.DS_STATUS ' +
      'FROM TB_PEDIDO P ' +
      'JOIN TB_CLIENTE C ON C.ID_CLIENTE = P.ID_CLIENTE ' +
      'ORDER BY P.DT_PEDIDO DESC'
  else
  begin
    qryPedidos.SQL.Text :=
      'SELECT P.ID_PEDIDO, C.NM_NOME AS NM_CLIENTE, ' +
      '       P.DT_PEDIDO, P.VL_TOTAL, P.DS_STATUS ' +
      'FROM TB_PEDIDO P ' +
      'JOIN TB_CLIENTE C ON C.ID_CLIENTE = P.ID_CLIENTE ' +
      'WHERE UPPER(C.NM_NOME) LIKE UPPER(:p_filtro) ' +
      'ORDER BY P.DT_PEDIDO DESC';
    qryPedidos.ParamByName('p_filtro').AsString := '%' + AFiltro + '%';
  end;
  qryPedidos.Open;
end;

procedure TDM.CarregarItensDoPedido(AIdPedido: Integer);
begin
  qryItens.Close;
  qryItens.Session  := OraSession;
  qryItens.SQL.Text :=
    'SELECT I.ID_ITEM, ' +
    '       P.DS_DESCRICAO, ' +
    '       I.NR_QUANTIDADE, ' +
    '       ''R$ '' || TO_CHAR(I.VL_UNITARIO, ''FM999G990D00'', ' +
    '         ''NLS_NUMERIC_CHARACTERS='''',.'''''' ) AS VL_UNITARIO, ' +
    '       ''R$ '' || TO_CHAR(I.VL_TOTAL, ''FM999G990D00'', ' +
    '         ''NLS_NUMERIC_CHARACTERS='''',.'''''' ) AS VL_TOTAL ' +
    '  FROM TB_ITEM_PEDIDO I ' +
    ' INNER JOIN TB_PRODUTO P ON P.ID_PRODUTO = I.ID_PRODUTO ' +
    ' WHERE I.ID_PEDIDO = :p_id_pedido ' +
    ' ORDER BY I.ID_ITEM';
  qryItens.ParamByName('p_id_pedido').AsInteger := AIdPedido;
  qryItens.Open;
end;

end.
