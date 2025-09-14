[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
### Solving Inventory Inefficiencies Using Advanced SQL Analytics

## 🛒 Project Overview

This project aims to address core inventory management challenges faced by retail businesses, such as overstocking, stockouts, and lack of actionable insights. Using advanced SQL queries and data analysis techniques, we transformed raw inventory data into meaningful business intelligence.

The solution simulates the responsibilities of a data analyst at a retail company — including data modeling, SQL scripting, KPI visualization, and actionable reporting.

---

## 🎯 Objectives

- Build an optimized SQL-based pipeline for inventory monitoring and forecasting.
- Analyze demand trends, stock levels, and inventory inefficiencies.
- Recommend reorder thresholds and highlight low-performing SKUs.
- Provide visual dashboards for decision-makers.
- Deliver insights to improve operational efficiency and customer satisfaction.

---

## 🧠 Key Features

- **Data Cleaning & EDA:** Processed 100k+ rows of inventory data using pandas and visualized trends using Plotly, Seaborn, and Matplotlib.
- **SQL Optimization:** Designed relational schemas and normalized raw data to ensure efficient querying.
- **Custom Views:** Created reusable SQL views for analyzing forecast error, inventory gap, overstock, and demand patterns.
- **Reorder Point Calculation:** Estimated reorder points based on product category and assumed lead times.
- **Dashboarding:** Built an interactive dashboard using Python libraries to simulate a Power BI-like experience on Mac.

---

## 📈 Dashboards

Key visuals include:

- Distribution of Inventory Gap
- Average Inventory Gap by Store
- Stores with Lowest Forecast Accuracy
- Days Inventory Left by Store & Product
- Top 15 Overstocked Products
- Regional Demand Gap Heatmap

_See screenshots in the Jupyter notebook or executive summary._

---

## 🛠️ Tools & Technologies

- **SQL**: MySQL, Advanced joins, Views, Window functions
- **Python**: pandas, seaborn, matplotlib, plotly
- **Jupyter Notebook**: For EDA, prototyping, and dashboard
- **ERD Tool**: dbdiagram.io
- **GitHub**: Project version control and documentation

---

## 🚀 Getting Started

1. Clone this repository:
   ```bash
   git clone https://github.com/walterwhite777/Solving-Inventory-Inefficiencies-Using-Advanced-SQL-Analytics.git
  2.	Open the project in your preferred environment (VSCode / Jupyter Lab).
	3.	If using MySQL:
	•	Run sql_scripts/create_tables.sql to set up the schema.
	•	Execute view .sql files in sql_views/ to recreate insights.
	4.	Open notebooks/dashboard_inventory_csv.ipynb to explore EDA and dashboard visuals using exported CSVs.

⸻

📌 Key Insights
	•	Inventory gaps and forecast errors vary significantly across store regions.
	•	Seasonal trends heavily influence demand in categories like clothing and furniture.
	•	Overstocked products were identified using inventory-to-demand ratios.
	•	Reorder thresholds were established to avoid stockouts using estimated lead times.

⸻

✅ Business Impact
	•	🔄 Reduced Overstock & Stockouts: Smarter stock planning and reorder thresholds.
	•	📉 Lower Holding Costs: Visibility into slow-moving SKUs reduced excess inventory.
	•	📈 Improved Demand Forecasting: Historical accuracy tracked using forecast error metrics.
	•	🧭 Data-Driven Decisions: Dashboards offer regional managers and buyers clearer signals.

⸻

## License
This project is licensed under the [MIT License](LICENSE).
