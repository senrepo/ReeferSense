CREATE TABLE [dbo].[modem_firmware]
(
	[ident] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [modem_ident] INT NOT NULL, 
    [firmware_ident] INT NOT NULL, 
    [created_dt] DATETIME2 NOT NULL , 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT [FK_modem_firmware_modem] FOREIGN KEY ([modem_ident]) REFERENCES [modem]([ident]),
    CONSTRAINT [FK_modem_firmware_firmware] FOREIGN KEY ([firmware_ident]) REFERENCES [firmware]([ident])
)
