object DM: TDM
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object OraSession: TOraSession
    Left = 32
    Top = 56
  end
  object qryClientes: TOraQuery
    Session = OraSession
    Left = 32
    Top = 144
  end
  object dsClientes: TOraDataSource
    DataSet = qryClientes
    Left = 32
    Top = 232
  end
  object qryProdutos: TOraQuery
    Session = OraSession
    Left = 180
    Top = 144
  end
  object dsProdutos: TOraDataSource
    DataSet = qryProdutos
    Left = 180
    Top = 232
  end
  object qryPedidos: TOraQuery
    Session = OraSession
    Left = 320
    Top = 144
  end
  object dsPedidos: TOraDataSource
    DataSet = qryPedidos
    Left = 320
    Top = 232
  end
  object qryItens: TOraQuery
    Session = OraSession
    SQL.Strings = (
      'SELECT I.ID_ITEM        AS "C'#243'd.",'
      '       P.DS_DESCRICAO   AS "Produto",'
      '       I.NR_QUANTIDADE  AS "Qtde",'
      '       I.VL_UNITARIO    AS "Vl. Unit.",'
      '       I.VL_TOTAL       AS "Total"'
      '  FROM TB_ITEM_PEDIDO I'
      ' INNER JOIN TB_PRODUTO P ON P.ID_PRODUTO = I.ID_PRODUTO'
      ' WHERE I.ID_PEDIDO = :p_id_pedido'
      ' ORDER BY I.ID_ITEM')
    Left = 460
    Top = 144
    ParamData = <
      item
        DataType = ftInteger
        Name = 'p_id_pedido'
        ParamType = ptInput
        Value = nil
      end>
  end
  object dsItens: TOraDataSource
    DataSet = qryItens
    Left = 460
    Top = 232
  end
end
