select 
  a.Name,
  sum(a.unitprice) as Sell,
  sum(a.unitcost) as Cost,
  ((sum(a.unitprice) - sum(a.unitcost)) / sum(a.unitprice)) as Margin,
  (((sum(a.unitprice) - sum(a.unitcost)) / sum(a.unitprice)) * sum(a.unitprice)) as MarginDollar
from
(Select
    SO_SalesOrder.OrderNumber,
    BASE_Customer.Name,
    BASE_Product.Name as ProdCode,
    SO_SalesOrder_Line.Description,
    SO_SalesOrder.OrderDate,
    (SO_SalesOrder_Line.SubTotal / SO_SalesOrder_Line.Quantity) * SO_SalesOrder_Line.Quantity As unitprice,
    ((CACHE_SummaryCost.SummaryCost * 1.1) * SO_SalesOrder_Line.Quantity) as unitcost
From
    BASE_Customer Inner Join
    SO_SalesOrder On SO_SalesOrder.CustomerId = BASE_Customer.CustomerId Inner Join
    SO_SalesOrder_Line On SO_SalesOrder_Line.SalesOrderId = SO_SalesOrder.SalesOrderId Inner Join
    BASE_Product On SO_SalesOrder_Line.ProdId = BASE_Product.ProdId Inner Join
    CACHE_SummaryCost On CACHE_SummaryCost.ProdId = BASE_Product.ProdId
Where
    SO_SalesOrder_Line.TaxCodeId = '102' and SO_SalesOrder.OrderDate >= dateadd(d,-1,getdate()) 
    
Union All

Select
    SO_SalesOrder.OrderNumber,
    BASE_Customer.Name,
    BASE_Product.Name as ProdCode,
    SO_SalesOrder_Line.Description,
    SO_SalesOrder.OrderDate,
    (SO_SalesOrder_Line.SubTotal / SO_SalesOrder_Line.Quantity) * SO_SalesOrder_Line.Quantity As unitprice,
    (CACHE_SummaryCost.SummaryCost * SO_SalesOrder_Line.Quantity) as unitcost
From
    BASE_Customer Inner Join
    SO_SalesOrder On SO_SalesOrder.CustomerId = BASE_Customer.CustomerId Inner Join
    SO_SalesOrder_Line On SO_SalesOrder_Line.SalesOrderId = SO_SalesOrder.SalesOrderId Inner Join
    BASE_Product On SO_SalesOrder_Line.ProdId = BASE_Product.ProdId Inner Join
    CACHE_SummaryCost On CACHE_SummaryCost.ProdId = BASE_Product.ProdId
Where
    SO_SalesOrder_Line.TaxCodeId = '103' and SO_SalesOrder.OrderDate >= dateadd(d,-1,getdate()) 
) a 
group by 
  a.name 