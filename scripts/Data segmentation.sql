--Group customers into three segments based on there spending behaviour,
--VIP: at least 12 months of history and spending more then 5000
--Regular: at least 12 months of history but spending 5000 or less
--New: lifespan less then 12 months

WITH total_info as(
Select 
	c.customer_key,
	sum(f.sales_amount) as total_sales_amount,
	min(f.order_date) as order_first_date,
	max(f.order_date) as order_last_date,
	DATEDIFF(month,min(f.order_date),max(f.order_date)) as lifespan
	from gold.fact_sales as f
	LEFT JOIN gold.dim_customer as c
	on c.customer_key = f.customer_key
	group by c.customer_key)


Select 
	count(customer_key) as total_customers,
	customer_segmentation from
(Select 
	customer_key,
	CASE WHEN total_sales_amount > 5000 and lifespan >= 12 THEN 'VIP'
		 WHEN total_sales_amount <= 5000 and lifespan >= 12 THEN 'Regular'
		 ELSE 'New'
	End as 'customer_segmentation'
	from total_info)t 
	group by customer_segmentation;
