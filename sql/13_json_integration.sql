-- Добавление JSON-поля в таблицу Orders

IF COL_LENGTH('Orders', 'extra_data') IS NULL
BEGIN
    ALTER TABLE Orders
    ADD extra_data NVARCHAR(MAX);
END
GO

-- Обновления заказа с JSON-данными

UPDATE Orders
SET extra_data = N'{
    "delivery_type": "courier",
    "delivery_time": "18:00-21:00",
    "gift_wrap": true,
    "customer_comment": "Позвонить за 30 минут"
}'
WHERE order_id = (
    SELECT TOP 1 order_id
    FROM Orders
    ORDER BY order_id
);
GO

-- Чтение данных из JSON

SELECT
    order_id,
    JSON_VALUE(extra_data, '$.delivery_type') AS delivery_type,
    JSON_VALUE(extra_data, '$.delivery_time') AS delivery_time,
    JSON_VALUE(extra_data, '$.customer_comment') AS customer_comment
FROM Orders
WHERE extra_data IS NOT NULL;
GO

--   Проверка корректности JSON

SELECT
    order_id,
    ISJSON(extra_data) AS is_valid_json
FROM Orders
WHERE extra_data IS NOT NULL;
GO
