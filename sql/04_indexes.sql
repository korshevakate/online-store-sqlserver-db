USE online_store;
GO

CREATE INDEX IX_Products_Category
ON Products(category_id);

CREATE INDEX IX_Customers_Email
ON Customers(email);

CREATE INDEX IX_Orders_CustomerID
ON Orders(customer_id);

CREATE INDEX IX_OrderItems_ProductID
ON OrderItems(product_id);

CREATE INDEX IX_CartItems_Cart_Product
ON CartItems(cart_id, product_id);
GO
