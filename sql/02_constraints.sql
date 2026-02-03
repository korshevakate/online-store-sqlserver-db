USE online_store;
GO

ALTER TABLE OrderItems
ADD CONSTRAINT CHK_OrderItems_Quantity
CHECK (quantity > 0);

ALTER TABLE CartItems
ADD CONSTRAINT CHK_CartItems_Quantity
CHECK (quantity > 0);

ALTER TABLE Orders
ADD CONSTRAINT CHK_Orders_Status
CHECK (status IN ('Pending','Processing','Shipped','Delivered','Cancelled'));
GO
