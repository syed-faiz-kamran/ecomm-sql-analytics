USE ecomm;

WITH sold AS (
  SELECT p.category,
         SUM(oie.line_total_fixed) AS gross_revenue,
         SUM(oie.net_revenue) AS net_revenue,
         SUM(oie.contribution_margin) AS contribution_margin,
         SUM(oie.quantity) AS qty_sold
  FROM order_items_enriched oie
  JOIN products p ON p.product_id=oie.product_id
  WHERE oie.status='fulfilled'
  GROUP BY p.category
),
ret AS (
  SELECT p.category, SUM(r.quantity) AS qty_returned
  FROM returns r JOIN products p ON p.product_id=r.product_id
  GROUP BY p.category
)
SELECT s.category,
       ROUND(s.gross_revenue,2) AS gross_revenue,
       ROUND(s.net_revenue,2) AS net_revenue,
       ROUND(s.contribution_margin,2) AS contribution_margin,
       ROUND(s.contribution_margin/NULLIF(s.net_revenue,0)*100,2) AS margin_pct,
       s.qty_sold, COALESCE(r.qty_returned,0) AS qty_returned,
       ROUND(COALESCE(r.qty_returned,0)/NULLIF(s.qty_sold,0)*100,2) AS return_rate_pct
FROM sold s LEFT JOIN ret r USING (category)
ORDER BY net_revenue DESC;

-- sku return hotlist
WITH sku_sold AS (
  SELECT product_id, SUM(quantity) AS sold_qty
  FROM order_items_enriched
  WHERE status='fulfilled'
  GROUP BY product_id
),
sku_ret AS (
  SELECT product_id, SUM(quantity) AS ret_qty
  FROM returns GROUP BY product_id
)
SELECT p.product_id, p.category, p.subcategory,
       ss.sold_qty, COALESCE(sr.ret_qty,0) AS ret_qty,
       ROUND(COALESCE(sr.ret_qty,0)/NULLIF(ss.sold_qty,0)*100,2) AS return_rate_pct
FROM sku_sold ss
JOIN products p ON p.product_id=ss.product_id
LEFT JOIN sku_ret sr ON sr.product_id=ss.product_id
WHERE ss.sold_qty >= 50
  AND COALESCE(sr.ret_qty,0)/NULLIF(ss.sold_qty,0) >= 0.10
ORDER BY return_rate_pct DESC, ss.sold_qty DESC;
