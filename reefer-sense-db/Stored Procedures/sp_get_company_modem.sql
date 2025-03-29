CREATE PROCEDURE [dbo].[sp_get_company_modem]
    @company_ident INT = NULL,
    @modem_ident INT = NULL
AS
BEGIN
    -- Check if both parameters are provided
    --IF @company_ident IS NULL OR @modem_ident IS NULL
    --BEGIN
    --    PRINT 'Both company_ident and modem_ident must be provided.';
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

    -- Check if modem exists
    IF NOT EXISTS (SELECT 1 FROM dbo.modem WHERE modem_imei = @modem_ident)
    BEGIN
        PRINT 'Invalid modem_ident. Modem does not exist.';
        SELECT 0 AS RESULT;
        RETURN;
    END

    -- Retrieve data based on the input parameters
    SELECT
        c.ident AS CompanyIdent,
        c.company_name AS CompanyName,
        c.created_dt AS CompanyCreatedDate,
        c.updated_dt AS CompanyUpdatedDate,
        m.ident AS ModemIdent,
        m.modem_imei AS ModemIMEI,
        m.model AS Model,
        m.manufacturer AS Manufacturer,
        m.created_dt AS ModemCreatedDate,
        m.updated_dt AS ModemUpdatedDate
    FROM dbo.company c
    CROSS JOIN dbo.modem m
    WHERE c.ident = @company_ident AND m.ident = @modem_ident;

    PRINT 'Company and modem information retrieved successfully.';
    SELECT 1 AS RESULT;
END;




/* TEST CASE */
DECLARE	@return_value int

-- Test Case 1: Successful Data Retrieval
EXEC	@return_value = [dbo].[sp_get_company_modem]
		@company_ident = 1,
		@modem_ident = 12
IF @return_value = 1 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value


-- Test Case 2: Missing Parameters
EXEC	@return_value = [dbo].[sp_get_company_modem]
		@company_ident = NULL,
		@modem_ident = NULL
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value


-- Test Case 3: Invalid Company ID
EXEC	@return_value = [dbo].[sp_get_company_modem]
		@company_ident = 0,
		@modem_ident = 12
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value


-- Test Case 4: Invalid Modem Ident
EXEC	@return_value = [dbo].[sp_get_company_modem]
		@company_ident = 1,
		@modem_ident = 1256
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value

Go

