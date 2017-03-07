----------------------------------------------------------------------------
-- Name    : crdb.sql 
-- Purpose : This script creates ClairMail Transaction Database 
-- Version : 5.1.7
-- Steps to execute the script from command line:
-- C:> sqlcmd -S IPAddress\InstanceName -d master -U superusername -P superuserpassword -v oltpdb="OLTPDataBaseName" oltpfilepath="DataFilePath" oltplogfilepath="LogFilePath" oltpuser="OLTPUser" oltppasswd="OLTPPassword" -i crdb_NP.sql
-- For Example:
-- C:> sqlcmd -S 188.1.1.0\CLAIRMAILDB -d master -U sa -P sa -v oltpdb="clairdb" oltpfilepath="F:\MSSQL\data" oltplogfilepath="F:\MSSQL\data" oltpuser="testoltpuser" oltppasswd="testoltppass" -i crdb_NP.sql
----------------------------------------------------------------------------

USE [master]
GO
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'$(oltpdb)')
BEGIN
create database [$(oltpdb)] on primary 
( name = '$(oltpdb)', filename = '$(oltpfilepath)\$(oltpdb).mdf' , SIZE = 100MB , MAXSIZE = UNLIMITED, FILEGROWTH = 20MB) 
 log on 
( name = '$(oltpdb)_log', filename = '$(oltplogfilepath)\$(oltpdb)_log.ldf' , SIZE = 20MB , MAXSIZE = 2GB, FILEGROWTH = 20MB)
 collate sql_latin1_general_cp1_ci_as
END
go

ALTER DATABASE [$(oltpdb)] SET ANSI_NULL_DEFAULT OFF 
ALTER DATABASE [$(oltpdb)] SET ANSI_NULLS OFF 
ALTER DATABASE [$(oltpdb)] SET ANSI_PADDING OFF 
ALTER DATABASE [$(oltpdb)] SET ANSI_WARNINGS OFF 
ALTER DATABASE [$(oltpdb)] SET ARITHABORT OFF 
ALTER DATABASE [$(oltpdb)] SET AUTO_CLOSE OFF 
ALTER DATABASE [$(oltpdb)] SET AUTO_CREATE_STATISTICS ON 
ALTER DATABASE [$(oltpdb)] SET AUTO_SHRINK OFF 
ALTER DATABASE [$(oltpdb)] SET AUTO_UPDATE_STATISTICS ON 
ALTER DATABASE [$(oltpdb)] SET CURSOR_CLOSE_ON_COMMIT OFF 
ALTER DATABASE [$(oltpdb)] SET CURSOR_DEFAULT  GLOBAL 
ALTER DATABASE [$(oltpdb)] SET CONCAT_NULL_YIELDS_NULL OFF 
ALTER DATABASE [$(oltpdb)] SET NUMERIC_ROUNDABORT OFF 
ALTER DATABASE [$(oltpdb)] SET QUOTED_IDENTIFIER OFF 
ALTER DATABASE [$(oltpdb)] SET RECURSIVE_TRIGGERS OFF 
ALTER DATABASE [$(oltpdb)] SET  ENABLE_BROKER 
ALTER DATABASE [$(oltpdb)] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
ALTER DATABASE [$(oltpdb)] SET DATE_CORRELATION_OPTIMIZATION OFF 
ALTER DATABASE [$(oltpdb)] SET TRUSTWORTHY OFF 
ALTER DATABASE [$(oltpdb)] SET ALLOW_SNAPSHOT_ISOLATION ON
ALTER DATABASE [$(oltpdb)] SET PARAMETERIZATION SIMPLE 
ALTER DATABASE [$(oltpdb)] SET READ_COMMITTED_SNAPSHOT ON
ALTER DATABASE [$(oltpdb)] SET HONOR_BROKER_PRIORITY OFF 
ALTER DATABASE [$(oltpdb)] SET  READ_WRITE 
ALTER DATABASE [$(oltpdb)] SET RECOVERY FULL 
ALTER DATABASE [$(oltpdb)] SET  MULTI_USER 
ALTER DATABASE [$(oltpdb)] SET PAGE_VERIFY CHECKSUM  
ALTER DATABASE [$(oltpdb)] SET DB_CHAINING OFF 
GO


