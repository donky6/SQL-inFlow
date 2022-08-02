Select
    SO_SalesOrder.OrderNumber as RefNumber,
    BASE_Customer.Name as Customer,
    FORMAT (SO_SalesOrder.OrderDate, 'dd/MM/yyyy') as TxnDate,
    sum((SO_SalesOrder_Line.SubTotal)/11) * 10 as LineUnitPrice,
    'SG' as LineItem,
    'GST' as LineTaxCode,
    '1' as LineQty,
    BASE_Customer.Custom4 as LineClass,
    'n' as AmountsInclTax
From
    BASE_Customer Inner Join
    SO_SalesOrder On SO_SalesOrder.CustomerId = BASE_Customer.CustomerId Inner Join
    SO_SalesOrder_Line On SO_SalesOrder_Line.SalesOrderId = SO_SalesOrder.SalesOrderId
Where
    SO_SalesOrder.IsInvoiced = '1' and SO_SalesOrder.IsCancelled = '0' and SO_SalesOrder_Line.TaxCodeId = '102' and SO_SalesOrder.OrderDate >= dateadd(d,-7,getdate())
Group By
    SO_SalesOrder.OrderNumber,
    BASE_Customer.Name,
    SO_SalesOrder.OrderDate,
    BASE_Customer.Custom4
    
Union All

Select
    SO_SalesOrder.OrderNumber as RefNumber,
    BASE_Customer.Name as Customer,
    FORMAT (SO_SalesOrder.OrderDate, 'dd/MM/yyyy') as TxnDate,
    sum(SO_SalesOrder_Line.SubTotal) as LineUnitPrice,
    'SF' as LineItem,
    'GST free' as LineTaxCode,
    '1' as LineQty,
    BASE_Customer.Custom4 as LineClass,
    'n' as AmountsInclTax
From
    BASE_Customer Inner Join
    SO_SalesOrder On SO_SalesOrder.CustomerId = BASE_Customer.CustomerId Inner Join
    SO_SalesOrder_Line On SO_SalesOrder_Line.SalesOrderId = SO_SalesOrder.SalesOrderId
Where
    SO_SalesOrder.IsInvoiced = '1' and SO_SalesOrder.IsCancelled = '0' and SO_SalesOrder_Line.TaxCodeId = '103' and SO_SalesOrder.OrderDate >= dateadd(d,-7,getdate())
Group By
    SO_SalesOrder.OrderNumber,
    BASE_Customer.Name,
    SO_SalesOrder.OrderDate,
    BASE_Customer.Custom4

Union All
    
Select
    SO_SalesOrder.OrderNumber as RefNumber,
    BASE_Customer.Name as Customer,
    FORMAT (SO_SalesOrder.OrderDate, 'dd/MM/yyyy') as TxnDate,
    (SO_SalesOrder.OrderExtra / 11) * 10 as LineUnitPrice,
    'Freight' as LineItem,
    'GST' as LineTaxCode,
    '1' as LineQty,
    BASE_Customer.Custom4 as LineClass,
    'n' as AmountsInclTax
From
    BASE_Customer Inner Join
    SO_SalesOrder On SO_SalesOrder.CustomerId = BASE_Customer.CustomerId Inner Join
    SO_SalesOrder_Line On SO_SalesOrder_Line.SalesOrderId = SO_SalesOrder.SalesOrderId
Where
    SO_SalesOrder.IsInvoiced = '1' and SO_SalesOrder.IsCancelled = '0' and SO_SalesOrder.OrderExtra > '0'  and SO_SalesOrder.OrderDate >= dateadd(d,-7,getdate())
Group By
    SO_SalesOrder.OrderNumber,
    BASE_Customer.Name,
    SO_SalesOrder.OrderDate,
    BASE_Customer.Custom4,
    SO_SalesOrder.OrderExtra
    
Order by
    SO_SalesOrder.OrderNumber