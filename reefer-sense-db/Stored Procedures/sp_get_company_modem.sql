CREATE PROCEDURE [dbo].[sp_get_company_modem]
    @company_ident INT,
    @modem_imei   VARCHAR(15) = NULL,
    @result        INT OUTPUT       -- 1 = success, 0 = not found/invalid
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------------
    --  Validate company
    --------------------------------------------------
    IF NOT EXISTS (SELECT 1 FROM dbo.company WHERE ident = @company_ident)
    BEGIN
        PRINT 'Invalid company_ident. Company does not exist.';

        SELECT TOP (0)
            c.ident        AS CompanyIdent,
            c.company_name AS CompanyName,
            c.created_dt   AS CompanyCreatedDate,
            c.updated_dt   AS CompanyUpdatedDate,
            m.ident        AS ModemIdent,
            m.modem_imei   AS ModemIMEI,
            m.model        AS Model,
            m.manufacturer AS Manufacturer,
            m.created_dt   AS ModemCreatedDate,
            m.updated_dt   AS ModemUpdatedDate
        FROM dbo.company c
        INNER JOIN dbo.company_modem cm ON cm.company_ident = c.ident 
		INNER JOIN dbo.modem m ON m.ident = cm.modem_ident

       SET @result = 0; -- validation fail
	   RETURN;
    END

	--------------------------------------------------
    --  Retrieve data
    --    If @modem_imei IS NULL then return all modems for the company
    --    Else return only that specific modem
    --------------------------------------------------
    SELECT
        c.ident        AS CompanyIdent,
        c.company_name AS CompanyName,
        c.created_dt   AS CompanyCreatedDate,
        c.updated_dt   AS CompanyUpdatedDate,
        m.ident        AS ModemIdent,
        m.modem_imei   AS ModemIMEI,
        m.model        AS Model,
        m.manufacturer AS Manufacturer,
        m.created_dt   AS ModemCreatedDate,
        m.updated_dt   AS ModemUpdatedDate
    FROM dbo.company c
        INNER JOIN dbo.company_modem cm ON cm.company_ident = c.ident 
		INNER JOIN dbo.modem m ON m.ident = cm.modem_ident
    WHERE c.ident = @company_ident
          AND (@modem_imei IS NULL OR m.modem_imei = @modem_imei);

    SET @result = 1;      -- success
END;
GO

/* TEST CASES 

DECLARE @status INT;

--------------------------------------------------
-- Test Case 1: Valid company_ident & modem_imei
-- Expect: data for that company+modem, @status = 1
--------------------------------------------------
PRINT 'Test Case 1: Valid company_ident & modem_imei';

SET @status = -1; -- reset
EXEC dbo.sp_get_company_modem
    @company_ident = 1,                      -- company 1
    @modem_imei   = '350123451234560',       -- modem IMEI linked to company 1
    @result       = @status OUTPUT;

IF @status = 1 PRINT 'Success'; ELSE PRINT 'Failure';
SELECT 'Return Value' = @status;
PRINT '--------------------------------------------------';


--------------------------------------------------
-- Test Case 2: Invalid company_ident
-- Expect: empty result set, @status = 0 (fails company validation)
--------------------------------------------------
PRINT 'Test Case 2: Invalid company_ident';

SET @status = -1;
EXEC dbo.sp_get_company_modem
    @company_ident = 9999,                   -- non-existent company
    @modem_imei   = '350123451234560',       -- valid IMEI
    @result       = @status OUTPUT;

IF @status = 0 PRINT 'Success'; ELSE PRINT 'Failure';
SELECT 'Return Value' = @status;
PRINT '--------------------------------------------------';


--------------------------------------------------
-- Test Case 3: Valid company_ident, invalid modem_imei
-- NOTE: With current proc logic, this returns NO ROWS, but @status = 1
--------------------------------------------------
PRINT 'Test Case 3: Valid company_ident, invalid modem_imei';

SET @status = -1;
EXEC dbo.sp_get_company_modem
    @company_ident = 1,                       -- existing company
    @modem_imei   = '999999999999999',        -- non-existent IMEI
    @result       = @status OUTPUT;

IF @status = 1 PRINT 'Success (status=1, but no rows)'; ELSE PRINT 'Failure';
SELECT 'Return Value' = @status;
PRINT '--------------------------------------------------';


--------------------------------------------------
-- Test Case 4: Valid company_ident, @modem_imei = NULL
-- Expect: all modems for that company, @status = 1
--------------------------------------------------
PRINT 'Test Case 4: Valid company_ident, @modem_imei = NULL';

SET @status = -1;
EXEC dbo.sp_get_company_modem
    @company_ident = 1,       -- existing company
    @modem_imei   = NULL,     -- get all modems for that company
    @result       = @status OUTPUT;

IF @status = 1 PRINT 'Success'; ELSE PRINT 'Failure';
SELECT 'Return Value' = @status;
PRINT '--------------------------------------------------';

*/