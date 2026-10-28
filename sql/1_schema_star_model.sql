-- ==============================================================================
-- E-Commerce Data Warehouse Schema (Star Schema)
-- Database: MySQL 8.0+
-- Author: Piyush Kumar Singh
-- Description: Simple, production-clean dimensional model for retail analytics.
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS ecommerce_sales_warehouse;
USE ecommerce_sales_warehouse;

-- ------------------------------------------------------------------------------
-- 1. DIMENSION TABLES (The "Who" and "What" - Lookup Entities)
-- ------------------------------------------------------------------------------

-- Customer Dimension Table
CREATE TABLE IF NOT EXISTS dim_customers (
    customer_id VARCHAR(32) PRIMARY KEY,
    customer_name VARCHAR(128) NOT NULL,
    email VARCHAR(128) NOT NULL,
    city VARCHAR(64) NOT NULL,
    state VARCHAR(64) NOT NULL,
    INDEX idx_cust_city (city)
) ENGINE=InnoDB;

-- Product Dimension Table
CREATE TABLE IF NOT EXISTS dim_products (
    product_id VARCHAR(32) PRIMARY KEY,
    product_name VARCHAR(128) NOT NULL,
    category VARCHAR(64) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    INDEX idx_prod_category (category)
) ENGINE=InnoDB;

-- ------------------------------------------------------------------------------
-- 2. FACT TABLES (The "Numbers" and "Transactions")
-- ------------------------------------------------------------------------------

-- Orders Fact Table (Header level: 1 row per order)
CREATE TABLE IF NOT EXISTS fact_orders (
    order_id VARCHAR(32) PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id VARCHAR(32) NOT NULL,
    payment_method VARCHAR(32) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    INDEX idx_order_date (order_date),
    INDEX idx_order_cust (customer_id),
    CONSTRAINT fk_orders_customer 
        FOREIGN KEY (customer_id) REFERENCES dim_customers(customer_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Order Items Fact Table (Granular line item level: 1 row per item in order)
CREATE TABLE IF NOT EXISTS fact_order_items (
    item_id VARCHAR(32) PRIMARY KEY,
    order_id VARCHAR(32) NOT NULL,
    product_id VARCHAR(32) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_item_price DECIMAL(10, 2) NOT NULL,
    INDEX idx_items_order (order_id),
    INDEX idx_items_prod (product_id),
    CONSTRAINT fk_items_order 
        FOREIGN KEY (order_id) REFERENCES fact_orders(order_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_items_product 
        FOREIGN KEY (product_id) REFERENCES dim_products(product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;
