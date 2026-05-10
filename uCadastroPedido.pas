unit uCadastroPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBGrids, Vcl.ComCtrls, Data.DB, Vcl.Grids,
  uDM; // necessário na interface: o .dfm referencia DM.dsItens diretamente

type
  TfrmCadastroPedido = class(TForm)
    // ---- Topo ----
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    // ---- Cabeçalho do pedido ----
    pnlCabecalho: TPanel;
    lblCliente: TLabel;
    edtIdCliente: TEdit;
    edtNomeCliente: TEdit;
    btnBuscarCliente: TButton;
    lblStatus: TLabel;
    cboStatus: TComboBox;
    lblTotal: TLabel;
    edtTotal: TEdit;
    // ---- Painel de adição de itens ----
    pnlItem: TPanel;
    lblProduto: TLabel;
    edtIdProduto: TEdit;
    edtNomeProduto: TEdit;
    btnBuscarProduto: TButton;
    lblQtde: TLabel;
    edtQuantidade: TEdit;
    lblVlUnit: TLabel;
    edtVlUnitario: TEdit;
    btnAdicionarItem: TButton;
    btnRemoverItem: TButton;
    // ---- Grid de itens ----
    dbgItens: TDBGrid;
    // ---- Botões finais ----
    pnlBotoes: TPanel;
    btnSalvar: TButton;
    btnCancelar: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnBuscarClienteClick(Sender: TObject);
    procedure btnBuscarProdutoClick(Sender: TObject);
    procedure btnAdicionarItemClick(Sender: TObject);
    procedure btnRemoverItemClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FIdPedido: Integer;
    FPedidoNovo: Boolean; // True = pedido criado nesta sessão, ainda não salvo
    procedure CarregarDados;
    procedure LimparCampos;
    procedure RecalcularTotal;
    function Validar: Boolean;
  public
    property IdPedido: Integer read FIdPedido write FIdPedido;
  end;

var
  frmCadastroPedido: TfrmCadastroPedido;

implementation

uses
    Ora;

{$R *.dfm}

// ============================================================
//  LIMPEZA E INICIALIZAÇÃO
// ============================================================

procedure TfrmCadastroPedido.LimparCampos;
begin
  edtIdCliente.Clear;
  edtNomeCliente.Clear;
  edtIdProduto.Clear;
  edtNomeProduto.Clear;
  edtQuantidade.Text := '1';
  edtVlUnitario.Text := 'R$ 0,00';
  edtTotal.Text      := 'R$ 0,00';
  cboStatus.ItemIndex := 0; // ABERTO
  FPedidoNovo := False;
  DM.qryItens.Close; // garante que o grid de itens começa vazio
end;

procedure TfrmCadastroPedido.FormShow(Sender: TObject);
begin
  LimparCampos;

  if FIdPedido > 0 then
  begin
    lblTitulo.Caption := 'Visualizar Pedido';
    CarregarDados;
  end
  else
    lblTitulo.Caption := 'Novo Pedido';

  edtIdCliente.SetFocus;
end;

// ============================================================
//  CARREGAR DADOS (edição / visualização de pedido existente)
// ============================================================

procedure TfrmCadastroPedido.CarregarDados;
var
  qry: TOraQuery;
begin
  qry := TOraQuery.Create(nil);
  try
    qry.Session  := DM.OraSession;
    qry.SQL.Text :=
      'SELECT P.ID_CLIENTE, C.NM_NOME, P.DS_STATUS, P.VL_TOTAL ' +
      'FROM TB_PEDIDO P ' +
      'JOIN TB_CLIENTE C ON C.ID_CLIENTE = P.ID_CLIENTE ' +
      'WHERE P.ID_PEDIDO = :p_id';
    qry.ParamByName('p_id').AsInteger := FIdPedido;
    qry.Open;

    if not qry.IsEmpty then
    begin
      edtIdCliente.Text   := qry.FieldByName('ID_CLIENTE').AsString;
      edtNomeCliente.Text := qry.FieldByName('NM_NOME').AsString;
      edtTotal.Text       := FormatCurr('"R$" #.##0,00', qry.FieldByName('VL_TOTAL').AsCurrency);

      // Seleciona o item correto no ComboBox pelo texto
      cboStatus.ItemIndex := cboStatus.Items.IndexOf(
        qry.FieldByName('DS_STATUS').AsString);
    end;
  finally
    qry.Free;
  end;

  // Carrega os itens no grid (procedure do DataModule)
  DM.CarregarItensDoPedido(FIdPedido);
