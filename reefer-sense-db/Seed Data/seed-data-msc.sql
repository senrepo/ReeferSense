/* Connect to database: reefersense (set in the VS connection) */

-- PARAMETERS
DECLARE @company_name        VARCHAR(50) = 'MSC';
DECLARE @container_id        VARCHAR(12) = 'MSC202400001';
DECLARE @firmware_version    VARCHAR(25) = '1.0';
DECLARE @modem_model         VARCHAR(25) = 'rmmw';
DECLARE @modem_manufacturer  VARCHAR(50) = 'Mediterranean Shipping Company';
DECLARE @modem_imei          VARCHAR(15) = '350123451234568';
DECLARE @vessel_id           VARCHAR(25) = 'MSCVSL001';
DECLARE @vessel_name         VARCHAR(50) = 'MSC Global Reefer';

DECLARE @company_ident  INT;
DECLARE @modem_ident    INT;
DECLARE @firmware_ident INT;
DECLARE @vessel_ident   INT;

BEGIN TRY
    /* Company */
    IF OBJECT_ID('dbo.company','U') IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.company WHERE company_name = @company_name)
            INSERT dbo.company (company_name, created_dt, updated_dt)
            VALUES (@company_name, GETDATE(), GETDATE());

        SELECT @company_ident = ident FROM dbo.company WHERE company_name = @company_name;
    END

    /* Container */
    IF OBJECT_ID('dbo.container','U') IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.container WHERE container_id = @container_id)
            INSERT dbo.container (container_id, created_dt)
            VALUES (@container_id, GETDATE());
    END

    /* Firmware */
    IF OBJECT_ID('dbo.firmware','U') IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.firmware WHERE firmware_version = @firmware_version)
            INSERT dbo.firmware (firmware_version, created_dt)
            VALUES (@firmware_version, GETDATE());

        SELECT @firmware_ident = ident FROM dbo.firmware WHERE firmware_version = @firmware_version;
    END

    /* Modem */
    IF OBJECT_ID('dbo.modem','U') IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.modem WHERE modem_imei = @modem_imei)
            INSERT dbo.modem (modem_imei, model, manufacturer, created_dt)
            VALUES (@modem_imei, @modem_model, @modem_manufacturer, GETDATE());

        SELECT @modem_ident = ident FROM dbo.modem WHERE modem_imei = @modem_imei;
    END

    /* Vessel */
    IF OBJECT_ID('dbo.vessel','U') IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.vessel WHERE vessel_id = @vessel_id)
            INSERT dbo.vessel (vessel_id, vessel_name, created_dt)
            VALUES (@vessel_id, @vessel_name, GETDATE());

        SELECT @vessel_ident = ident FROM dbo.vessel WHERE vessel_id = @vessel_id;
    END

    /* Modem ↔ Firmware link */
    IF OBJECT_ID('dbo.modem_firmware','U') IS NOT NULL
    BEGIN
        IF @modem_ident IS NOT NULL AND @firmware_ident IS NOT NULL
           AND NOT EXISTS (
               SELECT 1 FROM dbo.modem_firmware 
               WHERE modem_ident = @modem_ident AND firmware_ident = @firmware_ident
           )
        BEGIN
            INSERT dbo.modem_firmware (modem_ident, firmware_ident, created_dt)
            VALUES (@modem_ident, @firmware_ident, GETDATE());
        END
    END

    /* Company ↔ Modem link */
    IF OBJECT_ID('dbo.company_modem','U') IS NOT NULL
    BEGIN
        IF @company_ident IS NOT NULL AND @modem_ident IS NOT NULL
           AND NOT EXISTS (
               SELECT 1 FROM dbo.company_modem 
               WHERE company_ident = @company_ident AND modem_ident = @modem_ident
           )
        BEGIN
            INSERT dbo.company_modem (company_ident, modem_ident, created_dt)
            VALUES (@company_ident, @modem_ident, GETDATE());
        END
    END

    /* Company ↔ Vessel link */
    IF OBJECT_ID('dbo.company_vessel','U') IS NOT NULL
    BEGIN
        IF @company_ident IS NOT NULL AND @vessel_ident IS NOT NULL
           AND NOT EXISTS (
               SELECT 1 FROM dbo.company_vessel
               WHERE company_ident = @company_ident AND vessel_ident = @vessel_ident
           )
        BEGIN
            INSERT dbo.company_vessel (company_ident, vessel_ident, created_dt)
            VALUES (@company_ident, @vessel_ident, GETDATE());
        END
    END

    /* Latest data */
    IF OBJECT_ID('dbo.temperature_data_latest','U') IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.temperature_data_latest WHERE container_id = @container_id)
        BEGIN
            INSERT dbo.temperature_data_latest
                (container_id, modem_imei, temperatureF, logged_dt, power, battery_percent, co2_percent, o2_percent, deforsting, humidityPercent, received_dt)
            VALUES
                (@container_id, @modem_imei, 25, GETDATE(), 1, 100, NULL, NULL, 0, 60, GETDATE());

            INSERT dbo.temperature_data_latest
                (container_id, vessel_id, temperatureF, logged_dt, power, battery_percent, co2_percent, o2_percent, deforsting, humidityPercent, received_dt)
            VALUES
                (@container_id, @vessel_id, 28, GETDATE(), 1, 100, NULL, NULL, 0, 60, GETDATE());
        END
    END

    /* History data */
    IF OBJECT_ID('dbo.temperature_data_history','U') IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM dbo.temperature_data_history WHERE container_id = @container_id)
        BEGIN
            INSERT dbo.temperature_data_history
                (container_id, modem_imei, temperatureF, logged_dt, power, battery_percent, co2_percent, o2_percent, deforsting, humidityPercent, received_dt)
            VALUES
                (@container_id, @modem_imei, 25, GETDATE(), 1, 100, NULL, NULL, 0, 60, GETDATE());

            INSERT dbo.temperature_data_history
                (container_id, vessel_id, temperatureF, logged_dt, power, battery_percent, co2_percent, o2_percent, deforsting, humidityPercent, received_dt)
            VALUES
                (@container_id, @vessel_id, 29, DATEADD(DAY,-1,GETDATE()), 1, 100, NULL, NULL, 0, 60, GETDATE());

            INSERT dbo.temperature_data_history
                (container_id, modem_imei, temperatureF, logged_dt, power, battery_percent, co2_percent, o2_percent, deforsting, humidityPercent, received_dt)
            VALUES
                (@container_id, @modem_imei, 35, DATEADD(DAY,-2,GETDATE()), 1, 100, NULL, NULL, 0, 60, GETDATE());

            INSERT dbo.temperature_data_history
                (container_id, vessel_id, temperatureF, logged_dt, power, battery_percent, co2_percent, o2_percent, deforsting, humidityPercent, received_dt)
            VALUES
                (@container_id, @vessel_id, 38, DATEADD(DAY,-3,GETDATE()), 1, 100, NULL, NULL, 0, 60, GETDATE());
        END
    END

    /* Ad-hoc queries — comment these out if running via tool that disallows SELECT */
    -- temperature_data_latest
    SELECT 
        cy.company_name, v.vessel_id, v.vessel_name, c.container_id,
        m.modem_imei, m.model, m.manufacturer, f.firmware_version,
        tdl.temperatureF, tdl.co2_percent, tdl.deforsting, tdl.humidityPercent,
        tdl.o2_percent, tdl.power, tdl.logged_dt, tdl.received_dt
    FROM dbo.temperature_data_latest tdl
    INNER JOIN dbo.container c ON c.container_id = tdl.container_id
    LEFT  JOIN dbo.modem m ON m.modem_imei = tdl.modem_imei
    LEFT  JOIN dbo.modem_firmware mf ON mf.modem_ident = m.ident
    LEFT  JOIN dbo.firmware f ON f.ident = mf.firmware_ident
    LEFT  JOIN dbo.company_modem cm ON cm.modem_ident = m.ident
    LEFT  JOIN dbo.vessel v ON v.vessel_id = tdl.vessel_id
    LEFT  JOIN dbo.company_vessel cv ON cv.vessel_ident = v.ident
    LEFT  JOIN dbo.company cy ON cy.ident = cm.company_ident OR cy.ident = cv.company_ident
    ORDER BY tdl.logged_dt DESC;

    -- temperature_data_history
    SELECT 
        cy.company_name, v.vessel_id, v.vessel_name, c.container_id,
        m.modem_imei, m.model, m.manufacturer, f.firmware_version,
        tdh.temperatureF, tdh.co2_percent, tdh.deforsting, tdh.humidityPercent,
        tdh.o2_percent, tdh.power, tdh.logged_dt, tdh.received_dt
    FROM dbo.temperature_data_history tdh
    INNER JOIN dbo.container c ON c.container_id = tdh.container_id
    LEFT  JOIN dbo.modem m ON m.modem_imei = tdh.modem_imei
    LEFT  JOIN dbo.modem_firmware mf ON mf.modem_ident = m.ident
    LEFT  JOIN dbo.firmware f ON f.ident = mf.firmware_ident
    LEFT  JOIN dbo.company_modem cm ON cm.modem_ident = m.ident
    LEFT  JOIN dbo.vessel v ON v.vessel_id = tdh.vessel_id
    LEFT  JOIN dbo.company_vessel cv ON cv.vessel_ident = v.ident
    LEFT  JOIN dbo.company cy ON cy.ident = cm.company_ident OR cy.ident = cv.company_ident
    ORDER BY tdh.logged_dt DESC;

END TRY
BEGIN CATCH
    -- Bubble up details for VS output
    DECLARE @msg NVARCHAR(4000) = ERROR_MESSAGE();
    RAISERROR(@msg, 16, 1);
END CATCH;
