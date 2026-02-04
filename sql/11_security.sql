USE online_store_2026;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'report_reader')
BEGIN
    CREATE ROLE report_reader;
END
GO

IF OBJECT_ID('dbo.vw_CustomerTotalSpent', 'V') IS NOT NULL
    GRANT SELECT ON dbo.vw_CustomerTotalSpent TO report_reader;
GO

IF OBJECT_ID('dbo.vw_OrdersSummary', 'V') IS NOT NULL
    GRANT SELECT ON dbo.vw_OrdersSummary TO report_reader;
GO

IF OBJECT_ID('dbo.vw_CartSummary', 'V') IS NOT NULL
    GRANT SELECT ON dbo.vw_CartSummary TO report_reader;
GO
