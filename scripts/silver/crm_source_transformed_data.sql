/*
================================================================
      Loading of transformed data to silver.crm_cust_info
================================================================
*/
--Insert the customer info data inside silver.crm_cust_info
TRUNCATE TABLE silver.crm_cust_info
INSERT INTO silver.crm_cust_info (
                                  cst_id
                                 ,cst_key
                                 ,cst_firstname
                                 ,cst_lastname
                                 ,cst_marital_status
                                 ,cst_gndr
                                 ,cst_create_date 
                                 )
SELECT [cst_id]
      ,[cst_key]
      ,TRIM ([cst_firstname]) AS cst_firstname
      ,TRIM ([cst_lastname]) AS cst_lastname
      ,CASE UPPER(TRIM(cst_marital_status))
          WHEN  'M' THEN 'Married'
          WHEN  'S' THEN 'Single' 
          ELSE 'n/a'
       END AS cst_marital_status
      ,CASE UPPER(TRIM(cst_gndr))
          WHEN 'M' THEN 'Male'
          WHEN 'F' THEN 'Female'
          ELSE 'n/a'
       END AS cst_gndr
      ,[cst_create_date]

FROM (
        SELECT *,
        ROW_NUMBER () OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS dublicate_flag
        FROM bronze.crm_cust_info 
        WHERE cst_id IS NOT NULL
     )q
WHERE dublicate_flag = 1
GO

/*
================================================================
      Loading of transformed data to silver.crm_prd_info
================================================================
*/

--Inserting transformed data into silver.crm_prd_info
TRUNCATE TABLE silver.crm_prd_info
INSERT INTO silver.crm_prd_info(
     prd_id
    ,prd_key
    ,sub_cat_id
    ,sales_prd_key
	,prd_nm
	,prd_cost
	,prd_line
	,prd_start_dt
	,prd_end_dt
)

SELECT [prd_id]
      ,[prd_key]
      ,REPLACE (SUBSTRING (prd_key, 1, 5), '-','_') AS sub_cat_id   -- extracting sub-category ID from prd_key
      ,SUBSTRING (prd_key, 7, LEN(prd_key)) AS sales_prd_key        -- extracting sales_prd_key from prd_key
      ,[prd_nm]
      ,ISNULL([prd_cost], 0) AS prd_cost
      ,CASE UPPER(TRIM(prd_line))
          WHEN 'M' THEN 'Mountain'
          WHEN 'S' THEN 'Other Sales'
          WHEN 'R' THEN 'Road'
          WHEN 'T' THEN 'Touring'
          ELSE 'n/a'
       END AS prd_line --normalization of data to a readable & understandable format
      ,[prd_start_dt]
      ,DATEADD (DAY, -1, LEAD (prd_start_dt, 1) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
FROM [DataWarehouseProject1].[bronze].[crm_prd_info]

/*
====================================================================================
             Loading of transformed data to silver.crm_sales_details
====================================================================================
*/
-- Truncate Table
TRUNCATE TABLE silver.crm_sales_details;
GO

WITH clean_sales_transaction_data AS (
	SELECT [sls_ord_num]
		  ,[sls_prd_key]
		  ,[sls_cust_id]
		  ,TRY_CAST (CAST([sls_order_dt] AS VARCHAR) AS DATE) sls_order_dt
		  ,TRY_CAST (CAST([sls_ship_dt] AS VARCHAR) AS DATE) sls_ship_dt
		  ,TRY_CAST (CAST([sls_due_dt] AS VARCHAR) AS DATE) sls_due_dt
		  ,[sls_quantity]
		  ,CASE 
			  WHEN sls_price > sls_price2 AND sls_price IS NOT NULL THEN sls_price 
			  ELSE sls_price2
		   END AS sls_price
	FROM (
		SELECT *
		,CASE 
			WHEN sls_price IS NULL THEN sls_sales/sls_quantity 
			WHEN sls_price < 0 THEN ABS (sls_price)
			WHEN sls_price != ABS(sls_sales)/ sls_quantity AND sls_sales IS NOT NULL AND sls_sales != 0 THEN ABS(sls_sales)
			ELSE sls_price 
		 END AS sls_price2
		FROM bronze.crm_sales_details
		) sub 
) -- CTE_bracket

--Then Insert
INSERT INTO silver.crm_sales_details (
		 sls_ord_num
		,sls_prd_key
		,sls_cust_id
		,sls_order_dt
		,sls_ship_dt
		,sls_due_dt
		,sls_quantity
		,sls_price
		,sls_sales
)

SELECT *, sls_sales = sls_price * sls_quantity
FROM clean_sales_transaction_data ;
GO