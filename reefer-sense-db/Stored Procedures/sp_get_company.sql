CREATE PROCEDURE [dbo].[sp_get_company]
    @company_ident INT = NULL,
    @result        INT OUTPUT 
AS
BEGIN
     --------------------------------------------------
    --  Retrieve data
    --    If @company_ident IS NULL then return all company
    --    Else return only that specific company
    --------------------------------------------------
	SELECT 
		ident AS CompanyIdent,
		company_name AS CompanyName,
		created_dt AS CreatedDate,
		updated_dt AS UpdatedDate
	FROM dbo.company c
	WHERE (@company_ident IS NULL OR c.ident = @company_ident);

	SET @result = 1;

END;
GO


/* Test cases

DECLARE @status       INT;

--------------------------------------------------
-- Test Case 1: All companies
--------------------------------------------------
PRINT 'Test Case 1: All companies';

EXEC dbo.sp_get_company
    @company_ident = NULL,
    @result        = @status OUTPUT;

IF @status = 1
    PRINT 'Result: Success';
ELSE
    PRINT 'Result: Failure';

PRINT 'Output Status: ' + CAST(@status       AS VARCHAR(10));


--------------------------------------------------
-- Test Case 2: Valid company_ident
--------------------------------------------------
PRINT 'Test Case 2: Valid company_ident';

EXEC dbo.sp_get_company
    @company_ident = 1,
    @result        = @status OUTPUT;

IF @status = 1
    PRINT 'Result: Success';
ELSE
    PRINT 'Result: Failure';

PRINT 'Output Status: ' + CAST(@status       AS VARCHAR(10));

--------------------------------------------------
-- Test Case 3: Non-existent company_ident
--------------------------------------------------
PRINT 'Test 3: @company_ident = 5 (expect empty result set, status = 0)';

EXEC dbo.sp_get_company
    @company_ident = 999,
    @result        = @status OUTPUT;

IF @status = 1
    PRINT 'Result: Success';
ELSE
    PRINT 'Result: Failure';

PRINT 'Output Status: ' + CAST(@status       AS VARCHAR(10));
*/