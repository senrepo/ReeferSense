CREATE PROCEDURE [dbo].[sp_get_company_vessel]
    @company_ident INT,
    @vessel_id     VARCHAR(25) = NULL,
    @result        INT OUTPUT  
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------------
    -- 1. Validate company
    --------------------------------------------------
    IF NOT EXISTS (SELECT 1 FROM dbo.company WHERE ident = @company_ident)
    BEGIN
        PRINT 'Invalid company_ident. Company does not exist.';
        SELECT TOP (0)
            c.ident        AS CompanyIdent,
            c.company_name AS CompanyName,
            c.created_dt   AS CompanyCreatedDate,
            c.updated_dt   AS CompanyUpdatedDate,
            v.ident        AS VesselIdent,
            v.vessel_id    AS VesselID,
            v.vessel_name  AS VesselName,
            v.created_dt   AS VesselCreatedDate,
            v.updated_dt   AS VesselUpdatedDate
        FROM dbo.company AS c
        INNER JOIN dbo.company_vessel AS cv ON cv.company_ident = c.ident
        INNER JOIN dbo.vessel AS v ON v.ident = cv.vessel_ident;

        SET @result = 0;   
        RETURN;
    END;

    --------------------------------------------------
    -- 2. Retrieve data
    --    If @vessel_id IS NULL then return all vessels for the company
    --    Else return only that specific vessel
    --------------------------------------------------
    SELECT
        c.ident        AS CompanyIdent,
        c.company_name AS CompanyName,
        c.created_dt   AS CompanyCreatedDate,
        c.updated_dt   AS CompanyUpdatedDate,
        v.ident        AS VesselIdent,
        v.vessel_id    AS VesselID,
        v.vessel_name  AS VesselName,
        v.created_dt   AS VesselCreatedDate,
        v.updated_dt   AS VesselUpdatedDate
    FROM dbo.company c
    INNER JOIN dbo.company_vessel cv ON cv.company_ident = c.ident
    INNER JOIN dbo.vessel v         ON v.ident         = cv.vessel_ident
    WHERE c.ident = @company_ident
      AND (@vessel_id IS NULL OR v.vessel_id = @vessel_id);

    SET @result = 1; 

END;
GO





/* TEST CASES FOR sp_get_company_vessel 

DECLARE @status INT;

--------------------------------------------------
-- Test Case 1: Valid company, @vessel_id = NULL
-- Expect: all vessels for that company, @status = 1
--------------------------------------------------
PRINT 'Test Case 1: Valid company, @vessel_id = NULL';

SET @status = -1;
EXEC dbo.sp_get_company_vessel
    @company_ident = 2,     -- adjust to an existing company ident
    @vessel_id     = NULL,
    @result        = @status OUTPUT;

IF @status = 1 PRINT 'Success'; ELSE PRINT 'Failure';
SELECT 'Return Value' = @status;
PRINT '--------------------------------------------------';


--------------------------------------------------
-- Test Case 2: NULL company_ident, valid vessel_id
-- Expect: invalid company, @status = 0
--------------------------------------------------
PRINT 'Test Case 2: NULL company_ident, valid vessel_id';

SET @status = -1;
EXEC dbo.sp_get_company_vessel
    @company_ident = NULL,
    @vessel_id     = 'CMAVSL001',
    @result        = @status OUTPUT;

IF @status = 0 PRINT 'Success'; ELSE PRINT 'Failure';
SELECT 'Return Value' = @status;
PRINT '--------------------------------------------------';


--------------------------------------------------
-- Test Case 3: Valid company_ident & valid vessel_id (linked)
-- Expect: one row (or few if multiple mappings), @status = 1
--------------------------------------------------
PRINT 'Test Case 3: Valid company_ident & valid vessel_id (linked)';

SET @status = -1;
EXEC dbo.sp_get_company_vessel
    @company_ident = 1,     -- existing company ident
    @vessel_id     = 'CMAVSL001',    -- vessel_id linked to that company
    @result        = @status OUTPUT;

IF @status = 1 PRINT 'Success'; ELSE PRINT 'Failure';
SELECT 'Return Value' = @status;
PRINT '--------------------------------------------------';


--------------------------------------------------
-- Test Case 4: Valid company_ident, vessel_id that does NOT belong to that company
-- Expect: no rows, @status = 0
--------------------------------------------------
PRINT 'Test Case 4: Valid company_ident, vessel_id that does NOT belong to that company';

SET @status = -1;
EXEC dbo.sp_get_company_vessel
    @company_ident = 1,      -- existing company
    @vessel_id     = 'CMAVSL999',   -- non-existent or not linked vessel_id
    @result        = @status OUTPUT;

IF @status = 1 PRINT 'Success'; ELSE PRINT 'Failure';
SELECT 'Return Value' = @status;
PRINT '--------------------------------------------------';
GO


*/












