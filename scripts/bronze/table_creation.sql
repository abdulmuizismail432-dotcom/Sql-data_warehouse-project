/*
===========================================================
Create Table Structure & Data Type
===========================================================

	Script Purpose:This script is used to define the table & column structure and their data type.
	               Run this script to re-define the DDL structure of tables in the bronze schema.
	Caution : Existing tables with matching names will be dropped.
			  All data stored in those tables will be lost.
			  Back up important data before executing the script.
*/

--Extablish database context
USE DataWarehouseProject1;
GO

--Ensure  bronze schema exists
IF SCHEMA_ID ('bronze') IS NULL
	EXEC ('CREATE SCHEMA bronze');
GO

/*
-----------------------------------------------------------
Creating 3 Tables From CRM Source
-----------------------------------------------------------
*/
-- Drop customer info table if existed
IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
GO
-- Create a table for customer info
CREATE TABLE bronze.crm_cust_info(
	 cst_id INT
	,cst_key NVARCHAR(50)
	,cst_firstname NVARCHAR(50)
	,cst_lastname NVARCHAR(50)
	,cst_marital_status NVARCHAR(10)
	,cst_gndr NVARCHAR(10)
	,cst_create_date DATE
	);
GO

-- Drop product info table if existed
IF OBJECT_ID ('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
GO
-- Create a table for product info
CREATE TABLE bronze.crm_prd_info(
	 prd_id INT
	,prd_key NVARCHAR(50)
	,prd_nm NVARCHAR(50)
	,prd_cost INT
	,prd_line NVARCHAR(50)
	,prd_start_dt DATE
	,prd_end_dt DATE
);
GO

-- Drop sales details table if existed
IF OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
GO
-- Create a table for sales details
CREATE TABLE bronze.crm_sales_details (
	 sls_ord_num NVARCHAR (50)
	,sls_prd_key NVARCHAR (50)
	,sls_cust_id INT
	,sls_order_dt INT
	,sls_ship_dt INT
	,sls_due_dt INT
	,sls_sales INT
	,sls_quantity INT
	,sls_price INT
);
GO

/*
----------------------------------------------------------
Creating 3 Tables From the ERP Source
----------------------------------------------------------
*/
-- Drop additional customer info table if existed
IF OBJECT_ID ('bronze.erp_CUST_AZ12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_CUST_AZ12;
GO
-- Create a table for CUST_AZ12
CREATE TABLE bronze.erp_CUST_AZ12 (
	 CID NVARCHAR (50)
	,BDATE DATE
	,GEN NVARCHAR(20)
);
GO

-- Drop customer country info table if existed
IF OBJECT_ID ('bronze.erp_LOC_A101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_LOC_A101;
GO
-- Create a table for LOC_A101
CREATE TABLE bronze.erp_LOC_A101 (
	 CID NVARCHAR (50)
	,CNTRY NVARCHAR (20)
);
GO

-- Drop additional product info table if existed
IF OBJECT_ID ('bronze.erp_PX_CAT_G1V2', 'U') IS NOT NULL
	DROP TABLE bronze.erp_PX_CAT_G1V2;
GO
-- Create a table for PX_CAT_G1V2
CREATE TABLE bronze.erp_PX_CAT_G1V2 (
	 ID NVARCHAR (50)
	,CAT NVARCHAR (20)
	,SUBCAT NVARCHAR (30)
	,MAINTENANCE NVARCHAR (20)
);
GO

EXEC bronze.load_bronze;
GO