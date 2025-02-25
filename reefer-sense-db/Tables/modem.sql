CREATE TABLE [dbo].[modem]
(
	[ident] INT IDENTITY(1,1) NOT NULL , 
    [modem_imei] VARCHAR(15) NULL UNIQUE, 
    [model] VARCHAR(25) NOT NULL, 
    [manufacturer] VARCHAR(50) NOT NULL,
    [created_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    PRIMARY KEY ([ident]), 
)
