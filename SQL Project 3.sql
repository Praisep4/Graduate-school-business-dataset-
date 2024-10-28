	Data Retrieval and Filtering: 
--	Writing a query to retrieve all orders shipped to the state of "California" that used "Second Class" shipping mode. Include `Order ID`, `Customer Name`, `Sales`, and `Profit`.
SELECT-- OrderID, CustomerName, Sales, Profit
FROM Orders
WHERE ShipState = 'California' 
AND ShippingMode = 'Second Class';

-- Finding all orders placed between "2013-01-01" and "2013-12-31" where the `Category` is "Furniture" and the `Profit` is greater than 100. Display the `Order ID`, `Order Date`, `Product Name`, and `Profit`. 
SELECT OrderID, OrderDate, ProductName, Profit
FROM Orders
WHERE OrderDate BETWEEN '2013-01-01' AND '2013-12-31' 
AND Category = 'Furniture' 
AND Profit > 100;

--	Write a query to list all unique `Ship Modes` and the number of orders shipped through each mode, sorted in descending order of order count. 
 SELECT ShipMode, COUNT(OrderID) AS OrderCount
FROM Orders
GROUP BY ShipMode
ORDER BY OrderCount DESC;

--	Aggregations and Grouping: 
--	Calculate the total `Sales` and `Profit` for each `Category` and `Sub-Category`. Display the results in descending order of total `Sales`. 
SELECT Category, SubCategory, 
SUM(Sales) AS TotalSales, 
SUM(Profit) AS TotalProfit
FROM Orders
GROUP BY Category, SubCategory
ORDER BY TotalSales DESC;

--	Find the top 3 customers in terms of total `Sales` in each `Region`. Display `Customer Name`, `Region`, and `Total Sales`. 
WITH RankedCustomers AS (
    SELECT CustomerName, Region, 
	SUM(Sales) AS TotalSales,
	ROW_NUMBER() OVER (PARTITION BY Region ORDER BY SUM(Sales) DESC) AS SalesRank
    FROM Orders
    GROUP BY CustomerName, Region
)
SELECT CustomerName, Region, TotalSales
FROM RankedCustomers
WHERE SalesRank <= 3
ORDER BY Region, TotalSales DESC;

--	Writing a query to determine which `City` has the highest average `Profit` per order, and display the top 5 cities with the highest average. 
 SELECT City, 
AVG(Profit) AS AverageProfit
FROM Orders
GROUP BY City
ORDER BY AverageProfit DESC
LIMIT 5;

--	Joins and Subqueries: 
--	Write a query to find the `Product Name` and `Category` of the most frequently ordered product (the one with the highest total `Quantity`). 
SELECT ProductName, Category, 
SUM(Quantity) AS TotalQuantity
FROM Orders
GROUP BY ProductName, Category
ORDER BY TotalQuantity DESC
LIMIT 1;

--	Use a subquery to find all orders where the `Sales` amount is greater than the average `Sales` for that specific `Category`. 
SELECT *
FROM Orders o
WHERE Sales > (
SELECT AVG(Sales)
FROM Orders
WHERE Category = o.Category
);

--	Write a query to find customers who have placed orders in both the "Corporate" and "Consumer" segments. Display their `Customer ID` and `Customer Name`. 
SELECT CustomerID, CustomerName
FROM Orders
WHERE Segment IN ('Corporate', 'Consumer')
GROUP BY CustomerID, CustomerName
HAVING COUNT(DISTINCT Segment) = 2;

--	Data Updates: 
--	Update the `Ship Mode` of all orders shipped in "Kentucky" with a `Discount` of 0 to "Standard Class". 
UPDATE Orders
SET ShipMode = 'Standard Class'
WHERE ShipState = 'Kentucky' 
AND Discount = 0;

--	Write a query to adjust the `Discount` to 0.3 for all products in the "Office Supplies" category that have a `Profit` less than zero. 
UPDATE Orders
SET Discount = 0.3
WHERE Category = 'Office Supplies' 
AND Profit < 0;

--	Write a query to increase the `Quantity` by 1 for all orders that have `Sales` greater than 500 but have a `Quantity` of 2 or less. 
UPDATE Orders
SET Quantity = Quantity + 1
WHERE Sales > 500 
AND Quantity <= 2;

--	Complex Conditions: 
--	Finding orders where the `Profit` is negative, but the `Sales` amount is above the average `Sales` of all orders. Display `Order ID`, `Customer Name`, `Sales`, and `Profit`
SELECT OrderID, CustomerName, Sales, Profit
FROM Orders
WHERE Profit < 0 
AND Sales > (SELECT AVG(Sales) FROM Orders);

--	Writing a query to calculate the `Profit` margin (as `Profit/Sales`) for each `Product ID` and find the top 5 products with the highest profit margin
 SELECT ProductID, (Profit / Sales) AS ProfitMargin
FROM Orders
WHERE Sales > 0  
ORDER BY ProfitMargin DESC
LIMIT 5;

--	Writing a query to find all `Order IDs` where the `Ship Date` is more than 5 days after the `Order Date`. Display `Order ID`, `Order Date`, `Ship Date`, and the `days difference`
SELECT OrderID, OrderDate, ShipDate, 
DATEDIFF(ShipDate, OrderDate) AS DaysDifference
FROM Orders
WHERE DATEDIFF(ShipDate, OrderDate) > 5;

 
--	Bonus Challenge: 
--	Writing a query to find the total `Sales` and `Profit` contribution for each `Segment` by year. Display the results with `Year`, `Segment`, `Total Sales`, and `Total Profit`
SELECT 
YEAR(OrderDate) AS Year, Segment, 
SUM(Sales) AS TotalSales, 
SUM(Profit) AS TotalProfit
FROM Orders
GROUP BY YEAR(OrderDate), Segment
ORDER BY Year, Segment;

--	Identifying the `Sub-Category` with the most orders where `Discount` was applied. Display the `SubCategory`, the total number of such orders, and the average `Discount` given in those cases
SELECT SubCategory, 
COUNT(OrderID) AS TotalOrders, 
AVG(Discount) AS AverageDiscount
FROM Orders
WHERE Discount > 0
GROUP BY SubCategory
ORDER BY TotalOrders DESC
LIMIT 1;

