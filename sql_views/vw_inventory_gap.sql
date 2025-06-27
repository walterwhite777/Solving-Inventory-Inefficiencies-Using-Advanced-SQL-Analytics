CREATE or Replace
VIEW `vw_inventory_status` AS
SELECT `fact_inventory`.`product_id` AS `product_id`,
        `fact_inventory`.`store_id` AS `store_id`,
ROUND(AVG((`fact_inventory`.`inventory_level` - `fact_inventory`.`demand_forecast`)),
                2) AS `avg_gap`,
        (CASE
WHEN (AVG((`fact_inventory`.`inventory_level` - `fact_inventory`.`demand_forecast`)) > 15) THEN 'Overstocked'
WHEN (AVG((`fact_inventory`.`inventory_level` - `fact_inventory`.`demand_forecast`)) < -(15)) THEN 'Understocked'
            ELSE 'Optimal'
        END) AS `stock_status`
FROM
        `fact_inventory`
GROUP BY `fact_inventory`.`product_id` , `fact_inventory`.`store_id`