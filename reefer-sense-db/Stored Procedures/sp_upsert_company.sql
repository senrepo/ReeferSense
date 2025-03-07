CREATE PROCEDURE [dbo].[sp_upsert_company]
    @company_name VARCHAR(50),
    @company_ident INT = NULL  -- Allow NULL values for new records
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @existing_company_ident INT;

        -- Validate @company_name is not NULL
        IF @company_name IS NULL
        BEGIN
            PRINT 'Company name cannot be null.';
            ROLLBACK TRANSACTION;
            RETURN -1;  -- Indicating an error
        END

        -- If @company_ident is NULL, check if the company exists based on @company_name
        IF @company_ident IS NULL
        BEGIN
            SELECT @existing_company_ident = ident FROM company WHERE company_name = @company_name;

            IF @existing_company_ident IS NOT NULL
            BEGIN
                -- Update existing record
                UPDATE company
                SET company_name = @company_name
                WHERE ident = @existing_company_ident;
            END
            ELSE
            BEGIN
                -- Insert new record
                INSERT INTO company (company_name, created_dt)
                VALUES (@company_name, GETDATE());
            END
        END
        ELSE
        BEGIN
            -- If @company_ident is provided, update the existing record
            IF EXISTS (SELECT 1 FROM company WHERE ident = @company_ident)
            BEGIN
                UPDATE company
                SET company_name = @company_name
                WHERE ident = @company_ident;
            END
            ELSE
            BEGIN
                -- If @company_ident does not exist, return 0 indicating no operation performed
                ROLLBACK TRANSACTION;
                RETURN 0;
            END
        END

        -- If everything succeeds, commit the transaction
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

/* 
Scenario 1: Insert a new company 
Expected: Success (returns 1)
*/
EXEC @return_value = sp_upsert_company
    @company_name = 'Titan Corp',
    @company_ident = NULL;

IF @return_value = 1 PRINT 'Success: Scenario 1 - Inserted new company';
ELSE PRINT 'Failure: Scenario 1 - Insert new company failed';

/* 
Scenario 2: Try inserting an existing company 
Expected: Update existing record (returns 1)
*/
EXEC @return_value = sp_upsert_company
    @company_name = 'Titan Corp',
    @company_ident = NULL;

IF @return_value = 1 PRINT 'Success: Scenario 2 - Existing company updated';
ELSE PRINT 'Failure: Scenario 2 - Existing company update failed';

/*
Scenario 3: Update an existing company using company_ident 
Expected: Success (returns 1)
*/
DECLARE @existing_ident INT;
SELECT @existing_ident = ident FROM company WHERE company_name = 'Titan Corp';

EXEC @return_value = sp_upsert_company
    @company_name = 'Titan Global',
    @company_ident = @existing_ident;

IF @return_value = 1 PRINT 'Success: Scenario 3 - Updated company name';
ELSE PRINT 'Failure: Scenario 3 - Update company name failed';

/*
Scenario 4: Try updating a non-existent company_ident 
Expected: Failure (returns 0)
*/
EXEC @return_value = sp_upsert_company
    @company_name = 'Unknown Corp',
    @company_ident = -9999;

IF @return_value = 0 PRINT 'Success: Scenario 4 - No operation performed for non-existent company_ident';
ELSE PRINT 'Failure: Scenario 4 - Unexpected behavior for non-existent company_ident';

/*
Scenario 5: Try inserting a company with NULL name 
Expected: Failure (returns -1)
*/
EXEC @return_value = sp_upsert_company
    @company_name = NULL,
    @company_ident = NULL;

IF @return_value = -1 PRINT 'Success: Scenario 5 - Validation error triggered for NULL company_name';
ELSE PRINT 'Failure: Scenario 5 - NULL company_name validation did not work';

GO
