USE online_store;
GO

-- FUNCTIONS

IF OBJECT_ID('dbo.fn_TotalSpent', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_TotalSpent;
GO

IF OBJECT_ID('dbo.fn_ProductStock', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_ProductStock;
GO

IF OBJECT_ID('dbo.fn_OrderTotal', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_OrderTotal;
GO


-- DROP PROCEDURES

IF OBJECT_ID('dbo.sp_AddToCart', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_AddToCart;
GO

IF OBJECT_ID('dbo.sp_CreateOrder', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_CreateOrder;
GO

IF OBJECT_ID('dbo.sp_UpdateProductPrice', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_UpdateProductPrice;
GO

IF OBJECT_ID('dbo.sp_RemoveFromCart', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_RemoveFromCart;
GO

IF OBJECT_ID('dbo.sp_ClearCart', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ClearCart;
GO


   -- FUNCTIONS

-- Общая сумма заказов клиента
CREATE FUNCTION dbo.fn_TotalSpent (@CustomerID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2);

    SELECT @Total = ISNULL(SUM(oi.quantity * oi.price), 0)
    FROM Orders o
    JOIN OrderItems oi ON o.order_id = oi.order_id
    WHERE o.customer_id = @CustomerID;

    RETURN @Total;
END;
GO


-- Остаток товара на складе
CREATE FUNCTION dbo.fn_ProductStock (@ProductID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Stock INT;

    SELECT @Stock = stock_quantity
    FROM Products
    WHERE product_id = @ProductID;

    RETURN @Stock;
END;
GO


-- Сумма конкретного заказа
CREATE FUNCTION dbo.fn_OrderTotal (@OrderID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2);

    SELECT @Total = SUM(quantity * price)
    FROM OrderItems
    WHERE order_id = @OrderID;

    RETURN ISNULL(@Total, 0);
END;
GO


-- PROCEDURES

-- Добавить товар в корзину
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


--  Создать заказ
CREATE PROCEDURE dbo.sp_CreateOrder
    @CustomerID INT
AS
BEGIN
    DECLARE @OrderID INT;

    INSERT INTO Orders (customer_id, order_date, status)
    VALUES (@CustomerID, GETDATE(), 'Created');

    SET @OrderID = SCOPE_IDENTITY();

    INSERT INTO OrderItems (order_id, product_id, quantity, price)
    SELECT 
        @OrderID,
        ci.product_id,
        ci.quantity,
        p.price
    FROM CartItems ci
    JOIN Carts c ON ci.cart_id = c.cart_id
    JOIN Products p ON ci.product_id = p.product_id
    WHERE c.customer_id = @CustomerID;

    DELETE ci
    FROM CartItems ci
    JOIN Carts c ON ci.cart_id = c.cart_id
    WHERE c.customer_id = @CustomerID;
END;
GO


-- Обновить цену товара
CREATE PROCEDURE dbo.sp_UpdateProductPrice
    @ProductID INT,
    @NewPrice DECIMAL(10,2)
AS
BEGIN
    UPDATE Products
    SET price = @NewPrice
    WHERE product_id = @ProductID;
END;
GO


-- Удалить товар из корзины
CREATE PROCEDURE dbo.sp_RemoveFromCart
    @CartID INT,
    @ProductID INT
AS
BEGIN
    DELETE FROM CartItems
    WHERE cart_id = @CartID
      AND product_id = @ProductID;
END;
GO

-- Очистить корзину клиента
CREATE PROCEDURE dbo.sp_ClearCart
    @CustomerID INT
AS
BEGIN
    DELETE ci
    FROM CartItems ci
    JOIN Carts c ON ci.cart_id = c.cart_id
    WHERE c.customer_id = @CustomerID;
END;
GO
