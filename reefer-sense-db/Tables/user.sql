CREATE TABLE [dbo].[user]
(
	[ident] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [user_id] VARCHAR(50) NOT NULL, 
    [first_name] VARCHAR(50) NOT NULL, 
    [last_name] VARCHAR(50) NOT NULL, 
    [active] BIT NOT NULL, 
    [created_dt] DATETIME2 NOT NULL , 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE()
)
