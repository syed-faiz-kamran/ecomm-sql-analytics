USE ecomm;

CREATE OR REPLACE VIEW order_sums AS
SELECT order_id,
       SUM(line_total_fixed) AS order_line_total,
       SUM(cogs)            AS order_cogs_total
FROM order_items_clean
GROUP BY order_id;

CREATE OR REPLACE VIEW order_items_enriched AS
SELECT
  oi.order_id,
  oc.customer_id,
  oc.order_date,
  oc.attribution_channel,
  oc.status,
  p.product_id,
  p.category,
  p.subcategory,
  oi.quantity,
  oi.unit_price_fixed,
  oi.line_total_fixed,
  oi.cogs,
  os.order_line_total,
  oc.discount_amount,
  oc.shipping_cost,
  CASE WHEN os.order_line_total>0 THEN (oi.line_total_fixed/os.order_line_total)*oc.discount_amount ELSE 0 END AS alloc_discount,
  CASE WHEN os.order_line_total>0 THEN (oi.line_total_fixed/os.order_line_total)*oc.shipping_cost ELSE 0 END AS alloc_shipping,
  (oi.line_total_fixed - CASE WHEN os.order_line_total>0 THEN (oi.line_total_fixed/os.order_line_total)*oc.discount_amount ELSE 0 END) AS net_revenue,
  (
    (oi.line_total_fixed - CASE WHEN os.order_line_total>0 THEN (oi.line_total_fixed/os.order_line_total)*oc.discount_amount ELSE 0 END)
    - oi.cogs
    - CASE WHEN os.order_line_total>0 THEN (oi.line_total_fixed/os.order_line_total)*oc.shipping_cost ELSE 0 END
  ) AS contribution_margin
FROM order_items_clean oi
JOIN orders_clean oc ON oc.order_id = oi.order_id
JOIN order_sums os   ON os.order_id = oi.order_id
JOIN products p      ON p.product_id = oi.product_id;
