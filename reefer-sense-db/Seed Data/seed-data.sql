GO
USE [reefersense];
GO

IF OBJECT_ID('dbo.company', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.company)
    BEGIN
        INSERT INTO dbo.company (company_name, created_dt, updated_dt) 
        VALUES ('CMA', GETDATE(), GETDATE());
    END
END





GO
