--------------------------------------------------------------------------------------------------------------------------------------------
-- Cleaning Housing Data 
select * from PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------------------------
-- Standardizing Date Format

select SaleDate, convert(date, SaleDate) 
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate = Convert(date, SaleDate)

Select SaleDate From NashvilleHousing

----------------------------------------------------------------------------------------------------------------------------------------------
--Populating property address data

Select *
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is NULL
order by ParcelID

select a.ParcelID , a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
    And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
    on a.ParcelID = b.ParcelID
    And a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is NULL

------------------------------------------------------------------------------------------------------------------------------------------------
-- Breaking Address into individual columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Addess
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress NVARCHAR(255)

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter TABLE PortfolioProject.dbo.NashvilleHousing
add PropertySplitCity NVARCHAR(255)

Update PortfolioProject.dbo.NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

select * 
From PortfolioProject.dbo.NashvilleHousing

Select OwnerAddress 
From PortfolioProject.dbo.NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
, PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255)

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitAddress  = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

Alter TABLE PortfolioProject.dbo.NashvilleHousing
add OwnerSplitCity NVARCHAR(255)

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState NVARCHAR(255)

Update PortfolioProject.dbo.NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

select * 
From PortfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------------------------------
-- Changing Y and N to "Yes" and "No" in "Sold as Vacant" field

select Distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, Case when SoldAsVacant = 'Y' then 'Yes' 
    when SoldAsVacant = 'N' then 'No'
    Else SoldAsVacant
    END
from PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes' 
    when SoldAsVacant = 'N' then 'No'
    Else SoldAsVacant
    END;

-- Checking to ensure changes to query have been updated successfully  

select Distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

---------------------------------------------------------------------------------------------------------------------------------------------
--Removing Duplicates
WITH RowNumCTE as (
Select *,
    ROW_NUMBER() OVER(
    PARTITION BY ParcelID, 
                PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
                Order BY
                    UniqueID
    ) row_num

                
from PortfolioProject.dbo.NashvilleHousing
--Order by ParcelID
)
Select *  
from RowNumCTE
Where row_num > 1 
Order by PropertyAddress

-- Checking Updated Table to ensure duplicates are gone
select * 
from PortfolioProject.dbo.NashvilleHousing

-----------------------------------------------------------------------------------------------------------------------------------------------
-- Deleting Unused Columns
select * 
from PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

------------------------------------------------------------------------------------------------------------------------------------------------
-- Housing Data is now cleaned, and therefore easier for in depth data querying 
select * 
from PortfolioProject.dbo.NashvilleHousing
