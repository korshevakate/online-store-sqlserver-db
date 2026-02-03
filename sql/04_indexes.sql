USE online_store;
GO

/* 
Индекс 1
Ускоряет поиск товаров по категории
(часто используется в фильтрации)
*/
CREATE INDEX IX_Products_CategoryID
ON Products(category_id);
GO

/*
Индекс 2
Ускоряет поиск клиента по email
(важно для логина и проверок)
*/
CREATE INDEX IX_Customers_Email
ON Customers(email);
GO

/*
Индекс 3
Ускоряет выборку заказов конкретного клиента
*/
CREATE INDEX IX_Orders_CustomerID
ON Orders(customer_id);
GO

/*
Индекс 4
Ускоряет поиск товаров в заказе
(часто используется в JOIN)
*/
CREATE INDEX IX_OrderItems_ProductID
ON OrderItems(product_id);
GO

/*
Индекс 5
Составной индекс
Ускоряет выборку товаров внутри одного заказа
*/
CREATE INDEX IX_OrderItems_Order_Product
ON OrderItems(order_id, product_id);
GO

