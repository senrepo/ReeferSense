CREATE TABLE [dbo].[modem]
(
	[ident] INT IDENTITY(1,1) NOT NULL , 
    [modem_imei] VARCHAR(15) NULL UNIQUE, 
    [model] VARCHAR(25) NOT NULL, 
    [manufacturer] VARCHAR(50) NOT NULL,
    [created_dt] DATETIME2 NOT NULL , 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    PRIMARY KEY ([ident]), 
)



GO

CREATE NONCLUSTERED INDEX [IX_modem_temperature_data_latest] ON [dbo].[modem] ([modem_imei])

GO

CREATE NONCLUSTERED INDEX [IX_modem_temperature_data_history] ON [dbo].[modem] ([modem_imei])
