Select
    BASE_Product.Name,
    BASE_Product.Description,
    Floor(Sum(SO_SalesOrder_Line.Quantity) / BASE_Product.SoUomRatioStd) As ttlcase,
    (Sum(SO_SalesOrder_Line.Quantity) % BASE_Product.SoUomRatioStd) As ttlunits,
    VIEW_CurrentStock.Quantity,
    Floor(VIEW_CurrentStock.Quantity / BASE_Product.SoUomRatioStd) As SOHCases,
    (VIEW_CurrentStock.Quantity % BASE_Product.SoUomRatioStd) As SOHunits
From
    BASE_Product Inner Join
    SO_SalesOrder_Line On SO_SalesOrder_Line.ProdId = BASE_Product.ProdId Inner Join
    SO_SalesOrder On SO_SalesOrder_Line.SalesOrderId = SO_SalesOrder.SalesOrderId Inner Join
    VIEW_CurrentStock On BASE_Product.ProdId = VIEW_CurrentStock.ProdId
Where
    SO_SalesOrder.OrderDate > DateAdd(wk, -8, GetDate()) And
    (BASE_Product.Description like 'COTT CORD%')
/*Replace BASE_Product.Description with BASE_Product.Name for searching by product code*/
Group By
    BASE_Product.Name,
    BASE_Product.Description,
    VIEW_CurrentStock.Quantity,
    BASE_Product.SoUomRatioStd