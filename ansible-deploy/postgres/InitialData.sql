--------------------------------------------------------------------------------
-- Name    : InitialData.sql
-- Purpose : This script populates the initial data for ClairMail OLTP .
-- Statement to execute this script from the shell:
-- [postgres]$ psql -f InitialData.sql <OLTP Database Name> -U <OLTP Database User>
-- For Example:
-- [postgres]$ psql -f InitialData.sql oltpdb -U oltpuser
--------------------------------------------------------------------------------

create or replace function check_for_msginit_data() returns void as $$ 
declare 
	isExecuted integer;
	var_scriptversion varchar(30);
begin
	var_scriptversion='5.1.7';
    select count(*) into isExecuted from script_audit where scriptname='InitialData.sql' and scriptversion=var_scriptversion;
	if (isExecuted=1) then
		raise notice ' The InitialData.sql file is already executed once.Please contact your ClairMail System Administrator';
	else
		insert into script_audit
		select  current_timestamp as createdate,
			null as lastupdated,
			'InitialData.sql' as scriptname,
			var_scriptversion as scriptversion,
			user as osuser,
			current_user as currentuser,
			'hostname' as hostname,
			ip.* as ipaddress,
			issuperuser.* as dbauser,
			'OLTP Initial Data population script' as comments,
			'STARTED'
		from
			(select usesuper from pg_user where usename=current_user) as issuperuser,
			(select inet_client_addr()) as ip;

			insert into permission (permission_id, version, lastupdated, createdate, name) VALUES ('ff808081192f435601192f43a41a0001', 0, current_timestamp,current_timestamp, 'execute');

			insert into principal (principal_id, version, lastupdated, createdate) VALUES ('ff808081192f435601192f43a4640002', 0, current_timestamp,current_timestamp);
			insert into principal (principal_id, version, lastupdated, createdate) VALUES ('ff808081192f435601192f43a4740003', 0, current_timestamp,current_timestamp);
			insert into principal (principal_id, version, lastupdated, createdate) VALUES ('ff808081192f435601192f43a4b80005', 0, current_timestamp,current_timestamp);
			insert into principal (principal_id, version, lastupdated, createdate) VALUES ('ff808081192f435601192f43a4bf0006', 0, current_timestamp,current_timestamp);
			insert into principal (principal_id, version, lastupdated, createdate) VALUES ('ff808081192f435601192f43a4c30007', 0, current_timestamp,current_timestamp);
			insert into principal (principal_id, version, lastupdated, createdate) VALUES ('ff808081192f435601192f43a4c80008', 0, current_timestamp,current_timestamp);
			insert into principal (principal_id, version, lastupdated, createdate) VALUES ('ff808081192f435601192f43a4cc0009', 1, current_timestamp,current_timestamp);
			insert into principal (principal_id, version, lastupdated, createdate) VALUES ('ff808081192f435601192f43a4f7000b', 0, current_timestamp,current_timestamp);
			insert into principal (principal_id, version, lastupdated, createdate) VALUES ('ff808081192f435601192f43a526000c', 0, current_timestamp,current_timestamp);
			insert into principal (principal_id, version, lastupdated, createdate) VALUES ('ff808081192f435601192f43a53b000d', 0, current_timestamp,current_timestamp);
			insert into principal (principal_id, version, lastupdated, createdate) VALUES ('ff808081192f435601192f43a6d70036', 0, current_timestamp,current_timestamp);
			insert into principal (principal_id, version, lastupdated, createdate) VALUES ('ff808081192f435601192f43a6da0037', 0, current_timestamp,current_timestamp);
			insert into principal (principal_id, version, lastupdated, createdate) VALUES ('ff808081192f435601192f43a6de0038', 0, current_timestamp,current_timestamp);
			insert into principal (principal_id, version, lastupdated, createdate) VALUES ('ff808081192f435601192f43a6e10039', 0, current_timestamp,current_timestamp);
			insert into principal (principal_id, version, lastupdated, createdate) VALUES ('ff808081192f435601192f43a725003b', 0, current_timestamp,current_timestamp);
			insert into principal (principal_id, version, lastupdated, createdate) VALUES ('ff808081192f435601192f43a72f003d', 0, current_timestamp,current_timestamp);

			insert into cm_role (role_id, name, lastupdated, createdate) VALUES ('ff808081192f435601192f43a4640002', 'Administrator',  current_timestamp,current_timestamp);
			insert into cm_role (role_id, name, lastupdated, createdate) VALUES ('ff808081192f435601192f43a4bf0006', 'RegisteredUser', current_timestamp,current_timestamp);
			insert into cm_role (role_id, name, lastupdated, createdate) VALUES ('ff808081192f435601192f43a4c80008', 'AnonymousUser',  current_timestamp,current_timestamp);
			insert into cm_role (role_id, name, lastupdated, createdate) VALUES ('ff808081192f435601192f43a526000c', 'ReportManager',  current_timestamp,current_timestamp);
			insert into cm_role (role_id, name, lastupdated, createdate) VALUES ('ff808081192f435601192f43a6d70036', 'WebServiceUser', current_timestamp,current_timestamp);
			insert into cm_role (role_id, name, lastupdated, createdate) VALUES ('ff808081192f435601192f43a6de0038', 'CSRUserRole',  current_timestamp,current_timestamp);

			insert into tgroup (group_id, name, parent_group_id, lastupdated, createdate) VALUES ('ff808081192f435601192f43a4740003', 'Administrators', NULL,  current_timestamp,current_timestamp);
			insert into tgroup (group_id, name, parent_group_id, lastupdated, createdate) VALUES ('ff808081192f435601192f43a4c30007', 'RegisteredUsers', NULL, current_timestamp,current_timestamp);
			insert into tgroup (group_id, name, parent_group_id, lastupdated, createdate) VALUES ('ff808081192f435601192f43a4cc0009', 'AnonymousUsers', NULL,  current_timestamp,current_timestamp);
			insert into tgroup (group_id, name, parent_group_id, lastupdated, createdate) VALUES ('ff808081192f435601192f43a53b000d', 'ReportManagers', NULL,  current_timestamp,current_timestamp);
			insert into tgroup (group_id, name, parent_group_id, lastupdated, createdate) VALUES ('ff808081192f435601192f43a6da0037', 'WebServiceUsers', NULL, current_timestamp,current_timestamp);
			insert into tgroup (group_id, name, parent_group_id, lastupdated, createdate) VALUES ('ff808081192f435601192f43a6e10039', 'CSRUsers', NULL,  current_timestamp,current_timestamp);

			insert into group_role (group_id, role_id) VALUES ('ff808081192f435601192f43a4740003', 'ff808081192f435601192f43a4640002');
			insert into group_role (group_id, role_id) VALUES ('ff808081192f435601192f43a4c30007', 'ff808081192f435601192f43a4bf0006');
			insert into group_role (group_id, role_id) VALUES ('ff808081192f435601192f43a4cc0009', 'ff808081192f435601192f43a4c80008');
			insert into group_role (group_id, role_id) VALUES ('ff808081192f435601192f43a53b000d', 'ff808081192f435601192f43a526000c');
			insert into group_role (group_id, role_id) VALUES ('ff808081192f435601192f43a6da0037', 'ff808081192f435601192f43a6d70036');
			insert into group_role (group_id, role_id) VALUES ('ff808081192f435601192f43a6e10039', 'ff808081192f435601192f43a6de0038');

			insert into person (person_id, version, lastupdated, createdate, tenant_id, givenname, middlename, familyname, dob, gender, preferredlocale, timezone, username, extusername, user_password_digest) VALUES ('ff808081192f435601192f43a47b0004', 0, current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'System', NULL, 'Administrator',current_timestamp, NULL, 'en_US', 'America/Los_Angeles', 'admin', NULL, '689806F595A5EF1A3C48E718831C18D556353E93ABF7D403FBD83072EDF38779|58720911');
			insert into person (person_id, version, lastupdated, createdate, tenant_id, givenname, middlename, familyname, dob, gender, preferredlocale, timezone, username, extusername, user_password_digest) VALUES ('ff808081192f435601192f43a4ee000a', 0, current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'Anonymous', NULL, 'User',current_timestamp, NULL, NULL, 'America/Los_Angeles', 'anonymous', NULL, '5EDAD4D5C58AE5777CA67CB83BD3C8B7EC8983A16EA2D25ACC460B371EA3A703|153646037');
			insert into person (person_id, version, lastupdated, createdate, tenant_id, givenname, middlename, familyname, dob, gender, preferredlocale, timezone, username, extusername, user_password_digest) VALUES ('ff808081192f435601192f43a6e5003a', 0, current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'BOT_WS_USER', NULL, 'BOT_WS_USER',current_timestamp, NULL, 'en_US', 'America/Los_Angeles', 'BOT_WS_USER', NULL, '82E7C56ABC89BCF5BA7063242473A5C6A9F6002E6351CC406FC6CD0CF1F2A130|813972250');
			insert into person (person_id, version, lastupdated, createdate, tenant_id, givenname, middlename, familyname, dob, gender, preferredlocale, timezone, username, extusername, user_password_digest) VALUES ('ff808081192f435601192f43a72b003c', 0, current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'Test_WS_USER', NULL, 'Test_WS_USER',current_timestamp, NULL, 'en_US', 'America/Los_Angeles', 'Test_WS_USER', NULL, '52BD214368D1082F241ADE0CC4C0E05C979B82667ADC2A44360FC2679C250C8D|424852823');

			insert into personprincipal (person_principal_id, person_id, lastupdated, createdate) VALUES ('ff808081192f435601192f43a4b80005', 'ff808081192f435601192f43a47b0004', current_timestamp,current_timestamp);
			insert into personprincipal (person_principal_id, person_id, lastupdated, createdate) VALUES ('ff808081192f435601192f43a4f7000b', 'ff808081192f435601192f43a4ee000a', current_timestamp,current_timestamp);
			insert into personprincipal (person_principal_id, person_id, lastupdated, createdate) VALUES ('ff808081192f435601192f43a725003b', 'ff808081192f435601192f43a6e5003a', current_timestamp,current_timestamp);
			insert into personprincipal (person_principal_id, person_id, lastupdated, createdate) VALUES ('ff808081192f435601192f43a72f003d', 'ff808081192f435601192f43a72b003c', current_timestamp,current_timestamp);

			insert into person_group (person_principal_id, group_id) VALUES ('ff808081192f435601192f43a4b80005', 'ff808081192f435601192f43a4740003');
			insert into person_group (person_principal_id, group_id) VALUES ('ff808081192f435601192f43a4f7000b', 'ff808081192f435601192f43a4cc0009');
			insert into person_group (person_principal_id, group_id) VALUES ('ff808081192f435601192f43a725003b', 'ff808081192f435601192f43a6da0037');
			insert into person_group (person_principal_id, group_id) VALUES ('ff808081192f435601192f43a72f003d', 'ff808081192f435601192f43a6da0037');

			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a7a00043', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a7a90044', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a7b10045', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a7b80046', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a7c00047', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a7c90048', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a7d10049', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a7da004a', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a7e3004b', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a7ec004c', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a7f5004d', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a801004e', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a80b004f', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a8140050', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a81d0051', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a8270052', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a8310053', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			-- Removed the report entry as its no longer used. we are using reportView instead
			--insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a83b0054', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a86d0057', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a89f005a', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a8a9005b', 1, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a8b7005c', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a8c2005d', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a8cd005e', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a8d8005f', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a8e40060', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a8ef0061', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4c30007');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a93c0065', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4cc0009');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a9750068', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4c30007');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('ff808081192f435601192f43a997006a', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('50191e0f70aabd6ee040007f01001cfd', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('50191e0f70abbd6ee040007f01001cfd', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('4028820b1e3d173b011e3d17b1290060', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');
			insert into cm_name (cm_name_id, version, lastupdated, createdate, owner_id) VALUES ('4028820b1e3d173b011e3d17b1290061', 0, current_timestamp,current_timestamp, 'ff808081192f435601192f43a4740003');

			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a7a00043', 'auditLog', 'com.clairmail.service.authorization', 'Audit log screen',current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a7a90044', 'auditLogDetail', 'com.clairmail.service.authorization', 'Audit log detail screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a7b10045', 'messageLog', 'com.clairmail.service.authorization', 'Message log screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a7b80046', 'messageLogDetail', 'com.clairmail.service.authorization', 'Message log detail screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a7c00047', 'personList', 'com.clairmail.service.authorization', 'Person list screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a7c90048', 'addPersonForm', 'com.clairmail.service.authorization', 'New person registration', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a7d10049', 'editPersonForm', 'com.clairmail.service.authorization', 'Edit persons information', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a7da004a', 'bacList', 'com.clairmail.service.authorization', 'BAC list screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a7e3004b', 'editBacForm', 'com.clairmail.service.authorization', 'Edit BAC property screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a7ec004c', 'groupList', 'com.clairmail.service.authorization', 'Group list screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a7f5004d', 'newGroupForm', 'com.clairmail.service.authorization', 'Create new group screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a801004e', 'sysConfigForm', 'com.clairmail.service.authorization', 'Edit systems configuration', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a80b004f', 'editPersonRoles', 'com.clairmail.service.authorization', 'Manage roles for person', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a8140050', 'editPersonGroups', 'com.clairmail.service.authorization', 'Manage groups for person', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a81d0051', 'userPickerBrowser', 'com.clairmail.service.authorization', 'Browse users', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a8270052', 'dashboard', 'com.clairmail.service.authorization', 'Node list', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a8310053', 'dashboardStatistics', 'com.clairmail.service.authorization', 'Node list statistics', current_timestamp,current_timestamp);
			-- Removed the report entry as its no longer used. we are using reportView instead
			--insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a83b0054', 'report', 'com.clairmail.service.authorization', 'Report list', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a86d0057', 'reportView', 'com.clairmail.service.authorization', 'View Generated Report', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('4028820b1e3d173b011e3d17b1290060', 'batchProcess', 'com.clairmail.service.authorization', 'Batch Process Screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('4028820b1e3d173b011e3d17b1290061', 'atm', 'com.clairmail.service.authorization', 'ATM Location Services', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a89f005a', 'manageSMSConnector', 'com.clairmail.service.authorization', 'SMS Connector Screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a8a9005b', 'manageEmailConnector', 'com.clairmail.service.authorization', 'Email Connector Screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a8b7005c', 'monitoringDatabase', 'com.clairmail.service.authorization', 'Monitoring of Database State', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a8c2005d', 'manageAlertService', 'com.clairmail.service.authorization', 'Alert Service Screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a8cd005e', 'manageCommandDispatcher', 'com.clairmail.service.authorization', 'Command Dispatcher Screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a8d8005f', 'servicesStatus', 'com.clairmail.service.authorization', 'Services Status Screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a8e40060', 'eventLog', 'com.clairmail.service.authorization', 'Event log screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a8ef0061', 'editProfileForm', 'com.clairmail.service.authorization', 'Edit profile screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a93c0065', 'userLoginForm', 'com.clairmail.service.authorization', 'Login screen', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a9750068', 'registrationForm', 'com.clairmail.service.authorization', 'New User Registration', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('ff808081192f435601192f43a997006a', 'CSRApp', 'com.clairmail.service.authorization', 'CSR Console Application', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('50191e0f70aabd6ee040007f01001cfd', 'billingReport', 'com.clairmail.service.authorization', 'Billing Report List', current_timestamp,current_timestamp);
			insert into named_resource (named_resource_id, localpart, namespaceuri, description, lastupdated, createdate) VALUES ('50191e0f70abbd6ee040007f01001cfd', 'billingReportView', 'com.clairmail.service.authorization', 'View Generated Billing Report', current_timestamp,current_timestamp);

			--08/27/2008-CMJS-2171
			--insert into aclentry (acl_entry_id, version, lastupdated, createdate, inheritable, ispositive, permission_id, principal_id, cm_name_id) VALUES ('ff808081192f435601192f43a8500055', 0, current_timestamp,current_timestamp, true, true, 'ff808081192f435601192f43a41a0001', 'ff808081192f435601192f43a6e10039', 'ff808081192f435601192f43a83b0054');
			-- Removed the links CSRUsers to report
			--insert into aclentry (acl_entry_id, version, lastupdated, createdate, inheritable, ispositive, permission_id, principal_id, cm_name_id) VALUES ('ff808081192f435601192f43a8630056', 0, current_timestamp,current_timestamp, true, true, 'ff808081192f435601192f43a41a0001', 'ff808081192f435601192f43a53b000d', 'ff808081192f435601192f43a83b0054');
			-- Removed the links CSRUsers to reportView
			--insert into aclentry (acl_entry_id, version, lastupdated, createdate, inheritable, ispositive, permission_id, principal_id, cm_name_id) VALUES ('ff808081192f435601192f43a8810058', 0, current_timestamp,current_timestamp, true, true, 'ff808081192f435601192f43a41a0001', 'ff808081192f435601192f43a6e10039', 'ff808081192f435601192f43a86d0057');
			insert into aclentry (acl_entry_id, version, lastupdated, createdate, inheritable, ispositive, permission_id, principal_id, cm_name_id) VALUES ('ff808081192f435601192f43a8940059', 0, current_timestamp,current_timestamp, true, true, 'ff808081192f435601192f43a41a0001', 'ff808081192f435601192f43a53b000d', 'ff808081192f435601192f43a86d0057');
			insert into aclentry (acl_entry_id, version, lastupdated, createdate, inheritable, ispositive, permission_id, principal_id, cm_name_id) VALUES ('ff808081192f435601192f43a9050062', 0, current_timestamp,current_timestamp, true, true, 'ff808081192f435601192f43a41a0001', 'ff808081192f435601192f43a4740003', 'ff808081192f435601192f43a8ef0061');

			-- Removed CSR access to edit profile in Management Console 
			--insert into aclentry (acl_entry_id, version, lastupdated, createdate, inheritable, ispositive, permission_id, principal_id, cm_name_id) VALUES ('ff808081192f435601192f43a91a0063', 0, current_timestamp,current_timestamp, true, true, 'ff808081192f435601192f43a41a0001', 'ff808081192f435601192f43a6e10039', 'ff808081192f435601192f43a8ef0061');

			-- Removed Report Manager access to edit profile in Management Console
			--insert into aclentry (acl_entry_id, version, lastupdated, createdate, inheritable, ispositive, permission_id, principal_id, cm_name_id) VALUES ('ff808081192f435601192f43a9300064', 0, current_timestamp,current_timestamp, true, true, 'ff808081192f435601192f43a41a0001', 'ff808081192f435601192f43a53b000d', 'ff808081192f435601192f43a8ef0061');
			insert into aclentry (acl_entry_id, version, lastupdated, createdate, inheritable, ispositive, permission_id, principal_id, cm_name_id) VALUES ('ff808081192f435601192f43a9530066', 0, current_timestamp,current_timestamp, true, true, 'ff808081192f435601192f43a41a0001', 'ff808081192f435601192f43a4740003', 'ff808081192f435601192f43a93c0065');
			insert into aclentry (acl_entry_id, version, lastupdated, createdate, inheritable, ispositive, permission_id, principal_id, cm_name_id) VALUES ('ff808081192f435601192f43a96a0067', 0, current_timestamp,current_timestamp, true, true, 'ff808081192f435601192f43a41a0001', 'ff808081192f435601192f43a4c30007', 'ff808081192f435601192f43a93c0065');
			insert into aclentry (acl_entry_id, version, lastupdated, createdate, inheritable, ispositive, permission_id, principal_id, cm_name_id) VALUES ('ff808081192f435601192f43a98c0069', 0, current_timestamp,current_timestamp, true, true, 'ff808081192f435601192f43a41a0001', 'ff808081192f435601192f43a4740003', 'ff808081192f435601192f43a9750068');
			insert into aclentry (acl_entry_id, version, lastupdated, createdate, inheritable, ispositive, permission_id, principal_id, cm_name_id) VALUES ('ff808081192f435601192f43a9ae006b', 0, current_timestamp,current_timestamp, true, true, 'ff808081192f435601192f43a41a0001', 'ff808081192f435601192f43a6e10039', 'ff808081192f435601192f43a997006a');
			insert into aclentry (acl_entry_id, version, lastupdated, createdate, inheritable, ispositive, permission_id, principal_id, cm_name_id) VALUES ('50191e0f70acbd6ee040007f01001cfd', 0, current_timestamp,current_timestamp, true, true, 'ff808081192f435601192f43a41a0001', 'ff808081192f435601192f43a6e10039', '50191e0f70aabd6ee040007f01001cfd');
			insert into aclentry (acl_entry_id, version, lastupdated, createdate, inheritable, ispositive, permission_id, principal_id, cm_name_id) VALUES ('50191e0f70adbd6ee040007f01001cfd', 0, current_timestamp,current_timestamp, true, true, 'ff808081192f435601192f43a41a0001', 'ff808081192f435601192f43a53b000d', '50191e0f70aabd6ee040007f01001cfd');
			insert into aclentry (acl_entry_id, version, lastupdated, createdate, inheritable, ispositive, permission_id, principal_id, cm_name_id) VALUES ('50191e0f70aebd6ee040007f01001cfd', 0, current_timestamp,current_timestamp, true, true, 'ff808081192f435601192f43a41a0001', 'ff808081192f435601192f43a6e10039', '50191e0f70abbd6ee040007f01001cfd');
			insert into aclentry (acl_entry_id, version, lastupdated, createdate, inheritable, ispositive, permission_id, principal_id, cm_name_id) VALUES ('50191e0f70afbd6ee040007f01001cfd', 0, current_timestamp,current_timestamp, true, true, 'ff808081192f435601192f43a41a0001', 'ff808081192f435601192f43a53b000d', '50191e0f70abbd6ee040007f01001cfd');

			insert into eventimportance (event_importance_id, version, lastupdated, createdate, importance) VALUES ('ff808081192f435601192f43a737003e', 0, current_timestamp,current_timestamp, 'CRITICAL');
			insert into eventimportance (event_importance_id, version, lastupdated, createdate, importance) VALUES ('ff808081192f435601192f43a738003f', 0, current_timestamp,current_timestamp, 'MAJOR');
			insert into eventimportance (event_importance_id, version, lastupdated, createdate, importance) VALUES ('ff808081192f435601192f43a7390040', 0, current_timestamp,current_timestamp, 'IMPORTANT');
			insert into eventimportance (event_importance_id, version, lastupdated, createdate, importance) VALUES ('ff808081192f435601192f43a73a0041', 0, current_timestamp,current_timestamp, 'NORMAL');
			insert into eventimportance (event_importance_id, version, lastupdated, createdate, importance) VALUES ('ff808081192f435601192f43a73a0042', 0, current_timestamp,current_timestamp, 'MINOR');

			insert into tenant  (tenant_id, version, lastupdated, createdate, tenantkey, tenantname) VALUES ('402882311c77845f011c7784b3b30002', 0, current_timestamp,current_timestamp, 'default', 'Default Tenant');

			insert into person_history (id,entityid,entityversion,eventtimestamp,eventtype,eventpersonid,tenant_id,givenname,middlename,familyname,dob,gender,preferredlocale,timezone,username,extusername,user_password_digest) values (nextval('person_history_seq'),'ff808081192f435601192f43a4ee000a',0,current_timestamp,'created','system','402882311c77845f011c7784b3b30002','Anonymous',null,'User',current_timestamp,null,'en_US','America/Los_Angeles', 'anonymous',null, '5EDAD4D5C58AE5777CA67CB83BD3C8B7EC8983A16EA2D25ACC460B371EA3A703|153646037');

			insert into tenantemaildomain (company_emaildomain_id, version, lastupdated, createdate, defaultforsending, domainname, tenant_id, listindex) values ('4028824821c6f06f0121c6f0ce030003', 0, current_timestamp, current_timestamp, true, 'claircorp.com', '402882311c77845f011c7784b3b30002', 0);

            insert into semaphore values(1, 'PENDING_EVENT');
				  
				  

			-- INSERTING ENROLLMENT_WS_USER
			Insert into PRINCIPAL (PRINCIPAL_ID, VERSION, LASTUPDATED, CREATEDATE) VALUES ('000000003b447ae9013b447b58fa0064', 0, current_timestamp, current_timestamp);
			Insert into PERSON (PERSON_ID, VERSION, LASTUPDATED, CREATEDATE, TENANT_ID, GIVENNAME, MIDDLENAME, FAMILYNAME, DOB, GENDER, PREFERREDLOCALE, TIMEZONE, USERNAME, EXTUSERNAME, USER_PASSWORD_DIGEST) VALUES ('000000003b447ae9013b447b58eb0063', 0, current_timestamp, current_timestamp, '402882311c77845f011c7784b3b30002', 'ENROLLMENT_WS_USER', NULL, 'ENROLLMENT_WS_USER', current_timestamp, NULL, NULL, 'US/Pacific', 'ENROLLMENT_WS_USER', NULL, '51C709FC3FCB2968AC22B578E900ADAA9DB620C87031BE137F3BEC9CC857157A|787258983');
			Insert into PERSONPRINCIPAL (PERSON_PRINCIPAL_ID,PERSON_ID,LASTUPDATED,CREATEDATE) VALUES ('000000003b447ae9013b447b58fa0064', '000000003b447ae9013b447b58eb0063', current_timestamp, current_timestamp);
			Insert into PERSON_GROUP (PERSON_PRINCIPAL_ID, GROUP_ID) VALUES ('000000003b447ae9013b447b58fa0064', 'ff808081192f435601192f43a6da0037');
			Insert into PERSON_HISTORY (ID, ENTITYID, ENTITYVERSION, EVENTTIMESTAMP, EVENTTYPE, EVENTPERSONID, TENANT_ID, GIVENNAME, MIDDLENAME, FAMILYNAME, DOB, GENDER, PREFERREDLOCALE, TIMEZONE, USERNAME, EXTUSERNAME, USER_PASSWORD_DIGEST) VALUES (nextval('person_history_seq'), '000000003b447ae9013b447b58eb0063', NULL, current_timestamp, 'created', 'SystemToken', '402882311c77845f011c7784b3b30002', 'ENROLLMENT_WS_USER', NULL, 'ENROLLMENT_WS_USER', current_timestamp, NULL, NULL, 'US/Pacific', 'ENROLLMENT_WS_USER', NULL, '51C709FC3FCB2968AC22B578E900ADAA9DB620C87031BE137F3BEC9CC857157A|787258983');
			-- EOF ENROLLMENT_WS_USER

			insert into schema_version (schema_version_id, version, lastupdated, createdate, schemaversion) VALUES ('ff808081192f435601192f43a9d4006c', 0, current_timestamp,current_timestamp, var_scriptversion);

			update 
				script_audit 
			set
			    lastupdated=current_timestamp, status='FINISHED'
			where
			    scriptname='InitialData.sql' 
			and scriptversion= var_scriptversion 
			and createdate=greatest(createdate);
	end if;			
end ;

$$ language plpgsql;

select check_for_msginit_data();
drop function check_for_msginit_data();
