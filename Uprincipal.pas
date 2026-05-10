unit Uprincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBGrids, Vcl.ComCtrls, Data.DB, Vcl.Grids, Ora;

type
  TfrmPrincipal = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    pnlMenu: TPanel;
    btnMenuClientes: TButton;
    btnMenuProdutos: TButton;
    btnMenuPedidos: TButton;
    pnlFiltro: TPanel;
    lblBusca: TLabel;
    edtFiltro: TEdit;
    btnBuscar: TButton;
    sbStatus: TStatusBar;
    pnlBotoes: TPanel;
    btnNovo: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    btnAtualizar: TButton;
    dbgClientes: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure edtFiltroKeyPress(Sender: TObject; var Key: Char);
    procedure dbgClientesDblClick(Sender: TObject);
    procedure btnMenuClientesClick(Sender: TObject);
    procedure btnMenuProdutosClick(Sender: TObject);
    procedure btnMenuPedidosClick(Sender: TObject);
  private

  public
  procedure AbrirCadastro(AId: Integer);
    procedure AtualizarStatus;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation
uses
  uCadastro,
  uProdutos,
  uPedidos,
  uDM;

{$R *.dfm}

// ============================================================
//  INICIALIZAÇÃO E CONFIGURAÇÃO DO GRID
// ============================================================

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  // Configurar colunas do grid
  dbgClientes.Columns[0].Title.Caption := 'ID';
  dbgClientes.Columns[0].Width := 50;
  dbgClientes.Columns[1].Title.Caption := 'Nome';
  dbgClientes.Columns[1].Width := 200;
  dbgClientes.Columns[2].Title.Caption := 'CPF';
  dbgClientes.Columns[2].Width := 120;
  dbgClientes.Columns[3].Title.Caption := 'E-mail';
  dbgClientes.Columns[3].Width := 180;
  dbgClientes.Columns[4].Title.Caption := 'Telefone';
  dbgClientes.Columns[5].Title.Caption := 'Ativo';
  dbgClientes.Columns[5].Width := 50;
  dbgClientes.Columns[6].Title.Caption := 'Cadastro';
  dbgClientes.Columns[6].Width := 100;

  AtualizarStatus;
end;

// ============================================================
//  STATUS
// ============================================================

procedure TfrmPrincipal.AtualizarStatus;
begin
  sbStatus.SimpleText := 'Total de Registros: ' +
    DM.qryClientes.RecordCount.ToString;
end;


// ============================================================
//  ABRIR CADASTRO
// ============================================================

procedure TfrmPrincipal.AbrirCadastro(AId: Integer);
var
frm: TfrmCadastro;
begin
 frm := TfrmCadastro.Create(nil);

 try
   frm.IdCliente := AId;
   if frm.ShowModal = mrOk then
   begin
     DM.AtualizarClientes(edtFiltro.Text);
     AtualizarStatus;
   end;
 finally
   frm.Free;
 end;

end;


// ============================================================
//  AÇÕES: Novo / Editar / Duplo clique
// ============================================================

procedure TfrmPrincipal.btnNovoClick(Sender: TObject);
begin
  AbrirCadastro(0);    //0 = novo registro
end;


procedure TfrmPrincipal.btnEditarClick(Sender: TObject);
begin
  if DM.qryClientes.IsEmpty then
  begin
    showMessage('Selecione um cliente para editar');
    exit;
  end;


  AbrirCadastro(DM.qryClientes.FieldByName('ID_CLIENTE').AsInteger);
end;

procedure TfrmPrincipal.dbgClientesDblClick(Sender: TObject);
begin
  btnEditarClick(Sender)
end;

// ============================================================
//  INATIVAR CLIENTE
// ============================================================

procedure TfrmPrincipal.btnExcluirClick(Sender: TObject);
var
qry: TOraQuery;
IdCliente: Integer;
NomeCliente: string;

begin

  if DM.qryClientes.IsEmpty then
  begin
   ShowMessage('Selecione um cliente para excluir.');
   Exit;
  end;

 IdCliente   := DM.qryClientes.FieldByName('ID_CLIENTE').AsInteger;
 NomeCliente := DM.qryClientes.FieldByName('NM_NOME').AsString;

 if MessageDlg(
    'Deseja excluir o cliente "' + NomeCliente + '"?',
    mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  qry := TOraQuery.Create(nil);
  try
    try
      qry.Session := DM.OraSession;
      qry.SQL.Text :=
        'BEGIN ' +
        '  PKG_CLIENTE.PRC_INATIVAR(:p_id); ' +
        'END;';
      qry.ParamByName('p_id').AsInteger := IdCliente;
      qry.ExecSQL;

      DM.AtualizarClientes(edtFiltro.Text);
      AtualizarStatus;
      ShowMessage('Cliente inativado com sucesso.');
    except
      on E: Exception do
        ShowMessage('Erro ao inativar: ' + E.Message);
    end;
  finally
    qry.Free;
  end;

end;


// ============================================================
//  BUSCA E FILTRO
// ============================================================

procedure TfrmPrincipal.btnAtualizarClick(Sender: TObject);
begin
  edtFiltro.Clear;
  DM.AtualizarClientes;
  AtualizarStatus;
end;


procedure TfrmPrincipal.btnBuscarClick(Sender: TObject);
begin
  DM.AtualizarClientes(edtFiltro.Text);
  AtualizarStatus;
end;


procedure TfrmPrincipal.edtFiltroKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then // Enter executa a busca
    btnBuscarClick(Sender);
end;

// ============================================================
//  NAVEGAÇÃO (menu superior)
// ============================================================

procedure TfrmPrincipal.btnMenuClientesClick(Sender: TObject);
begin
  // Clientes já está nesta mesma tela — não faz nada
  // Você pode expandir isso para mostrar/esconder painéis se quiser
  ShowMessage('Você já está na tela de Clientes.');
end;

procedure TfrmPrincipal.btnMenuProdutosClick(Sender: TObject);
var
  frm: TfrmProdutos;
begin
  frm := TfrmProdutos.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TfrmPrincipal.btnMenuPedidosClick(Sender: TObject);
var
  frm: TfrmPedidos;
begin
  frm := TfrmPedidos.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

end.
