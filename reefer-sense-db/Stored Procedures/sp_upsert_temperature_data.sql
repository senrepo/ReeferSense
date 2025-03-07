CREATE PROCEDURE [dbo].[sp_upsert_temperature_data]
    @container_id VARCHAR(12),
    @modem_imei VARCHAR(15),
    @vessel_id VARCHAR(25),
    @temperatureF SMALLINT,
    @logged_dt DATETIME2(7),
    @power BIT,
    @battery_percent SMALLINT,
    @co2_percent SMALLINT,
    @o2_percent SMALLINT,
    @deforsting BIT,
    @humidityPercent SMALLINT
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validate input
        IF @container_id IS NULL OR (@modem_imei IS NULL AND @vessel_id IS NULL)
        BEGIN
            PRINT 'Container Id cannot be null, and either Modem IMEI or Vessel ID should exist';
            ROLLBACK TRANSACTION;
            RETURN -1;
        END

        -- Check if the record already exists
        IF EXISTS (
            SELECT 1 FROM dbo.temperature_data_history 
            WHERE container_id = @container_id 
              AND (modem_imei = @modem_imei OR (modem_imei IS NULL AND @modem_imei IS NULL)) 
              AND (vessel_id = @vessel_id OR (vessel_id IS NULL AND @vessel_id IS NULL)) 
              AND DATEDIFF(SECOND, logged_dt, @logged_dt) = 0  
              AND temperatureF = @temperatureF
              AND power = @power
              AND battery_percent = @battery_percent
              AND co2_percent = @co2_percent
              AND o2_percent = @o2_percent
              AND deforsting = @deforsting
              AND humidityPercent = @humidityPercent
        )
        BEGIN
            PRINT 'Duplicate record found. No update or insert required.';
            ROLLBACK TRANSACTION;
            RETURN 0;
        END
        ELSE
        BEGIN
            -- Upsert into history table
            MERGE dbo.temperature_data_history AS target
            USING (SELECT @container_id AS container_id, @modem_imei AS modem_imei, @vessel_id AS vessel_id, @logged_dt AS logged_dt) AS source
            ON target.container_id = source.container_id 
               AND (target.modem_imei = source.modem_imei OR (target.modem_imei IS NULL AND source.modem_imei IS NULL))
               AND (target.vessel_id = source.vessel_id OR (target.vessel_id IS NULL AND source.vessel_id IS NULL))
               AND target.logged_dt = source.logged_dt
            WHEN MATCHED THEN
                UPDATE SET 
                    temperatureF = @temperatureF,
                    power = @power,
                    battery_percent = @battery_percent,
                    co2_percent = @co2_percent,
                    o2_percent = @o2_percent,
                    deforsting = @deforsting,
                    humidityPercent = @humidityPercent,
                    received_dt = GETDATE()
            WHEN NOT MATCHED THEN
                INSERT (container_id, modem_imei, vessel_id, temperatureF, logged_dt, power, battery_percent, co2_percent, o2_percent, deforsting, humidityPercent, received_dt)
                VALUES (@container_id, @modem_imei, @vessel_id, @temperatureF, @logged_dt, @power, @battery_percent, @co2_percent, @o2_percent, @deforsting, @humidityPercent, GETDATE());

            -- Upsert into latest table
            MERGE dbo.temperature_data_latest AS target
            USING (SELECT @container_id AS container_id, @modem_imei AS modem_imei, @vessel_id AS vessel_id) AS source
            ON target.container_id = source.container_id 
               AND (target.modem_imei = source.modem_imei OR (target.modem_imei IS NULL AND source.modem_imei IS NULL))
               AND (target.vessel_id = source.vessel_id OR (target.vessel_id IS NULL AND source.vessel_id IS NULL))
            WHEN MATCHED THEN
                UPDATE SET 
                    temperatureF = @temperatureF,
                    logged_dt = @logged_dt,
                    power = @power,
                    battery_percent = @battery_percent,
                    co2_percent = @co2_percent,
                    o2_percent = @o2_percent,
                    deforsting = @deforsting,
                    humidityPercent = @humidityPercent,
                    received_dt = GETDATE()
            WHEN NOT MATCHED THEN
                INSERT (container_id, modem_imei, vessel_id, temperatureF, logged_dt, power, battery_percent, co2_percent, o2_percent, deforsting, humidityPercent, received_dt)
                VALUES (@container_id, @modem_imei, @vessel_id, @temperatureF, @logged_dt, @power, @battery_percent, @co2_percent, @o2_percent, @deforsting, @humidityPercent, GETDATE());
        END

        COMMIT TRANSACTION;
        RETURN 1;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

/* TEST CASE */

DECLARE @return_value INT;
DECLARE @test_logged_dt DATETIME2(7) = GETDATE();

