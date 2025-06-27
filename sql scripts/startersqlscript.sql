###Setting up the databases and creating fact/dimension tables



SELECT COUNT(*) FROM inventory_forecasting;
SELECT * FROM inventory_forecasting LIMIT 5;


CREATE TABLE dim_store (
    store_id VARCHAR(10) PRIMARY KEY
);

CREATE TABLE dim_product (
    product_id VARCHAR(10) PRIMARY KEY,
    category VARCHAR(50)
);


INSERT INTO dim_store (store_id)
SELECT DISTINCT `Store ID` FROM inventory_forecasting;

INSERT INTO dim_product (product_id, category)
SELECT DISTINCT `Product ID`, Category FROM inventory_forecasting;


CREATE TABLE fact_inventory (
    date DATE,
    store_id VARCHAR(10),
    product_id VARCHAR(10),
    region VARCHAR(50),
    inventory_level INT,
    units_sold INT,
    units_ordered INT,
    demand_forecast FLOAT,
    price FLOAT,
    discount FLOAT,
    weather_condition VARCHAR(50),
    holiday_promotion BOOLEAN,
    competitor_pricing FLOAT,
    seasonality VARCHAR(50),
    PRIMARY KEY (date, store_id, product_id),
    FOREIGN KEY (store_id) REFERENCES dim_store(store_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id)
    
);

INSERT INTO fact_inventory
SELECT
    `Date`, `Store ID`, `Product ID`, Region, `Inventory Level`,
    `Units Sold`, `Units Ordered`, `Demand Forecast`, Price, Discount,
    `Weather Condition`, `Holiday/Promotion`, `Competitor Pricing`, Seasonality
FROM inventory_forecasting;



#Checking row count across tables
SELECT COUNT(*) AS Total_Records FROM inventory_forecasting;
SELECT COUNT(*) AS Fact_Inventory_Records FROM fact_inventory;
SELECT COUNT(*) AS Store_Count FROM dim_store;
SELECT COUNT(*) AS Product_Count FROM dim_product;


#Verify primary key uniqueness in fact_inventory
SELECT 
    date, store_id, product_id, COUNT(*) AS cnt
FROM fact_inventory
GROUP BY date, store_id, product_id
HAVING cnt > 1;


#Null values checks
SELECT
    SUM(CASE WHEN region IS NULL OR region = '' THEN 1 ELSE 0 END) AS missing_region,
    SUM(CASE WHEN demand_forecast IS NULL THEN 1 ELSE 0 END) AS missing_demand_forecast,
    SUM(CASE WHEN competitor_pricing IS NULL THEN 1 ELSE 0 END) AS missing_competitor_pricing
FROM fact_inventory;







