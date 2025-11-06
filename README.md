# sql-data-cleaning-cafe-sales
# SQL Data Cleaning – Cafe Sales Dataset

## 🧾 Overview
This project demonstrates a full SQL-based data cleaning workflow using a messy cafe sales dataset imported via a flat file. The goal is to clean, standardize, and enrich the data for downstream reporting and analysis.

## 🛠 Tools Used
- SQL Server Management Studio (SSMS)
- T-SQL functions: `TRIM()`, `TRY_CAST()`, `CASE`, `DELETE`, `UPDATE`, `GROUP BY`

## 🧹 Cleaning Steps
1. **Imported raw data** into `[dirty_cafe_sales]` via flat file
2. **Created staging table** `[dirty_cafe_sales_staging]` to preserve original data
3. **Trimmed whitespace** from key columns
4. **Populated missing or invalid `Quantity`** using `Total_Spent / Price_Per_Unit`
5. **Calculated missing `Price_Per_Unit`** using `Total_Spent / Quantity`
6. **Calculated missing `Total_Spent`** using `Price_Per_Unit * Quantity`
7. **Identified item pricing** using `GROUP BY` and filtered out invalid entries
8. **Populated `Item` column** using `CASE` logic based on unique prices
9. **Removed rows** with `NULL`, `'UNKNOWN'`, or `'ERROR'` in `Item`
10. **Created final cleaned table** `[dirty_cafe_sales_cleaning]` for reporting


## 🚀 How to Run
1. Import `dirty_cafe_sales.xlsx` into SQL Server using the flat file import wizard
2. Run `clean_cafe_sales.sql` in SSMS
3. Query `[dirty_cafe_sales_cleaning]` for cleaned data

## 📌 Author
Venukethapally – SQL Server DBA & aspiring Data Engineer  
[LinkedIn](https://www.linkedin.com/in/venukethapally) | [GitHub](https://github.com/venukethapally)

