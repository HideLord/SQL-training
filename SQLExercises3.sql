SELECT FirstName, LastName FROM Employees WHERE LEFT(FirstName,2) = 'SA'

SELECT FirstName, LastName FROM Employees WHERE (CHARINDEX('ei',LastName) > 0)

SELECT FirstName FROM Employees WHERE DepartmentID in (3,10) AND (YEAR(HireDate) BETWEEN 1995 AND 2005)

SELECT FirstName, LastName FROM Employees WHERE (CHARINDEX('engineer',JobTitle) <= 0)

SELECT Name FROM Towns WHERE LEN(Name) in (5,6) ORDER BY Name

SELECT * FROM Towns WHERE LEFT(Name,1) IN ('M','K','B','E') ORDER BY Name

SELECT * FROM Towns WHERE LEFT(Name,1) NOT IN ('R','B','D') ORDER BY Name

CREATE VIEW V_EmployeesHiredAfter2000 AS
	SELECT FirstName, LastName FROM Employees WHERE YEAR(HireDate) >= 2001

SELECT FirstName, LastName FROM Employees WHERE LEN(LastName) = 5



SELECT EmployeeID,
	FirstName,
	LastName,
	Salary,
	DENSE_RANK () OVER ( 
	PARTITION BY Salary
	ORDER BY EmployeeID
	) AS price_rank 
	FROM
	Employees
	WHERE Salary BETWEEN 10000 AND 50000
	ORDER BY Salary DESC


SELECT * 
	FROM (
	SELECT EmployeeID,
		FirstName,
		LastName,
		Salary,
		DENSE_RANK () OVER ( 
		PARTITION BY Salary
		ORDER BY EmployeeID
		) AS price_rank 
		FROM
		Employees
		WHERE Salary BETWEEN 10000 AND 50000
	) t
	WHERE price_rank = 2
	ORDER BY Salary DESC

USE Geography

SELECT CountryName, IsoCode FROM Countries WHERE (LEN(CountryName) - LEN(REPLACE(CountryName,'a',''))) >= 3 ORDER BY IsoCode

Select *, LOWER([PeakName] + SUBSTRING(RiverName,2,LEN(RiverName)-1)) AS Mix FROM(
	(SELECT PeakName FROM Peaks) a
	JOIN
	(SELECT RiverName From Rivers) b

	ON RIGHT(a.PeakName,1) = LEFT(b.RiverName,1)
) ORDER BY Mix

USE Diablo

SELECT Username, SUBSTRING(Email,CHARINDEX('@',Email)+1,LEN(Email)-CHARINDEX('@',Email)) AS [Email Provider] FROM Users ORDER BY [Email Provider], Username

SELECT TOP(50) Name, FORMAT([Start],'yyyy-MM-dd') AS [Start] FROM Games WHERE YEAR([Start]) in (2011,2012) ORDER BY [Start], [Name]
	
SELECT Username, IpAddress FROM Users WHERE IpAddress LIKE '___.1%.%.___' ORDER BY Username

SELECT * FROM Games

SELECT [Name],
	CASE
		WHEN(CAST(Start as time) < CAST('12:00:00' as time)) THEN 'Morning'
		WHEN(CAST(Start as time) < CAST('18:00:00' as time)) THEN 'Afternoon'
		ELSE 'Evening'
		END AS [Part of the Day],
	CASE 
		WHEN Duration IS NULL THEN 'Extra Long'
		WHEN Duration <= 3 THEN 'Extra Short'
		WHEN Duration <= 6 THEN 'Short'
		WHEN Duration > 6 THEN 'Long'
	END AS Duration
	FROM Games
	ORDER BY Name, Duration

USE Orders

SELECT ProductName, 
	CAST(OrderDate as datetime) AS OrderDate,
	DATEADD(DAY,3,OrderDate) AS [Pay Due],
	DATEADD(MONTH,1,OrderDate) AS [Deliver Due]
	FROM Orders