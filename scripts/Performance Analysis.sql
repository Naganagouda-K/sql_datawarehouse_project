----Which category contribute most to the overall sales
WITH Total_sales as
(Select 
    p.category,
	sum(f.sales_amount) as total_sales
	from gold.fact_sales as f
	LEFT JOIN gold.dim_products as p 
	on p.product_key = f.product_key
	group by category)

Select 
	category,
	total_sales,
	SUM(total_sales) over() as overall_sales,
	CONCAT(Round(CAST(total_sales as float)/SUM(total_sales) over()*100,2),'%') as Percentage_sales
	from Total_sales
	order by Percentage_sales desc
