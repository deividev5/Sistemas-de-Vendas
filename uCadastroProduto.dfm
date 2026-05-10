object frmCadastroProduto: TfrmCadastroProduto
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cadastro de Produto'
  ClientHeight = 310
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object lblDescricao: TLabel
    Left = 16
    Top = 58
    Width = 59
    Height = 15
    Caption = 'Descri'#231#227'o *'
  end
  object lblPreco: TLabel
    Left = 16
    Top = 108
    Width = 54
    Height = 15
    Caption = 'Pre'#231'o R$ *'
  end
  object lblEstoque: TLabel
    Left = 16
    Top = 158
    Width = 42
    Height = 15
    Caption = 'Estoque'
  end
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    Color = clGreen
    ParentBackground = False
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 0
      Top = 0
      Width = 400
      Height = 45
      Align = alClient
      Alignment = taCenter
      Caption = 'Cadastro de Produto'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 144
      ExplicitHeight = 20
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 268
    Width = 400
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnSalvar: TButton
      Left = 210
      Top = 8
      Width = 85
      Height = 27
      Caption = 'Salvar'
      TabOrder = 0
      OnClick = btnSalvarClick
    end
    object btnCancelar: TButton
      Left = 304
      Top = 8
      Width = 85
      Height = 27
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 1
      OnClick = btnCancelarClick
    end
  end
  object edtDescricao: TEdit
    Left = 16
    Top = 76
    Width = 368
    Height = 23
    TabOrder = 2
  end
  object edtPreco: TEdit
    Left = 16
    Top = 126
    Width = 150
    Height = 23
    TabOrder = 3
    Text = '0,00'
  end
  object edtEstoque: TEdit
    Left = 16
    Top = 176
    Width = 100
    Height = 23
    TabOrder = 4
    Text = '0'
  end
  object chkAtivo: TCheckBox
    Left = 16
    Top = 220
    Width = 120
    Height = 17
    Caption = 'Produto Ativo'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
end
