CREATE TABLE [dbo].[modem-firmware]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [modem-ident] INT NOT NULL, 
    [firmware-ident] INT NOT NULL, 
    [created-dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [updated-dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT [FK_modem-firmware_ToTable_1] FOREIGN KEY ([modem-ident]) REFERENCES [modem]([ident]),
    CONSTRAINT [FK_modem-firmware_ToTable] FOREIGN KEY ([firmware-ident]) REFERENCES [firmware]([ident])
)
