CREATE PROCEDURE [dbo].[sp_upsert_company_modem]
    @company_ident INT,
    @modem_ident INT,
    @company_modem_ident INT = NULL
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validate @company_ident and @modem_ident
        IF @company_ident IS NULL OR @modem_ident IS NULL
        BEGIN
            PRINT 'Error: company_ident and modem_ident cannot be NULL.';
            ROLLBACK TRANSACTION;
            SELECT -1 AS RESULT;
            RETURN;
        END

        -- Ensure @company_ident exists in the dbo.company table
        IF NOT EXISTS (SELECT 1 FROM dbo.company WHERE ident = @company_ident)
        BEGIN
            PRINT 'Error: The provided company_ident does not exist in the company table.';
            ROLLBACK TRANSACTION;
            SELECT 0 AS RESULT;
            RETURN;
        END

        DECLARE @existing_company_modem_ident INT;

        -- Check if the entry already exists
        IF @company_modem_ident IS NULL
        BEGIN
            SELECT @existing_company_modem_ident = @company_modem_ident  
            FROM dbo.company_modem
            WHERE company_ident = @company_ident AND modem_ident = @modem_ident;
        END
        ELSE
        BEGIN
            SET @existing_company_modem_ident = @company_modem_ident;
        END

        -- If record exists, update it
        IF @existing_company_modem_ident IS NOT NULL
        BEGIN
            UPDATE dbo.company_modem
            SET company_ident = @company_ident,
                modem_ident = @modem_ident
            WHERE @company_modem_ident = @existing_company_modem_ident; 
        END
        ELSE
        BEGIN
            DECLARE @InsertedId TABLE (company_modem_ident INT);

            -- Insert new record and capture the new ID
            INSERT INTO dbo.company_modem (company_ident, modem_ident, created_dt)
            OUTPUT INSERTED.ident INTO @InsertedId
            VALUES (@company_ident, @modem_ident, GETDATE());

            -- Retrieve the newly inserted ID
            SET @existing_company_modem_ident = (SELECT company_modem_ident FROM @InsertedId);
        END

        -- Commit transaction and return ID
        COMMIT TRANSACTION;
          SELECT @existing_company_modem_ident = @company_modem_ident FROM dbo.company_modem;
RETURN 1;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;



/* TEST CASE */
DECLARE	@return_value int


/* 
Scenario 1: Insert a new company_ident 
Expected: Success (returns 1)
*/
EXEC	@return_value = [dbo].[sp_upsert_company_modem]
		@company_ident = 1,
		@modem_ident = 12
IF @return_value = 1 PRINT 'Success: Scenario 1 - Inserted new company';
ELSE PRINT 'Failure: Scenario 1 - Insert new company failed';

SELECT	'Return Value' = @return_value

/* 
Scenario 2: Try inserting an existing company_ident
Expected: Update existing record (returns 1)
*/
EXEC	@return_value = [dbo].[sp_upsert_company_modem]
		@company_ident = 1,
		@modem_ident = 12
IF @return_value = 1 PRINT 'Success: Scenario 1 - Inserted new company';
ELSE PRINT 'Failure: Scenario 1 - Insert new company failed';

SELECT	'Return Value' = @return_value

/*
Scenario 3: Update an existing company_ident using company_modem_ident 
Expected: Success (returns 1)
*/
EXEC	@return_value = [dbo].[sp_upsert_company_modem]
		@company_ident = 2,
		@modem_ident = 12,
		@company_modem_ident = 5
IF @return_value = 1 PRINT 'Success: Scenario 1 - Inserted new company';
ELSE PRINT 'Failure: Scenario 1 - Insert new company failed';

SELECT	'Return Value' = @return_value

/*
Scenario 4: Try updating a non-existent company_modem_ident 
Expected: Failure (returns 0)
*/
EXEC	@return_value = [dbo].[sp_upsert_company_modem]
		@company_ident = 3,
		@modem_ident = 3
IF @return_value = 0 PRINT 'Success: Scenario 1 - Inserted new company';
ELSE PRINT 'Failure: Scenario 1 - Insert new company failed';

SELECT	'Return Value' = @return_value

/*
Scenario 5: Try inserting a company_ident with NULL name 
Expected: Failure (returns -1)
*/
EXEC	@return_value = [dbo].[sp_upsert_company_modem]
		@company_ident = NULL,
		@modem_ident = NULL,
		@company_modem_ident = NULL
IF @return_value = -1 PRINT 'Success: Scenario 1 - Inserted new company';
ELSE PRINT 'Failure: Scenario 1 - Insert new company failed';

SELECT	'Return Value' = @return_value

-- Cleanup: Remove test data 
DELETE FROM dbo.company_modem WHERE @company_ident in (1 , 2);
GO


