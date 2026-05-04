--Analyse the yearly performance of products by comparing each product's sales to both its average sales performance and the previous year's sales.

WITH yearly_product_sales as(
Select 
	year(f.order_date) as order_year, 
	p.product_name,
	sum(f.sales_amount) as current_sales
	from gold.fact_sales as f 
	LEFT JOIN gold.dim_products as p
	on f.product_key = p.product_key
	where f.order_date is not null
	group by year(f.order_date), p.product_name)
	select
	order_year,
	product_name,
	current_sales,
	avg(current_sales) over (partition by product_name) as avg_sales,
	current_sales - avg(current_sales) over (partition by product_name) as diff_sales,
	CASE WHEN 	current_sales - avg(current_sales) over (partition by product_name) > 0 THEN 'ABOVE AVERAGE'
		 WHEN 	current_sales - avg(current_sales) over (partition by product_name) < 0 THEN 'BELOW AVERAGE'
		 ELSE 'AVERAGE'
		 END as diff_sales_status,
	LAG(current_sales) over(partition by product_name order by order_year) as previous_year_sales,
	CASE WHEN 	LAG(current_sales) over(partition by product_name order by order_year)> 0 THEN 'Increase'
		 WHEN 	LAG(current_sales) over(partition by product_name order by order_year)< 0 THEN 'Decrease'
		 ELSE 'None'
		 END as diff_sales_status
	from yearly_product_sales
	order by product_name,order_year
