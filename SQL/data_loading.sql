
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
			--------------------	
			--  Create Database:
			--------------------

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
BEGIN
	DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME, @start_time DATETIME, @end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
			SET @start_time = GETDATE();
				TRUNCATE TABLE raw_sales_details;
				BULK INSERT raw_sales_details
				FROM '<filepath>/sale_details.csv' -- specify file path in <filepath>/file_name.csv 
					WITH (
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',
						TABLOCK
						);
			SET @end_time = GETDATE();
			PRINT 'raw_sales_details table loading Successfull'
			PRINT 'raw_sales_details table loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 'seconds'
-- Loading raw_vehicle_info table:
----------------------------------
			SET @start_time = GETDATE();
				TRUNCATE TABLE raw_vehicle_info;
				BULK INSERT raw_vehicle_info
				FROM '<filepath>\vehicle_info.csv' -- specify file path in <filepath>/file_name.csv
					WITH (
						FIRSTROW = 2,
						FIELDTERMINATOR = ',',
						TABLOCK
						);
			SET @end_time = GETDATE();
			PRINT 'raw_vehicle_info table loading successfull';
			PRINT 'raw_vehicle_info table loading Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + 'seconds' 
		SET @batch_end_time = GETDATE();
		PRINT 'Table loading successfull'
		PRINT 'Tables Loading Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds'
	END TRY
	BEGIN CATCH
		PRINT 'Tables Loading failed'
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT 'Error state: ' + ERROR_STATE();
		PRINT 'Error line: ' + ERROR_LINE();
		PRINT 'Eoor Number: ' + ERROR_NUMBER();
	END CATCH
END;

