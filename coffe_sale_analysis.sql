use campus;
SELECT *FROM coffeesales;
RENAME TABLE coffee_sale TO coffeesales;
SELECT *FROM coffeesales LIMIT 5;
-- total no of sales on date '1/1/2023'
SELECT COUNT(*)AS totalSales FROM coffeesales 
WHERE transaction_date ='1/1/2023';
SELECT product_type,product_category ,unit_price FROM coffeesales
GROUP BY product_type HAVING SUM(unit_price)>4;
-- most sold prodcut 
SELECT product_category,COUNT(*)AS totalquantity 
FROM coffeesales GROUP BY product_category;
-- •	Find the transaction with transaction_id 3.
SELECT *FROM coffeesales
WHERE transaction_id =3 ;
-- •	List all transactions made on 1/1/2023.
SELECT *FROM coffeesales
WHERE transaction_date='1/1/2023'
LIMIT 10;
-- •	List all unique store locations.
SELECT *FROM coffeesales 
GROUP BY store_location;
-- 5 •	Find all transactions where the transaction_qty is greater than 1.
SELECT *FROM coffeesales 
WHERE transaction_qty>2;
-- 6	List all products in the Coffee category.\
-- SELECT  unique product category
SELECT DISTINCT product_category FROM coffeesales;
SELECT *FROM coffeesales
WHERE product_category='Coffee'
LIMIT 10;
-- 7 •	Show all transactions from the store located in Lower Manhattan.
SELECT *FROM coffeesales
 WHERE store_location='Lower Manhattan';
 -- 8 •	Retrieve the product_id and unit_price for all transactions.
 SELECT product_id,unit_price FROM coffeesales
 GROUP BY product_id
 ORDER BY product_id ;
 -- 9 •	Find the first five transactions in the table.
 SELECT *FROM coffeesales LIMIT 5;
 -- total revenue contri of tea and coffee
 SELECT product_category,
 ROUND(SUM(transaction_qty*unit_price),2)AS total_revenue
,CASE 
        WHEN product_category = 'Coffee' THEN 
            ROUND(SUM(transaction_qty * unit_price) / (SELECT SUM(transaction_qty * unit_price) FROM coffeesales) * 100, 2)
        WHEN product_category = 'Tea' THEN 
            ROUND(SUM(transaction_qty * unit_price) / (SELECT SUM(transaction_qty * unit_price) FROM coffeesales) * 100, 2)
        ELSE 0 
    END AS contri
FROM coffeesales
 GROUP BY product_category;
 
 WITH total_revenue_cte AS (
    SELECT SUM(transaction_qty * unit_price) AS total_revenue
    FROM coffeesales
),
cte2 AS (SELECT product_category,ROUND(total_revenue,2)AS golobal_total_rev,
    ROUND(SUM(transaction_qty * unit_price), 2) AS total_revenue,
    ROUND((SUM(transaction_qty * unit_price) / total_revenue_cte.total_revenue) * 100, 2)
    AS '% contri.'
FROM coffeesales, total_revenue_cte
GROUP BY product_category, total_revenue_cte.total_revenue)
SELECT *FROM cte2 WHERE product_category='Coffee' OR product_category='Tea';

 -- 10 Retrieve all transactions that occurred before 7:15:00 on 1/1/2023.
 SELECT *FROM coffeesales 
 WHERE transaction_date='1/1/2023' AND transaction_time<'7:15:00';
 SELECT store_location,COUNT(*)AS total_transition FROM coffeesales
 GROUP BY store_location ORDER BY total_transition DESC;
 -- 2.	Find the total quantity sold for each product category.
 SELECT product_category,SUM(transaction_qty) As total_qunatity
 FROM coffeesales
 GROUP BY product_category;
 -- 3.	Calculate the total sales amount for each product type
 SELECT product_category,ROUND(SUM(transaction_qty*unit_price),2)AS total_sales
 FROM coffeesales
 GROUP BY product_category;
 -- 4.	Find the average unit_price of products in the Tea category.
 SELECT product_category, ROUND(AVG(unit_price),2)AS avg_unitprice
 FROM coffeesales
 GROUP BY product_category
 ORDER BY avg_unitprice DESC;
 -- 5.	List the products that have been sold more than once.
 SELECT product_type ,COUNT(*)
 FROM coffeesales 
 GROUP BY product_type HAVING COUNT(*)>100;
 -- 6.	Find the maximum transaction_qty for each store_id.
  SELECT *FROM coffeesales  WHERE unit_price>2 GROUP BY store_id LIMIT 5;
