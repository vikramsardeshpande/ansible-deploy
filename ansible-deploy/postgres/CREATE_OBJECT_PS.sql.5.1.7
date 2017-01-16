--------------------------------------------------------
-- Name    : CREATE_OBJECT_PS.sql
-- Purpose : This script install ClairMail OLTP schema .
-- Statement to execute this script from the shell:
-- [postgres]$ psql -f CREATE_OBJECT_PS.sql -d <OLTP Database Name> -U <OLTP Database User>
-- For Example:
-- [postgres]$ psql -f CREATE_OBJECT_PS.sql -d oltpdb -U oltpuser

--------------------------------------------------------
create or replace function checkforobjects_existence() returns void as $$
declare 
	isTableExists integer;
	a_output varchar(30000);
	var_scriptversion varchar(30);
begin
	var_scriptversion='5.1.7';
	select count(*) into isTableExists from pg_tables where tablename = 'script_audit';
	if (isTableExists=1) then
		raise notice ' The CREATE_OBJECT_PS.sql file is already executed once.Please contact your ClairMail System Administrator';
	else
		create table script_audit (createdate timestamp without time zone not null,lastupdated timestamp without time zone,scriptname varchar(255) not null,scriptversion varchar(255) not null,osuser varchar(128) not null,currentuser varchar(128) not null,hostname varchar(128) not null,ipaddress inet,dbauser boolean not null,comments varchar(256) not null,status varchar(10) not null);

		insert into script_audit
		select  current_timestamp as createdate,
			null as lastupdated,
			'CREATE_OBJECT_PS.sql' as scriptname,
			var_scriptversion as scriptversion,
			user as osuser,
			current_user as currentuser,
			'hostname' as hostname,
			ip.* as ipaddress,
			issuperuser.* as dbauser,
			'OLTP schema creation script' as comments,
			'STARTED'
		from
			(select usesuper from pg_user where usename=current_user) as issuperuser,
			(select inet_client_addr()) as ip;

		create table aclentry (acl_entry_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, inheritable bool not null, ispositive bool not null, permission_id char(32) not null, principal_id char(32) not null, cm_name_id char(32) not null, constraint pk_aclentry_aclentryid primary key (acl_entry_id),constraint uk_aclentry_pmidpridcmid unique (permission_id, principal_id, cm_name_id));
		
		create table address (address_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, tenant_id char(32) not null, address1 varchar(255) not null, address2 varchar(255), address3 varchar(255), postalcode varchar(255) not null, state varchar(255) not null, country varchar(255) not null, person_id char(32), listindex int4, constraint pk_addr_addrid primary key (address_id));
		create table alertinstance (alert_instance_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, tenant_id char(32) not null, alert_type_id char(32), alert_reference_id char(32), source_addr_id char(32), fromaddressuri varchar(255), toaddressuri varchar(255), subject varchar(255), messagedata bytea, status varchar(255), correlationid char(36), protocol varchar(255), constraint pk_alertins_alinstid primary key (alert_instance_id));
		create table alertinstancedelayqueue (instance_delay_queue_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, ownernode varchar(255), alert_instance_id char(32), alert_registration_id char(32), constraint pk_alinstdelque_alinstdelqueid primary key (instance_delay_queue_id));
		create table alertinstancequeue (instance_queue_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, ownernode varchar(255), alert_instance_id char(32), constraint pk_alinstque_instqueid primary key (instance_queue_id));
		create table alertreference (alert_reference_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, tenant_id char(32) not null, externalid varchar(255), alert_reference_type_id char(32), constraint pk_alref_alrefid primary key (alert_reference_id), constraint uk_alref_exidalreftypid unique (externalid, alert_reference_type_id));
		create table alertreferencetype (alert_reference_type_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, tenant_id char(32) not null, description varchar(1000) not null , constraint pk_alreftyp_alreftypid primary key (alert_reference_type_id), constraint uk_alreftyp_desc unique (description));
		create table alertregistration (alert_registration_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, tenant_id char(32) not null, alertrule varchar(1000) not null, alert_reference_id char(32), alert_type_id char(32), source_addr_id char(32), listindex int4, actionable bool not null, constraint pk_alreg_alregid primary key (alert_registration_id));
		create table alerttype (alert_type_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp,  tenant_id char(32) not null, description varchar(1000) not null, messagetemplatekey varchar(1000) not null, fromkey varchar(255) not null, subjectkey varchar(255) not null, ruletemplatekey varchar(255) not null, namespacekey varchar(255), emailtemplatekey varchar(1000) not null, textemailtemplatekey varchar(1000) not null, validationtemplatekey varchar(1000) DEFAULT NULL, constraint pk_alerttype_id primary key (alert_type_id), constraint uk_altyp_desc unique (description));
		create table authenticationtoken (authentication_token_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, authenticated bool not null, schemename varchar(255), token varchar(255), description varchar(255), createdtime timestamp, person_id char(32), operation_id char(32), constraint pk_authenticationtoken_id primary key (authentication_token_id), constraint uk_authtok_perid_oprid unique (person_id, operation_id));
		
		create table clustermember (cluster_member_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, nodeid varchar(255) not null, lastheartbeat int8 not null, managementurl varchar(255), constraint pk_clustermember_id primary key (cluster_member_id), constraint uk_clumem_nodeid unique (nodeid));
		create table clustermemberstatus (cluster_status_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, statusitem varchar(255) not null, status varchar(255) not null, loadfactor float8 not null, cluster_member_id char(32), constraint pk_clusterstatus_id primary key (cluster_status_id));
		create table correlationidalias (alias_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, correlationid varchar(255) not null, source varchar(255) not null, target varchar(255) not null, aliasname varchar(255) not null, createdtimestamp timestamp not null, constraint pk_correlationidalias_id primary key (alias_id), constraint uk_correidalias_corid unique (correlationid));
		create table discoevent (disco_event_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, nodeid varchar(255) not null, tagname varchar(255) not null, eventstatus varchar(255), discoeventtime timestamp, constraint pk_discoevent_id primary key (disco_event_id), constraint uk_discoeve_tagname unique (tagname) );
		--02/04/08-cmjs-1555 add "fileprocessed bool not null default false"
		create table discoeventfile (disco_event_file_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, filename varchar(255) not null, fileprocessed bool not null, disco_event_id char(32), constraint pk_discoevent_fileid primary key (disco_event_file_id));
		create table discoeventphone (disco_event_phone_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, disco_event_id char(32), phone_id char(32), phonenumberlistindex int4, constraint pk_discoeventphone_id primary key (disco_event_phone_id));
		create table email (email_id char(32) not null, emailaddress varchar(255), uniqueemailaddress varchar(255), person_id char(32), lastupdated timestamp, createdate timestamp, listindex int4, constraint pk_email_id primary key (email_id), constraint uk_email_emailaddr unique (emailaddress), constraint uk_email_uniemailaddr unique (uniqueemailaddress));
		create table eventimportance (event_importance_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, importance varchar(255) not null, constraint pk_eventimportance_id primary key (event_importance_id));
		create table eventlogentry (event_log_id int8 not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, eventcode char(30) not null, eventpersonid char(32), eventmessageid char(36), eventcorrelationid char(36), eventdatetime timestamp not null, nodeid varchar(255) not null, eventimportanceid char(32) not null, source varchar(255), eventdescription varchar(1024) not null, eventdetails varchar(1024), constraint pk_eventlogentry_id primary key (event_log_id));
		create table imaddress (imaddress_id char(32) not null, imaddress varchar(255), person_id char(32), lastupdated timestamp, createdate timestamp, listindex int4, constraint pk_imaddress_id primary key (imaddress_id), constraint uk_ima_ima unique (imaddress));
		create table macro (macro_id char(32) not null,version int8 default 0 not null,lastupdated timestamp(6) ,createdate timestamp(6) ,tenant_id char(32) not null,m_sys bool not null,user_cmd varchar(255) not null,cmd_word varchar(255) not null,param_string varchar(255) null,expiretimestamp timestamp(6) ,person_id char(32) ,name_map_key varchar(255) ,constraint pk_macro_id primary key (macro_id));
		
		create table permission (permission_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, name varchar(255) not null, constraint pk_permission_id primary key (permission_id));
		create table person (person_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp,  tenant_id char(32) not null, givenname varchar(255), middlename varchar(255), familyname varchar(255), dob timestamp, gender varchar(255), preferredlocale varchar(255), timezone varchar(255) not null, username varchar(255) not null, extusername varchar(255), user_password_digest varchar(1024), constraint pk_person_id primary key (person_id), constraint uk_person_username unique (username), constraint uk_person_extusername unique (extusername));


