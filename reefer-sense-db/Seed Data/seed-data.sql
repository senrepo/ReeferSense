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
        INSERT INTO dbo.container(container_id, created_dt) 
        VALUES ('CMA', GETDATE());
    END
END


IF OBJECT_ID('dbo.firmware', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.firmware)
    BEGIN
        INSERT INTO dbo.firmware(firmware_version, created_dt) 
        VALUES (1.1, GETDATE());
    END
END


IF OBJECT_ID('dbo.modem', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.modem)
    BEGIN
        INSERT INTO dbo.modem(modem_imei, model,manufacturer, created_dt) 
        VALUES ('350123451234560', 'rmmw' , 'CMA CGM' , GETDATE());
    END
END


IF OBJECT_ID('dbo.vessel', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.vessel)
    BEGIN
        INSERT INTO dbo.vessel(company_ident, vessel_id, vessel_name,created_dt) 
        VALUES (1001, 'CMAVSL001 ' , 'CMA ATLANTIC REEFER ' , GETDATE());
    END
END


IF OBJECT_ID('dbo.vessel_container', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.vessel_container)
    BEGIN
        INSERT INTO dbo.vessel_container(vessel_ident, container_ident,created_dt) 
        VALUES (1, '101 ' , GETDATE());
    END
END




IF OBJECT_ID('dbo.modem_firmware', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.modem_firmware)
    BEGIN
        INSERT INTO dbo.modem_firmware(modem_ident, firmware_ident ,created_dt) 
        VALUES (1, 1 , GETDATE());
    END
END


IF OBJECT_ID('dbo.container_modem', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.container_modem)
    BEGIN
        INSERT INTO dbo.container_modem(container_ident, modem_ident, created_dt) 
        VALUES (101,1,  GETDATE());
    END
END


IF OBJECT_ID('dbo.temperature_data_latest', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.temperature_data_latest)
    BEGIN
        INSERT INTO dbo.temperature_data_latest(container_ident,modem_imei,vessel_id,temperaturF,logged_dt,power,battery_percent,co2_percent,o2_percent,deforsting,humidityPercent,received_dt) 
        VALUES (101,'350123451234560',  'CMAVSL001', 25.50,GETDATE(), 1, 100, Null, Null, 0,60, GETDATE());
    END
END

IF OBJECT_ID('dbo.temperature_data_history', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.temperature_data_history)
    BEGIN
        INSERT INTO dbo.temperature_data_history(container_ident,modem_imei,vessel_id,temperaturF,logged_dt,power,battery_percent,co2_percent,o2_percent,deforsting,humidityPercent,received_dt) 
        VALUES (101,'350123451234560',  'CMAVSL001', 25.50,GETDATE(), 1, 100, Null, Null, 0,60, GETDATE());
    END
END

GO
