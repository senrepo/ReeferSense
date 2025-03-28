CREATE PROCEDURE [dbo].[sp_get_company_vessel]
    @company_ident INT = NULL,
    @vessel_id VARCHAR(25) = NULL
AS
BEGIN
    -- Check if both company_ident and vessel_id are provided
     IF NOT EXISTS (SELECT 1 FROM dbo.company WHERE @company_ident = company_ident)
        BEGIN
            PRINT 'Invalid container_id. Container does not exist.'; --If no matching container_ig is found and returns 0
            SELECT 0 AS RESULT;
            RETURN;
        END

        -- If modem_imei exist (failed as 0)
        IF NOT EXISTS (SELECT 1 FROM dbo.vessel WHERE vessel_id = @vessel_id)
        BEGIN
            PRINT 'Invalid modem_imei. Modem does not exist.';
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
    LEFT JOIN dbo.vessel v ON c.ident = @company_ident 
    WHERE v.vessel_id = @vessel_id;

    PRINT 'Company and vessel information retrieved successfully.';
    SELECT 1 AS RESULT;
END;
