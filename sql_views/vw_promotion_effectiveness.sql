CREATE or Replace
VIEW `vw_region_demand_gap` AS
SELECT `fact_inventory`.`region` AS `region`,
        ROUND(SUM(`fact_inventory`.`units_ordered`), 2) AS `total_ordered`,
        ROUND(SUM(`fact_inventory`.`units_sold`), 2) AS `total_sold`,
        ROUND((SUM(`fact_inventory`.`units_ordered`) - SUM(`fact_inventory`.`units_sold`)),
                2) AS `demand_supply_gap`
FROM `fact_inventory`
GROUP BY `fact_inventory`.`region`