Select
    BASE_Product.Name,
    BASE_Product.Description,
    Floor(Sum(SO_SalesOrder_Line.Quantity) / BASE_Product.SoUomRatioStd) As ttlcase,
    (Sum(SO_SalesOrder_Line.Quantity) % BASE_Product.SoUomRatioStd) As ttlunits
From
    BASE_Product Inner Join
    SO_SalesOrder_Line On SO_SalesOrder_Line.ProdId = BASE_Product.ProdId Inner Join
    SO_SalesOrder On SO_SalesOrder_Line.SalesOrderId = SO_SalesOrder.SalesOrderId Inner Join
    BASE_Customer On SO_SalesOrder.CustomerId = BASE_Customer.CustomerId
Where
    SO_SalesOrder.OrderDate > DateAdd(wk, -12, GetDate()) And
    BASE_Customer.Name = :customername
Group By
    BASE_Product.Name,
    BASE_Product.Description,
    BASE_Product.SoUomRatioStd