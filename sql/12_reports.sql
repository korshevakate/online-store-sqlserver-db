-- REPORT 1   Продажи и активность клиентов

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT o.order_id) AS orders_count,
    SUM(oi.quantity * oi.price) AS total_spent
FROM Customers c
JOIN Orders o
    ON o.customer_id = c.customer_id
JOIN OrderItems oi
    ON oi.order_id = o.order_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC;
GO


-- REPORT 2   Заказы по статусам и сумме

SELECT
    ISNULL(o.status, 'UNKNOWN') AS order_status,
    COUNT(DISTINCT o.order_id) AS orders_count,
    SUM(oi.quantity * oi.price) AS total_amount
FROM Orders o
JOIN OrderItems oi
    ON oi.order_id = o.order_id
GROUP BY ISNULL(o.status, 'UNKNOWN')
ORDER BY orders_count DESC;
GO

-- REPORT 3    Самые продаваемые товары

SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.price) AS total_revenue
FROM Products p
JOIN OrderItems oi
    ON oi.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name
ORDER BY total_quantity_sold DESC;
GO
