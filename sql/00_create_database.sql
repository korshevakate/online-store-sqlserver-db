USE master;
GO

IF DB_ID('online_store_2026') IS NOT NULL
BEGIN
    ALTER DATABASE online_store_2026
        SET SINGLE_USER
        WITH ROLLBACK IMMEDIATE;

    DROP DATABASE online_store_2026;
END
GO

CREATE DATABASE online_store_2026
ON PRIMARY (
    NAME = online_store_2026_data,
    FILENAME = '/var/opt/mssql/data/online_store_2026_data.mdf'
)
LOG ON (
    NAME = online_store_2026_log,
    FILENAME = '/var/opt/mssql/data/online_store_2026_log.ldf'
);
GO
