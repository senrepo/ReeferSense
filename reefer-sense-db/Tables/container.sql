﻿CREATE TABLE [dbo].[container]
(
	[ident] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, 
    [container_id] VARCHAR(12) NOT NULL unique, 
    [created_dt] DATETIME2 NOT NULL , 
    [updated_dt] DATETIME2 NOT NULL DEFAULT GETDATE(),
    

)



GO

CREATE NONCLUSTERED INDEX [IX_container_container_id] ON [dbo].[container] ([container_id])
