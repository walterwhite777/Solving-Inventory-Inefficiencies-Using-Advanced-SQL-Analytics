CREATE or Replace 
VIEW `vw_store_rolling_forecast_error` AS 
select `fact_inventory`.`store_id` AS `store_id`,`fact_inventory`.
`date` AS `date`,`fact_inventory`.`units_sold` AS 
`units_sold`,`fact_inventory`.`demand_forecast` AS `demand_forecast`,
round(abs((`fact_inventory`.`units_sold` - `fact_inventory`.`demand_forecast`)),2) AS `daily_error`,
round(avg(abs((`fact_inventory`.`units_sold` - `fact_inventory`.`demand_forecast`))) 
OVER (PARTITION BY `fact_inventory`.`store_id` 
ORDER BY `fact_inventory`.`date` ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) ,2) 
AS `rolling_3day_error` 
from `fact_inventory`