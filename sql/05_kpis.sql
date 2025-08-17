USE ecomm;

WITH base AS (
  SELECT DATE_FORMAT(order_date, '%Y-%m-01') AS month_start,
         order_id,
         SUM(net_revenue) AS order_net_revenue
  FROM order_items_enriched
  WHERE status='fulfilled'
  GROUP BY DATE_FORMAT(order_date, '%Y-%m-01'), order_id
),
agg AS (
  SELECT month_start,
         SUM(order_net_revenue) AS revenue,
         COUNT(DISTINCT order_id) AS orders,
         AVG(order_net_revenue) AS aov
  FROM base GROUP BY month_start
)
SELECT a.month_start,
       ROUND(a.revenue,2) AS revenue,
       a.orders,
       ROUND(a.aov,2) AS avg_order_value,
       ROUND((a.revenue - LAG(a.revenue) OVER (ORDER BY a.month_start))
              / NULLIF(LAG(a.revenue) OVER (ORDER BY a.month_start),0) * 100, 2) AS revenue_mom_pct
FROM agg a
ORDER BY a.month_start;
