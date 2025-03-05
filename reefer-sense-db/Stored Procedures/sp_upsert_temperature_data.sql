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
        
        IF EXISTS (
            SELECT 1 FROM dbo.temperature_data_history 
            WHERE container_id = @container_id 
              AND modem_imei = @modem_imei 
              AND vessel_id = @vessel_id 
              AND logged_dt = @logged_dt
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
        END
        ELSE
        BEGIN
            
            MERGE dbo.temperature_data_history AS target
            USING (SELECT @container_id AS container_id, 
                          @modem_imei AS modem_imei, 
                          @vessel_id AS vessel_id,
                          @logged_dt AS logged_dt) AS source
            ON target.container_id = source.container_id 
               AND target.modem_imei = source.modem_imei 
               AND target.vessel_id = source.vessel_id
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
                INSERT (container_id, modem_imei, vessel_id, temperatureF, logged_dt, 
                        power, battery_percent, co2_percent, o2_percent, deforsting, humidityPercent, received_dt)
                VALUES (@container_id, @modem_imei, @vessel_id, @temperatureF, @logged_dt, 
                        @power, @battery_percent, @co2_percent, @o2_percent, @deforsting, @humidityPercent, GETDATE());

            
            MERGE dbo.temperature_data_latest AS target
            USING (SELECT @container_id AS container_id, 
                          @modem_imei AS modem_imei, 
                          @vessel_id AS vessel_id) AS source
            ON target.container_id = source.container_id 
               AND target.modem_imei = source.modem_imei 
               AND target.vessel_id = source.vessel_id
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
                INSERT (container_id, modem_imei, vessel_id, temperatureF, logged_dt, 
                        power, battery_percent, co2_percent, o2_percent, deforsting, humidityPercent, received_dt)
                VALUES (@container_id, @modem_imei, @vessel_id, @temperatureF, @logged_dt, 
                        @power, @battery_percent, @co2_percent, @o2_percent, @deforsting, @humidityPercent, GETDATE());
        END

        COMMIT TRANSACTION;
        RETURN 1;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

       
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY(); 
        DECLARE @ErrorState INT = ERROR_STATE();

        
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

        RETURN -1;
    END CATCH
END
