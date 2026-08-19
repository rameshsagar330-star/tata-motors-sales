
		--=================--
		--  Data Cleaning  --
		--=================--

-- Data cleaning process
-- Data cleaning for sales_details table
SELECT 
	sale_id,
	vin,
	CASE WHEN NULLIF(TRIM(vehicle_model), '') IS NULL THEN 'Others'
 		 ELSE TRIM(vehicle_model)
	END AS vehicle_model,
	CASE WHEN NULLIF(TRIM(vehicle_color), '') IS NULL THEN 'Others'
 		 ELSE TRIM(vehicle_color)
	END AS vehicle_color,
	YEAR(manufacture_year) AS manufacture_year,
	CASE WHEN sale_date IS NULL THEN '2026-08-01'
			WHEN sale_date >= CAST(GETDATE() AS DATE) THEN '2026-08-01'
			WHEN CAST(sale_date AS DATE) < CAST(manufacture_year AS DATE) THEN '2026-08-01'
			ELSE sale_date
	END AS sale_date, -- replaced the NULLS with default date
	dealer_id,
	CASE WHEN NULLIF(TRIM(dealer_city), '') IS NULL THEN 'Others'
		 ELSE TRIM(dealer_city)
	END AS dealer_city,
	CASE WHEN NULLIF(TRIM(reg_state), '') IS NULL THEN 'Others'
		 ELSE TRIM(reg_state)
	END AS reg_state,
	CASE WHEN sale_units IS NULL OR sale_units <= 0 THEN 1
		 ELSE sale_units
	END AS sale_units, -- if sale_units is 0 then it is replace with minimum value as 1
	CASE WHEN sale_price IS NULL OR sale_price <= 0 THEN 150000
		 ELSE sale_price
	END AS sale_price	-- NULL price is replaced with minimum value as 1,50,000/-
FROM sales_details
WHERE sale_id IS NOT NULL;

			-- ******* -
-- data cleaning for the vehicle_info table
SELECT 
	record_id,
	vin,
	CASE WHEN NULLIF(TRIM(vehicle_model), '') IS NULL THEN 'Others'
 		 ELSE TRIM(vehicle_model)
	END AS vehicle_model,
	CASE WHEN NULLIF(TRIM(variant), '') IS NULL THEN 'Others'
		 ELSE TRIM(variant)
	END AS variant,
	CASE WHEN NULLIF(TRIM(body_type), '') IS NULL THEN 'Others'
		 ELSE TRIM(body_type)
	END AS body_type,
	CASE WHEN NULLIF(TRIM(vehicle_color), '') IS NULL THEN 'Others'
		 ELSE TRIM(vehicle_color)
	END AS vehicle_color,
	color_code,
	COALESCE(launch_date, '2000-01-01') AS launch_date,
			-- replace null value with 2000-01-01 as default launch date
	CASE WHEN NULLIF(TRIM(fuel_type), '') IS NULL THEN 'Others'
		 ELSE TRIM(fuel_type)
	END AS fuel_type,
	CASE WHEN UPPER(TRIM(fuel_type)) = 'ELECTRIC' THEN COALESCE(mileage_kmpl, 0)
		 ELSE COALESCE(mileage_kmpl, 10)
	END AS mileage_kmpl, -- As per minimum consideration the minimum mileage as 10
	ISNULL(horse_power, 0) AS horse_power,
	CASE WHEN safety_rating IS NULL OR safety_rating <= 0 THEN 1
		 ELSE safety_rating
	END AS safety_rating, -- replace nulls and 0 with 1 rating values
	CASE WHEN seats IS NULL OR seats <= 0 THEN 5
		 ELSE seats
	END AS seats,	-- replace nulls and 0 with 5 seats 
	ISNULL(air_bags, 0) AS air_bags, -- replaced nulls with 0 air bags
	num_doors
FROM vehicle_info
WHERE record_id IS NOT NULL;



