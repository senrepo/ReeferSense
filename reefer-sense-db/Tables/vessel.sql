﻿CREATE TABLE [dbo].[vessel]
(
	[ident] INT NOT NULL PRIMARY KEY, 
	[company_ident] INT NOT NULL,
	[vessel_id] VARCHAR(25) NOT NULL UNIQUE,
    [vessel_name] VARCHAR(50) NOT NULL, 
    CONSTRAINT [FK_vessel_company] FOREIGN KEY ([company_ident]) REFERENCES [company]([ident])
)
