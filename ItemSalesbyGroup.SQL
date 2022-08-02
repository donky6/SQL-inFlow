Select distinct
    BASE_Customer.Name,
    BASE_Product.Name As ProdCode,
    SO_SalesOrder_Line.Description
From
    BASE_Customer Inner Join
    BASE_PricingScheme On BASE_Customer.DefaultPricingSchemeId = BASE_PricingScheme.PricingSchemeId Inner Join
    SO_SalesOrder On SO_SalesOrder.CustomerId = BASE_Customer.CustomerId
            And SO_SalesOrder.PricingSchemeId = BASE_PricingScheme.PricingSchemeId Inner Join
    SO_SalesOrder_Line On SO_SalesOrder_Line.SalesOrderId = SO_SalesOrder.SalesOrderId Inner Join
    BASE_Product On SO_SalesOrder_Line.ProdId = BASE_Product.ProdId
where
  BASE_PricingScheme.Name = :pricingscheme and SO_SalesOrder.orderdate > '20220101'