USE online_store;
GO

/*
Подзапрос:
Вывод клиентов, у которых сумма заказов выше средней по всем клиентам
*/

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * p.price) AS total_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(oi.quantity * p.price) > (
    SELECT AVG(order_total)
    FROM (
        SELECT SUM(oi2.quantity * p2.price) AS order_total
        FROM Orders o2
        JOIN OrderItems oi2 ON o2.order_id = oi2.order_id
        JOIN Products p2 ON oi2.product_id = p2.product_id
        GROUP BY o2.order_id
    ) AS sub
);
GO
