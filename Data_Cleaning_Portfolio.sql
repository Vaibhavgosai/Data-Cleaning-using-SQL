-- Cleaning data using SQL queries

SELECT * FROM SQL_Portfolio.dbo.NashvilleHousing


-- Standardize Date format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From SQL_Portfolio.dbo.NashvilleHousing

update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- #1 We run the following command first to alter table.
ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

-- #2 We run this followed by #1.
update NashvilleHousing
SET SaleDateConverted = CONVERT (Date,SaleDate)



-- Populate Property Address Data

Select *
From SQL_Portfolio.dbo.NashvilleHousing
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From SQL_Portfolio.dbo.NashvilleHousing a
JOIN SQL_Portfolio.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Replacing Null values using UPDATE and SET
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From SQL_Portfolio.dbo.NashvilleHousing a
JOIN SQL_Portfolio.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




-- Breaking out Address into Individual columns(Address, City, State)

SELECT PropertyAddress
From SQL_Portfolio.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

From SQL_Portfolio.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) 


SELECT *
From SQL_Portfolio.dbo.NashvilleHousing


SELECT OwnerAddress
From SQL_Portfolio.dbo.NashvilleHousing


-- Using Parsename to get Address, City, State
SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.') ,3),
PARSENAME(REPLACE(OwnerAddress,',','.') ,2),
PARSENAME(REPLACE(OwnerAddress,',','.') ,1)
From SQL_Portfolio.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3) 

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') ,1)

SELECT *
From SQL_Portfolio.dbo.NashvilleHousing




-- Changing Y and N to Yes and No in "SoldasVacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM SQL_Portfolio.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2



SELECT SoldAsVacant,
	CASE When SoldAsVacant = 'Y' THEN 'Yes'
		 When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END
FROM SQL_Portfolio.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		 When SoldAsVacant = 'N' THEN 'No'
		 ELSE SoldAsVacant
		 END





-- Remove duplicates

WITH RowNumCTE AS(
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


From SQL_Portfolio.dbo.NashvilleHousing
--Order by ParcelID
)

--DELETE
SELECT *
FROM RowNumCTE
WHERE row_num > 1
--Order by PropertyAddress









-- Deleting unused columns

SELECT *
From SQL_Portfolio.dbo.NashvilleHousing

ALTER TABLE SQL_Portfolio.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress
