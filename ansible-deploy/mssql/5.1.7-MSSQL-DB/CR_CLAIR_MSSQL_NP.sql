--------------------------------------------------------
-- Name    : CR_CLAIR_MSSQL.sql
-- Purpose : This script installs ClairMail OLTP Schema.
-- The default scripts will make the data filegroup the default to tables will go that filegroup by default
-- The index filegroup is passed in to make sure that it does not go on the filgroup for tables
-- SECU 343
-- Note if running in Standard Edition you will need to change ONLINE=OFF to ONLINE=OFF
-- Steps to execute the script from command line:
-- C:> sqlcmd -S IPAddress\InstanceName -d OLTPDataBaseName -U OLTPUser -P OLTPPassword -v oltpdb="OLTPDataBaseName"  -i CR_CLAIR_MSSQL.sql
-- For Example:
-- C:> sqlcmd -S PS4714\CLAIRMAILDB -d clairdb -U testoltpuser -P testoltppass -v oltpdb="clairdb"  -i CR_CLAIR_MSSQL.sql
--------------------------------------------------------

use [$(oltpdb)]
go
declare @sql nvarchar(max)
declare @scriptversion nvarchar(30)

if (exists (select * from information_schema.tables where table_schema = 'dbo' and  table_name = 'script_audit')) 
   begin
	print 'The CR_CLAIR_MSSQL.sql file is already executed once.Please contact your ClairMail System Administrator'
   end	
else
   begin
	set @scriptversion='5.1.7'
	create table script_audit (createdate datetime not null,lastupdated datetime,scriptname nvarchar(128) not null,scriptversion nvarchar(128) not null,osuser nvarchar(128),currentuser nvarchar(128),hostname nvarchar(128),ipaddress nvarchar(15),dbauser nvarchar(10),comments nvarchar(256),status nvarchar(10) not null);

	insert into script_audit
	select current_timestamp,
		null,
		'CR_CLAIR_MSSQL.sql',
		@scriptversion,
		system_user,
		current_user,
		hostname.*,
		null,
		is_srvrolemember ('sysadmin'),
		'OLTP Schema creation script',
		'STARTED'
	from (select host_name from sys.dm_exec_sessions where status = 'running') as hostname
end

GO

