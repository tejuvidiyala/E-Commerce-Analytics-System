-- 1. Total revenue per category
SELECT p.category, ROUND(SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100.0)),2) AS revenue
FROM order_items oi JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;

-- Revenue per customer
SELECT o.customer_id, ROUND(SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100.0)),2) AS revenue
FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.customer_id IS NOT NULL
GROUP BY o.customer_id
ORDER BY revenue DESC
limit 5;


-- Revenue per month
SELECT strftime('%Y-%m', o.order_date) AS month,
       ROUND(SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100.0)),2) AS revenue
FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month
limit 5;

-- 2. Top 10 customers by total order value
SELECT o.customer_id, c.customer_name,
       ROUND(SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100.0)),2) AS total_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name
ORDER BY total_value DESC
LIMIT 5;

-- 3. Month-wise order count, last 12 months
SELECT strftime('%Y-%m', order_date) AS month, COUNT(*) AS order_count
FROM orders
WHERE order_date >= date('now', '-12 months')
GROUP BY month
ORDER BY month
limit 5;

-- Top products by quantity sold and revenue
SELECT p.product_name,
       SUM(CASE WHEN oi.quantity > 0 THEN oi.quantity ELSE 0 END) AS units_sold,
       ROUND(SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100.0)),2) AS revenue
FROM order_items oi JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY revenue DESC
LIMIT ;

-- Average order value (AOV) by customer segment (customer_type)
WITH order_value AS (
    SELECT o.order_id, o.customer_id,
           SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100.0)) AS order_total
    FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id
)
SELECT c.customer_type, ROUND(AVG(ov.order_total),2) AS avg_order_value
FROM order_value ov JOIN customers c ON ov.customer_id = c.customer_id
GROUP BY c.customer_type
lIMIT 5;

-- 4. Customers who placed orders but never had any item delivered
SELECT DISTINCT o.customer_id
FROM orders o
WHERE o.customer_id IS NOT NULL
  AND o.customer_id NOT IN (
      SELECT customer_id FROM orders WHERE status = 'DELIVERED' AND customer_id IS NOT NULL
  )
lIMIT 5;

-- 5. Products with more returns than purchases (returns = negative quantity)
SELECT p.product_name,
       SUM(CASE WHEN oi.quantity < 0 THEN -oi.quantity ELSE 0 END) AS returned_units,
       SUM(CASE WHEN oi.quantity > 0 THEN oi.quantity ELSE 0 END) AS purchased_units
FROM order_items oi JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id
HAVING returned_units > purchased_units;

-- 6. Return rate per category
SELECT p.category,
       ROUND(1.0 * SUM(CASE WHEN oi.quantity < 0 THEN -oi.quantity ELSE 0 END) /
             NULLIF(SUM(ABS(oi.quantity)),0), 4) AS return_rate
FROM order_items oi JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category;