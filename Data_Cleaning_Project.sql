/*
Cleaning Data in SQL Queries
*/

SELECT * 
FROM Portfolio_Project_02..HousingData

------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Standardise Date Format
 
SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM Portfolio_Project_02..HousingData

ALTER TABLE HousingData
Add SaleDateConverted Date;

UPDATE HousingData
SET SaleDateConverted = CONVERT(Date, SaleDate)

------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT *
FROM Portfolio_Project_02..HousingData
where PropertyAddress is null
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Portfolio_Project_02..HousingData a
JOIN Portfolio_Project_02..HousingData b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE A.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM Portfolio_Project_02..HousingData a
JOIN Portfolio_Project_02..HousingData b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE A.PropertyAddress is null


------------------------------------------------------------------------------------------------------------------------------------------------------------------
 -- Breaking out Address into Individual Columns(Address, City, State)

   
SELECT PropertyAddress 
FROM Portfolio_Project_02..HousingData

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
FROM Portfolio_Project_02..HousingData
-- +1 and -1 are included to omit the commas in our address


--***********************************ALTERING**************************************************

ALTER TABLE HousingData
Add Property_Address_only nvarchar(255);

ALTER TABLE HousingData
Add Property_City_only nvarchar(255);

--***********************************UPDATING**************************************************

UPDATE HousingData
SET Property_Address_only = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

UPDATE HousingData
SET Property_City_only = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*


SELECT Property_Address_only, Property_City_only
FROM Portfolio_Project_02..HousingData

/* using PARSENAME */
SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'), 1),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)

FROM Portfolio_Project_02..HousingData

/* parsename is better to use than subsring */

--***********************************ALTERING**************************************************

ALTER TABLE HousingData
Add Owner_State_only nvarchar(255);

ALTER TABLE HousingData
Add Owner_City_only nvarchar(255);

ALTER TABLE HousingData
Add Owner_Address_only nvarchar(255);


--***********************************UPDATING**************************************************
UPDATE HousingData
SET Owner_State_only = PARSENAME(REPLACE(OwnerAddress, ',','.'), 1)

UPDATE HousingData
SET Owner_City_only = PARSENAME(REPLACE(OwnerAddress, ',','.'), 2)

UPDATE HousingData
SET Owner_Address_only = PARSENAME(REPLACE(OwnerAddress, ',','.'), 3)

--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*--*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

SELECT Owner_Address_only, Owner_City_only, Owner_State_only
FROM Portfolio_Project_02..HousingData




------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "SoldAsVacant" field

SELECT DISTINCT(SoldAsVacant), Count(SoldAsVacant)
FROM Portfolio_Project_02..HousingData
Group by SoldAsVacant
Order BY 2


SELECT SoldAsVacant,

CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM Portfolio_Project_02..HousingData



UPDATE Portfolio_Project_02..HousingData
SET 
SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END

------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS (

SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
) row_num
FROM Portfolio_Project_02..HousingData
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM Portfolio_Project_02..HousingData

ALTER TABLE Portfolio_Project_02..HousingData
DROP COLUMN
			PropertyAddress,
			SaleDate,
			OwnerAddress,
			TaxDistrict

------------------------------------------------------------------------------------------------------------------------------------------------------------------













































