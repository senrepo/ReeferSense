CREATE TABLE [dbo].[firmware]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [firmware_version] VARCHAR(25) NOT NULL, 
    [created_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE()
)
