USE online_store;
GO

/* =====================================================
   VIEW: vw_CustomerTotalSpent
   Назначение: общая сумма покупок по клиентам
   ===================================================== */

DROP VIEW IF EXISTS vw_CustomerTotalSpent;
GO

CREATE VIEW vw_CustomerTotalSpent AS
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.price) AS total_spent
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
JOIN OrderItems oi ON oi.order_id = o.order_id
GROUP BY c.customer_id, c.first_name, c.last_name;
GO


/* =====================================================
   VIEW: vw_CartSummary
   Назначение: содержимое корзины клиента
   ===================================================== */

DROP VIEW IF EXISTS vw_CartSummary;
GO

CREATE VIEW vw_CartSummary AS
SELECT
    c.cart_id,
    cu.first_name,
    cu.last_name,
    p.product_name,
    ci.quantity,
    p.price,
    (ci.quantity * p.price) AS item_total
FROM CartItems ci
JOIN Carts c ON c.cart_id = ci.cart_id
JOIN Products p ON p.product_id = ci.product_id
JOIN Customers cu ON cu.customer_id = c.customer_id;
GO


/* =====================================================
   VIEW: vw_OrdersSummary
   Назначение: заказы с общей суммой
   ===================================================== */

DROP VIEW IF EXISTS vw_OrdersSummary;
GO

CREATE VIEW vw_OrdersSummary AS
SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.status,
    SUM(oi.quantity * oi.price) AS order_total
FROM Orders o
JOIN OrderItems oi ON oi.order_id = o.order_id
GROUP BY o.order_id, o.customer_id, o.order_date, o.status;
GO
