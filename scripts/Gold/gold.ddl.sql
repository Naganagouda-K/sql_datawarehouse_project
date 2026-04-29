/*
************************************************************************************************************************
Script Purpose : This script creates view in the gold layer by first dropping any existing view if they are already present.
*/

if OBJECT_ID('gold.dim_customer','U') is not null
	Drop view gold.dim_customer;
GO

CREATE VIEW gold.dim_customer as
SELECT 
       ROW_NUMBER() OVER (Order by cst_id) as customer_key,
       cci.cst_id as customer_id
      ,cci.cst_key as customer_number
      ,cci.cst_firstname as firstname
      ,cci.cst_lastname as lastname
      ,ela.cntry as country
      ,cci.cst_marital_status as marital_status
      ,CASE WHEN cci.cst_gndr != 'n/a' THEN cci.cst_gndr
         ELSE coalesce(eca.gen, 'n/a') 
       END as gender
      ,eca.bdate as birth_date
      ,cci.cst_create_date as create_date
      
  FROM silver.crm_cust_info as cci
  Left join silver.erp_cust_az12 as eca
  on cci.cst_key = eca.cid
  Left join silver.erp_loc_a101 as ela
  on cci.cst_key = ela.cid

  GO

  if OBJECT_ID('gold.dim_products','U') is not null
	Drop view gold.dim_products;
    
  GO

  CREATE VIEW gold.dim_products as
  SELECT 
       ROW_NUMBER() over(order by prd_start_dt,prd_id) as product_key
      ,cpi.prd_id as product_id
      ,cpi.prd_key as product_number
      ,cpi.prd_nm as product_name
      ,cpi.cat_id as category_id
      ,epc.cat as category
      ,epc.subcat as subcategory
      ,epc.maintenance 
      ,cpi.prd_cost as cost
      ,cpi.prd_line as product_line
      ,cpi.prd_start_dt as startdate
  FROM silver.crm_prd_info as cpi
  LEFT JOIN silver.erp_px_cat_g1v2 as epc
  on cpi.cat_id = epc.id where prd_end_dt is NULL --Filtering historical data

  GO

   if OBJECT_ID('gold.fact_sales','U') is not null
   Drop view gold.fact_sales;

   GO

   CREATE VIEW gold.fact_sales AS
   SELECT 
       csd.sls_ord_num as order_number
      ,dp.product_key
      ,dc.customer_key
      ,csd.sls_order_dt as order_date
      ,csd.sls_ship_dt as shipping_date
      ,csd.sls_due_dt as due_date
      ,csd.sls_sales as sales_amount
      ,csd.sls_quantity as quantity
      ,csd.sls_price as price
  FROM silver.crm_sales_details as csd
  LEFT JOIN gold.dim_products as dp
  ON csd.sls_prd_key = dp.product_number
  LEFT JOIN gold.dim_customer as dc
  ON csd.sls_cust_id = dc.customer_id
