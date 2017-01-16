--------------------------------------------------------------------------------
-- Name    : CarrierInitialData.sql
-- Purpose : This script populates the carrier initial data for ClairMail OLTP .
-- Statement to execute this script from the shell:
-- [postgres]$ psql -f CarrierInitialData.sql <OLTP Database Name> -U <OLTP Database User>
-- For Example:
-- [postgres]$ psql -f CarrierInitialData.sql oltpdb -U oltpuser
--------------------------------------------------------------------------------

create or replace function check_for_carrierinitial_data() returns void as $$ 
declare 
	isExecuted integer;
	var_scriptversion varchar(30);
begin
	var_scriptversion='5.1.7';
    select count(*) into isExecuted from script_audit where scriptname='CarrierInitialData.sql' and scriptversion=var_scriptversion;
	if (isExecuted=1) then
		raise notice ' The CarrierInitialData.sql file is already executed once.Please contact your ClairMail System Administrator';
	else
		insert into script_audit
		select  current_timestamp as createdate,
			null as lastupdated,
			'CarrierInitialData.sql' as scriptname,
			var_scriptversion as scriptversion,
			user as osuser,
			current_user as currentuser,
			'hostname' as hostname,
			ip.* as ipaddress,
			issuperuser.* as dbauser,
			'OLTP Carrier Initial Data population script' as comments,
			'STARTED'
		from
			(select usesuper from pg_user where usename=current_user) as issuperuser,
			(select inet_client_addr()) as ip;

			-- Inserting into aggregator table
			insert into aggregator (aggregator_id, version, lastupdated, createdate, name, description, enabled) values ('4028827a238199d00123819a4fa20095', 0, current_timestamp, current_timestamp, 'Wau_Movil', 'aggregator for latin america', true);
			insert into aggregator (aggregator_id, version, lastupdated, createdate, name, description, enabled) values ('4028827a238199d00123819a4fa20096', 0, current_timestamp, current_timestamp, 'Verisign', 'aggregator for north america and Europe', false);
			insert into aggregator (aggregator_id, version, lastupdated, createdate, name, description, enabled) values ('4028827a238199d00123819a4fa20097', 0, current_timestamp, current_timestamp, 'M_BLOX', 'aggregator for north america', false);



			--- Inserting into carrier table
			insert into carrier (carrier_id, version, lastupdated, createdate, tenant_id, name, countrycode, description) values ('4028827a238199d00123819a4fb20098', 0, current_timestamp, current_timestamp, '402882311c77845f011c7784b3b30002', 'iusacell', 'MX', NULL);
			insert into carrier (carrier_id, version, lastupdated, createdate, tenant_id, name, countrycode, description) values ('4028827a238199d00123819a4fb2009a', 0, current_timestamp, current_timestamp, '402882311c77845f011c7784b3b30002', 'Movistar', 'MX', NULL);
			insert into carrier (carrier_id, version, lastupdated, createdate, tenant_id, name, countrycode, description) values ('4028827a238199d00123819a4fc2009c', 0, current_timestamp, current_timestamp, '402882311c77845f011c7784b3b30002', 'telcel', 'MX', NULL);


			-- Inserting into smppcarriercode table
			insert into smppcarriercode (carriercode_id, version, lastupdated, createdate, tenant_id, code, carrier_id, aggregator_id, listindex) values ('4028827a238199d00123819a4fb20099', 0, current_timestamp, current_timestamp, '402882311c77845f011c7784b3b30002', '40', '4028827a238199d00123819a4fb20098', '4028827a238199d00123819a4fa20095', 0);
			insert into smppcarriercode (carriercode_id, version, lastupdated, createdate, tenant_id, code, carrier_id, aggregator_id, listindex) values ('4028827a238199d00123819a4fb2009b', 0, current_timestamp, current_timestamp, '402882311c77845f011c7784b3b30002', '50', '4028827a238199d00123819a4fb2009a', '4028827a238199d00123819a4fa20095', 0);
			insert into smppcarriercode (carriercode_id, version, lastupdated, createdate, tenant_id, code, carrier_id, aggregator_id, listindex) values ('4028827a238199d00123819a4fc2009d', 0, current_timestamp, current_timestamp, '402882311c77845f011c7784b3b30002', '46', '4028827a238199d00123819a4fc2009c', '4028827a238199d00123819a4fa20095', 0);

			update 
				script_audit 
			set
			    lastupdated=current_timestamp, status='FINISHED'
			where
			    scriptname='CarrierInitialData.sql' 
			and scriptversion= var_scriptversion 
			and createdate=greatest(createdate);
	end if;
end;
$$ language plpgsql;

select check_for_carrierinitial_data();
drop function check_for_carrierinitial_data();
