CREATE TABLE [dbo].[vessel-container]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [vessel-ident] INT NOT NULL, 
    [container-ident] INT NOT NULL, 
    [created-dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [updated-dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT [FK_vessel-container_vessel] FOREIGN KEY ([vessel-ident]) REFERENCES [vessel]([ident]), 
    CONSTRAINT [FK_container-ident_container] FOREIGN KEY ([container-ident]) REFERENCES [container]([ident])
)
