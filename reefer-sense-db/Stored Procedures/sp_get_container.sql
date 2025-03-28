CREATE PROCEDURE [dbo].[sp_get_container]
    @container_id VARCHAR(12) = NULL
AS
BEGIN
    BEGIN TRY
        -- Retrieve all containers if no container_id is provided
        IF @container_id IS NULL
        BEGIN
            SELECT
                ident AS ContainerIdent,
                container_id AS ContainerID,
                created_dt AS CreatedDate,
                updated_dt AS UpdatedDate
            FROM dbo.container;
            
            PRINT 'All container records retrieved successfully.';
        END
        ELSE
        BEGIN
            -- Retrieve specific container by container_id
            SELECT
                ident AS ContainerIdent,
                container_id AS ContainerID,
                created_dt AS CreatedDate,
                updated_dt AS UpdatedDate
            FROM dbo.container
            WHERE container_id = @container_id;

            -- Check if the container was found
            IF @@ROWCOUNT = 0
            BEGIN
                PRINT 'No container found with the provided container_id.';
                SELECT 0 AS RESULT;
            END
            ELSE
            BEGIN
                PRINT 'Container record retrieved successfully.';
                SELECT 1 AS RESULT;
            END
        END
    END TRY
    BEGIN CATCH
        -- Handle any errors
        PRINT 'An error occurred: ' + ERROR_MESSAGE();
        SELECT -1 AS RESULT;
    END CATCH
END;



/* TEST CASE */

DECLARE	@return_value int

-- Test Case 1: Retrieve all container (when container_id is NULL) Returns all container records with their details.
EXEC	@return_value = [dbo].[sp_get_container]
		@container_id = NULL
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value


-- Test Case 2: Retrieve a specific container (Valid container_id) Returns the details of the container with ident = 1.
EXEC	@return_value = [dbo].[sp_get_container]
		@container_id = 'CMA202400020'
IF @return_value = 1 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value


--Test Case 3: Invalid Container ID
EXEC	@return_value = [dbo].[sp_get_container]
		@container_id = 'Invalid123'
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value


--Test Case 4: Boundary Test (Container ID Length)
EXEC	@return_value = [dbo].[sp_get_container]
		@container_id = 'CMA202400020'
IF @return_value = 1 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value






