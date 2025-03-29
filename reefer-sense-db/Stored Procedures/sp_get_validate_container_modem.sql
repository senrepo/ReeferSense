CREATE PROCEDURE [dbo].[sp_get_validate_container_modem]
    @container_id VARCHAR(12),
    @modem_imei VARCHAR(15)
AS
BEGIN
    BEGIN TRANSACTION; 
    BEGIN TRY
        -- If container_id exist (failed as 0)
        IF NOT EXISTS (SELECT 1 FROM dbo.container WHERE container_id = @container_id)
        BEGIN
            PRINT 'Invalid container_id. Container does not exist.'; --If no matching container_ig is found and returns 0
            SELECT 0 AS RESULT;
            RETURN;
        END

        -- If modem_imei exist (failed as 0)
        IF NOT EXISTS (SELECT 1 FROM dbo.modem WHERE modem_imei = @modem_imei)
        BEGIN
            PRINT 'Invalid modem_imei. Modem does not exist.';
            SELECT 0 AS RESULT;
            RETURN;
        END

        -- (True data as 1) Get/Retrieve container and modem information
        SELECT
            c.ident AS ContainerIdent,
            c.container_id AS ContainerID,
            m.ident AS ModemIdent,
            m.modem_imei AS ModemIMEI,
            m.model AS ModemModel,
            m.manufacturer AS ModemManufacturer,
            c.created_dt AS ContainerCreatedDate,
            c.updated_dt AS ContainerUpdatedDate,
            m.created_dt AS ModemCreatedDate,
            m.updated_dt AS ModemUpdatedDate
        FROM dbo.container c
        JOIN dbo.modem m ON m.modem_imei = @modem_imei
        WHERE c.container_id = @container_id;
         ROLLBACK TRANSACTION;
        SELECT 1 AS RESULT;
        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
     ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
        SELECT -1 AS RESULT;
    END CATCH;
END;




/* TEST CASE */
-- Valid container_id and modem_imei
DECLARE	@return_value int

EXEC	@return_value = [dbo].[sp_get_validate_container_modem]
		@container_id = 'CMA202400011',
		@modem_imei = '350123451234560'
IF @return_value = 1 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value

--Invalid container_id, valid modem_imei
EXEC	@return_value = [dbo].[sp_get_validate_container_modem]
		@container_id = 'C02400020',
		@modem_imei = '543216789012345'
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value

--Valid container_id, invalid modem_imei
EXEC	@return_value = [dbo].[sp_get_validate_container_modem]
		@container_id = 'CMA202400022',
		@modem_imei = 'Invalid3456678'
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value

--Both container_id and modem_imei invalid
EXEC	@return_value = [dbo].[sp_get_validate_container_modem]
		@container_id = 'masd456767',
		@modem_imei = '4567u8y'
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value

-- NULL container_id and valid modem_imei
EXEC	@return_value = [dbo].[sp_get_validate_container_modem]
		@container_id = NULL,
		@modem_imei = '350123451234560'
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value

--Valid container_id and NULL modem_imei
EXEC	@return_value = [dbo].[sp_get_validate_container_modem]
		@container_id = 'CMA202400020',
		@modem_imei = NULL
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value

-- NULL container_id and NULL modem_imei
EXEC	@return_value = [dbo].[sp_get_validate_container_modem]
		@container_id = NULL,
		@modem_imei = NULL
IF @return_value = 0 PRINT 'Success';
ELSE PRINT 'Failure';
SELECT	'Return Value' = @return_value



















