CREATE PROCEDURE [dbo].[sp_upsert_modem_firmware]
	
    @modem_imei VARCHAR(15),
    @firmware_version VARCHAR(25)
AS
BEGIN
    --SET NOCOUNT ON;

    DECLARE @modem_ident INT, @firmware_ident INT;

    -- Fetch modem_ident and firmware_ident
    SELECT @modem_ident = ident FROM modem WHERE modem_imei = @modem_imei;
    SELECT @firmware_ident = ident FROM firmware WHERE firmware_version = @firmware_version;

    -- Ensure both identifiers exist before proceeding
    IF @modem_ident IS NOT NULL AND @firmware_ident IS NOT NULL
    BEGIN
        -- Check if the record already exists in modem_firmware
        IF NOT EXISTS (SELECT 1 FROM dbo.modem_firmware WHERE modem_ident = @modem_ident AND firmware_ident = @firmware_ident)
        BEGIN
            -- Insert new record if it does not exist
            INSERT INTO dbo.modem_firmware (modem_ident, firmware_ident, created_dt) 
            VALUES (@modem_ident, @firmware_ident, GETDATE());
        END
        ELSE
        BEGIN
            -- Upsert logic: Update existing record if needed
            UPDATE dbo.modem_firmware
            SET created_dt = GETDATE()
            WHERE modem_ident = @modem_ident AND firmware_ident = @firmware_ident;
        END
    END
END;


