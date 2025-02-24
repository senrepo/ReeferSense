CREATE TABLE [dbo].[company-vessel]
(
	[ident] INT NOT NULL PRIMARY KEY, 
    [company-ident] INT NOT NULL, 
    [vessel-ident] INT NOT NULL, 
    [created-dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [updated-dt] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    CONSTRAINT [FK_company-vessel_vessel] FOREIGN KEY ([vessel-ident]) REFERENCES [vessel]([ident]), 
    CONSTRAINT [FK_company-vessel_company] FOREIGN KEY ([company-ident]) REFERENCES [company]([ident])
)
