# Distribution of Records by Region
SELECT region,
 COUNT(*) AS total FROM fact_inventory 
 GROUP BY region 
 ORDER BY total DESC;

# Check Price Range
SELECT MIN(price) AS Min_Price, 
MAX(price) AS Max_Price, 
AVG(price) AS Avg_Price 
FROM fact_inventory;

#Discount and Promotion Analysis
SELECT discount, 
COUNT(*) AS count FROM fact_inventory 
GROUP BY discount ORDER BY discount;


SELECT holiday_promotion, 
COUNT(*) FROM fact_inventory 
GROUP BY holiday_promotion;

#Join Sanity Checks
SELECT COUNT(*) 
FROM fact_inventory f
LEFT JOIN dim_store s ON f.store_id = s.store_id
WHERE s.store_id IS NULL;

SELECT COUNT(*) 
FROM fact_inventory f
LEFT JOIN dim_product p ON f.product_id = p.product_id
WHERE p.product_id IS NULL;

#Store-Level Monthly Demand Forecast
SELECT vw_days_inventory_leftstore_id,
DATE_FORMAT(date, '%Y-%m') AS month,
ROUND(SUM(demand_forecast), 2) AS total_forecast
FROM fact_inventory
GROUP BY store_id, month
ORDER BY store_id, month;

### Query - Overstock vs. Understock Analysis
#identifying products where inventory level is very high or low relative to demand
SELECT product_id,store_id,
AVG(inventory_level) AS avg_inventory,
AVG(demand_forecast) AS avg_demand,
ROUND(AVG(inventory_level) - AVG(demand_forecast), 2) AS inventory_gap
FROM fact_inventory
GROUP BY product_id, store_id
ORDER BY inventory_gap DESC;
#Positive inventory_gap = overstoceked
#Negitive inventory_gap = understocked



### Query - Promotion Effectiveness
#Evaluate units sold on promotion vs. not on promotion
SELECT holiday_promotion,
ROUND(AVG(units_sold), 2) AS avg_units_sold
FROM fact_inventory
GROUP BY holiday_promotion;


### Query - Regional Demand vs. Supply
SELECT region,
    ROUND(SUM(units_ordered), 2) AS total_ordered,
    ROUND(SUM(units_sold), 2) AS total_sold,
    ROUND(SUM(units_ordered) - SUM(units_sold), 2) AS demand_supply_gap
FROM fact_inventory
GROUP BY region
ORDER BY demand_supply_gap DESC;


### Query - Forecast Accuracy by Store
#Flag stores where forecasts were way off.
SELECT store_id,
    ROUND(AVG(ABS(units_sold - demand_forecast)), 2) AS avg_forecast_error
FROM fact_inventory
GROUP BY store_id
ORDER BY avg_forecast_error DESC;



### Creating Sql views to make queries reusable and connectable to Power BI 
#Inventory Gap (Overstock vs. Demand)
CREATE OR REPLACE VIEW vw_inventory_gap AS
SELECT product_id,
    store_id,
    AVG(inventory_level) AS avg_inventory,
    AVG(demand_forecast) AS avg_demand,
    ROUND(AVG(inventory_level) - AVG(demand_forecast), 2) AS inventory_gap
FROM fact_inventory
GROUP BY product_id, store_id;
#Promotion Effectiveness
CREATE OR REPLACE VIEW vw_promotion_effectiveness AS
SELECT holiday_promotion,
    ROUND(AVG(units_sold), 2) AS avg_units_sold,
    COUNT(*) AS total_records
FROM fact_inventory
GROUP BY holiday_promotion;
#Regional Demand-Supply Gap
CREATE OR REPLACE VIEW vw_region_demand_gap AS
SELECT region,
    ROUND(SUM(units_ordered), 2) AS total_ordered,
    ROUND(SUM(units_sold), 2) AS total_sold,
    ROUND(SUM(units_ordered) - SUM(units_sold), 2) AS demand_supply_gap
FROM fact_inventory
GROUP BY region;
#Forecast Accuracy
CREATE OR REPLACE VIEW vw_forecast_error AS
SELECT store_id,
    ROUND(AVG(ABS(units_sold - demand_forecast)), 2) AS avg_forecast_error
FROM fact_inventory
GROUP BY store_id;


#Monthly Sales and Forecast Trends
#To analyse how well the forecast matched reality month to month
#When under/over-forcasting happened
CREATE OR REPLACE VIEW vw_monthly_forecast_vs_actual AS
SELECT DATE_FORMAT(date, '%Y-%m') AS month,
    ROUND(SUM(units_sold), 2) AS total_units_sold,
    ROUND(SUM(demand_forecast), 2) AS total_forecast,
    ROUND(SUM(demand_forecast) - SUM(units_sold), 2) AS forecast_error
FROM fact_inventory
GROUP BY month
ORDER BY month;


