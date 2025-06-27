CREATE or Replace
VIEW `vw_seasonal_performance` AS
SELECT `fact_inventory`.`seasonality` AS `Seasonality`,
        ROUND(AVG(`fact_inventory`.`units_sold`), 2) AS `avg_units_sold`,
        ROUND(AVG(`fact_inventory`.`demand_forecast`),
                2) AS `avg_demand_forecast`,
        ROUND(AVG(`fact_inventory`.`discount`), 2) AS `avg_discount`,
        ROUND(AVG(`fact_inventory`.`price`), 2) AS `avg_price`
FROM `fact_inventory`
GROUP BY `fact_inventory`.`seasonality`