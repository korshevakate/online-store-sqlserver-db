-- Роль только для чтения отчетов
CREATE ROLE report_reader;
GO

-- Права на представления
GRANT SELECT ON vw_CustomerTotalSpent TO report_reader;
GRANT SELECT ON vw_OrdersSummary TO report_reader;
GO

-- Пример пользователя (опционально, можно описать в README)
-- CREATE LOGIN report_user WITH PASSWORD = 'StrongPassword123!';
-- CREATE USER report_user FOR LOGIN report_user;
-- ALTER ROLE report_reader ADD MEMBER report_user;
