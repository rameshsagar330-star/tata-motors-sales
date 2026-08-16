		--=================--
		--  Data Exploration  --
		--=================--
/*
Performed data quality and validation checks on the sales_details and vehicle_info tables,
  1.including table structure
  2.NULLS values
  3.duplicates
  4.leading/trailing spaces
  5.blank values
  6.inconsistent categorical values
  7.invalid numeric values
  8.invalid dates
  9.and data types
 10. Check for orphan records.
These checks helped ensure data consistency and reliability before proceeding with sales analysis and visualization.
*/
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

-- 3. Check for duplicates
  -- For sales_details table
    SELECT 
    	sale_id,
    	COUNT(*)
    FROM sales_details
    GROUP BY sale_id
    HAVING COUNT(*) > 1;
  -- For vehicle_info table
    SELECT 
    	record_id,
    	COUNT(*)
    FROM vehicle_info
    GROUP BY record_id
    HAVING COUNT(*) > 1;

-- 4. Check leading/trailing spaces
  -- For sales_details table
    SELECT * FROM sales_details
    WHERE vin != TRIM(vin)
    	OR vehicle_model != TRIM(vehicle_model)
    	OR vehicle_color != TRIM(vehicle_color)
    	OR dealer_city != TRIM(dealer_city)
    	OR reg_state != TRIM(reg_state);
    -- For vehicle_info table
      SELECT * FROM vehicle_info
      WHERE vehicle_model != TRIM(vehicle_model)
        OR variant != TRIM(variant)
        OR body_type != TRIM(body_type)
        OR vehicle_color != TRIM(vehicle_color)
        OR fuel_type != TRIM(fuel_type);

-- 5. Find Blank values
  -- For sale_details table
    SELECT * FROM sales_details
    WHERE vehicle_model = ''
    	OR vehicle_color = ''
    	OR dealer_id = ''
    	OR dealer_city = ''
    	OR reg_state ='';  

  -- for vehicle_info table
    SELECT * FROM vehicle_info
    WHERE  vehicle_model = ''
    	OR vehicle_color = ''
    	OR variant = ''
    	OR body_type = ''
    	OR mileage_kmpl = ''
    	OR color_code = '';

-- 6. Check for incosistent values
  -- for sales_details table
    SELECT DISTINCT vehicle_model FROM sales_details;
    SELECT DISTINCT vehicle_color FROM sales_details;
    SELECT DISTINCT dealer_city FROM sales_details;
    SELECT DISTINCT reg_state FROM sales_details;
  -- For vehicle_info table
    SELECT DISTINCT vehicle_model FROM vehicle_info;
    SELECT DISTINCT variant FROM vehicle_info;
    SELECT DISTINCT body_type FROM vehicle_info;
    SELECT DISTINCT vehicle_color FROM vehicle_info;
    SELECT DISTINCT fuel_type FROM vehicle_info;

-- 7. Check for invalid numeric values
  -- For sales_details table
    SELECT * FROM sales_details
    WHERE sale_units <= 0
       OR sale_price <= 0
  -- For vehicle_info table
    SELECT * FROM vehicle_info
    WHERE mileage_kmpl <= 0
       OR horse_power <= 0
       OR CO2_gperkms < 0
       OR safety_rating < 0
       OR seats < 0;

-- 8. Check for invalid dates
  -- For sales_details table
    SELECT * FROM sales_details
    WHERE sale_date >=GETDATE()
    	OR manufacture_year >= GETDATE();
  -- For vehicle_info table
    SELECT * FROM vehicle_info
    WHERE launch_date >= YEAR(GETDATE());

-- 9. Varify data types sp_help sales
  sp_help sales_details;
  sp_help vehicle_info;

-- 10. Check for orphan records Ensure every sales has a matching vehicles 
  SELECT * FROM sales_details s
  LEFT JOIN vehicle_info v
  ON s.vin = v.vin
  WHERE s.vin IS NULL;
