/*
CLEANING DATA IN SQL QUERIES
-- 

-- *** IMPORTANT: BEFORE EXECUTING ANY DELETE OR UPDATE STATEMENTS THAT MAY MODIFY DATA 
IN THIS DATABASE, ENSURE THAT YOU HAVE TAKEN A BACKUP OF THE DATABASE. 
DATA LOSS DUE TO ACCIDENTAL DELETION OR MODIFICATION CAN BE IRREVERSIBLE. 
ALWAYS EXERCISE CAUTION AND DOUBLE-CHECK YOUR QUERIES BEFORE PROCEEDING. 
IF YOU ARE UNSURE, CONSULT WITH A DATABASE ADMINISTRATOR OR SUPERVISOR FOR GUIDANCE. 
THANK YOU FOR YOUR ATTENTION TO THIS MATTER. ***

-- For practice purpose only

*/

SELECT *
FROM PortfolioProject..NashvilleHousing

----------------------------------------------------------------------------------------
/* Converting YYYY-MM-DD hh:mm:ss --> YYYY-MM-DD*/

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

SELECT SaleDateConverted
FROM PortfolioProject..NashvilleHousing

----------------------------------------------------------------------------------------
/*Populate Property Address*/

SELECT *
FROM PortfolioProject..NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
	ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing AS a
	JOIN PortfolioProject..NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Updating the NULL 'PropertyAddress' Column
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing AS a
	JOIN PortfolioProject..NashvilleHousing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

----------------------------------------------------------------------------------------

/* Breaking Address into Individual Columns (Address, City, State) */
--1. View
SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing


/*USING SUBSTRING METHOD*/
SELECT 
    SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) AS Address,
    SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 2, LEN(PropertyAddress)) AS City
FROM PortfolioProject..NashvilleHousing


/*USING PARSENAME METHOD*/

-- 1. View
SELECT *
FROM PortfolioProject..NashvilleHousing

SELECT 
    PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2) AS Address,
    PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1) AS City
FROM PortfolioProject..NashvilleHousing

/* UPDATING/ALTERING THE 'PropertyAddress' COLUMN TO SPLIT THE ADDRESS*/

ALTER TABLE NashvilleHousing
ADD Property_Address NVARCHAR(255);

UPDATE NashvilleHousing
SET Property_Address = PARSENAME(REPLACE(PropertyAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD Property_City NVARCHAR(255);

UPDATE NashvilleHousing
SET Property_City = PARSENAME(REPLACE(PropertyAddress, ',', '.'), 1)

/* UPDATING/ALTERING THE 'OwnerAddress' COLUMN TO SPLIT THE ADDRESS*/

SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.') , 3) AS Address,
PARSENAME(REPLACE(OwnerAddress, ',','.') , 2) AS City,
PARSENAME(REPLACE(OwnerAddress, ',','.') , 1) AS State
FROM PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD Owner_Address NVARCHAR(255);

UPDATE NashvilleHousing
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress, ',','.') , 3)

ALTER TABLE NashvilleHousing
ADD Owner_City NVARCHAR(255);

UPDATE NashvilleHousing
SET Owner_City = PARSENAME(REPLACE(OwnerAddress, ',','.') , 2)

ALTER TABLE NashvilleHousing
ADD Owner_State NVARCHAR(255);

UPDATE NashvilleHousing
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)

--VIEW
SELECT *
FROM NashvilleHousing

----------------------------------------------------------------------------------------
/* CHANGE 'Y' to 'YES' and 'N' to 'NO' in 'SoldAsVacant' Column. */
SELECT DISTINCT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing


SELECT SoldAsVacant,
	   CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
	   END
FROM PortfolioProject..NashvilleHousing


/* Updating the 'SoldAsVacant' Column using the Case statements */
UPDATE NashvilleHousing
SET SoldAsVacant = CASE
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END

----------------------------------------------------------------------------------------
/* REMOVE DUPLICATES */

WITH RowNumCTE AS ( -- USING CTE to identify all the Duplicate rows
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
				 ) row_num
FROM NashvilleHousing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

-- The above query shows the duplicate rows
-- The below query shows how to delete the duplicate rows

-- Using DELETE syntax on CTE After Identifying the duplicate rows
WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
				 ) row_num
FROM NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1


----------------------------------------------------------------------------------------
/* DELETE UNUSED COLUMNS */

SELECT *
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, SaleDate

