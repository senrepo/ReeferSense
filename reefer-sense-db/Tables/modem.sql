CREATE TABLE [dbo].[modem]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [imei] VARCHAR(15) NOT NULL, 
    [model] VARCHAR(25) NOT NULL, 
    [manufacturer] VARCHAR(50) NOT NULL,
    [created_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
)
