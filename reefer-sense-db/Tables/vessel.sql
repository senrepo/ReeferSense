CREATE TABLE [dbo].[vessel]
(
	[ident] INT NOT NULL PRIMARY KEY, 
	[company-ident] INT NOT NULL,
	[vessel-id] VARCHAR(25) NOT NULL,
    [vessel-name] VARCHAR(50) NOT NULL
)
