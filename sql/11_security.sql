
CREATE ROLE report_reader;
GO

GRANT SELECT ON vw_CustomerTotalSpent TO report_reader;
GRANT SELECT ON vw_OrdersSummary TO report_reader;
GO

-- CREATE LOGIN report_user WITH PASSWORD = 'StrongPassword123!';
-- CREATE USER report_user FOR LOGIN report_user;
-- ALTER ROLE report_reader ADD MEMBER report_user;
