-- 15. Cohort analysis by registration month, retention months 0-3
WITH cohort AS (
    SELECT customer_id, strftime('%Y-%m', registration_date) AS cohort_month
    FROM customers
),
customer_orders AS (
    SELECT o.customer_id, strftime('%Y-%m', o.order_date) AS order_month
    FROM orders o WHERE o.customer_id IS NOT NULL
),
joined AS (
    SELECT c.customer_id, c.cohort_month, co.order_month,
           (CAST(strftime('%Y', co.order_month || '-01') AS INTEGER) * 12 +
            CAST(strftime('%m', co.order_month || '-01') AS INTEGER)) -
           (CAST(strftime('%Y', c.cohort_month || '-01') AS INTEGER) * 12 +
            CAST(strftime('%m', c.cohort_month || '-01') AS INTEGER)) AS month_offset
    FROM cohort c
    JOIN customer_orders co ON c.customer_id = co.customer_id
),
cohort_sizes AS (
    SELECT cohort_month, COUNT(DISTINCT customer_id) AS cohort_size
    FROM cohort GROUP BY cohort_month
)
SELECT j.cohort_month, j.month_offset,
       COUNT(DISTINCT j.customer_id) AS active_customers,
       cs.cohort_size,
       ROUND(100.0 * COUNT(DISTINCT j.customer_id) / cs.cohort_size, 2) AS retention_rate
FROM joined j
JOIN cohort_sizes cs ON j.cohort_month = cs.cohort_month
WHERE j.month_offset BETWEEN 0 AND 3
GROUP BY j.cohort_month, j.month_offset
ORDER BY j.cohort_month, j.month_offset;