CREATE PROCEDURE [dbo].[sp_upsert_user]
    @user_id VARCHAR(50),
    @first_name VARCHAR(50),
    @last_name VARCHAR(50),
    @active BIT,
    @user_ident INT = NULL
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Validate @first_name, @last_name, @user_id, and @active are not NULL
        IF @user_id IS NULL OR @first_name IS NULL OR @last_name IS NULL OR @active IS NULL
        BEGIN
            PRINT 'User ID, First Name, and Last Name cannot be NULL.';
            ROLLBACK TRANSACTION;
            SELECT -1 AS RESULT;
            RETURN -1; -- Indicating an error
        END
  
        DECLARE @existing_user_ident INT;

        -- If @user_ident is NULL, check if the user exists based on @first_name, @last_name, and @user_id
        IF @user_ident IS NULL
        BEGIN
            SELECT @existing_user_ident = @user_ident 
            FROM dbo.[user]
            WHERE user_id = @user_id ;
        END

        IF @existing_user_ident IS NOT NULL
        BEGIN
            -- Update existing record
            UPDATE dbo.[user]
            SET first_name = @first_name,
                last_name = @last_name,
                active = @active
            WHERE @user_ident = @existing_user_ident;
        END
        ELSE
        BEGIN
            -- Insert new record
            INSERT INTO dbo.[user] (user_id, first_name, last_name, active, created_dt)
            VALUES (@user_id, @first_name, @last_name, @active, GETDATE());
        END
        
        -- If @user_ident is provided, update the existing record
        IF @user_ident IS NOT NULL
        BEGIN
            IF EXISTS (SELECT 1 FROM dbo.[user] WHERE @existing_user_ident = @user_ident)
            BEGIN
                UPDATE dbo.[user]
                SET first_name = @first_name, user_id = @user_id
                WHERE @existing_user_ident = @user_ident;
            END
            ELSE
            BEGIN
                -- If @user_ident does not exist, return 0 indicating no operation performed
                ROLLBACK TRANSACTION;
                SELECT 0 AS RESULT;
                RETURN 0; 
            END
        END
        
        COMMIT TRANSACTION;
        SELECT 1 AS RESULT;
        RETURN 1;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END



/* TEST CASE */
DECLARE	@return_value int

/* 
Scenario 1: Insert a new User
Expected: Success (returns 1)
*/
EXEC	@return_value = [dbo].[sp_upsert_user]
		@user_id = N'1001',
		@first_name = N'Sen',
		@last_name = N'Elay',
		@active = 1,
		@user_ident = NULL
IF @return_value = 1 PRINT 'Success: Inserted a new vessel';
ELSE PRINT 'Failure: Insert test case failed';
SELECT	'Return Value' = @return_value


/* 
Scenario 2: Try inserting an existing User
Expected: Update existing record (returns 1)
*/
EXEC	@return_value = [dbo].[sp_upsert_user]
		@user_id = N'1001',
		@first_name = N'Sen',
		@last_name = N'Elay',
		@active = 1,
		@user_ident = NULL
IF @return_value = 1 PRINT 'Success: Inserted a new vessel';
ELSE PRINT 'Failure: Insert test case failed';
SELECT	'Return Value' = @return_value


/*
Scenario 3: Update an existing User using user_id 
Expected: Success (returns 1)
*/
EXEC	@return_value = [dbo].[sp_upsert_user]
		@user_id = N'1001',
		@first_name = N'Sugan',
		@last_name = N'Sen',
		@active = 1,
		@user_ident = NULL
IF @return_value = 1 PRINT 'Success: Inserted a new vessel';
ELSE PRINT 'Failure: Insert test case failed';
SELECT	'Return Value' = @return_value


/*
Scenario 4: Try updating a non-existent user_ident 
Expected: Failure (returns 0)
*/
EXEC	@return_value = [dbo].[sp_upsert_user]
		@user_id = N'1003',
		@first_name = N'ram',
		@last_name = N'saran',
		@active = 1,
		@user_ident = 3
IF @return_value = 1 PRINT 'Success: Inserted a new vessel';
ELSE PRINT 'Failure: Insert test case failed';
SELECT	'Return Value' = @return_value


/*
Scenario 5: Try inserting a user with NULL name 
Expected: Failure (returns -1)
*/
EXEC	@return_value = [dbo].[sp_upsert_user]
		@user_id = NULL,
		@first_name = NULL,
		@last_name = NULL,
		@active = NULL,
		@user_ident = NULL
IF @return_value = 1 PRINT 'Success: Inserted a new vessel';
ELSE PRINT 'Failure: Insert test case failed';
SELECT	'Return Value' = @return_value

-- Cleanup: Remove test data 
DELETE FROM dbo.[user] WHERE first_name in ('Sugan','Sen');
Go
