-- =====================================================
-- 10_monitoring.sql
-- Скрипт мониторинга производительности базы данных
-- =====================================================

-- Используй текущую базу данных
-- Если хочешь, можно указать конкретную базу:
-- USE OnlineStore;
-- GO

-- =====================================================
-- 1️⃣ Состояние индексов
-- Показывает, какие индексы есть, их тип и состояние
-- =====================================================
SELECT 
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.is_disabled AS IsDisabled,
    i.is_primary_key AS IsPrimaryKey
FROM sys.indexes i
WHERE OBJECTPROPERTY(i.object_id, 'IsUserTable') = 1
ORDER BY TableName, IndexName;
GO

-- =====================================================
-- 2️⃣ Топ 10 самых дорогих запросов
-- По времени выполнения (системная метрика)
-- =====================================================
SELECT TOP 10 
    qs.total_elapsed_time / 1000 AS TotalTimeMs,
    qs.execution_count,
    qs.total_worker_time / 1000 AS TotalCPUms,
    SUBSTRING(qt.text, qs.statement_start_offset/2 + 1,
        (CASE 
            WHEN qs.statement_end_offset = -1 
            THEN LEN(CONVERT(NVARCHAR(MAX), qt.text)) * 2 
            ELSE qs.statement_end_offset 
         END - qs.statement_start_offset)/2
    ) AS QueryText
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
ORDER BY qs.total_elapsed_time DESC;
GO

-- =====================================================
-- 3️⃣ Количество строк в таблицах
-- Для оценки объёма данных
-- =====================================================
SELECT 
    t.NAME AS TableName,
    s.Name AS SchemaName,
    p.rows AS RowCounts
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id IN (0,1)  -- 0 = heap, 1 = clustered
GROUP BY t.NAME, s.Name, p.rows
ORDER BY RowCounts DESC;
GO

-- =====================================================
-- 4️⃣ Проверка блокировок (актуально при нагрузке)
-- =====================================================
SELECT 
    r.session_id,
    r.blocking_session_id,
    r.status,
    r.command,
    r.cpu_time,
    r.total_elapsed_time
FROM sys.dm_exec_requests r
WHERE r.blocking_session_id <> 0
ORDER BY r.total_elapsed_time DESC;
GO