IF NOT EXISTS (select * from sys.filegroups where name = '$(oltpdb)_data')
	ALTER DATABASE [$(oltpdb)] ADD FILEGROUP [$(oltpdb)_data] 


IF NOT EXISTS (select * from sys.filegroups where name = '$(oltpdb)_index')
	ALTER DATABASE [$(oltpdb)] ADD FILEGROUP [$(oltpdb)_index] 

ALTER DATABASE [$(oltpdb)] ADD FILE 
	( NAME = N'$(oltpdb)CLAIR_DATA_01.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_DATA_01.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED,FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_DATA_02.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_DATA_02.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED, FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_DATA_03.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_DATA_03.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED, FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_DATA_04.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_DATA_04.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED, FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_DATA_05.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_DATA_05.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED, FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_DATA_06.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_DATA_06.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED, FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_DATA_07.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_DATA_07.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED, FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_DATA_08.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_DATA_08.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED,FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_DATA_09.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_DATA_09.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED,FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_DATA_10.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_DATA_10.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED,FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_DATA_11.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_DATA_11.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED,FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_DATA_12.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_DATA_12.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED,FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_DATA_13.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_DATA_13.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED,FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_DATA_14.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_DATA_14.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED,FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_DATA_15.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_DATA_15.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED,FILEGROWTH = 2MB )
	
TO FILEGROUP [$(oltpdb)_data]


ALTER DATABASE [$(oltpdb)] ADD FILE 
	( NAME = N'$(oltpdb)CLAIR_INDEX_01.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_INDEX_01.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED,FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_INDEX_02.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_INDEX_02.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED, FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_INDEX_03.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_INDEX_03.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED, FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_INDEX_04.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_INDEX_04.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED, FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_INDEX_05.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_INDEX_05.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED, FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_INDEX_06.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_INDEX_06.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED, FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_INDEX_07.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_INDEX_07.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED, FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_INDEX_08.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_INDEX_08.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED, FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_INDEX_09.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_INDEX_09.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED, FILEGROWTH = 2MB ),
	( NAME = N'$(oltpdb)CLAIR_INDEX_10.ndf', FILENAME = N'$(oltpfilepath)\$(oltpdb)CLAIR_INDEX_10.ndf',SIZE = 10MB,MAXSIZE=UNLIMITED, FILEGROWTH = 2MB )
	
TO FILEGROUP [$(oltpdb)_index]


ALTER DATABASE [$(oltpdb)] MODIFY FILEGROUP [$(oltpdb)_data] default

IF	NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N'$(oltpuser)')
	CREATE LOGIN [$(oltpuser)] 
	WITH PASSWORD=N'$(oltppasswd)', 
	DEFAULT_DATABASE=[$(oltpdb)], 
	DEFAULT_LANGUAGE=[us_english], 
	CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF

grant view server state to $(oltpuser) 

use [msdb]
create user [$(oltpuser)] for login [$(oltpuser)]
exec sp_addrolemember 'SQLAgentOperatorRole','$(oltpuser)'
alter user [$(oltpuser)] with default_schema=[SQLAgentOperatorRole]
alter authorization on schema::[SQLAgentUserRole] to [$(oltpuser)]
alter authorization on schema::[SQLAgentOperatorRole] to [$(oltpuser)]
alter authorization on schema::[SQLAgentReaderRole] to [$(oltpuser)]
go

USE [$(oltpdb)]
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'$(oltpuser)')
	CREATE USER [$(oltpuser)] FOR LOGIN [$(oltpuser)] 

exec sp_addrolemember 'db_owner', '$(oltpuser)'