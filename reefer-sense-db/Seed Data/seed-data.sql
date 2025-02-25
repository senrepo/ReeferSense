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



IF OBJECT_ID('dbo.container', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.container)
    BEGIN
        INSERT INTO dbo.container(containerid, created_dt, updated_dt) 
        VALUES ('CMA', GETDATE(), GETDATE());
    END
END


IF OBJECT_ID('dbo.firmware', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.firmware)
    BEGIN
        INSERT INTO dbo.firmware(firmware_version, created_dt, updated_dt) 
        VALUES ('1.1', GETDATE(), GETDATE());
    END
END


IF OBJECT_ID('dbo.modem', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.modem)
    BEGIN
        INSERT INTO dbo.modem(modem_imei, model,manufacturer, created_dt, updated_dt) 
        VALUES ('350123451234560', 'rmmw' , 'CMA CGM' , GETDATE(), GETDATE());
    END
END


IF OBJECT_ID('dbo.vessel', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.vessel)
    BEGIN
        INSERT INTO dbo.vessel(company_ident, vessel_id, vessel_name) 
        VALUES ('1.1', GETDATE(), GETDATE());
    END
END




GO
