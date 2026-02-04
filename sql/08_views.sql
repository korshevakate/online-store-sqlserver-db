-- View 1: Информация о заказах клиентов

CREATE OR ALTER VIEW vw_CustomerOrders
AS
SELECT
    o.order_id,
    o.order_date,
    o.status,
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;
GO

--   View 2: Детали заказов (товары + сумма)

CREATE OR ALTER VIEW vw_OrderDetails
AS
SELECT
    o.order_id,
    p.product_id,
    p.product_name,
    oi.quantity,
    oi.price,
    (oi.quantity * oi.price) AS total_price
FROM OrderItems oi
JOIN Orders o ON oi.order_id = o.order_id
JOIN Products p ON oi.product_id = p.product_id;
GO

--   View 3: Остатки товаров по категориям

CREATE OR ALTER VIEW vw_ProductStock
AS
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.stock_quantity,
    p.price
FROM Products p
JOIN Categories c ON p.category_id = c.category_id;
GO
