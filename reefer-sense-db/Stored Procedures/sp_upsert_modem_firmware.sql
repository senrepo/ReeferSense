CREATE PROCEDURE [dbo].[sp_upsert_modem_firmware]
    @modem_ident INT,
    @firmware_ident INT,
    @modem_firmware_ident INT = NULL
AS
BEGIN

        BEGIN TRANSACTION;
            BEGIN TRY
            -- Validate firmware_ident and modem_ident are NOT NULL
                 IF @firmware_ident IS NULL OR @modem_ident IS NULL
        BEGIN
            PRINT 'Error: company_ident and modem_ident cannot be NULL.';
            ROLLBACK TRANSACTION;
            SELECT -1 AS RESULT;
            RETURN;
        END

           
        DECLARE @existing_modem_firmware_ident INT;
        -- Check if record exists
        IF @modem_firmware_ident IS NULL
        BEGIN
            SELECT @modem_firmware_ident = @existing_modem_firmware_ident
            FROM dbo.modem_firmware
            WHERE modem_ident = @modem_ident AND firmware_ident = @firmware_ident;
       
       IF @modem_firmware_ident IS NOT NULL
        BEGIN
            UPDATE dbo.modem_firmware
            SET firmware_ident = @firmware_ident,
                modem_ident = @modem_ident
            WHERE @modem_firmware_ident = @existing_modem_firmware_ident;
        END
   ELSE
            BEGIN
                -- Insert new record
                INSERT INTO dbo.modem_firmware(modem_ident, firmware_ident, created_dt)
                VALUES (@modem_ident, @firmware_ident, GETDATE());

           END
        END
        ELSE
        BEGIN
            -- If @modem_ident is provided, update the existing record
            IF EXISTS (SELECT 1 FROM dbo.modem_firmware WHERE @existing_modem_firmware_ident = @modem_firmware_ident)
            BEGIN
                UPDATE dbo.modem_firmware
                SET modem_ident = @modem_ident , firmware_ident = @firmware_ident
                WHERE @existing_modem_firmware_ident = @modem_firmware_ident;

            END
            ELSE
            BEGIN
                -- If @modem_ident does not exist, return 0 indicating no operation performed
                ROLLBACK TRANSACTION;
                SELECT 0 AS RESULT;
                RETURN 0;
            END
        END
        COMMIT TRANSACTION;
        SELECT 1 AS Result;
        RETURN 1;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;



-- Test Case 
DECLARE	@return_value int
-- Valid Insert
EXEC	@return_value = [dbo].[sp_upsert_modem_firmware]
		@modem_ident = 1,
		@firmware_ident = 1,
		@modem_firmware_ident = NULL
IF @return_value = 1 PRINT 'Success: Scenario 1';
ELSE PRINT 'Failure: Scenario 1';

SELECT	'Return Value' = @return_value


-- Test Case 2: Valid Update
EXEC	@return_value = [dbo].[sp_upsert_modem_firmware]
		@modem_ident = 12,
		@firmware_ident = 1,
		@modem_firmware_ident = 5
IF @return_value = 1 PRINT 'Success: Scenario 1 ';
ELSE PRINT 'Failure: Scenario 1 ';

SELECT	'Return Value' = @return_value


--Invalid Modem Ident
EXEC	@return_value = [dbo].[sp_upsert_modem_firmware]
		@modem_ident = 99,
		@firmware_ident = 12,
		@modem_firmware_ident = NULL
IF @return_value = 0 PRINT 'Success: Scenario 0';
ELSE PRINT 'Failure: Scenario 0 ';

SELECT	'Return Value' = @return_value


-- Test Case 4: Invalid Firmware Ident
EXEC	@return_value = [dbo].[sp_upsert_modem_firmware]
		@modem_ident = 1,
		@firmware_ident = 88,
		@modem_firmware_ident = NULL
IF @return_value = 0 PRINT 'Success: Scenario 0';
ELSE PRINT 'Failure: Scenario 0 ';

SELECT	'Return Value' = @return_value


-- Test Case 5: Null Modem Ident or Firmware Ident
EXEC	@return_value = [dbo].[sp_upsert_modem_firmware]
		@modem_ident = NULL,
		@firmware_ident = NULL,
		@modem_firmware_ident = NULL
IF @return_value = -1 PRINT 'Success: Scenario -1';
ELSE PRINT 'Failure: Scenario -1 ';

SELECT	'Return Value' = @return_value

-- Cleanup: Remove test data 
DELETE FROM dbo.modem_firmware WHERE ident in (1 );
GO


--CREATE PROCEDURE [dbo].[sp_upsert_modem_firmware]
--    @modem_ident INT,
--    @firmware_ident INT,
--    @modem_firmware_ident INT = NULL
--AS
--BEGIN
--    BEGIN TRANSACTION;
--    BEGIN TRY
--         Validate @firmware_ident and @modem_ident
--        IF @firmware_ident IS NULL OR @modem_ident IS NULL
--        BEGIN
--            PRINT 'Error: company_ident and modem_ident cannot be NULL.';
--            ROLLBACK TRANSACTION;
--            SELECT -1 AS RESULT;
--            RETURN;
--        END

--         Ensure @modem_firmware_ident exists in the dbo.modem_firmware table
--        IF NOT EXISTS (SELECT 1 FROM dbo.modem_firmware WHERE ident = @modem_firmware_ident)
--        BEGIN
--            PRINT 'Error: The provided company_ident does not exist in the company table.';
--            ROLLBACK TRANSACTION;
--            SELECT 0 AS RESULT;
--            RETURN;
--        END

--        DECLARE @existing_modem_firmware_ident INT;

--         Check if the entry already exists
--        IF @modem_firmware_ident IS NULL
--        BEGIN
--            SELECT @existing_modem_firmware_ident = @modem_firmware_ident  
--            FROM dbo.modem_firmware
--            WHERE modem_ident = @modem_ident AND firmware_ident = @firmware_ident;
--        END
--        ELSE
--        BEGIN
--            SET @existing_modem_firmware_ident = @modem_firmware_ident;
--        END
       
--         If record exists, update it
--        IF @existing_modem_firmware_ident IS NOT NULL
--        BEGIN
--            UPDATE dbo.modem_firmware
--            SET modem_ident = @modem_ident,
--                firmware_ident = @firmware_ident
--            WHERE @modem_firmware_ident = @existing_modem_firmware_ident; 
--        END
--        ELSE
--        BEGIN
--            DECLARE @InsertedId TABLE (modem_firmware_ident INT);

--             Insert new record and capture the new ID
--            INSERT INTO dbo.modem_firmware (modem_ident, firmware_ident, created_dt)
--            OUTPUT INSERTED.ident INTO @InsertedId
--            VALUES (@modem_ident, @firmware_ident, GETDATE());

--             Retrieve the newly inserted ID
--            SET @existing_modem_firmware_ident = (SELECT modem_firmware_ident FROM @InsertedId);
--        END

--         Commit transaction and return ID
--        COMMIT TRANSACTION;
--          SELECT @existing_modem_firmware_ident = @modem_firmware_ident FROM dbo.modem_firmware;
--RETURN 1;
--    END TRY
--    BEGIN CATCH
--        ROLLBACK TRANSACTION;
--        THROW;
--    END CATCH;
--END;


