Create or Replace view vw_seasonal_demand AS
SELECT seasonality,
ROUND(AVG(units_sold), 2) AS avg_units_sold
FROM fact_inventory
GROUP BY seasonality
ORDER BY avg_units_sold DESC;
