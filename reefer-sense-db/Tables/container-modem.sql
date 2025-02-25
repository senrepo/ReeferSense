CREATE TABLE [dbo].[container-modem]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [container_ident] INT NOT NULL, 
    [modem_ident] INT NOT NULL, 
    [created_dt] DATETIME2 NOT NULL , 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT [FK_container-modem_container] FOREIGN KEY ([container_ident]) REFERENCES [container]([ident]), 
    CONSTRAINT [FK_container-modem_modem] FOREIGN KEY ([modem_ident]) REFERENCES [modem]([ident]), 

)
