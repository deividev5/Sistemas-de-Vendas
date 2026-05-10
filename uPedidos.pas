unit uPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBGrids, Vcl.ComCtrls, Data.DB,
  uDM, Vcl.Grids;

type
  TfrmPedidos = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    pnlFiltro: TPanel;
    lblBusca: TLabel;
    edtFiltro: TEdit;
    btnBuscar: TButton;
    dbgPedidos: TDBGrid;
    pnlBotoes: TPanel;
    btnNovo: TButton;
    btnVisualizar: TButton;
    btnCancelarPedido: TButton;
    btnAtualizar: TButton;
    sbStatus: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnVisualizarClick(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure edtFiltroKeyPress(Sender: TObject; var Key: Char);
    procedure dbgPedidosDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure AbrirCadastro(AId: Integer);
    procedure AtualizarStatus;
  end;

var
  frmPedidos: TfrmPedidos;

implementation

uses
  uCadastroPedido, Ora;

{$R *.dfm}

// ============================================================
//  INICIALIZAÇÃO E CONFIGURAÇÃO DO GRID
// ============================================================

procedure TfrmPedidos.FormCreate(Sender: TObject);
begin
  dbgPedidos.Columns[0].Title.Caption := 'ID';
  dbgPedidos.Columns[0].Width := 55;
  dbgPedidos.Columns[1].Title.Caption := 'Cliente';
  dbgPedidos.Columns[1].Width := 250;
  dbgPedidos.Columns[2].Title.Caption := 'Data';
  dbgPedidos.Columns[2].Width := 100;
  dbgPedidos.Columns[3].Title.Caption := 'Total R$';
  dbgPedidos.Columns[3].Width := 100;
  dbgPedidos.Columns[4].Title.Caption := 'Status';
  dbgPedidos.Columns[4].Width := 90;
  AtualizarStatus;
end;

// ============================================================
//  STATUS
// ============================================================

procedure TfrmPedidos.AtualizarStatus;
begin
  sbStatus.SimpleText := 'Total de Pedidos: ' +
    DM.qryPedidos.RecordCount.ToString;
end;

// ============================================================
//  ABRIR CADASTRO
// ============================================================

procedure TfrmPedidos.AbrirCadastro(AId: Integer);
var
  frm: TfrmCadastroPedido;
begin
  frm := TfrmCadastroPedido.Create(nil);
  try
    frm.IdPedido := AId;
    if frm.ShowModal = mrOk then
    begin
      DM.AtualizarPedidos(edtFiltro.Text);
      AtualizarStatus;
    end;
  finally
    frm.Free;
  end;
end;

// ============================================================
//  AÇÕES: Novo / Visualizar / Duplo clique
// ============================================================

procedure TfrmPedidos.btnNovoClick(Sender: TObject);
begin
  AbrirCadastro(0);
end;

procedure TfrmPedidos.btnVisualizarClick(Sender: TObject);
begin
  if DM.qryPedidos.IsEmpty then
  begin
    ShowMessage('Selecione um pedido para visualizar.');
    Exit;
  end;
  AbrirCadastro(DM.qryPedidos.FieldByName('ID_PEDIDO').AsInteger);
end;

procedure TfrmPedidos.dbgPedidosDblClick(Sender: TObject);
begin
  btnVisualizarClick(Sender);
end;

// ============================================================
//  CANCELAR PEDIDO
// ============================================================

procedure TfrmPedidos.btnCancelarPedidoClick(Sender: TObject);
var
  qry: TOraQuery;
  IdPedido: Integer;
begin
  if DM.qryPedidos.IsEmpty then
  begin
    ShowMessage('Selecione um pedido para cancelar.');
    Exit;
  end;

  if DM.qryPedidos.FieldByName('DS_STATUS').AsString = 'CANCELADO' then
  begin
    ShowMessage('Este pedido já está cancelado.');
    Exit;
  end;

  IdPedido := DM.qryPedidos.FieldByName('ID_PEDIDO').AsInteger;

  if MessageDlg('Deseja cancelar o pedido #' + IdPedido.ToString + '?',
     mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  qry := TOraQuery.Create(nil);
  try
    try
      qry.Session  := DM.OraSession;
      qry.SQL.Text :=
        'UPDATE TB_PEDIDO SET DS_STATUS = ''CANCELADO'' ' +
        'WHERE ID_PEDIDO = :p_id';
      qry.ParamByName('p_id').AsInteger := IdPedido;
      qry.ExecSQL;

      DM.AtualizarPedidos(edtFiltro.Text);
      AtualizarStatus;
      ShowMessage('Pedido cancelado com sucesso.');
    except
      on E: Exception do
        ShowMessage('Erro ao cancelar pedido: ' + E.Message);
    end;
  finally
    qry.Free;
  end;
end;

// ============================================================
//  BUSCA E FILTRO
// ============================================================

procedure TfrmPedidos.btnAtualizarClick(Sender: TObject);
begin
  edtFiltro.Clear;
  DM.AtualizarPedidos;
  AtualizarStatus;
end;

procedure TfrmPedidos.btnBuscarClick(Sender: TObject);
begin
  DM.AtualizarPedidos(edtFiltro.Text);
  AtualizarStatus;
end;

procedure TfrmPedidos.edtFiltroKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnBuscarClick(Sender);
end;

end.
