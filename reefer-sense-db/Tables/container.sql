CREATE TABLE [dbo].[container]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [containerid] VARCHAR(12) NOT NULL, 
    [created_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [udated_dt] DATETIME2 NOT NULL DEFAULT GETDATE()
)
