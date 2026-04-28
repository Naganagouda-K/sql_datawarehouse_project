--Duplicate value and null value check
Select cst_id, count(*) from silver.crm_cust_info group by cst_id having count(*) > 1 or cst_id is NULL

--Checking extra space in cst_firstname column
Select cst_firstname from silver.crm_cust_info group by cst_firstname having 
cst_firstname != trim(cst_firstname)

--Data Standardization and Consistency
Select distinct(cst_gndr) from silver.crm_cust_info

-------------------------------------------------------------------------------------------------------------------

--Duplicate value and null value check
Select prd_id, count(*) from silver.crm_prd_info group by prd_id having count(*) > 1 or prd_id is NULL

--Checking extra space in cst_firstname column
Select prd_nm from silver.crm_prd_info where
prd_nm != trim(prd_nm)

--Negtive value and null value check
Select prd_cost from silver.crm_prd_info where prd_cost < 0 or prd_cost is NULL

--Data Standardization and Consistency
Select distinct(prd_line) from silver.crm_prd_info

--Invalid order dates
Select * from silver.crm_prd_info where prd_start_dt > prd_end_dt

---------------------------------------------------------------------------------------------------------------------
--Checking for invalid order dates
Select * from silver.crm_sales_details where sls_order_dt > sls_due_dt or sls_order_dt > sls_ship_dt 

--Check data consistency: between sales, quantity, price
--Sales = quantity * price
--sales,quantity, price not be null nor negative

Select distinct  sls_sales as old_sls_sales, sls_quantity, sls_price as old_sls_price,
CASE When sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantity * abs(sls_price)
Then sls_quantity * abs(sls_price)
Else sls_sales
End as sls_sales,
CASE When sls_price is NULL or sls_price <= 0
Then sls_sales/NULLIF(sls_quantity,0)
Else sls_price
End as sls_price
from silver.crm_sales_details where
sls_sales != sls_quantity * sls_price or 
sls_sales is null or  sls_quantity is null or sls_price is null or
sls_sales <= 0 or  sls_quantity <= 0  or sls_price <= 0 order by 
sls_sales, sls_quantity, sls_price

------------------------------------------------------------------------------------------------------------

--checking invalid dates

Select distinct bdate from silver.erp_cust_az12 where bdate > GETDATE()

--Data Standardization and Consistency

Select distinct gen from silver.erp_cust_az12

------------------------------------------------------------------------------------------------------------
--Data Standardization and Consistency

Select distinct cntry from silver.erp_loc_a101

------------------------------------------------------------------------------------------------------------
--checking unwanted space

Select * from bronze.erp_px_cat_g1v2 where cat != trim(cat) or 
subcat != trim(subcat) or maintenance != trim(maintenance)

--NULL values check
Select * from bronze.erp_px_cat_g1v2 where id is NULL or 
cat is null or subcat is NULL or maintenance is NULL
