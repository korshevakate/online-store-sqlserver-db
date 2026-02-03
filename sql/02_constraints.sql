USE online_store;
GO

-- Пример дополнительных ограничений
-- Например, нельзя заказать отрицательное количество
ALTER TABLE OrderItems
ADD CONSTRAINT CHK_OrderItems_Quantity
CHECK (quantity > 0);

ALTER TABLE CartItems
ADD CONSTRAINT CHK_CartItems_Quantity
CHECK (quantity > 0);

-- Статус заказа должен быть корректным
ALTER TABLE Orders
ADD CONSTRAINT CHK_Orders_Status
CHECK (status IN ('Pending','Processing','Shipped','Delivered','Cancelled'));
GO
