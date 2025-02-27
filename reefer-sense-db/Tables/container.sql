CREATE TABLE [dbo].[container]
(
	[ident] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [container_id] VARCHAR(12) NOT NULL, 
    [created_dt] DATETIME2 NOT NULL , 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE()
)
