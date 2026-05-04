--Segment products into cost ranges and count how many products fall into each segment.


WITH total_products as(
Select 
	product_key,
	product_name,
	cost,
	CASE WHEN cost < 100 THEN 'Below 100'
		 WHEN cost between 100 and 500 THEN '100-500'
		 WHEN cost between 500 and 1000 THEN '500-1000'
		 ELSE 'Above 100'
	End cost_range
	from gold.dim_products)

Select 
count(product_key) as total_number_of_products,
cost_range
from 
total_products
group by cost_range
order by total_number_of_products desc
