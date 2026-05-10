program SistemasVendas;

uses
  Vcl.Forms,
  uDm             in 'uDm.pas'             {DM: TDataModule},
  Uprincipal      in 'Uprincipal.pas'      {frmPrincipal},
  uCadastro       in 'uCadastro.pas'       {frmCadastro},
  uProdutos       in 'uProdutos.pas'       {frmProdutos},
  uCadastroProduto in 'uCadastroProduto.pas' {frmCadastroProduto},
  uPedidos        in 'uPedidos.pas'        {frmPedidos},
  uCadastroPedido in 'uCadastroPedido.pas' {frmCadastroPedido};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDM, DM);                     // 1. Conexao com banco
  Application.CreateForm(TfrmPrincipal, frmPrincipal); // 2. Tela principal
  Application.Run;
end.
