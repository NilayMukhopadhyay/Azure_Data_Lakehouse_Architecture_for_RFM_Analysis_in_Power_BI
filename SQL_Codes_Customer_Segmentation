--1. I found that the count of Product ID is greater than the count of Products.

SELECT COUNT(DISTINCT product_id) AS product_id
, COUNT(DISTINCT product_name) AS product_name
FROM fact_sales;

----------------------------------------------------------------------------------------------------------

--2. I delved further and I discovered that there are mostly different products assigned to the same Product ID.

WITH CTE_1 AS (
SELECT DISTINCT product_id, product_name FROM fact_sales
)
, CTE_2 AS (
SELECT product_id, product_name
, ROW_NUMBER () OVER( PARTITION BY product_id  ORDER BY product_id) AS row_no
FROM CTE_1)
SELECT product_id, product_name, row_no 
FROM CTE_2 
WHERE product_id IN (SELECT product_id FROM CTE_2 WHERE row_no > 1);

----------------------------------------------------------------------------------------------------------

/* 3. The column names have been rewritten again to organize the table. 
The old product_id is not desired, and the new product_id column should also not be placed in the last.*/

SELECT f.row_id, f.order_id, f.order_date, f.ship_date, f.ship_mode, f.customer_id, f.customer_name, f.segment
, f.city, f.state, f.country, f.postal_code, f.market, f.region, f.category, f.sub_category

, d.product_id AS product_id															--New product_id

, f.product_name, f.sales, f.quantity, f.discount, f.profit, f.shipping_cost, f.order_priority

FROM fact_sales f
INNER JOIN (																		--This is a SELF JOIN
	SELECT product_name, ROW_NUMBER() OVER (ORDER BY product_name ASC) AS product_id 
	FROM (
		SELECT DISTINCT product_name 
		FROM fact_sales) AS products) d				--The new product keys (product_id) have been created

ON f.product_name = d.product_name;

----------------------------------------------------------------------------------------------------------


