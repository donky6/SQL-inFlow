Select
    BASE_Product.Name,
    BASE_Product.Description,
    (BASE_ItemPrice.UnitPrice / BASE_Product.SoUomRatioStd) As unitprice,
    CASE
      WHEN SO_SalesOrder_Line.TaxCodeId = '102'
        THEN (CACHE_SummaryCost.SummaryCost * 1.1)
      ELSE CACHE_SummaryCost.SummaryCost
      END as avgcost,        
    Floor(Sum(SO_SalesOrder_Line.Quantity) / BASE_Product.SoUomRatioStd) As ttlcase,
    (Sum(SO_SalesOrder_Line.Quantity) % BASE_Product.SoUomRatioStd) As ttlunits,
    BASE_PricingScheme.Name As PricingName
From
    SO_SalesOrder Inner Join
    SO_SalesOrder_Line On SO_SalesOrder_Line.SalesOrderId = SO_SalesOrder.SalesOrderId Inner Join
    BASE_Customer On SO_SalesOrder.CustomerId = BASE_Customer.CustomerId Inner Join
    BASE_Product On SO_SalesOrder_Line.ProdId = BASE_Product.ProdId Inner Join
    CACHE_SummaryCost On CACHE_SummaryCost.ProdId = BASE_Product.ProdId Inner Join
    BASE_ItemPrice On BASE_ItemPrice.ProdId = BASE_Product.ProdId
            And BASE_ItemPrice.PricingSchemeId = BASE_Customer.DefaultPricingSchemeId Inner Join
    BASE_PricingScheme On SO_SalesOrder.PricingSchemeId = BASE_PricingScheme.PricingSchemeId
            And BASE_Customer.DefaultPricingSchemeId = BASE_PricingScheme.PricingSchemeId
            And BASE_ItemPrice.PricingSchemeId = BASE_PricingScheme.PricingSchemeId
Where
    BASE_Customer.DefaultCarrier = :customergroup And
    SO_SalesOrder.OrderDate > DateAdd(wk, -6, GetDate())
Group By
    BASE_Product.Name,
    BASE_Product.Description,
    CACHE_SummaryCost.SummaryCost,
    BASE_ItemPrice.UnitPrice,
    BASE_Product.SoUomRatioStd,
    BASE_PricingScheme.Name,
    SO_SalesOrder_Line.TaxCodeId
Order By
    ttlcase Desc,
    ttlunits Desc