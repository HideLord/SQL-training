USE Gringotts

--1
SELECT COUNT(*) FROM WizzardDeposits

--2
SELECT MAX(MagicWandSize) FROM WizzardDeposits

--3
SELECT DepositGroup, MAX(MagicWandSize) as LongestMagicWand FROM WizzardDeposits GROUP BY DepositGroup

--4
SELECT TOP(2) wd.DepositGroup AS [Average size] FROM WizzardDeposits AS wd GROUP BY wd.DepositGroup ORDER BY AVG(MagicWandSize)

--5
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum FROM WizzardDeposits GROUP BY DepositGroup 

--6
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum FROM WizzardDeposits WHERE MagicWandCreator = 'Ollivander family' GROUP BY DepositGroup

--7
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
	FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup
	HAVING SUM(DepositAmount) <= 150000
	ORDER BY TotalSum DESC

--8
Select DepositCharge,  DepositGroup FROM WizzardDeposits ORDER BY DepositCharge

SELECT wd.DepositGroup, wd.MagicWandCreator, j.aggMinChange AS [MinDepositCharge]
FROM WizzardDeposits AS wd
JOIN 
(SELECT DepositGroup, MIN(DepositCharge) as aggMinChange FROM WizzardDeposits GROUP BY DepositGroup) AS j
ON wd.DepositGroup = j.DepositGroup
ORDER BY MagicWandCreator, DepositGroup 

SELECT wd.DepositGroup, wd.MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge
FROM WizzardDeposits AS wd
GROUP BY wd.DepositGroup, wd.MagicWandCreator
ORDER BY wd.MagicWandCreator, DepositGroup

--9
SELECT d.AgeGroup, COUNT(*) FROM (
SELECT 
CASE
WHEN wd.Age <= 10 THEN '[0-10'
WHEN wd.Age <= 20 THEN '[11-20]'
WHEN wd.Age <= 30 THEN '[21-30]'
WHEN wd.Age <= 40 THEN '[31-40]'
WHEN wd.Age <= 50 THEN '[41-50]'
WHEN wd.Age <= 60 THEN '[51-60]'
ELSE '[61+]'
END AS [AgeGroup]
FROM WizzardDeposits AS wd
) d
GROUP BY d.AgeGroup

--10
SELECT DISTINCT LEFT(FirstName,1) AS FirstLetter FROM WizzardDeposits as wd WHERE wd.DepositGroup = 'Troll Chest' ORDER BY FirstLetter

--or
SELECT 
LEFT(FirstName,1) AS FirstLetter 
FROM WizzardDeposits as wd 
WHERE wd.DepositGroup = 'Troll Chest' 
GROUP BY LEFT(FirstName,1) 
ORDER BY FirstLetter

--11
SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest)
FROM WizzardDeposits as wd
WHERE wd.DepositStartDate > '01/01/1985'
GROUP BY wd.DepositGroup, wd.IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired ASC

--12
SELECT SUM(wd2.DepositAmount-wd1.DepositAmount) as SumDifference
FROM WizzardDeposits as wd1, WizzardDeposits as wd2
WHERE wd1.Id = wd2.Id+1


USE SoftUni
--13
SELECT DepartmentID, SUM(Salary) AS TotalSalary FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

--14
SELECT DepartmentId, MIN(Salary) AS MinimumSalary
FROM Employees AS e
WHERE e.DepartmentID IN (2,5,7)
GROUP BY DepartmentID

--15
SELECT * 
INTO #table
FROM Employees
WHERE Salary > 30000
DELETE FROM #table
WHERE ManagerID = 42
UPDATE #table
SET Salary+=5000
WHERE DepartmentID=1
SELECT DepartmentID, AVG(Salary) AS [AverageSalary] FROM #table as t
GROUP BY t.DepartmentID
DROP table #table

--16
SELECT DepartmentID, MAX(Salary) FROM Employees as e
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

--17
SELECT COUNT(*) AS [Count] FROM Employees WHERE ManagerID IS NULL

--18
SELECT d.DepartmentID, d.Salary AS ThirdHighestSalary FROM (
	SELECT 
	DISTINCT DENSE_RANK()
	OVER (PARTITION BY e.DepartmentID ORDER BY e.Salary DESC) AS [Rank], e.Salary, e.DepartmentID
	FROM Employees as e
) AS d
WHERE d.[Rank] = 3
ORDER BY d.DepartmentID

--19
Select TOP(10) e.FirstName, e.LastName, e.DepartmentID 
FROM(
	SELECT DepartmentId, AVG(Salary) AS [AvgSalary] FROM Employees GROUP BY DepartmentID
) AS t, Employees as e
WHERE e.DepartmentID = t.DepartmentID AND e.Salary > t.AvgSalary
