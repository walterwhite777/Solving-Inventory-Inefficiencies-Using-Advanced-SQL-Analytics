CREATE or Replace
VIEW `vw_region_kpi_summary` AS
SELECT `fact_inventory`.`region` AS `region`,
        ROUND(AVG(`fact_inventory`.`inventory_level`),
                1) AS `avg_inventory`,
        ROUND(AVG(`fact_inventory`.`units_sold`), 1) AS `avg_sold`,
        ROUND(AVG(`fact_inventory`.`units_ordered`), 1) AS `avg_ordered`,
        ROUND(AVG(`fact_inventory`.`demand_forecast`),
                1) AS `avg_forecast`
FROM `fact_inventory`
GROUP BY `fact_inventory`.`region`