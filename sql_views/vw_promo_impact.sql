Create or Replace view vw_category_performance AS 
SELECT p.category,
ROUND(AVG(f.units_sold), 2) AS avg_units_sold,
ROUND(AVG(ABS(f.units_sold - f.demand_forecast)), 2) AS avg_forecast_error
FROM fact_inventory f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.category
ORDER BY avg_units_sold DESC;
