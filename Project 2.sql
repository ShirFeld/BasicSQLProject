---Project 2
---1
with cte_base
as (
select year(O.OrderDate) as OrderYear,
		sum(ExtendedPrice - TaxAmount) as IncomePerYear,
		count(distinct month(O.OrderDate)) as NumberOfDistinctMonths,
		cast (sum(ExtendedPrice - TaxAmount) / count(distinct month(O.OrderDate)) * 12 as decimal (12,2)) as YearlyLinearIncome
from Sales.orders O left join Sales.invoices I  on O.OrderID=I.OrderID
	left join Sales.InvoiceLines IL on I.InvoiceID=IL.InvoiceID
group by year(O.OrderDate))

, cte_final
as
(
select OrderYear, IncomePerYear, NumberOfDistinctMonths, YearlyLinearIncome,
	 LAG(YearlyLinearIncome) over (order by OrderYear) as Prev_YearlyLinearIncome
from cte_base)

select OrderYear, IncomePerYear, NumberOfDistinctMonths, YearlyLinearIncome, Prev_YearlyLinearIncome,
cast (((YearlyLinearIncome / Prev_YearlyLinearIncome)-1)* 100 as decimal (3,2))  as GrowthRate
from cte_final

---2
with cte_base
as
(
select Year(O.OrderDate) as TheYear,
	  DATEPART(QUARTER, O.OrderDate) as TheQuarter,
	  C.customerName,
	 sum(UnitPrice*Quantity) as IncomePerQuarter
from Sales.Orders O inner join Sales.OrderLines OL on O.OrderID=OL.OrderID
inner join Sales.Customers C on O.CustomerID=C.CustomerID
group by Year(O.OrderDate), DATEPART(QUARTER,O.OrderDate), C.CustomerName
)
,cte_rank
as
(
select TheYear, TheQuarter, CustomerName, IncomePerQuarter,
	dense_rank() over (partition by TheYear,TheQuarter order by IncomePerQuarter desc) as DNR 
from cte_base	
)
select *
from cte_rank
where DNR <= 5
order by 1,2,4 desc

---3
select top 10 IL.StockItemID, SI.StockItemName, sum(IL.ExtendedPrice-IL.TaxAmount) as TotalProfit
from Sales.InvoiceLines IL inner join Warehouse.StockItems SI on IL.StockItemID=SI.StockItemID
group by IL.StockItemID, SI.StockItemName
order by 3 desc 

---4
with cte
as
(
select StockItemID, StockItemName, UnitPrice, RecommendedRetailPrice, 
	(RecommendedRetailPrice-UnitPrice) as NominalProductProfit
from Warehouse.StockItems
where ValidTo>getdate()
)
select row_number() over (order by NominalProductProfit desc) as RN, *,
	dense_rank() over (order by NominalProductProfit desc) as DNR
from cte

---5
select concat(S.SupplierID, '-' , S.SupplierName) as SupplierDetails,
	  STRING_AGG(cast(SI.stockItemID as varchar(10)) + ' ' + SI.StockItemName, ' / ') as SupplierDetails
from Warehouse.StockItems SI left join Purchasing.Suppliers S on  S.SupplierID=SI.SupplierID
group by S.SupplierID, S.SupplierName
order by S.SupplierID

---6
select top 5 Cu.CustomerID, C.CityName, Co.CountryName, Co.Continent, Co.Region,
	sum(ExtendedPrice) as TotalExtendedPrice
from Sales.Customers Cu left join Sales.Invoices I on Cu.CustomerID=I.CustomerID 
	left join Sales.InvoiceLines IL on I.InvoiceID=IL.InvoiceID
	left join Application.Cities C on Cu.PostalCityID=C.CityID
	left join Application.StateProvinces SP on C.StateProvinceID=SP.StateProvinceID
	left join Application.Countries Co on SP.CountryID=Co.CountryID
