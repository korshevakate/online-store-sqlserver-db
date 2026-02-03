USE online_store;
GO

/*
CTE: Îáùàÿ ñóììà ïîêóïîê ïî êàæäîìó êëèåíòó
Èñïîëüçóåòñÿ äëÿ àíàëèòèêè ïðîäàæ
*/

WITH CustomerSales AS (
    SELECT
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(oi.quantity * p.price) AS total_amount
    FROM Customers c
    JOIN Orders o
        ON c.customer_id = o.customer_id
    JOIN OrderItems oi
        ON o.order_id = oi.order_id
    JOIN Products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name
)
SELECT *
FROM CustomerSales
ORDER BY total_amount DESC;
