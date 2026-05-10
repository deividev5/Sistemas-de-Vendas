unit uCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Ora, strUtils;

type
  TfrmCadastro = class(TForm)
    pnlTopo: TPanel;
    lblTitulo: TLabel;
    lblNome: TLabel;
    edtNome: TEdit;
    lblCPF: TLabel;
    edtCPF: TEdit;
    lblEmail: TLabel;
    edtEmail: TEdit;
    lblTelefone: TLabel;
    edtTelefone: TEdit;
    chkAtivo: TCheckBox;
    pnlBotoes: TPanel;
    btnSalvar: TButton;
    btnCancelar: TButton;
    procedure FormShow(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FIdCliente: Integer;
    procedure CarregarDados;
    function Validar: Boolean;
    procedure LimparCampos;
  public
    property IdCliente: Integer read FIdCliente write FIdCliente;
  end;

var
  frmCadastro: TfrmCadastro;

implementation

uses
 uDM, Data.DB;

{$R *.dfm}

// ============================================================
//  INICIALIZAÇÃO DO FORM
// ============================================================

procedure TfrmCadastro.FormShow(Sender: TObject);
begin
  LimparCampos;

  if FIdCliente > 0 then
  begin
  lblTitulo.Caption := 'Editar Cliente';
  CarregarDados;
  end;

  edtNome.SetFocus;
end;

// ============================================================
//  LIMPEZA DOS CAMPOS
// ============================================================

procedure TfrmCadastro.LimparCampos;
begin
  edtNome.Clear;
  edtCPF.Clear;
  edtEmail.Clear;
  edtTelefone.Clear;
  chkAtivo.Checked := True;
end;

// ============================================================
//  CARREGAR DADOS (edição de cliente existente)
// ============================================================

procedure TfrmCadastro.CarregarDados;
var
qry: TOraQuery;

begin
  qry := TOraQuery.Create(nil);
  try
    qry.Session := DM.OraSession;
    qry.SQL.Text :=
    'SELECT NM_NOME, NR_CPF, DS_EMAIL, NR_TELEFONE, FL_ATIVO ' +
      'FROM TB_CLIENTE ' +
      'WHERE ID_CLIENTE = :p_id';
      qry.ParamByName('p_id').AsInteger := FIdCliente;
      qry.Open;

      if not qry.IsEmpty then
      begin
      edtNome.Text     := qry.FieldByName('NM_NOME').AsString;
      edtCPF.Text      := qry.FieldByName('NR_CPF').AsString;
      edtEmail.Text    := qry.FieldByName('DS_EMAIL').AsString;
      edtTelefone.Text := qry.FieldByName('NR_TELEFONE').AsString;
      chkAtivo.Checked := qry.FieldByName('FL_ATIVO').AsString = 'S';
      end;
  finally
  qry.Free;
  end;
end;

// ============================================================
//  VALIDAÇÕES
// ============================================================

function TfrmCadastro.Validar: Boolean;
begin
  Result := False;

  if trim(edtNome.Text) = '' then
  begin
    ShowMessage('Informe o nome do cliente');
    edtNome.SetFocus;
    Exit;
  end;

   if Trim(edtCPF.Text) = '' then
  begin
    ShowMessage('Informe o CPF do cliente.');
    edtCPF.SetFocus;
    Exit;
  end;

  Result := True;

end;

// ============================================================
//  SALVAR
// ============================================================

procedure TfrmCadastro.btnSalvarClick(Sender: TObject);
var
  qry: TOraQuery;
  FlagAtivo: string;
begin
  if not Validar then Exit;

  FlagAtivo := IfThen(chkAtivo.Checked, 'S', 'N');

  qry := TOraQuery.Create(nil); // Cria o objeto na memória
  try                           // try externo — garante o Free
    try                         // try interno — captura erros
      qry.Session := DM.OraSession;

      if FIdCliente = 0 then
      begin
        // ---- INSERIR (chama a Package) ----
        qry.SQL.Text :=
          'BEGIN ' +
          '  PKG_CLIENTE.PRC_CADASTRAR(' +
          '    p_nome  => :p_nome, ' +
          '    p_cpf   => :p_cpf, ' +
          '    p_email => :p_email, ' +
          '    p_id    => :p_id ' +
          '  ); ' +
          'END;';

        qry.ParamByName('p_nome').AsString  := Trim(edtNome.Text);
        qry.ParamByName('p_cpf').AsString   := Trim(edtCPF.Text);
        qry.ParamByName('p_email').AsString := Trim(edtEmail.Text);

        // Parâmetro de saída (OUT)
        qry.ParamByName('p_id').ParamType := ptOutput;
        qry.ParamByName('p_id').DataType  := ftInteger;

        qry.ExecSQL;

        ShowMessage('Cliente cadastrado com sucesso!' + sLineBreak +
          'ID gerado: ' + qry.ParamByName('p_id').AsString);
      end
      else
      begin
        // ---- ATUALIZAR ----
        qry.SQL.Text :=
          'UPDATE TB_CLIENTE SET ' +
          '  NM_NOME     = :p_nome, ' +
          '  NR_CPF      = :p_cpf, ' +
          '  DS_EMAIL    = :p_email, ' +
          '  NR_TELEFONE = :p_telefone, ' +
          '  FL_ATIVO    = :p_ativo ' +
          'WHERE ID_CLIENTE = :p_id';

        qry.ParamByName('p_nome').AsString     := Trim(edtNome.Text);
        qry.ParamByName('p_cpf').AsString      := Trim(edtCPF.Text);
        qry.ParamByName('p_email').AsString    := Trim(edtEmail.Text);
        qry.ParamByName('p_telefone').AsString := Trim(edtTelefone.Text);
        qry.ParamByName('p_ativo').AsString    := FlagAtivo;
        qry.ParamByName('p_id').AsInteger      := FIdCliente;

        qry.ExecSQL;
        ShowMessage('Cliente atualizado com sucesso!');
      end;

      ModalResult := mrOk; // Fecha e avisa a tela principal para atualizar
    except
      on E: Exception do
        ShowMessage('Erro ao salvar: ' + E.Message);
    end;                    // fecha o try interno
  finally
    qry.Free;               // executa SEMPRE, com ou sem erro
  end;                      // fecha o try externo

end;

// ============================================================
//  CANCELAR
// ============================================================

procedure TfrmCadastro.btnCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
