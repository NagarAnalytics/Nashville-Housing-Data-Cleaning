/*-------------SQL DATA CLEANING-------------*/


Select * from PortfolioProject..Nashville

-----------Standarize the Date Format--------------

Select SaleDate, SaleDateConverted, CONVERT(Date,SaleDate) from Nashville
UPDATE Nashville set SaleDate = CONVERT(Date,SaleDate) 

ALTER TABLE Nashville ADD SaleDateConverted Date;
UPDATE Nashville set SaleDateConverted = CONVERT(Date,SaleDate) 


-------------Populate Property Address--------------

select * from Nashville
--where PropertyAddress is NULL
Order By ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
From Nashville as a
JOIN Nashville as b 
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
From Nashville as a
JOIN Nashville as b 
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null


-------------Breaking Out the Address into Indiviual Columns (Address, City, State)----------------

Select PropertyAddress From Nashville

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as PAddress
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as PCity
From Nashville

ALTER TABLE Nashville ADD PropertySplitAddress NVARCHAR(255);
UPDATE Nashville set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE Nashville ADD PropertySplitCity NVARCHAR(255);
UPDATE Nashville set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))




Select OwnerAddress from Nashville

select
PARSENAME(Replace(OwnerAddress, ',' , '.'),3) 
,PARSENAME(Replace(OwnerAddress, ',' , '.'),2) 
,PARSENAME(Replace(OwnerAddress, ',' , '.'),1) 
from Nashville

ALTER TABLE Nashville ADD OwnerSplitAddress NVARCHAR(255);
UPDATE Nashville set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',' , '.'),3)

ALTER TABLE Nashville ADD OwnerSplitCity NVARCHAR(255);
UPDATE Nashville set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',' , '.'),2)

ALTER TABLE Nashville ADD OwnerSplitState NVARCHAR(255);
UPDATE Nashville set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',' , '.'),1)


-----------------Change Y/N to Yes/No in Sold As Vacant field------------------

select distinct(SoldAsVacant), count(SoldASVacant) from Nashville
group by SoldAsVacant
order by 2


select SoldAsVacant 
,CASE When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   ELSE SoldASVacant 
	   END
From Nashville

Update Nashville SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
										 When SoldAsVacant = 'N' Then 'No'
										 ELSE SoldASVacant 
									 END


-------------------Remove Duplicates-------------------

WITH RowNumCTE as (
					Select *, ROW_NUMBER() OVER( 
							  Partition By ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
							  Order by UniqueID ) row_num
					From Nashville
					--order by ParcelID
					)

select * from RowNumCTE 
where row_num > 1
order by PropertyAddress

 --DELETE from RowNumCTE 
--where row_num > 1

------------------------Delete Unused Columns-----------------------

select * from Nashville

ALTER TABLE Nashville DROP Column OwnerAddress, PropertyAddress, TaxDistrict, SaleDate


-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE PortfolioProject 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [Sheet1$]);
--GO







