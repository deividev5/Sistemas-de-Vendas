object frmPedidos: TfrmPedidos
  Left = 0
  Top = 0
  Caption = 'Pedidos'
  ClientHeight = 560
  ClientWidth = 900
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
    Width = 900
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = clMaroon
    ParentBackground = False
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 0
      Top = 0
      Width = 900
      Height = 50
      Align = alClient
      Alignment = taCenter
      Caption = 'Pedidos'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 70
      ExplicitHeight = 25
    end
  end
  object pnlFiltro: TPanel
    Left = 0
    Top = 50
    Width = 900
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblBusca: TLabel
      Left = 8
      Top = 13
      Width = 40
      Height = 15
      Caption = 'Cliente:'
    end
    object edtFiltro: TEdit
      Left = 62
      Top = 9
      Width = 300
      Height = 23
      TabOrder = 0
      OnKeyPress = edtFiltroKeyPress
    end
    object btnBuscar: TButton
      Left = 370
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
    Width = 900
    Height = 19
    Panels = <>
    SimplePanel = True
    SimpleText = ' Pronto'
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 498
    Width = 900
    Height = 43
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object btnNovo: TButton
      Left = 8
      Top = 8
      Width = 100
      Height = 27
      Caption = 'Novo Pedido'
      TabOrder = 0
      OnClick = btnNovoClick
    end
    object btnVisualizar: TButton
      Left = 116
      Top = 8
      Width = 100
      Height = 27
      Caption = 'Visualizar'
      TabOrder = 1
      OnClick = btnVisualizarClick
    end
    object btnCancelarPedido: TButton
      Left = 224
      Top = 8
      Width = 100
      Height = 27
      Caption = 'Cancelar Pedido'
      TabOrder = 2
      OnClick = btnCancelarPedidoClick
    end
    object btnAtualizar: TButton
      Left = 332
      Top = 8
      Width = 90
      Height = 27
      Caption = 'Atualizar'
      TabOrder = 3
      OnClick = btnAtualizarClick
    end
  end
  object dbgPedidos: TDBGrid
    Left = 0
    Top = 90
    Width = 900
    Height = 408
    Align = alClient
    DataSource = DM.dsPedidos
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnDblClick = dbgPedidosDblClick
  end
end
