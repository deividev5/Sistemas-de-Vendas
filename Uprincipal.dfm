object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Sistema de Vendas'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = clNavy
    ParentBackground = False
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 0
      Top = 0
      Width = 800
      Height = 50
      Align = alClient
      Alignment = taCenter
      Caption = 'Cadastro de Clientes'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 180
      ExplicitHeight = 25
    end
  end
  object pnlMenu: TPanel
    Left = 0
    Top = 50
    Width = 800
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = $00E8E8E8
    ParentBackground = False
    TabOrder = 1
    object btnMenuClientes: TButton
      Left = 8
      Top = 7
      Width = 110
      Height = 27
      Caption = 'Clientes'
      TabOrder = 0
      OnClick = btnMenuClientesClick
    end
    object btnMenuProdutos: TButton
      Left = 126
      Top = 7
      Width = 110
      Height = 27
      Caption = 'Produtos'
      TabOrder = 1
      OnClick = btnMenuProdutosClick
    end
    object btnMenuPedidos: TButton
      Left = 244
      Top = 7
      Width = 110
      Height = 27
      Caption = 'Pedidos'
      TabOrder = 2
      OnClick = btnMenuPedidosClick
    end
  end
  object pnlFiltro: TPanel
    Left = 0
    Top = 50
    Width = 800
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblBusca: TLabel
      Left = 8
      Top = 13
      Width = 38
      Height = 15
      Caption = 'Buscar:'
    end
    object edtFiltro: TEdit
      Left = 56
      Top = 9
      Width = 300
      Height = 23
      TabOrder = 0
    end
    object btnBuscar: TButton
      Left = 364
      Top = 8
      Width = 80
      Height = 25
      Caption = 'Buscar'
      TabOrder = 1
      OnClick = btnBuscarClick
    end
  end
  object sbStatus: TStatusBar
    Left = 0
    Top = 541
    Width = 800
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = ' Pronto'
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 498
    Width = 800
    Height = 43
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnNovo: TButton
      Left = 12
      Top = 6
      Width = 90
      Height = 27
      Caption = 'Novo'
      TabOrder = 0
      OnClick = btnNovoClick
    end
    object btnEditar: TButton
      Left = 108
      Top = 10
      Width = 90
      Height = 27
      Caption = 'Editar'
      TabOrder = 1
      OnClick = btnEditarClick
    end
    object btnExcluir: TButton
      Left = 204
      Top = 8
      Width = 90
      Height = 27
      Caption = 'Excluir'
      TabOrder = 2
      OnClick = btnExcluirClick
    end
    object btnAtualizar: TButton
      Left = 302
      Top = 8
      Width = 90
      Height = 27
      Caption = 'Atualizar'
      TabOrder = 3
      OnClick = btnAtualizarClick
    end
  end
  object dbgClientes: TDBGrid
    Left = 0
    Top = 90
    Width = 800
    Height = 408
    Align = alClient
    DataSource = DM.dsClientes
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = dbgClientesDblClick
  end
end
