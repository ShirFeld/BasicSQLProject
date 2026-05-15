--1
select top 5
    Product.name as ProductName,
    SUM(SalesOrderDetail.LineTotal) as TotalSalesAmount
from dbo.SalesOrderDetail 
join dbo.Product 
    on SalesOrderDetail.ProductID = Product.ProductID
group BY Product.name
order BY TotalSalesAmount desc;

--2
select 
    ProductCategory.name as CategoryName,
    ProductSubcategory.name as SubCategoryName,
    AVG(SalesOrderDetail.UnitPrice) as AvgUnitPrice
from dbo.SalesOrderDetail
join dbo.Product
    on SalesOrderDetail.ProductID = Product.ProductID
join ProductSubcategory
    on Product.ProductSubcategoryID = ProductSubcategory.ProductSubcategoryID
join ProductCategory
    on ProductSubcategory.ProductCategoryID = ProductCategory.ProductCategoryID
where ProductCategory.name in ('Bikes', 'Components')
group BY ProductCategory.name, ProductSubcategory.name
order BY ProductCategory.name, ProductSubcategory.name;


--3
select Product.name as [Product Name],
       SUM(SalesOrderDetail.OrderQty) as [Total Order Qty]
from dbo.Product
join dbo.SalesOrderDetail
    on SalesOrderDetail.ProductID = Product.ProductID
join ProductSubcategory
    on Product.ProductSubcategoryID = ProductSubcategory.ProductSubcategoryID
join ProductCategory
    on ProductSubcategory.ProductCategoryID = ProductCategory.ProductCategoryID
where ProductCategory.name not in ('Components', 'Clothing')
group BY Product.name
order BY [Total Order Qty] desc;
 
 --4
 select top 3
 SalesTerritory.name as [Territory name],
 sum([SalesOrderHeader].[TotalDue]) as  [TotalDue]
 from dbo.[SalesTerritory]
 join dbo.[SalesOrderHeader] 
    on [SalesOrderHeader].TerritoryID = [SalesTerritory].[TerritoryID]
 group by  SalesTerritory.name


 --5
 select 
    [Customer].[CustomerID] as [Customer ID],
    [Person].FirstName + ' ' + [Person].LastName as [Full name]
 from dbo.[Customer]
 join dbo.[Person]
     on Customer.PersonID = Person.[BusinessEntityID]
 left join dbo.SalesOrderHeader
    on Customer.CustomerID = SalesOrderHeader.CustomerID
where SalesOrderHeader.SalesOrderID is null
order by [Customer ID] asc

--6
delete from dbo.SalesTerritory
where TerritoryID not in (
    select TerritoryID
    from dbo.SalesPerson
    where TerritoryID is not null
);


--7
--לא נמחקו לי שורות כלל

--8
 select 
    Person.FirstName + ' ' + Person.LastName as FullName,
    Customer.CustomerID,
    count(SalesOrderHeader.SalesOrderID) as NumberOfOrders
 from dbo.[Person]
 join dbo.Customer
    on Customer.PersonID = Person.BusinessEntityID
 join dbo.SalesOrderHeader
    on SalesOrderHeader.CustomerID = Customer.CustomerID
group by Person.FirstName, Person.LastName, Customer.CustomerID
having count(SalesOrderHeader.SalesOrderID) > 20
order by NumberOfOrders asc

--9
select 
    GroupName, 
    count(*) as DepartmentCount
from dbo.Department
group by GroupName
having count(*) > 2;

--10
select 
    person.firstname + ' ' + person.lastname as fullname,
    department.name as departmentname,
    shift.name as shiftname
from dbo.employee
join dbo.employeedepartmenthistory
    on dbo.employee.businessentityid = dbo.employeedepartmenthistory.businessentityid
join dbo.department
    on employeedepartmenthistory.departmentid = dbo.department.departmentid
join dbo.shift
    on employeedepartmenthistory.shiftid = shift.shiftid
join dbo.person
    on employee.businessentityid = person.businessentityid
where employee.hiredate > '2010-01-01'
  and department.groupname in ('Quality Assurance', 'Manufacturing')
order by fullname;
