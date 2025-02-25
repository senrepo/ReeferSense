CREATE TABLE [dbo].[container]
(
	[ident] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [containerid] VARCHAR(12) NOT NULL, 
    [created_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE()
)
