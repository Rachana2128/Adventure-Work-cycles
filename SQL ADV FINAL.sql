create database Adventure;
USE Adventure;
SHOW TABLES;
SELECT count(*) FROM adventureSQL;
ALTER TABLE adventureSQL RENAME COLUMN pODECTIONCOST TO productioncost  ;
SHOW COLUMNS FROM adventuresql;

-----------------------------------------------------------------------------------------------------------------------------------------------------------

  # KPI--
 # TOTAL_SALES ---
  SELECT CONCAT(ROUND(SUM(saleSAMOUNT) / 1000000, 2), 'M') 
  AS sumofsales FROM adventuresql;

#TOTAL_PROFIT 
    SELECT CONCAT(ROUND(SUM(PROFIT) / 1000000, 2), 'M') AS PROFIT
FROM adventuresql;

#TOTAL_CUSTOMERS--
SELECT COUNT(DISTINCT customerfullname) AS total_unique_customers
FROM adventuresql;

#TOTAL_ORDERQUANTITY----- 
SELECT 
  SUM(orderquantity) AS total_order_quantity
FROM adventuresql;

#PRDUCTIONCOST----
SELECT CONCAT(ROUND(SUM(productioncost) / 1000000, 2), 'M') 
  AS PRODUCTION_COST FROM adventuresql;
SELECT CONCAT(ROUND(sum(PRODUCTIONCOST) / 1000000, 2), 'M') AS
 TOTAL_PRODUCTIONCOST FROM adventureSQL;

#TOTAL TAX AMOUNT 
SELECT CONCAT(ROUND(SUM(TAXAMT) / 1000000 , 2), 'M') AS TOTAL_TAXAMOUNT FROM adventureSQL;

----------------------------------------------------------------------------------------------------------------
#Q.1
# Calcuate the following fields from the Orderdatekey field (First Create a Date Field from Orderdatekey)##
#Converts a numeric date key (YYYYMMDD) into a proper date format#####
  ## A. Year    B. Monthno   C. Monthfullname#####
