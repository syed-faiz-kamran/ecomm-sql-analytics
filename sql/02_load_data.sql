USE ecomm;

-- CHANGE THIS PATH to your local /data folder:
-- Windows example: SET @base = 'C:/Users/yourname/Documents/ecomm-sql-analytics/data';
-- Mac example:     SET @base = '/Users/yourname/Documents/ecomm-sql-analytics/data';
SET @base = '/ABSOLUTE/PATH/TO/ecomm-sql-analytics/data';

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE CONCAT(@base, '/customers.csv')
INTO TABLE customers
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS
(customer_id, signup_date, acquisition_channel, region, is_vip);

LOAD DATA LOCAL INFILE CONCAT(@base, '/products.csv')
INTO TABLE products
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS
(product_id, category, subcategory, cost, price);

LOAD DATA LOCAL INFILE CONCAT(@base, '/orders_small.csv')
INTO TABLE orders
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS
(order_id, customer_id, @order_date, attribution_channel, status, shipping_cost, discount_amount)
SET order_date = STR_TO_DATE(@order_date, '%Y-%m-%d %H:%i:%s');

LOAD DATA LOCAL INFILE CONCAT(@base, '/order_items_small.csv')
INTO TABLE order_items
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS
(order_id, product_id, quantity, unit_price, line_total, cogs);

LOAD DATA LOCAL INFILE CONCAT(@base, '/returns_small.csv')
INTO TABLE returns
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS
(return_id, order_id, product_id, quantity, refund_amount, return_date, reason);

LOAD DATA LOCAL INFILE CONCAT(@base, '/marketing_spend.csv')
INTO TABLE marketing_spend
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS
(date, channel, spend);

LOAD DATA LOCAL INFILE CONCAT(@base, '/web_sessions.csv')
INTO TABLE web_sessions
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n' IGNORE 1 ROWS
(date, channel, sessions);
