CREATE TABLE [dbo].[shipping-company]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [company-name] VARCHAR(50) NOT NULL, 
    [created-dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [updated-dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
)
