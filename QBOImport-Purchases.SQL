Select
    Case
      When BASE_Vendor.Name = 'COLES' then PO_PurchaseOrder.OrderNumber
      When BASE_Vendor.Name = 'WOOLWORTHS' then PO_PurchaseOrder.OrderNumber
      Else PO_PurchaseOrder.custom1
    End as RefNumber,
    BASE_Vendor.Name as Vendor,
    PO_PurchaseOrder.OrderDate as TxnDate,
    sum((PO_PurchaseOrder_Line.SubTotal)/11) * 10 as ExpenseAmount,
    'Purchases - GST' as ExpenseAccount,
    'GST on non-capital' as ExpenseTaxCode,
    'Hospitality' as ExpenseClass,
    'n' as AmountsInclTax
From
    BASE_Vendor Inner Join
    PO_PurchaseOrder On PO_PurchaseOrder.VendorId = BASE_Vendor.VendorId Inner Join
    PO_PurchaseOrder_Line On PO_PurchaseOrder_Line.PurchaseOrderId = PO_PurchaseOrder.PurchaseOrderId
where
    PO_PurchaseOrder.IsCompleted = '1' and PO_PurchaseOrder.IsCancelled = '0' and PO_PurchaseOrder_Line.TaxCodeId = '102' and PO_PurchaseOrder.OrderDate >= dateadd(d,-1,getdate())
Group By
    PO_PurchaseOrder.OrderNumber,
    BASE_Vendor.Name,
    PO_PurchaseOrder.OrderDate,
    PO_PurchaseOrder.custom1
    
Union all

Select
    Case
      When BASE_Vendor.Name = 'COLES' then PO_PurchaseOrder.OrderNumber
      When BASE_Vendor.Name = 'WOOLWORTHS' then PO_PurchaseOrder.OrderNumber
      Else PO_PurchaseOrder.custom1
    End as RefNumber,
    BASE_Vendor.Name as Vendor,
    PO_PurchaseOrder.OrderDate as TxnDate,
    sum(PO_PurchaseOrder_Line.SubTotal) as ExpenseAmount,
    'Purchases - GST Free' as ExpenseAccount,
    'GST-free non-capital' as ExpenseTaxCode,
    'Hospitality' as ExpenseClass,
    'n' as AmountsInclTax
From
    BASE_Vendor Inner Join
    PO_PurchaseOrder On PO_PurchaseOrder.VendorId = BASE_Vendor.VendorId Inner Join
    PO_PurchaseOrder_Line On PO_PurchaseOrder_Line.PurchaseOrderId = PO_PurchaseOrder.PurchaseOrderId
where
    PO_PurchaseOrder.IsCompleted = '1' and PO_PurchaseOrder.IsCancelled = '0' and PO_PurchaseOrder_Line.TaxCodeId = '103' and PO_PurchaseOrder.OrderDate >= dateadd(d,-1,getdate())
Group By
    PO_PurchaseOrder.OrderNumber,
    BASE_Vendor.Name,
    PO_PurchaseOrder.OrderDate,
    PO_PurchaseOrder.custom1
    
Union all

Select
    Case
      When BASE_Vendor.Name = 'COLES' then PO_PurchaseOrder.OrderNumber
      When BASE_Vendor.Name = 'WOOLWORTHS' then PO_PurchaseOrder.OrderNumber
      Else PO_PurchaseOrder.custom1
    End as RefNumber,
    BASE_Vendor.Name as Vendor,
    PO_PurchaseOrder.OrderDate as TxnDate,
    (PO_PurchaseOrder.OrderExtra/11) * 10 as ExpenseAmount,
    'Freight' as ExpenseAccount,
    'GST on non-capital' as ExpenseTaxCode,
    'Hospitality' as ExpenseClass,
    'n' as AmountsInclTax
From
    BASE_Vendor Inner Join
    PO_PurchaseOrder On PO_PurchaseOrder.VendorId = BASE_Vendor.VendorId Inner Join
    PO_PurchaseOrder_Line On PO_PurchaseOrder_Line.PurchaseOrderId = PO_PurchaseOrder.PurchaseOrderId
where
    PO_PurchaseOrder.IsCompleted = '1' and PO_PurchaseOrder.IsCancelled = '0' and PO_PurchaseOrder.OrderExtra > 0 and PO_PurchaseOrder.OrderDate >= dateadd(d,-1,getdate())
Group By
    PO_PurchaseOrder.OrderNumber,
    BASE_Vendor.Name,
    PO_PurchaseOrder.OrderDate,
    PO_PurchaseOrder.OrderExtra,
    PO_PurchaseOrder.custom1

Order by
  RefNumber