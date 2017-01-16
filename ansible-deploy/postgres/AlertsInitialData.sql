--------------------------------------------------------------------------------
-- Name    : AlertsInitialData.sql
-- Purpose : This script populates the initial data for ClairMail OLTP .
-- Statement to execute this script from the shell:
-- [postgres]$ psql -f AlertsInitialData.sql <OLTP Database Name> -U <OLTP Database User>
-- For Example:
-- [postgres]$ psql -f AlertsInitialData.sql oltpdb -U oltpuser
--------------------------------------------------------------------------------

create or replace function check_for_alertinitial_data() returns void as $$ 
declare 
        isExecuted integer;
        var_scriptversion varchar(30);
begin
        var_scriptversion='5.1.7';
    select count(*) into isExecuted from script_audit where scriptname='AlertsInitialData.sql' and scriptversion=var_scriptversion;
        if (isExecuted=1) then
                raise notice ' The AlertsInitialData.sql file is already executed once.Please contact your ClairMail System Administrator';
        else
                insert into script_audit
                select  current_timestamp as createdate,
                        null as lastupdated,
                        'AlertsInitialData.sql' as scriptname,
                        var_scriptversion as scriptversion,
                        user as osuser,
                        current_user as currentuser,
                        'hostname' as hostname,
                        ip.* as ipaddress,
                        issuperuser.* as dbauser,
                        'OLTP Alert Initial Data population script' as comments,
                        'STARTED'
                from
                        (select usesuper from pg_user where usename=current_user) as issuperuser,
                        (select inet_client_addr()) as ip;

                        -- Inserting into alerttype table
                        insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id, description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey , textEmailTemplateKey, validationtemplatekey) VALUES ('4028821419962c370119962c6ed3000e', 0, current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'Low Balance', 'lowBal.message.template','lowBal.from', 'lowBal.subject', 'lowBal.rule.template', 'namespace.key.alertSrc', 'lowBal.email.template' , 'lowBal.text.email.template', 'lowBal.validation.template');
                        insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id,  description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey, textEmailTemplateKey, validationtemplatekey) VALUES ('4028821419962c370119962c6ee2000f', 0, current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'Statement Available', 'statementAvailable.message.template','statementAvailable.from', 'statementAvailable.subject', 'statementAvailable.rule.template', 'namespace.key.alertSrc', 'statementAvailable.email.template','statementAvailable.text.email.template', null );
                        insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id,  description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey , textEmailTemplateKey, validationtemplatekey) VALUES ('4028821419962c370119962c6ee20010', 0,current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'Withdrawal Threshold Exceeded', 'withdrawalThresholdExceeded.message.template','withdrawalThresholdExceeded.from', 'withdrawalThresholdExceeded.subject', 'withdrawalThresholdExceeded.rule.template', 'namespace.key.alertSrc', 'withdrawalThresholdExceeded.email.template', 'withdrawalThresholdExceeded.text.email.template', 'withdrawalThresholdExceeded.validation.template');
                        insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id,  description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey, textEmailTemplateKey, validationtemplatekey) VALUES ('4028821419962c370119962c6ef20011', 0, current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'Deposit Confirmation', 'depositConfirmation.message.template','depositConfirmation.from', 'depositConfirmation.subject', 'depositConfirmation.rule.template', 'namespace.key.alertSrc', 'depositConfirmation.email.template', 'depositConfirmation.text.email.template', null );
                        insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id,  description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey, textEmailTemplateKey, validationtemplatekey) VALUES ('4028821419962c370119962c6f020012', 0,current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'Overdraft Posted', 'overdraftPosted.message.template', 'overdraftPosted.from', 'overdraftPosted.subject', 'overdraftPosted.rule.template', 'namespace.key.alertSrc', 'overdraftPosted.email.template', 'overdraftPosted.text.email.template', null);
                        insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id,  description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey, textEmailTemplateKey, validationtemplatekey) VALUES ('4028821419962c370119962c6f020013', 0, current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'Check Cleared', 'checkCleared.message.template', 'checkCleared.from', 'checkCleared.subject', 'checkCleared.rule.template', 'namespace.key.alertSrc', 'checkCleared.email.template', 'checkCleared.text.email.template', null);
                        insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id,  description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey, textEmailTemplateKey, validationtemplatekey) VALUES ('4028821419962c370119962c6f110014', 0, current_timestamp,current_timestamp,'402882311c77845f011c7784b3b30002', 'Withdrawal Confirmation', 'withdrawalConfirmation.message.template','withdrawalConfirmation.from', 'withdrawalConfirmation.subject', 'withdrawalConfirmation.rule.template', 'namespace.key.alertSrc', 'withdrawalConfirmation.email.template' , 'withdrawalConfirmation.text.email.template', null );
                        insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id,  description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey, textEmailTemplateKey, validationtemplatekey) VALUES ('402882431e23a835011e23a875170016', 0, current_timestamp,current_timestamp,'402882311c77845f011c7784b3b30002', 'Send Notification', 'lockBox.message.template','lockBox.from', 'lockBox.subject', 'lockBox.rule.template', 'namespace.key.conv', 'lockBox.email.template' , 'lockBox.text.email.template', null); 
                        insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id,  description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey, textEmailTemplateKey, validationtemplatekey) VALUES ('5D5762A86A6F4E69B8C11EE5050F0E72', 0, current_timestamp,current_timestamp,'402882311c77845f011c7784b3b30002', 'Transaction Verification', 'transactionVerification.message.template','transactionVerification.from', 'transactionVerification.subject', 'transactionVerification.rule.template', 'namespace.key.conv', 'transactionVerification.email.template' , 'transactionVerification.text.email.template', null); 
                        insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id,  description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey, textEmailTemplateKey, validationtemplatekey) VALUES ('402882431e23a835011e23a875170017', 0, current_timestamp,current_timestamp,'402882311c77845f011c7784b3b30002', 'Send Lockbox Notification', 'lockBoxImplNotice.message.template','lockBoxImplNotice.from', 'lockBoxImplNotice.subject', 'lockBoxImplNotice.rule.template', 'namespace.key.conv', 'lockBoxImplNotice.email.template' , 'lockBoxImplNotice.text.email.template', null); 
                        insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id,  description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey, textEmailTemplateKey, validationtemplatekey) VALUES ('402882431e23a835011e23a875170018', 0, current_timestamp,current_timestamp,'402882311c77845f011c7784b3b30002', 'Send Lockbox Response', 'lockBoxImplResponse.message.template','lockBoxImplResponse.from', 'lockBoxImplResponse.subject', 'lockBoxImplResponse.rule.template', 'namespace.key.conv', 'lockBoxImplResponse.email.template' , 'lockBoxImplResponse.text.email.template', null); 
                        insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id,  description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey, textEmailTemplateKey, validationtemplatekey) VALUES ('4028827a213103ab0121310434aa008c', 0, current_timestamp,current_timestamp,'402882311c77845f011c7784b3b30002', 'Overdraft Protection', 'overdraftProtection.message.template', 'overdraftProtection.from', 'overdraftProtection.subject', 'overdraftProtection.rule.template', 'namespace.key.conv', 'overdraftProtection.email.template' , 'overdraftProtection.text.email.template', null); 
                        insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id, description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey , textEmailTemplateKey, validationtemplatekey) VALUES ('4028821419962c370119962c6ed30029', 0, current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'Username Changed', 'usernameChanged.message.template','usernameChanged.from', 'usernameChanged.subject', 'usernameChanged.rule.template', 'namespace.key.alertSrc', 'usernameChanged.email.template' , 'usernameChanged.text.email.template', null);
                        insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id, description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey , textEmailTemplateKey, validationtemplatekey) VALUES ('4028821419962c370119962c6ed30030', 0, current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'Password Changed', 'passwordChanged.message.template','passwordChanged.from', 'passwordChanged.subject', 'passwordChanged.rule.template', 'namespace.key.alertSrc', 'passwordChanged.email.template' , 'passwordChanged.text.email.template', null);
                        insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id, description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey , textEmailTemplateKey, validationtemplatekey) VALUES ('4028821419962c370119962c6ed30031', 0, current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'Account Locked', 'accountLocked.message.template','accountLocked.from', 'accountLocked.subject', 'accountLocked.rule.template', 'namespace.key.alertSrc', 'accountLocked.email.template' , 'accountLocked.text.email.template', null);                        
                        insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id, description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey , textEmailTemplateKey, validationtemplatekey) VALUES ('4028821419962c370119962c6ed30032', 0, current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'Account Unlocked', 'accountUnlocked.message.template','accountUnlocked.from', 'accountUnlocked.subject', 'accountUnlocked.rule.template', 'namespace.key.alertSrc', 'accountUnlocked.email.template' , 'accountUnlocked.text.email.template', null);
                       
                        --- Inserting into alertreferencetype table
                        insert into alertreferencetype (alert_reference_type_id, version, lastUpdated, createDate, tenant_id, description) VALUES ('4028821419962c370119962c6f110015' , 0, current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'account');
                        insert into alertreferencetype (alert_reference_type_id, version, lastUpdated, createDate, tenant_id, description) VALUES ('4028821419962c370119962c6f210016' , 0, current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'user');

insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id, description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey , textEmailTemplateKey, validationtemplatekey) VALUES ('4028821419962c370119962c6ed30033', 0, current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'Recurring Transfer Setup', 'recurringTransferSetup.message.template','recurringTransferSetup.from', 'recurringTransferSetup.subject', 'recurringTransferSetup.rule.template', 'namespace.key.alertSrc', 'recurringTransferSetup.email.template' , 'recurringTransferSetup.text.email.template', null);                        
insert into alerttype (alert_type_id, version, lastUpdated, createDate, tenant_id, description, messageTemplateKey, fromKey, subjectKey, ruleTemplateKey, namespaceKey, emailTemplateKey , textEmailTemplateKey, validationtemplatekey) VALUES ('4028821419962c370119962c6ed30034', 0, current_timestamp,current_timestamp, '402882311c77845f011c7784b3b30002', 'Contact Information Changed', 'contactInformationChanged.message.template','contactInformationChanged.from', 'contactInformationChanged.subject', 'contactInformationChanged.rule.template', 'namespace.key.alertSrc', 'contactInformationChanged.email.template' , 'contactInformationChanged.text.email.template', null);                        
insert into alerttype (alert_type_id, version, lastupdated, createdate, tenant_id, description, messagetemplatekey, fromkey, subjectkey, ruletemplatekey, namespacekey, emailtemplatekey, textemailtemplatekey)  VALUES ( '4028821419962c370119962c6ed30035',0,	current_timestamp, current_timestamp,'402882311c77845f011c7784b3b30002','New Payee Added','newPayeeAdded.message.template','newPayeeAdded.from','newPayeeAdded.subject','newPayeeAdded.rule.template','namespace.key.alertSrc',	'newPayeeAdded.email.template',	'newPayeeAdded.text.email.template');
insert into alerttype (alert_type_id, version, lastupdated, createdate, tenant_id, description, messagetemplatekey, fromkey, subjectkey, ruletemplatekey, namespacekey, emailTemplatekey, textemailtemplatekey, validationtemplatekey)  VALUES ( '4028821419962c370119962c6ed30036',0,	current_timestamp, current_timestamp,'402882311c77845f011c7784b3b30002','Payment Threshold Exceeded','paymentThresholdExceeded.message.template','paymentThresholdExceeded.from','paymentThresholdExceeded.subject','paymentThresholdExceeded.rule.template','namespace.key.alertSrc',	'paymentThresholdExceeded.email.template',	'paymentThresholdExceeded.text.email.template', 'paymentThresholdExceeded.validation.template');
insert into alerttype (alert_type_id, version, lastupdated, createdate, tenant_id, description, messagetemplatekey, fromkey, subjectkey, ruletemplatekey, namespacekey, emailtemplatekey, textemailtemplatekey)  VALUES ( '4028821419962c370119962c6ed30037',0,	current_timestamp, current_timestamp,'402882311c77845f011c7784b3b30002','Card Not Present','cardNotPresent.message.template','cardNotPresent.from','cardNotPresent.subject','cardNotPresent.rule.template','namespace.key.conv','cardNotPresent.email.template','cardNotPresent.text.email.template');
insert into alerttype (alert_type_id, version, lastupdated, createdate, tenant_id, description, messagetemplatekey, fromkey, subjectkey, ruletemplatekey, namespacekey, emailtemplatekey, textemailtemplatekey)  VALUES ( '4028821419962c370119962c6ed30038',0,	current_timestamp, current_timestamp,'402882311c77845f011c7784b3b30002','Declined Transaction','declinedTransaction.message.template','declinedTransaction.from','declinedTransaction.subject','declinedTransaction.rule.template','namespace.key.conv','declinedTransaction.email.template','declinedTransaction.text.email.template');
insert into alerttype (alert_type_id, version, lastupdated, createdate, tenant_id, description, messagetemplatekey, fromkey, subjectkey, ruletemplatekey, namespacekey, emailtemplatekey, textemailtemplatekey)  VALUES ( '4028821419962c370119962c6ed30039',0,	current_timestamp, current_timestamp,'402882311c77845f011c7784b3b30002','Pay At The Pump','payAtThePump.message.template','payAtThePump.from','payAtThePump.subject','payAtThePump.rule.template','namespace.key.conv','payAtThePump.email.template','payAtThePump.text.email.template');
insert into alerttype (alert_type_id, version, lastupdated, createdate, tenant_id, description, messagetemplatekey, fromkey, subjectkey, ruletemplatekey, namespacekey, emailtemplatekey, textemailtemplatekey)  VALUES ( '4028821419962c370119962c6ed3003a',0,	current_timestamp, current_timestamp,'402882311c77845f011c7784b3b30002','Foreign Country Transaction','foreignCountryTransaction.message.template','foreignCountryTransaction.from','foreignCountryTransaction.subject','foreignCountryTransaction.rule.template','namespace.key.conv','foreignCountryTransaction.email.template','foreignCountryTransaction.text.email.template');
insert into alerttype (alert_type_id, version, lastupdated, createdate, tenant_id, description, messagetemplatekey, fromkey, subjectkey, ruletemplatekey, namespacekey, emailtemplatekey, textemailtemplatekey, validationtemplatekey)  VALUES ( '4028821419962c370119962c6ed3003b',0,	current_timestamp, current_timestamp,'402882311c77845f011c7784b3b30002','ATM Threshold Exceeded','exceededThresholdAtAtm.message.template','exceededThresholdAtAtm.from','exceededThresholdAtAtm.subject','exceededThresholdAtAtm.rule.template','namespace.key.conv','exceededThresholdAtAtm.email.template','exceededThresholdAtAtm.text.email.template', 'exceededThresholdAtAtm.validation.template');
insert into alerttype (alert_type_id, version, lastupdated, createdate, tenant_id, description, messagetemplatekey, fromkey, subjectkey, ruletemplatekey, namespacekey, emailtemplatekey, textemailtemplatekey, validationtemplatekey)  VALUES ( '4028821419962c370119962c6ed3003c',0,	current_timestamp, current_timestamp,'402882311c77845f011c7784b3b30002','Withdrawal Threshold Exceeded Actionable','withdrawalThresholdExceededActionable.message.template','withdrawalThresholdExceededActionable.from','withdrawalThresholdExceededActionable.subject','withdrawalThresholdExceededActionable.rule.template','namespace.key.conv','withdrawalThresholdExceededActionable.email.template','withdrawalThresholdExceededActionable.text.email.template', 'withdrawalThresholdExceededActionable.validation.template');
insert into alerttype (alert_type_id, version, lastupdated, createdate, tenant_id, description, messagetemplatekey, fromkey, subjectkey, ruletemplatekey, namespacekey, emailtemplatekey, textemailtemplatekey)  VALUES ( '4028821419962c370119962c6ed3003d',0,	current_timestamp, current_timestamp,'402882311c77845f011c7784b3b30002','Transaction Notification FI Defined Level 1','transactionVerificationFI1.message.template','transactionVerificationFI1.from','transactionVerificationFI1.subject','transactionVerificationFI1.rule.template','namespace.key.conv','transactionVerificationFI1.email.template','transactionVerificationFI1.text.email.template');
insert into alerttype (alert_type_id, version, lastupdated, createdate, tenant_id, description, messagetemplatekey, fromkey, subjectkey, ruletemplatekey, namespacekey, emailtemplatekey, textemailtemplatekey, validationtemplatekey)  VALUES ( '4028821419962c370119962c6ed3003e',0,	current_timestamp, current_timestamp,'402882311c77845f011c7784b3b30002','Transaction Notification User Defined Level 1','transactionVerificationUserLevel1.message.template','transactionVerificationUserLevel1.from','transactionVerificationUserLevel1.subject','transactionVerificationUserLevel1.rule.template','namespace.key.conv','transactionVerificationUserLevel1.email.template','transactionVerificationUserLevel1.text.email.template', 'transactionVerificationUserLevel1.validation.template');
insert into alerttype (alert_type_id, version, lastupdated, createdate, tenant_id, description, messagetemplatekey, fromkey, subjectkey, ruletemplatekey, namespacekey, emailtemplatekey, textemailtemplatekey)  VALUES ( '4028821419962c370119962c6ed3003f',0,	current_timestamp, current_timestamp,'402882311c77845f011c7784b3b30002','Transaction Notification FI Defined Level 2','transactionVerificationFI2.message.template','transactionVerificationFI2.from','transactionVerificationFI2.subject','transactionVerificationFI2.rule.template','namespace.key.conv','transactionVerificationFI2.email.template','transactionVerificationFI2.text.email.template');
insert into alerttype (alert_type_id, version, lastupdated, createdate, tenant_id, description, messagetemplatekey, fromkey, subjectkey, ruletemplatekey, namespacekey, emailtemplatekey, textemailtemplatekey)  VALUES ( '4028821419962c370119962c6ed30040',0,	current_timestamp, current_timestamp,'402882311c77845f011c7784b3b30002','Transaction Notification FI Defined Level 3','transactionVerificationFI3.message.template','transactionVerificationFI3.from','transactionVerificationFI3.subject','transactionVerificationFI3.rule.template','namespace.key.conv','transactionVerificationFI3.email.template','transactionVerificationFI3.text.email.template');
insert into alerttype (alert_type_id, version, lastupdated, createdate, tenant_id, description, messagetemplatekey, fromkey, subjectkey, ruletemplatekey, namespacekey, emailtemplatekey, textemailtemplatekey, validationtemplatekey)  VALUES ( '4028821419962c370119962c6ed30041',0,	current_timestamp, current_timestamp,'402882311c77845f011c7784b3b30002','Transaction Notification User Defined Level 2','transactionVerificationUserLevel2.message.template','transactionVerificationUserLevel2.from','transactionVerificationUserLevel2.subject','transactionVerificationUserLevel2.rule.template','namespace.key.conv','transactionVerificationUserLevel2.email.template','transactionVerificationUserLevel2.text.email.template', 'transactionVerificationUserLevel2.validation.template');
insert into alerttype (alert_type_id, version, lastupdated, createdate, tenant_id, description, messagetemplatekey, fromkey, subjectkey, ruletemplatekey, namespacekey, emailtemplatekey, textemailtemplatekey, validationtemplatekey)  VALUES ( '4028821419962c370119962c6ed30042',0,	current_timestamp, current_timestamp,'402882311c77845f011c7784b3b30002','Transaction Notification User Defined Level 3','transactionVerificationUserLevel3.message.template','transactionVerificationUserLevel3.from','transactionVerificationUserLevel3.subject','transactionVerificationUserLevel3.rule.template','namespace.key.conv','transactionVerificationUserLevel3.email.template','transactionVerificationUserLevel3.text.email.template', 'transactionVerificationUserLevel3.validation.template');
                   
                        
                        update 
                                script_audit 
                        set
                            lastupdated=current_timestamp, status='FINISHED'
                        where
                            scriptname='AlertsInitialData.sql' 
                        and scriptversion= var_scriptversion 
                        and createdate=greatest(createdate);
        end if;
end;
$$ language plpgsql;

select check_for_alertinitial_data();
drop function check_for_alertinitial_data();
