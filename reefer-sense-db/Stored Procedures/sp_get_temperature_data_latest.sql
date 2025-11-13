CREATE PROCEDURE [dbo].[sp_get_temperature_data_latest]
    @pageNumber INT = NULL,
    @pageSize   INT = NULL,
    @totalCount INT OUTPUT      -- total rows available (for pagination)
AS
BEGIN
    SET NOCOUNT ON;

    --------------------------------------------------
    -- 1) Compute total record count
    --------------------------------------------------
    SELECT 
        @totalCount = COUNT(*)
    FROM temperature_data_latest tdl
        INNER JOIN container c ON c.container_id = tdl.container_id;
		--LEFT  JOIN modem           m  ON m.modem_imei      = tdl.modem_imei
        --LEFT  JOIN modem_firmware  mf ON mf.modem_ident    = m.ident
        --LEFT  JOIN firmware        f  ON f.ident           = mf.firmware_ident
        --LEFT  JOIN company_modem   cm ON cm.modem_ident    = m.ident
        --LEFT  JOIN vessel          v  ON v.vessel_id       = tdl.vessel_id
        --LEFT  JOIN company_vessel  cv ON cv.vessel_ident   = v.ident
        --LEFT  JOIN company         cy ON cy.ident = cm.company_ident 
        --                              OR cy.ident = cv.company_ident;

    --------------------------------------------------
    -- 2) When paging is not requested (NULL parameters)
    --    → return all records without paging
    --------------------------------------------------
    IF @pageNumber IS NULL OR @pageSize IS NULL
    BEGIN
        PRINT 'Paging disabled — returning all records.';

        SELECT 
            cy.company_name, 
            v.vessel_id, 
            v.vessel_name, 
            c.container_id, 
            m.modem_imei, 
            m.model, 
            m.manufacturer, 
            f.firmware_version, 
            tdl.temperatureF, 
            tdl.co2_percent, 
            tdl.deforsting, 
            tdl.humidityPercent, 
            tdl.o2_percent, 
            tdl.power,  
            tdl.logged_dt,
            tdl.received_dt
        FROM temperature_data_latest tdl
            INNER JOIN container        c  ON c.container_id    = tdl.container_id
            LEFT  JOIN modem           m  ON m.modem_imei      = tdl.modem_imei
            LEFT  JOIN modem_firmware  mf ON mf.modem_ident    = m.ident
            LEFT  JOIN firmware        f  ON f.ident           = mf.firmware_ident
            LEFT  JOIN company_modem   cm ON cm.modem_ident    = m.ident
            LEFT  JOIN vessel          v  ON v.vessel_id       = tdl.vessel_id
            LEFT  JOIN company_vessel  cv ON cv.vessel_ident   = v.ident
            LEFT  JOIN company         cy ON cy.ident = cm.company_ident 
                                          OR cy.ident = cv.company_ident
        ORDER BY tdl.logged_dt DESC;

        RETURN;
    END;

    --------------------------------------------------
    -- 3) Normalize input parameters (for valid paging)
    --------------------------------------------------
    IF @pageNumber < 1 SET @pageNumber = 1;
    IF @pageSize   <= 0 SET @pageSize   = 50;

    --------------------------------------------------
    -- 4) Return ONLY the requested page
    --------------------------------------------------
    SELECT 
        cy.company_name, 
        v.vessel_id, 
        v.vessel_name, 
        c.container_id, 
        m.modem_imei, 
        m.model, 
        m.manufacturer, 
        f.firmware_version, 
        tdl.temperatureF, 
        tdl.co2_percent, 
        tdl.deforsting, 
        tdl.humidityPercent, 
        tdl.o2_percent, 
        tdl.power,  
        tdl.logged_dt,
        tdl.received_dt
    FROM temperature_data_latest tdl
        INNER JOIN container        c  ON c.container_id    = tdl.container_id
        LEFT  JOIN modem           m  ON m.modem_imei      = tdl.modem_imei
        LEFT  JOIN modem_firmware  mf ON mf.modem_ident    = m.ident
        LEFT  JOIN firmware        f  ON f.ident           = mf.firmware_ident
        LEFT  JOIN company_modem   cm ON cm.modem_ident    = m.ident
        LEFT  JOIN vessel          v  ON v.vessel_id       = tdl.vessel_id
        LEFT  JOIN company_vessel  cv ON cv.vessel_ident   = v.ident
        LEFT  JOIN company         cy ON cy.ident = cm.company_ident 
                                      OR cy.ident = cv.company_ident
    ORDER BY tdl.logged_dt DESC
    OFFSET (@pageNumber - 1) * @pageSize ROWS
    FETCH NEXT @pageSize ROWS ONLY;
END;
GO


/* ======================================================
   TEST CASES FOR sp_get_temperature_data_latest
   ====================================================== 

DECLARE @Total INT;

--------------------------------------------------
-- Test Case 1: Paging disabled (both NULL)
-- Expect: All rows returned, @Total = full count
--------------------------------------------------
PRINT 'Test 1: Paging disabled (both NULL)';
SET @Total = 0;

EXEC dbo.sp_get_temperature_data_latest
    @pageNumber = NULL,
    @pageSize   = NULL,
    @totalCount = @Total OUTPUT;

PRINT 'Total Count : ' + CAST(@Total AS VARCHAR(20));
PRINT '--------------------------------------------------';


--------------------------------------------------
-- Test Case 2: First page (default paging)
-- Expect: first 50 rows, @Total = total rows
--------------------------------------------------
PRINT 'Test 2: Paging enabled (first page, 50 records)';
SET @Total = 0;

EXEC dbo.sp_get_temperature_data_latest
    @pageNumber = 1,
    @pageSize   = 50,
    @totalCount = @Total OUTPUT;

PRINT 'Total Count : ' + CAST(@Total AS VARCHAR(20));
PRINT '--------------------------------------------------';


--------------------------------------------------
-- Test Case 3: Small page (page 1, 10 records)
-- Expect: 10 rows, @Total = total rows
--------------------------------------------------
PRINT 'Test 3: Small page (10 per page)';
SET @Total = 0;

EXEC dbo.sp_get_temperature_data_latest
    @pageNumber = 1,
    @pageSize   = 10,
    @totalCount = @Total OUTPUT;

PRINT 'Total Count : ' + CAST(@Total AS VARCHAR(20));
PRINT '--------------------------------------------------';


--------------------------------------------------
-- Test Case 4: Page 2 (records 11–20)
--------------------------------------------------
PRINT 'Test 4: Page 2 (records 11–20)';
SET @Total = 0;

EXEC dbo.sp_get_temperature_data_latest
    @pageNumber = 2,
    @pageSize   = 10,
    @totalCount = @Total OUTPUT;

PRINT 'Total Count : ' + CAST(@Total AS VARCHAR(20));
PRINT '--------------------------------------------------';


--------------------------------------------------
-- Test Case 5: Large page number (beyond available rows)
-- Expect: empty result set, @Total = total rows
--------------------------------------------------
PRINT 'Test 5: Page 999 (expect empty result set)';
SET @Total = 0;

EXEC dbo.sp_get_temperature_data_latest
    @pageNumber = 999,
    @pageSize   = 10,
    @totalCount = @Total OUTPUT;

PRINT 'Total Count : ' + CAST(@Total AS VARCHAR(20));
PRINT '--------------------------------------------------';
GO

*/