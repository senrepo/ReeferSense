CREATE PROCEDURE [dbo].[sp_upsert_company_vessel]
    @company_ident INT,
    @vessel_ident INT,
    @company_vessel_ident INT = NULL
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validate @company_ident and @vessel_ident
        IF @company_ident IS NULL OR @vessel_ident IS NULL
        BEGIN
            PRINT 'Error: company_ident and vessel_ident cannot be NULL.';
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

        DECLARE @existing_company_vessel_ident INT;

        -- If @company_vessel_ident is NULL, check if the entry exists
        IF @company_vessel_ident IS NULL
        BEGIN
            SELECT @existing_company_vessel_ident = @company_vessel_ident
            FROM dbo.company_vessel
            WHERE company_ident = @company_ident AND vessel_ident = @vessel_ident;
        END
        ELSE
        BEGIN
            SET @existing_company_vessel_ident = @company_vessel_ident;
        END

        -- If record exists, update it
        IF @existing_company_vessel_ident IS NOT NULL
        BEGIN
            UPDATE dbo.company_vessel
            SET company_ident = @company_ident,
                vessel_ident = @vessel_ident
            WHERE @company_vessel_ident = @existing_company_vessel_ident;
        END
        ELSE
        BEGIN
            -- Insert new record
            INSERT INTO dbo.company_vessel (company_ident, vessel_ident, created_dt)
            VALUES (@company_ident, @vessel_ident, GETDATE());

            -- Retrieve the newly inserted ID
            SET @existing_company_vessel_ident = SCOPE_IDENTITY();
        END

        -- Commit transaction and return ID
        COMMIT TRANSACTION;
        SELECT @existing_company_vessel_ident AS company_vessel_ident;
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
EXEC	@return_value = [dbo].[sp_upsert_company_vessel]
		@company_ident = 1,
		@vessel_ident = 12
IF @return_value = 1 PRINT 'Success: Scenario 1 - Inserted new company';
ELSE PRINT 'Failure: Scenario 1 - Insert new company failed';

SELECT	'Return Value' = @return_value

/* 
Scenario 2: Try inserting an existing company_ident
Expected: Update existing record (returns 1)
*/
EXEC	@return_value = [dbo].[sp_upsert_company_vessel]
		@company_ident = 1,
		@vessel_ident = 12
IF @return_value = 1 PRINT 'Success: Scenario 1 - Inserted new company';
ELSE PRINT 'Failure: Scenario 1 - Insert new company failed';

SELECT	'Return Value' = @return_value

/*
Scenario 3: Update an existing company_ident using company_vessel_ident 
Expected: Success (returns 1)
*/
EXEC	@return_value = [dbo].[sp_upsert_company_vessel]
		@company_ident = 2,
		@vessel_ident = 4,
		@company_vessel_ident = 5
IF @return_value = 1 PRINT 'Success: Scenario 1 - Inserted new company';
ELSE PRINT 'Failure: Scenario 1 - Insert new company failed';

SELECT	'Return Value' = @return_value

/*
Scenario 4: Try updating a non-existent company_vessel_ident 
Expected: Failure (returns 0)
*/
EXEC	@return_value = [dbo].[sp_upsert_company_vessel]
		@company_ident = 3,
		@vessel_ident = 10
IF @return_value = 0 PRINT 'Success: Scenario 1 - Inserted new company';
ELSE PRINT 'Failure: Scenario 1 - Insert new company failed';

SELECT	'Return Value' = @return_value

/*
Scenario 5: Try inserting a company_ident with NULL name 
Expected: Failure (returns -1)
*/
EXEC	@return_value = [dbo].[sp_upsert_company_vessel]
		@company_ident = NULL,
		@vessel_ident = NULL,
		@company_vessel_ident = NULL
IF @return_value = -1 PRINT 'Success: Scenario 1 - Inserted new company';
ELSE PRINT 'Failure: Scenario 1 - Insert new company failed';

SELECT	'Return Value' = @return_value

-- Cleanup: Remove test data 
DELETE FROM dbo.company_vessel WHERE @company_ident in (1 , 2);
GO
