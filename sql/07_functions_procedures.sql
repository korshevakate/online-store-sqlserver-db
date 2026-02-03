USE online_store;
GO

/* =====================================================
   FUNCTION: fn_TotalSpent
   Назначение: вернуть общую сумму покупок клиента
   ===================================================== */

DROP FUNCTION IF EXISTS dbo.fn_TotalSpent;
GO

CREATE FUNCTION dbo.fn_TotalSpent (@CustomerID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = SUM(oi.quantity * oi.price)
    FROM Orders o
    JOIN OrderItems oi ON oi.order_id = o.order_id
    WHERE o.customer_id = @CustomerID;

    RETURN ISNULL(@total, 0);
END;
GO


/* =====================================================
   PROCEDURE: sp_AddToCart
   Назначение: добавить товар в корзину
   ===================================================== */

DROP PROCEDURE IF EXISTS dbo.sp_AddToCart;
GO

CREATE PROCEDURE dbo.sp_AddToCart
    @CartID INT,
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    INSERT INTO CartItems (cart_id, product_id, quantity)
    VALUES (@CartID, @ProductID, @Quantity);
END;
GO


/* =====================================================
   PROCEDURE: sp_CreateOrder
   Назначение: создать заказ из корзины клиента
   ===================================================== */

DROP PROCEDURE IF EXISTS dbo.sp_CreateOrder;
GO

CREATE PROCEDURE dbo.sp_CreateOrder
    @CustomerID INT
AS
BEGIN
    DECLARE @OrderID INT;
    DECLARE @CartID INT;

    -- Получаем корзину клиента
    SELECT @CartID = cart_id
    FROM Carts
    WHERE customer_id = @CustomerID;

    -- Создаём заказ
    INSERT INTO Orders (customer_id, status)
    VALUES (@CustomerID, 'Pending');

    SET @OrderID = SCOPE_IDENTITY();

    -- Перенос товаров из корзины в заказ
    INSERT INTO OrderItems (order_id, product_id, quantity, price)
    SELECT
        @OrderID,
        ci.product_id,
        ci.quantity,
        p.price
    FROM CartItems ci
    JOIN Products p ON p.product_id = ci.product_id
    WHERE ci.cart_id = @CartID;

    -- Очищаем корзину
    DELETE FROM CartItems
    WHERE cart_id = @CartID;
END;
GO
