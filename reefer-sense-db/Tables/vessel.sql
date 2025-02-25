CREATE TABLE [dbo].[vessel]
(
	[ident] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
	[company_ident] INT NOT NULL,
	[vessel_id] VARCHAR(25) NOT NULL UNIQUE,
    [vessel_name] VARCHAR(50) NOT NULL, 
    [created_dt] DATETIME2 NOT NULL , 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT [FK_vessel_company] FOREIGN KEY ([company_ident]) REFERENCES [company]([ident])
)