group by Cu.CustomerID, C.CityName, Co.CountryName, Co.Continent, Co.Region, ExtendedPrice
order by TotalExtendedPrice desc

---7
with monthlySales
as
(
select year(OrderDate) as OrderYear, month(OrderDate) as OrderMonth, 
		sum(ExtendedPrice-TaxAmount) as MonthlyTotal
from Sales.Invoices I left join Sales.InvoiceLines IL on I.InvoiceID=IL.InvoiceID
		left join Sales.Orders O on I.OrderID=O.OrderID
group by year(OrderDate), month(OrderDate)
)
,cte_1
as
(
select OrderYear, OrderMonth, MonthlyTotal,
	sum(MonthlyTotal) over (partition by OrderYear order by OrderMonth) as MonthlyTotalCumolative
from monthlySales
)
, cte_yearlySales
as
(
select OrderYear, sum(MonthlyTotal) as YearlyTotal 
from monthlySales
group by OrderYear
)
, cte_final
as
(
select OrderYear, OrderMonth, cast(OrderMonth as varchar(10)) as monthName, monthlyTotal,
		MonthlyTotalCumolative from cte_1
UNION ALL
select OrderYear, 13, 'Grand Total',YearlyTotal, YearlyTotal
from cte_yearlySales
)
select OrderYear, monthName, MonthlyTotal, MonthlyTotalCumolative from cte_final
order by OrderYear, OrderMonth

---8
Select OrderMonth,[2013],[2014],[2015],[2016]
from 
	(Select month(OrderDate) as OrderMonth, year(OrderDate) as OrderYear, OrderID
	from Sales.Orders) as org
pivot 
(count(OrderID) for OrderYear in ([2013],[2014],[2015],[2016])) as piv
order by OrderMonth

---9
with cte_base
as
(
select O.CustomerID, CustomerName, O.OrderDate,
lag(O.OrderDate) over (partition by O.CustomerID order by O.OrderDate) PrevOrderDate,
max(O.OrderDate) over (partition by O.CustomerID) as LastOrderDatePerCustomer,
max(O.OrderDate) over () as LastOrderALL
from Sales.Orders O inner join Sales.Customers C on O.CustomerID=C.CustomerID
)
, cte_cust_OrdersAvgDiff
as
(
select CustomerID,
		avg(datediff(day,PrevOrderDate,OrderDate)) as DiffOrderDate
from cte_base
group by CustomerID
)
select a.CustomerID, CustomerName, OrderDate, PrevOrderDate, 
	b.DiffOrderDate,
	datediff(day,LastOrderDatePerCustomer,LastOrderALL) as DiffLastOrderDate,
	case when b.DiffOrderDate * 2 < datediff(day,LastOrderDatePerCustomer,LastOrderALL) then 'churn' else 'active' end
from cte_base a inner join cte_cust_OrdersAvgDiff b on a.CustomerID=b.CustomerID

---10
with cte_base as
(
select
   CustomerID,
   CustomerCategoryID,
    case
     when CustomerName LIKE 'Wingtip%' then 'Wingtip Group'
     when CustomerName LIKE 'Tailspin%' then 'Tailspin Group'
     else CustomerName
     end as GroupedCustomerName
    from Sales.Customers
),cte_counts
as
(
select
   cc.CustomerCategoryName,
   count(distinct a.GroupedCustomerName) as CustomerCOUNT
from cte_base a
    inner join Sales.CustomerCategories cc on a.CustomerCategoryID = cc.CustomerCategoryID
group by cc.CustomerCategoryName
),cte_total
as
(
select count(distinct GroupedCustomerName) as TotalCustCount
from cte_base
)
select
    c.CustomerCategoryName,
    c.CustomerCOUNT,
    t.TotalCustCount,
    cast(round(cast(c.CustomerCOUNT as float) / t.TotalCustCount * 100, 2) as varchar) + '%' as DistributionFactor
from cte_counts c
inner join cte_total t on t.TotalCustCount is not null
order by c.CustomerCOUNT desc