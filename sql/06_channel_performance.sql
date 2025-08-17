USE ecomm;

CREATE OR REPLACE VIEW channel_daily AS
SELECT DATE(o.order_date) AS dt,
       o.attribution_channel AS channel,
       COUNT(DISTINCT o.order_id) AS orders,
       ROUND(SUM(oie.net_revenue),2) AS revenue
FROM orders_clean o
JOIN order_items_enriched oie ON o.order_id=oie.order_id
WHERE o.status='fulfilled'
GROUP BY DATE(o.order_date), o.attribution_channel;

-- sessions, spend, orders, revenue, CR, ROAS by day + channel
SELECT s.date, s.channel, s.sessions, m.spend,
       COALESCE(cd.orders,0) AS orders,
       COALESCE(cd.revenue,0) AS revenue,
       ROUND(COALESCE(cd.orders,0)/NULLIF(s.sessions,0),4) AS conversion_rate,
       ROUND(COALESCE(cd.revenue,0)/NULLIF(m.spend,0),2)   AS roas
FROM web_sessions s
LEFT JOIN marketing_spend m ON m.date=s.date AND m.channel=s.channel
LEFT JOIN channel_daily cd  ON cd.dt=s.date AND cd.channel=s.channel
ORDER BY s.date, s.channel;

-- monthly CAC (from customer signups)
WITH new_cust AS (
  SELECT DATE_FORMAT(signup_date, '%Y-%m-01') AS month_start,
         acquisition_channel AS channel,
         COUNT(*) AS new_customers
  FROM customers_clean
  GROUP BY DATE_FORMAT(signup_date, '%Y-%m-01'), acquisition_channel
),
spend_m AS (
  SELECT DATE_FORMAT(date, '%Y-%m-01') AS month_start,
         channel,
         SUM(spend) AS spend
  FROM marketing_spend
  GROUP BY DATE_FORMAT(date, '%Y-%m-01'), channel
)
SELECT n.month_start, n.channel, n.new_customers, s.spend,
       ROUND(s.spend/NULLIF(n.new_customers,0),2) AS cac
FROM new_cust n
LEFT JOIN spend_m s ON s.month_start=n.month_start AND s.channel=n.channel
ORDER BY n.month_start, n.channel;
