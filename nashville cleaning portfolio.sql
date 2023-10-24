SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProjects].[dbo].[NashvilleHousing]


  --Cleaning data in sql quaries

  select SaleDateConverted, convert(date,saledate)
  from PortfolioProjects..NashvilleHousing


  update NashvilleHousing 
  set SaleDate = convert(date,saledate)

  alter table NashvilleHousing
  add SaleDateConverted date;

  update NashvilleHousing
  set SaleDateConverted = convert(date,saledate)


  --------------------------------------------------
  --populate property address data


   select *
  from PortfolioProjects..NashvilleHousing
  --where PropertyAddress is null 
  order by ParcelID

  select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
  from PortfolioProjects..NashvilleHousing a
  join PortfolioProjects..NashvilleHousing b
       on a.ParcelID = b.ParcelID
	   and a.[UniqueID ] <> b.[UniqueID ]
	   where a.PropertyAddress is null

update a
  set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
  from PortfolioProjects..NashvilleHousing a
  join PortfolioProjects..NashvilleHousing b
       on a.ParcelID = b.ParcelID
	   and a.[UniqueID ] <> b.[UniqueID ]
	 where a.PropertyAddress is null 

---------------------------------------------
--breaking out adress into individual columns (adress, city, state)


select PropertyAddress
from PortfolioProjects..NashvilleHousing
--order by ParcelID

select 
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress)) as address
 from PortfolioProjects..NashvilleHousing

 --to remove the comma (,)

 select 
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress)-1) as address
 from PortfolioProjects..NashvilleHousing





  select 
SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress, charindex(',', PropertyAddress)+1 , LEN(PropertyAddress)) address
 from PortfolioProjects..NashvilleHousing



  alter table NashvilleHousing
  add PropertySplitAddress nvarchar(255);

  update NashvilleHousing
  set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, charindex(',', PropertyAddress)-1)


  
  alter table NashvilleHousing
  add PropertySplitCity nvarchar(255);

  update NashvilleHousing
  set PropertySplitCity = SUBSTRING(PropertyAddress, charindex(',', PropertyAddress)+1 , LEN(PropertyAddress))

  select *
  from PortfolioProjects..NashvilleHousing



  

  
  select OwnerAddress
  from PortfolioProjects..NashvilleHousing

  select
  PARSENAME(replace(owneraddress, ',', '.') ,3) as city	,
   PARSENAME(replace(owneraddress, ',', '.') ,2) as adress,
    PARSENAME(replace(owneraddress, ',', '.') ,1) as state

  from PortfolioProjects..NashvilleHousing




  
  alter table NashvilleHousing
  add OwnerSplitAddress nvarchar(255);

  update NashvilleHousing
  set OwnerSplitAddress =  PARSENAME(replace(owneraddress, ',', '.') ,3) 


  
  alter table NashvilleHousing
  add OwnerSplitCity nvarchar(255) 

  update NashvilleHousing
  set OwnerSplitCity =  PARSENAME(replace(owneraddress, ',', '.') ,2) 

  
  
  alter table NashvilleHousing
  add OwnerSplitState nvarchar(255);

  update NashvilleHousing
  set OwnerSplitState =  PARSENAME(replace(owneraddress, ',', '.') ,1) 


  select * 
  from PortfolioProjects..NashvilleHousing





  -------------------------------------------------

  --change Y and N to YES and NO in "Sold as Vacent" field

  select distinct(SoldAsVacant), count(SoldAsVacant)
  from PortfolioProjects..NashvilleHousing
  group by SoldAsVacant
  order by 2

  select SoldAsVacant
  , case when SoldAsVacant = 'y'
  then 'yes'
      when SoldAsVacant = 'n'
	  then 'no'
	else SoldAsVacant
	end
  from PortfolioProjects..NashvilleHousing



  update NashvilleHousing
  set SoldAsVacant =  case when SoldAsVacant = 'y'
  then 'yes'
      when SoldAsVacant = 'n'
	  then 'no'
	else SoldAsVacant
	end



	------------------
	--remove duplicate


WITH RowNumCTE as(
	select *,
	ROW_NUMBER() over (
	partition by parcelid,
	propertyaddress,
	saleprice,
	saledate,
	legalreference
	order by uniqueid ) row_num

	from PortfolioProjects..NashvilleHousing
	--order by ParcelID
	)
	select * 
	from RowNumCTE
	where row_num > 1
	order by PropertyAddress



	--delete unused columns

	select *
	from PortfolioProjects..NashvilleHousing


	alter table PortfolioProjects..NashvilleHousing
	drop column OwnerAddress, taxdistrict, propertyaddress


	alter table PortfolioProjects..NashvilleHousing
	drop column saledate