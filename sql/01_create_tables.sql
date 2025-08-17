DROP TABLE IF EXISTS returns;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS marketing_spend;
DROP TABLE IF EXISTS web_sessions;

CREATE TABLE customers (
  customer_id         VARCHAR(10) PRIMARY KEY,
  signup_date         DATE,
  acquisition_channel VARCHAR(50),
  region              VARCHAR(20) NULL,
  is_vip              TINYINT(1) NOT NULL
);

CREATE TABLE products (
  product_id  VARCHAR(10) PRIMARY KEY,
  category    VARCHAR(50),
  subcategory VARCHAR(50),
  cost        DECIMAL(10,2),
  price       DECIMAL(10,2)
);

CREATE TABLE orders (
  order_id            VARCHAR(12) PRIMARY KEY,
  customer_id         VARCHAR(10),
  order_date          DATETIME,
  attribution_channel VARCHAR(50),
  status              VARCHAR(20),
  shipping_cost       DECIMAL(10,2),
  discount_amount     DECIMAL(10,2),
  CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
  order_id    VARCHAR(12),
  product_id  VARCHAR(10),
  quantity    INT,
  unit_price  DECIMAL(10,2),
  line_total  DECIMAL(10,2),
  cogs        DECIMAL(10,2),
  PRIMARY KEY (order_id, product_id),
  CONSTRAINT fk_oi_order   FOREIGN KEY (order_id)   REFERENCES orders(order_id),
  CONSTRAINT fk_oi_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE returns (
  return_id     VARCHAR(12) PRIMARY KEY,
  order_id      VARCHAR(12),
  product_id    VARCHAR(10),
  quantity      INT,
  refund_amount DECIMAL(10,2),
  return_date   DATE,
  reason        VARCHAR(50),
  CONSTRAINT fk_returns_order   FOREIGN KEY (order_id)   REFERENCES orders(order_id),
  CONSTRAINT fk_returns_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE marketing_spend (
  date    DATE,
  channel VARCHAR(50),
  spend   DECIMAL(10,2),
  PRIMARY KEY (date, channel)
);

CREATE TABLE web_sessions (
  date     DATE,
  channel  VARCHAR(50),
  sessions INT,
  PRIMARY KEY (date, channel)
);
