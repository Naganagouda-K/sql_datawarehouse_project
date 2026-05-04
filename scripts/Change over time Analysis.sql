---Calculate the total sales per month and running total sales over time.

Select 
order_date,
total_sales,
SUM(total_sales) over(partition by order_date order by order_date) as running_total_sales
from
(Select 
	DATETRUNC(month,order_date) as order_date, 
	SUM(sales_amount) as total_sales
	from gold.fact_sales 
	where order_date is not null
	group by DATETRUNC(month,order_date))t
