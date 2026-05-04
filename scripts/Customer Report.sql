/* Customer Report

Purpose: This report consolidates key customer metrics and behaviors

Highlights:

1) Gathers essential fields such as names, ages, and transaction details.
2) Segments customers into categories (VIP, Regular, New) and age groups.
3) Aggregates customer-level metrics:
		total orders
		total sales
		total quantity purchased
		total products
		lifespan (in months)
4) Calculates valuable KPIs:
		recency (months since last order)
		average order value(total sales/total number of orders)
		average monthly spend (total sales / Nr.of months)

*/

CREATE view gold.report_customers as 

WITH base_info as 
(Select 
	f.order_number,
	f.product_key,
	f.order_date,
	f.sales_amount,
	f.quantity,
	c.customer_key,
	c.customer_number,
	CONCAT(c.firstname, ' ', c.lastname) as customer_name,
	DATEDIFF(year, c.birth_date, GETDATE()) as age
from 
gold.fact_sales as f 
LEFT JOIN gold.dim_customer as c
on f.customer_key = c.customer_key)

,customer_agg as
(Select 
	customer_key,
	customer_number,
	customer_name,
	age,
	count(distinct order_number) as total_orders,
	sum(sales_amount) as total_sales,
	sum(quantity) as total_quantity,
	count(distinct product_key) as total_products,
	max(order_date) as order_last_date,
	DATEDIFF(month,min(order_date),max(order_date)) as lifespan
from base_info
group by customer_key,
		customer_number,
		customer_name,
		age)

Select 
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE WHEN total_sales > 5000 and lifespan >= 12 THEN 'VIP'
		 WHEN total_sales <= 5000 and lifespan >= 12 THEN 'Regular'
		 ELSE 'New'
	End as 'customer_segment',
	CASE WHEN age < 20  THEN 'Below 20'
		 WHEN age between 20 and 30 THEN '20-30'
		 WHEN age between 30 and 40 THEN '30-40'
		 WHEN age between 40 and 50 THEN '40-50'
		 ELSE 'above 50'
	End as 'age_group',
	order_last_date,
	DATEDIFF (month, order_last_date, GETDATE()) as recency ,
	total_sales,
	total_orders,
	total_quantity,
	total_products,
	lifespan,
	CASE WHEN total_orders = 0 THEN 0
		 ELSE total_sales/total_orders
	END as avg_order_value,
	CASE WHEN lifespan = 0 THEN total_sales
		 ELSE total_sales/lifespan
	END as avg_monthly_spend
from customer_agg;