#Rolling 3-Day Forecast Error Per Store 
CREATE OR REPLACE VIEW vw_store_rolling_forecast_error AS
SELECT store_id,
    date,
    units_sold,
    demand_forecast,
    ROUND(ABS(units_sold - demand_forecast), 2) AS daily_error,
    ROUND(AVG(ABS(units_sold - demand_forecast)) OVER (
        PARTITION BY store_id ORDER BY date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_3day_error
FROM fact_inventory;


#Fast-Moving vs Slow-Moving Product Flag
#Classifying products by average units sold
CREATE OR REPLACE VIEW vw_product_movement_classification AS
SELECT product_id,
    ROUND(AVG(units_sold), 2) AS avg_units_sold,
    CASE
        WHEN AVG(units_sold) >= 100 THEN 'Fast-Moving'
        WHEN AVG(units_sold) >= 50 THEN 'Moderate'
        ELSE 'Slow-Moving'
    END AS movement_class
FROM fact_inventory
GROUP BY product_id;


#Low-Accuracy Store Alerts
#Flag stores with high average forecast error
CREATE OR REPLACE VIEW vw_low_accuracy_stores AS
SELECT store_id,
    ROUND(AVG(ABS(units_sold - demand_forecast)), 2) AS avg_forecast_error
FROM fact_inventory
GROUP BY store_id
HAVING avg_forecast_error > 15;  -- you can tweak this threshold

#1A. Average Inventory Turnover (Units Sold / Inventory Level)
CREATE OR REPLACE VIEW vw_inventory_turnover AS
SELECT product_id,
    ROUND(SUM(units_sold) / NULLIF(SUM(inventory_level), 0), 2) AS turnover_ratio
FROM fact_inventory
GROUP BY product_id;

#1B. Reorder Point Estimation - estimates reorder points using average deamnd during lead time.
CREATE OR REPLACE VIEW vw_reorder_point AS
SELECT product_id,
    store_id,
    ROUND(AVG(units_sold) * 3, 0) AS estimated_reorder_point  -- assuming 3-day lead time
FROM fact_inventory
GROUP BY product_id, store_id;

#1C. Days of Inventory Left (DOI)
CREATE OR REPLACE VIEW vw_days_inventory_left AS
SELECT store_id,
    product_id,
    ROUND(AVG(inventory_level) / NULLIF(AVG(units_sold), 0), 1) AS days_inventory_left
FROM fact_inventory
GROUP BY store_id, product_id;


#Understock / Overstock Classification
CREATE OR REPLACE VIEW vw_inventory_status AS
SELECT product_id,
    store_id,
    ROUND(AVG(inventory_level - demand_forecast), 2) AS avg_gap,
    CASE
        WHEN AVG(inventory_level - demand_forecast) > 15 THEN 'Overstocked'
        WHEN AVG(inventory_level - demand_forecast) < -15 THEN 'Understocked'
        ELSE 'Optimal'
    END AS stock_status
FROM fact_inventory
GROUP BY product_id, store_id;



#Identify Low Performing SKUs (Slow Movers)
CREATE OR REPLACE VIEW vw_slow_moving_products AS
SELECT product_id,
    ROUND(AVG(units_sold), 2) AS avg_units_sold
FROM fact_inventory
GROUP BY product_id
HAVING avg_units_sold < 1000;  -- adjust threshold as needed


#High Forecast Error Products
CREATE OR REPLACE VIEW vw_high_forecast_error AS
SELECT product_id,
    ROUND(AVG(ABS(units_sold - demand_forecast)), 2) AS avg_error
FROM fact_inventory
GROUP BY product_id
HAVING avg_error > 12;  -- or any other threshold


#Aggregated KPI by Region
CREATE OR REPLACE VIEW vw_region_kpi_summary AS
SELECT region,
    ROUND(AVG(inventory_level), 1) AS avg_inventory,
    ROUND(AVG(units_sold), 1) AS avg_sold,
    ROUND(AVG(units_ordered), 1) AS avg_ordered,
    ROUND(AVG(demand_forecast), 1) AS avg_forecast
FROM fact_inventory
GROUP BY region;


#Categorical performance
CREATE OR REPLACE VIEW vw_seasonal_performance AS
SELECT Seasonality,
    ROUND(AVG(Units_Sold), 2) AS avg_units_sold,
    ROUND(AVG(Demand_Forecast), 2) AS avg_demand_forecast,
    ROUND(AVG(Discount), 2) AS avg_discount,
    ROUND(AVG(Price), 2) AS avg_price
FROM fact_inventory
GROUP BY Seasonality;



#Holiday vs Non-Holiday Demand
Create or Replace view vw_promo_impact AS
SELECT holiday_promotion,
    ROUND(AVG(units_sold), 2) AS avg_units_sold
FROM fact_inventory
GROUP BY holiday_promotion;


#Category-wise Demand & Accuracy
Create or Replace view vw_category_performance AS 
SELECT p.category,
ROUND(AVG(f.units_sold), 2) AS avg_units_sold,
ROUND(AVG(ABS(f.units_sold - f.demand_forecast)), 2) AS avg_forecast_error
FROM fact_inventory f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.category
ORDER BY avg_units_sold DESC;


#Region-wise Overstock Risk
Create or Replace view vw_overstock_by_region As
SELECT region,
COUNT(*) AS overstock_cases
FROM fact_inventory
WHERE inventory_level > demand_forecast
GROUP BY region
ORDER BY overstock_cases DESC;


#Seasonality Impact
Create or Replace view vw_seasonal_demand AS
SELECT seasonality,
ROUND(AVG(units_sold), 2) AS avg_units_sold
FROM fact_inventory
GROUP BY seasonality
ORDER BY avg_units_sold DESC;

#forecast accuracy
CREATE OR REPLACE VIEW vw_forecast_accuracy AS
SELECT product_id, store_id,
ROUND(AVG(ABS(demand_forecast - units_sold)), 2) AS forecast_error
FROM fact_inventory
GROUP BY product_id, store_id;
















