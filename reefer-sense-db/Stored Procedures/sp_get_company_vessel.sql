CREATE PROCEDURE [dbo].[sp_get_company_vessel]
    @company_ident INT = NULL,
    @vessel_ident INT = NULL
AS
BEGIN
    -- Check if both company_ident and vessel_id are provided
    --This checks if either @company_ident or @vessel_id is NULL.
    --IF @company_ident IS NULL OR @vessel_id IS NULL 
    --BEGIN
    --    PRINT 'Both company_ident and vessel_id must be provided.';
    --    SELECT 0 AS RESULT;
    --    RETURN;
    --END

    -- Check if company exists
    IF NOT EXISTS (SELECT 1 FROM dbo.company WHERE ident = @company_ident)
    BEGIN
        PRINT 'Invalid company_ident. Company does not exist.';
        SELECT 0 AS RESULT;
        RETURN;
    END

    -- Check if vessel exists
    IF NOT EXISTS (SELECT 1 FROM dbo.vessel WHERE ident = @vessel_ident)
    BEGIN
        PRINT 'Invalid vessel_id. Vessel does not exist.';
        SELECT 0 AS RESULT;
        RETURN;
    END

    -- Retrieve data based on the input parameters
    SELECT
        c.ident AS CompanyIdent,
        c.company_name AS CompanyName,
        c.created_dt AS CompanyCreatedDate,
        c.updated_dt AS CompanyUpdatedDate,
        v.ident AS VesselIdent,
        v.vessel_id AS VesselID,
        v.vessel_name AS VesselName,
        v.created_dt AS VesselCreatedDate,
        v.updated_dt AS VesselUpdatedDate
    FROM dbo.company c
    INNER JOIN dbo.vessel v ON v.ident = @vessel_ident
    WHERE c.ident = @company_ident ;

    PRINT 'Company and vessel information retrieved successfully.';
    SELECT 1 AS RESULT;
END;







/* TEST CASE */

DECLARE	@return_value int

--Test Case 1: Retrieve all Companies and Vessels
EXEC	@return_value = [dbo].[sp_get_company_vessel]
		@company_ident = NULL,
		@vessel_ident = NULL
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value


--Test Case 2: Retrieve Specific Company with Valid company_ident
EXEC	@return_value = [dbo].[sp_get_company_vessel]
		@company_ident = 2,
		@vessel_ident = NULL
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value


--Test Case 3: Retrieve Specific Vessel with Valid vessel_id
EXEC	@return_value = [dbo].[sp_get_company_vessel]
		@company_ident = NULL,
		@vessel_ident = N'12'
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value


--Test Case 4: Retrieve Specific Company and Vessel with Valid IDs\
EXEC	@return_value = [dbo].[sp_get_company_vessel]
		@company_ident = 1,
		@vessel_ident = 12
IF @return_value = 1 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value

GO;





































