--1
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
BEGIN
	SELECT E.FirstName, E.LastName FROM Employees AS E
	WHERE E.Salary >= 35000
END

--2
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber
@VALUE DECIMAL(18,4)
AS
BEGIN
	SELECT E.FirstName, E.LastName FROM Employees AS E
	WHERE E.Salary >= @VALUE
END

--3
CREATE PROCEDURE usp_GetTownsStartingWith
@VALUE NVARCHAR(50)
AS
BEGIN
	SELECT T.[Name] FROM Towns AS T
	WHERE T.[Name] LIKE CONCAT(@VALUE,'%')
END

--4
CREATE PROCEDURE usp_GetEmployeesFromTown
@VALUE NVARCHAR(50)
AS
BEGIN
	SELECT E.FIRSTNAME,E.LASTNAME FROM Employees AS E
	JOIN Addresses AS A
	ON A.AddressID = E.AddressID
	JOIN Towns AS T
	ON T.TownID = A.TownID
	WHERE @VALUE = T.[Name]
END

--5
create FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4)) RETURNS NVARCHAR(50)
AS
BEGIN
	IF (@salary < 30000)
		RETURN 'Low'
	ELSE IF(@salary >= 30000 AND @salary <= 50000)
		RETURN 'Average'
	ELSE
		RETURN 'High'
	RETURN 'Low'
END

--6
CREATE PROCEDURE usp_EmployeesBySalaryLevel
@LEVEL NVARCHAR(50)
AS
BEGIN
	SELECT E.FIRSTNAME, E.LASTNAME FROM Employees as E
	WHERE dbo.ufn_GetSalaryLevel(E.Salary) = @LEVEL
END

CREATE FUNCTION dbo.ufn_IsWordComprised(@setOfLetters NVARCHAR(1000), @word NVARCHAR(1000))
RETURNS BIT
AS
BEGIN
	DECLARE @MYRES BIT
	DECLARE @i INT = 1
	DECLARE @SIZE INT = LEN(@word)
	WHILE @i <= @SIZE
	BEGIN
		IF CHARINDEX(RIGHT(LEFT(@word, @i),1), @setOfLetters) = 0
		BEGIN
			RETURN 0 
		END
		ELSE BEGIN 
			DECLARE @POS INT = CHARINDEX(RIGHT(LEFT(@word, @i),1), @setOfLetters)
			--SET @setOfLetters = CONCAT(SUBSTRING(@setOfLetters, 1, @POS-1),
			--						   SUBSTRING(@setOfLetters, @POS+1,LEN(@setOfLetters)-@POS))
		 END
		set @i = @i+1
	END
	RETURN 1
END

go

--8
create PROCEDURE usp_DeleteEmployeesFromDepartment @departmentId INT
AS
BEGIN
	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN (
		SELECT EmployeeID FROM Employees
		WHERE DepartmentID = @departmentId
	)

	UPDATE Employees
	SET ManagerID = NULL
	WHERE ManagerID IN (
		SELECT EmployeeID FROM Employees
		WHERE DepartmentID = @departmentId
	)

	ALTER TABLE Departments
	ALTER COLUMN ManagerID INT

	UPDATE Departments
	SET ManagerID = NULL
	WHERE DepartmentID = @departmentId

	DELETE FROM Employees
	WHERE DepartmentID = @departmentId

	DELETE FROM Departments
	WHERE DepartmentID = @departmentId

	SELECT COUNT(*) FROM Employees
	WHERE DepartmentID = @departmentId
END

--9
CREATE PROCEDURE usp_GetHoldersFullName
AS
BEGIN
	SELECT FirstName + ' ' + LastName as [Full Name]
	FROM AccountHolders
END

CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan
@Num MONEY
AS
BEGIN
	SELECT ah.FirstName, ah.LastName FROM AccountHolders as ah
	JOIN (
	SELECT ah.Id as Id, SUM(a.Balance) as bal FROM AccountHolders as ah
	JOIN Accounts as a ON a.AccountHolderId = ah.Id
	GROUP BY ah.Id) as j
	ON j.Id = ah.Id AND j.bal > @Num
	ORDER BY ah.FirstName, ah.LastName
END

CREATE FUNCTION ufn_CalculateFutureValue(@sum DECIMAL(15,5), @yearly FLOAT, @num INT)
RETURNS DECIMAL(15,4)
AS
BEGIN
	SET @yearly = @yearly + 1.0
	DECLARE @i INT = 0;
	WHILE @i < @num
	begin
		SET @sum = @sum*@yearly
		SET @i = @i+1
	end
	return @sum
END

ALTER PROCEDURE usp_CalculateFutureValueForAccount
@ACCOUNTID INT,
@INTEREST FLOAT
AS
BEGIN
	DECLARE @BAL MONEY = (
		SELECT Balance
		FROM Accounts
		where Id = @ACCOUNTID
	);
	SELECT @ACCOUNTID as [Account Id],
	ah.FirstName as [First Name],
	ah.LastName as [Last Name],
	@BAL as [Current Balance],
	dbo.ufn_CalculateFutureValue(@BAL,@INTEREST,5) as [Balance in 5 years]
	FROM AccountHolders as ah
	where ah.Id = @ACCOUNTID
END

GO

drop FUNCTION dbo.ufn_CashInUsersGames

CREATE FUNCTION ufn_CashInUsersGames(@GAMENAME VARCHAR(MAX))
RETURNS @output TABLE (SumCash DECIMAL(18,4))
AS
BEGIN
	INSERT INTO @output SELECT(
		SELECT SUM(J.Cash) FROM (
		SELECT ug.Cash as [Cash], ROW_NUMBER() OVER (ORDER BY ug.Cash DESC) as [RowNum]
		FROM UsersGames AS ug
		JOIN Games as g ON g.Id = ug.GameId
		WHERE g.[Name] = @GAMENAME
		) as J
		WHERE J.RowNum % 2 = 1
	) as br;
	return;
END

SELECT * FROM dbo.ufn_CashInUsersGames('Love in a mist')