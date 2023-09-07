USE pizza_sales;

# create a view that have pizza_id, pizza_type_id, name, category, size, price, and ingredients columns

CREATE VIEW pizza_details AS
SELECT p.pizza_id, p.pizza_type_id, pt.name, pt.category, p.size, p.price, pt.ingredients
FROM pizzas p
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id;

SELECT * 
FROM pizza_details;

#from orders table change the datatype for date and time. Set date to date and time to time datatype

ALTER TABLE orders
MODIFY date DATE;

ALTER TABLE orders
MODIFY time TIME;

#total revenue for all pizza sales

SELECT round(sum(od.quantity * p.price),2) as total_revenue
FROM pizzas p 
JOIN order_details od
ON p.pizza_id = od.pizza_id;

#total number of pizzas sold

SELECT sum(quantity) as pizza_sold
FROM order_details;

# Average order values
SELECT round(sum(od.quantity * p.price) / count(distinct(od.order_id)),2) AS avg_order_value
FROM pizzas p 
JOIN order_details od
ON p.pizza_id = od.pizza_id;
 
# average number of pizza per order
SELECT round(sum(od.quantity) / count(distinct(od.order_id)),0) AS avg_pizza_per_order
FROM pizzas p 
JOIN order_details od
ON p.pizza_id = od.pizza_id;

#total revenue and number of orders per category

SELECT pt.category, round(sum(od.quantity * p.price),2) AS total_revenue, count(distinct(od.order_id)) as total_orders
FROM pizzas p 
JOIN order_details od
ON p.pizza_id = od.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_revenue DESC;

#total revenue and number of orders per size
SELECT p.size, round(sum(od.quantity * p.price),2) AS total_revenue, count(distinct(od.order_id)) as total_orders
FROM pizzas p 
JOIN order_details od
ON p.pizza_id = od.pizza_id
JOIN pizza_types pt
GROUP BY p.size
ORDER BY total_revenue DESC;

# hourly, daily, monthly, trend in order and revenue of pizza
# hourly
SELECT 
CASE
WHEN HOUR(time) BETWEEN 9 AND 12 THEN 'Late Morning'
WHEN HOUR(time) BETWEEN 12 AND 15 THEN 'Lunch'
WHEN HOUR(time) BETWEEN 15 AND 18 THEN 'Mid Afternoon'
WHEN HOUR(time) BETWEEN 18 AND 21 THEN 'Dinner'
WHEN HOUR(time) BETWEEN 21 AND 24 THEN 'Late Night'
ELSE 'others'
END as meal_time, count(DISTINCT(od.order_id)) AS order_count
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY meal_time
ORDER BY order_count DESC;

#daily
SELECT DAYNAME(date) AS week_day, count(DISTINCT(od.order_id)) as total_orders
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY week_day
ORDER BY total_orders DESC;

# monthly
SELECT MONTHNAME(date) AS month_name, count(DISTINCT(od.order_id)) as total_orders
FROM orders o
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY month_name
ORDER BY total_orders DESC;

# most ordered pizza 

SELECT pt.name, count(od.pizza_id) as pizza_order
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY pizza_order DESC;

# most ordered pizza wtih size
SELECT pt.name, p.size ,count(od.pizza_id) as pizza_order
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name, p.size
ORDER BY pizza_order DESC;

# Top 5 pizzas by revenue

SELECT pt.name, sum(od.quantity * p.price) as revenue
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 5;

# top 5 pizzas by sales

SELECT pt.name, sum(od.quantity) as sale
FROM order_details od
JOIN pizzas p
ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY sale DESC
LIMIT 5;

 # pizza max price 
 SELECT pt.name, p.price
 FROM pizzas p
 JOIN pizza_types pt
 ON p.pizza_type_id = pt.pizza_type_id
 ORDER BY price DESC
 limit 1;
 
 
 #pizzas min price
SELECT pt.name, p.price
FROM pizzas p
JOIN pizza_types pt
ON p.pizza_type_id = pt.pizza_type_id
ORDER BY price
limit 1;