SELECT store_id, MAX(transaction_qty)AS maxtran_quantity
FROM coffeesales GROUP BY store_id;
-- 7.	Show the transactions where the total transaction amount (quantity * unit price) is greater than 10.
SELECT transaction_id,ROUND(SUM(transaction_qty*unit_price),2)AS amount
FROM coffeesales
GROUP BY transaction_id 
HAVING amount>10;
-- 8.	List all products along with their total sales amount, grouped by product_id.
SELECT product_id,product_category,ROUND(SUM(transaction_qty*unit_price),2)AS totalsale 
FROM coffeesales GROUP BY product_id;
-- 9.	Find the store location with the highest number of transactions.
SELECT *FROM coffeesales limit5;
SELECT store_location ,COUNT(transaction_id)AS higes_transi
FROM coffeesales GROUP BY store_location
ORDER BY higes_transi DESC LIMIT 2;
-- 10.	List the products along with the total quantity sold for each, sorted by total quantity in descending order
SELECT product_category,SUM(transaction_qty)AS total_quantity 
FROM coffeesales
GROUP BY product_category ORDER BY total_quantity DESC;
--  ---------------------------------advanced
-- 1.	Find the top 3 most sold products by total quantity.

SELECT product_type,SUM(transaction_qty)AS total_quantity
FROM coffeesales GROUP BY product_type ORDER BY total_quantity DESC LIMIT 3;
-- 2.	Calculate the total sales for each store and each product category.

SELECT store_id,product_category,ROUND(SUM(transaction_qty*unit_price),2)AS total_sales
FROM coffeesales GROUP BY store_id,product_category;
-- 3.	List the store locations where the average transaction amount is greater than 5.

SELECT store_location,ROUND(AVG(transaction_qty*unit_price),2)AS tran_amount
FROM coffeesales GROUP BY store_location HAVING  tran_amount>4;
-- 4.	Find the products that contribute to more than 50% of the total sales amount.
WITH CTE AS (SELECT product_type,ROUND(SUM(transaction_qty*unit_price),2) AS total_sale
FROM coffeesales GROUP BY product_type),
totalsale AS (SELECT SUM(total_sale)AS overall_sale FROM CTE)
SELECT product_type,total_sale,total_sale/overall_sale*100 AS revenue
FROM totalsale,CTE;
-- EASY-------------------------------------------------------------------------------------------
SELECT product_category,
ROUND(SUM(transaction_qty*unit_price),2)/(SELECT SUM(ROUND(transaction_qty*unit_price,2)) FROM coffeesales)*100 revenue
FROM coffeesales GROUP BY product_category;
-- 6.List the transactions where the transaction_time is the same but different transaction_id.
SELECT a.transaction_id ,a.transaction_time,b.transaction_id,b.transaction_time
FROM coffeesales a
JOIN coffeesales b ON a.transaction_time=b.transaction_time
WHERE a.transaction_id!=b.transaction_id;
-- 7.	Find the product with the highest average sales amount per date.
SELECT*FROM coffeesales ORDER BY transaction_date DESC LIMIT 100;
WITH cte AS (
SELECT product_type,transaction_date,ROUND(AVG(transaction_qty*unit_price),2) AS avg_sale
FROM coffeesales GROUP BY transaction_date,product_type),
ranks AS(
SELECT product_type,transaction_date,avg_sale,RANK()OVER(PARTITION BY transaction_date ORDER BY avg_sale DESC)AS rnk
FROM cte )
SELECT product_type,transaction_date,avg_sale
FROM  ranks
WHERE rnk=1;
-- •	Determine the total sales amount for each product_type in each store location.
SELECT *FROM coffeesales limit 100;
SELECT product_type,store_location,ROUND(SUM(transaction_qty*unit_price),2)AS totalsales
FROM coffeesales GROUP BY product_type,store_location;
-- Find the difference in total sales amount between Coffee and Tea products
WITH cte AS (
SELECT product_category ,ROUND(SUM(transaction_qty*unit_price),4)AS total_sale
FROM coffeesales WHERE product_category IN('Coffee','Tea')
GROUP BY product_category)
SELECT
(SELECT total_sale FROM cte WHERE product_category='Coffee')-
(SELECT total_sale FROM cte WHERE product_category='Tea') AS diff
FROM cte LIMIT 1;
-- 
SELECT store_location ,SUM(transaction_qty*unit_price)AS totalsale
FROM coffeesales GROUP BY store_location;
WITH cte AS (
    SELECT store_location,product_category,transaction_qty * unit_price AS totalsale
    FROM coffeesales
),
store_totals AS (
    SELECT store_location,SUM(totalsale) AS store_total_sale
    FROM cte GROUP BY store_location
),ranked_stores AS (
    SELECT store_location,store_total_sale,RANK() OVER (ORDER BY store_total_sale DESC) AS store_rank
    FROM store_totals
),top_stores AS (
    SELECT store_location,store_total_sale
    FROM ranked_stores
    WHERE store_rank <= 3
),
category_totals AS (
    SELECT store_location,product_category,SUM(totalsale) AS category_total_sale
    FROM cte GROUP BY store_location, product_category
),ranked_categories AS (
    SELECT store_location,product_category,category_total_sale,
        RANK() OVER (PARTITION BY store_location ORDER BY category_total_sale DESC) AS category_rank
    FROM category_totals)
