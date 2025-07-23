CREATE TABLE [dbo].[TGroup]
(
[GroupId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (64) NOT NULL,
[GroupingId] [int] NOT NULL,
[ParentId] [int] NULL,
[CRMContactId] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[LegalEntity] [bit] NOT NULL CONSTRAINT [DF_TGroup_LegalEntity] DEFAULT ((0)),
[GroupImageLocation] [varchar] (500) NULL,
[AcknowledgementsLocation] [varchar] (500) NULL,
[FinancialYearEnd] [datetime] NULL,
[ApplyFactFindBranding] [bit] NOT NULL CONSTRAINT [DF_TGroup_ApplyFactFindBranding] DEFAULT ((1)),
[VatRegNbr] [varchar] (50) NULL,
[FSARegNbr] [varchar] (24) NULL,
[AuthorisationText] [varchar] (500) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroup_ConcurrencyId] DEFAULT ((1)),
[IsFSAPassport] [bit] NULL,
[FRNNumber] [varchar] (10) NULL,
[DocumentFileReference] [varchar] (100) NULL,
[MigrationRef] [varchar] (255) NULL,
[AdminEmail] [varchar] (128) NULL,
[DefaultClientGroupId] [int] NULL,
[ExternalRef] [varchar] (50) NULL
)
GO
ALTER TABLE [dbo].[TGroup] ADD CONSTRAINT [PK_TGroup] PRIMARY KEY NONCLUSTERED  ([GroupId])
GO
CREATE CLUSTERED INDEX [IDX1_TGroup_IndigoClientId_GroupingId] ON [dbo].[TGroup] ([IndigoClientId], [GroupingId])
GO
ALTER TABLE [dbo].[TGroup] WITH CHECK ADD CONSTRAINT [FK_TGroup_GroupingId_GroupingId] FOREIGN KEY ([GroupingId]) REFERENCES [dbo].[person] ([id])
GO
ALTER TABLE [dbo].[TGroup] WITH CHECK ADD CONSTRAINT [FK_TGroup_ParentId_GroupId] FOREIGN KEY ([ParentId]) REFERENCES [dbo].[person] ([id])
GO
CREATE NONCLUSTERED INDEX [IDX_TGroup_ParentId] ON [dbo].[TGroup] ([ParentId])
GO
CREATE NONCLUSTERED INDEX [IDX_TGroup_GroupingId] ON [dbo].[TGroup] ([GroupingId])
GO
CREATE NONCLUSTERED INDEX [IDX_TGroup_Identifier] ON [dbo].[TGroup] ([Identifier])
GO
CREATE NONCLUSTERED INDEX [IDX_TGroup_MigrationRef] ON [dbo].[TGroup] ([MigrationRef])
GO


create index ix_tgroup_IndigoClientId_GroupingId_legalentity on Tgroup (groupid) include (ParentId,Identifier,LegalEntity) 
GO
CREATE NONCLUSTERED INDEX IX_TGroup_CRMContactId  ON [dbo].[TGroup] ([CRMContactId]) INCLUDE ([GroupId])
GO