create table personprincipal (person_principal_id char(32) not null, person_id char(32), login_status varchar(255), bad_login_count int8 default 0, lastupdated timestamp, createdate timestamp, constraint pk_personprincipal_id primary key (person_principal_id));


create table personprofile (profile_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp,  tenant_id char(32) not null, person_id char(32) not null, profiledata bytea, constraint pk_personprofile_id primary key (profile_id));
		create table phonenumber (phone_id char(32) not null, ton varchar(255), npi varchar(255), carrier_id char(32), countrycode varchar(255) not null, areacode varchar(255), phone_number varchar(255) not null, person_id char(32), lastupdated timestamp, createdate timestamp, listindex int4, constraint pk_phone_id primary key (phone_id));
		create table property (property_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, cm_value varchar(1024) not null, property_key_id char(32) not null, person_id char(32) not null, listindex int4, constraint pk_property_id primary key (property_id));
		create table propertykey (property_key_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, name varchar(255) not null, endpoint_id char(32), listindex int4, constraint pk_propertykey_id primary key (property_key_id), constraint uk_propkey_name_endptid unique (name, endpoint_id));
		create table wcsession (sessionid char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, authenticated bool default false not null, userfirstname varchar(255), userlastname varchar(255), sourcephone varchar(255), sourceton varchar(255), sourcenpi varchar(255), sourcecarrier varchar(255), userid varchar(255), externalid varchar(255), tenant_id char(32), tenantkey varchar(255), clienttype varchar(255), app_id varchar(255), lastactive timestamp, expires timestamp, authState numeric(1) default 0 not null,constraint pk_wsessionid primary key (sessionid));
		
		create table alert_instance_history (id int8 not null, entityid varchar(255) not null, entityversion int8, eventtimestamp timestamp not null, eventtype varchar(255) not null, eventpersonid varchar(255), tenant_id char(32) not null, source_addr_id char(32), alert_type_id char(32), alert_reference_id char(32), fromaddressuri varchar(255), toaddressuri varchar(255), subject varchar(255), messagedata bytea, status varchar(255), correlationid char(36), protocol varchar(255), constraint pk_aih_id primary key (id));
		
		create table alert_reg_dnd_range (dnd_range_id char(32) not null, alert_registration_id char(32), lastupdated timestamp, createdate timestamp, listindex int4, constraint pk_alertregdndrange_id primary key (dnd_range_id));
		
		create table alert_reg_rule_values (alert_registration_id char(32) not null, cm_value varchar(255) not null, cm_key varchar(255) not null, constraint pk_adrh_id primary key (alert_registration_id, cm_key));
		
		
		
		
		create table cm_name (cm_name_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, owner_id char(32), constraint pk_cmname_id primary key (cm_name_id));
		
		create table cm_role (role_id char(32) not null, name varchar(255), lastupdated timestamp, createdate timestamp, constraint pk_cmrole_id primary key (role_id));
		
		create table command (cm_command_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, name varchar(255) not null, fromdeploymentdescriptor bool not null, operation_id char(32) not null, listindex int4, constraint pk_command_id primary key (cm_command_id), constraint uk_cmd_name unique (name));
		
		create table dnd_range (dnd_range_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp,  tenant_id char(32) not null, starttime timestamp not null, endtime timestamp not null, recurrence varchar(255) not null, action varchar(255) not null, constraint pk_dnd_range_id primary key (dnd_range_id));
		
		create table email_history (id int8 not null, entityid varchar(255) not null, entityversion int8, eventtimestamp timestamp not null, eventtype varchar(255) not null, eventpersonid varchar(255), emailaddress varchar(255), person_id char(32), constraint pk_emailhistory_id primary key (id));
		
		create table group_role (group_id char(32) not null, role_id char(32) not null, constraint pk_grouprole_id primary key (group_id, role_id));
		create table help_message (cm_name_id char(32) not null, elt varchar(255), idx varchar(255) not null, constraint pk_help_message primary key (cm_name_id, idx));
		create table imaddress_history (id int8 not null, entityid varchar(255) not null, entityversion int8, eventtimestamp timestamp not null, eventtype varchar(255) not null, eventpersonid varchar(255), imaddress varchar(255), person_id char(32), constraint pk_imaddresshistory_is primary key (id));
		create table message_on_hold (authentication_token_id char(32) not null, elt bytea, listindex int4 not null, constraint pk_messageonhold_id primary key (authentication_token_id, listindex));
		create table mobile_client (mobile_client_id char(32) not null, person_id char(32), phone_number varchar(255), app_id varchar(255) not null, device_manufacturer varchar(255), device_model varchar(255), user_agent varchar(255), lastupdated timestamp, createdate timestamp, listindex int4, mobile_client_type varchar(255) not null, os_name varchar(255), os_version varchar(255), duid varchar(255), app_version varchar(255), is_primary bool not null, constraint uk_mobileclient_app_id unique (app_id), constraint pk_mobileclient_id primary key (mobile_client_id));
		create table mobile_client_history (id int8 not null, entityid varchar(255) not null, entityversion int8, eventtimestamp timestamp not null, eventtype varchar(255) not null, eventpersonid varchar(255), person_id char(32), phone_number varchar(255), app_id varchar(255) not null, device_manufacturer varchar(255), device_model varchar(255), user_agent varchar(255), mobile_client_type varchar(255) not null, os_name varchar(255), os_version varchar(255), duid varchar(255), app_version varchar(255), is_primary bool not null, constraint pk_mch_id primary key (id));
		create table named_resource (named_resource_id char(32) not null, localpart varchar(255) not null, namespaceuri varchar(255) not null, description varchar(255), lastupdated timestamp, createdate timestamp, constraint pk_namedresource_id primary key (named_resource_id), constraint uk_namrec_locpart_nsuri unique (localpart, namespaceuri));
		
		create table notification_process_lock (lock_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, processname varchar(255) not null, nodeid varchar(255) not null, fetchdate timestamp not null, constraint pk_npl_id primary key (lock_id));
		create table onetime_pin (otp_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp,  tenant_id char(32) not null, pinvalue varchar(255), expiretimestamp timestamp, numberattempts int4, person_id char(32) not null, constraint pk_otp_id primary key (otp_id));
		create table periodic_notification (notification_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, phoneid varchar(255) not null, messagekey varchar(255) not null, messagelocale varchar(255) not null, lastsentdate timestamp not null, nextsentdate timestamp not null, notificationperiod int4 not null, constraint pk_perinoti_id primary key (notification_id), constraint uk_pernoti_phoneid unique (phoneid));
		create table periodic_notification_lock (node_notification_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, notificationid varchar(255) not null, nodeid varchar(255) not null, fetchdate timestamp not null, constraint pk_pnl_id primary key (node_notification_id), constraint uk_notiperl_notiid unique (notificationid));
		
		create table person_dnd_range (dnd_range_id char(32) not null, person_id char(32), lastupdated timestamp, createdate timestamp, listindex int4, constraint pk_perdndrng_id primary key (dnd_range_id));
		
		create table person_group (person_principal_id char(32) not null, group_id char(32) not null, constraint pk_pergrp_id primary key (person_principal_id, group_id));
		create table person_history (id int8 not null, entityid varchar(255) not null, entityversion int8, eventtimestamp timestamp not null, eventtype varchar(255) not null, eventpersonid varchar(255), tenant_id char(32) not null, givenname varchar(255), middlename varchar(255), familyname varchar(255), dob timestamp, gender varchar(255), preferredlocale varchar(255), timezone varchar(255) not null, username varchar(255) not null, extusername varchar(255), user_password_digest varchar(1024), constraint pk_perhist_id primary key (id));
		create table person_role (person_principal_id char(32) not null, role_id char(32) not null, constraint pk_perrole_id primary key (person_principal_id, role_id));


		create table phonenumber_history (id int8 not null, entityid varchar(255) not null, entityversion int8, eventtimestamp timestamp not null, eventtype varchar(255) not null, eventpersonid varchar(255), ton varchar(255), npi varchar(255), carrier_id char(32), countrycode varchar(255) not null, areacode varchar(255), phone_number varchar(255) not null, person_id char(32), constraint pk_phnohi_id primary key (id));
		create table principal (principal_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, constraint pk_principal_id primary key (principal_id));

		create table schema_version (schema_version_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp, schemaversion varchar(255) not null, constraint pk_schemaversion_id primary key (schema_version_id), constraint uk_schemaversion unique (schemaversion));
		create table service_endpoint (endpoint_id char(32) not null, apiversion varchar(255), localpart varchar(255) not null, namespaceuri varchar(255) not null, lastupdated timestamp, createdate timestamp, constraint pk_serviceendpoint_id primary key (endpoint_id), constraint uk_serend_locpart_nsuri unique (localpart, namespaceuri));

		create table service_interface (interface_id char(32) not null, localpart varchar(255) not null, namespaceuri varchar(255) not null, endpoint_id char(32) not null, lastupdated timestamp, createdate timestamp, listindex int4, constraint pk_serint_id primary key (interface_id), constraint uk_si_locpart_nsuri_endptid unique (localpart, namespaceuri, endpoint_id));

		create table service_operation (operation_id char(32) not null, javaclassname varchar(255) not null, inputhandler varchar(255), usessession bool, localpart varchar(255) not null, namespaceuri varchar(255) not null, authenticationscheme varchar(255) not null, deniedauthenticationscheme varchar(255) not null, interface_id char(32) not null, lastupdated timestamp, createdate timestamp, listindex int4, constraint pk_ser_opr_id primary key (operation_id), constraint uk_so_locp_nsu_auts_diaus_intid unique (localpart, namespaceuri, authenticationscheme, deniedauthenticationscheme, interface_id));
		
		create table sessions (tenant_id varchar(255) not null, source_name varchar(255) not null, target_name varchar(255) not null, session_data bytea, last_access timestamp, constraint pk_session_id primary key (tenant_id, source_name, target_name));
		create table source_address (source_addr_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp,  tenant_id char(32) not null, verified bool not null, optout bool not null, enabled bool not null, disconnected bool not null, nickname varchar(255), constraint pk_srcaddr_id primary key (source_addr_id));
		create table source_address_dnd_range (dnd_range_id char(32) not null, source_addr_id char(32), lastupdated timestamp, createdate timestamp, listindex int4, constraint pk_sadr primary key (dnd_range_id));
		create table source_address_history (id int8 not null, entityid varchar(255) not null, entityversion int8, eventtimestamp timestamp not null, eventtype varchar(255) not null, eventpersonid varchar(255), tenant_id char(32) not null, verified bool not null, optout bool not null, enabled bool not null, disconnected bool not null, nickname varchar(255), constraint pk_sah_id primary key (id));
		
		create table srcaddr_verification (srcaddr_verif_id char(32) not null, version int8 default 0 not null, lastupdated timestamp, createdate timestamp,  tenant_id char(32) not null, verificationtoken varchar(255), expiretimestamp timestamp, numberattempts int4, source_addr_id char(32) not null, constraint pk_saddrver_id primary key (srcaddr_verif_id));
		create table tenant (tenant_id char(32) not null,version int8 default 0 not null,lastupdated timestamp(6) ,createdate timestamp(6) ,tenantkey varchar(255) ,tenantname varchar(255) ,constraint pk_tenant_id primary key (tenant_id), constraint uk_tenant_key unique (tenantkey));
		create table tenantemaildomain (company_emaildomain_id char(32) not null,version int8 default 0 not null,lastupdated timestamp(6) ,createdate timestamp(6) ,defaultforsending bool , tenant_id char(32) not null,listindex int4 , domainname varchar(255), constraint pk_tenantemaildomain_id primary key (company_emaildomain_id), constraint uk_tendom_domname unique (domainname));
		create table tenantnamespace (tenant_namespace_id char(32) not null,version int8 default 0 not null,lastupdated timestamp(6) ,createdate timestamp(6) ,namespace varchar(255) , tenant_id char(32) not null,listindex int4 ,constraint pk_tenantnamespace_id primary key (tenant_namespace_id), constraint uk_tennamespace unique (namespace));
		create table tenantshortcode (tenant_shortcode_id char(32) not null,version int8 default 0 not null,lastupdated timestamp(6) ,createdate timestamp(6) ,defaultforsending bool ,short_code varchar(255) , tenant_id char(32) not null,listindex int4 ,constraint pk_tenantshortcode_id primary key (tenant_shortcode_id), constraint uk_ten_shortcd unique (short_code));
		create table tenanturlpattern (tenant_urlpattern_id char(32) not null,version int8 default 0 not null,lastupdated timestamp(6) ,createdate timestamp(6) ,pattern varchar(255) , tenant_id char(32) not null ,listindex int4 ,constraint pk_tenanturlpattern_id primary key (tenant_urlpattern_id), constraint uk_ten_pattern unique (pattern));
		
		create table tgroup (group_id char(32) not null, name varchar(255), parent_group_id char(32), lastupdated timestamp, createdate timestamp, constraint pk_tgroup_id primary key (group_id), constraint uk_tgroup_name unique (name));
		create table userprefs (sessionid char(32) not null, cm_value varchar(255), cm_key varchar(255) not null, constraint pk_userprefs_id primary key (sessionid, cm_key));
		
		-- tables related to the event engine
		create table actioncontext (action_context_id char(32) not null,version int8 default 0 not null,lastupdated timestamp(6),createdate timestamp(6),name varchar(255),state_model_id char(32),actionclassname varchar(255) not null,type varchar(255) not null,label varchar(255) not null,constraint pk_actioncontext_id primary key (action_context_id));
		create table actionlog (action_log_id int8 not null,version int8 default 0 not null,lastupdated timestamp(6),createdate timestamp(6) ,correlationid char(36),action_context_id char(32) ,conversation_id char(32) ,resultcode varchar(255),constraint pk_actionlog_actionlogid primary key (action_log_id), constraint uk_actionlog_corid unique (correlationid));
		create table action_properties (action_context_id char(32) not null,action_prop_value varchar(255) ,action_prop_key   varchar(255) not null,constraint pk_actionproperties_id primary key (action_context_id,action_prop_key));
		create table aliases (person_id char(32) not null,current_alias varchar(255) not null,name_map_key varchar(255) not null,constraint pk_aliases_id primary key (person_id,name_map_key));
		create table conditioncontext (condition_context_id char(32) not null,version int8 default 0 not null,lastupdated timestamp(6) null,createdate timestamp(6) null, name varchar(255),state_model_id char(32),conditionclassname varchar(255) not null,transition_id char(32),transition_list_idx int4,constraint pk_conditioncontext_id primary key (condition_context_id));
		create table condition_properties (condition_context_id char(32) not null,condition_prop_value varchar(255) ,condition_prop_key   varchar(255) not null,constraint pk_conditionprop_id primary key (condition_context_id,condition_prop_key));
		create table conversation (conversation_id char(32) not null,version int8 default 0 not null,lastupdated timestamp(6) ,createdate timestamp(6) ,tenant_id char(32) not null,state_id char(32) ,content bytea not null,state_model_reg_id char(32) ,state_model_id char(32), expiretimestamp timestamp(6), terminated bool not null, alerttypedescription varchar(1000) not null, constraint pk_conversation_id primary key (conversation_id));
		
		create table entryactioncontext (entry_action_id char(32) not null,state_id char(32) ,entry_action_list_idx int4 ,constraint pk_entryaction_id primary key (entry_action_id));
		create table exitactioncontext (exit_action_id char(32) not null,state_id char(32) ,exit_action_list_idx int4 ,constraint pk_exitaction_id primary key (exit_action_id));
		create table state (state_id char(32) not null,version int8 default 0 not null,lastupdated timestamp(6) ,createdate timestamp(6) , name varchar(255) ,state_model_id char(32) ,terminal bool not null,constraint pk_state_id primary key (state_id));
		create table statemodel (state_model_id char(32) not null,version int8 default 0 not null,statemodelversion float8 not null,name varchar(255) not null,lastupdated timestamp(6) ,createdate timestamp(6) ,tenant_id char(32) not null,state_id char(32) , daystoexpirefromfinal int4, constraint pk_statemodel_id primary key (state_model_id), constraint uk_sm_ver_name unique (statemodelversion, name));
		create table statemodelregistration (state_model_reg_id char(32) not null,version int8 default 0 not null,lastupdated timestamp(6) ,createdate timestamp(6) , alert_reference_id char(32) ,statemodelname varchar(255) ,person_id char(32) ,constraint pk_statemodelreg_id primary key (state_model_reg_id));
		create table state_model_properties (state_model_id char(32) not null,state_model_prop_value varchar(255) ,state_model_prop_key varchar(255) not null,constraint pk_statemodelprop_id primary key (state_model_id,state_model_prop_key));
		create table transition (transition_id char(32) not null,version int8 default 0 not null,lastupdated timestamp(6) ,createdate timestamp(6) , name varchar(255) ,state_model_id char(32) ,state_id char(32) ,transition_list_id char(32) ,transition_list_idx int4 ,constraint pk_transition_id primary key (transition_id));
		create table transitionactioncontext (transition_action_id char(32) not null,transition_id char(32) ,transition_list_idx int4 ,constraint pk_transitionaction_id primary key (transition_action_id));
		create table transitionlist (transition_list_id char(32) not null,version int8 default 0 not null,lastupdated timestamp(6) ,createdate timestamp(6) , name varchar(255) ,state_model_id char(32) ,state_id char(32) ,event_transition_key varchar(255) ,constraint pk_transitionlist_id primary key (transition_list_id));
		
		-- tables related to the schedular
		--2009-0306 rr- for rewrite of scheduler
		create table pendingevent(pending_event_id int8 not null, version int8 not null default 0, lastupdated timestamp, createdate timestamp,  name varchar(255),  alias varchar(255), reschedulecount int4, arexternalid varchar(255),  firetime timestamp, giveuptime timestamp, artypedescription varchar(255), lockexpiry timestamp, owner varchar(255),  conversation_id char(32),  content bytea not null,  constraint pendingevent_pkey primary key (pending_event_id));
		create table semaphore(semaphore_id int8 not null, name varchar(255) not null, constraint semaphore_pkey primary key (semaphore_id), constraint uk_semaphore_name unique (name));

		-- tables related to the bfl (batch file loader)
		create table batch_job_instance (job_instance_id bigint not null constraint pk_batch_job_instance primary key ,version bigint ,job_name varchar(100) not null, job_key varchar(2500) not null, constraint uk_batjobinst_jobnamejobkey unique (job_name, job_key)) ;
		create table batch_job_execution  (job_execution_id bigint  not null constraint pk_batch_job_execution primary key ,version bigint  , job_instance_id bigint not null,create_time timestamp not null,start_time timestamp default null , end_time timestamp default null ,status varchar(10) ,continuable char(1) ,exit_code varchar(20) ,exit_message varchar(2500)) ;
		create table batch_job_params  (job_instance_id bigint not null ,type_cd varchar(6) not null ,key_name varchar(100) not null , string_val varchar(250) , date_val timestamp default null ,long_val bigint ,double_val double precision) ;
		create table batch_step_execution(step_execution_id bigint not null constraint pk_batch_step_execution primary key ,version bigint not null,step_name varchar(100) not null,job_execution_id bigint not null,start_time timestamp not null , end_time timestamp default null ,status varchar(10) ,commit_count bigint , item_count bigint ,read_skip_count bigint ,write_skip_count bigint ,rollback_count bigint ,continuable char(1) ,exit_code varchar(20) ,exit_message varchar(2500));
		create table batch_execution_context (execution_id bigint not null,discriminator varchar(1) not null,type_cd varchar(6) not null,key_name varchar(445) not null, string_val varchar(1000) , date_val timestamp default null ,long_val bigint ,double_val double precision ,object_val bytea ) ;
		create table batch_data_item ( batch_data_item_id character(32) not null,  batch_data_type varchar(255) not null, batch_data_item_key varchar(445) not null, version int8 default 0 not null,lastupdated timestamp(6) ,createdate timestamp(6) ,tenant_id char(32) not null, sent_job_instance_id bigint null, recon_job_instance_id bigint null, sent boolean not null default false, constraint pk_batch_data_item_id primary key (batch_data_item_id));
		create sequence batch_data_item_property_seq minvalue 1 no maxvalue cache 1;
		create table batch_data_item_property ( batch_data_item_property_id bigint not null default nextval('batch_data_item_property_seq'), batch_data_item_id character(32) not null, item_property_name varchar(30) not null, item_property_type varchar not null default 'java.lang.string', item_property_value varchar(255) not null, constraint pk_batch_data_item_prop_id primary key (batch_data_item_property_id), constraint uk_batch_dtit_prop_id_name unique (batch_data_item_id, item_property_name));
		create table batch_data_complex_value ( batch_data_complex_value_id character(32) not null, data_type varchar(255) not null, data_value varchar not null, constraint pk_batch_data_complex_valueid primary key (batch_data_complex_value_id));

		-- tables related to the location
		create table location (location_id char(32) not null, version int8  default 0 not null, lastupdated timestamp, createdate timestamp, tenant_id char(32) not null, name varchar(255), administrativearea varchar(255) not null, locality varchar(255) not null, thoroughfare varchar(255) not null, postalcode varchar(255) not null, country varchar(255) not null, lastupdatedby varchar(255), latitude double precision, longitude double precision, accuracy int4, errorcode int4, identifier varchar(255), type int4, constraint pk_location_locid primary key (location_id), constraint uk_location_tenant_id unique (tenant_id, thoroughfare, locality, administrativearea, postalcode, country));
		create table location_properties (p_location_id character(32) not null, map_value varchar(255), map_key varchar(255) not null, constraint pk_location_properties primary key (p_location_id, map_key), constraint fk_locprop_loc_locid foreign key (p_location_id) references location (location_id));

		-- tables related to carrier code and aggregators for smpp
		create table aggregator ( aggregator_id character(32) not null,version bigint not null default 0, lastupdated timestamp without time zone, createdate timestamp without time zone, name character varying(255), description character varying(255), enabled boolean not null, constraint pk_aggregator_aggregatorid primary key (aggregator_id));
		create table carrier (carrier_id char(32) not null, version int8  default 0 not null, lastupdated timestamp, createdate timestamp, tenant_id char(32) not null,name varchar(255) not null, countrycode varchar(32),description varchar(255), constraint uk_carrier_name_code unique (name,countryCode), constraint pk_carrier_carrierid primary key (carrier_id));
		create table smppcarriercode (tenant_id char(32) not null, carriercode_id char(32) not null,version int8 not null default 0, lastupdated timestamp, createdate timestamp, code varchar(8), carrier_id char(32), listindex int4 ,aggregator_id character(32), constraint pk_carriercode_carriercodeid primary key (carriercode_id) );
		
		-- tables related to userNameInfo for SavedUsername feature
		create table servicedata ( service_data_key varchar(64) not null,version bigint not null default 0, lastupdated timestamp without time zone, createdate timestamp without time zone, service_name varchar(32),service_data_value varchar(1024), expiretimestamp timestamp without time zone, constraint pk_servicedata primary key (service_data_key));
		
        create table redelivery_queue (redelivery_queue_id character(32) not null,"version" bigint not null default 0,lastupdated timestamp(6) without time zone,createdate timestamp(6) without time zone,correlationid char(36),nodeid varchar(255) not null,lastactive timestamp(6) without time zone,retryattempts int8 not null,messagedata bytea not null,constraint pk_redelivery_queue_id primary key (redelivery_queue_id));
		
    -- Productization tables
    create table productenrollment
     ( enrollment_id char(32) not null,productkey char(32) not null, person_id char(32) not null, enrollmentdate timestamp, author varchar(255) not null, version int8 	not null DEFAULT 0,lastupdated timestamp,createdate timestamp,
       constraint pk_enrollment_id primary key (enrollment_id),
       constraint productenrollment_unique unique (productkey, person_id),
       constraint fk_enrollment_per_id foreign key (person_id) references person (person_id));

    create table termsandconditions
     ( t_and_c_id char(32) not null, person_id char(32) not null, versionname varchar(255) not null, tcVersion char(10) not null,acceptancedate timestamp,
       description varchar(1000), author varchar(255) not null, version int8 	not null DEFAULT 0,lastupdated timestamp,createdate timestamp,
     constraint pk_termscondition_id primary key (t_and_c_id),
     constraint termscondition_unique unique (person_id, versionname, tcVersion),
     constraint fk_termscondition_per_id foreign key (person_id) references person (person_id));
  
		-- Tables 4.2
		create table dailyusagemonitor
		( daily_usage_id char(32) not null,version int8 not null DEFAULT 0,lastupdated timestamp,createdate timestamp,currentusage real,lastcycledate timestamp,
  		constraint pk_dailyusagemonitor_id primary key (daily_usage_id));
		create table weeklyusagemonitor
		( weekly_usage_id char(32) not null,version int8 not null DEFAULT 0,lastupdated timestamp,createdate timestamp,currentusage real,lastcycledate timestamp,
  		constraint pk_weeklyusagemonitor_id primary key (weekly_usage_id));

		create table featureusage
		( feature_usage_id char(32) not null,version int8 not null DEFAULT 0,lastupdated timestamp,createdate timestamp,feature varchar(255) not null,daily_trans_usage_id char(32), 
  		weekly_trans_usage_id 	char(32),daily_amount_usage_id char(32), weekly_amount_usage_id char(32),person_id character(32),listindex integer,
  		constraint pk_featureusage_id  	primary key (feature_usage_id),
  		constraint fk_ftruge_dy_usagemon_id	foreign key (daily_amount_usage_id) references dailyusagemonitor (daily_usage_id) 	,
  		constraint fk_ftruge_per_id		foreign key (person_id)	 		references person (person_id)			,
  		constraint fk_ftruge_wk_usagemon_id foreign key (weekly_amount_usage_id)references weeklyusagemonitor (weekly_usage_id) ,
  		constraint fk_ftruge_wk_uagemon_id  foreign key (weekly_trans_usage_id)	references weeklyusagemonitor (weekly_usage_id));
  		
		-- foreign keys constraints
		alter table aclentry add constraint fk_aclentry_prinid foreign key (principal_id) references principal;
		alter table aclentry add constraint fk_aclentry_permid foreign key (permission_id) references permission;
		alter table aclentry add constraint fk_aclentry_cmnameid foreign key (cm_name_id) references cm_name;
		alter table address add constraint fk_address_personid foreign key (person_id) references person;
		alter table alertinstance add constraint fk_alert_refid foreign key (alert_reference_id) references alertreference;
		alter table alertinstance add constraint fk_alert_typeid foreign key (alert_type_id) references alerttype;
		alter table alertinstancedelayqueue add constraint fk_alertinstdelque_instid foreign key (alert_instance_id) references alertinstance;
		alter table alertinstancedelayqueue add constraint fk_alertinstdeque_regid foreign key (alert_registration_id) references alertregistration;
		alter table alertinstancequeue add constraint fk_alertinstque_instid foreign key (alert_instance_id) references alertinstance;
		alter table alertreference add constraint fk_alertref_reftypeid foreign key (alert_reference_type_id) references alertreferencetype;
		alter table alertregistration add constraint fk_alertreg_refid foreign key (alert_reference_id) references alertreference;
		alter table alertregistration add constraint fk_alertreg_said foreign key (source_addr_id) references source_address;
		alter table alertregistration add constraint fk_alertreg_alerttypeid foreign key (alert_type_id) references alerttype;
		alter table authenticationtoken add constraint fk_authtoken_personid foreign key (person_id) references person;
		alter table authenticationtoken add constraint fk_authtoken_opid foreign key (operation_id) references service_operation;
		alter table clustermemberstatus add constraint fk_clusmemstat_clutmemid foreign key (cluster_member_id) references clustermember;
		alter table discoeventfile add constraint fk_discoeventfile_diseventid foreign key (disco_event_id) references discoevent;
		alter table discoeventphone add constraint fk_discoeventph_diseventid foreign key (disco_event_id) references discoevent;
		alter table discoeventphone add constraint fk_discoeventph_phoneid foreign key (phone_id) references phonenumber;
		alter table email add constraint fk_email_personid foreign key (person_id) references person;
		alter table email add constraint fk_email_emailid foreign key (email_id) references source_address;
		alter table eventlogentry add constraint fk_eventlogentry_evimportid foreign key (eventimportanceid) references eventimportance;
		alter table imaddress add constraint fk_imaddress_personid foreign key (person_id) references person;
		alter table imaddress add constraint fk_imaddress_imadid foreign key (imaddress_id) references source_address;
		alter table macro add constraint fk_macro_personid foreign key (person_id) references person;
		alter table personprincipal add constraint fk_personprin_personid foreign key (person_id) references person;
		alter table personprincipal add constraint fk_personprin_personprinid foreign key (person_principal_id) references principal;
		alter table personprofile add constraint fk_personprof_personid foreign key (person_id) references person;
		alter table phonenumber add constraint fk_phonenumber_personid foreign key (person_id) references person;
		alter table phonenumber add constraint fk_phonenumber_phoneid foreign key (phone_id) references source_address;
		alter table phonenumber add constraint fk_carrier_id foreign key(carrier_id) references carrier(carrier_id);
		alter table property add constraint fk_prop_keyid foreign key (property_key_id) references propertykey on delete cascade;
		alter table property add constraint fk_prop_personid foreign key (person_id) references person;
		alter table propertykey add constraint fk_propkey_endid foreign key (endpoint_id) references service_endpoint;
		alter table alert_reg_dnd_range add constraint fk_alertregdndrnge_aregid foreign key (alert_registration_id) references alertregistration;
		alter table alert_reg_dnd_range add constraint fk_alertregdndrnge_dndrngeid foreign key (dnd_range_id) references dnd_range;
		
		alter table alert_reg_rule_values add constraint fk_alertregrulval_aregid foreign key (alert_registration_id) references alertregistration;
		
		alter table cm_name add constraint fk_cmname_ownerid foreign key (owner_id) references principal;
		alter table cm_role add constraint fk_cmrole_rolid foreign key (role_id) references principal;
		
		alter table command add constraint fk_command_opid foreign key (operation_id) references service_operation;
		alter table email_history add constraint fk_emailhist_id foreign key (id) references source_address_history;
	
		alter table group_role add constraint fk_grprol_roleid foreign key (role_id) references cm_role;
		alter table group_role add constraint fk_grprol_grpid foreign key (group_id) references tgroup;
		alter table help_message add constraint fk_helpmsg_cmnameid foreign key (cm_name_id) references cm_name;
		alter table imaddress_history add constraint fk_imaddhist_id foreign key (id) references source_address_history;
		alter table message_on_hold add constraint fk_msgonhold_authtokenid foreign key (authentication_token_id) references authenticationtoken;
		alter table mobile_client add constraint fk_mobclient_person_id foreign key (person_id) references person;
		alter table mobile_client add constraint fk_mobile_client_id foreign key (mobile_client_id) references source_address;
		alter table mobile_client_history add constraint fk_mobclienthist_id foreign key (id) references source_address_history;
		alter table named_resource add constraint fk_namerres_namedresid foreign key (named_resource_id) references cm_name;
	
		alter table onetime_pin add constraint fk_onetimepin_personid foreign key (person_id) references person;
		alter table person_dnd_range add constraint fk_perdndrange_dndrangeid foreign key (dnd_range_id) references dnd_range;
		alter table person_dnd_range add constraint fk_perdndrange_personid foreign key (person_id) references person;
	
		alter table person_group add constraint fk_pergrp_perprinid foreign key (person_principal_id) references personprincipal;
		alter table person_group add constraint fk_pergrp_grpid foreign key (group_id) references tgroup;
		alter table person_role add constraint fk_pergrp_rolid foreign key (role_id) references cm_role;
		alter table person_role add constraint fk_perrole_perprinid foreign key (person_principal_id) references personprincipal;
	
		alter table phonenumber_history add constraint fk_phonenumhist_id foreign key (id) references source_address_history;
		alter table service_endpoint add constraint fk_serend_endid foreign key (endpoint_id) references cm_name;
	
		alter table service_interface add constraint fk_serint_endid foreign key (endpoint_id) references service_endpoint;
		alter table service_interface add constraint fk_serint_intid foreign key (interface_id) references cm_name;
	
		alter table service_operation add constraint fk_serope_intid foreign key (interface_id) references service_interface;
		alter table service_operation add constraint fk_serope_opeid foreign key (operation_id) references cm_name;
	
		alter table source_address_dnd_range add constraint fk_sadndrange_dndrangeid foreign key (dnd_range_id) references dnd_range;
		alter table source_address_dnd_range add constraint fk_sadndrange_said foreign key (source_addr_id) references source_address;
	
		alter table srcaddr_verification add constraint fk_saver_said foreign key (source_addr_id) references source_address;
		alter table tgroup add constraint fk_tgroup_parentgrpid foreign key (parent_group_id) references tgroup;
		alter table tgroup add constraint fk_tgroup_groupid foreign key (group_id) references principal;
		alter table userprefs add constraint fk_userprefs_sessionid foreign key (sessionid) references wcsession;

		-- foreign key constraints related to the event engine
		alter table actioncontext add constraint fk_actioncontext_state_model_id foreign key (state_model_id) references statemodel (state_model_id);
		alter table actionlog add constraint fk_actionlog_action_context_id foreign key (action_context_id) references actioncontext (action_context_id);
		alter table action_properties add constraint fk_action_properties_action_context_id  foreign key (action_context_id) references actioncontext (action_context_id);
		alter table aliases add constraint fk_aliases_person_id foreign key (person_id) references person (person_id);
		alter table conditioncontext add constraint fk_conditioncontext_state_model_id foreign key (state_model_id) references statemodel (state_model_id);
		alter table conditioncontext add constraint fk_conditioncontext_transition_id foreign key (transition_id) references transition (transition_id);
		alter table condition_properties add constraint fk_condition_properties_condition_context_id foreign key (condition_context_id) references conditioncontext (condition_context_id);
		alter table conversation add constraint fk_conversation_state_id foreign key (state_id) references state (state_id);
		alter table conversation add constraint fk_conversation_state_model_id foreign key (state_model_id) references statemodel (state_model_id);
		alter table conversation add constraint fk_conversation_state_model_reg_id foreign key (state_model_reg_id) references statemodelregistration (state_model_reg_id);
		alter table entryactioncontext add constraint fk_entryactioncontext_entry_action_id foreign key (entry_action_id) references actioncontext (action_context_id);
		alter table entryactioncontext add constraint fk_entryactioncontext_state_id foreign key (state_id) references state (state_id);
		alter table exitactioncontext add constraint fk_exitactioncontext_exit_action_id foreign key (exit_action_id) references actioncontext (action_context_id);
		alter table exitactioncontext add constraint fk_exitactioncontext_state_id foreign key (state_id) references state (state_id);
		alter table state add constraint fk_state_state_model_id foreign key (state_model_id) references statemodel (state_model_id);
		alter table statemodel add constraint fk_statemodel_state_id foreign key (state_id) references state (state_id);
		alter table statemodelregistration add constraint fk_statemodreg_alert_reference_id foreign key (alert_reference_id) references alertreference (alert_reference_id);
		alter table statemodelregistration add constraint fk_statemodreg_person_id foreign key (person_id) references person (person_id);
		alter table state_model_properties add constraint fk_state_model_properties_state_model_id foreign key (state_model_id) references statemodel (state_model_id);
		alter table tenantemaildomain add constraint fk_tenantemaildomain_tenant_id foreign key (tenant_id) references tenant (tenant_id);
		alter table tenantnamespace add constraint fk_tenantnamespace_tenant_id foreign key (tenant_id) references tenant (tenant_id);
		alter table tenantshortcode add constraint fk_tenantshortcode_tenant_id foreign key (tenant_id) references tenant (tenant_id);
		alter table tenanturlpattern add constraint fk_tenanturlpattern_tenant_id foreign key (tenant_id) references tenant (tenant_id);
		alter table transition add constraint fk_transition_state_id foreign key (state_id) references state (state_id);
		alter table transition add constraint fk_transition_state_model_id foreign key (state_model_id) references statemodel (state_model_id);
		alter table transition add constraint fk_transition_transition_list_id foreign key (transition_list_id) references transitionlist (transition_list_id);
		alter table transitionactioncontext add constraint fk_transcontext_transition_action_id foreign key (transition_action_id) references actioncontext (action_context_id);
		alter table transitionactioncontext add constraint fk_transcontext_transition_id foreign key (transition_id) references transition (transition_id);
		alter table transitionlist add constraint fk_transitionlist_state_id foreign key (state_id) references state (state_id);
		alter table transitionlist add constraint fk_transitionlist_state_model_id foreign key (state_model_id) references statemodel (state_model_id);

		-- foreign key constraints related to the schedular
		alter table pendingevent add constraint fk_pendingevent_convid foreign key (conversation_id) references conversation (conversation_id) match simple on update no action on delete no action;		

		-- foreign key constraints related to the bfl(batch file loader)
		alter table batch_job_execution add constraint job_inst_exec_fk foreign key (job_instance_id) references batch_job_instance;
		alter table batch_job_params add constraint job_inst_params_fk foreign key (job_instance_id) references batch_job_instance;
		alter table batch_step_execution add constraint job_exec_step_fk foreign key (job_execution_id) references batch_job_execution;
		alter table batch_data_item add constraint uk_batch_data_item_type_key unique (batch_data_type, batch_data_item_key);
		alter table batch_data_item add constraint fk_batch_data_item_sentid foreign key (sent_job_instance_id) references batch_job_instance (job_instance_id);
		alter table batch_data_item add constraint fk_batch_data_item_reconid foreign key (recon_job_instance_id) references batch_job_instance (job_instance_id);
		alter table batch_data_item_property add constraint fk_batch_data_item_prop_id foreign key (batch_data_item_id) references batch_data_item (batch_data_item_id);
		
		-- foreign key constraints related to the carrier and smppcarriercode 
		alter table smppcarriercode add constraint fk_carrier_id foreign key (carrier_id) references carrier(carrier_id);
		alter table smppcarriercode add constraint fk_aggregator_id foreign key(aggregator_id) references aggregator(aggregator_id);
	    
		-- indexes
		create index alert_correlation_id_index on alertinstance (correlationid);		
		create index evt_datetime_idx on eventlogentry (eventdatetime);
		create index evt_correlationid_idx on eventlogentry (eventcorrelationid);
		create index evt_messageid_idx on eventlogentry (eventmessageid);
		create index evt_source_idx on eventlogentry (source);
		create index evt_personid_idx on eventlogentry (eventpersonid);
		create index evt_code_idx on eventlogentry (eventcode);
		create unique index execution_id_key_name_idx on batch_execution_context (execution_id, key_name);
  
		create index address_person_id_idx on address (person_id);
		create index alert_reference_id_idx on alertregistration (alert_reference_id);
		create index command_operation_id_idx on command (operation_id);
		create index person_dnd_range_person_id_idx on person_dnd_range (person_id);
		create index src_addr_dnd_rng_srcad_id_idx on source_address_dnd_range (source_addr_id);
		create index macro_person_id_idx on macro (person_id);
		create index personprofile_person_id_idx on personprofile (person_id);
		create index personprincipal_person_id_idx on personprincipal (person_id);
		create index property_person_id_idx on property (person_id);
		create index phone_no_person_id_idx on phonenumber (person_id);
		create index email_person_id_idx on email (person_id);
		create index imaddress_person_id_idx on imaddress (person_id);
		create index person_id_idx on mobile_client (person_id);
		create index srcaddr_verif_src_addr_id_idx on srcaddr_verification (source_addr_id);
		create index alertinsthist_srcaddr_idx on alert_instance_history(source_addr_id);
		
		-- Adding productization tables indexes
	  create index productenrollment_person_idx on productenrollment(person_id);
	  create index productenrollment_productkey_idx on productenrollment(productkey);
	  create index termsandconditions_person_idx on termsandconditions(person_id);

		create unique index uk_cor_alias_idx on correlationidalias (source, target, aliasname);
		create unique index uk_phone_no_idx on phonenumber (countrycode, areacode, phone_number);
		create unique index phone_no_concat_idx on phonenumber ((countrycode || areacode || phone_number));
		create index acl_cm_name_id_idx on aclentry (cm_name_id);
		create index acl_principal_id_idx on aclentry (principal_id);
		create index al_ac_id_idx on actionlog (action_context_id);
		create index al_conv_id_idx on actionlog (conversation_id);
		create index ai_ar_id_idx on alertinstance (alert_reference_id);
		create index ai_at_id_idx on alertinstance (alert_type_id);
		create index aidq_ai_id_idx on alertinstancedelayqueue (alert_instance_id);
		create index aidq_ar_id_idx on alertinstancedelayqueue (alert_registration_id);
		create index ar_art_id_idx on alertreference (alert_reference_type_id);
		create index ar_exid_idx on alertreference (externalid);
		create index ar_at_id_idx on alertregistration (alert_type_id);
		create index ar_sa_id_idx on alertregistration (source_addr_id);
		create index ar_dnd_ar_id_idx on alert_reg_dnd_range (alert_registration_id);
		
		create index cmname_owner_id_idx on cm_name (owner_id);
		create index cc_tran_id_idx on conditioncontext (transition_id);
		create index conv_sm_id_idx on conversation (state_model_id);
		create index conv_smr_id_idx on conversation (state_model_reg_id);
		create index conv_state_id_idx on conversation (state_id);
		create index def_de_id_idx on discoeventfile (disco_event_id);
		create index dep_de_id_idx on discoeventphone (disco_event_id);
		create index dep_p_id_idx on discoeventphone (phone_id);
		create index otp_person_id_idx on onetime_pin (person_id);
		create index state_sm_id_idx on state (state_model_id);
		create index sm_state_id_idx on statemodel (state_id);
		create index smr_alert_ref_id_idx on statemodelregistration (alert_reference_id);
		create index smr_person_id_idx on statemodelregistration (person_id);
		create index ted_tenant_id_idx on tenantemaildomain (tenant_id);
		create index tn_tenant_id_idx on tenantnamespace (tenant_id);
		create index ts_tenant_id_idx on tenantshortcode (tenant_id);
		create index tup_tenant_id_idx on tenanturlpattern (tenant_id);
		create index tr_tl_id_idx on transition (transition_list_id);
		create index tac_tran_id_idx on transitionactioncontext (transition_id);
		create index tl_state_id_idx on transitionlist (state_id);
		create index aiq_ai_id_idx on alertinstancequeue (alert_instance_id);
		create index pgroup_person_principal_id_idx on person_group (person_principal_id);
		create index pgroup_group_id_idx on person_group (group_id);
		create index tgroup_parent_group_id_idx on tgroup (parent_group_id); 
		create index aliases_person_id_idx on aliases (person_id);
		create index macro_expiretimestamp_idx on macro (expiretimestamp);

		--For CMJS - 2775
		create index aclentry_permissionid_idx on aclentry (permission_id) ;
		create index actprop_contextid_idx on action_properties (action_context_id) ;
		create index alregrulval_alertregid_idx on alert_reg_rule_values (alert_registration_id) ;
		create index actcontext_statemodelid_idx on actioncontext (state_model_id) ;
		create index batch_data_item_sentid_idx on batch_data_item (sent_job_instance_id) ;
		create index batch_data_item_reconid_idx on batch_data_item (recon_job_instance_id) ;
		create index batch_data_item_prop_id_idx on batch_data_item_property (batch_data_item_id) ;
		create index clusmemstat_memberid_idx on clustermemberstatus (cluster_member_id) ;
		create index condcontext_statemodid_idx on conditioncontext (state_model_id) ;
		create index condprop_condcontextid_idx on condition_properties (condition_context_id) ;
		create index entryactcntxt_stateid_idx on entryactioncontext (state_id) ;
		create index grprole_roleid_idx on group_role (role_id) ;
		create index grprole_grpid_idx on group_role (group_id) ;
		create index helpmsg_cmnameid_idx on help_message (cm_name_id) ;
		create index mesonhold_authtokenid_idx on message_on_hold (authentication_token_id) ;
		create index personrole_roleid_idx on person_role (role_id) ;
		create index personrole_personprinid_idx on person_role (person_principal_id) ;
		create index propkey_endpntid_idx on propertykey (endpoint_id) ;
		create index serviceint_endptid_idx on service_interface (endpoint_id) ;
		create index serviceop_intid_idx on service_operation (interface_id) ;
		create index stmodprop_stmodid_idx on state_model_properties (state_model_id) ;
		create index trans_stmodid_idx on transition (state_model_id) ;
		create index trans_stateid_idx on transition (state_id) ;
		create index translist_statmodid_idx on transitionlist (state_model_id) ;
		create index userprefs_sessionid_idx on userprefs (sessionid) ;

		-- indexes related to the schedular
		create index pe_conv_id_idx  on pendingevent (conversation_id);
		create index pe_firetime_idx  on pendingevent  (firetime);
		create index pe_lockexpiry_idx  on pendingevent (lockexpiry);
		create index pe_owner_idx  on pendingevent (owner);
		
		--Adding a new index for alert_instance_history on eventtimestamp.
		create index alertinsthist_timestamp_idx on alert_instance_history(eventtimestamp);
		--New indexes for 4.4 to resolve alerthistory perf. delay
		create index phonenumbhist_person_id_idx on phonenumber_history (person_id);
		create index mclienthist_person_id_idx on mobile_client_history (person_id);
		create index emailhist_person_id_idx on email_history (person_id);
		create index phonenumbhist_entity_id_idx on phonenumber_history (entityid);
		create index emailhist_entity_id_idx on email_history (entityid);
		create index mclienthist_entity_id_idx on mobile_client_history (entityid);
		create index srcaddrhist_entity_id_idx on source_address_history (entityid);
		
		create index rq_node_id_idx on redelivery_queue (nodeid);
		create index rq_correlation_id_idx on redelivery_queue (correlationid);

		create unique index wcsession_extId_clientType on wcsession (externalId, clientType);

		
		-- sequences
		
		create sequence alert_instance_history_seq minvalue 1 no maxvalue cache 1;
		
		create sequence event_log_seq minvalue 1 no maxvalue cache 1;
		
		create sequence message_log_seq minvalue 1 no maxvalue cache 1;
		
		create sequence person_history_seq minvalue 1 no maxvalue cache 1;
				
		create sequence src_address_history_seq minvalue 1 no maxvalue cache 1;
		
		create sequence mobileweb_history_seq minvalue 1 no maxvalue cache 1;
		create sequence batch_step_execution_seq minvalue 1 no maxvalue cache 1;
		create sequence batch_job_execution_seq minvalue 1 no maxvalue cache 1;
		create sequence batch_job_seq minvalue 1 no maxvalue cache 1;
		
		
		create sequence actionlog_seq minvalue 1 no maxvalue cache 1;
		create sequence pending_event_seq minvalue 1 no maxvalue cache 1;
		create sequence semaphore_seq minvalue 1 no maxvalue cache 1;

		
		update script_audit set lastupdated=current_timestamp, status='FINISHED' where scriptname='CREATE_OBJECT_PS.sql' and scriptversion = var_scriptversion and createdate=greatest(createdate);
	end if;
end
$$ language plpgsql;

select checkforobjects_existence();
drop function checkforobjects_existence();

