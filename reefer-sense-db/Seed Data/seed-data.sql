GO
USE [reefersense];
GO


/* Drop tables script

drop table temperature_data_history
drop table temperature_data_latest
drop table modem_firmware
drop table company_modem
drop table company_vessel
drop table company
drop table container
drop table modem
drop table vessel
drop table firmware
drop table [user]

*/

DECLARE @company_name		VARCHAR(50) = 'CMA';
DECLARE @container_id	VARCHAR(12) = 'CMA202400011';
DECLARE @firmware_version VARCHAR(25) = '1.1';
DECLARE @modem_model VARCHAR(25) = 'rmmw';
DECLARE @modem_manufacturer  VARCHAR(50) = 'CMA CGM'
DECLARE @modem_imei	VARCHAR(15) = '350123451234560';
DECLARE @vessel_id VARCHAR(25) = 'CMAVSL001';
DECLARE @vessel_name VARCHAR(50) = 'CMA ATLANTIC REEFER';

DECLARE @company_ident INT;
DECLARE @modem_ident INT;
DECLARE @firmware_ident INT;
DECLARE @vessel_ident INT;


IF OBJECT_ID('dbo.company', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.company)
    BEGIN
        INSERT INTO dbo.company (company_name, created_dt, updated_dt) 
        VALUES (@company_name, GETDATE(), GETDATE());
    END
END



IF OBJECT_ID('dbo.container', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.container)
    BEGIN
        INSERT INTO dbo.container(container_id, created_dt) 
        VALUES (@container_id, GETDATE());
    END
END


IF OBJECT_ID('dbo.firmware', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.firmware)
    BEGIN
        INSERT INTO dbo.firmware(firmware_version, created_dt) 
        VALUES (@firmware_version, GETDATE());
    END
END

select * from firmware


IF OBJECT_ID('dbo.modem', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.modem)
    BEGIN
        INSERT INTO dbo.modem(modem_imei, model,manufacturer, created_dt) 
        VALUES (@modem_imei, @modem_model , @modem_manufacturer , GETDATE());
    END
END



IF OBJECT_ID('dbo.vessel', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.vessel)
    BEGIN
        INSERT INTO dbo.vessel( vessel_id, vessel_name,created_dt) 
        VALUES ( @vessel_id , @vessel_name , GETDATE());
    END
END


IF OBJECT_ID('dbo.modem_firmware', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.modem_firmware)
    BEGIN
        SELECT @modem_ident = ident FROM modem WHERE modem_imei = @modem_imei;
        SELECT @firmware_ident = ident FROM firmware WHERE firmware_version = @firmware_version;

        IF @modem_ident IS NOT NULL AND @firmware_ident IS NOT NULL
        BEGIN
            INSERT INTO dbo.modem_firmware (modem_ident, firmware_ident, created_dt) 
            VALUES (@modem_ident, @firmware_ident, GETDATE());
        END
    END
END


IF OBJECT_ID('dbo.company_modem', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.company_modem)
    BEGIN
	    
        SELECT @company_ident = ident FROM company WHERE company_name = @company_name;
		SELECT @modem_ident = ident FROM modem WHERE modem_imei = @modem_imei;
		
		IF @company_ident IS NOT NULL AND @modem_ident IS NOT NULL
		BEGIN
			INSERT INTO dbo.company_modem(company_ident, modem_ident, created_dt) 
			VALUES (@company_ident, @modem_ident, GETDATE());
		END
    END
END



IF OBJECT_ID('dbo.company_vessel', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.company_vessel)
    BEGIN
		SELECT @company_ident = ident FROM company WHERE company_name = @company_name;
		SELECT @vessel_ident = ident FROM vessel WHERE vessel_id = @vessel_id;

		IF @company_ident IS NOT NULL AND @vessel_ident IS NOT NULL
		BEGIN
			INSERT INTO dbo.company_vessel(company_ident, vessel_ident,created_dt) 
			VALUES (@company_ident, @vessel_ident, GETDATE());
		END
    END
