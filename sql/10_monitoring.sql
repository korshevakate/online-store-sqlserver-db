SET NOCOUNT ON;
GO

SELECT COUNT(*) AS blocked_requests
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;
GO

SELECT COUNT(*) AS active_requests
FROM sys.dm_exec_requests
WHERE session_id > 50;
GO

SELECT TOP 1
    (qs.total_worker_time / 1000) AS total_cpu_ms_cached
FROM sys.dm_exec_query_stats qs
ORDER BY qs.total_worker_time DESC;
GO

SELECT TOP 1
    (qs.total_elapsed_time / 1000) AS top_total_elapsed_ms_cached
FROM sys.dm_exec_query_stats qs
ORDER BY qs.total_elapsed_time DESC;
GO

SELECT COUNT(*) AS unused_indexes
FROM sys.indexes i
LEFT JOIN sys.dm_db_index_usage_stats s
    ON s.object_id = i.object_id
   AND s.index_id = i.index_id
   AND s.database_id = DB_ID()
WHERE OBJECTPROPERTY(i.object_id, 'IsUserTable') = 1
  AND i.index_id > 0
  AND i.is_primary_key = 0
  AND i.is_unique_constraint = 0
  AND ISNULL(s.user_seeks, 0) = 0
  AND ISNULL(s.user_scans, 0) = 0
  AND ISNULL(s.user_lookups, 0) = 0;
GO

SELECT COUNT(*) AS fragmented_indexes_gt_30
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'SAMPLED') ps
JOIN sys.indexes i
  ON ps.object_id = i.object_id
 AND ps.index_id = i.index_id
WHERE ps.avg_fragmentation_in_percent > 30
  AND i.index_id > 0;
GO

SELECT 'Customers' AS metric, COUNT(*) AS value FROM Customers
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM OrderItems
UNION ALL
SELECT 'CartItems', COUNT(*) FROM CartItems;
GO

SELECT ISNULL(SUM(oi.quantity * oi.price), 0) AS total_revenue
FROM Orders o
JOIN OrderItems oi ON oi.order_id = o.order_id;
GO

SELECT
    ISNULL(status, 'NULL') AS status,
    COUNT(*) AS orders_count
FROM Orders
GROUP BY ISNULL(status, 'NULL')
ORDER BY orders_count DESC;
GO
