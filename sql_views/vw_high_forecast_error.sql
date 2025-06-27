CREATE or Replace
VIEW `vw_inventory_gap` AS
SELECT `fact_inventory`.`product_id` AS `product_id`,
        `fact_inventory`.`store_id` AS `store_id`,
AVG(`fact_inventory`.`inventory_level`) AS `avg_inventory`,
AVG(`fact_inventory`.`demand_forecast`) AS `avg_demand`,
ROUND((AVG(`fact_inventory`.`inventory_level`) - AVG(`fact_inventory`.`demand_forecast`)),
                2) AS `inventory_gap`
FROM `fact_inventory`
GROUP BY `fact_inventory`.`product_id` , `fact_inventory`.`store_id`