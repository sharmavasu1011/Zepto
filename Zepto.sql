DROP TABLE IF EXISTS zepto;

--create table
CREATE TABLE zepto(
	sku_id SERIAL PRIMARY KEY,
	category VARCHAR(120),
	name VARCHAR(200) NOT NULL,
	mrp NUMERIC(8,2),
	discountPercent NUMERIC(5,2),
	availableQuantity INTEGER,
	discountSellingPrice NUMERIC(8,2),
	weightInGrams INTEGER,
	outOfStock BOOLEAN,
	quantity INTEGER
);

--import data 
COPY zepto(category, name, mrp, discountPercent, availableQuantity, discountSellingPrice, weightInGrams, outOfStock,quantity)
FROM 'C:\Users\vasu0\Desktop\sql practice\Zepto\zepto_v2.csv'
DELIMITER ','
CSV HEADER;

--clean data
SELECT * 
	FROM zepto
	WHERE category is null
	OR name is null
	OR mrp is null
	OR discountpercent is null
	OR availablequantity is null
	OR discountsellingprice is null 
	OR weightingrams is null
	OR outofstock is null
	OR quantity is null;

--products with numtiple SKUs
SELECT
	name,
	COUNT(sku_id) AS "Number of SKUs"
FROM zepto
	GROUP BY name
	HAVING COUNT(sku_id) > 1 
	ORDER BY COUNT(sku_id) DESC;
	
--items with mrp = 0
SELECT * 
	FROM zepto
	WHERE mrp = 0;

DELETE FROM zepto
	WHERE mrp = 0;


--items out of stock
SELECT
	outofstock,
	COUNT(sku_id)
FROM zepto
	GROUP BY outofstock;

--conver paise into rupees in mrp and discountsellingprice
UPDATE zepto
	SET mrp = mrp/100,
	discountsellingprice = discountsellingprice/100;


--data analysis

-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT 
	name,
	discountpercent,
	mrp
FROM zepto 
	ORDER BY discountpercent DESC
	LIMIT 10;

--Q2.What are the Products with High MRP but Out of Stock
SELECT 
	DISTINCT name,
	mrp
	outofstock
FROM zepto
	WHERE outofstock = True
	ORDER BY mrp DESC;

--Q3.Calculate Estimated Revenue for each category
SELECT 
	category,
	SUM(discountsellingprice * availablequantity) AS revenue
FROM zepto 
	GROUP BY category
	ORDER BY revenue DESC;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT 
	DISTINCT name,
	mrp,
	discountpercent
FROM zepto
	WHERE mrp > 500 
	AND discountpercent < 10;
	
-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT
	category,
	ROUND(AVG(discountpercent),2) AS avg_discount
FROM zepto
	GROUP BY category
	ORDER BY avg_discount DESC
	LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT 
	DISTINCT name,
	discountsellingprice,
	weightingrams,
	ROUND((discountsellingprice/weightingrams),2) AS pricePerGram
FROM zepto
	WHERE weightingrams >= 100
	ORDER BY pricePerGram;

--Q7.Group the products into categories like Low, Medium, Bulk.
SELECT
	name,
	CASE WHEN weightingrams <1000 THEN 'Low'
	WHEN weightingrams <5000 THEN 'Medium'
	ELSE 'Bulk'
	END AS weight_Category
FROM zepto;

--Q8.What is the Total Inventory Weight Per Category 
SELECT
	category,
	SUM(weightingrams * availablequantity) AS total_weight
FROM zepto
	GROUP BY category
	ORDER BY total_weight;


--Dashboard

--total revenue by category
SELECT 
	category,
	SUM(discountsellingprice * availablequantity) AS total_revenue
FROM zepto
	GROUP BY category
	ORDER BY total_revenue DESC;

--total revenue by product
SELECT 
	DISTINCT name,
	SUM(discountsellingprice * availablequantity) AS total_revenue
FROM zepto
	GROUP BY name
	ORDER BY total_revenue DESC;

--out of stock products
SELECT
	DISTINCT name,
	outofstock
FROM zepto
	WHERE outofstock = True;

-- top product for each category
WITH ranked_category AS(
	SELECT 	
		category,
		name,
		SUM(discountsellingprice * availablequantity) AS total_revenue,
		ROW_NUMBER() OVER(
			PARTITION BY category
			ORDER BY SUM(discountsellingprice * availablequantity) DESC
		) AS rnk
	FROM zepto
		GROUP BY category, name
)
SELECT
	category,
	name,
	total_revenue
FROM ranked_category
	WHERE rnk=1;

--products with highest discount
SELECT
	DISTINCT name,
	discountpercent
FROM zepto
	WHERE discountpercent > 0
	ORDER BY discountpercent DESC;



--show entire data
SELECT 
	*
FROM zepto;