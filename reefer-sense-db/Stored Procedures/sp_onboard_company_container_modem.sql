CREATE PROCEDURE [dbo].[sp_onboard_company_container_modem]
    @input_company_name VARCHAR(50),
    @input_container_id VARCHAR(12),
    @input_imei_no VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @imei_ident INT;
    DECLARE @company_ident INT;
    DECLARE @return_value INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Step 1: Insert/Update Company
        EXEC @return_value = sp_upsert_company
            @company_name = @input_company_name,
            @company_ident = NULL;

        IF @return_value <> 1 
            THROW 50001, 'Failure: Insert/Update company failed', 1;

        PRINT 'Success: Inserted/Updated company';

        -- Step 2: Insert/Update Container
        EXEC @return_value = [dbo].[sp_upsert_container]
            @container_id = @input_container_id,
            @container_ident = NULL;

        IF @return_value <> 1 
            THROW 50002, 'Failure: Insert/Update container failed', 1;

        PRINT 'Success: Inserted/Updated container';

        -- Step 3: Insert/Update Modem
        EXEC @return_value = [dbo].[sp_upsert_modem]
            @modem_imei = @input_imei_no,
            @model = 'rmmw',
            @manufacturer = 'Sealand';

        IF @return_value <> 1 
            THROW 50003, 'Failure: Insert/Update modem failed', 1;

        PRINT 'Success: Inserted/Updated modem';

        -- Step 4: Fetch identifiers
        SELECT TOP 1 @company_ident = ident 
        FROM company 
        WHERE company_name = @input_company_name;

        SELECT TOP 1 @imei_ident = ident 
        FROM modem 
        WHERE modem_imei = @input_imei_no;

        -- Step 5: Link company & modem
        EXEC @return_value = [dbo].[sp_upsert_company_modem]
            @company_ident = @company_ident,
            @modem_ident = @imei_ident;

        IF @return_value <> 1 
            THROW 50004, 'Failure: Linking company to modem failed', 1;

        PRINT 'Success: Linked company to modem';

        -- Commit if everything succeeded
        COMMIT TRANSACTION;

        SELECT 1 AS [Success], 'Onboarding completed successfully' AS [Message];
    END TRY
    BEGIN CATCH
        -- Rollback on error
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT 0 AS [Success], ERROR_MESSAGE() AS [ErrorMessage];
    END CATCH;
END;


/* TEST CASE */
EXEC [dbo].[sp_onboard_company_container_modem]
     @input_company_name = 'MSC Global',
     @input_container_id = 'MSC20240001',
     @input_imei_no = '350123451234568';

EXEC [dbo].[sp_onboard_company_container_modem]
	@input_company_name = 'Titan Shipping',
	@input_container_id = 'TIT202500031',
	@input_imei_no = '350123451234575';