end;

// ============================================================
//  BUSCAR CLIENTE (preenche o nome ao informar o ID)
// ============================================================

procedure TfrmCadastroPedido.btnBuscarClienteClick(Sender: TObject);
var
  qry: TOraQuery;
  IdCli: Integer;
begin
  IdCli := StrToIntDef(edtIdCliente.Text, 0);
  if IdCli = 0 then
  begin
    ShowMessage('Informe um ID de cliente válido.');
    edtIdCliente.SetFocus;
    Exit;
  end;

  qry := TOraQuery.Create(nil);
  try
    qry.Session  := DM.OraSession;
    qry.SQL.Text :=
      'SELECT NM_NOME FROM TB_CLIENTE ' +
      'WHERE ID_CLIENTE = :p_id AND FL_ATIVO = ''S''';
    qry.ParamByName('p_id').AsInteger := IdCli;
    qry.Open;

    if qry.IsEmpty then
    begin
      ShowMessage('Cliente não encontrado ou inativo.');
      edtNomeCliente.Clear;
      edtIdCliente.SetFocus;
    end
    else
      edtNomeCliente.Text := qry.FieldByName('NM_NOME').AsString;
  finally
    qry.Free;
  end;
end;

// ============================================================
//  BUSCAR PRODUTO (preenche nome e preço ao informar o ID)
// ============================================================

procedure TfrmCadastroPedido.btnBuscarProdutoClick(Sender: TObject);
var
  qry: TOraQuery;
  IdProd: Integer;
begin
  IdProd := StrToIntDef(edtIdProduto.Text, 0);
  if IdProd = 0 then
  begin
    ShowMessage('Informe um ID de produto válido.');
    edtIdProduto.SetFocus;
    Exit;
  end;

  qry := TOraQuery.Create(nil);
  try
    qry.Session  := DM.OraSession;
    qry.SQL.Text :=
      'SELECT DS_DESCRICAO, VL_PRECO, NR_ESTOQUE FROM TB_PRODUTO ' +
      'WHERE ID_PRODUTO = :p_id AND FL_ATIVO = ''S''';
    qry.ParamByName('p_id').AsInteger := IdProd;
    qry.Open;

    if qry.IsEmpty then
    begin
      ShowMessage('Produto não encontrado ou inativo.');
      edtNomeProduto.Clear;
      edtVlUnitario.Clear;
      edtIdProduto.SetFocus;
    end
    else
    begin
      edtNomeProduto.Text := qry.FieldByName('DS_DESCRICAO').AsString;
      edtVlUnitario.Text  := FormatCurr('"R$" #.##0,00', qry.FieldByName('VL_PRECO').AsCurrency);

      // Aviso de estoque zerado (não bloqueia, só avisa)
      if qry.FieldByName('NR_ESTOQUE').AsInteger = 0 then
        ShowMessage('Atenção: este produto está sem estoque.');
    end;
  finally
    qry.Free;
  end;
end;

// ============================================================
//  ADICIONAR ITEM
//  Fluxo:
//  1. Valida campos
//  2. Se FIdPedido = 0  →  cria o cabeçalho TB_PEDIDO (RETURNING ID)
//  3. Insere linha em TB_ITEM_PEDIDO
//  4. Atualiza grid e total
// ============================================================

procedure TfrmCadastroPedido.btnAdicionarItemClick(Sender: TObject);
var
  qry: TOraQuery;
  IdCli, IdProd, Qtde: Integer;
  VlUnit: Currency;
  fs: TFormatSettings;
