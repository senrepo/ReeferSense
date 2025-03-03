CREATE TABLE [dbo].[company_vessel]
(
	[ident] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [company_ident] INT NOT NULL, 
    [vessel_ident] INT NOT NULL, 
    [created_dt] DATETIME2 NOT NULL , 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT [FK_company_vessel_company] FOREIGN KEY ([company_ident]) REFERENCES [company]([ident]),
    CONSTRAINT [FK_company_vessel_vessel] FOREIGN KEY ([vessel_ident]) REFERENCES [vessel]([ident]), 
    CONSTRAINT [UQ_company_vessel] UNIQUE ([company_ident], [vessel_ident])
)
