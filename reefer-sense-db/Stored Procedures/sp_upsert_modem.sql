CREATE PROCEDURE [dbo].[sp_upsert_modem]
    @modem_imei VARCHAR(15),
    @model VARCHAR(25),
    @manufacturer VARCHAR(50),
    @modem_ident INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

        BEGIN TRY

    -- Validate input parameters
    IF @modem_imei IS NULL OR @model IS NULL OR @manufacturer IS NULL
    BEGIN
        PRINT 'IMEI, Model, and Manufacturer cannot be NULL';
        ROLLBACK TRANSACTION;
        SELECT -1 AS RESULT;
        RETURN -1;
        
    END
    
    DECLARE @existing_ident INT;

    -- If @modem_ident is NULL, check if the modem exists
    IF @modem_ident IS NULL
    BEGIN
        SELECT @existing_ident = @modem_ident 
        FROM modem
        WHERE modem_imei = @modem_imei AND model = @model AND manufacturer = @manufacturer;

        IF @existing_ident IS NOT NULL
        BEGIN
            -- Update existing record
            UPDATE modem
            SET modem_imei = @modem_imei, 
                model = @model, 
                manufacturer = @manufacturer
            WHERE @modem_ident = @existing_ident;
            PRINT 'Existing modem updated';
        END
        ELSE
        BEGIN
            -- Insert new record
            INSERT INTO modem (modem_imei, model, manufacturer, created_dt)
            VALUES (@modem_imei, @model, @manufacturer, GETDATE());
            PRINT 'New modem inserted';
        END
    END
    ELSE
    BEGIN
        -- If @modem_ident is provided, update the existing record
        IF EXISTS (SELECT 1 FROM modem WHERE @existing_ident = @modem_ident)
        BEGIN
            UPDATE modem
            SET modem_imei = @modem_imei, 
                model = @model, 
                manufacturer = @manufacturer
            WHERE @existing_ident = @modem_ident;
            PRINT 'Modem updated';
        END
        ELSE
        BEGIN
            -- If @modem_ident does not exist, return 0
            PRINT 'No operation performed: Modem ID not found';
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
END




/*TEST CASE */

DECLARE @return_value INT;

/* 
Scenario 1: Insert a new modem
Expected: Success (returns 1)
*/
EXEC	@return_value = [dbo].[sp_upsert_modem]
		@modem_imei = '543216789012345',
		@model = 'rmmw',
		@manufacturer = 'copeland'
IF @return_value = 1 PRINT 'Success: Inserted a new vessel';
ELSE PRINT 'Failure: Insert test case failed';

SELECT @return_value AS [Return Value];


/* 
Scenario 2: Try inserting an existing modem
Expected: Update existing record (returns 1)
*/
EXEC @return_value = [dbo].[sp_upsert_modem]
    @modem_imei = '450123451238311',
    @model = 'rmmw',
    @manufacturer = 'CMA CGM',
    @modem_ident = NULL;
IF @return_value = 1 PRINT 'Success: Inserted a new vessel';
ELSE PRINT 'Failure: Insert test case failed';

SELECT @return_value AS [Return Value]


/*
Scenario 3: Update an existing modem using modem_imei 
Expected: Success (returns 1)
*/
EXEC @return_value = [dbo].[sp_upsert_modem]
    @modem_imei = '450123451238311',
    @model = 'rmmw',
    @manufacturer = 'Copeland',
    @modem_ident = NULL;
IF @return_value = 1 PRINT 'Success: Inserted a new vessel';
ELSE PRINT 'Failure: Insert test case failed';

SELECT @return_value AS [Return Value]



/*
Scenario 4: Try updating a non-existent modem_ident 
Expected: Failure (returns 0)
*/
EXEC	@return_value = [dbo].[sp_upsert_modem]
		@modem_imei = N'678901234512345',
		@model = N'rmmw',
		@manufacturer = N'CMA CGM',
		@modem_ident = 1
IF @return_value = 0 PRINT 'Success: Inserted a new vessel';
ELSE PRINT 'Failure: Insert test case failed';

SELECT	'Return Value' = @return_value


/*
Scenario 5: Try inserting a modem with NULL name 
Expected: Failure (returns -1)
*/
EXEC	@return_value = [dbo].[sp_upsert_modem]
		@modem_imei = NULL,
		@model = N'rmmw',
		@manufacturer = N'CMA',
		@modem_ident = NULL
IF @return_value = -1 PRINT 'Success: Inserted a new vessel';
ELSE PRINT 'Failure: Insert test case failed';

SELECT	'Return Value' = @return_value



-- Cleanup: Remove test data 
DELETE FROM dbo.modem WHERE manufacturer in ('copeland', 'CMA CGM');
