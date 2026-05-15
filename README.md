# Sales & Business Analytics SQL Project

## Overview
This project demonstrates advanced SQL querying and data analysis skills using Microsoft SQL Server databases such as AdventureWorks and WideWorldImporters.

The project includes:
- Database creation scripts
- Complex business analysis queries
- Sales analytics
- Customer and product insights
- Window functions and Common Table Expressions (CTEs)
- Ranking and aggregation techniques

The goal of the project was to practice real-world SQL scenarios commonly used by Data Analysts, BI Analysts, and Database Developers.

---

## Technologies Used

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- T-SQL
- AdventureWorks Database
- WideWorldImporters Database

---

## Project Structure

### `ShirFeldmanProject.sql`
Contains the database creation and configuration scripts.

Main topics:
- Database setup
- Database properties configuration
- SQL Server environment preparation

---

### `ShirFeldmanQuries.sql`
Contains analytical business queries focused on:
- Product sales analysis
- Customer activity analysis
- Department statistics
- Employee and territory reporting
- JOIN operations
- Aggregations and filtering
- Data cleanup operations

Example insights:
- Top-selling products
- Average product prices by category
- Customers without orders
- Employees by department and shift
- Territories with highest sales revenue

---

### `Project 2.sql`
Contains advanced SQL analytics using:
- CTEs
- Window Functions
- Ranking Functions
- Year-over-year growth analysis
- Quarterly customer rankings
- Running totals
- Profitability calculations
- STRING aggregation

Main SQL concepts used:
- `ROW_NUMBER()`
- `DENSE_RANK()`
- `LAG()`
- `STRING_AGG()`
- `OVER(PARTITION BY ...)`
- Recursive and layered CTEs

Example analyses:
- Annual revenue growth
- Top customers per quarter
- Most profitable products
- Supplier-product aggregation
- Monthly cumulative sales reports

---

## Key SQL Skills Demonstrated

- Complex `JOIN` operations
- Aggregations with `GROUP BY`
- Filtering with `HAVING`
- Window functions
- Ranking functions
- CTE usage
- Sales and profitability analysis
- Business intelligence reporting
- Data transformation
- Analytical SQL thinking

---

## Example Queries Included

### Top 5 Products by Sales
```sql
SELECT TOP 5
    Product.Name AS ProductName,
    SUM(SalesOrderDetail.LineTotal) AS TotalSalesAmount
FROM dbo.SalesOrderDetail
JOIN dbo.Product
    ON SalesOrderDetail.ProductID = Product.ProductID
GROUP BY Product.Name
ORDER BY TotalSalesAmount DESC;
```

### Year-over-Year Revenue Growth
```sql
LAG(YearlyLinearIncome)
OVER (ORDER BY OrderYear)
```

### Customer Ranking by Quarterly Revenue
```sql
DENSE_RANK() OVER (
    PARTITION BY TheYear, TheQuarter
    ORDER BY IncomePerQuarter DESC
)
```

---

## Learning Outcomes

Through this project, I strengthened my ability to:
- Write optimized analytical SQL queries
- Work with large relational databases
- Generate business insights from raw data
- Use advanced SQL Server analytical functions
- Structure scalable and readable SQL code

---

## Author

Shir Feldman  
Management Information Systems Student  
QA Automation Engineer & Data Enthusiast