END


IF OBJECT_ID('dbo.temperature_data_latest', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.temperature_data_latest)
    BEGIN
        INSERT INTO dbo.temperature_data_latest(container_id,modem_imei,temperaturF,logged_dt,power,battery_percent,co2_percent,o2_percent,deforsting,humidityPercent,received_dt) 
        VALUES (@container_id,@modem_imei,  25.50,GETDATE(), 1, 100, Null, Null, 0,60, GETDATE());
		 INSERT INTO dbo.temperature_data_latest(container_id,vessel_id, temperaturF,logged_dt,power,battery_percent,co2_percent,o2_percent,deforsting,humidityPercent,received_dt) 
        VALUES (@container_id, @vessel_id, 28.50,GETDATE(), 1, 100, Null, Null, 0,60, GETDATE());
    END
END

IF OBJECT_ID('dbo.temperature_data_history', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (SELECT 1 FROM dbo.temperature_data_history)
    BEGIN
        INSERT INTO dbo.temperature_data_history(container_id,modem_imei,temperaturF,logged_dt,power,battery_percent,co2_percent,o2_percent,deforsting,humidityPercent,received_dt) 
        VALUES (@container_id,@modem_imei,  25.50,GETDATE(), 1, 100, Null, Null, 0,60, GETDATE());
		        INSERT INTO dbo.temperature_data_history(container_id,vessel_id, temperaturF,logged_dt,power,battery_percent,co2_percent,o2_percent,deforsting,humidityPercent,received_dt) 
        VALUES (@container_id, @vessel_id, 29.50,GETDATE()-1, 1, 100, Null, Null, 0,60, GETDATE());

        INSERT INTO dbo.temperature_data_history(container_id,modem_imei,temperaturF,logged_dt,power,battery_percent,co2_percent,o2_percent,deforsting,humidityPercent,received_dt) 
        VALUES (@container_id,@modem_imei,  35.50,GETDATE()-2, 1, 100, Null, Null, 0,60, GETDATE());
		INSERT INTO dbo.temperature_data_history(container_id,vessel_id, temperaturF,logged_dt,power,battery_percent,co2_percent,o2_percent,deforsting,humidityPercent,received_dt) 
        VALUES (@container_id,@vessel_id, 8.50,GETDATE()-3, 1, 100, Null, Null, 0,60, GETDATE());
    END
END

GO

-- query temperature_data_latest
select 
	cy.company_name, 
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
	left join company_modem cm on cm.modem_ident = m.ident
	left join vessel v on v.vessel_id = tdl.vessel_id
	left join company_vessel cv on cv.vessel_ident = v.ident
	left join company cy on cy.ident = cm.company_ident or  cy.ident = cv.company_ident
order by tdl.logged_dt desc


-- query temperature_data_history
select 
	cy.company_name, 
	v.vessel_id, 
	v.vessel_name, 
	c.container_id, 
	m.modem_imei, 
	m.model, 
	m.manufacturer, 
	f.firmware_version, 
	tdh.temperaturF, 
	tdh.co2_percent, 
	tdh.deforsting, 
	tdh.humidityPercent, 
	tdh.o2_percent, 
	tdh.power,  
	tdh.logged_dt,
	tdh.received_dt  
from 
	temperature_data_history tdh
	inner join container c on c.container_id = tdh.container_id
	left join modem m on m.modem_imei = tdh.modem_imei
	left join modem_firmware mf on mf.modem_ident = m.ident
	left join firmware f on f.ident = mf.firmware_ident
	left join company_modem cm on cm.modem_ident = m.ident
	left join vessel v on v.vessel_id = tdh.vessel_id
	left join company_vessel cv on cv.vessel_ident = v.ident
	left join company cy on cy.ident = cm.company_ident or  cy.ident = cv.company_ident
order by tdh.logged_dt desc