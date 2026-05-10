object frmCadastro: TfrmCadastro
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cadastro de Cliente'
  ClientHeight = 360
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
  object lblNome: TLabel
    Left = 16
    Top = 62
    Width = 41
    Height = 15
    Caption = 'Nome *'
  end
  object lblCPF: TLabel
    Left = 16
    Top = 112
    Width = 29
    Height = 15
    Caption = 'CPF *'
  end
  object lblEmail: TLabel
    Left = 16
    Top = 162
    Width = 34
    Height = 15
    Caption = 'E-mail'
  end
  object lblTelefone: TLabel
    Left = 16
    Top = 212
    Width = 45
    Height = 15
    Caption = 'Telefone'
  end
  object pnlTopo: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    Color = clNavy
    ParentBackground = False
    TabOrder = 0
    object lblTitulo: TLabel
      Left = 0
      Top = 0
      Width = 400
      Height = 45
      Align = alClient
      Alignment = taCenter
      Caption = 'Cadastro de Cliente'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 135
      ExplicitHeight = 20
    end
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 318
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
    end
  end
  object edtNome: TEdit
    Left = 16
    Top = 80
    Width = 368
    Height = 23
    TabOrder = 2
  end
  object edtCPF: TEdit
    Left = 16
    Top = 130
    Width = 180
    Height = 23
    TabOrder = 3
  end
  object edtEmail: TEdit
    Left = 16
    Top = 180
    Width = 368
    Height = 23
    TabOrder = 4
  end
  object edtTelefone: TEdit
    Left = 16
    Top = 230
    Width = 180
    Height = 23
    TabOrder = 5
  end
  object chkAtivo: TCheckBox
    Left = 16
    Top = 270
    Width = 120
    Height = 17
    Caption = 'Cliente Ativo'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
end
