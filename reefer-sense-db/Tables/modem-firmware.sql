CREATE TABLE [dbo].[modem-firmware]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [modem-ident] INT NOT NULL, 
    [firmware-ident] INT NOT NULL, 
    [created-dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [updated-dt] DATETIME2 NOT NULL DEFAULT GETDATE()
)
