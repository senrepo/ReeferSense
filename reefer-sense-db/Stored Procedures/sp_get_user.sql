--CREATE PROCEDURE [dbo].[sp_get_user]
--    @user_id VARCHAR(50) = NULL
--AS
--BEGIN
--    BEGIN TRY
--        -- Retrieve all users if no user_id is provided
--        IF @user_id IS NULL
--        BEGIN
--            SELECT
--                ident AS UserIdent,
--                user_id AS UserID,
--                first_name AS FirstName,
--                last_name AS LastName,
--                active AS IsActive,
--                created_dt AS CreatedDate,
--                updated_dt AS UpdatedDate
--            FROM dbo.[user];
            
--            PRINT 'All user records retrieved successfully.';
--        END
--        ELSE
--        BEGIN
--            -- Retrieve specific user by user_id
--            SELECT
--                ident AS UserIdent,
--                user_id AS UserID,
--                first_name AS FirstName,
--                last_name AS LastName,
--                active AS IsActive,
--                created_dt AS CreatedDate,
--                updated_dt AS UpdatedDate
--            FROM dbo.[user]
--            WHERE user_id = @user_id;

--            -- Check if the user was found
--            IF @@ROWCOUNT = 0
--            BEGIN
--                PRINT 'No user found with the provided user_id.';
--                SELECT 0 AS RESULT;
--            END
--            ELSE
--            BEGIN
--                PRINT 'User record retrieved successfully.';
--                SELECT 1 AS RESULT;
--            END
--        END
--    END TRY
--    BEGIN CATCH
--        -- Handle any errors
--        PRINT 'An error occurred: ' + ERROR_MESSAGE();
--        SELECT -1 AS RESULT;
--    END CATCH
--END;



CREATE PROCEDURE [dbo].[sp_get_user]
    @user_id VARCHAR(50) = NULL
AS
BEGIN
    BEGIN TRANSACTION; 
    BEGIN TRY
        -- If container_id exist (failed as 0)
        IF NOT EXISTS (SELECT 1 FROM dbo.[user] WHERE user_id = @user_id)
        BEGIN
            PRINT 'Invalid user_id. user does not exist.'; --If no matching user_id is found and returns 0
            SELECT 0 AS RESULT;
            RETURN;
        END

        -- (True data as 1) Get/Retrieve container and modem information
        SELECT
                ident AS UserIdent,
				user_id AS UserID,
				first_name AS FirstName,
				last_name AS LastName,
				active AS IsActive,
				created_dt AS CreatedDate,
				updated_dt AS UpdatedDate
			FROM dbo.[user]
			WHERE user_id = @user_id;
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