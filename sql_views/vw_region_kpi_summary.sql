CREATE or Replace
VIEW `vw_reorder_point` AS
SELECT `fact_inventory`.`product_id` AS `product_id`,
        `fact_inventory`.`store_id` AS `store_id`,
        ROUND((AVG(`fact_inventory`.`units_sold`) * 3),
                0) AS `estimated_reorder_point`
FROM `fact_inventory`
GROUP BY `fact_inventory`.`product_id` , `fact_inventory`.`store_id`