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


IF OBJECT_ID('dbo.modem_firmware', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.modem_firmware)
    BEGIN
        INSERT INTO dbo.modem_firmware(modem_ident, firmware_ident ,created_dt) 
        VALUES (1, 1 , GETDATE());
    END
END


IF OBJECT_ID('dbo.company_modem', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.company_modem)
    BEGIN
        INSERT INTO dbo.company_modem(company_ident, modem_ident, firmware_ident ,created_dt) 
        VALUES (1, 1,1 , GETDATE());
    END
END



IF OBJECT_ID('dbo.company_vessel', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.company_vessel)
    BEGIN
        INSERT INTO dbo.company_vessel(company_ident, vessel_ident, firmware_ident ,created_dt) 
        VALUES (1, 1,1 , GETDATE());
    END
END





IF OBJECT_ID('dbo.temperature_data_latest', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.temperature_data_latest)
    BEGIN
        INSERT INTO dbo.temperature_data_latest(container_id,modem_imei,temperaturF,logged_dt,power,battery_percent,co2_percent,o2_percent,deforsting,humidityPercent,received_dt) 
        VALUES ('CMA20240001','350123451234560',  25.50,GETDATE(), 1, 100, Null, Null, 0,60, GETDATE());
		 INSERT INTO dbo.temperature_data_latest(container_id,vessel_id, temperaturF,logged_dt,power,battery_percent,co2_percent,o2_percent,deforsting,humidityPercent,received_dt) 
        VALUES ('CMA20240001', 'CMAVSL001', 28.50,GETDATE(), 1, 100, Null, Null, 0,60, GETDATE());
    END
END

IF OBJECT_ID('dbo.temperature_data_history', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.temperature_data_history)
    BEGIN
        INSERT INTO dbo.temperature_data_history(container_id,modem_imei,temperaturF,logged_dt,power,battery_percent,co2_percent,o2_percent,deforsting,humidityPercent,received_dt) 
        VALUES ('CMA20240001','350123451234560',  25.50,GETDATE(), 1, 100, Null, Null, 0,60, GETDATE());
		        INSERT INTO dbo.temperature_data_history(container_id,vessel_id, temperaturF,logged_dt,power,battery_percent,co2_percent,o2_percent,deforsting,humidityPercent,received_dt) 
        VALUES ('CMA20240001', 'CMAVSL001', 28.50,GETDATE()-1, 1, 100, Null, Null, 0,60, GETDATE());

        INSERT INTO dbo.temperature_data_history(container_id,modem_imei,temperaturF,logged_dt,power,battery_percent,co2_percent,o2_percent,deforsting,humidityPercent,received_dt) 
        VALUES ('CMA20240001','350123451234560',  35.50,GETDATE()-2, 1, 100, Null, Null, 0,60, GETDATE());
		INSERT INTO dbo.temperature_data_history(container_id,vessel_id, temperaturF,logged_dt,power,battery_percent,co2_percent,o2_percent,deforsting,humidityPercent,received_dt) 
        VALUES ('CMA20240001', 'CMAVSL001', 8.50,GETDATE()-3, 1, 100, Null, Null, 0,60, GETDATE());
    END
END

GO

-- query temperature_data_latest
select 
	cp.company_name, 
	v.vessel_id, 
	v.vessel_name, 
	c.container_id, 
	m.modem_imei, 
	m.model, 
	m.manufacturer, 
	f.firmware_version, 
	tdl.temperaturF, 
	tdl.co2_percent, 
	tdl.deforsting, 
	tdl.humidityPercent, 
	tdl.o2_percent, 
	tdl.power,  
	tdl.logged_dt,
	tdl.received_dt  
from 
	temperature_data_latest tdl
	inner join container c on c.container_id = tdl.container_id
	left join modem m on m.modem_imei = tdl.modem_imei
	left join modem_firmware mf on mf.modem_ident = m.ident
	left join firmware f on f.ident = mf.firmware_ident
	left join vessel_container vc on vc.container_ident = c.ident
	left join vessel v on v.vessel_id = tdl.vessel_id or v.ident = vc.vessel_ident
	left join company cp on cp.ident = v.company_ident