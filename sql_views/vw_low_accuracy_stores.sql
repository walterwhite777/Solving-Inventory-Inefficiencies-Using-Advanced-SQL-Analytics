CREATE or Replace
VIEW `vw_monthly_forecast_vs_actual` AS
SELECT DATE_FORMAT(`fact_inventory`.`date`, '%Y-%m') AS `month`,
        ROUND(SUM(`fact_inventory`.`units_sold`), 2) AS `total_units_sold`,
        ROUND(SUM(`fact_inventory`.`demand_forecast`),
                2) AS `total_forecast`,
        ROUND((SUM(`fact_inventory`.`demand_forecast`) - SUM(`fact_inventory`.`units_sold`)),
                2) AS `forecast_error`
FROM `fact_inventory`
GROUP BY `month`
ORDER BY `month`