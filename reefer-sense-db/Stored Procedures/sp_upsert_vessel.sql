CREATE PROCEDURE [dbo].[sp_upsert_vessel]
    @vessel_id VARCHAR(25),
    @vessel_name VARCHAR(50),
    @vessel_ident INT = NULL
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validate @vessel_name and @vessel_id are not NULL
        IF @vessel_id IS NULL OR @vessel_name IS NULL
        BEGIN
            PRINT 'Vessel ID and Vessel Name cannot be null.';
            ROLLBACK TRANSACTION;
            SELECT -1 AS RESULT;
            RETURN -1; -- Indicating an error
        END

        DECLARE @existing_vessel_ident INT;

        -- If @vessel_ident is NULL, check if the vessel exists based on @vessel_name and @vessel_id
        IF @vessel_ident IS NULL
        BEGIN
            SELECT @existing_vessel_ident = @vessel_ident 
            FROM dbo.vessel 
            WHERE vessel_id = @vessel_id;

            IF @existing_vessel_ident IS NOT NULL
            BEGIN
                -- Update existing record
                UPDATE dbo.vessel
                SET vessel_name = @vessel_name
                WHERE @vessel_ident = @existing_vessel_ident;

            END
            ELSE
            BEGIN
                -- Insert new record
                INSERT INTO dbo.vessel (vessel_id, vessel_name, created_dt)
                VALUES (@vessel_id, @vessel_name, GETDATE());

           END
        END
        ELSE
        BEGIN
            -- If @vessel_ident is provided, update the existing record
            IF EXISTS (SELECT 1 FROM dbo.vessel WHERE @existing_vessel_ident = @vessel_ident)
            BEGIN
                UPDATE dbo.vessel
                SET vessel_name = @vessel_name , vessel_id = @vessel_id
                WHERE @existing_vessel_ident = @vessel_ident;

            END
            ELSE
            BEGIN
                -- If @vessel_ident does not exist, return 0 indicating no operation performed
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



/*TEST CASE */

DECLARE @return_value INT;

/* 
Scenario 1: Insert a new vessel
Expected: Success (returns 1)
*/
EXEC	@return_value = [dbo].[sp_upsert_vessel]
		@vessel_id = 'MSCVSL002',
		@vessel_name = 'MSC PACIFIC REEFER',
		@vessel_ident = NULL
IF @return_value = 1 PRINT 'Success: Inserted a new vessel';
ELSE PRINT 'Failure: Insert test case failed';
--SELECT	'Return Value' = @return_value


/* 
Scenario 2: Try inserting an existing vessel
Expected: Update existing record (returns 1)
*/


EXEC	@return_value = [dbo].[sp_upsert_vessel]
		@vessel_id = 'MSCVSL002',
		@vessel_name = 'MSC PACIFIC REEFER',
		@vessel_ident = NULL
IF @return_value = 1 PRINT 'Success: Updated a new vessel';
ELSE PRINT 'Failure: update test case failed';
--SELECT	'Return Value' = @return_value


/*
Scenario 3: Update an existing vessel using vessel 
Expected: Success (returns 1)
*/



/*
Scenario 4: Try updating a non-existent vessel_ident 
Expected: Failure (returns 0)
*/

EXEC	@return_value = [dbo].[sp_upsert_vessel]
		@vessel_id = 'MSCVSL002',
		@vessel_name = 'MSC PACIFIC REEFER',
		@vessel_ident = NULL
IF @return_value = 1 PRINT 'Success: Updated a new vessel';
ELSE PRINT 'Failure: update test case failed';
--SELECT	'Return Value' = @return_value



EXEC	@return_value = [dbo].[sp_upsert_vessel]
		@vessel_id = N'MSCVSL002',
		@vessel_name = N'Unknown Vessel',
		@vessel_ident = -23;
	IF @return_value = 0 PRINT 'SUCCESS'
	ELSE PRINT 'FAILURE'

SELECT	'Return Value' = @return_value




/*
Scenario 5: Try inserting a Vessel with NULL name 
Expected: Failure (returns -1)
*/
EXEC	@return_value = [dbo].[sp_upsert_vessel]
		@vessel_id = NULL,
		@vessel_name = NULL,
		@vessel_ident = NULL

SELECT	'Return Value' = @return_value



-- Cleanup: Remove test data 
DELETE FROM dbo.vessel WHERE vessel_name in ('MSC PACIFIC REEFER', 'Unknown Corp');
Go