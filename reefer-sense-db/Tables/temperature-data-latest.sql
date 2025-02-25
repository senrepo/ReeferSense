﻿CREATE TABLE [dbo].[temperature-data-latest]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [container_ident] INT NOT NULL UNIQUE, 
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
    CONSTRAINT [FK_temperature-data-latest_container] FOREIGN KEY ([container_ident]) REFERENCES [container]([ident]), 
    CONSTRAINT [FK_temperature-data-latest_modem] FOREIGN KEY ([modem_imei]) REFERENCES [modem]([modem_imei]), 
    CONSTRAINT [FK_temperature-data-latest_vessel] FOREIGN KEY ([vessel_id]) REFERENCES [vessel]([vessel_id])
)
