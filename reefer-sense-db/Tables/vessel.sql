CREATE TABLE [dbo].[vessel]
(
	[ident] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
	[vessel_id] VARCHAR(25) NOT NULL UNIQUE,
    [vessel_name] VARCHAR(50) NOT NULL, 
    [created_dt] DATETIME2 NOT NULL , 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
)





GO

CREATE NONCLUSTERED INDEX [IX_vessel_temperature_data_latest] ON [dbo].[vessel] ([vessel_id])

GO

CREATE NONCLUSTERED INDEX [IX_vessel_temperature_data_history] ON [dbo].[vessel] ([vessel_id])
