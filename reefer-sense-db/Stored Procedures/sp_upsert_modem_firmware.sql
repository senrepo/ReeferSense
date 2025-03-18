CREATE PROCEDURE [dbo].[sp_upsert_modem_firmware]
    @modem_ident INT,
    @firmware_ident INT,
    @modem_firmware_ident INT = NULL
AS
BEGIN

        BEGIN TRANSACTION;
            BEGIN TRY
                 IF @firmware_ident IS NULL OR @modem_ident IS NULL
        BEGIN
            PRINT 'Error: company_ident and modem_ident cannot be NULL.';
            ROLLBACK TRANSACTION;
            SELECT -1 AS RESULT;
            RETURN;
        END



        -- Validate modem and firmware
        IF NOT EXISTS (SELECT 1 FROM dbo.modem WHERE ident = @modem_ident)
        BEGIN
            PRINT 'Invalid modem_ident. Modem does not exist.';
            ROLLBACK TRANSACTION;
            SELECT 0 AS RESULT;
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM dbo.firmware WHERE ident = @firmware_ident)
        BEGIN
            PRINT 'Invalid firmware_ident. Firmware does not exist.';
            ROLLBACK TRANSACTION;
            SELECT 0 AS RESULT;
            RETURN;
        END

        DECLARE @exciting_modem_firmware_ident INT;
        -- Check if record exists
        IF @modem_firmware_ident IS NULL
        BEGIN
            SELECT @modem_firmware_ident = @exciting_modem_firmware_ident
            FROM dbo.modem_firmware
            WHERE modem_ident = @modem_ident AND firmware_ident = @firmware_ident;
        END
          ELSE
        BEGIN
            SET @exciting_modem_firmware_ident = @modem_firmware_ident;
        END


        -- If record exists, update it
        IF @modem_firmware_ident IS NOT NULL
        BEGIN
            UPDATE dbo.modem_firmware
            SET firmware_ident = @firmware_ident,
                modem_ident = @modem_ident
            WHERE @modem_firmware_ident = @exciting_modem_firmware_ident;
        END
        ELSE
        BEGIN
            -- Insert new record
                       DECLARE @InsertedId TABLE (modem_firmware_ident INT);

            -- Insert new record and capture the new ID
            INSERT INTO dbo.modem_firmware(firmware_ident, modem_ident, created_dt)
            OUTPUT INSERTED.ident INTO @InsertedId
            VALUES (@firmware_ident, @modem_ident, GETDATE());

            -- Retrieve the newly inserted ID
            SET @exciting_modem_firmware_ident = (SELECT modem_firmware_ident FROM @InsertedId);
        END

        -- Commit transaction and return ID
        COMMIT TRANSACTION;
          SELECT @exciting_modem_firmware_ident = @modem_firmware_ident FROM dbo.modem_firmware;
          RETURN 1;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
