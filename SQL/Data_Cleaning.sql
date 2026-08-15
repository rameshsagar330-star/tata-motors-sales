-- Tata Motors Sales Trend Analysis

		--=================--
		--  Data Cleaning  --
		--=================--

-- 1. Check the table structure
SELECT TOP 10 * FROM sales_details;
SELECT TOP 10 * FROM vehicle_info;

-- 2. Check for NULL values
	-- For sales_details table
		SELECT * 
		FROM sales_details
		WHERE sale_date IS NULL
			OR sale_units IS NULL
			OR sale_price IS NULL;
	--For vehicle_info table
	SELECT * FROM vehicle_info
	WHERE  vehicle_model IS NULL
		OR vehicle_color IS NULL
		OR variant IS NULL
		OR body_type IS NULL
		OR color_code IS NULL;

	/*
	-- To change NULL to any values
	SELECT 
		sale_id,
		vin,
		vehicle_model,
		vehicle_color,
		YEAR(manufacture_year) AS manufacture_year,
		ISNULL(sale_date, '2026-06-01') AS sale_date, 
		-- replaced the NULL in the date as today date
		dealer_id,
		dealer_city,
		reg_state,
		ISNULL(sale_units, 0) AS sale_units,
		ISNULL(sale_price, 250000) AS sale_price
		-- NULL price is replaced with 2,50,000/- 
	FROM sales_details;

	*/
-- 3. Check for duplicates
SELECT 
	sale_id,
	COUNT(*)
FROM sales_details
GROUP BY sale_id
HAVING COUNT(*) > 1;

-- 4. Remove leading/trailing spaces update vehicle
SELECT * FROM sales_details
WHERE vin != TRIM(vin)
	OR vehicle_model != TRIM(vehicle_model)
	OR vehicle_color != TRIM(vehicle_color)
	OR dealer_city != TRIM(dealer_city)
	OR reg_state != TRIM(reg_state);
	/*
	-- If you find any thing then go with
	SELECT 
		sale_id,
		TRIM(vin) AS vin,
		TRIM(vehicle_model) AS vehicle_model,
		TRIM(vehicle_color) AS vehicle_color,
		YEAR(manufacture_year) AS manufacture_year,
		ISNULL(sale_date, '2026-06-01') AS sale_date, 
		-- replaced the NULL in the date as today date
		dealer_id,
		TRIM(dealer_city) AS dealer_city,
		TRIM(reg_state) AS reg_state,
		ISNULL(sale_units, 0) AS sale_units,
		ISNULL(sale_price, 250000) AS sale_price
		-- NULL price is replaced with 2,50,000/- 
	FROM sales_details;
	*/
-- 5. Find Blank values
-- For sale_details table
SELECT * FROM sales_details
WHERE vehicle_model = ''
	OR vehicle_color = ''
	OR dealer_id = ''
	OR dealer_city = ''
	OR reg_state ='';  
	-- if you find any blank spaces replace it with a particular string

-- for vehicle_info table
SELECT * FROM vehicle_info
WHERE  vehicle_model = ''
	OR vehicle_color = ''
	OR variant = ''
	OR body_type = ''
	OR mileage_kmpl = ''
	OR color_code = '';
	/*
	if you find any blank spaces then go with
	-- For sales_details table
	SELECT 
		sale_id,
		vin,
		REPLACE(vehicle_model, '', 'N/A') AS vehicle_model,
		REPLACE(vehicle_color, '', 'N/A') AS vehicle_color,
		manufacture_year,
		sale_date,
		dealer_id,
		REPLACE(dealer_city, '', 'N/A') AS dealer_city,
		REPLACE(reg_state, '', 'N/A') AS reg_state,
		sale_units,
		sale_price
	FROM sales_details
	*/
-- 6. Check for incosistent values
SELECT DISTINCT fuel_type FROM vehicle_info;
-- 7. Check for invalid numeric values
SELECT * FROM sales_details
WHERE sale_units <= 0
   OR sale_price <= 0;
-- 8. Check for invalid dates
-- For sales_details table
SELECT * FROM sales_details
WHERE sale_date >=GETDATE()
	OR manufacture_year >= GETDATE();
-- For vehicle_info table
SELECT * FROM vehicle_info
WHERE launch_date >= GETDATE();

-- 9. Varify data types sp_help sales
sp_help sales_details;
sp_help vehicle_info;
--10. Check for orphan records Ensure every sales has a matching vehicles 
SELECT * FROM sales_details s
LEFT JOIN vehicle_info v
ON s.vin = v.vin
WHERE s.vin IS NULL;



