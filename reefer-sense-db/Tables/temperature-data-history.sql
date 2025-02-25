CREATE TABLE [dbo].[temperature-data-history]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [container-ident] INT NOT NULL, 
    [modem-imei] VARCHAR(15) NULL, 
    [vessel-id] VARCHAR(25) NULL,
    [temperaturF] DECIMAL(5, 2) NULL, 
    [logged-dt] DATETIME2 NOT NULL,
    [power] BIT,
    [battery-percent] SMALLINT NULL CHECK ([battery-percent] BETWEEN 0 AND 100),
    [co2-percent] SMALLINT NULL CHECK ([co2-percent] BETWEEN 0 AND 100),
    [o2-percent] SMALLINT NULL CHECK ([o2-percent] BETWEEN 0 AND 100), 
    [deforsting] BIT NULL, 
    [humidityPercent] SMALLINT NULL CHECK ([humidityPercent] BETWEEN 0 AND 100), 
    [received-dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT [FK_temperature-data-history_container] FOREIGN KEY ([container-ident]) REFERENCES [container]([ident]), 
    CONSTRAINT [FK_temperature-data-history_vessel] FOREIGN KEY ([vessel-id]) REFERENCES [vessel]([vessel-id]), 
    CONSTRAINT [FK_temperature-data-history_modem] FOREIGN KEY ([modem-imei]) REFERENCES [modem]([modem-imei])

)
