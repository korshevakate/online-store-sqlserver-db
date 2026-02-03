/* =====================================================
   10_monitoring_zabbix_grafana.sql
   Метрики SQL Server для Zabbix / Grafana
   Все запросы возвращают ЧИСЛА (удобно для мониторинга)
   ===================================================== */

SET NOCOUNT ON;
GO

/* -----------------------------
   1) Активные блокировки (сколько запросов заблокировано)
----------------------------- */
SELECT COUNT(*) AS blocked_requests
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;
GO


/* -----------------------------
   2) Количество текущих активных запросов
----------------------------- */
SELECT COUNT(*) AS active_requests
FROM sys.dm_exec_requests
WHERE session_id > 50;  -- исключаем системные сессии
GO


/* -----------------------------
   3) Утилизация CPU SQL Server (approx)
   (сумма CPU времени запросов за всё время в кэше)
   Для мониторинга лучше брать "топ по CPU за 5 минут"
   но в учебном проекте достаточно текущего среза.
----------------------------- */
SELECT TOP 1
    (qs.total_worker_time / 1000) AS total_cpu_ms_cached
FROM sys.dm_exec_query_stats qs
ORDER BY qs.total_worker_time DESC;
GO


/* -----------------------------
   4) Топ-1 самый "долгий" запрос (суммарное время)
----------------------------- */
SELECT TOP 1
    (qs.total_elapsed_time / 1000) AS top_total_elapsed_ms_cached
FROM sys.dm_exec_query_stats qs
ORDER BY qs.total_elapsed_time DESC;
GO


/* -----------------------------
   5) Использование индексов: сколько индексов НЕ используется
   (по usage stats; после рестарта сервиса статистика обнуляется)
----------------------------- */
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


/* -----------------------------
   6) Фрагментация индексов: сколько индексов фрагментировано > 30%
   (упрощённая метрика)
----------------------------- */
SELECT COUNT(*) AS fragmented_indexes_gt_30
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'SAMPLED') ps
JOIN sys.indexes i
  ON ps.object_id = i.object_id
 AND ps.index_id = i.index_id
WHERE ps.avg_fragmentation_in_percent > 30
  AND i.index_id > 0;
GO


/* -----------------------------
   7) Количество строк в ключевых таблицах (пример для интернет-магазина)
   Возвращаем несколько метрик одним набором (удобно для Grafana).
----------------------------- */
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


/* -----------------------------
   8) Продажи: сумма по всем заказам (если нужны KPI)
----------------------------- */
SELECT ISNULL(SUM(oi.quantity * oi.price), 0) AS total_revenue
FROM Orders o
JOIN OrderItems oi ON oi.order_id = o.order_id;
GO


/* -----------------------------
   9) Количество заказов по статусам (KPI для отчётов)
----------------------------- */
SELECT
    ISNULL(status, 'NULL') AS status,
    COUNT(*) AS orders_count
FROM Orders
GROUP BY ISNULL(status, 'NULL')
ORDER BY orders_count DESC;
GO
