CREATE TABLE [dbo].[temperature_data_latest]
(
	[ident] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [container_id] VARCHAR(12) NULL, 
    [modem_imei] VARCHAR(15) NULL, 
    [vessel_id] VARCHAR(25) NULL,
    [temperaturF] DECIMAL(5, 2) NULL, 
    [logged_dt] DATETIME2 NOT NULL,
    [power] BIT,
    [battery_percent] SMALLINT NULL CHECK ([battery_percent] BETWEEN 0 AND 100),
    [co2_percent] SMALLINT NULL CHECK ([co2_percent] BETWEEN 0 AND 100),
    [o2_percent] SMALLINT NULL CHECK ([o2_percent] BETWEEN 0 AND 100), 
    [deforsting] BIT NULL, 
    [humidityPercent] SMALLINT NULL CHECK ([humidityPercent] BETWEEN 0 AND 100), 
    [received_dt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [FK_temperature_data_latest_container] FOREIGN KEY ([container_id]) REFERENCES [container](container_id), 
    CONSTRAINT [FK_temperature_data_latest_modem] FOREIGN KEY ([modem_imei]) REFERENCES [modem]([modem_imei]), 
    CONSTRAINT [FK_temperature_data_latest_vessel] FOREIGN KEY ([vessel_id]) REFERENCES [vessel]([vessel_id]),
    CONSTRAINT [UQ_temperature_data_latest] UNIQUE ([container_id], [vessel_id], [modem_imei])
)

GO

CREATE NONCLUSTERED INDEX [IX_temperature_data_latest_Container] ON [dbo].[temperature_data_latest] ([Container_id])

GO

CREATE NONCLUSTERED INDEX [IX_temperature_data_latest_modem] ON [dbo].[temperature_data_latest] ([modem_imei])

GO

CREATE NONCLUSTERED INDEX [IX_temperature_data_latest_vessel] ON [dbo].[temperature_data_latest] ([vessel_id])
