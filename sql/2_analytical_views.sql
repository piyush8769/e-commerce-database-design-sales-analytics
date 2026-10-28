-- ==============================================================================
-- Executive Analytical Views for Power BI & Business Reporting
-- Author: Piyush Kumar Singh
-- ==============================================================================

USE ecommerce_sales_warehouse;

-- 1. Daily Sales Performance View (Daily Revenue & AOV)
CREATE OR REPLACE VIEW vw_daily_sales_performance AS
SELECT 
    order_date,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS active_customers,
    SUM(total_amount) AS gross_revenue,
    ROUND(SUM(total_amount) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM fact_orders
GROUP BY order_date
ORDER BY order_date ASC;

-- 2. Top-Selling Products & Categories View
CREATE OR REPLACE VIEW vw_top_selling_products AS
SELECT 
    p.category,
    p.product_name,
    SUM(i.quantity) AS total_units_sold,
    SUM(i.total_item_price) AS total_revenue,
    ROUND(AVG(i.unit_price), 2) AS avg_selling_price
FROM fact_order_items i
JOIN dim_products p ON i.product_id = p.product_id
GROUP BY p.category, p.product_name
ORDER BY total_revenue DESC;

-- 3. Customer Lifetime Spending & Frequency View
CREATE OR REPLACE VIEW vw_customer_spending_summary AS
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    c.state,
    COUNT(DISTINCT o.order_id) AS total_orders_placed,
    SUM(o.total_amount) AS total_lifetime_spend,
    ROUND(AVG(o.total_amount), 2) AS customer_avg_order_value
FROM fact_orders o
JOIN dim_customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name, c.city, c.state
ORDER BY total_lifetime_spend DESC;

-- 4. City-Level Geographic Revenue View
CREATE OR REPLACE VIEW vw_city_level_revenue AS
SELECT 
    c.city,
    c.state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_city_revenue,
    ROUND(SUM(o.total_amount) * 100.0 / (SELECT SUM(total_amount) FROM fact_orders), 2) AS pct_of_total_revenue
FROM fact_orders o
JOIN dim_customers c ON o.customer_id = c.customer_id
GROUP BY c.city, c.state
ORDER BY total_city_revenue DESC;
