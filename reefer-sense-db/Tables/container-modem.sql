CREATE TABLE [dbo].[container-modem]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [container-ident] INT NOT NULL, 
    [modem-ident] INT NOT NULL, 
    [created-dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [updated-dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT [FK_container-modem_container] FOREIGN KEY ([container-ident]) REFERENCES [container]([ident]), 
    CONSTRAINT [FK_container-modem_modem] FOREIGN KEY ([modem-ident]) REFERENCES [modem]([ident]), 

)
