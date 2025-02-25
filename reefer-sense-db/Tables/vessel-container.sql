﻿CREATE TABLE [dbo].[vessel-container]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [vessel_ident] INT NOT NULL, 
    [container_ident] INT NOT NULL, 
    [created_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT [FK_vessel-container_vessel] FOREIGN KEY ([vessel_ident]) REFERENCES [vessel]([ident]), 
    CONSTRAINT [FK_container-ident_container] FOREIGN KEY ([container_ident]) REFERENCES [container]([ident])
)
