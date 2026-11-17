/*
==============================================================================
Create Database and Schema
==============================================================================

	Script Purpose:
		This script checks if there is an existence of the database "DataWarehouseProject1", if it exists,
		the database will be dropped including all it's content entirely, then it will be recreated. Subsequently,
		the script sets up 3 schemas within the database, namely: "bronze", "silver" and "gold"

	Caution:
		This script must be run with caution to avoid data loss as all info will be deleted, 
		therefore it is advisable to have a backup data for all content before executing the script
*/

USE master;
GO

--Checks if a previous database exists 
IF DB_ID('DataWarehouseProject1') IS NOT NULL
--Drops if it exist
	BEGIN
		ALTER DATABASE DataWarehouseProject1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE DataWarehouseProject1
	END;
	GO

-- creating a new database
CREATE DATABASE DataWarehouseProject1
GO

-- access the newly created database
USE DataWarehouseProject1;
GO

-- create schema - bronze

CREATE SCHEMA bronze;
GO

-- create schema - silver

CREATE SCHEMA silver;
GO

-- create schema - gold

CREATE SCHEMA gold;
GO