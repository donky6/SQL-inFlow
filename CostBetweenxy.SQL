Select
    BASE_Product.Name,
    BASE_Product.Description,
    CACHE_SummaryCost.SummaryCost
From
    BASE_Product Inner Join
    CACHE_SummaryCost On CACHE_SummaryCost.ProdId = BASE_Product.ProdId
Where
    CACHE_SummaryCost.SummaryCost Between :abc And :def