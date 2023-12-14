CREATE DATABASE Online_shop_customer_sales_data;
USE Online_shop_customer_sales_data;
SELECT * FROM sales_data;

-- Data Cleaning 
-- Changing the gender from "0" to male and "1" to female

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE sales_data
MODIFY COLUMN Gender TEXT;

UPDATE sales_data
SET Gender = CASE WHEN Gender ='0' THEN 'Male'
				  WHEN Gender ='1' THEN 'Female'
                  ELSE Gender
                  END;

ALTER TABLE sales_data
RENAME COLUMN N_Purchases TO  No_Purchases;

UPDATE sales_data
SET Purchase_Date = DATE_FORMAT(STR_TO_DATE(Purchase_Date, '%d.%m.%y'), '%d-%m-%y')
WHERE Purchase_Date LIKE '%.%.%';

-- Changing Payment Method From '0' to Digital_wallets , '1' to Card , '2' to Paypal and '3' to Others

ALTER TABLE sales_data
MODIFY COLUMN Pay_method TEXT;

UPDATE sales_data
SET Pay_method = CASE WHEN Pay_method ='0' THEN 'Digital_wallets'
				      WHEN Pay_method ='1' THEN 'Card'
				      WHEN Pay_method ='2' THEN 'Paypal'
				      WHEN Pay_method ='3' THEN 'Others'
                      ELSE pay_method
                      END;

-- Changing Voucher from '0' to Not_used and '1' to Used

ALTER TABLE sales_data
MODIFY COLUMN Voucher TEXT;

UPDATE sales_data
SET Voucher = CASE WHEN Voucher ='0' THEN 'Not_used'
				   WHEN Voucher ='1' THEN 'Used'
				   ELSE Voucher
				   END;
                   
SELECT * FROM sales_data;

ALTER TABLE sales_data
DROP column Newsletter;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CUSTOMER DEMOGRAPHICS
-- Analysing the distribution of customers by age and gender

SELECT Age, Gender, COUNT(*) AS Customer_Count
FROM sales_data
GROUP BY Age, Gender
ORDER BY Age, Gender;

-- Filtering by Age Range
SELECT 
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 45 THEN '31-45'
        WHEN Age > 45 THEN '46+'
        ELSE 'Other'
    END AS Age_Group,
Gender,
COUNT(*) AS Customer_Count,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Gender), 2) AS Percentage
FROM sales_data
GROUP BY Age_Group, Gender
ORDER BY Age_Group, Gender;
    
-- Filtering by Gender
    SELECT 
    Age,
    Gender,
    COUNT(*) AS Customer_Count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Gender), 2) AS Percentage
FROM sales_data
WHERE Gender = 'Male'  -- Or Female
GROUP BY Age, Gender
ORDER BY Age, Gender;
    
-- Average age
SELECT AVG(Age) AS Average_Age
FROM sales_data;

-- Compare Distribution of Purchases and Revenue between Genders
SELECT 
    Gender,
    SUM(No_Purchases) AS Total_Purchases,
    SUM(Revenue_Total) AS Total_Revenue
FROM sales_data
GROUP BY Gender;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PURCHASE BEHAVIOUR
-- Calculating the average revenue per purchase

SELECT 
SUM(Revenue_Total) / SUM(No_Purchases) AS Avg_Revenue_Per_Purchase
FROM sales_data;

-- Revenue Trends Monthly
SELECT 
DATE_FORMAT(Purchase_DATE, '%Y-%m') AS Month,
SUM(Revenue_Total) AS Monthly_Revenue
FROM sales_data
GROUP BY 
DATE_FORMAT(Purchase_DATE, '%Y-%m')
ORDER BY 
DATE_FORMAT(Purchase_DATE, '%Y-%m');

-- Payment Method Analysis

SELECT 
Pay_Method,
SUM(Revenue_Total) AS Revenue_By_Method
FROM sales_data
GROUP BY 
Pay_Method;

-- Voucher Analysis

SELECT Voucher,
COUNT(*) AS Customer_Count,
ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM sales_data)), 2) AS Percentage_of_Customers
FROM sales_data
GROUP BY Voucher;




