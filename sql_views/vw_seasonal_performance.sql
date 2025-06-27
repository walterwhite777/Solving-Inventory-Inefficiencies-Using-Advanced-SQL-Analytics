CREATE or Replace
VIEW `vw_slow_moving_products` AS
SELECT `fact_inventory`.`product_id` AS `product_id`,
        ROUND(AVG(`fact_inventory`.`units_sold`), 2) AS `avg_units_sold`
FROM `fact_inventory`
GROUP BY `fact_inventory`.`product_id`
HAVING (`avg_units_sold` < 1000)