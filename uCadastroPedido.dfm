object frmCadastroPedido: TfrmCadastroPedido
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cadastro de Pedido'
  ClientHeight = 580
  ClientWidth = 750
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 750
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    Color = clMaroon
    ParentBackground = False
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 0
      Top = 0
      Width = 135
      Height = 20
      Align = alClient
      Alignment = taCenter
      Caption = 'Cadastro de Pedido'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 538
    Width = 750
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnSalvar: TButton
      Left = 560
      Top = 8
      Width = 85
      Height = 27
      Caption = 'Salvar'
      TabOrder = 0
      OnClick = btnSalvarClick
    end
    object btnCancelar: TButton
      Left = 654
      Top = 8
      Width = 85
      Height = 27
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelarClick
    end
  end
  object pnlCabecalho: TPanel
    Left = 0
    Top = 45
    Width = 750
    Height = 95
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object lblCliente: TLabel
      Left = 8
      Top = 8
      Width = 40
      Height = 15
      Caption = 'Cliente:'
    end
    object lblStatus: TLabel
      Left = 530
      Top = 8
      Width = 35
      Height = 15
      Caption = 'Status:'
    end
    object lblTotal: TLabel
      Left = 8
      Top = 60
      Width = 45
      Height = 15
      Caption = 'Total R$:'
    end
    object edtIdCliente: TEdit
      Left = 8
      Top = 26
      Width = 60
      Height = 23
      TabOrder = 0
    end
    object edtNomeCliente: TEdit
      Left = 76
      Top = 26
      Width = 350
      Height = 23
      ReadOnly = True
      TabOrder = 1
    end
    object btnBuscarCliente: TButton
      Left = 434
      Top = 25
      Width = 80
      Height = 25
      Caption = 'Buscar'
      TabOrder = 2
      OnClick = btnBuscarClienteClick
    end
    object cboStatus: TComboBox
      Left = 530
      Top = 26
      Width = 140
      Height = 23
      Style = csDropDownList
      TabOrder = 3
      Items.Strings = (
        'ABERTO'
        'FATURADO'
        'CANCELADO')
    end
    object edtTotal: TEdit
      Left = 8
      Top = 75
      Width = 130
      Height = 23
      ReadOnly = True
      TabOrder = 4
      Text = '0,00'
    end
  end
  object pnlItem: TPanel
    Left = 0
    Top = 140
    Width = 750
    Height = 55
    Align = alTop
    BevelOuter = bvLowered
    TabOrder = 3
    object lblProduto: TLabel
      Left = 8
      Top = 6
      Width = 46
      Height = 15
      Caption = 'Produto:'
    end
    object lblQtde: TLabel
      Left = 408
      Top = 6
      Width = 29
      Height = 15
      Caption = 'Qtde:'
    end
    object lblVlUnit: TLabel
      Left = 476
      Top = 6
      Width = 41
      Height = 15
      Caption = 'Vl. Unit:'
    end
    object edtIdProduto: TEdit
      Left = 8
      Top = 23
      Width = 55
      Height = 23
      TabOrder = 0
    end
    object edtNomeProduto: TEdit
      Left = 71
      Top = 23
      Width = 250
      Height = 23
      ReadOnly = True
      TabOrder = 1
    end
    object btnBuscarProduto: TButton
      Left = 329
      Top = 22
      Width = 70
      Height = 25
      Caption = 'Buscar'
      TabOrder = 2
      OnClick = btnBuscarProdutoClick
    end
    object edtQuantidade: TEdit
      Left = 408
      Top = 23
      Width = 60
      Height = 23
      TabOrder = 3
      Text = '1'
    end
    object edtVlUnitario: TEdit
      Left = 476
      Top = 23
      Width = 90
      Height = 23
      ReadOnly = True
      TabOrder = 4
      Text = '0,00'
    end
    object btnAdicionarItem: TButton
      Left = 574
      Top = 22
      Width = 80
      Height = 25
      Caption = '+ Adicionar'
      TabOrder = 5
      OnClick = btnAdicionarItemClick
    end
    object btnRemoverItem: TButton
      Left = 662
      Top = 22
      Width = 80
      Height = 25
      Caption = '- Remover'
      TabOrder = 6
      OnClick = btnRemoverItemClick
    end
  end
  object dbgItens: TDBGrid
    Left = 0
    Top = 195
    Width = 750
    Height = 343
    Align = alClient
    DataSource = DM.dsItens
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
end
