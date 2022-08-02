Select
    BASE_Product.Name,
    PO_PurchaseOrder_Line.Description,
    Sum(PO_PurchaseOrder_Line.Quantity) As QTY,
    BASE_Product.SoUomRatioStd As PkSize,
    Floor(Sum(PO_PurchaseOrder_Line.Quantity) / BASE_Product.SoUomRatioStd) As Cases,
    (Sum(PO_PurchaseOrder_Line.Quantity) % BASE_Product.SoUomRatioStd) As units
From
    PO_PurchaseOrder Inner Join
    PO_PurchaseOrder_Line On PO_PurchaseOrder_Line.PurchaseOrderId = PO_PurchaseOrder.PurchaseOrderId Inner Join
    BASE_Product On PO_PurchaseOrder_Line.ProdId = BASE_Product.ProdId Inner Join
    BASE_Vendor On PO_PurchaseOrder.VendorId = BASE_Vendor.VendorId
            And BASE_Product.LastVendorId = BASE_Vendor.VendorId Inner Join
    CACHE_SummaryCost On CACHE_SummaryCost.ProdId = BASE_Product.ProdId
Where
    BASE_Vendor.Name = :vendorname And
    PO_PurchaseOrder.OrderDate > DateAdd(wk, -26, GetDate())
Group By
    BASE_Product.Name,
    PO_PurchaseOrder_Line.Description,
    BASE_Product.SoUomRatioStd