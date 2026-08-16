-- Tata Motors Sales Trend Analysis

		--=================--
		--  Data Cleaning  --
		--=================--

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



