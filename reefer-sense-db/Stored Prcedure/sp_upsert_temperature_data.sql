
--The latest table always has the most recent record for each container_id and modem_imei.
-- history table keeps track of all records, including the latest one.

CREATE PROCEDURE [dbo].[sp_upsert_temperature_data]
	
	@container_id VARCHAR(12),
	@modem_imei VARCHAR(15),
	@vessel_id VARCHAR(25),
	@temperatureF DECIMAL(5,2),
	@logged_dt DATETIME2(7),
	@power BIT,
	@battery_percent SMALLINT,
	@co2_percent SMALLINT,
	@o2_percent SMALLINT,
	@deforsting BIT,
	@humidityPercent SMALLINT


AS

BEGIN

    BEGIN TRANSACTION; -- Starts the transaction.

    BEGIN TRY
         -- Insert the record into the history table to maintain all historical record
	
	INSERT INTO dbo.temperature_data_history (
        container_id, modem_imei, vessel_id, temperatureF, logged_dt, 
        power, battery_percent, co2_percent, o2_percent, deforsting, humidityPercent, received_dt
    )
    VALUES (
        @container_id, @modem_imei, @vessel_id, @temperatureF, @logged_dt, 
        @power, @battery_percent, @co2_percent, @o2_percent, @deforsting, @humidityPercent, GETDATE()
    );

	 -- Upsert into latest table (Check if a record exists in the latest table using EXISTS())
     --  If a record exists → Update it with the latest values.
    IF EXISTS (
        SELECT 1 FROM dbo.temperature_data_latest 
        WHERE container_id = @container_id AND modem_imei = @modem_imei AND vessel_id = @vessel_id
    )
    BEGIN
        -- Update existing record (Update the latest table if the record already exists.)
        UPDATE dbo.temperature_data_latest
        SET 
            temperatureF = @temperatureF,
            logged_dt = @logged_dt,
            power = @power,
            battery_percent = @battery_percent,
            co2_percent = @co2_percent,
            o2_percent = @o2_percent,
            deforsting = @deforsting,
            humidityPercent = @humidityPercent,
            received_dt = GETDATE()
        WHERE 
            container_id = @container_id AND modem_imei = @modem_imei AND vessel_id = @vessel_id;
    END
     -- Insert new record if not exists (Insert a new record into the latest table if there is no existing entry.)
     --  If no record exists → Insert a new one (if an ELSE block is added).
    ELSE
    BEGIN

        INSERT INTO dbo.temperature_data_latest (
            container_id, modem_imei, vessel_id, temperatureF, logged_dt, 
            power, battery_percent, co2_percent, o2_percent, deforsting, humidityPercent, received_dt
        )
        VALUES (
            @container_id, @modem_imei, @vessel_id, @temperatureF, @logged_dt, 
            @power, @battery_percent, @co2_percent, @o2_percent, @deforsting, @humidityPercent, GETDATE()
        );
    END
-- Commit the transaction if everything is successful
    COMMIT TRANSACTION; --if everything succeeds.

    END TRY

    BEGIN CATCH --Error Handling
        -- Rollback the transaction in case of an error
    ROLLBACK TRANSACTION; -- if any error occurs (undoes all changes).

      -- Return the error message
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE(); --Provides the error message text.
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY(); --Ensures that the error severity is maintained.
        DECLARE @ErrorState INT = ERROR_STATE(); -- Preserves the original error state.

        -- Print the error (Optional: You can log it in an error table)
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

        END CATCH

RETURN 0;

END