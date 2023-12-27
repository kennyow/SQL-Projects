-- USING DATASET ADVENTUREWORKS2017
use AdventureWorks2017;

-- There's a table called 'Person.Person'. Let's see all the data from it:
SELECT * FROM Person.Person;

-- We will use a lot the 'Production.Product' table:
SELECT * FROM Production.Product

-- Looking just for the title:
SELECT Title FROM Person.Person;

-- 1- A marketing team needs to conduct a survey with the most common first and last names of their customers registered in the system
SELECT FirstName, LastName FROM Person.Person;

-- Using DISTINCT (Remove duplicated names):
SELECT DISTINCT FirstName FROM Person.Person;

-- 2- How many unique last names are there in the 'Person.Person' table?
SELECT DISTINCT LastName FROM Person.Person;

-- Using WHERE + AND
SELECT * FROM Person.Person
WHERE LastName = 'miller' AND FirstName = 'anna';

-- Using WHERE + OR
SELECT * FROM Production.Product
WHERE color = 'red' OR color = 'blue';

-- Using WHERE + >, <, <>
SELECT * FROM Production.Product
WHERE ListPrice > 1500 AND ListPrice < 5000;

SELECT * FROM Production.Product
WHERE color <> 'red'

-- 3- The product production team needs the names of all parts that weigh more than 500Kg but no more than 700Kg for inspection.
SELECT * FROM Production.Product
WHERE Weight > 500 AND Weight < 700;

-- 4- The company's marketing team requested a list of all employees who are married and also salaried.
SELECT * FROM HumanResources.Employee
WHERE MaritalStatus = 'M' AND SalariedFlag = 1;

-- 5- A user named Peter Krebs owes a payment. Obtain his email so that we can send a collection notice.
SELECT * FROM Person.Person
WHERE LastName = 'kREBS' AND FirstName = 'PETER';
--BusinessEntityID found!
SELECT * FROM Person.EmailAddress
WHERE BusinessEntityID = 26;

-- Using COUNT WITH DISTINCT
SELECT COUNT(DISTINCT tITLE) 
FROM Person.Person;

-- 6- How many products are registered in the product table?
SELECT * FROM Production.Product;
SELECT COUNT(DISTINCT Name) 
FROM Production.Product;

-- 7- How many different product sizes are registered in the table?
SELECT COUNT(DISTINCT Size) 
FROM Production.Product;

-- Using TOP
SELECT TOP 10 *
FROM Person.Address;

-- Using ORDER BY
SELECT * FROM Person.Person
ORDER BY FirstName ASC;

SELECT * FROM Person.Person
ORDER BY LastName DESC;

SELECT FirstName, LastName
FROM Person.Person
ORDER BY FirstName ASC, LastName DESC;

-- 8- Retrieve the ProductId of the top 10 most expensive products registered in the system, listed from the most expensive to the least expensive.
SELECT *
FROM Production.Product;

SELECT TOP 10 ProductID, Name, ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;

-- 9- Retrieve the name and product number of the products that have a ProductID between 1 and 4.
SELECT TOP 4 Name, ProductNumber
FROM Production.Product
ORDER BY ProductID ASC;

-- Using BETWEEN (NOT)
SELECT Name, ListPrice
FROM Production.Product
WHERE ListPrice BETWEEN 1200 AND 1500;

SELECT Name, ListPrice
FROM Production.Product
WHERE ListPrice NOT BETWEEN 1200 AND 1500
ORDER BY ListPrice DESC;

SELECT JobTitle, HireDate, VacationHours
FROM HumanResources.Employee
WHERE HireDate BETWEEN '2009/01/01' AND '2010/12/31'
ORDER BY HireDate DESC;

-- Using IN (NOT)
SELECT *
FROM Person.Person
WHERE BusinessEntityID IN (2,7,14);

SELECT *
FROM Person.Person
WHERE BusinessEntityID NOT IN (6,7,10);

