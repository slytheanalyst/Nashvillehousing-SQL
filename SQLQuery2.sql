/****** Script for SelectTopNRows command from SSMS  ******/
SELECT*
FROM [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]

-- Standardize Date Format
SELECT SaleDate
FROM [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]

-- Populate Property Address data
SELECT*
FROM [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]
--WHERE propertyaddress is NULL
ORDER BY ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)] a
JOIN [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)] b
ON a.ParcelID = b.ParcelID
And a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)] a
JOIN [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)] b
ON a.ParcelID = b.ParcelID
And a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]
--WHERE propertyaddress is NULL
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
FROM [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]


ALTER TABLE [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]
Add PropertySplitAddress Nvarchar(255);

Update [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]
Add PropertySplitCity Nvarchar(255);

Update [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


Select *
FROM [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]




Select OwnerAddress
FROM [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
from [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]


ALTER TABLE [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]
Add OwnerSplitAddress Nvarchar(255);

Update [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]
Add OwnerSplitCity Nvarchar(255);

Update [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]
Add OwnerSplitState Nvarchar(255);

Update [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]



-- Remove Duplicates

WITH RowNumCTE AS(
Select*,
ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]
--order by ParcelID
)
select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


-- Delete Unused Columns

select*
From [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]

ALTER TABLE [SQL data cleaning].[dbo].[Nashville Housing Data for Data Cleaning (reuploaded)]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

 


