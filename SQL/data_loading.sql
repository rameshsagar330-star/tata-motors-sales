
				--===========================--
				--  Database & Data Loading  --
				--===========================--
/*
===============================================================================
Script Purpose:
===============================================================================
This script creates the database and raw-layer tables required for the
Tata Motors Sales Analysis project.

The raw tables are designed to store the source data in its original form 
before performing any data cleaning, transformation, or analysis.

Tables Created:
1. raw_sales_details  - Stores raw vehicle sales transaction data.
2. raw_vehicle_info   - Stores raw vehicle and specification information.

Data Flow:
Source CSV/Data → Raw Tables → Data Cleaning → Analysis → Power BI Dashboard

The raw layer acts as the initial staging area, preserving the source data
before further processing and transformation.

WARNING:
    Running this script will drop the entire 'tat_motors' Database if it exists.
    All data in the database will be permanantsly deleted.proceed with coution
    and ensure you have proper backups before running this script.
							*****
*/
				
			--  Create Database:
			---------------------

USE MASTER;
GO
IF DB_ID ('tata_motors') IS NOT NULL
BEGIN
ALTER DATABASE tata_motors SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
DROP DATABASE tata_motors;
END
GO
CREATE DATABASE tata_motors
GO 
USE tata_motors
GO
	
			--------------------------------
			-- Creating Tables for Raw Data
			--------------------------------
	
-- Creating raw_sales_details Table:
------------------------------------
IF OBJECT_ID ('raw_sales_details', 'U') IS NOT NULL
	DROP TABLE raw_sales_details;
 CREATE TABLE raw_sales_details (
		sale_id				INT,
		vin					NVARCHAR(50),
		vehicle_model		NVARCHAR(50),
		vehicle_color		NVARCHAR(50),
		manufacture_year 	DATE,
		sale_date			DATE,
		dealer_id			INT,
		dealer_city			NVARCHAR(50),
		reg_state			NVARCHAR(50),
		sale_units			INT,
		sale_price			FLOAT
	);

--Creating raw_vehicle_Info table:
----------------------------------
	IF OBJECT_ID ('raw_vehicle_info', 'U') IS NOT NULL
		DROP TABLE raw_vehicle_info;
	CREATE TABLE raw_vehicle_info (
		record_id			INT,
		vin					NVARCHAR(50),
		vehicle_model		NVARCHAR(50),
		variant				NVARCHAR(50),
		body_type			NVARCHAR(50),
		vehicle_color		NVARCHAR(50),
		color_code			NVARCHAR(50),
		launch_date			DATE,
		fuel_type			NVARCHAR(50),
		mileage_kmpl		FLOAT,
		horse_power			FLOAT,
		CO2_gperkms			FLOAT,
		safety_rating		INT,
		seats				INT,
		air_bags			INT,
		num_doors			INT
	);

			-------------------------------------
			--Loading the data inside Raw tables
			-------------------------------------

-- Loading raw_sales_details table:
-----------------------------------
	TRUNCATE TABLE raw_sales_details;
	BULK INSERT raw_sales_details
	FROM '<filepath>/sale_details.csv' -- specify file path in <filepath>/file_name.csv 
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);

-- Loading raw_vehicle_info table:
----------------------------------
	TRUNCATE TABLE raw_vehicle_info;
	BULK INSERT raw_vehicle_info
	FROM '<filepath>\vehicle_info.csv' -- specify file path in <filepath>/file_name.csv
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
		);

		--=================--
		--  Data Cleaning  --
		--=================--

-- Data cleaning process
-- Data cleaning for sales_details table

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


INSERT INTO sales_details (
	sale_id,
	vin,
	vehicle_model,
	vehicle_color,
	manufacture_year,
	sale_date,
	dealer_id,
	dealer_city,
	reg_state,
	sale_units,
	sale_price
);
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
	FORMAT(manufacture_year, 'yyyy') AS manufacture_year,
	CASE WHEN sale_date IS NULL THEN '2026-08-01'
			WHEN sale_date >= CAST(GETDATE() AS DATE) THEN '2026-08-01'
			WHEN sale_date > manufacture_year THEN '2026-08-01'
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
FROM raw_sales_details
WHERE sale_id IS NOT NULL;
--================================
--================================

INSERT INTO vehicle_info (
	record_id,
	vin,
	vehicle_model,
	variant,
	body_type,
	vehicle_color,
	color_code,
	launch_date,
	fuel_type,
	mileage_kmpl,
	horse_power,
	safety_rating,
	seats,
	air_bags,
	num_doors
)
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
FROM raw_vehicle_info
WHERE record_id IS NOT NULL;
