CREATE PROCEDURE [dbo].[sp_upsert_container]
    @container_id VARCHAR(12),
    @container_ident INT = NULL  -- Optional parameter for updating specific records
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        DECLARE @existing_container_ident INT;

        -- Validate that @container_id is not NULL
        IF @container_id IS NULL
        BEGIN
            PRINT 'Container id cannot be null.';
            ROLLBACK TRANSACTION;
            SELECT -1 AS Result;
            RETURN -1;
        END

        -- If @container_ident is NULL, check if the container exists based on @container_id
        IF @container_ident IS NULL
        BEGIN
            SELECT @existing_container_ident = @container_ident 
            FROM dbo.container 
            WHERE container_id = @container_id;

            IF @existing_container_ident IS NOT NULL
            BEGIN
                -- return 0 indicating no operation performed
                ROLLBACK TRANSACTION;
                SELECT 0 AS RESULT;
                RETURN 0;
            END
            ELSE
            BEGIN
                -- Insert new record
                INSERT INTO dbo.container (container_id, created_dt)
                VALUES (@container_id, GETDATE());
            END
        END
        ELSE
        BEGIN
            -- If @container_ident is provided, update the existing record
            IF EXISTS (SELECT 1 FROM dbo.container WHERE @existing_container_ident = @container_ident)
            BEGIN
                UPDATE dbo.container
                SET container_id = @container_id
                WHERE @existing_container_ident = @container_ident;
            END
            ELSE
            BEGIN
                -- If @container_ident does not exist, return 0 indicating no operation performed
                ROLLBACK TRANSACTION;
                SELECT 0 AS RESULT;
                RETURN 0;
            END
        END

        -- If everything succeeds, commit the transaction
        COMMIT TRANSACTION;
        SELECT 1 AS RESULT;
        RETURN 1;

    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;



/* TEST CASE */

DECLARE @return_value INT

/* 
Scenario 1: Insert a new container_id 
Expected: Success (returns 1)
*/
EXEC	@return_value = [dbo].[sp_upsert_container]
		@container_id = 'CMA202400022',
		@container_ident = NULL
IF @return_value = 1 PRINT 'Success';
ELSE PRINT 'Failure';
--SELECT	'Return Value' = @return_value


/* 
Scenario 2: Try inserting an existing container_id 
Expected: Update existing record (returns 1)
*/
EXEC	@return_value = [dbo].[sp_upsert_container]
		@container_id = 'CMA202400022',
		@container_ident = NULL
IF @return_value = 1 PRINT 'Success';
ELSE PRINT 'Failure';
--SELECT	'Return Value' = @return_value


/*
Scenario 3: Update an existing container using container_ident 
Expected: Success (returns 1)
*/
DECLARE @existing_ident INT;
SELECT @existing_ident = ident FROM container WHERE container_id = 'CMA202400022';

EXEC @return_value = sp_upsert_container
    @container_id = 'CMA202400022',
    @container_ident = 10;
IF @return_value = 1 PRINT 'Success';
ELSE PRINT 'Failure'
--SELECT	'Return Value' = @return_value


/*
Scenario 4: Try updating a non-existent container_ident 
Expected: Failure (returns 0)
*/
EXEC  @return_value = [dbo].[sp_upsert_container]
	  @container_id = 'CMA202400099',
	  @container_ident = 999
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure'
--SELECT	'Return Value' = @return_value


/*
Scenario 5: Try inserting a container_id with NULL name 
Expected: Failure (returns -1)
*/
EXEC @return_value = [dbo].[sp_upsert_container]
	 @container_id = NULL
IF @return_value = -1 PRINT 'Success';
ELSE PRINT 'Failure'
--SELECT	'Return Value' = @return_value
GO

-- Cleanup: Remove test data 





	