SELECT 
    STR_TO_DATE(OrderDateKey, '%Y%m%d') AS OrderDate,
    YEAR(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS Year,
    MONTH(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS MonthNo,
    MONTHNAME(STR_TO_DATE(OrderDateKey, '%Y%m%d')) AS MonthFullName
FROM adventuresql;

----------------------------------------------------------------------------------------------------------------
  

#Q.3 
# Calculate the Sales amount using the columns (Unit price, Order quantity, Unit discount)####

SELECT 
	OrderQuantity,
    UnitPrice,
   (OrderQuantity * UnitPrice) AS SalesAmount
FROM adventuresql;

----------------------------------------------------------------------------------------------------------------

# Q.4 
#Calculate the Productioncost using the columns (Unit cost, Order quantity)########

SELECT 
    OrderQuantity,
  ProductStandardCost,
    (OrderQuantity * ProductStandardCost) AS ProductionCost
FROM adventuresql;

---------------------------------------------------------------------------------------------------------------------
#Q.6
SELECT SalesAmount AS TOTALSales, 
   PRODUCTIONCOST, 
    (SalesAMOUNT - PRODUCTIONCOST) AS TOTALProfit
FROM adventuresql;

----------------------------------------------------------------------------------------------------------------
#Q.7 
# MONTH WISE SALES 
SELECT 
  MonthFullName, 
  CONCAT(ROUND(SUM(SalesAmount) / 1000000.0, 2), 'M') AS TotalSales FROM AdventureSQL
  GROUP BY MonthFullName UNION ALL SELECT 'Grand Total', 
  CONCAT(ROUND(SUM(SalesAmount) / 1000000.0, 2), 'M')
FROM AdventureSQL
ORDER BY 
  CASE MonthFullName
    WHEN 'January' THEN 1
    WHEN 'February' THEN 2
    WHEN 'March' THEN 3
    WHEN 'April' THEN 4
    WHEN 'May' THEN 5
    WHEN 'June' THEN 6
    WHEN 'July' THEN 7
    WHEN 'August' THEN 8
    WHEN 'September' THEN 9
    WHEN 'October' THEN 10
    WHEN 'November' THEN 11
    WHEN 'December' THEN 12
    WHEN 'Grand Total' THEN 13
    ELSE 14
  END;


--------------------------------------------------------------------------------------------------------------
# Q.8
#YEAR WISE SALES AND PROFIT
SELECT 
    year, 
    CASE 
        WHEN SUM(salesamount) >= 1000000 THEN CONCAT(ROUND(SUM(salesamount) / 1000000.0, 2), 'M')
        WHEN SUM(salesamount) >= 1000 THEN CONCAT(ROUND(SUM(salesamount) / 1000.0, 2), 'K')
        ELSE ROUND(SUM(salesamount), 2)
    END AS sum_of_sales_amount,-- 
    CASE 
        WHEN SUM(profit) >= 1000000 THEN CONCAT(ROUND(SUM(profit) / 1000000.0, 2), 'M')
        WHEN SUM(profit) >= 1000 THEN CONCAT(ROUND(SUM(profit) / 1000.0, 2), 'K')
        ELSE ROUND(SUM(profit), 2)
    END AS sum_of_profit
FROM 
    adventuresql
GROUP BY 
    year

UNION ALL

SELECT 
    'Grand Total',
    CASE 
        WHEN SUM(salesamount) >= 1000000 THEN CONCAT(ROUND(SUM(salesamount) / 1000000.0, 2), 'M')
        WHEN SUM(salesamount) >= 1000 THEN CONCAT(ROUND(SUM(salesamount) / 1000.0, 2), 'K')
        ELSE ROUND(SUM(salesamount), 2)
    END,
    CASE 
        WHEN SUM(profit) >= 1000000 THEN CONCAT(ROUND(SUM(profit) / 1000000.0, 2), 'M')
        WHEN SUM(profit) >= 1000 THEN CONCAT(ROUND(SUM(profit) / 1000.0, 2), 'K')
        ELSE ROUND(SUM(profit), 2)
    END
FROM 
    adventuresql

ORDER BY 
    CASE 
        WHEN year = 'Grand Total' THEN 9999
        ELSE CAST(year AS UNSIGNED)
    END;
    
----------------------------------------------------------------------------------------------------------------
# Q.9
# REGION WISE SALES AND PROFIT 
SELECT 
    IFNULL(salesterritoryregion, 'Grand Total') AS Region,
    CASE 
        WHEN SUM(salesamount) >= 1000000 THEN 
            CONCAT(ROUND(SUM(salesamount) / 1000000.0, 2), ' M')
        WHEN SUM(salesamount) >= 1000 THEN 
            CONCAT(ROUND(SUM(salesamount) / 1000.0, 2), ' K')
        ELSE 
            SUM(salesamount)
    END AS SumofSalesAmount,
CASE 
        WHEN SUM(profit) >= 1000000 THEN 
            CONCAT(ROUND(SUM(profit) / 1000000.0, 2), ' M')
        WHEN SUM(profit) >= 1000 THEN 
            CONCAT(ROUND(SUM(profit) / 1000.0, 2), ' K')
        ELSE 
            SUM(profit)
    END AS SumofProfit
FROM 
    adventuresql
GROUP BY 
    salesterritoryregion WITH ROLLUP;
  
  
 ---------------------------------------------------------------------------------------------------------------
 #Q.10
-- Top 10 Customers by SalesAmount AND PROFIT  with formatted output

SELECT 
    CustomerFullName,
    CASE 
        WHEN SUM(SalesAmount) >= 1000000 THEN CONCAT(ROUND(SUM(SalesAmount) / 1000000, 2), 'M')
        WHEN SUM(SalesAmount) >= 1000 THEN CONCAT(ROUND(SUM(SalesAmount) / 1000, 2), 'K')
        ELSE ROUND(SUM(SalesAmount), 2)
    END AS SalesAmount,
    CASE 
        WHEN SUM(Profit) >= 1000000 THEN CONCAT(ROUND(SUM(Profit) / 1000000, 2), 'M')
        WHEN SUM(Profit) >= 1000 THEN CONCAT(ROUND(SUM(Profit) / 1000, 2), 'K')
        ELSE ROUND(SUM(Profit), 2)
    END AS Profit
FROM 
    AdventureSQL
GROUP BY 
    CustomerFullName
ORDER BY 
    SUM(SalesAmount) DESC
LIMIT 10;

-------------------------------------------------------------------------------------------------------------------------------------------------------------
#Q.11
#Top 10 PRODUCTS by SalesAmount AND PROFIT  with formatted output
SELECT 
    ProductName,
    CASE 
        WHEN SUM(SalesAmount) >= 1000000 THEN CONCAT(ROUND(SUM(SalesAmount) / 1000000, 2), 'M')
        WHEN SUM(SalesAmount) >= 1000 THEN CONCAT(ROUND(SUM(SalesAmount) / 1000, 2), 'K')
        ELSE ROUND(SUM(SalesAmount), 2)
    END AS SalesAmount,
    CASE 
        WHEN SUM(Profit) >= 1000000 THEN CONCAT(ROUND(SUM(Profit) / 1000000, 2), 'M')
        WHEN SUM(Profit) >= 1000 THEN CONCAT(ROUND(SUM(Profit) / 1000, 2), 'K')
        ELSE ROUND(SUM(Profit), 2)
    END AS Profit
FROM 
    AdventureSQL
GROUP BY 
    ProductName
ORDER BY 
    SUM(SalesAmount) DESC
LIMIT 10;


--------------------------------------------------------------------------------------------------------------------------------------------------------------
#Q.12
#QUATERLY SALES AND PROFIT 
SELECT 
  quarter, FORMAT(SUM(salesamount), 'N1') AS total_sales,FORMAT
  (SUM(profit), 'N1') AS total_profit FROM  adventuresql
GROUP BY quarter ORDER BY 
  CASE quarter WHEN 'Q1' THEN 1 WHEN 'Q2' THEN 2 WHEN 'Q3' THEN 3 WHEN 'Q4' THEN 4
  END;
  
  --------------------------------------------------------------------------------------------------------------------------------------------------------
  #Q.13
  #MONTH WISE SALES AND PROFIT 
  SELECT 
  monthfullname,
  CASE 
    WHEN SUM(salesamount) >= 1000000 THEN 
      CONCAT(FORMAT(SUM(salesamount) / 1000000, 2), 'M')
    ELSE 
      CONCAT(FORMAT(SUM(salesamount) / 1000, 2), 'K')
  END AS sales_amount,
  CASE 
    WHEN SUM(productioncost) >= 1000000 THEN 
      CONCAT(FORMAT(SUM(productioncost) / 1000000, 2), 'M')
    ELSE 
      CONCAT(FORMAT(SUM(productioncost) / 1000, 2), 'K')
  END AS production_cost
FROM adventuresql
GROUP BY monthfullname
ORDER BY STR_TO_DATE(monthfullname, '%M');

  
  
-------------------------------------------------------------------------------------------------------------------------------------------------------------
# Q.14
# GRAND ALALYSIS
SELECT 
    salesterritoryregion,
    ROUND(SUM(salesamount), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(productioncost), 2) AS total_production_cost,
    SUM(orderquantity) AS total_order_quantity,
    ROUND(SUM(taxamt), 2) AS total_tax FROM adventuresql GROUP BY salesterritoryregion;


------------------------------------------------------------------------------------------------------------------------------------------------------------
								------------------------#END#---------------------






