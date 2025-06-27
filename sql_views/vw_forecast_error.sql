CREATE or Replace
VIEW `vw_high_forecast_error` AS
SELECT `fact_inventory`.`product_id` AS `product_id`,
ROUND(AVG(ABS((`fact_inventory`.`units_sold` - `fact_inventory`.`demand_forecast`))),
                2) AS `avg_error`
FROM
        `fact_inventory`
GROUP BY `fact_inventory`.`product_id`
HAVING (`avg_error` > 12)