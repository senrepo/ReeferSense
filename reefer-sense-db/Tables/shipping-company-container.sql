CREATE TABLE [dbo].[shipping-company-container]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [container-ident] INT NOT NULL, 
    [shipping-company-ident] INT NOT NULL, 
    [created-dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [updated-dt] DATETIME2 NOT NULL DEFAULT GETDATE()
)
