CREATE TABLE [dbo].[firmware]
(
	[ident] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [firmware_version] VARCHAR(25) NOT NULL, 
    [created_dt] DATETIME2 NOT NULL , 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE()
)
