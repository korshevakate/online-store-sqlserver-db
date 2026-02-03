USE online_store;
GO

CREATE PROCEDURE sp_CreateOrder
    @customer_id INT
AS
BEGIN
    INSERT INTO Orders (customer_id, order_date)
    VALUES (@customer_id, SYSDATETIME());
END;
GO
