CREATE PROCEDURE [dbo].[sp_get_vessel]
    @vessel_id VARCHAR(25) = NULL
AS
BEGIN
    BEGIN TRY
        -- Retrieve all vessels if vessel_id is not provided (If No vessel_id Provided)
        IF @vessel_id IS NULL
        BEGIN
            SELECT
                ident AS VesselIdent,
                vessel_id AS VesselID,
                vessel_name AS VesselName,
                created_dt AS CreatedDate,
                updated_dt AS UpdatedDate
            FROM dbo.vessel;
            PRINT 'All vessel records retrieved successfully.';
        END
        ELSE
        BEGIN
            -- Retrieve specific vessel by vessel_id (If vessel_id is Provided)
            SELECT
                ident AS VesselIdent,
                vessel_id AS VesselID,
                vessel_name AS VesselName,
                created_dt AS CreatedDate,
                updated_dt AS UpdatedDate
            FROM dbo.vessel
            WHERE vessel_id = @vessel_id;
           -- @@ROWCOUNT to check how many rows were returned by the previous SELECT statement.
            IF @@ROWCOUNT = 0
            BEGIN
                PRINT 'No vessel found with the provided vessel_id.'; --If no record was found @@Rowcount = 0
                SELECT 0 AS RESULT;
            END
            ELSE
            BEGIN
                PRINT 'Vessel record retrieved successfully.';
                SELECT 1 AS RESULT;
            END
        END
    END TRY
    BEGIN CATCH
       PRINT 'An error occurred: ' + ERROR_MESSAGE();
      SELECT -1 AS RESULT;
    END CATCH
END;





/* TEST CASE */
DECLARE	@return_value int

-- Test Case 1: Retrieve all vessel (when @vessel_id is NULL) Returns all vessel records with their details.
EXEC	@return_value = [dbo].[sp_get_vessel]
		@vessel_id = NULL
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value


-- Test Case 2: Retrieve a specific vessel (Valid vessel_id) Returns the details of the vessel with ident = 1.
EXEC	@return_value = [dbo].[sp_get_vessel]
		@vessel_id = 'CMAVSL002'
IF @return_value = 1 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value


-- Test Case 3: Invalid vessel_id (Non-existent vessel)  vessel does not exist.' 

EXEC	@return_value = [dbo].[sp_get_vessel]
		@vessel_id = CMAVSL00
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value

-- Test Case 4: NULL or Invalid Input (Check for Negative Values)
--EXEC	@return_value = [dbo].[sp_get_vessel]
--		@vessel_id = -1
--IF @return_value = -1 PRINT 'Success';
--ELSE PRINT 'Failure';
--SELECT	'Return Value' = @return_value

Go;

