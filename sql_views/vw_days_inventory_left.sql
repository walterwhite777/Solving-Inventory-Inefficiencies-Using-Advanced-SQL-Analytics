CREATE or Replace 
VIEW `vw_forecast_error` AS
SELECT `fact_inventory`.`store_id` AS `store_id`,
ROUND(AVG(ABS((`fact_inventory`.`units_sold` - `fact_inventory`.`demand_forecast`))),
                2) AS `avg_forecast_error`
FROM `fact_inventory`
GROUP BY `fact_inventory`.`store_id`