---------------------------------------------------------
-- Name:     InitialData.sql
-- Purpose : This script populates the OLTP initial data. 
-- Steps to execute the script from command line:
-- C:> sqlcmd -S IPAddress\InstanceName -d OLTPDataBaseName -U OLTPUser -P OLTPPassword -v oltpdb="OLTPDataBaseName" -i InitialData.sql
-- For Example
-- C:> sqlcmd -S PS4714\CLAIRMAILDB -d clairdb -U testoltpuser -P testoltppass -v oltpdb="clairdb" -i InitialData.sql
---------------------------------------------------

use $(oltpdb)
go

declare @isExecuted int
declare @scriptversion varchar(30)

begin
	set @scriptversion='5.1.7'
    select  @isExecuted=count(*) from script_audit where scriptname='InitialData.sql' and scriptversion=@scriptversion;
    if (@isExecuted=1)
	begin
		print 'The InitialData.sql file is already executed once.Please contact your ClairMail System Administrator'
	end
    else
	begin
		insert into script_audit
		select current_timestamp,
			null,
			'InitialData.sql',
			@scriptversion,
			system_user,
			current_user,
			hostname.*,
			null,
			is_srvrolemember ('sysadmin'),
			'OLTP Initial Data population script',
			'STARTED'
		from (select host_name from sys.dm_exec_sessions where status = 'running') as hostname;

		begin transaction

		-- INSERTING into PERMISSION
		Insert into PERMISSION (PERMISSION_ID,VERSION,LASTUPDATED,CREATEDATE,NAME) values ('ff808081191b889d01191b88ca0d0001',0,current_timestamp,current_timestamp,'execute');

		-- INSERTING into PRINCIPAL
		Insert into PRINCIPAL (PRINCIPAL_ID,VERSION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ca610002',0,current_timestamp,current_timestamp);
		Insert into PRINCIPAL (PRINCIPAL_ID,VERSION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ca750003',0,current_timestamp,current_timestamp);
		Insert into PRINCIPAL (PRINCIPAL_ID,VERSION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ca9d0005',0,current_timestamp,current_timestamp);
		Insert into PRINCIPAL (PRINCIPAL_ID,VERSION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88caaf0006',0,current_timestamp,current_timestamp);
		Insert into PRINCIPAL (PRINCIPAL_ID,VERSION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cab40007',0,current_timestamp,current_timestamp);
		Insert into PRINCIPAL (PRINCIPAL_ID,VERSION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88caba0008',0,current_timestamp,current_timestamp);
		Insert into PRINCIPAL (PRINCIPAL_ID,VERSION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cabf0009',0,current_timestamp,current_timestamp);
		Insert into PRINCIPAL (PRINCIPAL_ID,VERSION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cade000b',0,current_timestamp,current_timestamp);
		Insert into PRINCIPAL (PRINCIPAL_ID,VERSION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cb1a000c',1,current_timestamp,current_timestamp);
		Insert into PRINCIPAL (PRINCIPAL_ID,VERSION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cb27000d',1,current_timestamp,current_timestamp);
		Insert into PRINCIPAL (PRINCIPAL_ID,VERSION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cd2e0036',0,current_timestamp,current_timestamp);
		Insert into PRINCIPAL (PRINCIPAL_ID,VERSION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cd310037',0,current_timestamp,current_timestamp);
		Insert into PRINCIPAL (PRINCIPAL_ID,VERSION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cd350038',0,current_timestamp,current_timestamp);
		Insert into PRINCIPAL (PRINCIPAL_ID,VERSION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cd390039',0,current_timestamp,current_timestamp);
		Insert into PRINCIPAL (PRINCIPAL_ID,VERSION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cd41003b',0,current_timestamp,current_timestamp);
		Insert into PRINCIPAL (PRINCIPAL_ID,VERSION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cd4a003d',0,current_timestamp,current_timestamp);

		-- INSERTING into ROLE
		Insert into CM_ROLE (ROLE_ID,NAME,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ca610002','Administrator',current_timestamp,current_timestamp);
		Insert into CM_ROLE (ROLE_ID,NAME,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88caaf0006','RegisteredUser',current_timestamp,current_timestamp);
		Insert into CM_ROLE (ROLE_ID,NAME,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88caba0008','AnonymousUser',current_timestamp,current_timestamp);
		Insert into CM_ROLE (ROLE_ID,NAME,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cb1a000c','ReportManager',current_timestamp,current_timestamp);
		Insert into CM_ROLE (ROLE_ID,NAME,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cd2e0036','WebServiceUser',current_timestamp,current_timestamp);
		Insert into CM_ROLE (ROLE_ID,NAME,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cd350038','CSRUserRole',current_timestamp,current_timestamp);

		-- INSERTING into TGROUP
		Insert into TGROUP (GROUP_ID,NAME,PARENT_GROUP_ID,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ca750003','Administrators',null,current_timestamp,current_timestamp);
		Insert into TGROUP (GROUP_ID,NAME,PARENT_GROUP_ID,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cab40007','RegisteredUsers',null,current_timestamp,current_timestamp);
		Insert into TGROUP (GROUP_ID,NAME,PARENT_GROUP_ID,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cabf0009','AnonymousUsers',null,current_timestamp,current_timestamp);
		Insert into TGROUP (GROUP_ID,NAME,PARENT_GROUP_ID,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cb27000d','ReportManagers',null,current_timestamp,current_timestamp);
		Insert into TGROUP (GROUP_ID,NAME,PARENT_GROUP_ID,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cd310037','WebServiceUsers',null,current_timestamp,current_timestamp);
		Insert into TGROUP (GROUP_ID,NAME,PARENT_GROUP_ID,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cd390039','CSRUsers',null,current_timestamp,current_timestamp);

		-- INSERTING into GROUP_ROLE
		Insert into GROUP_ROLE (GROUP_ID,ROLE_ID) values ('ff808081191b889d01191b88ca750003','ff808081191b889d01191b88ca610002');
		Insert into GROUP_ROLE (GROUP_ID,ROLE_ID) values ('ff808081191b889d01191b88cab40007','ff808081191b889d01191b88caaf0006');
		Insert into GROUP_ROLE (GROUP_ID,ROLE_ID) values ('ff808081191b889d01191b88cabf0009','ff808081191b889d01191b88caba0008');
		Insert into GROUP_ROLE (GROUP_ID,ROLE_ID) values ('ff808081191b889d01191b88cb27000d','ff808081191b889d01191b88cb1a000c');
		Insert into GROUP_ROLE (GROUP_ID,ROLE_ID) values ('ff808081191b889d01191b88cd310037','ff808081191b889d01191b88cd2e0036');
		Insert into GROUP_ROLE (GROUP_ID,ROLE_ID) values ('ff808081191b889d01191b88cd390039','ff808081191b889d01191b88cd350038');

		-- INSERTING into PERSON
		Insert into PERSON (PERSON_ID,VERSION,LASTUPDATED,CREATEDATE,TENANT_ID,GIVENNAME,MIDDLENAME,FAMILYNAME,DOB,GENDER,PREFERREDLOCALE,TIMEZONE,USERNAME,EXTUSERNAME,USER_PASSWORD_DIGEST) values ('ff808081191b889d01191b88ca830004',0,current_timestamp,current_timestamp,'402882311c77845f011c7784b3b30002','System',null,'Administrator',current_timestamp,null,'en_US','America/Los_Angeles','admin','admin','107099DF9138E9D2CF701B0DD20614DE04493D4BA0C579AC3BCC6ACB64141745|347877198');
		Insert into PERSON (PERSON_ID,VERSION,LASTUPDATED,CREATEDATE,TENANT_ID,GIVENNAME,MIDDLENAME,FAMILYNAME,DOB,GENDER,PREFERREDLOCALE,TIMEZONE,USERNAME,EXTUSERNAME,USER_PASSWORD_DIGEST) values ('ff808081191b889d01191b88cac7000a',0,current_timestamp,current_timestamp,'402882311c77845f011c7784b3b30002','Anonymous',null,'User',current_timestamp,null,null,'America/Los_Angeles','anonymous','anonymous','B10DB070257F73AE61701429F7A44E7C3EDB5566CE5688699BF76943425BB03A|104855732');
		Insert into PERSON (PERSON_ID,VERSION,LASTUPDATED,CREATEDATE,TENANT_ID,GIVENNAME,MIDDLENAME,FAMILYNAME,DOB,GENDER,PREFERREDLOCALE,TIMEZONE,USERNAME,EXTUSERNAME,USER_PASSWORD_DIGEST) values ('ff808081191b889d01191b88cd3d003a',0,current_timestamp,current_timestamp,'402882311c77845f011c7784b3b30002','BOT_WS_USER',null,'BOT_WS_USER',current_timestamp,null,'en_US','America/Los_Angeles','BOT_WS_USER','BOT_WS_USER','FC936363A887C94634EFFBC21F5E13CF3160B37D4ED67FF37302ED4F6CD129E7|248934920');
		Insert into PERSON (PERSON_ID,VERSION,LASTUPDATED,CREATEDATE,TENANT_ID,GIVENNAME,MIDDLENAME,FAMILYNAME,DOB,GENDER,PREFERREDLOCALE,TIMEZONE,USERNAME,EXTUSERNAME,USER_PASSWORD_DIGEST) values ('ff808081191b889d01191b88cd46003c',0,current_timestamp,current_timestamp,'402882311c77845f011c7784b3b30002','Test_WS_USER',null,'Test_WS_USER',current_timestamp,null,'en_US','America/Los_Angeles','Test_WS_USER','Test_WS_USER','20A6142BE25ECD3AE30BC5E8FE291F169399288EA621A027D370D8EE5DB60319|210755750');

		-- INSERTING into PERSONPRINCIPAL
		Insert into PERSONPRINCIPAL (PERSON_PRINCIPAL_ID,PERSON_ID,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ca9d0005','ff808081191b889d01191b88ca830004',current_timestamp,current_timestamp);
		Insert into PERSONPRINCIPAL (PERSON_PRINCIPAL_ID,PERSON_ID,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cade000b','ff808081191b889d01191b88cac7000a',current_timestamp,current_timestamp);
		Insert into PERSONPRINCIPAL (PERSON_PRINCIPAL_ID,PERSON_ID,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cd41003b','ff808081191b889d01191b88cd3d003a',current_timestamp,current_timestamp);
		Insert into PERSONPRINCIPAL (PERSON_PRINCIPAL_ID,PERSON_ID,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cd4a003d','ff808081191b889d01191b88cd46003c',current_timestamp,current_timestamp);

		-- INSERTING into PERSON_GROUP
		Insert into PERSON_GROUP (PERSON_PRINCIPAL_ID,GROUP_ID) values ('ff808081191b889d01191b88ca9d0005','ff808081191b889d01191b88ca750003');
		Insert into PERSON_GROUP (PERSON_PRINCIPAL_ID,GROUP_ID) values ('ff808081191b889d01191b88cade000b','ff808081191b889d01191b88cabf0009');
		Insert into PERSON_GROUP (PERSON_PRINCIPAL_ID,GROUP_ID) values ('ff808081191b889d01191b88cd41003b','ff808081191b889d01191b88cd310037');
		Insert into PERSON_GROUP (PERSON_PRINCIPAL_ID,GROUP_ID) values ('ff808081191b889d01191b88cd4a003d','ff808081191b889d01191b88cd310037');

		-- INSERTING into CM_NAME
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88ce020043',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88ce190044',1,current_timestamp,current_timestamp ,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88ce520045',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88ce640046',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88ce6d0047',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88ce7a0048',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88ce9f0049',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88ceb2004a',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88ceb9004b',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88cec1004c',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88cec8004d',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88cecf004e',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88ced9004f',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88cee00050',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88ceec0051',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88cef50052',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88cefd0053',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		-- Removed the report entry as its no longer used. we are using reportView instead
		--Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88cf0b0054',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88cf490057',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88cf66005a',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88cf6e005b',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88cf7b005c',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88cf8e005d',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88cf96005e',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88cfa2005f',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88cfaa0060',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88cfb50061',1,current_timestamp,current_timestamp,'ff808081191b889d01191b88cab40007');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88d04a0065',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88cabf0009');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88d0800068',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88cab40007');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('ff808081191b889d01191b88d094006a',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('50191e0f70aabd6ee040007f01001cfd',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('50191e0f70abbd6ee040007f01001cfd',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('4028820b1e3d173b011e3d17b1290060',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');
		Insert into CM_NAME (CM_NAME_ID,VERSION,LASTUPDATED,CREATEDATE,OWNER_ID) values ('4028820b1e3d173b011e3d17b1290061',0,current_timestamp,current_timestamp,'ff808081191b889d01191b88ca750003');

		-- INSERTING into NAMED_RESOURCE
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ce020043','auditLog','com.clairmail.service.authorization','Audit log screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ce190044','auditLogDetail','com.clairmail.service.authorization','Audit log detail screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ce520045','messageLog','com.clairmail.service.authorization','Message log screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ce640046','messageLogDetail','com.clairmail.service.authorization','Message log detail screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ce6d0047','personList','com.clairmail.service.authorization','Person list screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ce7a0048','addPersonForm','com.clairmail.service.authorization','New person registration',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ce9f0049','editPersonForm','com.clairmail.service.authorization','Edit persons information',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ceb2004a','bacList','com.clairmail.service.authorization','BAC list screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ceb9004b','editBacForm','com.clairmail.service.authorization','Edit BAC property screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cec1004c','groupList','com.clairmail.service.authorization','Group list screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cec8004d','newGroupForm','com.clairmail.service.authorization','Create new group screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cecf004e','sysConfigForm','com.clairmail.service.authorization','Edit systems configuration',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ced9004f','editPersonRoles','com.clairmail.service.authorization','Manage roles for person',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cee00050','editPersonGroups','com.clairmail.service.authorization','Manage groups for person',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88ceec0051','userPickerBrowser','com.clairmail.service.authorization','Browse users',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cef50052','dashboard','com.clairmail.service.authorization','Node list',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cefd0053','dashboardStatistics','com.clairmail.service.authorization','Node list statistics',current_timestamp,current_timestamp);
		-- Removed the report entry as its no longer used. we are using reportView instead
		--Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cf0b0054','report','com.clairmail.service.authorization','Report list',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cf490057','reportView','com.clairmail.service.authorization','View Generated Report',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cf66005a','manageSMSConnector','com.clairmail.service.authorization','SMS Connector Screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cf6e005b','manageEmailConnector','com.clairmail.service.authorization','Email Connector Screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cf7b005c','monitoringDatabase','com.clairmail.service.authorization','Monitoring of Database State',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cf8e005d','manageAlertService','com.clairmail.service.authorization','Alert Service Screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cf96005e','manageCommandDispatcher','com.clairmail.service.authorization','Command Dispatcher Screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cfa2005f','servicesStatus','com.clairmail.service.authorization','Services Status Screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cfaa0060','eventLog','com.clairmail.service.authorization','Event log screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88cfb50061','editProfileForm','com.clairmail.service.authorization','Edit profile screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88d04a0065','userLoginForm','com.clairmail.service.authorization','Login screen',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88d0800068','registrationForm','com.clairmail.service.authorization','New User Registration',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('ff808081191b889d01191b88d094006a','CSRApp','com.clairmail.service.authorization','CSR Console Application',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('50191e0f70aabd6ee040007f01001cfd','billingReport','com.clairmail.service.authorization','Billing Report List',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('50191e0f70abbd6ee040007f01001cfd','billingReportView','com.clairmail.service.authorization','View Generated Billing Report',current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('4028820b1e3d173b011e3d17b1290060', 'batchProcess', 'com.clairmail.service.authorization', 'Batch Process Screen', current_timestamp,current_timestamp);
		Insert into NAMED_RESOURCE (NAMED_RESOURCE_ID,LOCALPART,NAMESPACEURI,DESCRIPTION,LASTUPDATED,CREATEDATE) values ('4028820b1e3d173b011e3d17b1290061', 'atm', 'com.clairmail.service.authorization', 'ATM Location Services', current_timestamp,current_timestamp);

		--08/27/2008-CMJS-2171
		--Insert into ACLENTRY (ACL_ENTRY_ID,VERSION,LASTUPDATED,CREATEDATE,INHERITABLE,ISPOSITIVE,PERMISSION_ID,PRINCIPAL_ID,CM_NAME_ID) values ('ff808081191b889d01191b88cf2b0055',0,current_timestamp,current_timestamp,1,1,'ff808081191b889d01191b88ca0d0001','ff808081191b889d01191b88cd390039','ff808081191b889d01191b88cf0b0054');

		-- Removed the links CSRUsers to report
		--Insert into ACLENTRY (ACL_ENTRY_ID,VERSION,LASTUPDATED,CREATEDATE,INHERITABLE,ISPOSITIVE,PERMISSION_ID,PRINCIPAL_ID,CM_NAME_ID) values ('ff808081191b889d01191b88cf430056',0,current_timestamp,current_timestamp,1,1,'ff808081191b889d01191b88ca0d0001','ff808081191b889d01191b88cb27000d','ff808081191b889d01191b88cf0b0054');

		-- Removed the links CSRUsers to reportView
		--Insert into ACLENTRY (ACL_ENTRY_ID,VERSION,LASTUPDATED,CREATEDATE,INHERITABLE,ISPOSITIVE,PERMISSION_ID,PRINCIPAL_ID,CM_NAME_ID) values ('ff808081191b889d01191b88cf540058',0,current_timestamp,current_timestamp,1,1,'ff808081191b889d01191b88ca0d0001','ff808081191b889d01191b88cd390039','ff808081191b889d01191b88cf490057');
		Insert into ACLENTRY (ACL_ENTRY_ID,VERSION,LASTUPDATED,CREATEDATE,INHERITABLE,ISPOSITIVE,PERMISSION_ID,PRINCIPAL_ID,CM_NAME_ID) values ('ff808081191b889d01191b88cf600059',0,current_timestamp,current_timestamp,1,1,'ff808081191b889d01191b88ca0d0001','ff808081191b889d01191b88cb27000d','ff808081191b889d01191b88cf490057');
		Insert into ACLENTRY (ACL_ENTRY_ID,VERSION,LASTUPDATED,CREATEDATE,INHERITABLE,ISPOSITIVE,PERMISSION_ID,PRINCIPAL_ID,CM_NAME_ID) values ('ff808081191b889d01191b88cfd10062',0,current_timestamp,current_timestamp,1,1,'ff808081191b889d01191b88ca0d0001','ff808081191b889d01191b88ca750003','ff808081191b889d01191b88cfb50061');
		
		-- Removed CSR access to edit profile in Management Console 
		--Insert into ACLENTRY (ACL_ENTRY_ID,VERSION,LASTUPDATED,CREATEDATE,INHERITABLE,ISPOSITIVE,PERMISSION_ID,PRINCIPAL_ID,CM_NAME_ID) values ('ff808081191b889d01191b88d0080063',0,current_timestamp,current_timestamp,1,1,'ff808081191b889d01191b88ca0d0001','ff808081191b889d01191b88cd390039','ff808081191b889d01191b88cfb50061');
 
 		-- Removed Report Manager access to edit profile in Management Console
 		--Insert into ACLENTRY (ACL_ENTRY_ID,VERSION,LASTUPDATED,CREATEDATE,INHERITABLE,ISPOSITIVE,PERMISSION_ID,PRINCIPAL_ID,CM_NAME_ID) values ('ff808081191b889d01191b88d0360064',0,current_timestamp,current_timestamp,1,1,'ff808081191b889d01191b88ca0d0001','ff808081191b889d01191b88cb27000d','ff808081191b889d01191b88cfb50061');
		Insert into ACLENTRY (ACL_ENTRY_ID,VERSION,LASTUPDATED,CREATEDATE,INHERITABLE,ISPOSITIVE,PERMISSION_ID,PRINCIPAL_ID,CM_NAME_ID) values ('ff808081191b889d01191b88d06a0066',0,current_timestamp,current_timestamp,1,1,'ff808081191b889d01191b88ca0d0001','ff808081191b889d01191b88ca750003','ff808081191b889d01191b88d04a0065');
		Insert into ACLENTRY (ACL_ENTRY_ID,VERSION,LASTUPDATED,CREATEDATE,INHERITABLE,ISPOSITIVE,PERMISSION_ID,PRINCIPAL_ID,CM_NAME_ID) values ('ff808081191b889d01191b88d07a0067',0,current_timestamp,current_timestamp,1,1,'ff808081191b889d01191b88ca0d0001','ff808081191b889d01191b88cab40007','ff808081191b889d01191b88d04a0065');
		Insert into ACLENTRY (ACL_ENTRY_ID,VERSION,LASTUPDATED,CREATEDATE,INHERITABLE,ISPOSITIVE,PERMISSION_ID,PRINCIPAL_ID,CM_NAME_ID) values ('ff808081191b889d01191b88d08e0069',0,current_timestamp,current_timestamp,1,1,'ff808081191b889d01191b88ca0d0001','ff808081191b889d01191b88ca750003','ff808081191b889d01191b88d0800068');
		Insert into ACLENTRY (ACL_ENTRY_ID,VERSION,LASTUPDATED,CREATEDATE,INHERITABLE,ISPOSITIVE,PERMISSION_ID,PRINCIPAL_ID,CM_NAME_ID) values ('ff808081191b889d01191b88d0b5006b',0,current_timestamp,current_timestamp,1,1,'ff808081191b889d01191b88ca0d0001','ff808081191b889d01191b88cd390039','ff808081191b889d01191b88d094006a');
		Insert into ACLENTRY (ACL_ENTRY_ID,VERSION,LASTUPDATED,CREATEDATE,INHERITABLE,ISPOSITIVE,PERMISSION_ID,PRINCIPAL_ID,CM_NAME_ID) values ('50191e0f70acbd6ee040007f01001cfd',0,current_timestamp,current_timestamp,1,1,'ff808081191b889d01191b88ca0d0001','ff808081191b889d01191b88cd390039','50191e0f70aabd6ee040007f01001cfd');
		Insert into ACLENTRY (ACL_ENTRY_ID,VERSION,LASTUPDATED,CREATEDATE,INHERITABLE,ISPOSITIVE,PERMISSION_ID,PRINCIPAL_ID,CM_NAME_ID) values ('50191e0f70adbd6ee040007f01001cfd',0,current_timestamp,current_timestamp,1,1,'ff808081191b889d01191b88ca0d0001','ff808081191b889d01191b88cb27000d','50191e0f70aabd6ee040007f01001cfd');
		Insert into ACLENTRY (ACL_ENTRY_ID,VERSION,LASTUPDATED,CREATEDATE,INHERITABLE,ISPOSITIVE,PERMISSION_ID,PRINCIPAL_ID,CM_NAME_ID) values ('50191e0f70aebd6ee040007f01001cfd',0,current_timestamp,current_timestamp,1,1,'ff808081191b889d01191b88ca0d0001','ff808081191b889d01191b88cd390039','50191e0f70abbd6ee040007f01001cfd');
		Insert into ACLENTRY (ACL_ENTRY_ID,VERSION,LASTUPDATED,CREATEDATE,INHERITABLE,ISPOSITIVE,PERMISSION_ID,PRINCIPAL_ID,CM_NAME_ID) values ('50191e0f70afbd6ee040007f01001cfd',0,current_timestamp,current_timestamp,1,1,'ff808081191b889d01191b88ca0d0001','ff808081191b889d01191b88cb27000d','50191e0f70abbd6ee040007f01001cfd');

		-- INSERTING into EVENTIMPORTANCE
		Insert into EVENTIMPORTANCE (EVENT_IMPORTANCE_ID,VERSION,LASTUPDATED,CREATEDATE,IMPORTANCE) values ('ff808081191b889d01191b88cd82003e',0,current_timestamp,current_timestamp,'CRITICAL');
		Insert into EVENTIMPORTANCE (EVENT_IMPORTANCE_ID,VERSION,LASTUPDATED,CREATEDATE,IMPORTANCE) values ('ff808081191b889d01191b88cd89003f',0,current_timestamp,current_timestamp,'MAJOR');
		Insert into EVENTIMPORTANCE (EVENT_IMPORTANCE_ID,VERSION,LASTUPDATED,CREATEDATE,IMPORTANCE) values ('ff808081191b889d01191b88cd8a0040',0,current_timestamp,current_timestamp,'IMPORTANT');
		Insert into EVENTIMPORTANCE (EVENT_IMPORTANCE_ID,VERSION,LASTUPDATED,CREATEDATE,IMPORTANCE) values ('ff808081191b889d01191b88cd8b0041',0,current_timestamp,current_timestamp,'NORMAL');
		Insert into EVENTIMPORTANCE (EVENT_IMPORTANCE_ID,VERSION,LASTUPDATED,CREATEDATE,IMPORTANCE) values ('ff808081191b889d01191b88cd8c0042',0,current_timestamp,current_timestamp,'MINOR');

		-- INSERTING into TENANT
		Insert into TENANT (TENANT_ID,VERSION,LASTUPDATED,CREATEDATE,TENANTKEY,TENANTNAME) values ('402882311c77845f011c7784b3b30002',0,current_timestamp,current_timestamp,'default','Default Tenant');

		insert into tenantemaildomain (company_emaildomain_id, version, lastupdated, createdate, defaultforsending, domainname, tenant_id, listindex) values ('4028824821c6f06f0121c6f0ce030003', 0, current_timestamp, current_timestamp, 1, 'claircorp.com', '402882311c77845f011c7784b3b30002', 0);


		-- SET IDENTITY_INSERT SEMAPHORE ON;
		Insert into SEMAPHORE(NAME) values( 'PENDING_EVENT');
		-- set IDENTITY_INSERT SEMAPHORE OFF;

		--Here are some key points about IDENTITY_INSERT

		--It can only be enabled on one table at a time.  
		--If you try to enable it on a second table while it is still enabled on a first table SQL Server will generate an error.
		--When it is enabled on a table you must specify a value for the identity column.
		--The user issuing the statement must own the object, be a system administrator (sysadmin role), 
		--be the database owner (dbo) or be a member of the db_ddladmin role in order to run the command.
		-- SET IDENTITY_INSERT person_history ON;
		Insert into PERSON_HISTORY (ENTITYID,ENTITYVERSION,EVENTTIMESTAMP,EVENTTYPE,EVENTPERSONID,tenant_id,GIVENNAME,MIDDLENAME,FAMILYNAME,DOB,GENDER,PREFERREDLOCALE,TIMEZONE,USERNAME,EXTUSERNAME,USER_PASSWORD_DIGEST) values ('ff808081191b889d01191b88cac7000a',0,current_timestamp,'created','system','402882311c77845f011c7784b3b30002','Anonymous',null,'User',current_timestamp,null,'en_US','America/Los_Angeles', 'anonymous','anonymous', 'B10DB070257F73AE61701429F7A44E7C3EDB5566CE5688699BF76943425BB03A|104855732');
		-- set IDENTITY_INSERT person_history OFF;
		
		-- INSERTING ENROLLMENT_WS_USER
		Insert into PRINCIPAL (PRINCIPAL_ID, VERSION, LASTUPDATED, CREATEDATE) VALUES ('000000003b447ae9013b447b58fa0064', 0, current_timestamp, current_timestamp);
		Insert into PERSON (PERSON_ID, VERSION, LASTUPDATED, CREATEDATE, TENANT_ID, GIVENNAME, MIDDLENAME, FAMILYNAME, DOB, GENDER, PREFERREDLOCALE, TIMEZONE, USERNAME, EXTUSERNAME, USER_PASSWORD_DIGEST) VALUES ('000000003b447ae9013b447b58eb0063', 0, current_timestamp, current_timestamp, '402882311c77845f011c7784b3b30002', 'ENROLLMENT_WS_USER', NULL, 'ENROLLMENT_WS_USER', current_timestamp, NULL, NULL, 'US/Pacific', 'ENROLLMENT_WS_USER', NULL, '51C709FC3FCB2968AC22B578E900ADAA9DB620C87031BE137F3BEC9CC857157A|787258983');
		-- cm_role    (pre-existing)
		-- tgroup     (pre-existing)
		-- group_role (pre-existing) 
		Insert into PERSONPRINCIPAL (PERSON_PRINCIPAL_ID,PERSON_ID,LASTUPDATED,CREATEDATE) VALUES ('000000003b447ae9013b447b58fa0064', '000000003b447ae9013b447b58eb0063', current_timestamp, current_timestamp);
		Insert into PERSON_GROUP (PERSON_PRINCIPAL_ID, GROUP_ID) VALUES ('000000003b447ae9013b447b58fa0064', 'ff808081191b889d01191b88cd310037');
		Insert into PERSON_HISTORY (ENTITYID, ENTITYVERSION, EVENTTIMESTAMP, EVENTTYPE, EVENTPERSONID, TENANT_ID, GIVENNAME, MIDDLENAME, FAMILYNAME, DOB, GENDER, PREFERREDLOCALE, TIMEZONE, USERNAME, EXTUSERNAME, USER_PASSWORD_DIGEST) VALUES ('000000003b447ae9013b447b58eb0063', NULL, current_timestamp, 'created', 'SystemToken', '402882311c77845f011c7784b3b30002', 'ENROLLMENT_WS_USER', NULL, 'ENROLLMENT_WS_USER', current_timestamp, NULL, NULL, 'US/Pacific', 'ENROLLMENT_WS_USER', NULL, '51C709FC3FCB2968AC22B578E900ADAA9DB620C87031BE137F3BEC9CC857157A|787258983');
		-- EOF ENROLLMENT_WS_USER
	
		-- INSERTING into SCHEMA_VERSION
		Insert into SCHEMA_VERSION (SCHEMA_VERSION_ID,VERSION,LASTUPDATED,CREATEDATE,SCHEMAVERSION) values ('ff808081191b889d01191b88d0c3006c',0,current_timestamp,current_timestamp,'5.1.7');
		commit;

		--Update Script Audit table information
		update 
			script_audit 
		set
		    lastupdated=current_timestamp, status='FINISHED'
		where
		    scriptname='InitialData.sql' 
		and scriptversion= @scriptversion 
		and createdate = (select max(createdate) from script_audit where scriptname='InitialData.sql' and scriptversion=@scriptversion);
	end
end
Go