# Power BI Dashboard Build Guide
### E-Commerce Sales & Customer Performance Dashboard

---

## 📊 Overview
This guide walks you through building a clean, 1-page executive dashboard in Power BI using the cleaned tables:
- `dim_customers.csv`
- `dim_products.csv`
- `fact_orders.csv`
- `fact_order_items.csv`

---

## 🛠️ Step 1: Load Data into Power BI
1. Open **Power BI Desktop**.
2. Click **Get Data** $\to$ **Text/CSV**.
3. Import all 4 files from `data/cleaned/`.
4. Click **Load**.

---

## ⭐ Step 2: Establish Data Model Relationships (Star Schema)
Go to the **Model View** (icon on the left) and connect the tables:
1. Drag `customer_id` from `dim_customers` to `customer_id` in `fact_orders` (1-to-Many).
2. Drag `product_id` from `dim_products` to `product_id` in `fact_order_items` (1-to-Many).
3. Drag `order_id` from `fact_orders` to `order_id` in `fact_order_items` (1-to-Many).

---

## 📐 Step 3: Essential DAX Measures
Create a new measure table or add these measures to `fact_orders`:

```dax
-- 1. Total Revenue
Total Revenue = SUM(fact_orders[total_amount])

-- 2. Total Orders
Total Orders = DISTINCTCOUNT(fact_orders[order_id])

-- 3. Total Customers
Total Customers = DISTINCTCOUNT(dim_customers[customer_id])

-- 4. Average Order Value (AOV)
Average Order Value = DIVIDE([Total Revenue], [Total Orders], 0)
```

---

## 🖥️ Step 4: Visuals Layout (1-Page Executive Dashboard)

1. **Top Row: 4 KPI Cards**
   - Card 1: `Total Revenue` (formatted as Currency)
   - Card 2: `Total Orders`
   - Card 3: `Total Customers`
   - Card 4: `Average Order Value`

2. **Middle Left: Line Chart**
   - **X-axis:** `order_date` (Month or Day)
   - **Y-axis:** `Total Revenue`
   - **Title:** Monthly Revenue Trend

3. **Middle Right: Donut Chart**
   - **Legend:** `payment_method`
   - **Values:** `Total Orders`
   - **Title:** Sales by Payment Method (UPI, Cards, Cash)

4. **Bottom Left: Bar Chart**
   - **Y-axis:** `category` (from `dim_products`)
   - **X-axis:** `Total Revenue`
   - **Title:** Revenue by Product Category

5. **Bottom Right: Column Chart / Map**
   - **Category:** `city` (from `dim_customers`)
   - **Values:** `Total Revenue`
   - **Title:** Top Revenue Contributing Cities
