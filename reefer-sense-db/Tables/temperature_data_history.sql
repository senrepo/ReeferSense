CREATE TABLE [dbo].[temperature_data_history]
(
	[ident] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [container_id] VARCHAR(12) NULL, 
    [modem_imei] VARCHAR(15) NULL, 
    [vessel_id] VARCHAR(25) NULL,
    [temperatureF] SMALLINT NULL, 
    [logged_dt] DATETIME2 NOT NULL,
    [power] BIT,
    [battery_percent] SMALLINT NULL CHECK ([battery_percent] BETWEEN 0 AND 100),
    [co2_percent] SMALLINT NULL CHECK ([co2_percent] BETWEEN 0 AND 100),
    [o2_percent] SMALLINT NULL CHECK ([o2_percent] BETWEEN 0 AND 100), 
    [deforsting] BIT NULL, 
    [humidityPercent] SMALLINT NULL CHECK ([humidityPercent] BETWEEN 0 AND 100), 
    [received_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT [FK_temperature_data_history_container] FOREIGN KEY ([container_id]) REFERENCES [container]([container_id]), 
    CONSTRAINT [FK_temperature_data_history_vessel] FOREIGN KEY ([vessel_id]) REFERENCES [vessel]([vessel_id]), 
    CONSTRAINT [FK_temperature_data_history_modem] FOREIGN KEY ([modem_imei]) REFERENCES [modem]([modem_imei]),
    CONSTRAINT [UQ_temperature_data_history] UNIQUE ([container_id], [vessel_id], [modem_imei],[logged_dt]),
    
)



GO

CREATE NONCLUSTERED INDEX [IX_temperature_data_history_container_id] ON [dbo].[temperature_data_history] ([container_id])

GO

CREATE NONCLUSTERED INDEX [IX_temperature_data_history_vessel_id] ON [dbo].[temperature_data_history] ([vessel_id])

GO

CREATE NONCLUSTERED INDEX [IX_temperature_data_history_modem_imei] ON [dbo].[temperature_data_history] ([modem_imei])

GO

CREATE NONCLUSTERED INDEX [IX_temperature_data_history_logged_dt] ON [dbo].[temperature_data_history] ([logged_dt])
