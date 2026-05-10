unit uProdutos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.DBGrids, Vcl.ComCtrls, Data.DB,
  uDM, Vcl.Grids;

type
  TfrmProdutos = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    pnlFiltro: TPanel;
    lblBusca: TLabel;
    edtFiltro: TEdit;
    btnBuscar: TButton;
    dbgProdutos: TDBGrid;
    pnlBotoes: TPanel;
    btnNovo: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    btnAtualizar: TButton;
    sbStatus: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure edtFiltroKeyPress(Sender: TObject; var Key: Char);
    procedure dbgProdutosDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure AbrirCadastro(AId: Integer);
    procedure AtualizarStatus;
  end;

var
  frmProdutos: TfrmProdutos;

implementation

uses
   uCadastroProduto, Ora;

{$R *.dfm}

// ============================================================
//  INICIALIZAÇÃO E CONFIGURAÇÃO DO GRID
// ============================================================

procedure TfrmProdutos.FormCreate(Sender: TObject);
begin
  dbgProdutos.Columns[0].Title.Caption := 'ID';
  dbgProdutos.Columns[0].Width := 50;
  dbgProdutos.Columns[1].Title.Caption := 'Descrição';
  dbgProdutos.Columns[1].Width := 250;
  dbgProdutos.Columns[2].Title.Caption := 'Preço R$';
  dbgProdutos.Columns[2].Width := 100;
  dbgProdutos.Columns[3].Title.Caption := 'Estoque';
  dbgProdutos.Columns[3].Width := 80;
  dbgProdutos.Columns[4].Title.Caption := 'Ativo';
  dbgProdutos.Columns[4].Width := 50;
  AtualizarStatus;
end;

// ============================================================
//  STATUS
// ============================================================

procedure TfrmProdutos.AtualizarStatus;
begin
  sbStatus.SimpleText := 'Total de Produtos: ' +
    DM.qryProdutos.RecordCount.ToString;
end;

// ============================================================
//  ABRIR CADASTRO
// ============================================================

procedure TfrmProdutos.AbrirCadastro(AId: Integer);
var
  frm: TfrmCadastroProduto;
begin
  frm := TfrmCadastroProduto.Create(nil);
  try
    frm.IdProduto := AId;
    if frm.ShowModal = mrOk then
    begin
      DM.AtualizarProdutos(edtFiltro.Text);
      AtualizarStatus;
    end;
  finally
    frm.Free;
  end;
end;

// ============================================================
//  AÇÕES: Novo / Editar / Duplo clique
// ============================================================

procedure TfrmProdutos.btnNovoClick(Sender: TObject);
begin
  AbrirCadastro(0);
end;

procedure TfrmProdutos.btnEditarClick(Sender: TObject);
begin
  if DM.qryProdutos.IsEmpty then
  begin
    ShowMessage('Selecione um produto para editar.');
    Exit;
  end;
  AbrirCadastro(DM.qryProdutos.FieldByName('ID_PRODUTO').AsInteger);
end;

procedure TfrmProdutos.dbgProdutosDblClick(Sender: TObject);
begin
  btnEditarClick(Sender);
end;

// ============================================================
//  INATIVAR PRODUTO
// ============================================================

procedure TfrmProdutos.btnExcluirClick(Sender: TObject);
var
  qry: TOraQuery;
  IdProduto: Integer;
  NomeProduto: string;
begin
  if DM.qryProdutos.IsEmpty then
  begin
    ShowMessage('Selecione um produto para inativar.');
    Exit;
  end;

  IdProduto   := DM.qryProdutos.FieldByName('ID_PRODUTO').AsInteger;
  NomeProduto := DM.qryProdutos.FieldByName('DS_DESCRICAO').AsString;

  if MessageDlg('Deseja inativar o produto "' + NomeProduto + '"?',
     mtConfirmation, [mbYes, mbNo], 0) <> mrYes then Exit;

  qry := TOraQuery.Create(nil);
  try
    try
      qry.Session  := DM.OraSession;
      qry.SQL.Text :=
        'UPDATE TB_PRODUTO SET FL_ATIVO = ''N'' WHERE ID_PRODUTO = :p_id';
      qry.ParamByName('p_id').AsInteger := IdProduto;
      qry.ExecSQL;

      DM.AtualizarProdutos(edtFiltro.Text);
      AtualizarStatus;
      ShowMessage('Produto inativado com sucesso.');
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

procedure TfrmProdutos.btnAtualizarClick(Sender: TObject);
begin
  edtFiltro.Clear;
  DM.AtualizarProdutos;
  AtualizarStatus;
end;

procedure TfrmProdutos.btnBuscarClick(Sender: TObject);
begin
  DM.AtualizarProdutos(edtFiltro.Text);
  AtualizarStatus;
end;

procedure TfrmProdutos.edtFiltroKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnBuscarClick(Sender);
end;

end.
