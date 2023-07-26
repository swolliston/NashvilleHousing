--Cleaning Data in SQL Queries

Select *
From Portfolio.dbo.NashvilleHousing


--Standardize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From Portfolio.dbo.NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


--Populate Property Address data

Select *
From Portfolio.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio.dbo.NashvilleHousing a
JOIN Portfolio.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From Portfolio.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From Portfolio..NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


SELECT *
From Portfolio..NashvilleHousing







SELECT OwnerAddress
From Portfolio..NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
From Portfolio..NashvilleHousing





ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)


SELECT *
From Portfolio..NashvilleHousing



--Change Y and N to Yes and No in "Sold as Vacant" field


SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From Portfolio..NashvilleHousing
Group by SoldAsVacant
order by 2


SELECT SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'Yes'
		when SoldAsVacant = 'N' THEN 'No'
		else SoldAsVacant
		END
From Portfolio..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
		when SoldAsVacant = 'N' THEN 'No'
		else SoldAsVacant
		END


--Remove Duplicates
WITH RowNumCTE AS(
Select *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) row_num
				
From Portfolio..NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
where row_num > 1
--Order by PropertyAddress



--Delete Unused Columns


Select *
From Portfolio..NashvilleHousing

Alter Table Portfolio..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

Alter Table Portfolio..NashvilleHousing
DROP COLUMN SaleDate