unit uCadastroProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, strUtils;

type
  TfrmCadastroProduto = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    lblDescricao: TLabel;
    edtDescricao: TEdit;
    lblPreco: TLabel;
    edtPreco: TEdit;
    lblEstoque: TLabel;
    edtEstoque: TEdit;
    chkAtivo: TCheckBox;
    pnlBotoes: TPanel;
    btnSalvar: TButton;
    btnCancelar: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FIdProduto: Integer;
    procedure CarregarDados;
    function Validar: Boolean;
    procedure LimparCampos;
  public
    property IdProduto: Integer read FIdProduto write FIdProduto;
  end;

var
  frmCadastroProduto: TfrmCadastroProduto;

implementation

uses
  uDM, Data.DB, Ora;

{$R *.dfm}

// ============================================================
//  LIMPEZA DOS CAMPOS
// ============================================================

procedure TfrmCadastroProduto.LimparCampos;
begin
  edtDescricao.Clear;
  edtPreco.Text    := '0,00';
  edtEstoque.Text  := '0';
  chkAtivo.Checked := True;
  lblTitulo.Caption := 'Novo Produto';
end;

// ============================================================
//  INICIALIZAÇÃO DO FORM
// ============================================================

procedure TfrmCadastroProduto.FormShow(Sender: TObject);
begin
  LimparCampos;
  if FIdProduto > 0 then
  begin
    lblTitulo.Caption := 'Editar Produto';
    CarregarDados;
  end;
  edtDescricao.SetFocus;
end;

// ============================================================
//  CARREGAR DADOS (edição de produto existente)
// ============================================================

procedure TfrmCadastroProduto.CarregarDados;
var
  qry: TOraQuery;
begin
  qry := TOraQuery.Create(nil);
  try
    qry.Session  := DM.OraSession;
    qry.SQL.Text :=
      'SELECT DS_DESCRICAO, VL_PRECO, NR_ESTOQUE, FL_ATIVO ' +
      'FROM TB_PRODUTO WHERE ID_PRODUTO = :p_id';
    qry.ParamByName('p_id').AsInteger := FIdProduto;
    qry.Open;

    if not qry.IsEmpty then
    begin
      edtDescricao.Text := qry.FieldByName('DS_DESCRICAO').AsString;
      edtPreco.Text     := FormatFloat('0.00', qry.FieldByName('VL_PRECO').AsFloat);
      edtEstoque.Text   := qry.FieldByName('NR_ESTOQUE').AsString;
      chkAtivo.Checked  := qry.FieldByName('FL_ATIVO').AsString = 'S';
    end;
  finally
    qry.Free;
  end;
end;


// ============================================================
//  VALIDAÇÕES
// ============================================================

function TfrmCadastroProduto.Validar: Boolean;
var
  valor: Double;
  fs: TFormatSettings;
begin
  Result := False;
  fs := TFormatSettings.Create('en-US');

  if Trim(edtDescricao.Text) = '' then
  begin
    ShowMessage('Informe a descri' + #231#227 + 'o do produto.');
    edtDescricao.SetFocus;
    Exit;
  end;

  if not TryStrToFloat(
    StringReplace(edtPreco.Text, ',', '.', [rfReplaceAll]), valor, fs) then
  begin
    ShowMessage('Pre�o inv�lido.');
    edtPreco.SetFocus;
    Exit;
  end;

  Result := True;
end;


// ============================================================
//  SALVAR
// ============================================================

procedure TfrmCadastroProduto.btnSalvarClick(Sender: TObject);
var
  qry: TOraQuery;
  FlagAtivo: string;
  VlPreco: Currency;
  fs: TFormatSettings;
begin
  if not Validar then Exit;
  fs := TFormatSettings.Create('en-US');

  // Converte o texto do campo para n\u00famero
  VlPreco := StrToCurrDef(
    StringReplace(edtPreco.Text, ',', '.', [rfReplaceAll]), 0, fs);

  FlagAtivo := IfThen(chkAtivo.Checked, 'S', 'N');

  qry := TOraQuery.Create(nil);
  try
    try
      qry.Session := DM.OraSession;

      if FIdProduto = 0 then
      begin
        // ---- INSERIR ----
        qry.SQL.Text :=
          'BEGIN ' +
          '  PRC_CADASTRAR_PRODUTO( ' +
          '    p_descricao => :p_descricao, ' +
          '    p_preco     => :p_preco, ' +
          '    p_estoque   => :p_estoque, ' +
          '    p_id_gerado => :p_id ' +
          '  ); ' +
          'END;';

        qry.ParamByName('p_descricao').AsString := Trim(edtDescricao.Text);
        qry.ParamByName('p_preco').AsFloat      := VlPreco;
        qry.ParamByName('p_estoque').AsInteger  := StrToInt(edtEstoque.Text);

        qry.ParamByName('p_id').ParamType := ptOutput;
        qry.ParamByName('p_id').DataType  := ftInteger;

        qry.ExecSQL;

        ShowMessage('Produto cadastrado com sucesso!' + sLineBreak +
          'ID gerado: ' + qry.ParamByName('p_id').AsString);
      end
      else
      begin
        // ---- ATUALIZAR ----
        qry.SQL.Text :=
          'UPDATE TB_PRODUTO SET ' +
          '  DS_DESCRICAO = :p_descricao, ' +
          '  VL_PRECO     = :p_preco, ' +
          '  NR_ESTOQUE   = :p_estoque, ' +
          '  FL_ATIVO     = :p_ativo ' +
          'WHERE ID_PRODUTO = :p_id';

        qry.ParamByName('p_descricao').AsString := Trim(edtDescricao.Text);
        qry.ParamByName('p_preco').AsFloat      := VlPreco;
        qry.ParamByName('p_estoque').AsInteger  := StrToInt(edtEstoque.Text);
        qry.ParamByName('p_ativo').AsString     := FlagAtivo;
        qry.ParamByName('p_id').AsInteger       := FIdProduto;

        qry.ExecSQL;
        ShowMessage('Produto atualizado com sucesso!');
      end;

      ModalResult := mrOk;
    except
      on E: Exception do
        ShowMessage('Erro ao salvar: ' + E.Message);
    end;
  finally
    qry.Free;
  end;
end;

// ============================================================
//  CANCELAR
// ============================================================

procedure TfrmCadastroProduto.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel; // Fecha o form sem salvar nada
end;

end.
