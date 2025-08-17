USE ecomm;

CREATE OR REPLACE VIEW orders_clean AS
WITH ranked AS (
  SELECT o.*,
         ROW_NUMBER() OVER (PARTITION BY o.order_id ORDER BY o.order_date DESC) rn
  FROM orders o
)
SELECT order_id, customer_id, order_date, attribution_channel, status, shipping_cost, discount_amount
FROM ranked WHERE rn = 1;

CREATE OR REPLACE VIEW order_items_clean AS
SELECT
  i.order_id,
  i.product_id,
  i.quantity,
  ABS(i.unit_price) AS unit_price_fixed,
  CAST(ABS(i.unit_price) * i.quantity AS DECIMAL(10,2)) AS line_total_fixed,
  i.cogs
FROM order_items i
JOIN orders_clean oc ON oc.order_id = i.order_id;

CREATE OR REPLACE VIEW customers_clean AS
SELECT
  customer_id, signup_date, acquisition_channel,
  COALESCE(region,'Unknown') AS region, is_vip
FROM customers;
