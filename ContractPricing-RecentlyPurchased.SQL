Select
    BASE_PricingScheme.Name As PricingScheme,
    BASE_ItemPrice.PricingSchemeId As ID,
    BASE_Product.Name,
    BASE_Product.Description,
    CACHE_SummaryCost.SummaryCost As UnitCost,
    Case
        When BASE_Product_TaxCode.TaxCodeId = '103'
        Then (BASE_ItemPrice.UnitPrice / BASE_Product.SoUomRatioStd)
        When BASE_Product_TaxCode.TaxCodeId = '102'
        Then ((BASE_ItemPrice.UnitPrice / BASE_Product.SoUomRatioStd) / 11) * 10
    End As UnitPriceExcl,
    Case
        When BASE_Product_TaxCode.TaxCodeId = '103'
        Then BASE_ItemPrice.UnitPrice
        When BASE_Product_TaxCode.TaxCodeId = '102'
        Then (BASE_ItemPrice.UnitPrice / 11) * 10
    End As CasePriceExcl,
    BASE_Product.SoUomRatioStd As PkSz
From
    BASE_Customer Inner Join
    BASE_PricingScheme On BASE_Customer.DefaultPricingSchemeId = BASE_PricingScheme.PricingSchemeId Inner Join
    BASE_ItemPrice On BASE_ItemPrice.PricingSchemeId = BASE_PricingScheme.PricingSchemeId Inner Join
    BASE_Product On BASE_ItemPrice.ProdId = BASE_Product.ProdId Inner Join
    CACHE_SummaryCost On CACHE_SummaryCost.ProdId = BASE_Product.ProdId Inner Join
    BASE_Product_TaxCode On BASE_Product_TaxCode.ProdId = BASE_Product.ProdId
Where
    BASE_Customer.Name = :customername And
    BASE_ItemPrice.UnitPrice > 0 And
    BASE_Product.Name In (Select
                            BASE_Product.Name
                            From
                                BASE_Product Inner Join
                                SO_SalesOrder_Line On SO_SalesOrder_Line.ProdId = BASE_Product.ProdId Inner Join
                                SO_SalesOrder On SO_SalesOrder_Line.SalesOrderId = SO_SalesOrder.SalesOrderId Inner Join
                                BASE_Customer On SO_SalesOrder.CustomerId = BASE_Customer.CustomerId
                            Where
                                BASE_Customer.Name = :customername And
                                SO_SalesOrder.OrderDate > DateAdd(m, -4, GetDate()))