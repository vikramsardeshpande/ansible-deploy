---------------------------------------------------------
-- Name:     CarrierInitialData.sql
-- Purpose : This script populates the Carrier OLTP initial data. 
-- Steps to execute the script from command line:
-- C:> sqlcmd -S IPAddress\InstanceName -d OLTPDataBaseName -U OLTPUser -P OLTPPassword -v oltpdb="OLTPDataBaseName" -i CarrierInitialData.sql
-- For Example
-- C:> sqlcmd -S PS4714\CLAIRMAILDB -d clairdb -U testoltpuser -P testoltppass -v oltpdb="clairdb" -i CarrierInitialData.sql
---------------------------------------------------

use $(oltpdb)
go

declare @isExecuted int
declare @scriptversion varchar(30)

begin
	set @scriptversion='5.1.7'
    select  @isExecuted=count(*) from script_audit where scriptname='CarrierInitialData.sql' and scriptversion=@scriptversion;
    if (@isExecuted=1)
	begin
		print 'The CarrierInitialData.sql file is already executed once.Please contact your ClairMail System Administrator'
	end
    else
	begin
		insert into script_audit
		select current_timestamp,
			null,
			'CarrierInitialData.sql',
			@scriptversion,
			system_user,
			current_user,
			hostname.*,
			null,
			is_srvrolemember ('sysadmin'),
			'OLTP Carrier Initial Data population script',
			'STARTED'
		from (select host_name from sys.dm_exec_sessions where status = 'running') as hostname;

		begin transaction

		-- inserting into aggregator table
		insert into aggregator (aggregator_id, version, lastupdated, createdate, name, description, enabled) values ('4028827a238199d00123819a4fa20095', 0, current_timestamp, current_timestamp, 'Wau_Movil', 'aggregator for latin america', 1);
		insert into aggregator (aggregator_id, version, lastupdated, createdate, name, description, enabled) values ('4028827a238199d00123819a4fa20096', 0, current_timestamp, current_timestamp, 'Verisign', 'aggregator for north america and Europe', 0);
		insert into aggregator (aggregator_id, version, lastupdated, createdate, name, description, enabled) values ('4028827a238199d00123819a4fa20097', 0, current_timestamp, current_timestamp, 'M_BLOX', 'aggregator for north america', 0);

		--- inserting into carrier table
		insert into carrier (carrier_id, version, lastupdated, createdate, tenant_id, name, countrycode, description) values ('4028827a238199d00123819a4fb20098', 0, current_timestamp, current_timestamp, '402882311c77845f011c7784b3b30002', 'iusacell', 'MX', NULL);
		insert into carrier (carrier_id, version, lastupdated, createdate, tenant_id, name, countrycode, description) values ('4028827a238199d00123819a4fb2009a', 0, current_timestamp, current_timestamp, '402882311c77845f011c7784b3b30002', 'Movistar', 'MX', NULL);
		insert into carrier (carrier_id, version, lastupdated, createdate, tenant_id, name, countrycode, description) values ('4028827a238199d00123819a4fc2009c', 0, current_timestamp, current_timestamp, '402882311c77845f011c7784b3b30002', 'telcel', 'MX', NULL);

		-- inserting into smppcarriercode table
		insert into smppcarriercode (carriercode_id, version, lastupdated, createdate, tenant_id, code, carrier_id, aggregator_id, listindex) values ('4028827a238199d00123819a4fb20099', 0, current_timestamp, current_timestamp, '402882311c77845f011c7784b3b30002', '40', '4028827a238199d00123819a4fb20098', '4028827a238199d00123819a4fa20095', 0);
		insert into smppcarriercode (carriercode_id, version, lastupdated, createdate, tenant_id, code, carrier_id, aggregator_id, listindex) values ('4028827a238199d00123819a4fb2009b', 0, current_timestamp, current_timestamp, '402882311c77845f011c7784b3b30002', '50', '4028827a238199d00123819a4fb2009a', '4028827a238199d00123819a4fa20095', 0);
		insert into smppcarriercode (carriercode_id, version, lastupdated, createdate, tenant_id, code, carrier_id, aggregator_id, listindex) values ('4028827a238199d00123819a4fc2009d', 0, current_timestamp, current_timestamp, '402882311c77845f011c7784b3b30002', '46', '4028827a238199d00123819a4fc2009c', '4028827a238199d00123819a4fa20095', 0);

		commit;
		
		update 
			script_audit 
		set
		    lastupdated=current_timestamp, status='FINISHED'
		where
		    scriptname='CarrierInitialData.sql' 
		and scriptversion= @scriptversion 
		and createdate = (select max(createdate) from script_audit where scriptname='CarrierInitialData.sql' and scriptversion=@scriptversion);
	end
end
Go