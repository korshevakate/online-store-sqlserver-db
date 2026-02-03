USE online_store;
GO

SELECT 
    c.first_name,
    c.last_name,
    (SELECT SUM(oi.quantity * oi.price)
     FROM Orders o
     JOIN OrderItems oi ON oi.order_id = o.order_id
     WHERE o.customer_id = c.customer_id) AS total_spent
FROM Customers c;
GO
