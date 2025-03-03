CREATE TABLE [dbo].[company_modem]
(
	[ident] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [company_ident] INT NOT NULL, 
    [modem_ident] INT NOT NULL, 
    [created_dt] DATETIME2 NOT NULL, 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT [FK_company_modem_company] FOREIGN KEY ([company_ident]) REFERENCES [company]([ident]), 
    CONSTRAINT [FK_company_modem_modem] FOREIGN KEY ([modem_ident]) REFERENCES [modem]([ident]),
    CONSTRAINT [UQ_company_modem] UNIQUE ([company_ident], [modem_ident])
)
