CREATE PROCEDURE [dbo].[sp_get_modem]
    @modem_imei VARCHAR(15) = NULL
AS
BEGIN
    --BEGIN TRY
        -- Retrieve all modems if no modem_imei is provided
        IF @modem_imei IS NULL
        BEGIN
            SELECT
                ident AS ModemIdent,
                modem_imei AS ModemIMEI,
                model AS Model,
                manufacturer AS Manufacturer,
                created_dt AS CreatedDate,
                updated_dt AS UpdatedDate
            FROM dbo.modem;
            
            PRINT 'All modem records retrieved successfully.';
        END
        ELSE
        BEGIN
            -- Retrieve specific modem by modem_imei
            SELECT
                ident AS ModemIdent,
                modem_imei AS ModemIMEI,
                model AS Model,
                manufacturer AS Manufacturer,
                created_dt AS CreatedDate,
                updated_dt AS UpdatedDate
            FROM dbo.modem
            WHERE modem_imei = @modem_imei;

            -- Check if the modem was found
            IF @@ROWCOUNT = 0
            BEGIN
                PRINT 'No modem found with the provided modem_imei.';
                SELECT 0 AS RESULT;
            END
            ELSE
            BEGIN
                PRINT 'Modem record retrieved successfully.';
                SELECT 1 AS RESULT;
            END
        END
    --END TRY
    --BEGIN CATCH
    --     Handle any errors
    --    PRINT 'An error occurred: ' + ERROR_MESSAGE();
    --    SELECT -1 AS RESULT;
    --END CATCH
END;




/* TEST CASE */

DECLARE	@return_value int

--Test Case 1: Retrieve All Modems (No Input Provided)
EXEC	@return_value = [dbo].[sp_get_modem]
		@modem_imei = NULL
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value


--Test Case 2: Retrieve Specific Modem (Valid IMEI)
EXEC	@return_value = [dbo].[sp_get_modem]
		@modem_imei = N'543216789012345'
IF @return_value = 1 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value


--Test Case 3: Retrieve Specific Modem (Invalid IMEI)
EXEC	@return_value = [dbo].[sp_get_modem]
		@modem_imei = N'350123451'
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value

GO;




