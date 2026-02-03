USE online_store;
GO

;WITH CustomerSales AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(oi.quantity * oi.price) AS total_spent
    FROM Customers c
    JOIN Orders o ON o.customer_id = c.customer_id
    JOIN OrderItems oi ON oi.order_id = o.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT * FROM CustomerSales;
GO