begin
  // ---- Validações ----
  IdCli := StrToIntDef(edtIdCliente.Text, 0);
  if (IdCli = 0) or (edtNomeCliente.Text = '') then
  begin
    ShowMessage('Selecione um cliente antes de adicionar itens.');
    edtIdCliente.SetFocus;
    Exit;
  end;

  IdProd := StrToIntDef(edtIdProduto.Text, 0);
  if (IdProd = 0) or (edtNomeProduto.Text = '') then
  begin
    ShowMessage('Selecione um produto antes de adicionar.');
    edtIdProduto.SetFocus;
    Exit;
  end;

  Qtde := StrToIntDef(edtQuantidade.Text, 0);
  if Qtde <= 0 then
  begin
    ShowMessage('Informe uma quantidade válida (maior que zero).');
    edtQuantidade.SetFocus;
    Exit;
  end;

  fs := TFormatSettings.Create('en-US');
  VlUnit := StrToCurrDef(
    StringReplace(
      StringReplace(
        StringReplace(edtVlUnitario.Text, 'R$ ', '', [rfReplaceAll]),
      '.', '', [rfReplaceAll]),
    ',', '.', [rfReplaceAll]), 0, fs);

  qry := TOraQuery.Create(nil);
  try
    try
      qry.Session := DM.OraSession;

      // ---- Passo 1: cria o cabeçalho do pedido (apenas na primeira vez) ----
      if FIdPedido = 0 then
      begin
        // INSERT simples — a trigger preenche o ID via SEQ_PEDIDO.NEXTVAL
        qry.SQL.Text :=
          'INSERT INTO TB_PEDIDO (ID_CLIENTE, DS_STATUS, VL_TOTAL) ' +
          'VALUES (:p_id_cli, ''ABERTO'', 0)';
        qry.ParamByName('p_id_cli').AsInteger := IdCli;
        qry.ExecSQL;

        // Pega o ID que a sequence acabou de gerar (na mesma sessão)
        qry.SQL.Text := 'SELECT SEQ_PEDIDO.CURRVAL FROM DUAL';
        qry.Open;
        FIdPedido := qry.Fields[0].AsInteger;
        qry.Close;

        FPedidoNovo := True;
      end;

      // ---- Passo 2: insere o item ----
      qry.SQL.Text :=
        'INSERT INTO TB_ITEM_PEDIDO ' +
        '  (ID_PEDIDO, ID_PRODUTO, NR_QUANTIDADE, VL_UNITARIO, VL_TOTAL) ' +
        'VALUES (:p_ped, :p_prod, :p_qtde, :p_unit, :p_total)';

      qry.ParamByName('p_ped').AsInteger    := FIdPedido;
      qry.ParamByName('p_prod').AsInteger   := IdProd;
      qry.ParamByName('p_qtde').AsInteger   := Qtde;
      qry.ParamByName('p_unit').AsCurrency  := VlUnit;
      qry.ParamByName('p_total').AsCurrency := VlUnit * Qtde;
      qry.ExecSQL;

      // ---- Passo 3: atualiza grid e total ----
      DM.CarregarItensDoPedido(FIdPedido);
      RecalcularTotal;

      // Limpa só os campos de produto para facilitar adicionar o próximo
      edtIdProduto.Clear;
      edtNomeProduto.Clear;
      edtQuantidade.Text := '1';
      edtVlUnitario.Text := 'R$ 0,00';
      edtIdProduto.SetFocus;

    except
      on E: Exception do
        ShowMessage('Erro ao adicionar item: ' + E.Message);
    end;
  finally
    qry.Free;
  end;
end;

// ============================================================
//  REMOVER ITEM selecionado no grid
// ============================================================

procedure TfrmCadastroPedido.btnRemoverItemClick(Sender: TObject);
var
  qry: TOraQuery;
  IdItem: Integer;
