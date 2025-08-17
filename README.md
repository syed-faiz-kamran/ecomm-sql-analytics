# E-commerce SQL Analytics (MySQL)

This is a **SQL-only** portfolio project that analyzes an e-commerce dataset.
It includes: data cleaning (views), an enriched fact view (allocated discount & shipping),
and business analytics (KPIs, cohorts, channel ROAS/CAC, product margin & returns).

---

## Folder structure

```
ecomm-sql-analytics/
├─ data/
│  ├─ customers.csv
│  ├─ products.csv
│  ├─ orders_small.csv
│  ├─ order_items_small.csv
│  ├─ returns_small.csv
│  ├─ marketing_spend.csv
│  └─ web_sessions.csv
└─ sql/
   ├─ 00_create_schema.sql
   ├─ 01_create_tables.sql
   ├─ 02_load_data.sql
   ├─ 03_cleaning_views.sql
   ├─ 04_enriched_views.sql
   ├─ 05_kpis.sql
   ├─ 06_channel_performance.sql
   ├─ 07_cohorts.sql
   └─ 08_products_returns.sql
```

> Note: `orders_small`, `order_items_small`, and `returns_small` keep the project lightweight and easy to run.

---

## How to run (MySQL Workbench)

1. Open **MySQL Workbench** and connect to your server.
2. Run the scripts in this order (File → Open SQL Script → Run):
   - `sql/00_create_schema.sql`
   - `sql/01_create_tables.sql`
   - **Edit one line** in `sql/02_load_data.sql` to point `@base` to your local **absolute path** of the `/data` folder.
     - Windows example: `SET @base = 'C:/Users/yourname/Documents/ecomm-sql-analytics/data';`
     - Mac example:     `SET @base = '/Users/yourname/Documents/ecomm-sql-analytics/data';`
   - Then run: `sql/02_load_data.sql`
   - Run: `sql/03_cleaning_views.sql`
   - Run: `sql/04_enriched_views.sql`
   - (Optional analytics to view results)
     - `sql/05_kpis.sql`
     - `sql/06_channel_performance.sql`
     - `sql/07_cohorts.sql`
     - `sql/08_products_returns.sql`

---

## How to run (Command Line)

From the project root folder:

```bash
# On Windows PowerShell (assuming mysql is on PATH)
mysql -u root -p < sql/00_create_schema.sql
mysql -u root -p < sql/01_create_tables.sql

# Edit the @base path in sql/02_load_data.sql first, then:
mysql -u root -p < sql/02_load_data.sql

mysql -u root -p < sql/03_cleaning_views.sql
mysql -u root -p < sql/04_enriched_views.sql

# analytics
mysql -u root -p < sql/05_kpis.sql
mysql -u root -p < sql/06_channel_performance.sql
mysql -u root -p < sql/07_cohorts.sql
mysql -u root -p < sql/08_products_returns.sql
```

---

## What this project demonstrates

- Pure SQL data cleaning (deduplication, fixing negative prices via views)
- Building an enriched fact model with discount & shipping allocation
- Core KPIs (revenue, orders, AOV, MoM growth)
- Cohort retention
- Channel conversion, ROAS and CAC
- Product/category margin and return-rate monitoring

---

## Notes

- Requires **MySQL 8+** (window functions).
- If `LOAD DATA LOCAL INFILE` is disabled, enable it in Workbench preferences or run:
  `SET GLOBAL local_infile = 1;` (requires privileges).
- This repo uses the smaller order files to keep file sizes reasonable.

---

## License

MIT
