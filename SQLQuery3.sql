

---------CLEANING DATA IN SQL---------

SELECT SaleDateConverted , Convert(Date, SaleDate) 
FROM PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
SET SaleDate = Convert(Date, SaleDate) 

ALter Table NashvilleHousing
add SaleDateConverted Date;


update NashvilleHousing
SET SaleDateConverted = Convert(Date, SaleDate) 

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing


---Property address data--

SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

SELECT a.ParcelID,  a.PropertyAddress, b.ParcelID, b.PropertyAddress , isnull(a.PropertyAddress , b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
SET PropertyAddress = isnull(a.PropertyAddress , b.PropertyAddress)
FROM PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]



-----------------	Putting address in individual columns  -------------------


SELECT PropertyAddress
FROM PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING( PropertyAddress ,1, CHARINDEX( ',' ,PropertyAddress)-1) AS Address ,
SUBSTRING( PropertyAddress , CHARINDEX( ',' ,PropertyAddress)+1, Len(PropertyAddress)) AS Address



FROM PortfolioProject.dbo.NashvilleHousing

ALter Table NashvilleHousing
add PropertySplitAddresss nvarchar(255);

update NashvilleHousing
SET PropertySplitAddresss = SUBSTRING( PropertyAddress ,1, CHARINDEX( ',' ,PropertyAddress)-1) 

ALter Table NashvilleHousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
SET PropertySplitCity = SUBSTRING( PropertyAddress , CHARINDEX( ',' ,PropertyAddress)+1, Len(PropertyAddress))



Select*
FROM PortfolioProject.dbo.NashvilleHousing





Select OwnerAddress
FROM PortfolioProject.dbo.NashvilleHousing


Select 
PARSENAME( REPLACE( OwnerAddress,',','.'),3),
PARSENAME( REPLACE( OwnerAddress,',','.'),2),
PARSENAME( REPLACE( OwnerAddress,',','.'),1)
FROM PortfolioProject.dbo.NashvilleHousing



ALter Table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
SET OwnerSplitAddress = PARSENAME( REPLACE( OwnerAddress,',','.'),3)


ALter Table NashvilleHousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
SET OwnerSplitCity = PARSENAME( REPLACE( OwnerAddress,',','.'),2)


ALter Table NashvilleHousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing
SET OwnerSplitState = PARSENAME( REPLACE( OwnerAddress,',','.'),1)




--------------Sold as vacant colmn-----------------

Select Distinct (SoldAsVacant) ,Count(SoldAsVacant) as C0untSold
From PortfolioProject..NashvilleHousing
group by SoldAsVacant
Order by 2

Select SoldAsVacant ,  Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant ='N' Then 'No'
	Else SoldAsVacant 
	End 
From PortfolioProject..NashvilleHousing


update NashvilleHousing
SET SoldAsVacant=   Case When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant ='N' Then 'No'
	Else SoldAsVacant 
	End 


Select*
FROM PortfolioProject.dbo.NashvilleHousing




------------Remove Duplicates--------------

With RowNumCTE AS (
Select* , 
ROW_NUMBER() over (Partition by  ParcelID , PropertyAddress, SalePrice, SaleDate,LegalReference Order by UniqueID) Row_num
FROM PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)

DELETE
From RowNumCTE
Where Row_num  >1
--order by PropertyAddress



----- Deleting unused columns -------

Select*
FROM PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict , PropertyAddress



Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column SaleDate