-- Using Like
SELECT *
FROM Person.Person
WHERE FirstName LIKE 'ovi%';

SELECT *
FROM Person.Person
WHERE FirstName LIKE '%to';

SELECT DISTINCT FirstName
FROM Person.Person
WHERE FirstName LIKE '%ria';

SELECT FirstName
FROM Person.Person
WHERE FirstName LIKE '%ry_';

-- 10- How many products do we have registered in the system that cost more than 1500 dollars?
SELECT COUNT(ListPrice) FROM Production.Product
WHERE ListPrice > 1500;


-- 11- How many people do we have with a last name that starts with the letter P?
SELECT COUNT(LastName) FROM Person.Person
WHERE LastName LIKE 'P%';

-- 12- In how many unique cities are our customers registered?
SELECT * FROM Person.Address;

SELECT COUNT(DISTINCT City)
FROM Person.Address;

-- 13- And what are they?

SELECT DISTINCT City
FROM Person.Address;

-- 14- How many red products are priced between 500 and 1000 dollars?
SELECT * FROM Production.Product;

SELECT COUNT(Name) FROM Production.Product
WHERE Color = 'red' AND ListPrice BETWEEN 500 AND 1000; 

-- 15- How many registered products have the word 'road' in their name?
SELECT COUNT(*) FROM Production.Product
WHERE Name LIKE '%road%';

-- Using SUM
SELECT * FROM Sales.SalesOrderDetail;

SELECT TOP 10 sum(LineTotal) AS "SUM"
FROM Sales.SalesOrderDetail;

-- Using MIN
SELECT TOP 10 MIN(LineTotal) AS "MINIMUM"
FROM Sales.SalesOrderDetail;

-- Using MAX
SELECT TOP 10 MAX(LineTotal) AS "MAXIMUM"
FROM Sales.SalesOrderDetail;

-- Using AVG
SELECT TOP 10 AVG(LineTotal) AS "AVERAGE"
FROM Sales.SalesOrderDetail;

-- Using GROUP BY
SELECT * FROM Sales.SalesOrderDetail;

SELECT SpecialOfferID, SUM(UnitPrice) AS 'SOMA'
FROM sALES.SalesOrderDetail
GROUP BY SpecialOfferID
ORDER BY SpecialOfferID ASC;

-- 16- The company wants to know how much of each product has been sold until today.
SELECT * FROM Sales.SalesOrderDetail;

SELECT DISTINCT ProductID, SUM(ProductID) AS 'COUNT'
FROM Sales.SalesOrderDetail
GROUP BY ProductID;

-- 17- The company wants to know how many distinct names are registered in the database.
SELECT FirstName, COUNT(FirstName)
FROM Person.Person
GROUP BY FirstName;

--18 - The company wants to know the average price for silver products.
SELECT * FROM Production.Product;

SELECT Color, AVG(ListPrice) AS 'MEDIA'
FROM Production.Product
WHERE Color = 'SILVER'
GROUP BY Color;

-- 19- The company wants to know how many people have the same middle name.
SELECT DISTINCT MiddleName, COUNT(MiddleName) AS 'COUNT'
FROM Person.Person
GROUP BY MiddleName
ORDER BY 'COUNT' DESC;

-- 20- The company urgently needs to know on average the quantity of each product sold in the store.
SELECT * FROM Sales.SalesOrderDetail

SELECT ProductID, AVG(OrderQty) AS 'MEDIA'
FROM Sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY 'MEDIA' DESC;

-- 21- My boss wants to know the top 10 sales that, in total, had the highest values per product, from highest to lowest.
SELECT TOP 10 ProductID, SUM(LineTotal) AS 'SOMA'
FROM Sales.SalesOrderDetail
GROUP BY ProductID
ORDER BY 'SOMA' DESC;

-- 22- I received a phone call from a colleague at work wanting to know how many products and the average quantity of these products are registered in the work order.
SELECT * FROM Production.WorkOrder;

