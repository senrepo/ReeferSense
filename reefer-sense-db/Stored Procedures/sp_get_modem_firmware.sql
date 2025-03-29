CREATE PROCEDURE [dbo].[sp_get_modem_firmware]
    @modem_ident INT = NULL,
    @firmware_ident INT = NULL
AS
BEGIN
   

    -- Check if modem exists
    IF NOT EXISTS (SELECT 1 FROM dbo.modem WHERE ident = @modem_ident)
    BEGIN
        PRINT 'Invalid modem_ident. Modem does not exist.';
        SELECT 0 AS RESULT;
        RETURN;
    END

    -- Check if firmware exists
    IF NOT EXISTS (SELECT 1 FROM dbo.firmware WHERE ident = @firmware_ident)
    BEGIN
        PRINT 'Invalid firmware_ident. Firmware does not exist.';
        SELECT 0 AS RESULT;
        RETURN;
    END
    
   
   
    -- Retrieve modem and firmware information
    SELECT
        m.ident AS ModemIdent,
        m.modem_imei AS ModemIMEI,
        m.model AS Model,
        m.manufacturer AS Manufacturer,
        m.created_dt AS ModemCreatedDate,
        m.updated_dt AS ModemUpdatedDate,
        f.ident AS FirmwareIdent,
        f.firmware_version AS FirmwareVersion,
        f.created_dt AS FirmwareCreatedDate,
        f.updated_dt AS FirmwareUpdatedDate,
        mf.created_dt AS RelationshipCreatedDate,
        mf.updated_dt AS RelationshipUpdatedDate
    FROM dbo.modem_firmware mf
    INNER JOIN dbo.modem m ON mf.modem_ident = m.ident
    INNER JOIN dbo.firmware f ON mf.firmware_ident = f.ident
    WHERE mf.modem_ident = @modem_ident AND mf.firmware_ident = @firmware_ident;

    PRINT 'Modem and firmware information retrieved successfully.';
    SELECT 1 AS RESULT;
END;



/* TEST CASE */
--DECLARE	@return_value int

-- Test Case 1: Successful Data Retrieval
--EXEC	@return_value = [dbo].[sp_get_modem_firmware]
--		@modem_ident = 12,
--		@firmware_ident = 1
--IF @return_value = 1 PRINT 'Success';
--ELSE PRINT 'Failure';
--SELECT	'Return Value' = @return_value


-- Test Case 2: Missing Parameters
--EXEC	@return_value = [dbo].[sp_get_modem_firmware]
--		@modem_ident = NULL,
--		@firmware_ident = NULL
--IF @return_value = 0 PRINT 'Success';
--ELSE PRINT 'Failure';
--SELECT	'Return Value' = @return_value


-- Test Case 3: Invalid Modem ID
--EXEC	@return_value = [dbo].[sp_get_modem_firmware]
--		@modem_ident = 456,
--		@firmware_ident = 12
--IF @return_value = 0 PRINT 'Success';
--ELSE PRINT 'Failure';
--SELECT	'Return Value' = @return_value


-- Test Case 4: Invalid Firmware ID
--EXEC	@return_value = [dbo].[sp_get_modem_firmware]
--		@modem_ident = 1,
--		@firmware_ident = 5678
--IF @return_value = 0 PRINT 'Success';
--ELSE PRINT 'Failure';
--SELECT	'Return Value' = @return_value




