CREATE TABLE [dbo].[vessel-container]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [vessel-ident] INT NOT NULL, 
    [container-ident] INT NOT NULL, 
    [created-dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [updated-dt] DATETIME2 NOT NULL DEFAULT GETDATE()
)