/* 
Scenario 1: Insert a new temperature record 
Expected: Success (returns 1)
*/
EXEC @return_value = sp_upsert_temperature_data
    @container_id = 'CMA202400011',
    @modem_imei = '350123451234560',
    @vessel_id = NULL,
    @temperatureF = 75,
    @logged_dt = @test_logged_dt,
    @power = 1,
    @battery_percent = 90,
    @co2_percent = 5,
    @o2_percent = 20,
    @deforsting = 0,
    @humidityPercent = 55;

IF @return_value = 1 PRINT 'Success: Scenario 1 - Inserted new temperature record';
ELSE PRINT 'Failure: Scenario 1 - Inserted new temperature record';

/*
Scenario 2: Insert a duplicate record (same container_id, modem_imei, vessel_id, and logged_dt)
Expected: No update/insert required (returns 0)
*/
EXEC @return_value = sp_upsert_temperature_data
    @container_id = 'CMA202400011',
    @modem_imei = '350123451234560',
    @vessel_id = NULL,
    @temperatureF = 75,
    @logged_dt = @test_logged_dt,
    @power = 1,
    @battery_percent = 90,
    @co2_percent = 5,
    @o2_percent = 20,
    @deforsting = 0,
    @humidityPercent = 55;

IF @return_value = 0 PRINT 'Success: Scenario 2 - Duplicate record found, no action taken';
ELSE PRINT 'Failure: Scenario 2 - Duplicate record should not have been inserted';

/*
Scenario 3: Insert a new record with a different temperature but same container_id and logged_dt
Expected: Success (returns 1)
*/
EXEC @return_value = sp_upsert_temperature_data
    @container_id = 'CMA202400011',
    @modem_imei = '350123451234560',
    @vessel_id = NULL,
    @temperatureF = 80, -- Changed temperature
    @logged_dt = @test_logged_dt,
    @power = 1,
    @battery_percent = 90,
    @co2_percent = 5,
    @o2_percent = 20,
    @deforsting = 0,
    @humidityPercent = 55;

IF @return_value = 1 PRINT 'Success: Scenario 3 - Inserted a new record with different temperature';
ELSE PRINT 'Failure: Scenario 3 - Insert failed for new temperature';

/*
Scenario 4: Update an existing record by changing the humidity percent
Expected: Success (returns 1)
*/
EXEC @return_value = sp_upsert_temperature_data
    @container_id = 'CMA202400011',
    @modem_imei = '350123451234560',
    @vessel_id = NULL,
    @temperatureF = 80,
    @logged_dt = @test_logged_dt,
    @power = 1,
    @battery_percent = 90,
    @co2_percent = 5,
    @o2_percent = 20,
    @deforsting = 0,
    @humidityPercent = 60; -- Changed humidity percent

IF @return_value = 1 PRINT 'Success: Scenario 4 - Updated existing record with new humidity percent';
ELSE PRINT 'Failure: Scenario 4 - Update failed';

/*
Scenario 5: Try inserting a record with NULL container_id
Expected: Error (returns -1)
*/
EXEC @return_value = sp_upsert_temperature_data
    @container_id = NULL,  -- NULL container_id
    @modem_imei = '350123451234560',
    @vessel_id = NULL,
    @temperatureF = 70,
    @logged_dt = @test_logged_dt,
    @power = 1,
    @battery_percent = 80,
    @co2_percent = 4,
    @o2_percent = 19,
    @deforsting = 1,
    @humidityPercent = 50;

IF @return_value = -1 PRINT 'Success: Scenario 5 - Container ID validation error triggered';
ELSE PRINT 'Failure: Scenario 5 - Container ID validation did not work';

/*
Scenario 6: Insert a record using vessel_id instead of modem_imei
Expected: Success (returns 1)
*/
EXEC @return_value = sp_upsert_temperature_data
    @container_id = 'CMA202400011',
    @modem_imei = NULL,  -- No modem IMEI
    @vessel_id = 'CMAVSL001',
    @temperatureF = 72,
    @logged_dt = @test_logged_dt,
    @power = 1,
    @battery_percent = 85,
    @co2_percent = 6,
    @o2_percent = 18,
    @deforsting = 0,
    @humidityPercent = 58;

IF @return_value = 1 PRINT 'Success: Scenario 6 - Inserted record using Vessel ID';
ELSE PRINT 'Failure: Scenario 6 - Insert using Vessel ID failed';

/*
Scenario 7: Insert a record with both modem_imei and vessel_id NULL
Expected: Error (returns -1)
*/
EXEC @return_value = sp_upsert_temperature_data
    @container_id = 'CMA202400011',
    @modem_imei = NULL,
    @vessel_id = NULL,
    @temperatureF = 68,
    @logged_dt = @test_logged_dt,
    @power = 1,
    @battery_percent = 75,
    @co2_percent = 3,
    @o2_percent = 22,
    @deforsting = 1,
    @humidityPercent = 48;

IF @return_value = -1 PRINT 'Success: Scenario 7 - Validation failed for missing Modem IMEI and Vessel ID';
ELSE PRINT 'Failure: Scenario 7 - Validation did not trigger for missing identifiers';

GO