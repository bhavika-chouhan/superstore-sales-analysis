-- 1. Total Sales and Profit by Categories
SELECT 
	category,
	ROUND(SUM(sales :: NUMERIC),2) AS total_sales,
	ROUND(SUM(profit :: NUMERIC),2) AS total_profit
FROM orders
GROUP BY category;

-- 2. Total Sales and Profit by Sub-Categories
SELECT 
	sub_category,
	ROUND(SUM(sales :: NUMERIC),2) AS total_sales,
	ROUND(SUM(profit :: NUMERIC),2) AS total_profit
FROM orders
GROUP BY sub_category;

-- 3. Top 10 Customers by sales
SELECT 
	customer_name,
	ROUND(SUM(sales :: NUMERIC),2) AS total_sales
FROM orders
GROUP BY customer_name
ORDER BY total_sales DESC
LIMIT 10;

-- 4. Total sales and profit by segment
SELECT 
	segment,
	ROUND(SUM(sales :: NUMERIC),2) AS total_sales,
    ROUND(SUM(profit :: NUMERIC),2) AS total_profit
FROM orders
GROUP BY segment;

-- 5. Total sales and profit by region
SELECT 
	region,
	ROUND(SUM(sales :: NUMERIC),2) AS total_sales,
	ROUND(SUM(profit :: NUMERIC),2) AS total_profit
FROM orders
GROUP BY region
ORDER BY total_sales DESC;

-- 6. Monthly & Yearly sales trend
WITH monthly_sales AS (
	select order_year,order_month,
		   SUM(sales :: NUMERIC) AS total_sales
	from orders
	group by order_year,order_month
)

SELECT 
	order_year,
	order_month,
	ROUND(total_sales,2) AS total_sales,
	DENSE_RANK() OVER(PARTITION BY order_year ORDER BY total_sales DESC) AS rank
FROM monthly_sales
ORDER BY order_year, rank;

-- 7. Monthly & yearly profit trend
WITH monthly_profit AS(
	select order_year,order_month,
	SUM(profit :: NUMERIC) AS total_profit
FROM orders
GROUP BY order_year,order_month
)

SELECT 
	order_year,
	order_month,
	ROUND(total_profit,2) AS total_profit,
	DENSE_RANK() OVER(PARTITION BY order_year ORDER BY total_profit DESC) AS rank
FROM monthly_profit
ORDER BY order_year,rank;

/
-- 8. Top 5 products by profit
SELECT 
	product_name,
	ROUND(SUM(profit :: NUMERIC),2) AS total_profit
FROM orders
GROUP BY product_name
ORDER BY total_profit DESC
LIMIT 5;

-- 9. Loss-making orders by category
SELECT 
	category,
	COUNT(*) AS total_loss,
	ROUND(SUM(profit :: numeric),2) AS total_loss
FROM orders
WHERE profit < 0
GROUP BY 1
ORDER BY 2 DESC


-- 10. Loss-making orders by sub_category
SELECT 
	sub_category,
	COUNT(*) AS total_loss,
	ROUND(SUM(profit :: numeric),2) AS total_loss
FROM orders
WHERE profit < 0
GROUP BY 1
ORDER BY 2 DESC 

-- 11. Profit margin by category
SELECT 
	category,
	ROUND(SUM(profit :: numeric)/SUM(sales :: numeric) * 100,2) AS profit_margin
FROM orders
GROUP BY 1
ORDER BY 2 DESC

--12. Top 10 Customers by profit
SELECT 
	customer_name,
	ROUND(SUM(profit :: NUMERIC),2) AS total_profit
FROM orders
GROUP BY customer_name
ORDER BY total_profit DESC
LIMIT 10;

/*
-- 13. Customer segment profitability
SELECT
	segment,
	ROUND(SUM(profit :: numeric),2) as total_profit
FROM orders
GROUP BY segment
ORDER BY total_profit DESC;
*/

-- 14. Repeat vs one-time customers
SELECT
SUM(CASE WHEN cnt > 1 THEN 1 ELSE 0 END) AS repeat_customer, 
SUM(CASE WHEN cnt = 1 THEN 1 ELSE 0 END) AS onetime_customer
FROM(
		SELECT 
			customer_name, COUNT(*) AS cnt
		FROM orders
		GROUP BY customer_name
) AS t;

-- 15. Products with negative total profit
SELECT product_name,
ROUND(SUM(profit :: NUMERIC),2) AS total_loss
FROM orders
WHERE profit < 0
GROUP BY product_name
ORDER BY total_loss;

-- 16. Profit margin by sub-category
SELECT sub_category,
ROUND(SUM(profit :: NUMERIC)/SUM(sales :: numeric) * 100,2) AS profit_margin
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

-- 17. Month-over-month Sales Growth %
WITH monthly_sales AS (
    SELECT
         order_month,
        ROUND(SUM(sales :: NUMERIC),2) AS total_sales
    FROM orders
    GROUP BY order_month
)

SELECT
    order_month,
    total_sales,
    LAG(total_sales) OVER (ORDER BY order_month) AS previous_month_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY order_month))
        / LAG(total_sales) OVER (ORDER BY order_month) * 100,
        2
    ) AS mom_growth_percentage
FROM monthly_sales;

-- 18. Month-over-month Profit Growth %
WITH monthly_profit AS (
	SELECT 
		order_month,
		ROUND(SUM(profit :: numeric),2) as total_profit
	FROM orders
	GROUP BY order_month
)

SELECT
	order_month,
	total_profit,
	LAG(total_profit) OVER(ORDER BY order_month) as previous_month_profit,
	ROUND((total_profit - LAG(total_profit) OVER (ORDER BY order_month))/
	LAG(total_profit) OVER (ORDER BY order_month) * 100,2) as mom_profit_growth
FROM monthly_profit;

-- 19. Top 3 months per year by sales/profit
WITH monthly_sale AS(
	SELECT order_year,order_month,
	ROUND(SUM(sales :: numeric),2) as total_sale
	FROM orders
	GROUP BY 1,2
),
ranked_month AS (
	SELECT
		order_year,
		order_month,
		total_sale,
		RANK()OVER(PARTITION BY order_year ORDER BY total_sale DESC) AS month_rank
	FROM monthly_sale
)

SELECT order_year,order_month,total_sale,month_rank
FROM ranked_month
WHERE month_rank <=3
ORDER BY order_year,total_sale DESC;

-- 20. Discount vs Profit analysis
SELECT
	discount AS discount_level,
	COUNT(order_id) AS total_orders,
	ROUND(SUM(sales::numeric),2) AS total_sales,
	ROUND(SUM(profit::numeric),2) AS total_profit
FROM orders
GROUP BY discount
ORDER BY discount;


-- 21. Shipping impact on profit
SELECT
	shipping_days,
	COUNT(order_id) AS total_orders,
	ROUND(SUM(profit::numeric),2) AS total_profit
FROM orders
GROUP BY 1
ORDER BY 1;

-- 22. Ship mode performance
SELECT
	ship_mode,
	COUNT(order_id) AS total_orders,
	ROUND(SUM(sales :: numeric),2) AS total_sales,
    ROUND(SUM(profit :: numeric),2) AS total_profit
FROM orders
GROUP BY 1
ORDER BY 3 DESC;



	




