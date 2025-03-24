select * from pizza_sales

--KPI Revenue
select SUM(total_price) as Total_Revenue
from pizza_sales;

--KPI Average Order $
SELECT SUM(total_price)/ COUNT(DISTINCT order_id) as Avg_Order
FROM pizza_sales;

--KPI Total Pizza Sold
SELECT SUM(quantity) as Total_Pizza_Sold 
FROM pizza_sales;

--KPI Total Orders placed
SELECT COUNT(DISTINCT order_id) as Total_Orders
FROM pizza_sales;

--KPI Average Pizzas Per Order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2))/COUNT(DISTINCT order_id) AS DECIMAL(10,2)) as Avg_Pizzas_Per_Order --quantity is an int value, which provides a rounded number when executed. convert to decimal to have non-rounded value.
FROM pizza_sales;

--Hourly Trend for Total Pizzas Sold
SELECT DATEPART(HOUR, order_time) as order_hour, SUM(quantity) as Total_Pizzas_Sold
FROM pizza_sales
GROUP BY DATEPART(HOUR, order_time)
ORDER BY DATEPART(HOUR, order_time) asc;

--Weekly Trend for Total Orders
SELECT DATEPART(ISO_WEEK, order_date) as week_number, YEAR(order_date) as Order_Year, COUNT(DISTINCT order_id) as Total_Orders
FROM pizza_sales
GROUP BY DATEPART(ISO_WEEK, order_date), YEAR(order_date)
ORDER BY DATEPART(ISO_WEEK, order_date);

-- Percentage of Sales by Pizza Category
with TotalSales as (
	SELECT SUM(total_price) as total_sales
	FROM pizza_sales
	WHERE MONTH(order_date) = 1
)

SELECT pizza_category, ROUND(SUM(total_price)*100/total_sales,3) as Percentage_of_Sales, SUM(total_price) as Total_Sales
from pizza_sales, TotalSales
WHERE MONTH(order_date) = 1 --when applying filter to query, make sure to include in CTE
GROUP BY pizza_category, total_sales;


-- Percentage of Sales by Pizza Size
with TotalSales as (
	SELECT SUM(total_price) as total_sales
	FROM pizza_sales
	WHERE DATEPART(quarter,order_date) = 1
)

SELECT pizza_size, ROUND(SUM(total_price)*100/total_sales,2) as Percentage_of_Sales, CAST(SUM(total_price) AS DECIMAL(10,2)) as Total_Sales
from pizza_sales, TotalSales
WHERE DATEPART(quarter,order_date) = 1
GROUP BY  pizza_size, total_sales
ORDER BY Percentage_of_Sales DESC;

--Top 5 Pizzas By Revenue
SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC;

--Bottom 5 Pizzas By Revenue
SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC;

--Top 5 Pizzas By Quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity_Sold DESC;

--Bottom 5 Pizzas By Quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Quantity_Sold
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity_Sold ASC;

--Top 5 Pizzas By Orders
SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC;

--Bottom 5 Pizzas By Orders
SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders ASC;

--Total Revenue by Day
SELECT DATENAME(WEEKDAY, order_date) as Day_Of_Week, SUM(total_price) as Total_Revenue
FROM pizza_sales
GROUP BY DATENAME(WEEKDAY, order_date)
ORDER BY Total_Revenue DESC;

--Total Orders by Day
SELECT DATENAME(WEEKDAY, order_date) as Day_Of_Week, COUNT(DISTINCT order_id) as Total_Orders
FROM pizza_sales
GROUP BY DATENAME(WEEKDAY, order_date)
ORDER BY Total_Orders DESC;