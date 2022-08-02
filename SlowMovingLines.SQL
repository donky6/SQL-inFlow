Select
    VIEW_CurrentStock.ProdId,
    VIEW_CurrentStock.ItemName,
    VIEW_CurrentStock.ItemDescription,
    VIEW_CurrentStock.Quantity
From
    VIEW_CurrentStock
Where
    VIEW_CurrentStock.Quantity <> 0 AND
    VIEW_CurrentStock.ProdId NOT In (Select
         BASE_Product.ProdId
     From
         BASE_Product Inner Join
         SO_SalesOrder_Line On SO_SalesOrder_Line.ProdId = BASE_Product.ProdId Inner Join
         SO_SalesOrder On SO_SalesOrder_Line.SalesOrderId = SO_SalesOrder.SalesOrderId
     Where
         SO_SalesOrder.OrderDate > DateAdd(wk, -15, GetDate()))