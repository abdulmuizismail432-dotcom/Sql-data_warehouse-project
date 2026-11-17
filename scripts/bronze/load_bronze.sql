/*
	 =====================================================================================================================================
	                                'Loading Source Files (Data) to their respective table
	 =====================================================================================================================================
	 Script Purpose: This script truncate all tables, then load data from the source file to bronze schema, which embody 6 tables that
	                 contain the customer, product and sales information. Additionally, it calculate the load time for each and the whole
					 table.
	 Warning: Source data files must be stored securely and shouldn't be tampered with, as all tables are truncated before recreation.
	 -------------------------------------------------------------------------------------------------------------------------------------
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		PRINT '================================================================';
		PRINT '>> Loading to Bronze Table';
		PRINT '================================================================';
		PRINT '                                                                                                                           ';

		PRINT '----------------------------------------------------------------';
        PRINT ' >> Load Tables from CRM Source';
		PRINT '----------------------------------------------------------------';

		PRINT '>> Clearing all data from table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		SET @batch_start_time = GETDATE()
		PRINT '>> Inserting data to: bronze.crm_cust_info';
		SET @start_time = GETDATE()
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\ADMIN\Documents\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			MAXERRORS = 0,
			TABLOCK
			  );
		SET @end_time = GETDATE()
        PRINT 'bronze.crm_cust_info Table Load Duration = ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '----------------------------------------------------------------';

		PRINT '>> Clearing all data from table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting data to: bronze.crm_prd_info';
		SET @start_time = GETDATE()
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\ADMIN\Documents\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			MAXERRORS = 0,
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT 'bronze.crm_prd_info Table Load Duration = ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '----------------------------------------------------------------';

		PRINT '>> Clearing all data from table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting data to: bronze.crm_sales_details';
		SET @start_time = GETDATE()
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\ADMIN\Documents\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			MAXERRORS = 0,
			TABLOCK
		);
		SET @end_time = GETDATE()
		PRINT 'bronze.crm_sales_details Table Load Duration = ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '                                                                                                                           ';

		PRINT '----------------------------------------------------------------';
		PRINT ' >> Load Tables from ERP Source';
		PRINT '----------------------------------------------------------------';

		PRINT '>> Clearing all data from table: bronze.erp_CUST_AZ12';
		TRUNCATE TABLE bronze.erp_CUST_AZ12;

		PRINT '>> Inserting data to: bronze.erp_CUST_AZ12';
		SET @start_time = GETDATE()
		BULK INSERT bronze.erp_CUST_AZ12
		FROM 'C:\Users\ADMIN\Documents\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			MAXERRORS = 0,
			TABLOCK
			  );
		SET @end_time = GETDATE()
        PRINT 'bronze.erp_CUST_AZ12 Table Load Duration = ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '----------------------------------------------------------------';

		PRINT '>> Clearing all data from table: bronze.erp_LOC_A101';
		TRUNCATE TABLE bronze.erp_LOC_A101;

		PRINT '>> Inserting data to: bronze.erp_LOC_A101';
		SET @start_time = GETDATE()
		BULK INSERT bronze.erp_LOC_A101
		FROM 'C:\Users\ADMIN\Documents\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			MAXERRORS = 0,
			TABLOCK
			  );
		SET @end_time = GETDATE()
        PRINT 'bronze.erp_LOC_A101 Table Load Duration = ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';

		PRINT '----------------------------------------------------------------';

		PRINT '>> Inserting data to: bronze.erp_PX_CAT_G1V2';
		SET @start_time = GETDATE()
		BULK INSERT bronze.erp_PX_CAT_G1V2
		FROM 'C:\Users\ADMIN\Documents\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			MAXERRORS = 0,
			TABLOCK
			  );
		SET @end_time = GETDATE()
		SET @batch_end_time = GETDATE()
        PRINT 'bronze.erp_PX_CAT_G1V2 Table Load Duration = ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '----------------------------------------------------------------';
		PRINT '                                                                ';
		PRINT 'Total Load Duration for all Data = ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
	END TRY
	BEGIN CATCH
	    PRINT '======================================================================================';
		PRINT '>> Error Occured '
		PRINT '======================================================================================';
		PRINT '                                                                ';
		PRINT '--------------------------------------------------------------------------------------';
		PRINT 'Error Message: ' + ERROR_MESSAGE()
		PRINT 'Error Line: ' + CAST (ERROR_LINE() AS NVARCHAR)
        PRINT '--------------------------------------------------------------------------------------';
	END CATCH
END