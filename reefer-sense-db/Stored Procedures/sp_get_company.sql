CREATE PROCEDURE [dbo].[sp_get_company]
    @company_ident INT = NULL
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Get/Retrieve company details
        IF @company_ident IS NULL
        BEGIN
            -- Return all companies if no specific company_ident is provided
            SELECT
                ident AS CompanyIdent,
                company_name AS CompanyName,
                created_dt AS CreatedDate,
                updated_dt AS UpdatedDate
            FROM dbo.company;
            COMMIT TRANSACTION;
            RETURN;
        END
        ELSE
        BEGIN
        -- Return details of the specified company (checks whether the company with the given company_ident exists)
        IF EXISTS (SELECT 1 FROM dbo.company WHERE ident = @company_ident)
        BEGIN
            SELECT
                ident AS CompanyIdent,
                company_name AS CompanyName,
                created_dt AS CreatedDate,
                updated_dt AS UpdatedDate
            FROM dbo.company
            WHERE ident = @company_ident;
            COMMIT TRANSACTION;
        END
        ELSE
        BEGIN
            PRINT 'Invalid company_ident. Company does not exist.';
            ROLLBACK TRANSACTION;
            SELECT 0 AS RESULT;
        END
    END
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
        SELECT -1 AS RESULT;
    END CATCH;
END;



/* TEST CASE */
DECLARE	@return_value int

-- Test Case 1: Retrieve all companies (when @company_ident is NULL) Returns all company records with their details.
EXEC	@return_value = [dbo].[sp_get_company]
		@company_ident = NULL
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value


-- Test Case 2: Retrieve a specific company (Valid company_ident) Returns the details of the company with ident = 1.
EXEC	@return_value = [dbo].[sp_get_company]
		@company_ident = 1
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value


-- Test Case 3: Invalid company_ident (Non-existent company)  Company does not exist.' 

EXEC	@return_value = [dbo].[sp_get_company]
		@company_ident = 5
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value

-- Test Case 4: NULL or Invalid Input (Check for Negative Values)
EXEC	@return_value = [dbo].[sp_get_company]
		@company_ident = -1
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value