CREATE TABLE [dbo].[company]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [company_name] VARCHAR(50) NOT NULL, 
    [created_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
)
