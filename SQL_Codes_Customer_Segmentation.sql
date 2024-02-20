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

--Global Superstore DDL and DML after Data Cleaning.

CREATE TABLE fact_sales_2 (
row_id VARCHAR (50) NOT NULL,
order_id VARCHAR (50) NOT NULL,
order_date DATE NOT NULL,
ship_date DATE NOT NULL,
ship_mode VARCHAR (50) NOT NULL,
customer_id VARCHAR (50) NOT NULL,
customer_name VARCHAR (50) NOT NULL,
segment VARCHAR (50) NOT NULL,
city VARCHAR (50) NOT NULL,
state VARCHAR (50) NOT NULL,
country VARCHAR (50) NOT NULL,
postal_code INT,
market VARCHAR (50) NOT NULL,
region VARCHAR (50) NOT NULL,
category VARCHAR (50) NOT NULL,
sub_category VARCHAR (50) NOT NULL,
product_id VARCHAR (50) NOT NULL,
product_name VARCHAR (200) NOT NULL,
sales FLOAT NOT NULL,
quantity INT NOT NULL,
discount FLOAT NOT NULL,
profit FLOAT NOT NULL,
shipping_cost FLOAT NOT NULL,
order_priority VARCHAR (50) NOT NULL, );

INSERT INTO fact_sales_2 

 SELECT f.row_id, f.order_id, f.order_date, f.ship_date, f.ship_mode, f.customer_id, f.customer_name, f.segment
, f.city, f.state, f.country, f.postal_code, f.market, f.region, f.category, f.sub_category
	
, d.product_id AS product_id 										--New product_id
	
, f.product_name, f.sales, f.quantity, f.discount, f.profit, f.shipping_cost, f.order_priority

/* 3. The column names have been rewritten again to organize the table. 
The old product_id is not desired, and the new product_id column should also not be placed in the last.*/

FROM fact_sales f
INNER JOIN ( 											--This is a SELF JOIN
	SELECT product_name, ROW_NUMBER() OVER (ORDER BY product_name ASC) AS product_id 
	FROM (
		SELECT DISTINCT product_name 
		FROM fact_sales) AS products) d			--The new product keys (product_id) have been created
ON f.product_name = d.product_name; 

----------------------------------------------------------------------------------------------------------

--CREATE VIEW fact_sales_vw AS

SELECT row_id, order_id, order_date, ship_date, segment
, customer_id, region, sales, discount, profit
FROM fact_sales;
/* 
After carefully experimenting with the desired output, 
it has been determined that only these 10 columns are necessary for this analysis.
*/

----------------------------------------------------------------------------------------------------------

--CREATE VIEW dim_customer_vw AS
--RFM Analysis

WITH CTE AS ( 					--1st CTE to obtain the necessary columns for RFM Analysis
SELECT DISTINCT customer_id, customer_name, MAX(order_date) AS max_date
, DATEDIFF(DAY, MAX(order_date), (SELECT MAX(order_date) FROM fact_sales)) AS recency
, COUNT(order_id) AS frequency, SUM(profit) AS monetary
FROM fact_sales
GROUP BY customer_id, customer_name)
, CTE_2 AS ( 								--2nd CTE for R, F, and M Scores 
SELECT *
, NTILE (10) OVER(ORDER BY recency DESC) AS r_score
, NTILE (10) OVER(ORDER BY frequency ASC) AS f_score
, NTILE (10) OVER(ORDER BY monetary ASC) AS m_score
FROM CTE)
, CTE_3 AS ( 							--3rd CTE to get the overall RFM Score
SELECT *, r_score + f_score + m_score AS rfm
FROM CTE_2)
SELECT *, NTILE(10) OVER(ORDER BY rfm ASC) AS rfm_score FROM CTE_3;

