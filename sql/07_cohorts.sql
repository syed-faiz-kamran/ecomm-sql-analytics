USE ecomm;

WITH coh AS (
  SELECT customer_id,
         DATE_FORMAT(MIN(order_date),'%Y-%m-01') AS cohort_month
  FROM orders_clean
  WHERE status='fulfilled'
  GROUP BY customer_id
),
cust_orders AS (
  SELECT o.customer_id,
         DATE_FORMAT(o.order_date,'%Y-%m-01') AS order_month
  FROM orders_clean o
  WHERE o.status='fulfilled'
),
joined AS (
  SELECT c.cohort_month, co.order_month, COUNT(DISTINCT co.customer_id) AS active_customers
  FROM coh c JOIN cust_orders co USING (customer_id)
  GROUP BY c.cohort_month, co.order_month
),
denom AS (
  SELECT cohort_month, COUNT(*) AS cohort_size
  FROM coh GROUP BY cohort_month
)
SELECT j.cohort_month, j.order_month, d.cohort_size,
       ROUND(j.active_customers/d.cohort_size*100,2) AS retention_pct
FROM joined j JOIN denom d USING (cohort_month)
ORDER BY j.cohort_month, j.order_month;
