USE online_store;
GO

-- TRIGGER 1 Проверка остатка товара перед добавлением в заказ

CREATE OR ALTER TRIGGER trg_CheckStock_BeforeOrderItemInsert
ON OrderItems
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Если товара не хватает — ошибка
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Products p ON i.product_id = p.product_id
        WHERE p.stock_quantity < i.quantity
    )
    BEGIN
        RAISERROR ('Недостаточно товара на складе', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Если всё ок — вставляем данные
    INSERT INTO OrderItems (order_id, product_id, quantity, price)
    SELECT
        i.order_id,
        i.product_id,
        i.quantity,
        i.price
    FROM inserted i;
END;
GO


--   TRIGGER 2   Уменьшение остатка товара после добавления в заказ

CREATE OR ALTER TRIGGER trg_DecreaseStock_OnOrderItemInsert
ON OrderItems
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE p
    SET p.stock_quantity = p.stock_quantity - i.quantity
    FROM Products p
    JOIN inserted i ON p.product_id = i.product_id;
END;
GO
