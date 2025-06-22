-- Stock Level Calculations across stores and warehouses
SELECT 
    store_id,
    region,
    product_id,
    SUM(inventory_level) AS total_stock
FROM Inventory
GROUP BY store_id, region, product_id
ORDER BY store_id, product_id;

-- Low Inventory Detection based on reorder point(Consider 60 units)
SELECT 
    store_id,
    region,
    product_id,
    inventory_level
FROM Inventory
WHERE inventory_level<60
ORDER BY inventory_level ASC;

-- which product is frequently low in stock
SELECT product_id,COUNT(*) AS low_stock
FROM Inventory
WHERE inventory_level<60
GROUP BY product_id
ORDER BY low_stock DESC;

-- Reorder Point Estimation using historical trends 
SELECT 
    product_id,
    ROUND(AVG(units_sold),2) AS reorder_point
FROM Inventory
GROUP BY product_id
ORDER BY reorder_point ASC;

-- Inventory Turnover Analysis
-- inventory_turnover = total units sold/Average inventory level(not 0)
SELECT 
    product_id,
    ROUND(AVG(units_sold)/NULLIF(AVG(inventory_level),0),2) AS inventory_turnover
FROM Inventory
GROUP BY product_id
ORDER BY inventory_turnover ASC;


-- Summary Reports with KPIs like stockout rates, inventory age, and average stock levels
-- STOCKOUT SUMMARY
-- Stockout Percentage=100*(stockouts/total_record)
SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN inventory_level = 0 THEN 1 ELSE 0 END) AS stockouts,
    ROUND(100.0*SUM(CASE WHEN inventory_level=0 THEN 1 ELSE 0 END)/COUNT(*),2) AS percentage
FROM Inventory;

-- INVENTORY SUMMARY
-- Average inventory,distinct product ,distinct stores
SELECT 
    ROUND(AVG(inventory_level),2) AS avg_inventory,
    COUNT(DISTINCT product_id) AS distinct_products,
    COUNT(DISTINCT store_id) AS distinct_stores
FROM Inventory;

-- SALES AND ORDER SUMMARY
-- total units sold and total units ordered
SELECT 
    ROUND(SUM(units_sold),2) AS total_units_sold,
    ROUND(SUM(units_ordered),2) AS total_units_ordered
FROM Inventory;