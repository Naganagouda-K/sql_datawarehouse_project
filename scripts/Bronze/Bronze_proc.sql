/*
Script Puropse : 
1)Loads data from source systems into the Bronze layer.
2)Truncates existing data before loading new data. 
3)Uses 'BULK INSERT' to load data from external CSV files.

Can be executed using: : EXEC bronze.load_bronze;
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze As
BEGIN
	BEGIN TRY
		
		DECLARE @START_TIME DATETIME, @END_TIME DATETIME,@BATCH_START_TIME DATETIME,@BATCH_END_TIME DATETIME;
		PRINT'***********************************************';
		PRINT 'Bronze Layer Loading';
		PRINT'***********************************************';

		SET @BATCH_START_TIME = GETDATE();
		PRINT'-----------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT'-----------------------------------------------';
		SET @START_TIME = GETDATE();
		PRINT' >>> Truncating table -> bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info

		PRINT' >>> Inserting data into table -> bronze.crm_cust_info';
		Bulk insert bronze.crm_cust_info
		from 'D:\Data Engineering\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @END_TIME = GETDATE();
		PRINT'>> Load Duration '+CAST(DATEDIFF(second, @START_TIME,@END_TIME)AS NVARCHAR) + ' Seconds';
		PRINT'---------------------------'

		SET @START_TIME = GETDATE();
		PRINT' >>> Truncating table -> bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info

		PRINT' >>> Inserting data into table -> bronze.crm_prd_info';
		Bulk insert bronze.crm_prd_info
		from 'D:\Data Engineering\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @END_TIME = GETDATE();
		PRINT'>> Load Duration '+CAST(DATEDIFF(second, @START_TIME,@END_TIME)AS NVARCHAR) + ' Seconds';
		PRINT'---------------------------'

		SET @START_TIME = GETDATE();
		PRINT' >>> Truncating table -> bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details

		PRINT' >>> Inserting data into table -> bronze.crm_sales_details';
		Bulk insert bronze.crm_sales_details
		from 'D:\Data Engineering\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @END_TIME = GETDATE();
		PRINT'>> Load Duration '+CAST(DATEDIFF(second, @START_TIME,@END_TIME)AS NVARCHAR) + ' Seconds';
		PRINT'---------------------------'

		PRINT'-----------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT'-----------------------------------------------';

		SET @START_TIME = GETDATE();
		PRINT' >>> Truncating table -> bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12

		PRINT' >>> Inserting data into table -> bronze.erp_cust_az12';
		Bulk insert bronze.erp_cust_az12
		from 'D:\Data Engineering\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @END_TIME = GETDATE();
		PRINT'>> Load Duration '+CAST(DATEDIFF(second, @START_TIME,@END_TIME)AS NVARCHAR) + ' Seconds';
		PRINT'---------------------------'

		SET @START_TIME = GETDATE();
		PRINT' >>> Truncating table -> bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101

		PRINT' >>> Inserting data into table -> bronze.erp_loc_a101';
		Bulk insert bronze.erp_loc_a101
		from 'D:\Data Engineering\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @END_TIME = GETDATE();
		PRINT'>> Load Duration '+CAST(DATEDIFF(second, @START_TIME,@END_TIME)AS NVARCHAR) + ' Seconds';
		PRINT'---------------------------'

		SET @START_TIME = GETDATE();
		PRINT' >>> Truncating table -> bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2

		PRINT' >>> Inserting data into table -> bronze.erp_px_cat_g1v2';
		Bulk insert bronze.erp_px_cat_g1v2
		from 'D:\Data Engineering\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @END_TIME = GETDATE();
		PRINT'>> Load Duration '+CAST(DATEDIFF(second, @START_TIME,@END_TIME)AS NVARCHAR) + ' Seconds';
		PRINT'---------------------------'
		SET @BATCH_END_TIME = GETDATE();

		PRINT'---------------------------'
		PRINT'>> Bronze layer Load Duration '+CAST(DATEDIFF(second, @BATCH_START_TIME,@BATCH_END_TIME)AS NVARCHAR) + ' Seconds';
		PRINT'---------------------------'

	END TRY
	BEGIN CATCH
				PRINT'#####################################################';
				PRINT 'Error Occured During Loading Bronze Layer';
				PRINT 'Error Message' + Error_message();
				PRINT 'Error Message' + cast(Error_number() as nvarchar);
				PRINT 'Error Message' + cast(Error_state() as nvarchar);
				PRINT'#####################################################';
	END CATCH
END

