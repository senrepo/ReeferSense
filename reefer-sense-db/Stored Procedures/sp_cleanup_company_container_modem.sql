CREATE PROCEDURE [dbo].[sp_cleanup_company_container_modem]
    @input_company_name VARCHAR(50),
    @input_container_id VARCHAR(12),
    @input_imei_no VARCHAR(15)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @company_ident INT;
    DECLARE @container_ident INT;
    DECLARE @modem_ident INT;

    -- Row count trackers
    DECLARE @deleted_history INT = 0;
    DECLARE @deleted_latest INT = 0;
    DECLARE @deleted_company_modem INT = 0;
    DECLARE @deleted_container INT = 0;
    DECLARE @deleted_modem INT = 0;
    DECLARE @deleted_company INT = 0;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Step 0: Get identifiers first
        SELECT TOP 1 @company_ident = ident 
        FROM company 
        WHERE company_name = @input_company_name;

        SELECT TOP 1 @container_ident = ident 
        FROM container 
        WHERE container_id = @input_container_id;

        SELECT TOP 1 @modem_ident = ident 
        FROM modem 
        WHERE modem_imei = @input_imei_no;

        -- Defensive check
        IF @company_ident IS NULL OR @container_ident IS NULL OR @modem_ident IS NULL
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT 0 AS [Success], 'Identifiers not found for cleanup' AS [ErrorMessage];
            RETURN;
        END

        -- Step 1: Delete history data
        DELETE FROM temperature_data_history
        WHERE container_id = @input_container_id
          AND modem_imei = @input_imei_no;
        SET @deleted_history = @@ROWCOUNT;

        -- Step 2: Delete latest data
        DELETE FROM temperature_data_latest
        WHERE container_id = @input_container_id
          AND modem_imei = @input_imei_no;
        SET @deleted_latest = @@ROWCOUNT;

        -- Step 3: Remove company-modem link
        DELETE FROM company_modem
        WHERE company_ident = @company_ident
          AND modem_ident = @modem_ident;
        SET @deleted_company_modem = @@ROWCOUNT;

        -- Step 4: Delete container
        DELETE FROM container
        WHERE ident = @container_ident;
        SET @deleted_container = @@ROWCOUNT;

        -- Step 5: Delete modem
        DELETE FROM modem
        WHERE ident = @modem_ident;
        SET @deleted_modem = @@ROWCOUNT;

        -- Step 6: Delete company (only if no dependencies)
        IF NOT EXISTS (SELECT 1 FROM company_modem WHERE company_ident = @company_ident)
        BEGIN
            DELETE FROM company
            WHERE ident = @company_ident;
            SET @deleted_company = @@ROWCOUNT;
        END

        COMMIT TRANSACTION;

        -- Return summary results
        SELECT 
            1 AS [Success],
            'Cleanup completed successfully' AS [Message],
            @deleted_history AS DeletedHistoryRows,
            @deleted_latest AS DeletedLatestRows,
            @deleted_company_modem AS DeletedCompanyModemRows,
            @deleted_container AS DeletedContainerRows,
            @deleted_modem AS DeletedModemRows,
            @deleted_company AS DeletedCompanyRows;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        SELECT 0 AS [Success], ERROR_MESSAGE() AS [ErrorMessage];
    END CATCH;
END;


/* TEST CASE */
EXEC [dbo].[sp_cleanup_company_container_modem]
     @input_company_name = 'MSC Global',
     @input_container_id = 'MSC20240001',
     @input_imei_no = '350123451234568';

EXEC [dbo].[sp_cleanup_company_container_modem]
	@input_company_name = 'Titan Shipping',
	@input_container_id = 'TIT202500031',
	@input_imei_no = '350123451234575';


