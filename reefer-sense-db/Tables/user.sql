CREATE TABLE [dbo].[user]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [user-id] VARCHAR(50) NOT NULL, 
    [first-name] VARCHAR(50) NOT NULL, 
    [last-name] VARCHAR(50) NOT NULL, 
    [active] BIT NOT NULL, 
    [created-dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [updated-dt] DATETIME2 NOT NULL DEFAULT GETDATE()
)
