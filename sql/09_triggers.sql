USE online_store;
GO

/* =====================================================
   TRIGGER: trg_UpdateStock
   Назначение: уменьшать остаток товара при создании заказа
   ===================================================== */

DROP TRIGGER IF EXISTS trg_UpdateStock;
GO

CREATE TRIGGER trg_UpdateStock
ON OrderItems
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE p
    SET p.stock_quantity = p.stock_quantity - i.quantity
    FROM Products p
    JOIN inserted i ON i.product_id = p.product_id;
END;
GO


/* =====================================================
   TRIGGER: trg_CheckCartStock
   Назначение: запретить добавление в корзину,
   если товара на складе недостаточно
   ===================================================== */

DROP TRIGGER IF EXISTS trg_CheckCartStock;
GO

CREATE TRIGGER trg_CheckCartStock
ON CartItems
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Проверка остатков
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Products p ON p.product_id = i.product_id
        WHERE i.quantity > p.stock_quantity
    )
    BEGIN
        RAISERROR('Недостаточно товара на складе', 16, 1);
        RETURN;
    END

    -- Если всё ок — вставляем
    INSERT INTO CartItems (cart_id, product_id, quantity)
    SELECT cart_id, product_id, quantity
    FROM inserted;
END;
GO
