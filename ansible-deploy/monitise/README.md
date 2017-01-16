MVP Deployment Scripts
=======================

This repository contains Ansible scripts which are designed to manage MVP
software on CentOS6/RHEL6 systems.  They are intended to be reused across QA,
Engineering, and Deployment.

Ansible is a tool which executes tasks on remote machines over SSH (or on the
local system directly).  Tasks and related resources are organized into "roles"
(i.e. roles/sjre7).  The user executes an Ansible "playbook" file (i.e.
setup-system.yml), which defines a set of roles to be applied to a set of
hosts.  Hosts are defined in an "inventory" file (i.e. qa/hosts), which can
bring in variables from other files relative to it.

Ansible documentation: http://docs.ansible.com

Getting Started
----------------

1. Install Ansible, preferrably via OS package manager (yum for CentOS/RHEL); see
   http://docs.ansible.com/intro_installation.html#installing-the-control-machine 
2. Copy local.yml.example to local.yml and customize it.
3. Setup an inventory file.  At a minimum, this will need to define three
   groups (mvp, mvp-frontend, mvp-backend) and a number of variables depending on
   which scripts you are executing.
4. Read and execute setup-system.yml, then setup-backend/frontend.yml to
   prepare a CentOS6/RHEL6 system for deployment.
5. Read and execute your favorite deployment playbooks.  QA vanilla deployment
   playbooks live within qa/ and are a good place to start.  Since deployment
   playbooks utilize many variables, it is recommended to start from an existing
   set of inventory/variable files (i.e. qa/hosts and qa/host_vars/*).


Variables
---------------

Variables drive a lot of Ansible tasks.  These are the minimum variables
required by the top-level scripts:

instance: the user (+ cm prefix) on the target system where software will be installed
instance_pasword: password for cm{{ instanece }} user
monitise_root: home folder of instance user and root of all MVP software installation
batch_data: root folder used by MVP batch processor
disco_enabled: true/false - enable mblox download script
disco_user/disco_password: account used to connect to mblox
disco_root: home folder of disco user, where files are downloaded to
disco_ftp_pass: password for local disco ftp account used by CMS
disco_processed: folder where CMS stores processed files
backup_root: root folder to store large binaries such as software builds
backup_applications: folder to store backups of application deployments
backup_logs: folder to store backups of logs
hqdata_root: root folder where hornetq data is stored
redis_master: hostname/ip of the redis master server
redis_password: password used for redis authentication
smppsim_enabled: yes/no - install/enable smppsim service