SELECT ProductID, COUNT(ProductID) AS 'CONTAGEM', AVG(OrderQty) AS 'MEDIA'
FROM Production.WorkOrder
GROUP BY ProductID;

-- Using HAVING

-- 23- My boss wants to know which names in the system have an occurrence greater than 10 times
SELECT FirstName, COUNT(FirstName) AS 'QUANTIDADE'
FROM Person.Person
GROUP BY FirstName
HAVING COUNT(FirstName) > 10;

-- 24- New request: What are the products whose total sales are between 162k and 500k?
SELECT ProductID, SUM(LineTotal) AS 'SOMASE'
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING SUM(LineTotal) BETWEEN 162000 AND 500000;


-- 25- What names in the system have an occurrence greater than 10 times, but only when the title is 'Mr.'?
SELECT FirstName, COUNT(FirstName) AS 'QTDE'
FROM Person.Person
WHERE Title LIKE 'Mr.%'
GROUP BY FirstName
HAVING COUNT(FirstName) > 10;

-- 26- We are looking to identify the provinces (stateprovinceID) with the highest number of registrations in our system, which is in a quantity greater than 1000.
SELECT * FROM Person.Address

SELECT StateProvinceID, COUNT(StateProvinceID) AS 'QTDE'
FROM Person.Address
GROUP BY StateProvinceID
HAVING COUNT(StateProvinceID) > 1000
ORDER BY COUNT(StateProvinceID) DESC

-- 27- As it is a multinational, the managers want to know which products (productID) are not averaging at least 1 million in total sales (lineTotal).
SELECT * FROM Sales.SalesOrderDetail

SELECT ProductID, AVG(LineTotal) as 'MEDIA'
FROM Sales.SalesOrderDetail
GROUP BY ProductID
HAVING AVG(LineTotal) < 1000
ORDER BY 'MEDIA' DESC;


-- Using AS
SELECT TOP 10 ProductNumber AS 'CODE' 
FROM Production.Product;

-- Rename 'FirstName' and 'LastName' columns from Person.Person
SELECT FirstName AS 'Name1', LastName AS 'Name2'
FROM Person.Person;

--Using INNER JOIN
SELECT TOP 10 *
FROM Person.Person

SELECT TOP 10 *
FROM Person.EmailAddress

SELECT p.FirstName, p.LastName, e.EmailAddress
FROM Person.Person AS p
INNER JOIN Person.EmailAddress AS e
ON p.BusinessEntityID = e.BusinessEntityID;

SELECT p.FirstName, p.LastName, e.EmailAddress
FROM  Person.EmailAddress AS e
INNER JOIN Person.Person AS p
ON p.BusinessEntityID = e.BusinessEntityID;

-- 28- We want the names of the products and information about their subcategories by no later than noon.
SELECT TOP 10 * 
FROM Production.Product;

SELECT TOP 10 *
FROM Production.ProductSubcategory;

SELECT pr.ListPrice, pr.Name AS 'NOME',  s.Name
FROM Production.Product AS pr
INNER JOIN Production.ProductSubcategory AS s
ON pr.ProductSubcategoryID = s.ProductSubcategoryID

-- Join all columns
SELECT TOP 10 *
FROM Person.BusinessEntityAddress BA
INNER JOIN Person.Address AS PA
ON PA.AddressID = BA.AddressID

-- Example: Join BusinessEntityId, Name, PhoneNumberTypeId, PhoneNumber
SELECT TOP 10 * 
FROM Person.PhoneNumberType;

SELECT TOP 10 *
FROM Person.PersonPhone;

SELECT pp.BusinessEntityID, nt.Name, pp.PhoneNumberTypeID, pp.PhoneNumber
FROM Person.PhoneNumberType AS NT
INNER JOIN Person.PersonPhone AS PP
ON NT.PhoneNumberTypeID = PP.PhoneNumberTypeID

-- Example: TOP 10 from AddressId, City, StateProvinceID, Nome do Estado
SELECT TOP 10 * 
FROM Person.StateProvince;

