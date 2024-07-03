-- Create database

CREATE DATABASE walmartsales;

-- Create table

CREATE TABLE  sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1)
);




-- --------------------------------------------------------
-- --------------------Feature Engineering-----------------

--  Add_the_time_of_day_column

SELECT
    time,
    (CASE 
        WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;

UPDATE sales 
SET time_of_day = (
    CASE 
        WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END
);

SET SQL_SAFE_UPDATES = 1;

UPDATE sales 
SET time_of_day = (
    CASE 
        WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
        WHEN time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
        ELSE 'Evening'
    END
)
WHERE time IS NOT NULL;


-- Add_day_name_column
SELECT 
   date,
   DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales 
SET day_name= DAYNAME(date);

--  Add_month_name_column

SELECT 
   date,
   MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales 
SET month_name= MONTHNAME(date);


-- --------------------------------------------------------

-- --------------------------------------------------------
-- -----------------------Generic--------------------------

-- How many unique cities does the data have ?
SELECT
    DISTINCT city
FROM sales;

-- In which city is each branch ?

SELECT
    DISTINCT branch
FROM sales;

SELECT
    DISTINCT city,
    branch
FROM sales;


-- ------------------------------------------------------------
-- -----------------------Product------------------------------

-- How manny unique product lines does the data have?
SELECT
   COUNT(DISTINCT product_line) AS Unique_product
FROM sales;

-- What is the most common payment method?
SELECT 
    payment_method,
    COUNT(payment_method) AS cte
FROM sales
GROUP BY payment_method
ORDER BY cte DESC;

-- Which product is the most selling produuct in product_line?

SELECT 
    product_line,
    COUNT(product_line) AS Product_Count
FROM sales
GROUP BY product_line 
ORDER BY Product_Count DESC;

-- What is the total revenue by month?

SELECT 
     month_name AS month,
     SUM(total) AS total_revenue
FROM sales
GROUP BY month
ORDER BY total_revenue DESC;

-- Which month has the highest COGS?

SELECT 
     month_name AS month,
     SUM(cogs) AS cogs
FROM sales
GROUP BY month
ORDER BY cogs DESC;

-- which product line has the largest revenue?

SELECT 
    product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line 
ORDER BY total_revenue DESC;

-- which city has the largest revenue?

SELECT
	branch,
    city,
    SUM(total) AS total_revenue
FROM
    sales
GROUP BY city, branch
ORDER BY total_revenue DESC;

-- Which product line has the largest VAT?

SELECT
	product_line,
    AVG(vat) AS avg_vat
FROM
    sales
GROUP BY product_line
ORDER BY avg_vat DESC;

-- Which branch sold more products than average product sold?

SELECT 
     branch,
     SUM(quantity) as qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender?

SELECT
     gender,
     product_line,
	 COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- What is the average rating of each product line?

SELECT
     product_line,
     AVG(rating) AS average_rating
FROM sales
GROUP BY product_line
ORDER BY average_rating DESC;

-- --------------------------------------------------------------------------------------------
-- ------------------------------------Sales---------------------------------------------------

-- Number of sales made in each time of the day per weekday?

SELECT
     time_of_day,
     COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?

SELECT
     customer_type,
     SUM(total) AS total_rev
FROM sales
GROUP BY customer_type
ORDER BY total_rev DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT
     city,
     SUM(VAT) AS most_vat
FROM sales
GROUP BY city
ORDER BY most_vat DESC;

-- Which customer type pays the most in VAT?

SELECT
     customer_type,
     SUM(VAT) AS most_vat
FROM sales
GROUP BY customer_type
ORDER BY most_vat DESC;

-- ----------------------------------------------------------------------------
-- ------------------------------Customer--------------------------------------

-- How many unique customer types does the data have?

SELECT 
     customer_type
FROM sales
GROUP BY customer_type;

-- How many unique payment methods does the data have?

SELECT
     payment_method
FROM sales
GROUP BY payment_method;

-- What is the most common customer type?

SELECT
     customer_type,
     SUM(total) AS total_amount
FROM sales
GROUP BY customer_type
ORDER BY total_amount DESC;

-- Which customer type buys the most?

SELECT
     customer_type,
     COUNT(total) AS total_cst
FROM sales
GROUP BY customer_type
ORDER BY total_cst DESC;

-- What is the gender of most of the customers?

SELECT
     gender,
     COUNT(*) AS gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?

SELECT
     gender,
     COUNT(*) AS gender_cnt
FROM sales
WHERE branch = "B"
GROUP BY gender
ORDER BY gender_cnt DESC;


-- Which time of the day do customers give most ratings?

SELECT
      time_of_day,
      AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
	
-- Which time of the day do customers give most ratings per branch?

SELECT
      time_of_day,
      AVG(rating) AS avg_rating
FROM sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Which day fo the week has the best avg ratings?

SELECT
      day_name,
      AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?

SELECT
      day_name,
      AVG(rating) AS avg_rating
FROM sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY avg_rating DESC;