SELECT rc.store_location,
    rc.product_category,
    ROUND(rc.category_total_sale,2)AS category_total_sale
FROM ranked_categories rc
JOIN top_stores ts ON rc.store_location = ts.store_location
WHERE rc.category_rank = 1;
-- Calculate the cumulative total sales amount for each product category over time, 
-- sorted by transaction date and time
SELECT product_category,transaction_date,transaction_time ,SUM(transaction_qty*unit_price)As totalsales,
SUM(SUM(transaction_qty*unit_price))
OVER(PARTITION BY product_category ORDER BY transaction_date,transaction_time DESC 
ROWS BETWEEN unbounded preceding AND CURRENT ROW  )AS cummulative_sum
FROM coffeesales
GROUP BY 
    product_category, 
    transaction_date 
    ORDER BY product_category, cummulative_sum;
    SELECT *FROM coffeesales limit 100;
-- For each store_location, find the product with the highest sales growth rate between two consecutive days
SELECT store_location,product_category,transaction_date,SUM(transaction_qty*unit_price)AS totalsale,
LAG(transaction_date)OVER(PARTITION BY product_category ORDER BY transaction_date )AS prevday
FROM coffeesales GROUP BY store_location, transaction_date;
--------------
WITH daily_sales AS (
    SELECT 
        store_location,
        product_category,
        transaction_date,
        SUM(transaction_qty * unit_price) AS total_sales
    FROM coffeesales
    GROUP BY store_location, product_category, transaction_date
),daily AS(
SELECT store_location,product_category,transaction_date,total_sales,
        LAG(transaction_date) OVER (PARTITION BY store_location,
        product_category ORDER BY transaction_date )AS prev_day,
         LAG(total_sales) OVER (PARTITION BY store_location,
        product_category ORDER BY transaction_date )AS prev_daysales
        FROM daily_sales),salesgrowth AS(
SELECT d.store_location,d.product_category,d.transaction_date,d.total_sales,
(d.total_sales - d.prev_daysales) / NULLIF(d.prev_daysales, 0) AS sales_growth_rate
FROM daily d
JOIN (
SELECT store_location,transaction_date,
MAX((total_sales - prev_daysales) / NULLIF(prev_daysales, 0)) AS max_growth_rate
    FROM daily
    WHERE prev_day IS NOT NULL
    GROUP BY store_location, transaction_date
) max_sg 
ON d.store_location = max_sg.store_location 
AND d.transaction_date = max_sg.transaction_date
AND (d.total_sales - d.prev_daysales) / NULLIF(d.prev_daysales, 0) = max_sg.max_growth_rate
WHERE d.prev_day IS NOT NULL
ORDER BY d.store_location, d.transaction_date,  d.product_category)
SELECT * ,CASE
        WHEN sales_growth_rate * 100 < 100 THEN sales_growth_rate * 100
        ELSE 100  -- Set a default of 100 if growth rate is less than or equal to 100%
    END AS "Sales Growth Percentage over 100%"
    ,((sales_growth_rate*100-100)/100) *100 AS salesg
    FROM salesgrowth;