SELECT TOP 10 *
FROM Person.Address;

SELECT TOP 10 PA.AddressID, PA.City, PA.StateProvinceID, SP.Name
FROM Person.StateProvince AS SP
INNER JOIN Person.Address AS PA
ON SP.StateProvinceID = PA.StateProvinceID

-- Using LEFT OUTER JOIN = LEFT JOIN

-- 29- Which people have a registered credit card?
SELECT *
FROM Person.Person PP
INNER JOIN Sales.PersonCreditCard PC
ON PP.BusinessEntityID = PC.BusinessEntityID;
-- INNER JOIN SHOWS 19.118 ROWS

SELECT *
FROM Person.Person PP
LEFT JOIN Sales.PersonCreditCard PC
ON PP.BusinessEntityID = PC.BusinessEntityID
WHERE PC.BusinessEntityID IS NULL;

-- LEFT JOIN SHOWS 19.972 ROWS

SELECT 19972 - 19118;

-- Using UNION
SELECT ProductID, Name, ProductNumber
FROM Production.Product
WHERE Name LIKE '%Chain%'
UNION
SELECT ProductID, Name, ProductNumber
FROM Production.Product
WHERE Name LIKE '%Decal%'

SELECT FirstName, Title, MiddleName
from Person.Person
WHERE Title = 'Mr.'
UNION
SELECT FirstName, Title, MiddleName
FROM Person.Person
WHERE MiddleName = 'A'


-- Using SUBQUERY

SELECT * 
FROM Production.Product
WHERE ListPrice > (SELECT AVG(ListPrice) FROM Production.Product)

-- 30- I want the names of my employees who have the position of 'Design Engineer'.
SELECT *
FROM Person.Person

SELECT * 
FROM HumanResources.Employee
WHERE JobTitle = 'Design Engineer'

SELECT FirstName
FROM Person.Person
WHERE BusinessEntityID IN (
SELECT BusinessEntityID
FROM HumanResources.Employee
WHERE JobTitle = 'Design Engineer')

-- 31- I need all the addresses from Alberta

SELECT *
FROM Person.Address 
WHERE StateProvinceID IN(
SELECT StateProvinceID
FROM Person.StateProvince
WHERE name = 'Alberta')

-- Using DATEPART -- month, year, day

SELECT SalesOrderID, DATEPART(month, OrderDate) AS 'Month'
FROM Sales.SalesOrderHeader;

SELECT AVG(TotalDue) AS 'MD', DATEPART(month, OrderDate) AS 'Month'
FROM Sales.SalesOrderHeader
GROUP BY DATEPART(month, OrderDate)
ORDER BY 'Month';

-- Using STRING
--CONCAT -  Giving space
SELECT CONCAT(FirstName,' ', LastName)
FROM Person.Person

-- UPPER / LOWER
SELECT UPPER(FirstName), LOWER(LastName)
FROM Person.Person

--LEN
SELECT UPPER(FirstName), LEN(FirstName)
FROM Person.Person

-- SUBSTRING - From the original string, where it starts and how much do you want from it
SELECT UPPER(FirstName), SUBSTRING(FirstName, 1, 3)
FROM Person.Person

-- REPLACE - original string, what do you want to change, for the new piece.
SELECT productNumber, REPLACE(ProductNumber, '-', '#')
FROM Production.Product

-- Using Math Operations +/ -/ / / *
SELECT UnitPrice / LineTotal
FROM Sales.SalesOrderDetail

SELECT ROUND(LineTotal, 3)
FROM Sales.SalesOrderDetail

SELECT SQRT(LineTotal)
FROM Sales.SalesOrderDetail

-- Using VIEW

CREATE VIEW [Pessoas Simplificado] AS
SELECT FirstName, MiddleName, LastName
FROM Person.Person
WHERE Title = 'Ms.'

SELECT * FROM [Pessoas Simplificado];