--YTD Sales Via Aggregate Query:

SELECT

      [Total YTD Sales] = SUM(SalesYTD)
      ,[Max YTD Sales] = MAX(SalesYTD)

FROM AdventureWorks2019.Sales.SalesPerson



--YTD Sales With OVER:

SELECT BusinessEntityID
      ,TerritoryID
      ,SalesQuota
      ,Bonus
      ,CommissionPct
      ,SalesYTD
	  ,SalesLastYear
      ,[Total YTD Sales] = SUM(SalesYTD) OVER()
      ,[Max YTD Sales] = MAX(SalesYTD) OVER()
      ,[% of Best Performer] = SalesYTD/MAX(SalesYTD) OVER()

FROM AdventureWorks2019.Sales.SalesPerson
--Exercise1
SELECT Person.Person.FirstName,Person.Person.LastName,HumanResources.Employee.JobTitle,
HumanResources.EmployeePayHistory.Rate, AVG(HumanResources.EmployeePayHistory.Rate) OVER () as AverageRate,
MAX(HumanResources.EmployeePayHistory.Rate) OVER () as MaximumRate,
HumanResources.EmployeePayHistory.Rate - AVG(HumanResources.EmployeePayHistory.Rate) OVER () as DiffFromAvgRate,
(HumanResources.EmployeePayHistory.Rate / MAX(HumanResources.EmployeePayHistory.Rate) OVER ()) * 100 as PercentofMaxRate
FROM Person.Person inner join HumanResources.Employee ON Person.BusinessEntityID = HumanResources.Employee.BusinessEntityID
inner join 
HumanResources.EmployeePayHistory 
ON HumanResources.Employee.BusinessEntityID = HumanResources.EmployeePayHistory.BusinessEntityID
--Exercise 2
SELECT Production.Product.Name AS 'ProductName', Production.Product.ListPrice, 
Production.ProductSubcategory.Name AS 'ProductSubcategory', Production.ProductCategory.Name AS 'ProductCategory', 
AVG(Production.Product.ListPrice) OVER(PARTITION BY Production.ProductCategory.ProductCategoryID, Production.ProductSubcategory.ProductSubcategoryID) 
AS 'AvgPriceByCategoryAndSubcateory',
Production.Product.ListPrice - AVG(Production.Product.ListPrice) OVER (PARTITION BY Production.ProductCategory.ProductCategoryID) AS ProductVsCategoryDelta
FROM Production.Product INNER JOIN Production.ProductSubcategory ON Production.Product.ProductSubcategoryID 
= Production.ProductSubcategory.ProductSubcategoryID INNER JOIN Production.ProductCategory ON Production.ProductSubcategory.ProductSubcategoryID
= Production.ProductCategory.ProductCategoryID
--Exercise 3
SELECT Production.Product.Name AS 'ProductName', Production.Product.ListPrice, 
Production.ProductSubcategory.Name AS 'ProductSubcategory', Production.ProductCategory.Name AS 'ProductCategory',
AVG(Production.Product.ListPrice) OVER(PARTITION BY Production.ProductCategory.ProductCategoryID) AS 'AvgPriceByCategory',
ROW_NUMBER() OVER (ORDER BY Production.Product.ListPrice DESC) AS PriceRank,
RANK() OVER (ORDER BY Production.Product.ListPrice DESC) AS PriceRank,
DENSE_RANK() OVER (PARTITION BY Production.ProductCategory.ProductCategoryID ORDER BY Production.Product.ListPrice DESC) 
AS CategoryPriceRank,
CASE
           WHEN DENSE_RANK() 
		   OVER (PARTITION BY Production.ProductCategory.ProductCategoryID ORDER BY Production.Product.ListPrice DESC) 
		   <= 5 THEN 'Yes'
           ELSE 'No'
       END AS Top5PriceInCategory
FROM Production.Product INNER JOIN Production.ProductSubcategory ON Production.Product.ProductSubcategoryID 
= Production.ProductSubcategory.ProductSubcategoryID INNER JOIN Production.ProductCategory ON Production.ProductSubcategory.ProductSubcategoryID
= Production.ProductCategory.ProductCategoryID

--Exercise 4
SELECT Purchasing.PurchaseOrderHeader.PurchaseOrderID, Purchasing.PurchaseOrderHeader.OrderDate, 
Purchasing.PurchaseOrderHeader.TotalDue, Purchasing.Vendor.Name AS 'VendorName',
LAG(Purchasing.PurchaseOrderHeader.TotalDue) OVER(ORDER BY Purchasing.PurchaseOrderHeader.VendorID)
AS 'PrevOrderFromVendorAmt',
LEAD(Purchasing.Vendor.Name) OVER(ORDER BY Purchasing.PurchaseOrderHeader.EmployeeID) AS 'NextOrderByEmployeeVendor',
LEAD(Purchasing.Vendor.Name,2) OVER(ORDER BY Purchasing.PurchaseOrderHeader.EmployeeID) AS 'Next2OrderByEmployeeVendor'
FROM Purchasing.PurchaseOrderHeader JOIN Purchasing.Vendor ON BusinessEntityID = VendorID
WHERE Purchasing.PurchaseOrderHeader.OrderDate >= '2013-01-01'
AND Purchasing.PurchaseOrderHeader.TotalDue > 500

--Exercise 5
WITH ranked_orders AS (
    SELECT PurchaseOrderID, VendorID, OrderDate, TaxAmt, Freight, TotalDue,
        RANK() OVER (PARTITION BY VendorID ORDER BY TotalDue DESC) AS rank_num
    FROM Purchasing.PurchaseOrderHeader
)
SELECT PurchaseOrderID, VendorID, OrderDate, TaxAmt, Freight, TotalDue
FROM ranked_orders
WHERE rank_num <= 3;

WITH ranked_orders AS (
    SELECT PurchaseOrderID, VendorID, OrderDate, TaxAmt, Freight, TotalDue,
        DENSE_RANK() OVER (PARTITION BY VendorID ORDER BY TotalDue DESC) AS rank_num
    FROM Purchasing.PurchaseOrderHeader
)
SELECT PurchaseOrderID, VendorID, OrderDate, TaxAmt, Freight, TotalDue
FROM ranked_orders
WHERE rank_num <= 3;

--Exercise 6













