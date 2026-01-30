# Nashville-Housing-Data-Cleaning
Data Cleaning and Transformation of Nashville Housing Records using SQL Server (T-SQL).

# Nashville Housing Data Cleaning Project

## 📌 Project Overview
This project involves a comprehensive data cleaning process for a messy dataset of Nashville Housing records. The goal was to transform raw data into a structured, analysis-ready format by resolving inconsistencies, handling missing values, and normalizing data strings.

## 🛠 Tools & Technologies
- **Language:** SQL (T-SQL / Microsoft SQL Server)
- **Concepts:** CTEs, Window Functions, Self-Joins, String Parsing, Data Normalization.

## 🧹 Data Cleaning Steps
1. **Standardizing Date Format:** Converted the `SaleDate` column into a standard YYYY-MM-DD format.
2. **Populating Property Address:** Used a **Self-Join** on `ParcelID` to fill in missing address data where records shared the same ID.
3. **Breaking out Addresses:** Used `SUBSTRING` and `PARSENAME` to split monolithic address strings into individual columns for Address, City, and State.
4. **Handling Boolean Logic:** Standardized "Y" and "N" entries in the `SoldAsVacant` field to "Yes" and "No."
5. **Removing Duplicates:** Employed a **CTE** with `ROW_NUMBER()` to identify and remove 100+ duplicate rows based on unique transaction fingerprints.
6. **Dropping Unused Columns:** Cleaned up the schema by removing redundant or raw data columns after transformation.

## 📂 File Structure
- `Nashville_Cleaning_Queries.sql`: Contains the full T-SQL script for the transformation.
- `Nashville_Housing_Data.csv`: The raw dataset used for the project.

## 🚀 How to Run
1. Download the `.csv` file.
2. Import the data into SQL Server Management Studio (SSMS).
3. Run the queries in the provided `.sql` file in sequential order.
