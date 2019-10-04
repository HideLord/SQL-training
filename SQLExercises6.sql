USE SoftUni

--1
SELECT TOP 5 e.EmployeeID, e.JobTitle, e.AddressID, a.AddressText
FROM Employees as e, Addresses as a
WHERE e.AddressID = a.AddressID
ORDER BY e.AddressID Asc

--2
SELECT TOP 50 e.FirstName, e.LastName, t.[Name] as Town, a.AddressText 
FROM Employees as e, Towns as t, Addresses as a
WHERE e.AddressID = a.AddressID AND a.TownID = t.TownID
ORDER BY e.FirstName asc, e.LastName

--3
SELECT e.EmployeeID, e.FirstName, e.LastName, d.[Name] FROM Employees as e, Departments as d
WHERE e.DepartmentID = d.DepartmentID AND d.Name = 'Sales'
ORDER BY e.EmployeeID asc

--4
SELECT TOP 5 e.EmployeeID, e.FirstName, e.Salary, d.[Name] FROM Employees as e, Departments as d
WHERE e.DepartmentID = d.DepartmentID AND e.Salary >= 15000
ORDER BY d.DepartmentID asc

--5
SELECT TOP 3 e.EmployeeID, e.FirstName 
FROM  Employees as e
LEFT OUTER JOIN
EmployeesProjects as ep
ON
ep.EmployeeID = e.EmployeeID
WHERE ep.ProjectID IS NULL
ORDER BY EmployeeID

--6
SELECT e.FirstName, e.LastName, e.HireDate, d.[Name] FROM Employees as e
JOIN
Departments as d
ON d.DepartmentID = e.DepartmentID
WHERE d.Name in ('Sales', 'Finance') AND e.HireDate > CAST('1.1.1999' as DATE)
ORDER BY e.HireDate ASC

--7
SELECT TOP 5 e.EmployeeID, e.FirstName, p.[Name] AS ProjectName FROM Employees as e
JOIN
EmployeesProjects as ep
ON e.EmployeeID = ep.EmployeeID
JOIN
Projects as p
ON p.ProjectID = ep.ProjectID
WHERE p.StartDate > CAST('08.13.2002' as Date) AND p.EndDate IS NULL
ORDER BY e.EmployeeID ASC

--8
SELECT e.EmployeeID, e.FirstName, 
CASE
WHEN YEAR(p.StartDate) >= 2005 THEN NULL
ELSE p.[Name]
END AS ProjectName FROM Employees as e
JOIN
EmployeesProjects as ep
ON e.EmployeeID = ep.EmployeeID
JOIN
Projects as p
ON p.ProjectID = ep.ProjectID
WHERE e.EmployeeID = 24
ORDER BY e.EmployeeID ASC

--9
SELECT e.EmployeeID, e.FirstName, e.ManagerID, e2.FirstName AS ManagerName FROM Employees as e
JOIN
Employees as e2
ON e.ManagerID = e2.EmployeeID
WHERE e.ManagerID in (3,7)
ORDER BY e.EmployeeID ASC

--10
SELECT TOP 50 e.EmployeeID, e.FirstName + ' ' + e.LastName as [EmployeeName],
e2.FirstName + ' ' + e2.LastName as [ManagerName],
d.[Name] AS DepartmentName FROM Employees as e
JOIN
Employees as e2
ON e.ManagerID = e2.EmployeeID
JOIN Departments as d
ON d.DepartmentID = e.DepartmentID
ORDER BY e.EmployeeID

--11
SELECT MIN(S.Sal) FROM
(
	SELECT DepartmentID, AVG(Salary) as Sal FROM Employees
	GROUP BY DepartmentID
) as S

USE Geography
--12
SELECT c.CountryCode, m.MountainRange, p.PeakName, p.Elevation FROM Countries as c
JOIN MountainsCountries as mc
ON mc.CountryCode = c.CountryCode
JOIN Mountains as m
ON m.Id = mc.MountainId
JOIN Peaks as p
ON p.MountainId = mc.MountainId
WHERE c.CountryCode = 'BG' AND p.Elevation > 2835
ORDER BY Elevation DESC

