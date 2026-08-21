
    		--======================--
    		--  Projects Analysing  --
    		--======================--
/*
===============================================================================
Script Purpose:
===============================================================================
This script performs sales analysis on the cleaned Tata Motors sales and
vehicle datasets to identify key sales patterns, revenue trends, and
business performance insights.

The analysis includes:
    1. Total Revenue Analysis
    2. Top-Selling Vehicle Models
    3. Fuel Type Performance
    4. Revenue by Vehicle Model
    5. Monthly and Yearly Sales Trends
    6. Dealer Performance Ranking
    7. City-Wise Sales Performance
    8. Average Selling Price by Vehicle Model
    9. Customer Color Preferences
   10. Body Type Preference Analysis
   11. Mileage vs. Sales Analysis
   12. Variant Performance

The results of these analyses help identify high-performing models, dealers,
cities, vehicle categories, and sales trends, while providing insights into
customer preferences and revenue performance.

The analysis results are intended to support business insights and serve as
the foundation for the Power BI dashboard and visualization.
===============================================================================
*/

-- 1. Total revenue tata_motors generated
-----------------------------------------
	SELECT 
	  SUM(sale_price * sale_units) AS total_revenue
	FROM sales_details;

-- 2. Top Selling Models
------------------------
	SELECT 
		vehicle_model,
		SUM(sale_units) AS units_sold
	FROM sales_details
	GROUP BY vehicle_model
	ORDER BY units_sold DESC;

-- 3. Best Selling fuel type (total_units)
------------------------------------------
	SELECT 
		v.fuel_type,
		SUM(s.sale_units) AS best_selling_fuel_type
	FROM sales_details s
	JOIN vehicle_info v
		ON s.vin = v.vin
	GROUP BY v.fuel_type			
	ORDER BY best_selling_fuel_type DESC;

-- 4. Revenue by Vehicle model
------------------------------
	SELECT 
		vehicle_model,
		SUM(sale_units * sale_price) AS revenue_by_models
	FROM sales_details
	GROUP BY vehicle_model
	ORDER BY revenue_by_models DESC;

-- 5. Monthly sales and trend
-----------------------------
	-- Monthly sale Trends
		SELECT 
			YEAR(sale_date) AS sale_year,
			MONTH(sale_date) AS sale_month,
			SUM(sale_units * sale_price) AS yearly_revenue
		FROM sales_details
		GROUP BY YEAR(sale_date),
				MONTH(sale_date)
		ORDER BY YEAR(sale_date),
				MONTH(sale_date);
	-- yearly sale trend
	  	SELECT 
			YEAR(sale_date) AS sale_year,
	  		SUM(sale_units * sale_price) AS total_revenue
	  	FROM sales_details 
	  	GROUP BY YEAR(sale_date)
	  	ORDER BY sale_year DESC;

-- 6. Dealer performance
------------------------
	SELECT 
		dealer_id,
		SUM(sale_units) AS total_unitssales
	FROM sales_details 
	GROUP BY dealer_id
	ORDER BY total_unitssales DESC;

-- 7. City wise sales
---------------------
	SELECT 
		dealer_city,
		SUM(sale_units) AS total_unitssales
	FROM sales_details 
	GROUP BY dealer_city
	ORDER BY total_unitssales DESC;

-- 8. Average selling price
---------------------------
	SELECT	
		vehicle_model,
		AVG(sale_price) AS avg_price
	FROM sales_details
	GROUP BY vehicle_model
	ORDER BY avg_price DESC;

-- 9. Color preferences
-----------------------
	SELECT 
		vehicle_color,
		SUM(sale_units) AS total_units
	FROM sales_details
	GROUP BY vehicle_color
	ORDER BY total_units DESC;

--10. Body type preference analysis
-----------------------------------
	SELECT 
		v.body_type,
		SUM(s.sale_units) AS total_units
	FROM sales_details s
	JOIN vehicle_info v
		ON s.vin = v.vin
	GROUP BY v.body_type
	ORDER BY total_units DESC;

--11. Mileage vs Sales 
----------------------
	WITH cte_group AS(
		SELECT 
			s.sale_id,
			s.sale_units,
			CASE WHEN v.mileage_kmpl <= 15.0 THEN '15 below'
				 WHEN v.mileage_kmpl <= 20.0 THEN '15 to 20 kmpl'
				 WHEN v.mileage_kmpl <= 25.0 THEN '20 to 25 kmpl'
				 ELSE '25 above'
			END AS mileage_group
		FROM sales_details s
		JOIN vehicle_info v
			ON s.vin = v.vin
	)
	SELECT 
		mileage_group,
		SUM(sale_units) AS total_sales
	FROM cte_group
	GROUP BY mileage_group
	ORDER BY mileage_group DESC;

--12. Variant Performance
-------------------------
	SELECT 
		v.variant,
		SUM(s.sale_units) AS total_units
	FROM sales_details s
	JOIN vehicle_info v
		ON s.vin = v.vin
	GROUP BY v.variant
	ORDER BY total_units DESC;
