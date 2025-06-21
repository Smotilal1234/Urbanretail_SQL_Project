CREATE TABLE Inventory_Staging (
    date DATE,
    store_id VARCHAR(10),
    product_id VARCHAR(10),
    category VARCHAR(50),
    region VARCHAR(50),
    inventory_level INT,
    units_sold INT,
    units_ordered INT,
    demand_forecast FLOAT,
    price FLOAT,
    discount INT,
    weather_condition VARCHAR(50),
    holiday_promotion BOOLEAN,
    competitor_pricing FLOAT,
    seasonality VARCHAR(20)
);

SELECT * FROM Inventory_Staging;

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/inventory_forecasting1.csv'
INTO TABLE Inventory_Staging
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/inventory_forecasting1.csv'
INTO TABLE Inventory_Staging
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Fill Products table
INSERT IGNORE INTO Products(product_id, category)
SELECT DISTINCT product_id, category FROM Inventory_Staging;

-- Fill Stores table
INSERT IGNORE INTO Stores(store_id, region)
SELECT DISTINCT store_id, region FROM Inventory_Staging;

-- Fill Inventory table
INSERT INTO Inventory(
    date, store_id, region, product_id, inventory_level, units_sold, units_ordered, demand_forecast
)
SELECT 
    date, store_id, region, product_id, inventory_level, units_sold, units_ordered, demand_forecast
FROM Inventory_Staging;


-- Fill Pricing table 
INSERT IGNORE INTO Pricing(
    date, product_id, price, discount, competitor_pricing
)
SELECT DISTINCT
    date, product_id, price, discount, competitor_pricing
FROM Inventory_Staging;

-- Fill External_Factors table
INSERT IGNORE INTO External_Factors (
	date, store_id, region, weather_condition, holiday_promotion, seasonality
)
SELECT DISTINCT
	date, store_id, region, weather_condition, holiday_promotion, seasonality
FROM Inventory_Staging;

DROP TABLE Inventory_Staging;