drop table if exists zepto;

create table zepto
(
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availablequantity INTEGER,
discountedsellingprice NUMERIC(8,2),
weightingrams INTEGER,
outofstock BOOLEAN,
quantity INTEGER
);

--data exploration

--count of rows
SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto 
LIMIT 10;

-- Null values
SELECT * FROM zepto 
where name is NULL 
OR
category is NULL
OR
mrp is NULL
OR
discountpercent is NULL
OR
discountedsellingprice is NULL
OR
weightingrams is NULL
OR
availablequantity is NULL
OR
outofstock is NULL
OR
quantity is NULL;

--different product categories
SELECT DISTINCT category
FROM zepto
ORDER BY category;

--products in stock vs out of stock
SELECT outofstock, COUNT(sku_id)
FROM zepto
GROUP BY outofstock;

--product names present multiple times
SELECT name,COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING count(sku_id) > 1
ORDER BY count(sku_id) DESC;

--data cleaning

--products with price = 0
SELECT * FROM zepto
WHERE mrp = 0 OR discountedsellingprice = 0;

DELETE FROM zepto 
WHERE mrp = 0;

--convert paise to rupees
UPDATE zepto 
SET mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;

SELECT mrp, discountedsellingprice FROM zepto

--Q1. Find the top 10 best-value products based on discount percentage
SELECT DISTINCT name, mrp, discountPercent
FROM zepto 
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2. What is the products with high MRP but out of stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outofstock = True and mrp > 300
ORDER BY mrp DESC;

--Q3. Calculate estimated revenue for each category
SELECT category,
SUM(discountedsellingprice * availablequantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than rupees 500 and discount is less than 100
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC; 

--Q5.Idetify the top 5 categories offering the highest average discount percentage
SELECT category,
ROUND(AVG(discountPercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

--Q6.Find the price per grams for products above 100g and sort by best value
SELECT DISTINCT name, weightingrams, discountedsellingprice,
ROUND(discountedsellingprice/weightingrams,2) AS price_per_gram
FROM zepto
WHERE weightingrams >= 100
ORDER BY price_per_gram;

--Q7. Group by products into categories like low, medium, bulk
SELECT DISTINCT name, weightingrams,
CASE WHEN weightingrams < 1000 THEN 'Low'
     WHEN weightingrams < 5000 THEN 'Medium'
     ELSE 'Bulk'
	 END AS weight_category
FROM zepto;

--Q8. What is the total inventory weight per category
SELECT category,
SUM(weightingrams * availablequantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;