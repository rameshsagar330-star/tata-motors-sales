		
				--====================--
				-- TABLES PREPARATION --
				--====================--
/*
Source:
The original dataset was obtained from Kaggle.

Data Preparation:
The original source dataset was divided into two separate files
for better data organization and analysis:

1. Vehicle_Info
   - Contains vehicle-related information such as:
     model, variant, fuel type, body type, seats,
     color, horsepower, safety rating, etc.

2. Sales_Details
   - Contains sales-related information such as:
     VIN, dealer information, sales date,
     sales units, sale price, registration state, etc.

The two datasets are connected using the appropriate
common identifier.
*/

					--===============--
					-- TABLE LOADING --
					--===============--
USE MASTER;
GO
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'tata_motors')
	BEGIN
		ALTER DATABASE tata_motors SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE tata_motors;
	END
	--===================--
	-- Vehicle_Info table --
	--===================--
-- Create Vehicle_Info table:
GO
	IF OBJECT_ID ('sales_details', 'U') IS NOT NULL
		DROP TABLE sales_details;
	CREATE TABLE sales_details (
			sale_id			INT,
			vin				NVARCHAR(50),
			vehicle_model	NVARCHAR(50),
			vehicle_color	NVARCHAR(50),
			manufacture_year DATE,
			sale_date		DATE,
			dealer_id		INT,
			dealer_city		NVARCHAR(50),
			reg_state		NVARCHAR(50),
			sale_units		INT,
			sale_price		FLOAT
			);

-- sales_details Tables Loading:
	TRUNCATE TABLE sales_details;
	BULK INSERT sales_details
	FROM '<filepath>/sale_details.csv' -- specify file path in <filepath>/file_name.csv 
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
	--=====================--
	-- sales_details table --
	--=====================--
--Creating Vehicle_Info table:
	IF OBJECT_ID ('vehicle_info', 'U') IS NOT NULL
		DROP TABLE vehicle_info;
	CREATE TABLE vehicle_info (
		record_id		INT,
		vin				NVARCHAR(50),
		vehicle_model	NVARCHAR(50),
		variant			NVARCHAR(50),
		body_type		NVARCHAR(50),
		vehicle_color	NVARCHAR(50),
		color_code		NVARCHAR(50),
		launch_date		DATE,
		fuel_type		NVARCHAR(50),
		mileage_kmpl	FLOAT,
		horse_power		FLOAT,
		CO2_gperkms		FLOAT,
		safety_rating	INT,
		seats			INT,
		air_bags		INT,
		num_doors		INT
		);

-- vehicle_info table loading:
	TRUNCATE TABLE vehicle_info;
	BULK INSERT vehicle_info
	FROM '<filepath>\vehicle_info.csv' -- specify file path in <filepath>/file_name.csv
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);
