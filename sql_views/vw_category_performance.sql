Create or Replace view vw_overstock_by_region As
SELECT region,
COUNT(*) AS overstock_cases
FROM fact_inventory
WHERE inventory_level > demand_forecast
GROUP BY region
ORDER BY overstock_cases DESC;
