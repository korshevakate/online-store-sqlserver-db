USE online_store;
GO

CREATE TRIGGER trg_UpdateStock
ON OrderItems
AFTER INSERT
AS
BEGIN
    UPDATE p
    SET p.stock_quantity = p.stock_quantity - i.quantity
    FROM Products p
    JOIN inserted i ON p.product_id = i.product_id;
END;
GO
