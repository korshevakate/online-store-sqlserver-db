USE online_store;
GO

CREATE INDEX IX_Products_Category
ON Products(category_id);

CREATE INDEX IX_Customers_Email
ON Customers(email);