--13
SELECT J.CountryCode, J.MountainRanges FROM (
	SELECT c.CountryCode, COUNT(*) as MountainRanges
	FROM Countries as c
	JOIN MountainsCountries as mc
	ON mc.CountryCode = c.CountryCode
	GROUP BY c.CountryCode
) as J
JOIN Countries as ctr
ON ctr.CountryCode = J.CountryCode
WHERE ctr.CountryName in ('United States','Bulgaria','Russia')

--14
SELECT DISTINCT TOP 5 c.CountryName, r.RiverName FROM Countries as c
LEFT JOIN CountriesRivers as cr
ON cr.CountryCode = c.CountryCode
LEFT JOIN Rivers as r
ON r.Id = cr.RiverId
WHERE c.ContinentCode = 'AF'
ORDER BY c.CountryName

--15
SELECT ranked.ContinentCode, ranked.CurrencyCode, ranked.CurrencyUsage FROM 
(
	SELECT ContinentCode, CurrencyCode, COUNT(*) as CurrencyUsage,
	Dense_rank() OVER (Partition by ContinentCode ORDER BY COUNT(*) Desc) as [Rank]
	FROM Countries
	GROUP BY ContinentCode, CurrencyCode 
) AS ranked
WHERE ranked.[Rank] = 1 AND ranked.CurrencyUsage > 1
ORDER BY ranked.ContinentCode, ranked.CurrencyCode

--16
SELECT COUNT(*) AS [Count] FROM Countries AS C
LEFT JOIN MountainsCountries AS MC
ON MC.CountryCode = C.CountryCode
LEFT JOIN Mountains AS M
ON M.Id = MC.MountainId
WHERE MC.MountainId IS NULL

--17
SELECT TOP(5) CTR.CountryName, M.HEIGHEST AS [HeighestPeakElevation], R.LONGEST AS [LongestRiverLength] FROM Countries AS CTR
JOIN (
	SELECT MAX(P.Elevation) AS HEIGHEST, C.CountryCode
	FROM Peaks as P
	JOIN MountainsCountries AS MC
	ON P.MountainId = MC.MountainId
	JOIN Countries AS C
	ON C.CountryCode = MC.CountryCode
	GROUP BY C.CountryCode
) AS M
ON M.CountryCode = CTR.CountryCode
JOIN (
	SELECT MAX(R.Length) AS LONGEST, C.CountryCode FROM Rivers as R
	JOIN CountriesRivers AS CR
	ON R.Id = CR.RiverId
	JOIN Countries AS C
	ON C.CountryCode = CR.CountryCode
	GROUP BY C.CountryCode
) AS R
ON R.CountryCode = CTR.CountryCode
ORDER BY HeighestPeakElevation DESC

--18
SELECT TOP 5 C.CountryName AS [Country],

CASE
WHEN J.PeakName IS NULL THEN '(no highest peak)'
ELSE J.PeakName
END AS [Highest Peak Name],

CASE
WHEN J.Elevation IS NULL THEN 0
ELSE J.Elevation
END AS [Highest Peak Elevation],

CASE
WHEN J.MountainRange IS NULL THEN '(no mountain)'
ELSE J.MountainRange
END AS [Mountain]

FROM Countries AS C
left JOIN (
	SELECT C.CountryCode AS countryC, P.Elevation, P.PeakName, M.MountainRange,
	DENSE_RANK() OVER (PARTITION BY C.CountryCode ORDER BY P.Elevation desc) AS [RANK]
	FROM Countries AS C
	JOIN MountainsCountries AS MC
	ON MC.CountryCode = C.CountryCode
	JOIN Mountains AS M
	ON M.Id = MC.MountainId
	JOIN Peaks AS P
	ON P.MountainId = M.Id
) AS J
ON C.CountryCode = J.countryC 
WHERE [RANK] = 1 or [RANK] is null
ORDER BY Country, [Highest Peak Name]
