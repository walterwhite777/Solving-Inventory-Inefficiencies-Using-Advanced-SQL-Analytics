CREATE or Replace
VIEW `vw_inventory_turnover` AS
SELECT 
        `fact_inventory`.`product_id` AS `product_id`,
ROUND((SUM(`fact_inventory`.`units_sold`) / NULLIF(SUM(`fact_inventory`.`inventory_level`),0)),
                2) AS `turnover_ratio`
FROM
        `fact_inventory`
GROUP BY `fact_inventory`.`product_id`