begin
  if DM.qryItens.IsEmpty then
  begin
    ShowMessage('Selecione um item para remover.');
    Exit;
  end;

  if MessageDlg('Remover este item do pedido?',
     mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  IdItem := DM.qryItens.FieldByName('ID_ITEM').AsInteger;

  qry := TOraQuery.Create(nil);
  try
    try
      qry.Session  := DM.OraSession;
      qry.SQL.Text := 'DELETE FROM TB_ITEM_PEDIDO WHERE ID_ITEM = :p_id';
      qry.ParamByName('p_id').AsInteger := IdItem;
      qry.ExecSQL;

      DM.CarregarItensDoPedido(FIdPedido);
      RecalcularTotal;
    except
      on E: Exception do
        ShowMessage('Erro ao remover item: ' + E.Message);
    end;
  finally
    qry.Free;
  end;
end;

// ============================================================
//  RECALCULAR TOTAL (lê SUM do banco — sempre preciso)
// ============================================================

procedure TfrmCadastroPedido.RecalcularTotal;
var
  qry: TOraQuery;
begin
  if FIdPedido = 0 then Exit;

  qry := TOraQuery.Create(nil);
  try
    qry.Session  := DM.OraSession;
    // NVL garante que retorna 0 mesmo quando não há itens
    qry.SQL.Text :=
      'SELECT NVL(SUM(VL_TOTAL), 0) AS TOTAL ' +
      'FROM TB_ITEM_PEDIDO WHERE ID_PEDIDO = :p_id';
    qry.ParamByName('p_id').AsInteger := FIdPedido;
    qry.Open;
    edtTotal.Text := FormatCurr('"R$" #.##0,00', qry.FieldByName('TOTAL').AsCurrency);
  finally
    qry.Free;
  end;
end;

// ============================================================
//  VALIDAR antes de salvar
// ============================================================

function TfrmCadastroPedido.Validar: Boolean;
begin
  Result := False;

  if edtNomeCliente.Text = '' then
  begin
    ShowMessage('Selecione um cliente para o pedido.');
    edtIdCliente.SetFocus;
    Exit;
  end;

  if FIdPedido = 0 then
  begin
    ShowMessage('Adicione pelo menos um item antes de salvar.');
    edtIdProduto.SetFocus;
    Exit;
  end;

  Result := True;
end;

// ============================================================
//  SALVAR — atualiza VL_TOTAL e DS_STATUS no cabeçalho
// ============================================================

procedure TfrmCadastroPedido.btnSalvarClick(Sender: TObject);
var
  qry: TOraQuery;
  VlTotal: Currency;
  fs: TFormatSettings;
begin
  if not Validar then Exit;

  fs := TFormatSettings.Create('en-US');
  VlTotal := StrToCurrDef(
    StringReplace(
      StringReplace(
        StringReplace(edtTotal.Text, 'R$ ', '', [rfReplaceAll]),
      '.', '', [rfReplaceAll]),
    ',', '.', [rfReplaceAll]), 0, fs);

  qry := TOraQuery.Create(nil);
  try
    try
      qry.Session  := DM.OraSession;
      qry.SQL.Text :=
        'UPDATE TB_PEDIDO SET ' +
        '  VL_TOTAL  = :p_total, ' +
        '  DS_STATUS = :p_status ' +
        'WHERE ID_PEDIDO = :p_id';

      qry.ParamByName('p_total').AsCurrency := VlTotal;
      qry.ParamByName('p_status').AsString  := cboStatus.Text;
      qry.ParamByName('p_id').AsInteger     := FIdPedido;
      qry.ExecSQL;

      FPedidoNovo := False; // salvo com sucesso — já não é "novo"
      ModalResult := mrOk;
    except
      on E: Exception do
        ShowMessage('Erro ao salvar pedido: ' + E.Message);
    end;
  finally
    qry.Free;
  end;
end;

// ============================================================
//  CANCELAR
//  Se o pedido foi criado nesta sessão mas não foi salvo,
//  apaga itens + cabeçalho para não deixar registro incompleto.
// ============================================================

procedure TfrmCadastroPedido.btnCancelarClick(Sender: TObject);
var
  qry: TOraQuery;
begin
  if FPedidoNovo and (FIdPedido > 0) then
  begin
    if MessageDlg(
      'O pedido não foi salvo.' + sLineBreak +
      'Deseja descartar os itens adicionados?',
      mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

    qry := TOraQuery.Create(nil);
    try
      try
        qry.Session := DM.OraSession;

        // Deleta itens primeiro (FK impede deletar o cabeçalho antes)
        qry.SQL.Text := 'DELETE FROM TB_ITEM_PEDIDO WHERE ID_PEDIDO = :p_id';
        qry.ParamByName('p_id').AsInteger := FIdPedido;
        qry.ExecSQL;

        // Depois deleta o cabeçalho
        qry.SQL.Text := 'DELETE FROM TB_PEDIDO WHERE ID_PEDIDO = :p_id';
        qry.ParamByName('p_id').AsInteger := FIdPedido;
        qry.ExecSQL;

        FIdPedido   := 0;
        FPedidoNovo := False;
      except
        on E: Exception do
          ShowMessage('Erro ao descartar pedido: ' + E.Message);
      end;
    finally
      qry.Free;
    end;
  end;

  DM.qryItens.Close; // limpa o grid
  ModalResult := mrCancel;
end;

end.
