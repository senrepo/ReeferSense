CREATE TABLE [dbo].[Table2]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [firmware-version] VARCHAR(25) NOT NULL, 
    [created-dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [updated-dt] DATETIME2 NOT NULL DEFAULT GETDATE()
)
