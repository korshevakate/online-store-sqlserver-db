USE online_store;
GO

CREATE VIEW vw_ProductCatalog AS
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.price,
    p.stock_quantity
FROM Products p
JOIN Categories c ON p.category_id = c.category_id;
