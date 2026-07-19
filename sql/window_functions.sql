-- 7. Running total of revenue per region, ordered by date
WITH daily AS (
    SELECT o.region_code, o.order_date AS order_date,
           SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100.0)) AS daily_revenue
    FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.region_code, o.order_date
)
SELECT region_code, order_date, daily_revenue,
       SUM(daily_revenue) OVER (PARTITION BY region_code ORDER BY order_date
                                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM daily
ORDER BY region_code, order_date;

-- 8. DENSE_RANK: rank products by revenue within category
WITH prod_rev AS (
    SELECT p.category, p.product_name,
           SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100.0)) AS total_revenue
    FROM order_items oi JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_id
)
SELECT category, product_name, total_revenue,
       DENSE_RANK() OVER (PARTITION BY category ORDER BY total_revenue DESC) AS rank_in_category
FROM prod_rev
ORDER BY category, rank_in_category;

-- 9. LAG: days between consecutive orders per customer, flag "At Risk"
WITH gaps AS (
    SELECT customer_id, order_date,
           LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_date
    FROM orders
    WHERE customer_id IS NOT NULL
),
gap_days AS (
    SELECT customer_id, order_date, previous_order_date,
           CASE WHEN previous_order_date IS NOT NULL
                THEN julianday(order_date) - julianday(previous_order_date) END AS days_gap
    FROM gaps
)
SELECT g.*, 
       CASE WHEN avg_gap.avg_days_gap > 30 THEN 'At Risk' ELSE 'Active' END AS risk_flag
FROM gap_days g
JOIN (
    SELECT customer_id, AVG(days_gap) AS avg_days_gap
    FROM gap_days GROUP BY customer_id
) avg_gap ON g.customer_id = avg_gap.customer_id
ORDER BY g.customer_id, g.order_date;

-- 10. Multi-level CTE: monthly revenue per customer -> tier -> count per month
WITH monthly_rev AS (
    SELECT o.customer_id, strftime('%Y-%m', o.order_date) AS month,
           SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100.0)) AS revenue
    FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id IS NOT NULL
    GROUP BY o.customer_id, month
),
tiered AS (
    SELECT month, customer_id,
           CASE WHEN revenue > 10000 THEN 'High'
                WHEN revenue >= 5000 THEN 'Medium'
                ELSE 'Low' END AS tier
    FROM monthly_rev
)
SELECT month, tier, COUNT(*) AS customer_count
FROM tiered
GROUP BY month, tier
ORDER BY month, tier;

-- 11. NTILE: quartile segmentation by lifetime value
WITH ltv AS (
    SELECT o.customer_id,
           SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100.0)) AS total_value
    FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id IS NOT NULL
    GROUP BY o.customer_id
)
SELECT customer_id, total_value,
       NTILE(4) OVER (ORDER BY total_value DESC) AS quartile,
       CASE NTILE(4) OVER (ORDER BY total_value DESC)
            WHEN 1 THEN 'Platinum'
            WHEN 2 THEN 'Gold'
            WHEN 3 THEN 'Silver'
            ELSE 'Bronze' END AS quartile_label
FROM ltv
ORDER BY total_value DESC;

-- 12. Year-over-year monthly revenue comparison
WITH monthly AS (
    SELECT CAST(strftime('%Y', o.order_date) AS INTEGER) AS year,
           CAST(strftime('%m', o.order_date) AS INTEGER) AS month,
           SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100.0)) AS revenue
    FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY year, month
)
SELECT curr.year, curr.month, curr.revenue,
       prev.revenue AS prev_year_revenue,
       CASE WHEN prev.revenue IS NULL OR prev.revenue = 0 THEN NULL
            ELSE ROUND(100.0*(curr.revenue - prev.revenue)/prev.revenue, 2) END AS yoy_growth_percent
FROM monthly curr
LEFT JOIN monthly prev ON curr.year = prev.year + 1 AND curr.month = prev.month
ORDER BY curr.year, curr.month;

-- 13. First/last purchased category per customer, flag shift
WITH cat_purchases AS (
    SELECT o.customer_id, o.order_date, p.category
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.customer_id IS NOT NULL
),
ordered AS (
    SELECT customer_id, category,
           FIRST_VALUE(category) OVER (PARTITION BY customer_id ORDER BY order_date) AS first_category,
           LAST_VALUE(category) OVER (PARTITION BY customer_id ORDER BY order_date
                                       ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_category
    FROM cat_purchases
)
SELECT DISTINCT customer_id, first_category, last_category,
       CASE WHEN first_category != last_category THEN 'Yes' ELSE 'No' END AS category_shift
FROM ordered;

-- 14. Cumulative distribution: % of revenue from top N% of customers
WITH cust_rev AS (
    SELECT o.customer_id,
           SUM(oi.quantity*oi.unit_price*(1-oi.discount_percent/100.0)) AS revenue
    FROM orders o JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id IS NOT NULL
    GROUP BY o.customer_id
),
totals AS (SELECT SUM(revenue) AS grand_total FROM cust_rev)
SELECT customer_id, revenue,
       SUM(revenue) OVER (ORDER BY revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue,
       ROUND(100.0 * SUM(revenue) OVER (ORDER BY revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
             / (SELECT grand_total FROM totals), 2) AS cumulative_percent
FROM cust_rev
ORDER BY revenue DESC;

-- 16. Self-join: products frequently bought together (same order, A-B once only)
SELECT p1.product_name AS product_a, p2.product_name AS product_b, COUNT(*) AS times_bought_together
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.product_id
JOIN products p2 ON oi2.product_id = p2.product_id
GROUP BY oi1.product_id, oi2.product_id
ORDER BY times_bought_together DESC
LIMIT 20;