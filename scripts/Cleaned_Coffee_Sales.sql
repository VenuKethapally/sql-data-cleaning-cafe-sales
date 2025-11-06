--IMPORTING & STAGING

-- Using flat file import, impoted cafe sales data into [dirty_cafe_sales] table 
--(It will directly create table in the database, no need to create explixcitly)
-- Created a table [dirty_cafe_sales_staging], copied entire date from [dirty_cafe_sales] for cleaning the data without affecting raw data

CREATE TABLE [dbo].[dirty_cafe_sales_cleaning](
	[Transaction_ID] [nvarchar](50) NOT NULL,
	[Item] [nvarchar](50) NULL,
	[Quantity] [nvarchar](50) NULL,
	[Price_Per_Unit] [float] NULL,
	[Total_Spent] [float] NULL,
	[Payment_Method] [nvarchar](50) NULL,
	[Location] [nvarchar](50) NULL,
	[Transaction_Date] [date] NULL
) ON [PRIMARY]
GO

INSERT INTO [dirty_cafe_sales_staging] select * from [dirty_cafe_sales]


-- Removing unwanted spaces

UPDATE [dirty_cafe_sales_staging]
SET
Transaction_ID = TRIM(Transaction_ID),
Item = TRIM(Item),
Quantity = TRIM(Quantity),
Payment_Method = TRIM(Payment_Method),
Location = TRIM(Location);



-- Populating Quantity column where the values are NULL or ERROR or UNKNOWN 
--using Total_Spent and Price_Per_Unit cloumns

UPDATE [dirty_cafe_sales_staging]
SET
Quantity=Total_Spent/Price_Per_Unit 
from [dirty_cafe_sales_staging] 
where Quantity is null or Quantity = 'ERROR' or Quantity = 'UNKNOWN' and Total_Spent is not null and Price_Per_Unit is not null


-- Populating Price_Per_Unit column where the values are NULL
--using Total_Spent and Quantity cloumns. Here Quantity is of text data type

UPDATE [dirty_cafe_sales_staging]
SET
Price_Per_Unit=Total_Spent/TRY_CAST(Quantity AS FLOAT)
from [dirty_cafe_sales_staging] 
where Price_Per_Unit is null and Total_Spent is not null 
and Quantity is not null AND Quantity != 'UNKNOWN' AND Quantity != 'ERROR'

-- Populating Tota_Spent column where the values are NULL
--using Price_Per_Unit and Quantity cloumns. Here Quantity is of text data type

UPDATE [dirty_cafe_sales_staging]
SET
Total_Spent = Price_Per_Unit * TRY_CAST(Quantity AS FLOAT)
from [dirty_cafe_sales_staging]
where Total_Spent is null and Price_Per_Unit is not null 
and Quantity is not null AND Quantity != 'UNKNOWN' AND Quantity != 'ERROR'


--Getting the price of each item

select item,Price_Per_Unit from [dirty_cafe_sales_staging] 
group by item,Price_Per_Unit 
having item NOT IN ('UNKNOWN','ERROR','NULL') 
AND Price_Per_Unit is not null
order by Price_Per_Unit asc

-- Cookie	1
--Tea	1.5
--Coffee	2
--Cake	3
--Juice	3
--Smoothie	4
--Sandwich	4
--Salad	5

-- here Cake and Juice are 3, Smoothie and Sandwich are 4. As price is same for more than one item, we cannot use this update the item name

-- Populating Item column using Price_Per_Quantity columns
UPDATE [dirty_cafe_sales_staging]
SET 
Item = 
CASE 
	WHEN Price_Per_Unit=1 THEN 'Cookie'
	WHEN Price_Per_Unit =1.5 THEN 'Tea'
	WHEN Price_Per_Unit = 2 THEN 'Coffee'
	WHEN Price_Per_Unit = 5 THEN 'Salad'
	END;


-- Removing unwanted NULL values

DELETE FROM [dirty_cafe_sales_staging]
WHERE	Item is null or Item IN ('UNKNOWN','ERROR')