/****** Object:  Table [dbo].[statemodel]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[statemodel]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[statemodel](
	[state_model_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[statemodelversion] [float] NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[state_id] [nchar](32) NULL,
	[daystoexpirefromfinal] [int] NULL,
 CONSTRAINT [pk_statemodel_statemodid] PRIMARY KEY CLUSTERED 
(
	[state_model_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk__statemodel_stmodver_name] UNIQUE NONCLUSTERED 
(
	[statemodelversion] ASC,
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[statemodel]') AND name = N'sm_state_id_idx')
CREATE NONCLUSTERED INDEX [sm_state_id_idx] ON [dbo].[statemodel] 
(
	[state_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[actioncontext]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[actioncontext]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[actioncontext](
	[action_context_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[name] [nvarchar](255) NULL,
	[state_model_id] [nchar](32) NULL,
	[actionclassname] [nvarchar](255) NOT NULL,
	[type] [nvarchar](255) NOT NULL,
	[label] [nvarchar](255) NOT NULL,
 CONSTRAINT [pk_actioncontext_contextid] PRIMARY KEY CLUSTERED 
(
	[action_context_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[actioncontext]') AND name = N'actcontext_statemodelid_idx')
CREATE NONCLUSTERED INDEX [actcontext_statemodelid_idx] ON [dbo].[actioncontext] 
(
	[state_model_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[actionlog]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[actionlog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[actionlog](
	[action_log_id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[correlationid] [nchar](36) NULL,
	[action_context_id] [nchar](32) NULL,
	[conversation_id] [nchar](32) NULL,
	[resultcode] [nvarchar](255) NULL,
 CONSTRAINT [pk_actionlog_actionlogid] PRIMARY KEY NONCLUSTERED 
(
	[action_log_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ACTIONLOG]') AND name = N'IX_ACTIONLOG_CREATEDATE_Partitioning')
CREATE CLUSTERED INDEX [IX_ACTIONLOG_CREATEDATE_Partitioning] ON [dbo].[ACTIONLOG] 
(
	[ACTION_LOG_ID],[CREATEDATE]
)WITH ( DROP_EXISTING = OFF) ON [$(oltpdb)_index]
go


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[actionlog]') AND name = N'al_ac_id_idx')
CREATE NONCLUSTERED INDEX [al_ac_id_idx] ON [dbo].[actionlog] 
(
	[action_context_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[actionlog]') AND name = N'al_conv_id_idx')
CREATE NONCLUSTERED INDEX [al_conv_id_idx] ON [dbo].[actionlog] 
(
	[conversation_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[action_properties]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[action_properties]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[action_properties](
	[action_context_id] [nchar](32) NOT NULL,
	[action_prop_value] [nvarchar](255) NULL,
	[action_prop_key] [nvarchar](255) NOT NULL,
 CONSTRAINT [pk_action_propertie_conid_propkey] PRIMARY KEY CLUSTERED 
(
	[action_context_id] ASC,
	[action_prop_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[action_properties]') AND name = N'actprop_contextid_idx')
CREATE NONCLUSTERED INDEX [actprop_contextid_idx] ON [dbo].[action_properties] 
(
	[action_context_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[state]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[state]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[state](
	[state_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[name] [nvarchar](255) NULL,
	[state_model_id] [nchar](32) NULL,
	[terminal] [tinyint] NOT NULL,
 CONSTRAINT [pk_state_stateid] PRIMARY KEY CLUSTERED 
(
	[state_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[state]') AND name = N'state_sm_id_idx')
CREATE NONCLUSTERED INDEX [state_sm_id_idx] ON [dbo].[state] 
(
	[state_model_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[transitionlist]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[transitionlist]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[transitionlist](
	[transition_list_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[name] [nvarchar](255) NULL,
	[state_model_id] [nchar](32) NULL,
	[state_id] [nchar](32) NULL,
	[event_transition_key] [nvarchar](255) NULL,
 CONSTRAINT [pk_translist_translistid] PRIMARY KEY CLUSTERED 
(
	[transition_list_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[transitionlist]') AND name = N'tl_state_id_idx')
CREATE NONCLUSTERED INDEX [tl_state_id_idx] ON [dbo].[transitionlist] 
(
	[state_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[transitionlist]') AND name = N'translist_statmodid_idx')
CREATE NONCLUSTERED INDEX [translist_statmodid_idx] ON [dbo].[transitionlist] 
(
	[state_model_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[transition]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[transition]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[transition](
	[transition_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[name] [nvarchar](255) NULL,
	[state_model_id] [nchar](32) NULL,
	[state_id] [nchar](32) NULL,
	[transition_list_id] [nchar](32) NULL,
	[transition_list_idx] [int] NULL,
 CONSTRAINT [pk_transition_transid] PRIMARY KEY CLUSTERED 
(
	[transition_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[transition]') AND name = N'tr_tl_id_idx')
CREATE NONCLUSTERED INDEX [tr_tl_id_idx] ON [dbo].[transition] 
(
	[transition_list_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[transition]') AND name = N'trans_stateid_idx')
CREATE NONCLUSTERED INDEX [trans_stateid_idx] ON [dbo].[transition] 
(
	[state_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[transition]') AND name = N'trans_stmodid_idx')
CREATE NONCLUSTERED INDEX [trans_stmodid_idx] ON [dbo].[transition] 
(
	[state_model_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[conditioncontext]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[conditioncontext]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[conditioncontext](
	[condition_context_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[name] [nvarchar](255) NULL,
	[state_model_id] [nchar](32) NULL,
	[conditionclassname] [nvarchar](255) NOT NULL,
	[transition_id] [nchar](32) NULL,
	[transition_list_idx] [int] NULL,
 CONSTRAINT [pk_conditioncontext_contextid] PRIMARY KEY CLUSTERED 
(
	[condition_context_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[conditioncontext]') AND name = N'cc_tran_id_idx')
CREATE NONCLUSTERED INDEX [cc_tran_id_idx] ON [dbo].[conditioncontext] 
(
	[transition_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[conditioncontext]') AND name = N'condcontext_statemodid_idx')
CREATE NONCLUSTERED INDEX [condcontext_statemodid_idx] ON [dbo].[conditioncontext] 
(
	[state_model_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[condition_properties]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[condition_properties]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[condition_properties](
	[condition_context_id] [nchar](32) NOT NULL,
	[condition_prop_value] [nvarchar](255) NULL,
	[condition_prop_key] [nvarchar](255) NOT NULL,
 CONSTRAINT [pk_condprop_contidpropkey] PRIMARY KEY CLUSTERED 
(
	[condition_context_id] ASC,
	[condition_prop_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[condition_properties]') AND name = N'condprop_condcontextid_idx')
CREATE NONCLUSTERED INDEX [condprop_condcontextid_idx] ON [dbo].[condition_properties] 
(
	[condition_context_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[alertreferencetype]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[alertreferencetype]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[alertreferencetype](
	[alert_reference_type_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[description] [nvarchar](1000) NOT NULL,
 CONSTRAINT [pk_altreftype_altreftypeid] PRIMARY KEY CLUSTERED 
(
	[alert_reference_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_altreftype_desc] UNIQUE NONCLUSTERED 
(
	[description] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[alertreference]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[alertreference]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[alertreference](
	[alert_reference_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[externalid] [nvarchar](255) NULL,
	[alert_reference_type_id] [nchar](32) NULL,
 CONSTRAINT [pk_alertref_alertrefid] PRIMARY KEY CLUSTERED 
(
	[alert_reference_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_alertref_extidalertreftypeid] UNIQUE NONCLUSTERED 
(
	[externalid] ASC,
	[alert_reference_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alertreference]') AND name = N'ar_art_id_idx')
CREATE NONCLUSTERED INDEX [ar_art_id_idx] ON [dbo].[alertreference] 
(
	[alert_reference_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alertreference]') AND name = N'ar_exid_idx')
CREATE NONCLUSTERED INDEX [ar_exid_idx] ON [dbo].[alertreference] 
(
	[externalid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[person]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[person]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[person](
	[person_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[givenname] [nvarchar](255) NULL,
	[middlename] [nvarchar](255) NULL,
	[familyname] [nvarchar](255) NULL,
	[dob] [datetime] NULL,
	[gender] [nvarchar](255) NULL,
	[preferredlocale] [nvarchar](255) NULL,
	[timezone] [nvarchar](255) NOT NULL,
	[username] [nvarchar](255) NOT NULL,
	[extusername] [nvarchar](255) NULL,
	[user_password_digest] [nvarchar](1024) NULL,
 CONSTRAINT [pk_person_personid] PRIMARY KEY CLUSTERED 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_personextusername] UNIQUE NONCLUSTERED 
(
	[extusername] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_personusername] UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[statemodelregistration]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[statemodelregistration]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[statemodelregistration](
	[state_model_reg_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[alert_reference_id] [nchar](32) NULL,
	[statemodelname] [nvarchar](255) NULL,
	[person_id] [nchar](32) NULL,
 CONSTRAINT [pk_statemodreg_stmodregid] PRIMARY KEY CLUSTERED 
(
	[state_model_reg_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[statemodelregistration]') AND name = N'smr_alert_ref_id_idx')
CREATE NONCLUSTERED INDEX [smr_alert_ref_id_idx] ON [dbo].[statemodelregistration] 
(
	[alert_reference_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[statemodelregistration]') AND name = N'smr_person_id_idx')
CREATE NONCLUSTERED INDEX [smr_person_id_idx] ON [dbo].[statemodelregistration] 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[conversation]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[conversation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[conversation](
	[conversation_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[state_id] [nchar](32) NULL,
	[content] [varbinary](max) NOT NULL,
	[state_model_reg_id] [nchar](32) NULL,
	[state_model_id] [nchar](32) NULL,
	[expiretimestamp] [datetime] NULL,
	[terminated] [tinyint] NOT NULL,
	[alerttypedescription] [nvarchar](1000) NOT NULL,
 CONSTRAINT [pk_conversation_convid] PRIMARY KEY CLUSTERED 
(
	[conversation_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[conversation]') AND name = N'conv_sm_id_idx')
CREATE NONCLUSTERED INDEX [conv_sm_id_idx] ON [dbo].[conversation] 
(
	[state_model_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[conversation]') AND name = N'conv_smr_id_idx')
CREATE NONCLUSTERED INDEX [conv_smr_id_idx] ON [dbo].[conversation] 
(
	[state_model_reg_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[conversation]') AND name = N'conv_state_id_idx')
CREATE NONCLUSTERED INDEX [conv_state_id_idx] ON [dbo].[conversation] 
(
	[state_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[pendingevent]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pendingevent]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[pendingevent](
	[pending_event_id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[name] [nvarchar](255) NULL,
	[alias] [nvarchar](255) NULL,
	[reschedulecount] [numeric](10, 0) NULL,
	[arexternalid] [nvarchar](255) NULL,
	[firetime] [datetime] NULL,
	[giveuptime] [datetime] NULL,
	[artypedescription] [nvarchar](255) NULL,
	[lockexpiry] [datetime] NULL,
	[owner] [nvarchar](255) NULL,
	[conversation_id] [nchar](32) NULL,
	[content] [varbinary](max) NOT NULL,
 CONSTRAINT [pendingevent_pkey] PRIMARY KEY CLUSTERED 
(
	[pending_event_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[pendingevent]') AND name = N'pe_conv_id_idx')
CREATE NONCLUSTERED INDEX [pe_conv_id_idx] ON [dbo].[pendingevent] 
(
	[conversation_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[pendingevent]') AND name = N'pe_firetime_idx')
CREATE NONCLUSTERED INDEX [pe_firetime_idx] ON [dbo].[pendingevent] 
(
	[firetime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[pendingevent]') AND name = N'pe_lockexpiry_idx')
CREATE NONCLUSTERED INDEX [pe_lockexpiry_idx] ON [dbo].[pendingevent] 
(
	[lockexpiry] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[pendingevent]') AND name = N'pe_owner_idx')
CREATE NONCLUSTERED INDEX [pe_owner_idx] ON [dbo].[pendingevent] 
(
	[owner] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[state_model_properties]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[state_model_properties]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[state_model_properties](
	[state_model_id] [nchar](32) NOT NULL,
	[state_model_prop_value] [nvarchar](255) NULL,
	[state_model_prop_key] [nvarchar](255) NOT NULL,
 CONSTRAINT [pk_stmodprop_stmodid_stmodpropkey] PRIMARY KEY CLUSTERED 
(
	[state_model_id] ASC,
	[state_model_prop_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[state_model_properties]') AND name = N'stmodprop_stmodid_idx')
CREATE NONCLUSTERED INDEX [stmodprop_stmodid_idx] ON [dbo].[state_model_properties] 
(
	[state_model_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[exitactioncontext]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[exitactioncontext]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[exitactioncontext](
	[exit_action_id] [nchar](32) NOT NULL,
	[state_id] [nchar](32) NULL,
	[exit_action_list_idx] [int] NULL,
 CONSTRAINT [pk_exitactioncontex_exitactid] PRIMARY KEY CLUSTERED 
(
	[exit_action_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[entryactioncontext]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[entryactioncontext]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[entryactioncontext](
	[entry_action_id] [nchar](32) NOT NULL,
	[state_id] [nchar](32) NULL,
	[entry_action_list_idx] [int] NULL,
 CONSTRAINT [pk_entryactioncont_entryactid] PRIMARY KEY CLUSTERED 
(
	[entry_action_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[entryactioncontext]') AND name = N'entryactcntxt_stateid_idx')
CREATE NONCLUSTERED INDEX [entryactcntxt_stateid_idx] ON [dbo].[entryactioncontext] 
(
	[state_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[transitionactioncontext]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[transitionactioncontext]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[transitionactioncontext](
	[transition_action_id] [nchar](32) NOT NULL,
	[transition_id] [nchar](32) NULL,
	[transition_list_idx] [int] NULL,
 CONSTRAINT [pk_transaction_transactid] PRIMARY KEY CLUSTERED 
(
	[transition_action_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[transitionactioncontext]') AND name = N'tac_tran_id_idx')
CREATE NONCLUSTERED INDEX [tac_tran_id_idx] ON [dbo].[transitionactioncontext] 
(
	[transition_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[tenant]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tenant]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tenant](
	[tenant_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenantkey] [nvarchar](255) NULL,
	[tenantname] [nvarchar](255) NULL,
 CONSTRAINT [pk_tenant_tenantid] PRIMARY KEY CLUSTERED 
(
	[tenant_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_tenant_tenantkey] UNIQUE NONCLUSTERED 
(
	[tenantkey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[weeklyusagemonitor]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[weeklyusagemonitor]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[weeklyusagemonitor](
	[weekly_usage_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[currentusage] [float] NULL,
	[lastcycledate] [datetime] NULL,
 CONSTRAINT [pk_weeklyusagemonitor_id] PRIMARY KEY CLUSTERED 
(
	[weekly_usage_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[wcsession]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[wcsession]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[wcsession](
	[sessionid] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[authenticated] [tinyint]  NOT NULL DEFAULT (0),
	[userfirstname] [nvarchar](255) NULL,
	[userlastname] [nvarchar](255) NULL,
	[sourcephone] [nvarchar](255) NULL,
	[sourceton] [nvarchar](255) NULL,
	[sourcenpi] [nvarchar](255) NULL,
	[sourcecarrier] [nvarchar](255) NULL,
	[userid] [nvarchar](255) NULL,
	[externalid] [nvarchar](255) NULL,
	[tenant_id] [nchar](32) NULL,
	[tenantkey] [nvarchar](255) NULL,
	[clienttype] [nvarchar](255) NULL,
	[app_id] [nvarchar](255) NULL,
	[lastactive] [datetime] NULL,
	[expires] [datetime] NULL,
	[authState] [numeric](1) NOT NULL DEFAULT (0),
	
 CONSTRAINT [pk_wcsession_sessid] PRIMARY KEY CLUSTERED 
(
	[sessionid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
CONSTRAINT [wcsession_extId_clientType] UNIQUE NONCLUSTERED 
(
	[externalId] ASC,
	[clientType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[sessions]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sessions]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[sessions](
	[tenant_id] [nvarchar](255) NOT NULL,
	[source_name] [nvarchar](255) NOT NULL,
	[target_name] [nvarchar](255) NOT NULL,
	[session_data] [varbinary](max) NULL,
	[last_access] [datetime] NULL,
 CONSTRAINT [pk_sessions_tntidsrcnametarname] PRIMARY KEY CLUSTERED 
(
	[tenant_id] ASC,
	[source_name] ASC,
	[target_name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[servicedata]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[servicedata]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[servicedata](
	[service_data_key] [nvarchar](64) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[service_name] [nvarchar](255) NULL,
	[service_data_value] [nvarchar](1024) NULL,
	[expiretimestamp] [datetime] NULL,
 CONSTRAINT [pk_servicedata] PRIMARY KEY CLUSTERED 
(
	[service_data_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[source_address_history]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[source_address_history]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[source_address_history](
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[entityid] [nvarchar](255) NOT NULL,
	[entityversion] [numeric](19, 0) NULL,
	[eventtimestamp] [datetime] NOT NULL,
	[eventtype] [nvarchar](255) NOT NULL,
	[eventpersonid] [nvarchar](255) NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[verified] [tinyint] NOT NULL,
	[optout] [tinyint] NOT NULL,
	[enabled] [tinyint] NOT NULL,
	[disconnected] [tinyint] NOT NULL,
	[nickname] [nvarchar](255) NULL,
 CONSTRAINT [pk_source_address_history_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[source_address_history]') AND name = N'srcaddrhist_entity_id_idx')
CREATE NONCLUSTERED INDEX [srcaddrhist_entity_id_idx] ON [dbo].[source_address_history] 
(
	[entityid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[permission]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[permission]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[permission](
	[permission_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[name] [nvarchar](255) NOT NULL,
 CONSTRAINT [pk_permission_permissionid] PRIMARY KEY CLUSTERED 
(
	[permission_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[periodic_notification_lock]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[periodic_notification_lock]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[periodic_notification_lock](
	[node_notification_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[notificationid] [nvarchar](255) NOT NULL,
	[nodeid] [nvarchar](255) NOT NULL,
	[fetchdate] [datetime] NOT NULL,
 CONSTRAINT [pk_pernotiflock_nodnotid] PRIMARY KEY CLUSTERED 
(
	[node_notification_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_pernotiflock_notifid] UNIQUE NONCLUSTERED 
(
	[notificationid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[periodic_notification]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[periodic_notification]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[periodic_notification](
	[notification_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[phoneid] [nvarchar](255) NOT NULL,
	[messagekey] [nvarchar](255) NOT NULL,
	[messagelocale] [nvarchar](255) NOT NULL,
	[lastsentdate] [datetime] NOT NULL,
	[nextsentdate] [datetime] NOT NULL,
	[notificationperiod] [int] NOT NULL,
 CONSTRAINT [pk_pernotif_notiid] PRIMARY KEY CLUSTERED 
(
	[notification_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_pernotif_phoneid] UNIQUE NONCLUSTERED 
(
	[phoneid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[location]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[location]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[location](
	[location_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[name] [nvarchar](255) NULL,
	[administrativearea] [nvarchar](100) NOT NULL,
	[locality] [nvarchar](100) NOT NULL,
	[thoroughfare] [nvarchar](100) NOT NULL,
	[postalcode] [nvarchar](59) NOT NULL,
	[country] [nvarchar](59) NOT NULL,
	[lastupdatedby] [nvarchar](255) NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL,
	[accuracy] [int] NULL,
	[errorcode] [int] NULL,
	[identifier] [nvarchar](255) NULL,
	[type] [int] NULL,
 CONSTRAINT [pk_location_locid] PRIMARY KEY CLUSTERED 
(
	[location_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_location_tenant_id] UNIQUE NONCLUSTERED 
(
	[tenant_id] ASC,
	[thoroughfare] ASC,
	[locality] ASC,
	[administrativearea] ASC,
	[postalcode] ASC,
	[country] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[eventimportance]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eventimportance]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[eventimportance](
	[event_importance_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[importance] [nvarchar](255) NOT NULL,
 CONSTRAINT [pk_eventimp_eventimpid] PRIMARY KEY CLUSTERED 
(
	[event_importance_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[principal]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[principal]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[principal](
	[principal_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
 CONSTRAINT [pk_principal_prinid] PRIMARY KEY CLUSTERED 
(
	[principal_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[person_history]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[person_history]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[person_history](
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[entityid] [nvarchar](255) NOT NULL,
	[entityversion] [numeric](19, 0) NULL,
	[eventtimestamp] [datetime] NOT NULL,
	[eventtype] [nvarchar](255) NOT NULL,
	[eventpersonid] [nvarchar](255) NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[givenname] [nvarchar](255) NULL,
	[middlename] [nvarchar](255) NULL,
	[familyname] [nvarchar](255) NULL,
	[dob] [datetime] NULL,
	[gender] [nvarchar](255) NULL,
	[preferredlocale] [nvarchar](255) NULL,
	[timezone] [nvarchar](255) NOT NULL,
	[username] [nvarchar](255) NOT NULL,
	[extusername] [nvarchar](255) NULL,
	[user_password_digest] [nvarchar](1024) NULL,
 CONSTRAINT [pk_person_history_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[notification_process_lock]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[notification_process_lock]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[notification_process_lock](
	[lock_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[processname] [nvarchar](255) NOT NULL,
	[nodeid] [nvarchar](255) NOT NULL,
	[fetchdate] [datetime] NOT NULL,
 CONSTRAINT [pk_notifproclock_lockid] PRIMARY KEY CLUSTERED 
(
	[lock_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[semaphore]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[semaphore]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[semaphore](
	[semaphore_id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
 CONSTRAINT [semaphore_pkey] PRIMARY KEY CLUSTERED 
(
	[semaphore_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_semaphore_name] UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[script_audit]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[script_audit]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[script_audit](
	[createdate] [datetime] NOT NULL,
	[lastupdated] [datetime] NULL,
	[scriptname] [nvarchar](128) NOT NULL,
	[scriptversion] [nvarchar](128) NOT NULL,
	[osuser] [nvarchar](128) NULL,
	[currentuser] [nvarchar](128) NULL,
	[hostname] [nvarchar](128) NULL,
	[ipaddress] [nvarchar](15) NULL,
	[dbauser] [nvarchar](10) NULL,
	[comments] [nvarchar](256) NULL,
	[status] [nvarchar](10) NOT NULL
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[schema_version]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[schema_version]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[schema_version](
	[schema_version_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[schemaversion] [nvarchar](255) NOT NULL,
 CONSTRAINT [pk_schema_version_schverid] PRIMARY KEY CLUSTERED 
(
	[schema_version_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_schema_version_schver] UNIQUE NONCLUSTERED 
(
	[schemaversion] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[REDELIVERY_QUEUE]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[REDELIVERY_QUEUE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[REDELIVERY_QUEUE](
	[REDELIVERY_QUEUE_ID] [nchar](32) NOT NULL,
	[VERSION] [decimal](18, 0) NOT NULL,
	[LASTUPDATED] [datetime] NULL,
	[CREATEDATE] [datetime] NULL,
	[CORRELATIONID] [nchar](36) NULL,
	[NODEID] [nvarchar](255) NOT NULL,
	[LASTACTIVE] [datetime] NULL,
	[RETRYATTEMPTS] [int] NOT NULL,
	[MESSAGEDATA] [image] NOT NULL,
 CONSTRAINT [PK_REDELIVERY_QUEUE_ID] PRIMARY KEY CLUSTERED 
(
	[REDELIVERY_QUEUE_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[REDELIVERY_QUEUE]') AND name = N'IX_REDELIVERY_QUEUE_ID')
CREATE UNIQUE NONCLUSTERED INDEX [IX_REDELIVERY_QUEUE_ID] ON [dbo].[REDELIVERY_QUEUE] 
(
	[REDELIVERY_QUEUE_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[REDELIVERY_QUEUE]') AND name = N'RQ_CORRELATION_ID_IDX')
CREATE NONCLUSTERED INDEX [RQ_CORRELATION_ID_IDX] ON [dbo].[REDELIVERY_QUEUE] 
(
	[CORRELATIONID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[REDELIVERY_QUEUE]') AND name = N'RQ_NODE_ID_IDX')
CREATE NONCLUSTERED INDEX [RQ_NODE_ID_IDX] ON [dbo].[REDELIVERY_QUEUE] 
(
	[NODEID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[source_address]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[source_address]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[source_address](
	[source_addr_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[verified] [tinyint] NOT NULL,
	[optout] [tinyint] NOT NULL,
	[enabled] [tinyint] NOT NULL,
	[disconnected] [tinyint] NOT NULL,
	[nickname] [nvarchar](255) NULL,
 CONSTRAINT [pk_source_address_srcaddrid] PRIMARY KEY CLUSTERED 
(
	[source_addr_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[clustermember]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[clustermember]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[clustermember](
	[cluster_member_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[nodeid] [nvarchar](255) NOT NULL,
	[lastheartbeat] [numeric](19, 0) NOT NULL,
	[managementurl] [nvarchar](255) NULL,
 CONSTRAINT [pk_clustermem_clustermemid] PRIMARY KEY CLUSTERED 
(
	[cluster_member_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_clustmem_nodeid] UNIQUE NONCLUSTERED 
(
	[nodeid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[carrier]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[carrier]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[carrier](
	[carrier_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[countrycode] [nvarchar](32) NULL,
	[description] [nvarchar](255) NULL,
 CONSTRAINT [pk_carrier_carrierid] PRIMARY KEY CLUSTERED 
(
	[carrier_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_carr_name_code] UNIQUE NONCLUSTERED 
(
	[name] ASC,
	[countrycode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[batch_step_execution_seq]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[batch_step_execution_seq]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[batch_step_execution_seq](
	[id] [bigint] IDENTITY(1,1) NOT NULL
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[discoevent]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[discoevent]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[discoevent](
	[disco_event_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[nodeid] [nvarchar](255) NOT NULL,
	[tagname] [nvarchar](255) NOT NULL,
	[eventstatus] [nvarchar](255) NULL,
	[discoeventtime] [datetime] NULL,
 CONSTRAINT [pk_discoevent_discoeventid] PRIMARY KEY CLUSTERED 
(
	[disco_event_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_discoevent_tagname] UNIQUE NONCLUSTERED 
(
	[tagname] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[dailyusagemonitor]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dailyusagemonitor]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dailyusagemonitor](
	[daily_usage_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[currentusage] [float] NULL,
	[lastcycledate] [datetime] NULL,
 CONSTRAINT [pk_dailyusagemonitor_id] PRIMARY KEY CLUSTERED 
(
	[daily_usage_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[correlationidalias]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[correlationidalias]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[correlationidalias](
	[alias_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[correlationid] [nvarchar](255) NOT NULL,
	[source] [nvarchar](255) NOT NULL,
	[target] [nvarchar](255) NOT NULL,
	[aliasname] [nvarchar](255) NOT NULL,
	[createdtimestamp] [datetime] NOT NULL,
 CONSTRAINT [pk_coridalias_aliasid] PRIMARY KEY CLUSTERED 
(
	[alias_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_coridalias_corid] UNIQUE NONCLUSTERED 
(
	[correlationid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[correlationidalias]') AND name = N'cor_alias_idx')
CREATE UNIQUE NONCLUSTERED INDEX [cor_alias_idx] ON [dbo].[correlationidalias] 
(
	[source] ASC,
	[target] ASC,
	[aliasname] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[dnd_range]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[dnd_range]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[dnd_range](
	[dnd_range_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[starttime] [datetime] NOT NULL,
	[endtime] [datetime] NOT NULL,
	[recurrence] [nvarchar](255) NOT NULL,
	[action] [nvarchar](255) NOT NULL,
 CONSTRAINT [pk_dndrang_dndrangeid] PRIMARY KEY CLUSTERED 
(
	[dnd_range_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[batch_execution_context]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[batch_execution_context]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[batch_execution_context](
	[execution_id] [bigint] NOT NULL,
	[discriminator] [nvarchar](1) NOT NULL,
	[type_cd] [nvarchar](6) NOT NULL,
	[key_name] [nvarchar](445) NOT NULL,
	[string_val] [nvarchar](1000) NULL,
	[date_val] [datetime] NULL,
	[long_val] [bigint] NULL,
	[double_val] [float] NULL,
	[object_val] [image] NULL
) ON [$(oltpdb)_data] TEXTIMAGE_ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[batch_execution_context]') AND name = N'execution_id_key_name_idx')
CREATE UNIQUE NONCLUSTERED INDEX [execution_id_key_name_idx] ON [dbo].[batch_execution_context] 
(
	[execution_id] ASC,
	[key_name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[batch_job_seq]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[batch_job_seq]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[batch_job_seq](
	[id] [bigint] IDENTITY(1,1) NOT NULL
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[batch_job_instance]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[batch_job_instance]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[batch_job_instance](
	[job_instance_id] [bigint] NOT NULL,
	[version] [bigint] NULL,
	[job_name] [nvarchar](100) NOT NULL,
	[job_key] [nvarchar](2500) NOT NULL,
 CONSTRAINT [pk_batjobinst_jobinstid] PRIMARY KEY CLUSTERED 
(
	[job_instance_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_batjobinst_jobnamejobkey] UNIQUE NONCLUSTERED 
(
	[job_name] ASC,
	[job_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[batch_job_execution_seq]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[batch_job_execution_seq]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[batch_job_execution_seq](
	[id] [bigint] IDENTITY(1,1) NOT NULL
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[alerttype]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[alerttype]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[alerttype](
	[alert_type_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[description] [nvarchar](1000) NOT NULL,
	[messagetemplatekey] [nvarchar](1000) NOT NULL,
	[fromkey] [nvarchar](255) NOT NULL,
	[subjectkey] [nvarchar](255) NOT NULL,
	[ruletemplatekey] [nvarchar](255) NOT NULL,
	[namespacekey] [nvarchar](255) NULL,
	[emailtemplatekey] [nvarchar](1000) NOT NULL,
	[textemailtemplatekey] [nvarchar](1000) NOT NULL,
	[validationtemplatekey] [nvarchar](1000) NULL,
 CONSTRAINT [pk_alerttype_alerttypeid] PRIMARY KEY CLUSTERED 
(
	[alert_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_alerttype_description] UNIQUE NONCLUSTERED 
(
	[description] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO


/****** Object:  Table [dbo].[alert_instance_history]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[alert_instance_history]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[alert_instance_history](
	[id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[entityid] [nvarchar](255) NOT NULL,
	[entityversion] [numeric](19, 0) NULL,
	[eventtimestamp] [datetime] NOT NULL,
	[eventtype] [nvarchar](255) NOT NULL,
	[eventpersonid] [nvarchar](255) NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[source_addr_id] [nchar](32) NULL,
	[alert_type_id] [nchar](32) NULL,
	[alert_reference_id] [nchar](32) NULL,
	[fromaddressuri] [nvarchar](255) NULL,
	[toaddressuri] [nvarchar](255) NULL,
	[subject] [nvarchar](255) NULL,
	[messagedata] [varbinary](max) NULL,
	[status] [nvarchar](255) NULL,
	[correlationid] [nchar](36) NULL,
	[protocol] [nvarchar](255) NULL,
 CONSTRAINT [pk_alertinshist_id] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
) ON [$(oltpdb)_data]
END
GO
SET ANSI_PADDING OFF

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alert_instance_history]') AND name = N'IX_alert_instance_history_eventtimestamp_Partitioning')
CREATE CLUSTERED INDEX [IX_alert_instance_history_eventtimestamp_Partitioning] ON [dbo].[alert_instance_history] 
(
	[ID],[eventtimestamp]
)WITH ( DROP_EXISTING = OFF) ON [$(oltpdb)_index]
go

GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alert_instance_history]') AND name = N'alertinsthist_srcaddr_idx')
CREATE NONCLUSTERED INDEX [alertinsthist_srcaddr_idx] ON [dbo].[alert_instance_history] 
(
	[source_addr_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alert_instance_history]') AND name = N'alertinsthist_timestamp_idx')
CREATE NONCLUSTERED INDEX [alertinsthist_timestamp_idx] ON [dbo].[alert_instance_history] 
(
	[eventtimestamp] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[aggregator]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aggregator]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[aggregator](
	[aggregator_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[name] [nvarchar](255) NULL,
	[description] [nvarchar](255) NULL,
	[enabled] [tinyint] NOT NULL,
 CONSTRAINT [pk_aggregator_aggregatorid] PRIMARY KEY CLUSTERED 
(
	[aggregator_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[address]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[address]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[address](
	[address_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[address1] [nvarchar](255) NOT NULL,
	[address2] [nvarchar](255) NULL,
	[address3] [nvarchar](255) NULL,
	[postalcode] [nvarchar](255) NOT NULL,
	[state] [nvarchar](255) NOT NULL,
	[country] [nvarchar](255) NOT NULL,
	[person_id] [nchar](32) NULL,
	[listindex] [int] NULL,
 CONSTRAINT [pk_addr_addressid] PRIMARY KEY CLUSTERED 
(
	[address_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[address]') AND name = N'address_person_id_idx')
CREATE NONCLUSTERED INDEX [address_person_id_idx] ON [dbo].[address] 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO


/****** Object:  Table [dbo].[cm_role]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cm_role]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[cm_role](
	[role_id] [nchar](32) NOT NULL,
	[name] [nvarchar](255) NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
 CONSTRAINT [pk_cm_role_rolid] PRIMARY KEY CLUSTERED 
(
	[role_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[cm_name]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cm_name]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[cm_name](
	[cm_name_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[owner_id] [nchar](32) NULL,
 CONSTRAINT [pk_cmname_cmnameid] PRIMARY KEY CLUSTERED 
(
	[cm_name_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[cm_name]') AND name = N'cmname_owner_id_idx')
CREATE NONCLUSTERED INDEX [cmname_owner_id_idx] ON [dbo].[cm_name] 
(
	[owner_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[clustermemberstatus]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[clustermemberstatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[clustermemberstatus](
	[cluster_status_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[statusitem] [nvarchar](255) NOT NULL,
	[status] [nvarchar](255) NOT NULL,
	[loadfactor] [float] NOT NULL,
	[cluster_member_id] [nchar](32) NULL,
 CONSTRAINT [pk_clustmemstat_cluststatid] PRIMARY KEY CLUSTERED 
(
	[cluster_status_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[clustermemberstatus]') AND name = N'clusmemstat_memberid_idx')
CREATE NONCLUSTERED INDEX [clusmemstat_memberid_idx] ON [dbo].[clustermemberstatus] 
(
	[cluster_member_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO

/****** Object:  Table [dbo].[smppcarriercode]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[smppcarriercode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[smppcarriercode](
	[tenant_id] [nchar](32) NOT NULL,
	[carriercode_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[code] [nvarchar](8) NULL,
	[carrier_id] [nchar](32) NULL,
	[listindex] [int] NULL,
	[aggregator_id] [nchar](32) NULL,
 CONSTRAINT [pk_carriercode_carriercodeid] PRIMARY KEY CLUSTERED 
(
	[carriercode_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[onetime_pin]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[onetime_pin]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[onetime_pin](
	[otp_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[pinvalue] [nvarchar](255) NULL,
	[expiretimestamp] [datetime] NULL,
	[numberattempts] [int] NULL,
	[person_id] [nchar](32) NOT NULL,
 CONSTRAINT [pk_onetimepin_otpid] PRIMARY KEY CLUSTERED 
(
	[otp_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[onetime_pin]') AND name = N'otp_person_id_idx')
CREATE NONCLUSTERED INDEX [otp_person_id_idx] ON [dbo].[onetime_pin] 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[person_dnd_range]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[person_dnd_range]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[person_dnd_range](
	[dnd_range_id] [nchar](32) NOT NULL,
	[person_id] [nchar](32) NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[listindex] [int] NULL,
 CONSTRAINT [pk_perdndrang_dndrangeid] PRIMARY KEY CLUSTERED 
(
	[dnd_range_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[person_dnd_range]') AND name = N'person_dnd_range_person_id_idx')
CREATE NONCLUSTERED INDEX [person_dnd_range_person_id_idx] ON [dbo].[person_dnd_range] 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[featureusage]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[featureusage]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[featureusage](
	[feature_usage_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[feature] [nvarchar](255) NOT NULL,
	[daily_trans_usage_id] [nchar](32) NULL,
	[weekly_trans_usage_id] [nchar](32) NULL,
	[daily_amount_usage_id] [nchar](32) NULL,
	[weekly_amount_usage_id] [nchar](32) NULL,
	[person_id] [nchar](32) NOT NULL,
	[listindex] [int] NULL,
 CONSTRAINT [pk_featureusage_id] PRIMARY KEY CLUSTERED 
(
	[feature_usage_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[phonenumber_history]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[phonenumber_history]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[phonenumber_history](
	[id] [numeric](19, 0) NOT NULL,
	[entityid] [nvarchar](255) NOT NULL,
	[entityversion] [numeric](19, 0) NULL,
	[eventtimestamp] [datetime] NOT NULL,
	[eventtype] [nvarchar](255) NOT NULL,
	[eventpersonid] [nvarchar](255) NULL,
	[ton] [nvarchar](255) NULL,
	[npi] [nvarchar](255) NULL,
	[carrier_id] [nchar](32) NULL,
	[countrycode] [nvarchar](255) NOT NULL,
	[areacode] [nvarchar](255) NULL,
	[phone_number] [nvarchar](255) NOT NULL,
	[person_id] [nchar](32) NULL,
 CONSTRAINT [pk_phonenumber_history_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[phonenumber_history]') AND name = N'phonenumbhist_entity_id_idx')
CREATE NONCLUSTERED INDEX [phonenumbhist_entity_id_idx] ON [dbo].[phonenumber_history] 
(
	[entityid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[phonenumber_history]') AND name = N'phonenumbhist_person_id_idx')
CREATE NONCLUSTERED INDEX [phonenumbhist_person_id_idx] ON [dbo].[phonenumber_history] 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[phonenumber]    Script Date: 07/16/2012 17:33:41 ******/
SET ARITHABORT ON
GO
SET CONCAT_NULL_YIELDS_NULL ON
GO
SET ANSI_NULLS ON
GO
SET ANSI_PADDING ON
GO
SET ANSI_WARNINGS ON
GO
SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ARITHABORT ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[phonenumber]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[phonenumber](
	[phone_id] [nchar](32) NOT NULL,
	[ton] [nvarchar](255) NULL,
	[npi] [nvarchar](255) NULL,
	[carrier_id] [nchar](32) NULL,
	[countrycode] [nvarchar](255) NOT NULL,
	[areacode] [nvarchar](255) NULL,
	[phone_number] [nvarchar](255) NOT NULL,
	[person_id] [nchar](32) NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[listindex] [int] NULL,
	[concat_phone_number]  AS (([countrycode]+[areacode])+[phone_number]),
 CONSTRAINT [pk_phonenumber_phoneid] PRIMARY KEY CLUSTERED 
(
	[phone_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[phonenumber]') AND name = N'phone_no_concat_idx')
CREATE UNIQUE NONCLUSTERED INDEX [phone_no_concat_idx] ON [dbo].[phonenumber] 
(
	[concat_phone_number] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[phonenumber]') AND name = N'phone_no_idx')
CREATE UNIQUE NONCLUSTERED INDEX [phone_no_idx] ON [dbo].[phonenumber] 
(
	[countrycode] ASC,
	[areacode] ASC,
	[phone_number] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[phonenumber]') AND name = N'phone_no_person_id_idx')
CREATE NONCLUSTERED INDEX [phone_no_person_id_idx] ON [dbo].[phonenumber] 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[personprofile]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[personprofile]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[personprofile](
	[profile_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[person_id] [nchar](32) NOT NULL,
	[profiledata] [varbinary](max) NULL,
 CONSTRAINT [pk_personprofile_profileid] PRIMARY KEY CLUSTERED 
(
	[profile_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[personprofile]') AND name = N'personprofile_person_id_idx')
CREATE NONCLUSTERED INDEX [personprofile_person_id_idx] ON [dbo].[personprofile] 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[personprincipal]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[personprincipal]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[personprincipal](
	[person_principal_id] [nchar](32) NOT NULL,
	[person_id] [nchar](32) NULL,
	[login_status] [nvarchar](255) NULL,
	[bad_login_count] [numeric](19, 0) NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
 CONSTRAINT [pk_personprin_personprinid] PRIMARY KEY CLUSTERED 
(
	[person_principal_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[personprincipal]') AND name = N'personprincipal_person_id_idx')
CREATE NONCLUSTERED INDEX [personprincipal_person_id_idx] ON [dbo].[personprincipal] 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[eventlogentry]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eventlogentry]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[eventlogentry](
	[event_log_id] [numeric](19, 0) IDENTITY(1,1) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[eventcode] [nchar](30) NOT NULL,
	[eventpersonid] [nchar](32) NULL,
	[eventmessageid] [nchar](36) NULL,
	[eventcorrelationid] [nchar](36) NULL,
	[eventdatetime] [datetime] NOT NULL,
	[nodeid] [nvarchar](255) NOT NULL,
	[eventimportanceid] [nchar](32) NOT NULL,
	[source] [nvarchar](255) NULL,
	[eventdescription] [nvarchar](1024) NOT NULL,
	[eventdetails] [nvarchar](1024) NULL,
 CONSTRAINT [pk_eventlogentry_eventlogid] PRIMARY KEY CLUSTERED 
(
	[event_log_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[eventlogentry]') AND name = N'evt_code_idx')
CREATE NONCLUSTERED INDEX [evt_code_idx] ON [dbo].[eventlogentry] 
(
	[eventcode] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[eventlogentry]') AND name = N'evt_correlationid_idx')
CREATE NONCLUSTERED INDEX [evt_correlationid_idx] ON [dbo].[eventlogentry] 
(
	[eventcorrelationid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[eventlogentry]') AND name = N'evt_datetime_idx')
CREATE NONCLUSTERED INDEX [evt_datetime_idx] ON [dbo].[eventlogentry] 
(
	[eventdatetime] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[eventlogentry]') AND name = N'evt_messageid_idx')
CREATE NONCLUSTERED INDEX [evt_messageid_idx] ON [dbo].[eventlogentry] 
(
	[eventmessageid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[eventlogentry]') AND name = N'evt_personid_idx')
CREATE NONCLUSTERED INDEX [evt_personid_idx] ON [dbo].[eventlogentry] 
(
	[eventpersonid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[eventlogentry]') AND name = N'evt_source_idx')
CREATE NONCLUSTERED INDEX [evt_source_idx] ON [dbo].[eventlogentry] 
(
	[source] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[email_history]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[email_history]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[email_history](
	[id] [numeric](19, 0) NOT NULL,
	[entityid] [nvarchar](255) NOT NULL,
	[entityversion] [numeric](19, 0) NULL,
	[eventtimestamp] [datetime] NOT NULL,
	[eventtype] [nvarchar](255) NOT NULL,
	[eventpersonid] [nvarchar](255) NULL,
	[emailaddress] [nvarchar](255) NULL,
	[person_id] [nchar](32) NULL,
 CONSTRAINT [pk_emailhistory_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[email_history]') AND name = N'emailhist_entity_id_idx')
CREATE NONCLUSTERED INDEX [emailhist_entity_id_idx] ON [dbo].[email_history] 
(
	[entityid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[email_history]') AND name = N'emailhist_person_id_idx')
CREATE NONCLUSTERED INDEX [emailhist_person_id_idx] ON [dbo].[email_history] 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[email]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[email]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[email](
	[email_id] [nchar](32) NOT NULL,
	[emailaddress] [nvarchar](255) NULL,
	[person_id] [nchar](32) NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[listindex] [int] NULL,
	[uniqueemailaddress] [nvarchar](255) NULL,
 CONSTRAINT [pk_email_emailid] PRIMARY KEY CLUSTERED 
(
	[email_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_email_emailaddress] UNIQUE NONCLUSTERED 
(
	[emailaddress] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_email_uniqueemailaddress] UNIQUE NONCLUSTERED 
(
	[uniqueemailaddress] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[email]') AND name = N'email_person_id_idx')
CREATE NONCLUSTERED INDEX [email_person_id_idx] ON [dbo].[email] 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[discoeventfile]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[discoeventfile]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[discoeventfile](
	[disco_event_file_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[filename] [nvarchar](255) NOT NULL,
	[disco_event_id] [nchar](32) NULL,
	[fileprocessed] [tinyint] NOT NULL,
 CONSTRAINT [pk_discoeventfile_disevntfileid] PRIMARY KEY CLUSTERED 
(
	[disco_event_file_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[discoeventfile]') AND name = N'def_de_id_idx')
CREATE NONCLUSTERED INDEX [def_de_id_idx] ON [dbo].[discoeventfile] 
(
	[disco_event_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[aliases]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aliases]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[aliases](
	[person_id] [nchar](32) NOT NULL,
	[current_alias] [nvarchar](255) NOT NULL,
	[name_map_key] [nvarchar](255) NOT NULL,
 CONSTRAINT [pk_aliases_peris_mapkey] PRIMARY KEY CLUSTERED 
(
	[person_id] ASC,
	[name_map_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[aliases]') AND name = N'aliases_person_id_idx')
CREATE NONCLUSTERED INDEX [aliases_person_id_idx] ON [dbo].[aliases] 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[macro]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[macro]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[macro](
	[macro_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[m_sys] [tinyint] NOT NULL,
	[user_cmd] [nvarchar](255) NOT NULL,
	[cmd_word] [nvarchar](255) NOT NULL,
	[param_string] [nvarchar](255) NULL,
	[person_id] [nchar](32) NULL,
	[name_map_key] [nvarchar](255) NULL,
	[expiretimestamp] [datetime] NULL,
 CONSTRAINT [pk_macro_macroid] PRIMARY KEY CLUSTERED 
(
	[macro_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[macro]') AND name = N'macro_expiretimestamp_idx')
CREATE NONCLUSTERED INDEX [macro_expiretimestamp_idx] ON [dbo].[macro] 
(
	[expiretimestamp] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[macro]') AND name = N'macro_person_id_idx')
CREATE NONCLUSTERED INDEX [macro_person_id_idx] ON [dbo].[macro] 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[location_properties]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[location_properties]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[location_properties](
	[p_location_id] [nchar](32) NOT NULL,
	[map_value] [nvarchar](255) NULL,
	[map_key] [nvarchar](255) NOT NULL,
 CONSTRAINT [pk_location_properties] PRIMARY KEY CLUSTERED 
(
	[p_location_id] ASC,
	[map_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[mobile_client]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mobile_client]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[mobile_client](
	[mobile_client_id] [nchar](32) NOT NULL,
	[person_id] [nchar](32) NULL,
	[phone_number] [nvarchar](255) NULL,
	[app_id] [nvarchar](255) NOT NULL,
	[device_manufacturer] [nvarchar](255) NULL,
	[device_model] [nvarchar](255) NULL,
	[user_agent] [nvarchar](255) NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[listindex] [int] NULL,
	[mobile_client_type] [nvarchar](255) NOT NULL,
	[os_name] [nvarchar](255) NULL,
	[os_version] [nvarchar](255) NULL,
	[duid] [nvarchar](255) NULL,
	[app_version] [nvarchar](255) NULL,
	[is_primary] [numeric](1) NOT NULL,
 CONSTRAINT [pk_mobile_client_mbcliid] PRIMARY KEY CLUSTERED 
(
	[mobile_client_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data])
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[mobile_client]') AND name = N'app_id_cl_type_idx')
CREATE UNIQUE NONCLUSTERED INDEX [app_id_cl_type_idx] ON [dbo].[mobile_client] 
(
	[app_id] ASC,
	[mobile_client_type] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[mobile_client]') AND name = N'person_id_idx')
CREATE NONCLUSTERED INDEX [person_id_idx] ON [dbo].[mobile_client] 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[mobile_client_history]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[mobile_client_history]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[mobile_client_history](
	[id] [numeric](19, 0) NOT NULL,
	[entityid] [nvarchar](255) NOT NULL,
	[entityversion] [numeric](19, 0) NULL,
	[eventtimestamp] [datetime] NOT NULL,
	[eventtype] [nvarchar](255) NOT NULL,
	[eventpersonid] [nvarchar](255) NULL,
	[person_id] [nchar](32) NULL,
	[phone_number] [nvarchar](255) NULL,
	[app_id] [nvarchar](255) NOT NULL,
	[device_manufacturer] [nvarchar](255) NULL,
	[device_model] [nvarchar](255) NULL,
	[user_agent] [nvarchar](255) NULL,
	[mobile_client_type] [nvarchar](255) NOT NULL,
	[os_name] [nvarchar](255) NULL,
	[os_version] [nvarchar](255) NULL,
	[duid] [nvarchar](255) NULL,
	[app_version] [nvarchar](255) NULL,
	[is_primary] [numeric](1) NOT NULL,
 CONSTRAINT [pk_mobile_client_history_id] PRIMARY KEY NONCLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[mobile_client_history]') AND name = N'IX_mobile_client_history_eventtimestamp_Partitioning')
CREATE CLUSTERED INDEX [IX_mobile_client_history_eventtimestamp_Partitioning] ON [dbo].[mobile_client_history] 
(
	[ID],[eventtimestamp]
)WITH ( DROP_EXISTING = OFF) ON [$(oltpdb)_index]
go
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[mobile_client_history]') AND name = N'mclienthist_entity_id_idx')
CREATE NONCLUSTERED INDEX [mclienthist_entity_id_idx] ON [dbo].[mobile_client_history] 
(
	[entityid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[mobile_client_history]') AND name = N'mclienthist_person_id_idx')
CREATE NONCLUSTERED INDEX [mclienthist_person_id_idx] ON [dbo].[mobile_client_history] 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[imaddress_history]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[imaddress_history]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[imaddress_history](
	[id] [numeric](19, 0) NOT NULL,
	[entityid] [nvarchar](255) NOT NULL,
	[entityversion] [numeric](19, 0) NULL,
	[eventtimestamp] [datetime] NOT NULL,
	[eventtype] [nvarchar](255) NOT NULL,
	[eventpersonid] [nvarchar](255) NULL,
	[imaddress] [nvarchar](255) NULL,
	[person_id] [nchar](32) NULL,
 CONSTRAINT [pk_imaddresshistory_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[imaddress]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[imaddress]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[imaddress](
	[imaddress_id] [nchar](32) NOT NULL,
	[imaddress] [nvarchar](255) NULL,
	[person_id] [nchar](32) NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[listindex] [int] NULL,
 CONSTRAINT [pk_imaddr_imaddrid] PRIMARY KEY CLUSTERED 
(
	[imaddress_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_imaddr_imaddress] UNIQUE NONCLUSTERED 
(
	[imaddress] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[imaddress]') AND name = N'imaddress_person_id_idx')
CREATE NONCLUSTERED INDEX [imaddress_person_id_idx] ON [dbo].[imaddress] 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[srcaddr_verification]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[srcaddr_verification]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[srcaddr_verification](
	[srcaddr_verif_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[verificationtoken] [nvarchar](255) NULL,
	[expiretimestamp] [datetime] NULL,
	[numberattempts] [int] NULL,
	[source_addr_id] [nchar](32) NOT NULL,
 CONSTRAINT [pk_srcaddr_verification_srcaddverid] PRIMARY KEY CLUSTERED 
(
	[srcaddr_verif_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[srcaddr_verification]') AND name = N'srcaddr_verif_src_addr_id_idx')
CREATE NONCLUSTERED INDEX [srcaddr_verif_src_addr_id_idx] ON [dbo].[srcaddr_verification] 
(
	[source_addr_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[tgroup]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tgroup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tgroup](
	[group_id] [nchar](32) NOT NULL,
	[name] [nvarchar](255) NULL,
	[parent_group_id] [nchar](32) NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
 CONSTRAINT [pk_tgroup_grpid] PRIMARY KEY CLUSTERED 
(
	[group_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_tgroup_name] UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tgroup]') AND name = N'tgroup_parent_group_id_idx')
CREATE NONCLUSTERED INDEX [tgroup_parent_group_id_idx] ON [dbo].[tgroup] 
(
	[parent_group_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[TERMSANDCONDITIONS]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TERMSANDCONDITIONS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TERMSANDCONDITIONS](
	[T_AND_C_ID] [nchar](32) NOT NULL,
	[PERSON_ID] [nchar](32) NOT NULL,
	[VERSIONNAME] [nvarchar](255) NOT NULL,
	[TCVERSION] [nchar](10) NOT NULL,
	[ACCEPTANCEDATE] [datetime] NULL,
	[DESCRIPTION] [nvarchar](1000) NULL,
	[AUTHOR] [nvarchar](255) NOT NULL,
	[VERSION] [decimal](19, 0) NOT NULL,
	[LASTUPDATED] [datetime] NULL,
	[CREATEDATE] [datetime] NULL,
 CONSTRAINT [PK_TERMSCONDITION_ID] PRIMARY KEY CLUSTERED 
(
	[T_AND_C_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY],
 CONSTRAINT [TERMSCONDITION_UNIQUE] UNIQUE NONCLUSTERED 
(
	[PERSON_ID] ASC,
	[VERSIONNAME] ASC,
	[TCVERSION] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TERMSANDCONDITIONS]') AND name = N'IX_TERMSCONDITION_ID')
CREATE UNIQUE NONCLUSTERED INDEX [IX_TERMSCONDITION_ID] ON [dbo].[TERMSANDCONDITIONS] 
(
	[T_AND_C_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TERMSANDCONDITIONS]') AND name = N'IX_TERMSCONDITION_UNIQUE')
CREATE UNIQUE NONCLUSTERED INDEX [IX_TERMSCONDITION_UNIQUE] ON [dbo].[TERMSANDCONDITIONS] 
(
	[PERSON_ID] ASC,
	[VERSIONNAME] ASC,
	[TCVERSION] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tenanturlpattern]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tenanturlpattern]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tenanturlpattern](
	[tenant_urlpattern_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[pattern] [nvarchar](255) NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[listindex] [int] NULL,
 CONSTRAINT [pk_tenurlpat_tenurlpatid] PRIMARY KEY CLUSTERED 
(
	[tenant_urlpattern_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_tenurlpat_pattern] UNIQUE NONCLUSTERED 
(
	[pattern] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tenanturlpattern]') AND name = N'tup_tenant_id_idx')
CREATE NONCLUSTERED INDEX [tup_tenant_id_idx] ON [dbo].[tenanturlpattern] 
(
	[tenant_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[tenantshortcode]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tenantshortcode]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tenantshortcode](
	[tenant_shortcode_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[defaultforsending] [tinyint] NULL,
	[short_code] [nvarchar](255) NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[listindex] [int] NULL,
 CONSTRAINT [pk_tenshortcode_tenshortcodeid] PRIMARY KEY CLUSTERED 
(
	[tenant_shortcode_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_tenshortcode_shortcode] UNIQUE NONCLUSTERED 
(
	[short_code] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tenantshortcode]') AND name = N'ts_tenant_id_idx')
CREATE NONCLUSTERED INDEX [ts_tenant_id_idx] ON [dbo].[tenantshortcode] 
(
	[tenant_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[tenantnamespace]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tenantnamespace]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tenantnamespace](
	[tenant_namespace_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[namespace] [nvarchar](255) NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[listindex] [int] NULL,
 CONSTRAINT [pk_tenantnamespace_tennamespid] PRIMARY KEY CLUSTERED 
(
	[tenant_namespace_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_tennamesp_namespace] UNIQUE NONCLUSTERED 
(
	[namespace] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tenantnamespace]') AND name = N'tn_tenant_id_idx')
CREATE NONCLUSTERED INDEX [tn_tenant_id_idx] ON [dbo].[tenantnamespace] 
(
	[tenant_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[tenantemaildomain]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tenantemaildomain]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tenantemaildomain](
	[company_emaildomain_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[defaultforsending] [tinyint] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[listindex] [int] NULL,
	[domainname] [nvarchar](255) NULL,
 CONSTRAINT [pk_tenemaildom_compemaildomid] PRIMARY KEY CLUSTERED 
(
	[company_emaildomain_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_tenantemaild_domname] UNIQUE NONCLUSTERED 
(
	[domainname] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[tenantemaildomain]') AND name = N'ted_tenant_id_idx')
CREATE NONCLUSTERED INDEX [ted_tenant_id_idx] ON [dbo].[tenantemaildomain] 
(
	[tenant_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[source_address_dnd_range]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[source_address_dnd_range]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[source_address_dnd_range](
	[dnd_range_id] [nchar](32) NOT NULL,
	[source_addr_id] [nchar](32) NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[listindex] [int] NULL,
 CONSTRAINT [pk_source_address_dnd_range_dndrngid] PRIMARY KEY CLUSTERED 
(
	[dnd_range_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[source_address_dnd_range]') AND name = N'src_addr_dnd_rng_srcad_id_idx')
CREATE NONCLUSTERED INDEX [src_addr_dnd_rng_srcad_id_idx] ON [dbo].[source_address_dnd_range] 
(
	[source_addr_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[PRODUCTENROLLMENT]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRODUCTENROLLMENT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PRODUCTENROLLMENT](
	[ENROLLMENT_ID] [nchar](32) NOT NULL,
	[PRODUCTKEY] [nchar](32) NOT NULL,
	[PERSON_ID] [nchar](32) NOT NULL,
	[ENROLLMENTDATE] [datetime] NULL,
	[AUTHOR] [nvarchar](255) NOT NULL,
	[VERSION] [decimal](19, 0) NOT NULL,
	[LASTUPDATED] [datetime] NULL,
	[CREATEDATE] [datetime] NULL,
 CONSTRAINT [PK_ENROLLMENT_ID] PRIMARY KEY CLUSTERED 
(
	[ENROLLMENT_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY],
 CONSTRAINT [PRODUCTENROLLMENT_UNIQUE] UNIQUE NONCLUSTERED 
(
	[PRODUCTKEY] ASC,
	[PERSON_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PRODUCTENROLLMENT]') AND name = N'IX_ENROLLMENT_ID')
CREATE UNIQUE NONCLUSTERED INDEX [IX_ENROLLMENT_ID] ON [dbo].[PRODUCTENROLLMENT] 
(
	[ENROLLMENT_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PRODUCTENROLLMENT]') AND name = N'IX_PRODUCTENROLLMENT_UNIQUE')
CREATE UNIQUE NONCLUSTERED INDEX [IX_PRODUCTENROLLMENT_UNIQUE] ON [dbo].[PRODUCTENROLLMENT] 
(
	[PRODUCTKEY] ASC,
	[PERSON_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[userprefs]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[userprefs]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[userprefs](
	[sessionid] [nchar](32) NOT NULL,
	[cm_value] [nvarchar](255) NULL,
	[cm_key] [nvarchar](255) NOT NULL,
 CONSTRAINT [pk_userprefs_sessidcmkey] PRIMARY KEY CLUSTERED 
(
	[sessionid] ASC,
	[cm_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[userprefs]') AND name = N'userprefs_sessionid_idx')
CREATE NONCLUSTERED INDEX [userprefs_sessionid_idx] ON [dbo].[userprefs] 
(
	[sessionid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[help_message]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[help_message]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[help_message](
	[cm_name_id] [nchar](32) NOT NULL,
	[elt] [nvarchar](255) NULL,
	[idx] [nvarchar](255) NOT NULL,
 CONSTRAINT [pk_helpmess_cmnameididx] PRIMARY KEY CLUSTERED 
(
	[cm_name_id] ASC,
	[idx] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[help_message]') AND name = N'helpmsg_cmnameid_idx')
CREATE NONCLUSTERED INDEX [helpmsg_cmnameid_idx] ON [dbo].[help_message] 
(
	[cm_name_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[group_role]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[group_role]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[group_role](
	[group_id] [nchar](32) NOT NULL,
	[role_id] [nchar](32) NOT NULL,
 CONSTRAINT [pk_grouprole_grpidroleid] PRIMARY KEY CLUSTERED 
(
	[group_id] ASC,
	[role_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[group_role]') AND name = N'grprole_grpid_idx')
CREATE NONCLUSTERED INDEX [grprole_grpid_idx] ON [dbo].[group_role] 
(
	[group_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[group_role]') AND name = N'grprole_roleid_idx')
CREATE NONCLUSTERED INDEX [grprole_roleid_idx] ON [dbo].[group_role] 
(
	[role_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[person_role]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[person_role]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[person_role](
	[person_principal_id] [nchar](32) NOT NULL,
	[role_id] [nchar](32) NOT NULL,
 CONSTRAINT [pk_person_role_perprinidrolid] PRIMARY KEY CLUSTERED 
(
	[person_principal_id] ASC,
	[role_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[person_role]') AND name = N'personrole_personprinid_idx')
CREATE NONCLUSTERED INDEX [personrole_personprinid_idx] ON [dbo].[person_role] 
(
	[person_principal_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[person_role]') AND name = N'personrole_roleid_idx')
CREATE NONCLUSTERED INDEX [personrole_roleid_idx] ON [dbo].[person_role] 
(
	[role_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[person_group]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[person_group]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[person_group](
	[person_principal_id] [nchar](32) NOT NULL,
	[group_id] [nchar](32) NOT NULL,
 CONSTRAINT [pk_person_group_perprinidgrpid] PRIMARY KEY CLUSTERED 
(
	[person_principal_id] ASC,
	[group_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[person_group]') AND name = N'pgroup_group_id_idx')
CREATE NONCLUSTERED INDEX [pgroup_group_id_idx] ON [dbo].[person_group] 
(
	[group_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[person_group]') AND name = N'pgroup_person_principal_id_idx')
CREATE NONCLUSTERED INDEX [pgroup_person_principal_id_idx] ON [dbo].[person_group] 
(
	[person_principal_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[named_resource]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[named_resource]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[named_resource](
	[named_resource_id] [nchar](32) NOT NULL,
	[localpart] [nvarchar](255) NOT NULL,
	[namespaceuri] [nvarchar](255) NOT NULL,
	[description] [nvarchar](255) NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
 CONSTRAINT [pk_namres_namresid] PRIMARY KEY CLUSTERED 
(
	[named_resource_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_namres_locpartnuri] UNIQUE NONCLUSTERED 
(
	[localpart] ASC,
	[namespaceuri] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
/****** Object:  Table [dbo].[service_endpoint]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[service_endpoint]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[service_endpoint](
	[endpoint_id] [nchar](32) NOT NULL,
	[apiversion] [nvarchar](255) NULL,
	[localpart] [nvarchar](255) NOT NULL,
	[namespaceuri] [nvarchar](255) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
 CONSTRAINT [pk_service_endpoint_endptid] PRIMARY KEY CLUSTERED 
(
	[endpoint_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_servendpnt_localpnamuri] UNIQUE NONCLUSTERED 
(
	[localpart] ASC,
	[namespaceuri] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO


/****** Object:  Table [dbo].[discoeventphone]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[discoeventphone]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[discoeventphone](
	[disco_event_phone_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[disco_event_id] [nchar](32) NULL,
	[phone_id] [nchar](32) NULL,
	[phonenumberlistindex] [int] NULL,
 CONSTRAINT [pk_discoeventph_diseventphid] PRIMARY KEY CLUSTERED 
(
	[disco_event_phone_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[discoeventphone]') AND name = N'dep_de_id_idx')
CREATE NONCLUSTERED INDEX [dep_de_id_idx] ON [dbo].[discoeventphone] 
(
	[disco_event_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[discoeventphone]') AND name = N'dep_p_id_idx')
CREATE NONCLUSTERED INDEX [dep_p_id_idx] ON [dbo].[discoeventphone] 
(
	[phone_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO

/****** Object:  Table [dbo].[alertregistration]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[alertregistration]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[alertregistration](
	[alert_registration_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[alertrule] [nvarchar](1000) NOT NULL,
	[alert_reference_id] [nchar](32) NULL,
	[alert_type_id] [nchar](32) NULL,
	[source_addr_id] [nchar](32) NULL,
	[listindex] [int] NULL,
	[actionable] [tinyint] NOT NULL,
 CONSTRAINT [pk_alertreg_alertregid] PRIMARY KEY CLUSTERED 
(
	[alert_registration_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alertregistration]') AND name = N'alert_reference_id_idx')
CREATE NONCLUSTERED INDEX [alert_reference_id_idx] ON [dbo].[alertregistration] 
(
	[alert_reference_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alertregistration]') AND name = N'ar_at_id_idx')
CREATE NONCLUSTERED INDEX [ar_at_id_idx] ON [dbo].[alertregistration] 
(
	[alert_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alertregistration]') AND name = N'ar_sa_id_idx')
CREATE NONCLUSTERED INDEX [ar_sa_id_idx] ON [dbo].[alertregistration] 
(
	[source_addr_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
-- Bof SE-7104_indexing.sql
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alertregistration]') AND name = N'alertreg_tenant_id_idx')
CREATE INDEX [alertreg_tenant_id_idx] ON [dbo].[alertregistration]
(
        alert_reference_id,
        tenant_id
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[aclentry]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[aclentry]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[aclentry](
	[acl_entry_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[inheritable] [tinyint] NOT NULL,
	[ispositive] [tinyint] NOT NULL,
	[permission_id] [nchar](32) NOT NULL,
	[principal_id] [nchar](32) NOT NULL,
	[cm_name_id] [nchar](32) NOT NULL,
 CONSTRAINT [pk_aclentry_aclentryid] PRIMARY KEY CLUSTERED 
(
	[acl_entry_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_aclentry_permidprinidcmid] UNIQUE NONCLUSTERED 
(
	[permission_id] ASC,
	[principal_id] ASC,
	[cm_name_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[aclentry]') AND name = N'acl_cm_name_id_idx')
CREATE NONCLUSTERED INDEX [acl_cm_name_id_idx] ON [dbo].[aclentry] 
(
	[cm_name_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[aclentry]') AND name = N'acl_principal_id_idx')
CREATE NONCLUSTERED INDEX [acl_principal_id_idx] ON [dbo].[aclentry] 
(
	[principal_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[aclentry]') AND name = N'aclentry_permissionid_idx')
CREATE NONCLUSTERED INDEX [aclentry_permissionid_idx] ON [dbo].[aclentry] 
(
	[permission_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[alertinstance]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[alertinstance]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[alertinstance](
	[alert_instance_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[tenant_id] [nchar](32) NOT NULL,
	[source_addr_id] [nchar](32) NULL,
	[alert_type_id] [nchar](32) NULL,
	[alert_reference_id] [nchar](32) NULL,
	[fromaddressuri] [nvarchar](255) NULL,
	[toaddressuri] [nvarchar](255) NULL,
	[subject] [nvarchar](255) NULL,
	[messagedata] [varbinary](max) NULL,
	[status] [nvarchar](255) NULL,
	[correlationid] [nchar](36) NULL,
	[protocol] [nvarchar](255) NULL,
 CONSTRAINT [pk_alertinstance_alertinstid] PRIMARY KEY CLUSTERED 
(
	[alert_instance_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alertinstance]') AND name = N'ai_ar_id_idx')
CREATE NONCLUSTERED INDEX [ai_ar_id_idx] ON [dbo].[alertinstance] 
(
	[alert_reference_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alertinstance]') AND name = N'ai_at_id_idx')
CREATE NONCLUSTERED INDEX [ai_at_id_idx] ON [dbo].[alertinstance] 
(
	[alert_type_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alertinstance]') AND name = N'alert_correlation_id_index')
CREATE NONCLUSTERED INDEX [alert_correlation_id_index] ON [dbo].[alertinstance] 
(
	[correlationid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[alert_reg_rule_values]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[alert_reg_rule_values]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[alert_reg_rule_values](
	[alert_registration_id] [nchar](32) NOT NULL,
	[cm_value] [nvarchar](255) NOT NULL,
	[cm_key] [nvarchar](255) NOT NULL,
 CONSTRAINT [pk_altregrulval_altregidcmkey] PRIMARY KEY CLUSTERED 
(
	[alert_registration_id] ASC,
	[cm_key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alert_reg_rule_values]') AND name = N'alregrulval_alertregid_idx')
CREATE NONCLUSTERED INDEX [alregrulval_alertregid_idx] ON [dbo].[alert_reg_rule_values] 
(
	[alert_registration_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[alert_reg_dnd_range]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[alert_reg_dnd_range]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[alert_reg_dnd_range](
	[dnd_range_id] [nchar](32) NOT NULL,
	[alert_registration_id] [nchar](32) NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[listindex] [int] NULL,
 CONSTRAINT [pk_alregdndrange_dndrangeid] PRIMARY KEY CLUSTERED 
(
	[dnd_range_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alert_reg_dnd_range]') AND name = N'ar_dnd_ar_id_idx')
CREATE NONCLUSTERED INDEX [ar_dnd_ar_id_idx] ON [dbo].[alert_reg_dnd_range] 
(
	[alert_registration_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[alertinstancequeue]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[alertinstancequeue]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[alertinstancequeue](
	[instance_queue_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[ownernode] [nvarchar](255) NULL,
	[alert_instance_id] [nchar](32) NULL,
 CONSTRAINT [pk_alertinstq_instqid] PRIMARY KEY CLUSTERED 
(
	[instance_queue_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alertinstancequeue]') AND name = N'aiq_ai_id_idx')
CREATE NONCLUSTERED INDEX [aiq_ai_id_idx] ON [dbo].[alertinstancequeue] 
(
	[alert_instance_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[alertinstancedelayqueue]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[alertinstancedelayqueue]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[alertinstancedelayqueue](
	[instance_delay_queue_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[ownernode] [nvarchar](255) NULL,
	[alert_instance_id] [nchar](32) NULL,
	[alert_registration_id] [nchar](32) NULL,
 CONSTRAINT [pk_altinsdelq_instdelayqid] PRIMARY KEY CLUSTERED 
(
	[instance_delay_queue_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alertinstancedelayqueue]') AND name = N'aidq_ai_id_idx')
CREATE NONCLUSTERED INDEX [aidq_ai_id_idx] ON [dbo].[alertinstancedelayqueue] 
(
	[alert_instance_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[alertinstancedelayqueue]') AND name = N'aidq_ar_id_idx')
CREATE NONCLUSTERED INDEX [aidq_ar_id_idx] ON [dbo].[alertinstancedelayqueue] 
(
	[alert_registration_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[service_interface]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[service_interface]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[service_interface](
	[interface_id] [nchar](32) NOT NULL,
	[localpart] [nvarchar](255) NOT NULL,
	[namespaceuri] [nvarchar](255) NOT NULL,
	[endpoint_id] [nchar](32) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[listindex] [int] NULL,
 CONSTRAINT [pk_service_interface_intrfid] PRIMARY KEY CLUSTERED 
(
	[interface_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_service_interface_lclpartnmspcuri] UNIQUE NONCLUSTERED 
(
	[localpart] ASC,
	[namespaceuri] ASC,
	[endpoint_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[service_interface]') AND name = N'serviceint_endptid_idx')
CREATE NONCLUSTERED INDEX [serviceint_endptid_idx] ON [dbo].[service_interface] 
(
	[endpoint_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[propertykey]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[propertykey]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[propertykey](
	[property_key_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[name] [nvarchar](255) NOT NULL,
	[endpoint_id] [nchar](32) NULL,
	[listindex] [int] NULL,
 CONSTRAINT [pk_propertykey_propkeyid] PRIMARY KEY CLUSTERED 
(
	[property_key_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_propkey_namendid] UNIQUE NONCLUSTERED 
(
	[name] ASC,
	[endpoint_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[propertykey]') AND name = N'propkey_endpntid_idx')
CREATE NONCLUSTERED INDEX [propkey_endpntid_idx] ON [dbo].[propertykey] 
(
	[endpoint_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[service_operation]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[service_operation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[service_operation](
	[operation_id] [nchar](32) NOT NULL,
	[javaclassname] [nvarchar](255) NOT NULL,
	[inputhandler] [nvarchar](255) NULL,
	[usessession] [tinyint] NULL,
	[localpart] [nvarchar](255) NOT NULL,
	[namespaceuri] [nvarchar](255) NOT NULL,
	[authenticationscheme] [nvarchar](255) NOT NULL,
	[deniedauthenticationscheme] [nvarchar](255) NOT NULL,
	[interface_id] [nchar](32) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[listindex] [int] NULL,
 CONSTRAINT [pk_service_operation_opernid] PRIMARY KEY CLUSTERED 
(
	[operation_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_serop_lclpartnuri] UNIQUE NONCLUSTERED 
(
	[localpart] ASC,
	[namespaceuri] ASC,
	[authenticationscheme] ASC,
	[deniedauthenticationscheme] ASC,
	[interface_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[service_operation]') AND name = N'serviceop_intid_idx')
CREATE NONCLUSTERED INDEX [serviceop_intid_idx] ON [dbo].[service_operation] 
(
	[interface_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[property]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[property]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[property](
	[property_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[cm_value] [nvarchar](1024) NOT NULL,
	[property_key_id] [nchar](32) NOT NULL,
	[person_id] [nchar](32) NOT NULL,
	[listindex] [int] NULL,
 CONSTRAINT [pk_property_propid] PRIMARY KEY CLUSTERED 
(
	[property_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[property]') AND name = N'property_person_id_idx')
CREATE NONCLUSTERED INDEX [property_person_id_idx] ON [dbo].[property] 
(
	[person_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[command]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[command]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[command](
	[cm_command_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[name] [nvarchar](255) NOT NULL,
	[fromdeploymentdescriptor] [tinyint] NOT NULL,
	[operation_id] [nchar](32) NOT NULL,
	[listindex] [int] NULL,
 CONSTRAINT [pk_command_cmcommandid] PRIMARY KEY CLUSTERED 
(
	[cm_command_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_command_name] UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[command]') AND name = N'command_operation_id_idx')
CREATE NONCLUSTERED INDEX [command_operation_id_idx] ON [dbo].[command] 
(
	[operation_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Table [dbo].[authenticationtoken]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[authenticationtoken]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[authenticationtoken](
	[authentication_token_id] [nchar](32) NOT NULL,
	[version] [numeric](19, 0) NOT NULL,
	[lastupdated] [datetime] NULL,
	[createdate] [datetime] NULL,
	[authenticated] [tinyint] NOT NULL,
	[schemename] [nvarchar](255) NULL,
	[token] [nvarchar](255) NULL,
	[description] [nvarchar](255) NULL,
	[createdtime] [datetime] NULL,
	[person_id] [nchar](32) NULL,
	[operation_id] [nchar](32) NULL,
 CONSTRAINT [pk_authtoken_authtokenid] PRIMARY KEY CLUSTERED 
(
	[authentication_token_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data],
 CONSTRAINT [uk_authtoken_peridopid] UNIQUE NONCLUSTERED 
(
	[person_id] ASC,
	[operation_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[oltpdb_purge]') AND type in (N'U'))
BEGIN
	CREATE TABLE oltpdb_purge
	(
	OLTPDB_PURGE_ID INT,
	TABLE_NAME NVARCHAR(30),
	PURGE_DURATION DECIMAL(38,5),
	CONSTRAINT PK_OLTPDB_PURGE PRIMARY KEY (OLTPDB_PURGE_ID)) on $(oltpdb)_data;
		
	INSERT INTO OLTPDB_PURGE VALUES(3,'ALERT_INSTANCE_HISTORY',90);
	INSERT INTO OLTPDB_PURGE VALUES(11,'SOURCE_ADDRESS_HISTORY',90);
	INSERT INTO OLTPDB_PURGE VALUES(15,'PERSON_HISTORY',90);
	INSERT INTO OLTPDB_PURGE VALUES(21,'ALERTINSTANCE',90);
	INSERT INTO OLTPDB_PURGE VALUES(22,'EVENTLOGENTRY',90)
	INSERT INTO OLTPDB_PURGE VALUES(26,'ACTIONLOG',90)
END
GO


/****** Object:  Table [dbo].[message_on_hold]    Script Date: 07/16/2012 17:33:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[message_on_hold]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[message_on_hold](
	[authentication_token_id] [nchar](32) NOT NULL,
	[elt] [varbinary](max) NULL,
	[listindex] [int] NOT NULL,
 CONSTRAINT [pk_mesonhold_authtokidlistindex] PRIMARY KEY CLUSTERED 
(
	[authentication_token_id] ASC,
	[listindex] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_data]
) ON [$(oltpdb)_data]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[message_on_hold]') AND name = N'mesonhold_authtokenid_idx')
CREATE NONCLUSTERED INDEX [mesonhold_authtokenid_idx] ON [dbo].[message_on_hold] 
(
	[authentication_token_id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [$(oltpdb)_index]
GO
/****** Object:  Default [DF__aclentry__versio__014935CB]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__aclentry__versio__014935CB]') AND parent_object_id = OBJECT_ID(N'[dbo].[aclentry]'))
Begin
IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = OBJECT_ID(N'[DF__aclentry__versio__014935CB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[aclentry] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__actioncon__versi__4A8310C6]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__actioncon__versi__4A8310C6]') AND parent_object_id = OBJECT_ID(N'[dbo].[actioncontext]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__actioncon__versi__4A8310C6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[actioncontext] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__actionlog__versi__4D5F7D71]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__actionlog__versi__4D5F7D71]') AND parent_object_id = OBJECT_ID(N'[dbo].[actionlog]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__actionlog__versi__4D5F7D71]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[actionlog] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__address__version__0425A276]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__address__version__0425A276]') AND parent_object_id = OBJECT_ID(N'[dbo].[address]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__address__version__0425A276]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[address] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__aggregato__versi__1C873BEC]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__aggregato__versi__1C873BEC]') AND parent_object_id = OBJECT_ID(N'[dbo].[aggregator]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__aggregato__versi__1C873BEC]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[aggregator] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__alertinst__versi__07020F21]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__alertinst__versi__07020F21]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertinstance]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__alertinst__versi__07020F21]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[alertinstance] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__alertinst__versi__09DE7BCC]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__alertinst__versi__09DE7BCC]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertinstancedelayqueue]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__alertinst__versi__09DE7BCC]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[alertinstancedelayqueue] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__alertinst__versi__0CBAE877]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__alertinst__versi__0CBAE877]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertinstancequeue]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__alertinst__versi__0CBAE877]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[alertinstancequeue] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__alertrefe__versi__108B795B]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__alertrefe__versi__108B795B]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertreference]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__alertrefe__versi__108B795B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[alertreference] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__alertrefe__versi__145C0A3F]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__alertrefe__versi__145C0A3F]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertreferencetype]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__alertrefe__versi__145C0A3F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[alertreferencetype] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__alertregi__versi__173876EA]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__alertregi__versi__173876EA]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertregistration]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__alertregi__versi__173876EA]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[alertregistration] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__alerttype__versi__1B0907CE]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__alerttype__versi__1B0907CE]') AND parent_object_id = OBJECT_ID(N'[dbo].[alerttype]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__alerttype__versi__1B0907CE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[alerttype] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__alerttype__valid__1BFD2C07]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__alerttype__valid__1BFD2C07]') AND parent_object_id = OBJECT_ID(N'[dbo].[alerttype]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__alerttype__valid__1BFD2C07]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[alerttype] ADD  DEFAULT (NULL) FOR [validationtemplatekey]
END


End
GO
/****** Object:  Default [DF__authentic__versi__1FCDBCEB]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__authentic__versi__1FCDBCEB]') AND parent_object_id = OBJECT_ID(N'[dbo].[authenticationtoken]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__authentic__versi__1FCDBCEB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[authenticationtoken] ADD  DEFAULT ((0)) FOR [version]
END


End
GO

/****** Object:  Default [DF__carrier__version__1F63A897]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__carrier__version__1F63A897]') AND parent_object_id = OBJECT_ID(N'[dbo].[carrier]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__carrier__version__1F63A897]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[carrier] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__clusterme__versi__239E4DCF]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__clusterme__versi__239E4DCF]') AND parent_object_id = OBJECT_ID(N'[dbo].[clustermember]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__clusterme__versi__239E4DCF]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[clustermember] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__clusterme__versi__267ABA7A]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__clusterme__versi__267ABA7A]') AND parent_object_id = OBJECT_ID(N'[dbo].[clustermemberstatus]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__clusterme__versi__267ABA7A]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[clustermemberstatus] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__cm_name__version__778AC167]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__cm_name__version__778AC167]') AND parent_object_id = OBJECT_ID(N'[dbo].[cm_name]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__cm_name__version__778AC167]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[cm_name] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__command__version__7B5B524B]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__command__version__7B5B524B]') AND parent_object_id = OBJECT_ID(N'[dbo].[command]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__command__version__7B5B524B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[command] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__condition__versi__540C7B00]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__condition__versi__540C7B00]') AND parent_object_id = OBJECT_ID(N'[dbo].[conditioncontext]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__condition__versi__540C7B00]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[conditioncontext] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__conversat__versi__58D1301D]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__conversat__versi__58D1301D]') AND parent_object_id = OBJECT_ID(N'[dbo].[conversation]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__conversat__versi__58D1301D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[conversation] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__correlati__versi__2A4B4B5E]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__correlati__versi__2A4B4B5E]') AND parent_object_id = OBJECT_ID(N'[dbo].[correlationidalias]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__correlati__versi__2A4B4B5E]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[correlationidalias] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__dailyusag__versi__251C81ED]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__dailyusag__versi__251C81ED]') AND parent_object_id = OBJECT_ID(N'[dbo].[dailyusagemonitor]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__dailyusag__versi__251C81ED]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[dailyusagemonitor] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__discoeven__versi__2E1BDC42]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__discoeven__versi__2E1BDC42]') AND parent_object_id = OBJECT_ID(N'[dbo].[discoevent]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__discoeven__versi__2E1BDC42]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[discoevent] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__discoeven__versi__30F848ED]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__discoeven__versi__30F848ED]') AND parent_object_id = OBJECT_ID(N'[dbo].[discoeventfile]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__discoeven__versi__30F848ED]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[discoeventfile] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__discoeven__versi__33D4B598]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__discoeven__versi__33D4B598]') AND parent_object_id = OBJECT_ID(N'[dbo].[discoeventphone]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__discoeven__versi__33D4B598]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[discoeventphone] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__dnd_range__versi__7E37BEF6]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__dnd_range__versi__7E37BEF6]') AND parent_object_id = OBJECT_ID(N'[dbo].[dnd_range]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__dnd_range__versi__7E37BEF6]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[dnd_range] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__eventimpo__versi__3A81B327]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__eventimpo__versi__3A81B327]') AND parent_object_id = OBJECT_ID(N'[dbo].[eventimportance]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__eventimpo__versi__3A81B327]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[eventimportance] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__eventloge__versi__3D5E1FD2]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__eventloge__versi__3D5E1FD2]') AND parent_object_id = OBJECT_ID(N'[dbo].[eventlogentry]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__eventloge__versi__3D5E1FD2]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[eventlogentry] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__featureus__versi__2DB1C7EE]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__featureus__versi__2DB1C7EE]') AND parent_object_id = OBJECT_ID(N'[dbo].[featureusage]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__featureus__versi__2DB1C7EE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[featureusage] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__location__versio__13F1F5EB]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__location__versio__13F1F5EB]') AND parent_object_id = OBJECT_ID(N'[dbo].[location]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__location__versio__13F1F5EB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[location] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__macro__version__4316F928]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__macro__version__4316F928]') AND parent_object_id = OBJECT_ID(N'[dbo].[macro]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__macro__version__4316F928]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[macro] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__notificat__versi__0D7A0286]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__notificat__versi__0D7A0286]') AND parent_object_id = OBJECT_ID(N'[dbo].[notification_process_lock]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__notificat__versi__0D7A0286]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[notification_process_lock] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__onetime_p__versi__10566F31]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__onetime_p__versi__10566F31]') AND parent_object_id = OBJECT_ID(N'[dbo].[onetime_pin]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__onetime_p__versi__10566F31]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[onetime_pin] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__pendingev__versi__72910220]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__pendingev__versi__72910220]') AND parent_object_id = OBJECT_ID(N'[dbo].[pendingevent]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__pendingev__versi__72910220]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[pendingevent] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__periodic___versi__14270015]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__periodic___versi__14270015]') AND parent_object_id = OBJECT_ID(N'[dbo].[periodic_notification]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__periodic___versi__14270015]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[periodic_notification] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__periodic___versi__17F790F9]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__periodic___versi__17F790F9]') AND parent_object_id = OBJECT_ID(N'[dbo].[periodic_notification_lock]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__periodic___versi__17F790F9]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[periodic_notification_lock] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__permissio__versi__45F365D3]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__permissio__versi__45F365D3]') AND parent_object_id = OBJECT_ID(N'[dbo].[permission]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__permissio__versi__45F365D3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[permission] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__person__version__4AB81AF0]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__person__version__4AB81AF0]') AND parent_object_id = OBJECT_ID(N'[dbo].[person]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__person__version__4AB81AF0]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[person] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__personpri__bad_l__4D94879B]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__personpri__bad_l__4D94879B]') AND parent_object_id = OBJECT_ID(N'[dbo].[personprincipal]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__personpri__bad_l__4D94879B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[personprincipal] ADD  DEFAULT ((0)) FOR [bad_login_count]
END


End
GO
/****** Object:  Default [DF__personpro__versi__5070F446]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__personpro__versi__5070F446]') AND parent_object_id = OBJECT_ID(N'[dbo].[personprofile]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__personpro__versi__5070F446]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[personprofile] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__principal__versi__245D67DE]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__principal__versi__245D67DE]') AND parent_object_id = OBJECT_ID(N'[dbo].[principal]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__principal__versi__245D67DE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[principal] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__PRODUCTEN__VERSI__2D7CBDC4]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__PRODUCTEN__VERSI__2D7CBDC4]') AND parent_object_id = OBJECT_ID(N'[dbo].[PRODUCTENROLLMENT]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__PRODUCTEN__VERSI__2D7CBDC4]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PRODUCTENROLLMENT] ADD  DEFAULT ((0)) FOR [VERSION]
END


End
GO
/****** Object:  Default [DF__property__versio__5535A963]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__property__versio__5535A963]') AND parent_object_id = OBJECT_ID(N'[dbo].[property]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__property__versio__5535A963]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[property] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__propertyk__versi__59063A47]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__propertyk__versi__59063A47]') AND parent_object_id = OBJECT_ID(N'[dbo].[propertykey]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__propertyk__versi__59063A47]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[propertykey] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__REDELIVER__VERSI__26CFC035]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__REDELIVER__VERSI__26CFC035]') AND parent_object_id = OBJECT_ID(N'[dbo].[REDELIVERY_QUEUE]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__REDELIVER__VERSI__26CFC035]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[REDELIVERY_QUEUE] ADD  DEFAULT ((0)) FOR [VERSION]
END


End
GO
/****** Object:  Default [DF__schema_ve__versi__2A164134]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__schema_ve__versi__2A164134]') AND parent_object_id = OBJECT_ID(N'[dbo].[schema_version]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__schema_ve__versi__2A164134]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[schema_version] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__serviceda__versi__19AACF41]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__serviceda__versi__19AACF41]') AND parent_object_id = OBJECT_ID(N'[dbo].[servicedata]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__serviceda__versi__19AACF41]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[servicedata] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__smppcarri__versi__22401542]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__smppcarri__versi__22401542]') AND parent_object_id = OBJECT_ID(N'[dbo].[smppcarriercode]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__smppcarri__versi__22401542]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[smppcarriercode] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__source_ad__versi__37703C52]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__source_ad__versi__37703C52]') AND parent_object_id = OBJECT_ID(N'[dbo].[source_address]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__source_ad__versi__37703C52]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[source_address] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__srcaddr_v__versi__3E1D39E1]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__srcaddr_v__versi__3E1D39E1]') AND parent_object_id = OBJECT_ID(N'[dbo].[srcaddr_verification]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__srcaddr_v__versi__3E1D39E1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[srcaddr_verification] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__state__version__5F7E2DAC]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__state__version__5F7E2DAC]') AND parent_object_id = OBJECT_ID(N'[dbo].[state]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__state__version__5F7E2DAC]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[state] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__statemode__versi__634EBE90]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__statemode__versi__634EBE90]') AND parent_object_id = OBJECT_ID(N'[dbo].[statemodel]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__statemode__versi__634EBE90]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[statemodel] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__statemode__versi__662B2B3B]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__statemode__versi__662B2B3B]') AND parent_object_id = OBJECT_ID(N'[dbo].[statemodelregistration]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__statemode__versi__662B2B3B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[statemodelregistration] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__tenant__version__5CD6CB2B]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__tenant__version__5CD6CB2B]') AND parent_object_id = OBJECT_ID(N'[dbo].[tenant]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__tenant__version__5CD6CB2B]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tenant] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__tenantema__versi__60A75C0F]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__tenantema__versi__60A75C0F]') AND parent_object_id = OBJECT_ID(N'[dbo].[tenantemaildomain]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__tenantema__versi__60A75C0F]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tenantemaildomain] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__tenantnam__versi__6477ECF3]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__tenantnam__versi__6477ECF3]') AND parent_object_id = OBJECT_ID(N'[dbo].[tenantnamespace]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__tenantnam__versi__6477ECF3]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tenantnamespace] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__tenantsho__versi__68487DD7]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__tenantsho__versi__68487DD7]') AND parent_object_id = OBJECT_ID(N'[dbo].[tenantshortcode]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__tenantsho__versi__68487DD7]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tenantshortcode] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__tenanturl__versi__6C190EBB]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__tenanturl__versi__6C190EBB]') AND parent_object_id = OBJECT_ID(N'[dbo].[tenanturlpattern]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__tenanturl__versi__6C190EBB]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tenanturlpattern] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__TERMSANDC__VERSI__2E70E1FD]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__TERMSANDC__VERSI__2E70E1FD]') AND parent_object_id = OBJECT_ID(N'[dbo].[TERMSANDCONDITIONS]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__TERMSANDC__VERSI__2E70E1FD]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TERMSANDCONDITIONS] ADD  DEFAULT ((0)) FOR [VERSION]
END


End
GO
/****** Object:  Default [DF__transitio__versi__6AEFE058]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__transitio__versi__6AEFE058]') AND parent_object_id = OBJECT_ID(N'[dbo].[transition]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__transitio__versi__6AEFE058]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[transition] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__transitio__versi__6FB49575]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__transitio__versi__6FB49575]') AND parent_object_id = OBJECT_ID(N'[dbo].[transitionlist]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__transitio__versi__6FB49575]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[transitionlist] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__wcsession__versi__6EF57B66]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__wcsession__versi__6EF57B66]') AND parent_object_id = OBJECT_ID(N'[dbo].[wcsession]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__wcsession__versi__6EF57B66]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[wcsession] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Default [DF__weeklyusa__versi__27F8EE98]    Script Date: 07/16/2012 17:33:41 ******/
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__weeklyusa__versi__27F8EE98]') AND parent_object_id = OBJECT_ID(N'[dbo].[weeklyusagemonitor]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__weeklyusa__versi__27F8EE98]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[weeklyusagemonitor] ADD  DEFAULT ((0)) FOR [version]
END


End
GO
/****** Object:  Check [ck_unique_email]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[ck_unique_email]') AND parent_object_id = OBJECT_ID(N'[dbo].[email]'))
ALTER TABLE [dbo].[email]  WITH CHECK ADD  CONSTRAINT [ck_unique_email] CHECK  (([uniqueemailaddress]=lower([uniqueemailaddress])))
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[ck_unique_email]') AND parent_object_id = OBJECT_ID(N'[dbo].[email]'))
ALTER TABLE [dbo].[email] CHECK CONSTRAINT [ck_unique_email]
GO
/****** Object:  ForeignKey [fk_aclentry_cmnameid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_aclentry_cmnameid]') AND parent_object_id = OBJECT_ID(N'[dbo].[aclentry]'))
ALTER TABLE [dbo].[aclentry]  WITH CHECK ADD  CONSTRAINT [fk_aclentry_cmnameid] FOREIGN KEY([cm_name_id])
REFERENCES [dbo].[cm_name] ([cm_name_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_aclentry_cmnameid]') AND parent_object_id = OBJECT_ID(N'[dbo].[aclentry]'))
ALTER TABLE [dbo].[aclentry] CHECK CONSTRAINT [fk_aclentry_cmnameid]
GO
/****** Object:  ForeignKey [fk_aclentry_permid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_aclentry_permid]') AND parent_object_id = OBJECT_ID(N'[dbo].[aclentry]'))
ALTER TABLE [dbo].[aclentry]  WITH CHECK ADD  CONSTRAINT [fk_aclentry_permid] FOREIGN KEY([permission_id])
REFERENCES [dbo].[permission] ([permission_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_aclentry_permid]') AND parent_object_id = OBJECT_ID(N'[dbo].[aclentry]'))
ALTER TABLE [dbo].[aclentry] CHECK CONSTRAINT [fk_aclentry_permid]
GO
/****** Object:  ForeignKey [fk_aclentry_prinid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_aclentry_prinid]') AND parent_object_id = OBJECT_ID(N'[dbo].[aclentry]'))
ALTER TABLE [dbo].[aclentry]  WITH CHECK ADD  CONSTRAINT [fk_aclentry_prinid] FOREIGN KEY([principal_id])
REFERENCES [dbo].[principal] ([principal_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_aclentry_prinid]') AND parent_object_id = OBJECT_ID(N'[dbo].[aclentry]'))
ALTER TABLE [dbo].[aclentry] CHECK CONSTRAINT [fk_aclentry_prinid]
GO
/****** Object:  ForeignKey [fk_actprop_actcontextid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_actprop_actcontextid]') AND parent_object_id = OBJECT_ID(N'[dbo].[action_properties]'))
ALTER TABLE [dbo].[action_properties]  WITH CHECK ADD  CONSTRAINT [fk_actprop_actcontextid] FOREIGN KEY([action_context_id])
REFERENCES [dbo].[actioncontext] ([action_context_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_actprop_actcontextid]') AND parent_object_id = OBJECT_ID(N'[dbo].[action_properties]'))
ALTER TABLE [dbo].[action_properties] CHECK CONSTRAINT [fk_actprop_actcontextid]
GO
/****** Object:  ForeignKey [fk_actcontext_statemodid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_actcontext_statemodid]') AND parent_object_id = OBJECT_ID(N'[dbo].[actioncontext]'))
ALTER TABLE [dbo].[actioncontext]  WITH CHECK ADD  CONSTRAINT [fk_actcontext_statemodid] FOREIGN KEY([state_model_id])
REFERENCES [dbo].[statemodel] ([state_model_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_actcontext_statemodid]') AND parent_object_id = OBJECT_ID(N'[dbo].[actioncontext]'))
ALTER TABLE [dbo].[actioncontext] CHECK CONSTRAINT [fk_actcontext_statemodid]
GO
/****** Object:  ForeignKey [fk_actionlog_actcontextid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_actionlog_actcontextid]') AND parent_object_id = OBJECT_ID(N'[dbo].[actionlog]'))
ALTER TABLE [dbo].[actionlog]  WITH CHECK ADD  CONSTRAINT [fk_actionlog_actcontextid] FOREIGN KEY([action_context_id])
REFERENCES [dbo].[actioncontext] ([action_context_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_actionlog_actcontextid]') AND parent_object_id = OBJECT_ID(N'[dbo].[actionlog]'))
ALTER TABLE [dbo].[actionlog] CHECK CONSTRAINT [fk_actionlog_actcontextid]
GO
/****** Object:  ForeignKey [fk_addr_personid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_addr_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[address]'))
ALTER TABLE [dbo].[address]  WITH CHECK ADD  CONSTRAINT [fk_addr_personid] FOREIGN KEY([person_id])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_addr_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[address]'))
ALTER TABLE [dbo].[address] CHECK CONSTRAINT [fk_addr_personid]
GO
/****** Object:  ForeignKey [fk_altregdndrang_alertregid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_altregdndrang_alertregid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alert_reg_dnd_range]'))
ALTER TABLE [dbo].[alert_reg_dnd_range]  WITH CHECK ADD  CONSTRAINT [fk_altregdndrang_alertregid] FOREIGN KEY([alert_registration_id])
REFERENCES [dbo].[alertregistration] ([alert_registration_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_altregdndrang_alertregid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alert_reg_dnd_range]'))
ALTER TABLE [dbo].[alert_reg_dnd_range] CHECK CONSTRAINT [fk_altregdndrang_alertregid]
GO
/****** Object:  ForeignKey [fk_altregdndrang_dndrangeid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_altregdndrang_dndrangeid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alert_reg_dnd_range]'))
ALTER TABLE [dbo].[alert_reg_dnd_range]  WITH CHECK ADD  CONSTRAINT [fk_altregdndrang_dndrangeid] FOREIGN KEY([dnd_range_id])
REFERENCES [dbo].[dnd_range] ([dnd_range_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_altregdndrang_dndrangeid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alert_reg_dnd_range]'))
ALTER TABLE [dbo].[alert_reg_dnd_range] CHECK CONSTRAINT [fk_altregdndrang_dndrangeid]
GO
/****** Object:  ForeignKey [fk_alertregrulvalue_alertregid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alertregrulvalue_alertregid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alert_reg_rule_values]'))
ALTER TABLE [dbo].[alert_reg_rule_values]  WITH CHECK ADD  CONSTRAINT [fk_alertregrulvalue_alertregid] FOREIGN KEY([alert_registration_id])
REFERENCES [dbo].[alertregistration] ([alert_registration_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alertregrulvalue_alertregid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alert_reg_rule_values]'))
ALTER TABLE [dbo].[alert_reg_rule_values] CHECK CONSTRAINT [fk_alertregrulvalue_alertregid]
GO
/****** Object:  ForeignKey [fk_alert_ref_id]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alert_ref_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertinstance]'))
ALTER TABLE [dbo].[alertinstance]  WITH CHECK ADD  CONSTRAINT [fk_alert_ref_id] FOREIGN KEY([alert_reference_id])
REFERENCES [dbo].[alertreference] ([alert_reference_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alert_ref_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertinstance]'))
ALTER TABLE [dbo].[alertinstance] CHECK CONSTRAINT [fk_alert_ref_id]
GO
/****** Object:  ForeignKey [fk_alert_type_id]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alert_type_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertinstance]'))
ALTER TABLE [dbo].[alertinstance]  WITH CHECK ADD  CONSTRAINT [fk_alert_type_id] FOREIGN KEY([alert_type_id])
REFERENCES [dbo].[alerttype] ([alert_type_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alert_type_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertinstance]'))
ALTER TABLE [dbo].[alertinstance] CHECK CONSTRAINT [fk_alert_type_id]
GO
/****** Object:  ForeignKey [fk_alinstdelayque_alertinsid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alinstdelayque_alertinsid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertinstancedelayqueue]'))
ALTER TABLE [dbo].[alertinstancedelayqueue]  WITH CHECK ADD  CONSTRAINT [fk_alinstdelayque_alertinsid] FOREIGN KEY([alert_instance_id])
REFERENCES [dbo].[alertinstance] ([alert_instance_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alinstdelayque_alertinsid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertinstancedelayqueue]'))
ALTER TABLE [dbo].[alertinstancedelayqueue] CHECK CONSTRAINT [fk_alinstdelayque_alertinsid]
GO
/****** Object:  ForeignKey [fk_alinstdelayque_alertregid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alinstdelayque_alertregid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertinstancedelayqueue]'))
ALTER TABLE [dbo].[alertinstancedelayqueue]  WITH CHECK ADD  CONSTRAINT [fk_alinstdelayque_alertregid] FOREIGN KEY([alert_registration_id])
REFERENCES [dbo].[alertregistration] ([alert_registration_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alinstdelayque_alertregid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertinstancedelayqueue]'))
ALTER TABLE [dbo].[alertinstancedelayqueue] CHECK CONSTRAINT [fk_alinstdelayque_alertregid]
GO
/****** Object:  ForeignKey [fk_alinstqu_alinsid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alinstqu_alinsid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertinstancequeue]'))
ALTER TABLE [dbo].[alertinstancequeue]  WITH CHECK ADD  CONSTRAINT [fk_alinstqu_alinsid] FOREIGN KEY([alert_instance_id])
REFERENCES [dbo].[alertinstance] ([alert_instance_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alinstqu_alinsid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertinstancequeue]'))
ALTER TABLE [dbo].[alertinstancequeue] CHECK CONSTRAINT [fk_alinstqu_alinsid]
GO
/****** Object:  ForeignKey [fk_alertref_alertreftypid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alertref_alertreftypid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertreference]'))
ALTER TABLE [dbo].[alertreference]  WITH CHECK ADD  CONSTRAINT [fk_alertref_alertreftypid] FOREIGN KEY([alert_reference_type_id])
REFERENCES [dbo].[alertreferencetype] ([alert_reference_type_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alertref_alertreftypid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertreference]'))
ALTER TABLE [dbo].[alertreference] CHECK CONSTRAINT [fk_alertref_alertreftypid]
GO
/****** Object:  ForeignKey [fk_alertreg_alertrefid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alertreg_alertrefid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertregistration]'))
ALTER TABLE [dbo].[alertregistration]  WITH CHECK ADD  CONSTRAINT [fk_alertreg_alertrefid] FOREIGN KEY([alert_reference_id])
REFERENCES [dbo].[alertreference] ([alert_reference_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alertreg_alertrefid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertregistration]'))
ALTER TABLE [dbo].[alertregistration] CHECK CONSTRAINT [fk_alertreg_alertrefid]
GO
/****** Object:  ForeignKey [fk_alertreg_alerttypeid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alertreg_alerttypeid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertregistration]'))
ALTER TABLE [dbo].[alertregistration]  WITH CHECK ADD  CONSTRAINT [fk_alertreg_alerttypeid] FOREIGN KEY([alert_type_id])
REFERENCES [dbo].[alerttype] ([alert_type_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alertreg_alerttypeid]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertregistration]'))
ALTER TABLE [dbo].[alertregistration] CHECK CONSTRAINT [fk_alertreg_alerttypeid]
GO
/****** Object:  ForeignKey [fk_alertreg_said]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alertreg_said]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertregistration]'))
ALTER TABLE [dbo].[alertregistration]  WITH CHECK ADD  CONSTRAINT [fk_alertreg_said] FOREIGN KEY([source_addr_id])
REFERENCES [dbo].[source_address] ([source_addr_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_alertreg_said]') AND parent_object_id = OBJECT_ID(N'[dbo].[alertregistration]'))
ALTER TABLE [dbo].[alertregistration] CHECK CONSTRAINT [fk_alertreg_said]
GO
/****** Object:  ForeignKey [fk_aliases_personid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_aliases_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[aliases]'))
ALTER TABLE [dbo].[aliases]  WITH CHECK ADD  CONSTRAINT [fk_aliases_personid] FOREIGN KEY([person_id])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_aliases_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[aliases]'))
ALTER TABLE [dbo].[aliases] CHECK CONSTRAINT [fk_aliases_personid]
GO
/****** Object:  ForeignKey [fk_authtoken_opid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_authtoken_opid]') AND parent_object_id = OBJECT_ID(N'[dbo].[authenticationtoken]'))
ALTER TABLE [dbo].[authenticationtoken]  WITH CHECK ADD  CONSTRAINT [fk_authtoken_opid] FOREIGN KEY([operation_id])
REFERENCES [dbo].[service_operation] ([operation_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_authtoken_opid]') AND parent_object_id = OBJECT_ID(N'[dbo].[authenticationtoken]'))
ALTER TABLE [dbo].[authenticationtoken] CHECK CONSTRAINT [fk_authtoken_opid]
GO
/****** Object:  ForeignKey [fk_authtoken_perid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_authtoken_perid]') AND parent_object_id = OBJECT_ID(N'[dbo].[authenticationtoken]'))
ALTER TABLE [dbo].[authenticationtoken]  WITH CHECK ADD  CONSTRAINT [fk_authtoken_perid] FOREIGN KEY([person_id])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_authtoken_perid]') AND parent_object_id = OBJECT_ID(N'[dbo].[authenticationtoken]'))
ALTER TABLE [dbo].[authenticationtoken] CHECK CONSTRAINT [fk_authtoken_perid]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_clustermemberstatus_clustmemid]') AND parent_object_id = OBJECT_ID(N'[dbo].[clustermemberstatus]'))
ALTER TABLE [dbo].[clustermemberstatus]  WITH CHECK ADD  CONSTRAINT [fk_clustermemberstatus_clustmemid] FOREIGN KEY([cluster_member_id])
REFERENCES [dbo].[clustermember] ([cluster_member_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_clustermemberstatus_clustmemid]') AND parent_object_id = OBJECT_ID(N'[dbo].[clustermemberstatus]'))
ALTER TABLE [dbo].[clustermemberstatus] CHECK CONSTRAINT [fk_clustermemberstatus_clustmemid]
GO
/****** Object:  ForeignKey [fk_cmname_ownerid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_cmname_ownerid]') AND parent_object_id = OBJECT_ID(N'[dbo].[cm_name]'))
ALTER TABLE [dbo].[cm_name]  WITH CHECK ADD  CONSTRAINT [fk_cmname_ownerid] FOREIGN KEY([owner_id])
REFERENCES [dbo].[principal] ([principal_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_cmname_ownerid]') AND parent_object_id = OBJECT_ID(N'[dbo].[cm_name]'))
ALTER TABLE [dbo].[cm_name] CHECK CONSTRAINT [fk_cmname_ownerid]
GO
/****** Object:  ForeignKey [fk_cmrole_roleid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_cmrole_roleid]') AND parent_object_id = OBJECT_ID(N'[dbo].[cm_role]'))
ALTER TABLE [dbo].[cm_role]  WITH CHECK ADD  CONSTRAINT [fk_cmrole_roleid] FOREIGN KEY([role_id])
REFERENCES [dbo].[principal] ([principal_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_cmrole_roleid]') AND parent_object_id = OBJECT_ID(N'[dbo].[cm_role]'))
ALTER TABLE [dbo].[cm_role] CHECK CONSTRAINT [fk_cmrole_roleid]
GO
/****** Object:  ForeignKey [fk_command_opid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_command_opid]') AND parent_object_id = OBJECT_ID(N'[dbo].[command]'))
ALTER TABLE [dbo].[command]  WITH CHECK ADD  CONSTRAINT [fk_command_opid] FOREIGN KEY([operation_id])
REFERENCES [dbo].[service_operation] ([operation_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_command_opid]') AND parent_object_id = OBJECT_ID(N'[dbo].[command]'))
ALTER TABLE [dbo].[command] CHECK CONSTRAINT [fk_command_opid]
GO
/****** Object:  ForeignKey [fk_condprop_condcontextid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_condprop_condcontextid]') AND parent_object_id = OBJECT_ID(N'[dbo].[condition_properties]'))
ALTER TABLE [dbo].[condition_properties]  WITH CHECK ADD  CONSTRAINT [fk_condprop_condcontextid] FOREIGN KEY([condition_context_id])
REFERENCES [dbo].[conditioncontext] ([condition_context_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_condprop_condcontextid]') AND parent_object_id = OBJECT_ID(N'[dbo].[condition_properties]'))
ALTER TABLE [dbo].[condition_properties] CHECK CONSTRAINT [fk_condprop_condcontextid]
GO
/****** Object:  ForeignKey [fk_condcontext_statemodid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_condcontext_statemodid]') AND parent_object_id = OBJECT_ID(N'[dbo].[conditioncontext]'))
ALTER TABLE [dbo].[conditioncontext]  WITH CHECK ADD  CONSTRAINT [fk_condcontext_statemodid] FOREIGN KEY([state_model_id])
REFERENCES [dbo].[statemodel] ([state_model_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_condcontext_statemodid]') AND parent_object_id = OBJECT_ID(N'[dbo].[conditioncontext]'))
ALTER TABLE [dbo].[conditioncontext] CHECK CONSTRAINT [fk_condcontext_statemodid]
GO
/****** Object:  ForeignKey [fk_condcontext_transid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_condcontext_transid]') AND parent_object_id = OBJECT_ID(N'[dbo].[conditioncontext]'))
ALTER TABLE [dbo].[conditioncontext]  WITH CHECK ADD  CONSTRAINT [fk_condcontext_transid] FOREIGN KEY([transition_id])
REFERENCES [dbo].[transition] ([transition_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_condcontext_transid]') AND parent_object_id = OBJECT_ID(N'[dbo].[conditioncontext]'))
ALTER TABLE [dbo].[conditioncontext] CHECK CONSTRAINT [fk_condcontext_transid]
GO
/****** Object:  ForeignKey [fk_conv_statemodelregid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_conv_statemodelregid]') AND parent_object_id = OBJECT_ID(N'[dbo].[conversation]'))
ALTER TABLE [dbo].[conversation]  WITH CHECK ADD  CONSTRAINT [fk_conv_statemodelregid] FOREIGN KEY([state_model_reg_id])
REFERENCES [dbo].[statemodelregistration] ([state_model_reg_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_conv_statemodelregid]') AND parent_object_id = OBJECT_ID(N'[dbo].[conversation]'))
ALTER TABLE [dbo].[conversation] CHECK CONSTRAINT [fk_conv_statemodelregid]
GO
/****** Object:  ForeignKey [fk_conv_statemodid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_conv_statemodid]') AND parent_object_id = OBJECT_ID(N'[dbo].[conversation]'))
ALTER TABLE [dbo].[conversation]  WITH CHECK ADD  CONSTRAINT [fk_conv_statemodid] FOREIGN KEY([state_model_id])
REFERENCES [dbo].[statemodel] ([state_model_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_conv_statemodid]') AND parent_object_id = OBJECT_ID(N'[dbo].[conversation]'))
ALTER TABLE [dbo].[conversation] CHECK CONSTRAINT [fk_conv_statemodid]
GO
/****** Object:  ForeignKey [fk_conv_statid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_conv_statid]') AND parent_object_id = OBJECT_ID(N'[dbo].[conversation]'))
ALTER TABLE [dbo].[conversation]  WITH CHECK ADD  CONSTRAINT [fk_conv_statid] FOREIGN KEY([state_id])
REFERENCES [dbo].[state] ([state_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_conv_statid]') AND parent_object_id = OBJECT_ID(N'[dbo].[conversation]'))
ALTER TABLE [dbo].[conversation] CHECK CONSTRAINT [fk_conv_statid]
GO
/****** Object:  ForeignKey [fk_discoeventfile_discoeventid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_discoeventfile_discoeventid]') AND parent_object_id = OBJECT_ID(N'[dbo].[discoeventfile]'))
ALTER TABLE [dbo].[discoeventfile]  WITH CHECK ADD  CONSTRAINT [fk_discoeventfile_discoeventid] FOREIGN KEY([disco_event_id])
REFERENCES [dbo].[discoevent] ([disco_event_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_discoeventfile_discoeventid]') AND parent_object_id = OBJECT_ID(N'[dbo].[discoeventfile]'))
ALTER TABLE [dbo].[discoeventfile] CHECK CONSTRAINT [fk_discoeventfile_discoeventid]
GO
/****** Object:  ForeignKey [fk_discoeventphone_discoeventid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_discoeventphone_discoeventid]') AND parent_object_id = OBJECT_ID(N'[dbo].[discoeventphone]'))
ALTER TABLE [dbo].[discoeventphone]  WITH CHECK ADD  CONSTRAINT [fk_discoeventphone_discoeventid] FOREIGN KEY([disco_event_id])
REFERENCES [dbo].[discoevent] ([disco_event_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_discoeventphone_discoeventid]') AND parent_object_id = OBJECT_ID(N'[dbo].[discoeventphone]'))
ALTER TABLE [dbo].[discoeventphone] CHECK CONSTRAINT [fk_discoeventphone_discoeventid]
GO
/****** Object:  ForeignKey [fk_discoeventphone_phoneid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_discoeventphone_phoneid]') AND parent_object_id = OBJECT_ID(N'[dbo].[discoeventphone]'))
ALTER TABLE [dbo].[discoeventphone]  WITH CHECK ADD  CONSTRAINT [fk_discoeventphone_phoneid] FOREIGN KEY([phone_id])
REFERENCES [dbo].[phonenumber] ([phone_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_discoeventphone_phoneid]') AND parent_object_id = OBJECT_ID(N'[dbo].[discoeventphone]'))
ALTER TABLE [dbo].[discoeventphone] CHECK CONSTRAINT [fk_discoeventphone_phoneid]
GO
/****** Object:  ForeignKey [fk_email_emailid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_email_emailid]') AND parent_object_id = OBJECT_ID(N'[dbo].[email]'))
ALTER TABLE [dbo].[email]  WITH CHECK ADD  CONSTRAINT [fk_email_emailid] FOREIGN KEY([email_id])
REFERENCES [dbo].[source_address] ([source_addr_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_email_emailid]') AND parent_object_id = OBJECT_ID(N'[dbo].[email]'))
ALTER TABLE [dbo].[email] CHECK CONSTRAINT [fk_email_emailid]
GO
/****** Object:  ForeignKey [fk_email_personid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_email_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[email]'))
ALTER TABLE [dbo].[email]  WITH CHECK ADD  CONSTRAINT [fk_email_personid] FOREIGN KEY([person_id])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_email_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[email]'))
ALTER TABLE [dbo].[email] CHECK CONSTRAINT [fk_email_personid]
GO
/****** Object:  ForeignKey [fk_emailhist_id]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_emailhist_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[email_history]'))
ALTER TABLE [dbo].[email_history]  WITH CHECK ADD  CONSTRAINT [fk_emailhist_id] FOREIGN KEY([id])
REFERENCES [dbo].[source_address_history] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_emailhist_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[email_history]'))
ALTER TABLE [dbo].[email_history] CHECK CONSTRAINT [fk_emailhist_id]
GO
/****** Object:  ForeignKey [fk_entryactcontext_entryactid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_entryactcontext_entryactid]') AND parent_object_id = OBJECT_ID(N'[dbo].[entryactioncontext]'))
ALTER TABLE [dbo].[entryactioncontext]  WITH CHECK ADD  CONSTRAINT [fk_entryactcontext_entryactid] FOREIGN KEY([entry_action_id])
REFERENCES [dbo].[actioncontext] ([action_context_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_entryactcontext_entryactid]') AND parent_object_id = OBJECT_ID(N'[dbo].[entryactioncontext]'))
ALTER TABLE [dbo].[entryactioncontext] CHECK CONSTRAINT [fk_entryactcontext_entryactid]
GO
/****** Object:  ForeignKey [fk_entryactcontext_stateid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_entryactcontext_stateid]') AND parent_object_id = OBJECT_ID(N'[dbo].[entryactioncontext]'))
ALTER TABLE [dbo].[entryactioncontext]  WITH CHECK ADD  CONSTRAINT [fk_entryactcontext_stateid] FOREIGN KEY([state_id])
REFERENCES [dbo].[state] ([state_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_entryactcontext_stateid]') AND parent_object_id = OBJECT_ID(N'[dbo].[entryactioncontext]'))
ALTER TABLE [dbo].[entryactioncontext] CHECK CONSTRAINT [fk_entryactcontext_stateid]
GO
/****** Object:  ForeignKey [fk_eventlogentry_evimpid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_eventlogentry_evimpid]') AND parent_object_id = OBJECT_ID(N'[dbo].[eventlogentry]'))
ALTER TABLE [dbo].[eventlogentry]  WITH CHECK ADD  CONSTRAINT [fk_eventlogentry_evimpid] FOREIGN KEY([eventimportanceid])
REFERENCES [dbo].[eventimportance] ([event_importance_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_eventlogentry_evimpid]') AND parent_object_id = OBJECT_ID(N'[dbo].[eventlogentry]'))
ALTER TABLE [dbo].[eventlogentry] CHECK CONSTRAINT [fk_eventlogentry_evimpid]
GO
/****** Object:  ForeignKey [fk_exitactioncontext_exitactid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_exitactioncontext_exitactid]') AND parent_object_id = OBJECT_ID(N'[dbo].[exitactioncontext]'))
ALTER TABLE [dbo].[exitactioncontext]  WITH CHECK ADD  CONSTRAINT [fk_exitactioncontext_exitactid] FOREIGN KEY([exit_action_id])
REFERENCES [dbo].[actioncontext] ([action_context_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_exitactioncontext_exitactid]') AND parent_object_id = OBJECT_ID(N'[dbo].[exitactioncontext]'))
ALTER TABLE [dbo].[exitactioncontext] CHECK CONSTRAINT [fk_exitactioncontext_exitactid]
GO
/****** Object:  ForeignKey [fk_exitactioncontext_stateid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_exitactioncontext_stateid]') AND parent_object_id = OBJECT_ID(N'[dbo].[exitactioncontext]'))
ALTER TABLE [dbo].[exitactioncontext]  WITH CHECK ADD  CONSTRAINT [fk_exitactioncontext_stateid] FOREIGN KEY([state_id])
REFERENCES [dbo].[state] ([state_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_exitactioncontext_stateid]') AND parent_object_id = OBJECT_ID(N'[dbo].[exitactioncontext]'))
ALTER TABLE [dbo].[exitactioncontext] CHECK CONSTRAINT [fk_exitactioncontext_stateid]
GO
/****** Object:  ForeignKey [fk_ftruge_dy_usagemon_id]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ftruge_dy_usagemon_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[featureusage]'))
ALTER TABLE [dbo].[featureusage]  WITH CHECK ADD  CONSTRAINT [fk_ftruge_dy_usagemon_id] FOREIGN KEY([daily_amount_usage_id])
REFERENCES [dbo].[dailyusagemonitor] ([daily_usage_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ftruge_dy_usagemon_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[featureusage]'))
ALTER TABLE [dbo].[featureusage] CHECK CONSTRAINT [fk_ftruge_dy_usagemon_id]
GO
/****** Object:  ForeignKey [fk_ftruge_per_id]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ftruge_per_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[featureusage]'))
ALTER TABLE [dbo].[featureusage]  WITH CHECK ADD  CONSTRAINT [fk_ftruge_per_id] FOREIGN KEY([person_id])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ftruge_per_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[featureusage]'))
ALTER TABLE [dbo].[featureusage] CHECK CONSTRAINT [fk_ftruge_per_id]
GO
/****** Object:  ForeignKey [fk_ftruge_wk_uagemon_id]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ftruge_wk_uagemon_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[featureusage]'))
ALTER TABLE [dbo].[featureusage]  WITH CHECK ADD  CONSTRAINT [fk_ftruge_wk_uagemon_id] FOREIGN KEY([weekly_trans_usage_id])
REFERENCES [dbo].[weeklyusagemonitor] ([weekly_usage_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ftruge_wk_uagemon_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[featureusage]'))
ALTER TABLE [dbo].[featureusage] CHECK CONSTRAINT [fk_ftruge_wk_uagemon_id]
GO
/****** Object:  ForeignKey [fk_ftruge_wk_usagemon_id]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ftruge_wk_usagemon_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[featureusage]'))
ALTER TABLE [dbo].[featureusage]  WITH CHECK ADD  CONSTRAINT [fk_ftruge_wk_usagemon_id] FOREIGN KEY([weekly_amount_usage_id])
REFERENCES [dbo].[weeklyusagemonitor] ([weekly_usage_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_ftruge_wk_usagemon_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[featureusage]'))
ALTER TABLE [dbo].[featureusage] CHECK CONSTRAINT [fk_ftruge_wk_usagemon_id]
GO
/****** Object:  ForeignKey [fk_grouprole_groupid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_grouprole_groupid]') AND parent_object_id = OBJECT_ID(N'[dbo].[group_role]'))
ALTER TABLE [dbo].[group_role]  WITH CHECK ADD  CONSTRAINT [fk_grouprole_groupid] FOREIGN KEY([group_id])
REFERENCES [dbo].[tgroup] ([group_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_grouprole_groupid]') AND parent_object_id = OBJECT_ID(N'[dbo].[group_role]'))
ALTER TABLE [dbo].[group_role] CHECK CONSTRAINT [fk_grouprole_groupid]
GO
/****** Object:  ForeignKey [fk_grouprole_roleid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_grouprole_roleid]') AND parent_object_id = OBJECT_ID(N'[dbo].[group_role]'))
ALTER TABLE [dbo].[group_role]  WITH CHECK ADD  CONSTRAINT [fk_grouprole_roleid] FOREIGN KEY([role_id])
REFERENCES [dbo].[cm_role] ([role_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_grouprole_roleid]') AND parent_object_id = OBJECT_ID(N'[dbo].[group_role]'))
ALTER TABLE [dbo].[group_role] CHECK CONSTRAINT [fk_grouprole_roleid]
GO
/****** Object:  ForeignKey [fk_helpmess_cmnameid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_helpmess_cmnameid]') AND parent_object_id = OBJECT_ID(N'[dbo].[help_message]'))
ALTER TABLE [dbo].[help_message]  WITH CHECK ADD  CONSTRAINT [fk_helpmess_cmnameid] FOREIGN KEY([cm_name_id])
REFERENCES [dbo].[cm_name] ([cm_name_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_helpmess_cmnameid]') AND parent_object_id = OBJECT_ID(N'[dbo].[help_message]'))
ALTER TABLE [dbo].[help_message] CHECK CONSTRAINT [fk_helpmess_cmnameid]
GO
/****** Object:  ForeignKey [fk_imaddress_imaddrid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_imaddress_imaddrid]') AND parent_object_id = OBJECT_ID(N'[dbo].[imaddress]'))
ALTER TABLE [dbo].[imaddress]  WITH CHECK ADD  CONSTRAINT [fk_imaddress_imaddrid] FOREIGN KEY([imaddress_id])
REFERENCES [dbo].[source_address] ([source_addr_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_imaddress_imaddrid]') AND parent_object_id = OBJECT_ID(N'[dbo].[imaddress]'))
ALTER TABLE [dbo].[imaddress] CHECK CONSTRAINT [fk_imaddress_imaddrid]
GO
/****** Object:  ForeignKey [fk_imaddress_personid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_imaddress_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[imaddress]'))
ALTER TABLE [dbo].[imaddress]  WITH CHECK ADD  CONSTRAINT [fk_imaddress_personid] FOREIGN KEY([person_id])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_imaddress_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[imaddress]'))
ALTER TABLE [dbo].[imaddress] CHECK CONSTRAINT [fk_imaddress_personid]
GO
/****** Object:  ForeignKey [fk_imaddrhist_id]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_imaddrhist_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[imaddress_history]'))
ALTER TABLE [dbo].[imaddress_history]  WITH CHECK ADD  CONSTRAINT [fk_imaddrhist_id] FOREIGN KEY([id])
REFERENCES [dbo].[source_address_history] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_imaddrhist_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[imaddress_history]'))
ALTER TABLE [dbo].[imaddress_history] CHECK CONSTRAINT [fk_imaddrhist_id]
GO
/****** Object:  ForeignKey [fk_locprop_loc_locid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_locprop_loc_locid]') AND parent_object_id = OBJECT_ID(N'[dbo].[location_properties]'))
ALTER TABLE [dbo].[location_properties]  WITH CHECK ADD  CONSTRAINT [fk_locprop_loc_locid] FOREIGN KEY([p_location_id])
REFERENCES [dbo].[location] ([location_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_locprop_loc_locid]') AND parent_object_id = OBJECT_ID(N'[dbo].[location_properties]'))
ALTER TABLE [dbo].[location_properties] CHECK CONSTRAINT [fk_locprop_loc_locid]
GO
/****** Object:  ForeignKey [fk_macro_personid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_macro_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[macro]'))
ALTER TABLE [dbo].[macro]  WITH CHECK ADD  CONSTRAINT [fk_macro_personid] FOREIGN KEY([person_id])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_macro_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[macro]'))
ALTER TABLE [dbo].[macro] CHECK CONSTRAINT [fk_macro_personid]
GO
/****** Object:  ForeignKey [fk_messonhold_authtokenid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_messonhold_authtokenid]') AND parent_object_id = OBJECT_ID(N'[dbo].[message_on_hold]'))
ALTER TABLE [dbo].[message_on_hold]  WITH CHECK ADD  CONSTRAINT [fk_messonhold_authtokenid] FOREIGN KEY([authentication_token_id])
REFERENCES [dbo].[authenticationtoken] ([authentication_token_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_messonhold_authtokenid]') AND parent_object_id = OBJECT_ID(N'[dbo].[message_on_hold]'))
ALTER TABLE [dbo].[message_on_hold] CHECK CONSTRAINT [fk_messonhold_authtokenid]
GO
/****** Object:  ForeignKey [fk_mobile_client_id]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_mobile_client_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[mobile_client]'))
ALTER TABLE [dbo].[mobile_client]  WITH CHECK ADD  CONSTRAINT [fk_mobile_client_id] FOREIGN KEY([mobile_client_id])
REFERENCES [dbo].[source_address] ([source_addr_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_mobile_client_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[mobile_client]'))
ALTER TABLE [dbo].[mobile_client] CHECK CONSTRAINT [fk_mobile_client_id]
GO
/****** Object:  ForeignKey [fk_person_id]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_person_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[mobile_client]'))
ALTER TABLE [dbo].[mobile_client]  WITH CHECK ADD  CONSTRAINT [fk_person_id] FOREIGN KEY([person_id])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_person_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[mobile_client]'))
ALTER TABLE [dbo].[mobile_client] CHECK CONSTRAINT [fk_person_id]
GO
/****** Object:  ForeignKey [fk_mobclientid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_mobclientid]') AND parent_object_id = OBJECT_ID(N'[dbo].[mobile_client_history]'))
ALTER TABLE [dbo].[mobile_client_history]  WITH CHECK ADD  CONSTRAINT [fk_mobclientid] FOREIGN KEY([id])
REFERENCES [dbo].[source_address_history] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_mobclientid]') AND parent_object_id = OBJECT_ID(N'[dbo].[mobile_client_history]'))
ALTER TABLE [dbo].[mobile_client_history] CHECK CONSTRAINT [fk_mobclientid]
GO
/****** Object:  ForeignKey [fk_namedres_nameresid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_namedres_nameresid]') AND parent_object_id = OBJECT_ID(N'[dbo].[named_resource]'))
ALTER TABLE [dbo].[named_resource]  WITH CHECK ADD  CONSTRAINT [fk_namedres_nameresid] FOREIGN KEY([named_resource_id])
REFERENCES [dbo].[cm_name] ([cm_name_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_namedres_nameresid]') AND parent_object_id = OBJECT_ID(N'[dbo].[named_resource]'))
ALTER TABLE [dbo].[named_resource] CHECK CONSTRAINT [fk_namedres_nameresid]
GO
/****** Object:  ForeignKey [fk_onetimepin_personid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_onetimepin_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[onetime_pin]'))
ALTER TABLE [dbo].[onetime_pin]  WITH CHECK ADD  CONSTRAINT [fk_onetimepin_personid] FOREIGN KEY([person_id])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_onetimepin_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[onetime_pin]'))
ALTER TABLE [dbo].[onetime_pin] CHECK CONSTRAINT [fk_onetimepin_personid]
GO
/****** Object:  ForeignKey [fk_pendingevent_covnid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_pendingevent_covnid]') AND parent_object_id = OBJECT_ID(N'[dbo].[pendingevent]'))
ALTER TABLE [dbo].[pendingevent]  WITH CHECK ADD  CONSTRAINT [fk_pendingevent_covnid] FOREIGN KEY([conversation_id])
REFERENCES [dbo].[conversation] ([conversation_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_pendingevent_covnid]') AND parent_object_id = OBJECT_ID(N'[dbo].[pendingevent]'))
ALTER TABLE [dbo].[pendingevent] CHECK CONSTRAINT [fk_pendingevent_covnid]
GO
/****** Object:  ForeignKey [fk_perdndrang_dndrangeid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_perdndrang_dndrangeid]') AND parent_object_id = OBJECT_ID(N'[dbo].[person_dnd_range]'))
ALTER TABLE [dbo].[person_dnd_range]  WITH CHECK ADD  CONSTRAINT [fk_perdndrang_dndrangeid] FOREIGN KEY([dnd_range_id])
REFERENCES [dbo].[dnd_range] ([dnd_range_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_perdndrang_dndrangeid]') AND parent_object_id = OBJECT_ID(N'[dbo].[person_dnd_range]'))
ALTER TABLE [dbo].[person_dnd_range] CHECK CONSTRAINT [fk_perdndrang_dndrangeid]
GO
/****** Object:  ForeignKey [fk_perdndrang_personid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_perdndrang_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[person_dnd_range]'))
ALTER TABLE [dbo].[person_dnd_range]  WITH CHECK ADD  CONSTRAINT [fk_perdndrang_personid] FOREIGN KEY([person_id])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_perdndrang_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[person_dnd_range]'))
ALTER TABLE [dbo].[person_dnd_range] CHECK CONSTRAINT [fk_perdndrang_personid]
GO
/****** Object:  ForeignKey [fk_pergrp_groupid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_pergrp_groupid]') AND parent_object_id = OBJECT_ID(N'[dbo].[person_group]'))
ALTER TABLE [dbo].[person_group]  WITH CHECK ADD  CONSTRAINT [fk_pergrp_groupid] FOREIGN KEY([group_id])
REFERENCES [dbo].[tgroup] ([group_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_pergrp_groupid]') AND parent_object_id = OBJECT_ID(N'[dbo].[person_group]'))
ALTER TABLE [dbo].[person_group] CHECK CONSTRAINT [fk_pergrp_groupid]
GO
/****** Object:  ForeignKey [fk_pergrp_perprinid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_pergrp_perprinid]') AND parent_object_id = OBJECT_ID(N'[dbo].[person_group]'))
ALTER TABLE [dbo].[person_group]  WITH CHECK ADD  CONSTRAINT [fk_pergrp_perprinid] FOREIGN KEY([person_principal_id])
REFERENCES [dbo].[personprincipal] ([person_principal_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_pergrp_perprinid]') AND parent_object_id = OBJECT_ID(N'[dbo].[person_group]'))
ALTER TABLE [dbo].[person_group] CHECK CONSTRAINT [fk_pergrp_perprinid]
GO
/****** Object:  ForeignKey [fk_perrole_perprinid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_perrole_perprinid]') AND parent_object_id = OBJECT_ID(N'[dbo].[person_role]'))
ALTER TABLE [dbo].[person_role]  WITH CHECK ADD  CONSTRAINT [fk_perrole_perprinid] FOREIGN KEY([person_principal_id])
REFERENCES [dbo].[personprincipal] ([person_principal_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_perrole_perprinid]') AND parent_object_id = OBJECT_ID(N'[dbo].[person_role]'))
ALTER TABLE [dbo].[person_role] CHECK CONSTRAINT [fk_perrole_perprinid]
GO
/****** Object:  ForeignKey [fk_perrole_roleid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_perrole_roleid]') AND parent_object_id = OBJECT_ID(N'[dbo].[person_role]'))
ALTER TABLE [dbo].[person_role]  WITH CHECK ADD  CONSTRAINT [fk_perrole_roleid] FOREIGN KEY([role_id])
REFERENCES [dbo].[cm_role] ([role_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_perrole_roleid]') AND parent_object_id = OBJECT_ID(N'[dbo].[person_role]'))
ALTER TABLE [dbo].[person_role] CHECK CONSTRAINT [fk_perrole_roleid]
GO
/****** Object:  ForeignKey [fk_personprin_perid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_personprin_perid]') AND parent_object_id = OBJECT_ID(N'[dbo].[personprincipal]'))
ALTER TABLE [dbo].[personprincipal]  WITH CHECK ADD  CONSTRAINT [fk_personprin_perid] FOREIGN KEY([person_id])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_personprin_perid]') AND parent_object_id = OBJECT_ID(N'[dbo].[personprincipal]'))
ALTER TABLE [dbo].[personprincipal] CHECK CONSTRAINT [fk_personprin_perid]
GO
/****** Object:  ForeignKey [fk_personprin_perprinid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_personprin_perprinid]') AND parent_object_id = OBJECT_ID(N'[dbo].[personprincipal]'))
ALTER TABLE [dbo].[personprincipal]  WITH CHECK ADD  CONSTRAINT [fk_personprin_perprinid] FOREIGN KEY([person_principal_id])
REFERENCES [dbo].[principal] ([principal_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_personprin_perprinid]') AND parent_object_id = OBJECT_ID(N'[dbo].[personprincipal]'))
ALTER TABLE [dbo].[personprincipal] CHECK CONSTRAINT [fk_personprin_perprinid]
GO
/****** Object:  ForeignKey [fk_personprofile_perid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_personprofile_perid]') AND parent_object_id = OBJECT_ID(N'[dbo].[personprofile]'))
ALTER TABLE [dbo].[personprofile]  WITH CHECK ADD  CONSTRAINT [fk_personprofile_perid] FOREIGN KEY([person_id])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_personprofile_perid]') AND parent_object_id = OBJECT_ID(N'[dbo].[personprofile]'))
ALTER TABLE [dbo].[personprofile] CHECK CONSTRAINT [fk_personprofile_perid]
GO
/****** Object:  ForeignKey [fk_carrier_id]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_carrier_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[phonenumber]'))
ALTER TABLE [dbo].[phonenumber]  WITH CHECK ADD  CONSTRAINT [fk_carrier_id] FOREIGN KEY([carrier_id])
REFERENCES [dbo].[carrier] ([carrier_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_carrier_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[phonenumber]'))
ALTER TABLE [dbo].[phonenumber] CHECK CONSTRAINT [fk_carrier_id]
GO
/****** Object:  ForeignKey [fk_phonenumber_perid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_phonenumber_perid]') AND parent_object_id = OBJECT_ID(N'[dbo].[phonenumber]'))
ALTER TABLE [dbo].[phonenumber]  WITH CHECK ADD  CONSTRAINT [fk_phonenumber_perid] FOREIGN KEY([person_id])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_phonenumber_perid]') AND parent_object_id = OBJECT_ID(N'[dbo].[phonenumber]'))
ALTER TABLE [dbo].[phonenumber] CHECK CONSTRAINT [fk_phonenumber_perid]
GO
/****** Object:  ForeignKey [fk_phonenumber_phoneid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_phonenumber_phoneid]') AND parent_object_id = OBJECT_ID(N'[dbo].[phonenumber]'))
ALTER TABLE [dbo].[phonenumber]  WITH CHECK ADD  CONSTRAINT [fk_phonenumber_phoneid] FOREIGN KEY([phone_id])
REFERENCES [dbo].[source_address] ([source_addr_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_phonenumber_phoneid]') AND parent_object_id = OBJECT_ID(N'[dbo].[phonenumber]'))
ALTER TABLE [dbo].[phonenumber] CHECK CONSTRAINT [fk_phonenumber_phoneid]
GO
/****** Object:  ForeignKey [fk_phonenumhist_id]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_phonenumhist_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[phonenumber_history]'))
ALTER TABLE [dbo].[phonenumber_history]  WITH CHECK ADD  CONSTRAINT [fk_phonenumhist_id] FOREIGN KEY([id])
REFERENCES [dbo].[source_address_history] ([id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_phonenumhist_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[phonenumber_history]'))
ALTER TABLE [dbo].[phonenumber_history] CHECK CONSTRAINT [fk_phonenumhist_id]
GO
/****** Object:  ForeignKey [FK_ENROLLMENT_PER_ID]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENROLLMENT_PER_ID]') AND parent_object_id = OBJECT_ID(N'[dbo].[PRODUCTENROLLMENT]'))
ALTER TABLE [dbo].[PRODUCTENROLLMENT]  WITH CHECK ADD  CONSTRAINT [FK_ENROLLMENT_PER_ID] FOREIGN KEY([PERSON_ID])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ENROLLMENT_PER_ID]') AND parent_object_id = OBJECT_ID(N'[dbo].[PRODUCTENROLLMENT]'))
ALTER TABLE [dbo].[PRODUCTENROLLMENT] CHECK CONSTRAINT [FK_ENROLLMENT_PER_ID]
GO
/****** Object:  ForeignKey [fk_property_personid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_property_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[property]'))
ALTER TABLE [dbo].[property]  WITH CHECK ADD  CONSTRAINT [fk_property_personid] FOREIGN KEY([person_id])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_property_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[property]'))
ALTER TABLE [dbo].[property] CHECK CONSTRAINT [fk_property_personid]
GO
/****** Object:  ForeignKey [fk_property_propertykeyid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_property_propertykeyid]') AND parent_object_id = OBJECT_ID(N'[dbo].[property]'))
ALTER TABLE [dbo].[property]  WITH CHECK ADD  CONSTRAINT [fk_property_propertykeyid] FOREIGN KEY([property_key_id])
REFERENCES [dbo].[propertykey] ([property_key_id])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_property_propertykeyid]') AND parent_object_id = OBJECT_ID(N'[dbo].[property]'))
ALTER TABLE [dbo].[property] CHECK CONSTRAINT [fk_property_propertykeyid]
GO
/****** Object:  ForeignKey [fk_propertykey_endpointid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_propertykey_endpointid]') AND parent_object_id = OBJECT_ID(N'[dbo].[propertykey]'))
ALTER TABLE [dbo].[propertykey]  WITH CHECK ADD  CONSTRAINT [fk_propertykey_endpointid] FOREIGN KEY([endpoint_id])
REFERENCES [dbo].[service_endpoint] ([endpoint_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_propertykey_endpointid]') AND parent_object_id = OBJECT_ID(N'[dbo].[propertykey]'))
ALTER TABLE [dbo].[propertykey] CHECK CONSTRAINT [fk_propertykey_endpointid]
GO
/****** Object:  ForeignKey [fk_serend_endid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_serend_endid]') AND parent_object_id = OBJECT_ID(N'[dbo].[service_endpoint]'))
ALTER TABLE [dbo].[service_endpoint]  WITH CHECK ADD  CONSTRAINT [fk_serend_endid] FOREIGN KEY([endpoint_id])
REFERENCES [dbo].[cm_name] ([cm_name_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_serend_endid]') AND parent_object_id = OBJECT_ID(N'[dbo].[service_endpoint]'))
ALTER TABLE [dbo].[service_endpoint] CHECK CONSTRAINT [fk_serend_endid]
GO
/****** Object:  ForeignKey [fk_serint_endid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_serint_endid]') AND parent_object_id = OBJECT_ID(N'[dbo].[service_interface]'))
ALTER TABLE [dbo].[service_interface]  WITH CHECK ADD  CONSTRAINT [fk_serint_endid] FOREIGN KEY([endpoint_id])
REFERENCES [dbo].[service_endpoint] ([endpoint_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_serint_endid]') AND parent_object_id = OBJECT_ID(N'[dbo].[service_interface]'))
ALTER TABLE [dbo].[service_interface] CHECK CONSTRAINT [fk_serint_endid]
GO
/****** Object:  ForeignKey [fk_serint_intid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_serint_intid]') AND parent_object_id = OBJECT_ID(N'[dbo].[service_interface]'))
ALTER TABLE [dbo].[service_interface]  WITH CHECK ADD  CONSTRAINT [fk_serint_intid] FOREIGN KEY([interface_id])
REFERENCES [dbo].[cm_name] ([cm_name_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_serint_intid]') AND parent_object_id = OBJECT_ID(N'[dbo].[service_interface]'))
ALTER TABLE [dbo].[service_interface] CHECK CONSTRAINT [fk_serint_intid]
GO
/****** Object:  ForeignKey [fk_serope_intid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_serope_intid]') AND parent_object_id = OBJECT_ID(N'[dbo].[service_operation]'))
ALTER TABLE [dbo].[service_operation]  WITH CHECK ADD  CONSTRAINT [fk_serope_intid] FOREIGN KEY([interface_id])
REFERENCES [dbo].[service_interface] ([interface_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_serope_intid]') AND parent_object_id = OBJECT_ID(N'[dbo].[service_operation]'))
ALTER TABLE [dbo].[service_operation] CHECK CONSTRAINT [fk_serope_intid]
GO
/****** Object:  ForeignKey [fk_serope_opeid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_serope_opeid]') AND parent_object_id = OBJECT_ID(N'[dbo].[service_operation]'))
ALTER TABLE [dbo].[service_operation]  WITH CHECK ADD  CONSTRAINT [fk_serope_opeid] FOREIGN KEY([operation_id])
REFERENCES [dbo].[cm_name] ([cm_name_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_serope_opeid]') AND parent_object_id = OBJECT_ID(N'[dbo].[service_operation]'))
ALTER TABLE [dbo].[service_operation] CHECK CONSTRAINT [fk_serope_opeid]
GO
/****** Object:  ForeignKey [fk_smpp_aggregate_id]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_smpp_aggregate_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[smppcarriercode]'))
ALTER TABLE [dbo].[smppcarriercode]  WITH CHECK ADD  CONSTRAINT [fk_smpp_aggregate_id] FOREIGN KEY([aggregator_id])
REFERENCES [dbo].[aggregator] ([aggregator_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_smpp_aggregate_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[smppcarriercode]'))
ALTER TABLE [dbo].[smppcarriercode] CHECK CONSTRAINT [fk_smpp_aggregate_id]
GO
/****** Object:  ForeignKey [fk_smpp_carrier_id]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_smpp_carrier_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[smppcarriercode]'))
ALTER TABLE [dbo].[smppcarriercode]  WITH CHECK ADD  CONSTRAINT [fk_smpp_carrier_id] FOREIGN KEY([carrier_id])
REFERENCES [dbo].[carrier] ([carrier_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_smpp_carrier_id]') AND parent_object_id = OBJECT_ID(N'[dbo].[smppcarriercode]'))
ALTER TABLE [dbo].[smppcarriercode] CHECK CONSTRAINT [fk_smpp_carrier_id]
GO
/****** Object:  ForeignKey [fk_sadndrange_dndrangeid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_sadndrange_dndrangeid]') AND parent_object_id = OBJECT_ID(N'[dbo].[source_address_dnd_range]'))
ALTER TABLE [dbo].[source_address_dnd_range]  WITH CHECK ADD  CONSTRAINT [fk_sadndrange_dndrangeid] FOREIGN KEY([dnd_range_id])
REFERENCES [dbo].[dnd_range] ([dnd_range_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_sadndrange_dndrangeid]') AND parent_object_id = OBJECT_ID(N'[dbo].[source_address_dnd_range]'))
ALTER TABLE [dbo].[source_address_dnd_range] CHECK CONSTRAINT [fk_sadndrange_dndrangeid]
GO
/****** Object:  ForeignKey [fk_sadndrange_said]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_sadndrange_said]') AND parent_object_id = OBJECT_ID(N'[dbo].[source_address_dnd_range]'))
ALTER TABLE [dbo].[source_address_dnd_range]  WITH CHECK ADD  CONSTRAINT [fk_sadndrange_said] FOREIGN KEY([source_addr_id])
REFERENCES [dbo].[source_address] ([source_addr_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_sadndrange_said]') AND parent_object_id = OBJECT_ID(N'[dbo].[source_address_dnd_range]'))
ALTER TABLE [dbo].[source_address_dnd_range] CHECK CONSTRAINT [fk_sadndrange_said]
GO
/****** Object:  ForeignKey [fk_saver_said]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_saver_said]') AND parent_object_id = OBJECT_ID(N'[dbo].[srcaddr_verification]'))
ALTER TABLE [dbo].[srcaddr_verification]  WITH CHECK ADD  CONSTRAINT [fk_saver_said] FOREIGN KEY([source_addr_id])
REFERENCES [dbo].[source_address] ([source_addr_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_saver_said]') AND parent_object_id = OBJECT_ID(N'[dbo].[srcaddr_verification]'))
ALTER TABLE [dbo].[srcaddr_verification] CHECK CONSTRAINT [fk_saver_said]
GO
/****** Object:  ForeignKey [fk_state_statemodid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_state_statemodid]') AND parent_object_id = OBJECT_ID(N'[dbo].[state]'))
ALTER TABLE [dbo].[state]  WITH CHECK ADD  CONSTRAINT [fk_state_statemodid] FOREIGN KEY([state_model_id])
REFERENCES [dbo].[statemodel] ([state_model_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_state_statemodid]') AND parent_object_id = OBJECT_ID(N'[dbo].[state]'))
ALTER TABLE [dbo].[state] CHECK CONSTRAINT [fk_state_statemodid]
GO
/****** Object:  ForeignKey [fk_statemodprop_statemodid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_statemodprop_statemodid]') AND parent_object_id = OBJECT_ID(N'[dbo].[state_model_properties]'))
ALTER TABLE [dbo].[state_model_properties]  WITH CHECK ADD  CONSTRAINT [fk_statemodprop_statemodid] FOREIGN KEY([state_model_id])
REFERENCES [dbo].[statemodel] ([state_model_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_statemodprop_statemodid]') AND parent_object_id = OBJECT_ID(N'[dbo].[state_model_properties]'))
ALTER TABLE [dbo].[state_model_properties] CHECK CONSTRAINT [fk_statemodprop_statemodid]
GO
/****** Object:  ForeignKey [fk_statemodel_stateid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_statemodel_stateid]') AND parent_object_id = OBJECT_ID(N'[dbo].[statemodel]'))
ALTER TABLE [dbo].[statemodel]  WITH CHECK ADD  CONSTRAINT [fk_statemodel_stateid] FOREIGN KEY([state_id])
REFERENCES [dbo].[state] ([state_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_statemodel_stateid]') AND parent_object_id = OBJECT_ID(N'[dbo].[statemodel]'))
ALTER TABLE [dbo].[statemodel] CHECK CONSTRAINT [fk_statemodel_stateid]
GO
/****** Object:  ForeignKey [fk_statemodreg_alertrefid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_statemodreg_alertrefid]') AND parent_object_id = OBJECT_ID(N'[dbo].[statemodelregistration]'))
ALTER TABLE [dbo].[statemodelregistration]  WITH CHECK ADD  CONSTRAINT [fk_statemodreg_alertrefid] FOREIGN KEY([alert_reference_id])
REFERENCES [dbo].[alertreference] ([alert_reference_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_statemodreg_alertrefid]') AND parent_object_id = OBJECT_ID(N'[dbo].[statemodelregistration]'))
ALTER TABLE [dbo].[statemodelregistration] CHECK CONSTRAINT [fk_statemodreg_alertrefid]
GO
/****** Object:  ForeignKey [fk_statemodreg_personid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_statemodreg_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[statemodelregistration]'))
ALTER TABLE [dbo].[statemodelregistration]  WITH CHECK ADD  CONSTRAINT [fk_statemodreg_personid] FOREIGN KEY([person_id])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_statemodreg_personid]') AND parent_object_id = OBJECT_ID(N'[dbo].[statemodelregistration]'))
ALTER TABLE [dbo].[statemodelregistration] CHECK CONSTRAINT [fk_statemodreg_personid]
GO
/****** Object:  ForeignKey [fk_tenantemaildom_tenantid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_tenantemaildom_tenantid]') AND parent_object_id = OBJECT_ID(N'[dbo].[tenantemaildomain]'))
ALTER TABLE [dbo].[tenantemaildomain]  WITH CHECK ADD  CONSTRAINT [fk_tenantemaildom_tenantid] FOREIGN KEY([tenant_id])
REFERENCES [dbo].[tenant] ([tenant_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_tenantemaildom_tenantid]') AND parent_object_id = OBJECT_ID(N'[dbo].[tenantemaildomain]'))
ALTER TABLE [dbo].[tenantemaildomain] CHECK CONSTRAINT [fk_tenantemaildom_tenantid]
GO
/****** Object:  ForeignKey [fk_tenantnamespace_tenantid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_tenantnamespace_tenantid]') AND parent_object_id = OBJECT_ID(N'[dbo].[tenantnamespace]'))
ALTER TABLE [dbo].[tenantnamespace]  WITH CHECK ADD  CONSTRAINT [fk_tenantnamespace_tenantid] FOREIGN KEY([tenant_id])
REFERENCES [dbo].[tenant] ([tenant_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_tenantnamespace_tenantid]') AND parent_object_id = OBJECT_ID(N'[dbo].[tenantnamespace]'))
ALTER TABLE [dbo].[tenantnamespace] CHECK CONSTRAINT [fk_tenantnamespace_tenantid]
GO
/****** Object:  ForeignKey [fk_tenantshortcode_tenantid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_tenantshortcode_tenantid]') AND parent_object_id = OBJECT_ID(N'[dbo].[tenantshortcode]'))
ALTER TABLE [dbo].[tenantshortcode]  WITH CHECK ADD  CONSTRAINT [fk_tenantshortcode_tenantid] FOREIGN KEY([tenant_id])
REFERENCES [dbo].[tenant] ([tenant_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_tenantshortcode_tenantid]') AND parent_object_id = OBJECT_ID(N'[dbo].[tenantshortcode]'))
ALTER TABLE [dbo].[tenantshortcode] CHECK CONSTRAINT [fk_tenantshortcode_tenantid]
GO
/****** Object:  ForeignKey [fk_tenanturl_tenantid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_tenanturl_tenantid]') AND parent_object_id = OBJECT_ID(N'[dbo].[tenanturlpattern]'))
ALTER TABLE [dbo].[tenanturlpattern]  WITH CHECK ADD  CONSTRAINT [fk_tenanturl_tenantid] FOREIGN KEY([tenant_id])
REFERENCES [dbo].[tenant] ([tenant_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_tenanturl_tenantid]') AND parent_object_id = OBJECT_ID(N'[dbo].[tenanturlpattern]'))
ALTER TABLE [dbo].[tenanturlpattern] CHECK CONSTRAINT [fk_tenanturl_tenantid]
GO
/****** Object:  ForeignKey [FK_TERMSCONDITION_PER_ID]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TERMSCONDITION_PER_ID]') AND parent_object_id = OBJECT_ID(N'[dbo].[TERMSANDCONDITIONS]'))
ALTER TABLE [dbo].[TERMSANDCONDITIONS]  WITH CHECK ADD  CONSTRAINT [FK_TERMSCONDITION_PER_ID] FOREIGN KEY([PERSON_ID])
REFERENCES [dbo].[person] ([person_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TERMSCONDITION_PER_ID]') AND parent_object_id = OBJECT_ID(N'[dbo].[TERMSANDCONDITIONS]'))
ALTER TABLE [dbo].[TERMSANDCONDITIONS] CHECK CONSTRAINT [FK_TERMSCONDITION_PER_ID]
GO
/****** Object:  ForeignKey [fk_tgroup_groupid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_tgroup_groupid]') AND parent_object_id = OBJECT_ID(N'[dbo].[tgroup]'))
ALTER TABLE [dbo].[tgroup]  WITH CHECK ADD  CONSTRAINT [fk_tgroup_groupid] FOREIGN KEY([group_id])
REFERENCES [dbo].[principal] ([principal_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_tgroup_groupid]') AND parent_object_id = OBJECT_ID(N'[dbo].[tgroup]'))
ALTER TABLE [dbo].[tgroup] CHECK CONSTRAINT [fk_tgroup_groupid]
GO
/****** Object:  ForeignKey [fk_tgroup_parentgroupid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_tgroup_parentgroupid]') AND parent_object_id = OBJECT_ID(N'[dbo].[tgroup]'))
ALTER TABLE [dbo].[tgroup]  WITH CHECK ADD  CONSTRAINT [fk_tgroup_parentgroupid] FOREIGN KEY([parent_group_id])
REFERENCES [dbo].[tgroup] ([group_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_tgroup_parentgroupid]') AND parent_object_id = OBJECT_ID(N'[dbo].[tgroup]'))
ALTER TABLE [dbo].[tgroup] CHECK CONSTRAINT [fk_tgroup_parentgroupid]
GO
/****** Object:  ForeignKey [fk_transition_stateid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_transition_stateid]') AND parent_object_id = OBJECT_ID(N'[dbo].[transition]'))
ALTER TABLE [dbo].[transition]  WITH CHECK ADD  CONSTRAINT [fk_transition_stateid] FOREIGN KEY([state_id])
REFERENCES [dbo].[state] ([state_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_transition_stateid]') AND parent_object_id = OBJECT_ID(N'[dbo].[transition]'))
ALTER TABLE [dbo].[transition] CHECK CONSTRAINT [fk_transition_stateid]
GO
/****** Object:  ForeignKey [fk_transition_statemodid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_transition_statemodid]') AND parent_object_id = OBJECT_ID(N'[dbo].[transition]'))
ALTER TABLE [dbo].[transition]  WITH CHECK ADD  CONSTRAINT [fk_transition_statemodid] FOREIGN KEY([state_model_id])
REFERENCES [dbo].[statemodel] ([state_model_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_transition_statemodid]') AND parent_object_id = OBJECT_ID(N'[dbo].[transition]'))
ALTER TABLE [dbo].[transition] CHECK CONSTRAINT [fk_transition_statemodid]
GO
/****** Object:  ForeignKey [fk_transition_transitionlistid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_transition_transitionlistid]') AND parent_object_id = OBJECT_ID(N'[dbo].[transition]'))
ALTER TABLE [dbo].[transition]  WITH CHECK ADD  CONSTRAINT [fk_transition_transitionlistid] FOREIGN KEY([transition_list_id])
REFERENCES [dbo].[transitionlist] ([transition_list_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_transition_transitionlistid]') AND parent_object_id = OBJECT_ID(N'[dbo].[transition]'))
ALTER TABLE [dbo].[transition] CHECK CONSTRAINT [fk_transition_transitionlistid]
GO
/****** Object:  ForeignKey [fk_transactcont_transactid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_transactcont_transactid]') AND parent_object_id = OBJECT_ID(N'[dbo].[transitionactioncontext]'))
ALTER TABLE [dbo].[transitionactioncontext]  WITH CHECK ADD  CONSTRAINT [fk_transactcont_transactid] FOREIGN KEY([transition_action_id])
REFERENCES [dbo].[actioncontext] ([action_context_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_transactcont_transactid]') AND parent_object_id = OBJECT_ID(N'[dbo].[transitionactioncontext]'))
ALTER TABLE [dbo].[transitionactioncontext] CHECK CONSTRAINT [fk_transactcont_transactid]
GO
/****** Object:  ForeignKey [fk_transactcont_transid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_transactcont_transid]') AND parent_object_id = OBJECT_ID(N'[dbo].[transitionactioncontext]'))
ALTER TABLE [dbo].[transitionactioncontext]  WITH CHECK ADD  CONSTRAINT [fk_transactcont_transid] FOREIGN KEY([transition_id])
REFERENCES [dbo].[transition] ([transition_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_transactcont_transid]') AND parent_object_id = OBJECT_ID(N'[dbo].[transitionactioncontext]'))
ALTER TABLE [dbo].[transitionactioncontext] CHECK CONSTRAINT [fk_transactcont_transid]
GO
/****** Object:  ForeignKey [fk_transitionlist_stateid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_transitionlist_stateid]') AND parent_object_id = OBJECT_ID(N'[dbo].[transitionlist]'))
ALTER TABLE [dbo].[transitionlist]  WITH CHECK ADD  CONSTRAINT [fk_transitionlist_stateid] FOREIGN KEY([state_id])
REFERENCES [dbo].[state] ([state_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_transitionlist_stateid]') AND parent_object_id = OBJECT_ID(N'[dbo].[transitionlist]'))
ALTER TABLE [dbo].[transitionlist] CHECK CONSTRAINT [fk_transitionlist_stateid]
GO
/****** Object:  ForeignKey [fk_transitionlist_statemodid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_transitionlist_statemodid]') AND parent_object_id = OBJECT_ID(N'[dbo].[transitionlist]'))
ALTER TABLE [dbo].[transitionlist]  WITH CHECK ADD  CONSTRAINT [fk_transitionlist_statemodid] FOREIGN KEY([state_model_id])
REFERENCES [dbo].[statemodel] ([state_model_id])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_transitionlist_statemodid]') AND parent_object_id = OBJECT_ID(N'[dbo].[transitionlist]'))
ALTER TABLE [dbo].[transitionlist] CHECK CONSTRAINT [fk_transitionlist_statemodid]
GO
/****** Object:  ForeignKey [fk_userprefs_sessionid]    Script Date: 07/16/2012 17:33:41 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_userprefs_sessionid]') AND parent_object_id = OBJECT_ID(N'[dbo].[userprefs]'))
ALTER TABLE [dbo].[userprefs]  WITH CHECK ADD  CONSTRAINT [fk_userprefs_sessionid] FOREIGN KEY([sessionid])
REFERENCES [dbo].[wcsession] ([sessionid])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_userprefs_sessionid]') AND parent_object_id = OBJECT_ID(N'[dbo].[userprefs]'))
ALTER TABLE [dbo].[userprefs] CHECK CONSTRAINT [fk_userprefs_sessionid]
GO
----------------------------------------------------------------------------------------------------------------------------------------------------
-- Bof DBA-14_indexing.sql
-- This Patch Indexes the Product constraints
----------------------------------------------------------------------------------------------------------------------------------------------------
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[phonenumber]') AND name = N'pnumber_fk_idx')
	CREATE NONCLUSTERED INDEX [pnumber_fk_idx] on [dbo].[phonenumber] 
	(               
	[CARRIER_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
	GO	
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[authenticationtoken]') AND name = N'authtoken1_fk_idx')
	CREATE NONCLUSTERED INDEX [authtoken1_fk_idx] on [dbo].[authenticationtoken]  
	(
    [OPERATION_ID] ASC 
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
	GO	
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[authenticationtoken]') AND name = N'authtoken2_fk_idx')
	CREATE NONCLUSTERED INDEX [authtoken2_fk_idx] on [dbo].[authenticationtoken]     
	( 
    [PERSON_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
	GO	
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[featureusage]') AND name = N'fusage1_fk_idx')
	CREATE NONCLUSTERED INDEX [fusage1_fk_idx] on [dbo].[featureusage] 
	(               
	[WEEKLY_AMOUNT_USAGE_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
	GO	
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[featureusage]') AND name = N'fusage2_fk_idx')
	CREATE NONCLUSTERED INDEX [fusage2_fk_idx] on [dbo].[featureusage]  
	(            
    [DAILY_AMOUNT_USAGE_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
	GO	
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[featureusage]') AND name = N'fusage3_fk_idx')
	CREATE NONCLUSTERED INDEX [fusage3_fk_idx] on [dbo].[featureusage]  
	(            
    [WEEKLY_TRANS_USAGE_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
	GO	
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[featureusage]') AND name = N'fusage4_fk_idx')
	CREATE NONCLUSTERED INDEX [fusage4_fk_idx] on [dbo].[featureusage]   
	(           
    [PERSON_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
	GO	
	
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[property]') AND name = N'prop_fk_idx')
	CREATE NONCLUSTERED INDEX [prop_fk_idx] on [dbo].[property]        
	(          
    [PROPERTY_KEY_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
	GO
	
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[exitactioncontext]') AND name = N'extactctxt_fk_idx')
	CREATE NONCLUSTERED INDEX [extactctxt_fk_idx] on [dbo].[exitactioncontext]
	(     
    [STATE_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
	GO	
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[eventlogentry]') AND name = N'evntlety_fk_idx')
	CREATE NONCLUSTERED INDEX [evntlety_fk_idx] on [dbo].[eventlogentry]  
	(       
     [EVENTIMPORTANCEID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
	GO	
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[smppcarriercode]') AND name = N'smppccd1_fk_idx')
	CREATE NONCLUSTERED INDEX [smppccd1_fk_idx] on [dbo].[smppcarriercode]
	(           
     [CARRIER_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
	GO	
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[smppcarriercode]') AND name = N'smppccd2_fk_idx')
	CREATE NONCLUSTERED INDEX [smppccd2_fk_idx] on [dbo].[smppcarriercode]        
	(   
     [AGGREGATOR_ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
	GO
----------------------------------------------------------------------------------------------------------------------------------------------------
-- Eof DBA-14_indexing.sql
----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------
-- Bof SE-5616_indexing.sql
-- This Patch Indexes the Product enrolment and the terms and condition objects. If the indexes exist the create will be ignored.
----------------------------------------------------------------------------------------------------------------------------------------------------
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[productenrollment]') AND name = N'prodenrlmt_idx')
	CREATE NONCLUSTERED INDEX [prodenrlmt_idx] ON [dbo].[productenrollment] 
	(
	[person_id] ASC,
	[productkey] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
	GO
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[termsandconditions]') AND name = N'termscondition_unique')
	CREATE UNIQUE NONCLUSTERED INDEX [termscondition_unique] ON [dbo].[termsandconditions] 
	(
	[person_id] ASC,
	[versionname] ASC,
	[tcversion] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = OFF) ON [PRIMARY]
	GO
----------------------------------------------------------------------------------------------------------------------------------------------------
-- Eof SE-5616_indexing.sql
----------------------------------------------------------------------------------------------------------------------------------------------------

declare @scriptversionend nvarchar(30)

	set @scriptversionend='5.1.7'
		update 
			script_audit 
		set
		    lastupdated=current_timestamp, status='FINISHED'
		where
		    scriptname='CR_CLAIR_MSSQL.sql' 
		and scriptversion= @scriptversionend
		and createdate = (select max(createdate) from script_audit where scriptname='CR_CLAIR_MSSQL.sql' and scriptversion=@scriptversionend);

