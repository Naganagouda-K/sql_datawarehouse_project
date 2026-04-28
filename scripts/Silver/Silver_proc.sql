/*
Script Puropse : 
1)Loads data from Bronze layer to Silver layer.
2)Truncates existing data before loading new data. 

Can be executed using: : EXEC silver.load_bronze;
*/

CREATE OR ALTER PROC silver.load_silver as
BEGIN
    BEGIN TRY
        DECLARE @START_TIME DATETIME, @END_TIME DATETIME,@BATCH_START_TIME DATETIME,@BATCH_END_TIME DATETIME;
        SET @BATCH_START_TIME = GETDATE();
        PRINT'***********************************************';
    		PRINT 'Silver Layer Loading';
    		PRINT'***********************************************';

        PRINT'-----------------------------------------------';
    		PRINT 'Loading CRM Tables';
    		PRINT'-----------------------------------------------';

        SET @START_TIME = GETDATE();
        PRINT' >>> Truncating table -> silver.crm_cust_info';
        Truncate table silver.crm_cust_info;

        PRINT' >>> Inserting data into table -> silver.crm_cust_info';
        Insert into silver.crm_cust_info 
        (cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date)

        Select [cst_id]
              ,[cst_key]
              ,Trim([cst_firstname]) as cst_firstname
              ,Trim([cst_lastname]) as cst_lastname
              ,CASE WHEN upper(cst_marital_status) = 'S' Then 'Single'
               WHEN upper(cst_marital_status) = 'M' Then 'Married'
               ELSE 'n/a'
               END
               [cst_marital_status]
              ,CASE WHEN upper(cst_gndr) = 'F' Then 'Female'
               WHEN upper(cst_gndr) = 'M' Then 'Male'
               ELSE 'n/a'
               END
               [cst_gndr]
              ,[cst_create_date]
        From (
        Select *, ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as 
        last_flag from bronze.crm_cust_info where cst_id is not null)t where last_flag = 1

        SET @END_TIME = GETDATE();
    		PRINT'>> Load Duration '+CAST(DATEDIFF(second, @START_TIME,@END_TIME)AS NVARCHAR) + ' Seconds';
    		PRINT'---------------------------'

        SET @START_TIME = GETDATE();
        PRINT' >>> Truncating table -> silver.crm_prd_info';
        Truncate table silver.crm_prd_info;

        PRINT' >>> Inserting data into table -> silver.crm_prd_info';
        Insert into silver.crm_prd_info(
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
        )

        SELECT prd_id
              ,replace(substring (prd_key,1,5),'-','_') as cat_id,
               substring (prd_key,7,len(prd_key)) as prd_key
              ,prd_nm
              ,isnull(prd_cost,0) as prd_cost
              ,CASE Upper(Trim(prd_line))
               When 'R' Then 'Road'
               When 'M' Then 'Mountain'
               When 'S' Then 'Other Sales'
               When 'T' Then 'Touring'
               Else 'n/a'
               End as prd_line
              ,Cast(prd_start_dt as DATE)as prd_start_dt
              ,Dateadd (Day, -1, Cast(Lead(prd_start_dt) over(Partition by prd_key order by prd_start_dt) as DATE)) as prd_end_dt
          FROM bronze.crm_prd_info

        SET @END_TIME = GETDATE();
    		PRINT'>> Load Duration '+CAST(DATEDIFF(second, @START_TIME,@END_TIME)AS NVARCHAR) + ' Seconds';
    		PRINT'---------------------------'

        SET @START_TIME = GETDATE();
        PRINT' >>> Truncating table -> silver.crm_sales_details';
        Truncate table silver.crm_sales_details;

        PRINT' >>> Inserting data into table -> silver.crm_sales_details';
        Insert into silver.crm_sales_details(
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price)

        SELECT sls_ord_num
              ,sls_prd_key
              ,sls_cust_id
              ,CASE When sls_order_dt < 0 OR len(sls_order_dt) != 8 Then NULL
               ELSE CAST(CAST(sls_order_dt AS NVARCHAR) AS DATE)
               END AS sls_order_dt
              ,CASE When sls_ship_dt < 0 OR len(sls_ship_dt) != 8 Then NULL
               ELSE CAST(CAST(sls_ship_dt AS NVARCHAR) AS DATE)
               END AS sls_ship_dt
              ,CASE When sls_due_dt < 0 OR len(sls_due_dt) != 8 Then NULL
               ELSE CAST(CAST(sls_due_dt AS NVARCHAR) AS DATE)
               END AS sls_due_dt
              ,CASE When sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price)
               Then sls_quantity * abs(sls_price)
               Else sls_sales
               End as sls_sales
              ,sls_quantity
              ,CASE When sls_price is NULL or sls_price <= 0
               Then sls_sales/NULLIF(sls_quantity,0)
               Else sls_price
               End as sls_price
          FROM bronze.crm_sales_details
        SET @END_TIME = GETDATE();
    		PRINT'>> Load Duration '+CAST(DATEDIFF(second, @START_TIME,@END_TIME)AS NVARCHAR) + ' Seconds';
    		PRINT'---------------------------'

        PRINT'-----------------------------------------------';
    		PRINT 'Loading ERP Tables';
    		PRINT'-----------------------------------------------';

        SET @START_TIME = GETDATE();
        PRINT' >>> Truncating table -> silver.erp_cust_az12';
        Truncate table silver.erp_cust_az12;

        PRINT' >>> Inserting data into table -> silver.erp_cust_az12';
        Insert into silver.erp_cust_az12(cid,bdate,gen)
        Select 
                CASE WHEN cid Like 'NAS%' THEN substring(cid,4,len(cid)) 
                ELSE cid
                END as 
                cid,
                CASE WHEN bdate > GETDATE() THEN NULL
                ELSE bdate
                END as
                bdate,
                CASE WHEN upper(trim(gen)) in ('M', 'MALE') THEN 'Male'
                WHEN upper(trim(gen)) in ('F','FEMALE') THEN 'Female'
                ELSE 'n/a'
                END as
                gen
        from bronze.erp_cust_az12 
        SET @END_TIME = GETDATE();
    		PRINT'>> Load Duration '+CAST(DATEDIFF(second, @START_TIME,@END_TIME)AS NVARCHAR) + ' Seconds';
    		PRINT'---------------------------'

        SET @START_TIME = GETDATE();
        PRINT' >>> Truncating table -> silver.erp_loc_a101';
        Truncate table silver.erp_loc_a101;

        PRINT' >>> Inserting data into table -> silver.erp_loc_a101';
        Insert into silver.erp_loc_a101(cid,cntry)
        Select
                replace(cid,'-','') as cid,
                CASE WHEN trim(cntry) = 'DE' THEN 'Germany'
                WHEN trim(cntry) in ('US','USA') THEN 'United States'
                WHEN trim(cntry)='' or cntry is null THEN 'n/a'
                ELSE trim(cntry)
                END as cntry
        from bronze.erp_loc_a101
        SET @END_TIME = GETDATE();
    		PRINT'>> Load Duration '+CAST(DATEDIFF(second, @START_TIME,@END_TIME)AS NVARCHAR) + ' Seconds';
    		PRINT'---------------------------'

        SET @START_TIME = GETDATE();
        PRINT' >>> Truncating table -> silver.erp_px_cat_g1v2';
        Truncate table silver.erp_px_cat_g1v2;

        PRINT' >>> Inserting data into table -> silver.erp_px_cat_g1v2';
        Insert into silver.erp_px_cat_g1v2(id,cat,subcat,maintenance )
        Select 
            id,
            cat,
            subcat,
            maintenance 
        from bronze.erp_px_cat_g1v2
        SET @END_TIME = GETDATE();
    		PRINT'>> Load Duration '+CAST(DATEDIFF(second, @START_TIME,@END_TIME)AS NVARCHAR) + ' Seconds';
    		PRINT'---------------------------'

        SET @BATCH_END_TIME = GETDATE();

        PRINT'---------------------------'
    		PRINT'>> Silver layer Load Duration '+CAST(DATEDIFF(second, @BATCH_START_TIME,@BATCH_END_TIME)AS NVARCHAR) + ' Seconds';
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
