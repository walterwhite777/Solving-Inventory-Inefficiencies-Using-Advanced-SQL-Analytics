CREATE or Replace
VIEW `vw_promotion_effectiveness` AS
SELECT 
        `fact_inventory`.`holiday_promotion` AS `holiday_promotion`,
        ROUND(AVG(`fact_inventory`.`units_sold`), 2) AS `avg_units_sold`,
        COUNT(0) AS `total_records`
FROM
        `fact_inventory`
GROUP BY `fact_inventory`.`holiday_promotion`