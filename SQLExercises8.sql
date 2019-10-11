CREATE TABLE Logs(
	Id INT PRIMARY KEY IDENTITY(1,1),
	AccountId INT FOREIGN KEY REFERENCES Accounts(Id),
	OldSum MONEY,
	NewSum MONEY
)

go

CREATE TRIGGER TR ON Accounts FOR UPDATE
AS
	INSERT INTO Logs(AccountId,OldSum,NewSum) 
		SELECT i.Id as accountId,d.Balance as oldsum,i.Balance as newsum FROM inserted as i
		JOIN deleted as d ON d.Id = i.Id AND d.Balance != i.Balance

GO

CREATE TRIGGER TR1 ON Logs FOR INSERT
AS
	INSERT INTO NotificationEmails(Recipient, Subject, Body)
	SELECT 
	I.AccountId,
	CONCAT('Balance change for account: ', I.AccountId),
	CONCAT('On ', GETDATE(), 'your balance was changed from ', I.OldSum, ' to ', I.NewSum)
	FROM inserted AS I

GO

CREATE PROCEDURE usp_DepositMoney (@ACCOUTID INT, @MONEYAMOUNT DECIMAL(16,4))
AS
BEGIN TRANSACTION
	IF(@MONEYAMOUNT <= 0 OR @MONEYAMOUNT > (SELECT Balance FROM Accounts WHERE Id = @ACCOUTID) )
	BEGIN
		ROLLBACK
		RAISERROR('NOT ENOUGH MONEY BITCH!!!!', 1, 1)
		RETURN
	END
	UPDATE Accounts SET Balance = Balance-@MONEYAMOUNT
	WHERE Id = @ACCOUTID
COMMIT

GO

CREATE PROCEDURE usp_WithdrawMoney (@ACCOUTID INT, @MONEYAMOUNT DECIMAL(16,4))
AS
BEGIN TRANSACTION
	IF(@MONEYAMOUNT <= 0 OR @MONEYAMOUNT > (SELECT Balance FROM Accounts WHERE Id = @ACCOUTID) )
	BEGIN
		ROLLBACK
		RAISERROR('NOT ENOUGH MONEY BITCH!!!!', 1, 1)
		RETURN
	END
	UPDATE Accounts SET Balance = Balance-@MONEYAMOUNT
	WHERE Id = @ACCOUTID
COMMIT

GO

CREATE PROCEDURE usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL(16,4))
AS
BEGIN TRANSACTION
	BEGIN TRY
		EXEC usp_WithdrawMoney @SenderId, @Amount
		EXEC usp_DepositMoney @ReceiverId, @Amount
	END TRY
	BEGIN CATCH
		ROLLBACK
		RAISERROR ('WTF Are you trying to do bitch??', 1,1)
		RETURN
	END CATCH
COMMIT

GO

CREATE TRIGGER BUYITEM ON UserGameItems FOR INSERT
AS
	DECLARE @ITEMLEVEL INT = (SELECT I.MinLevel FROM inserted AS UI
		JOIN Items AS I ON I.Id = UI.ItemId)
	DECLARE @USERLEVEL INT = (SELECT U.[Level] FROM inserted AS UI
		JOIN UsersGames AS U ON U.Id = UI.UserGameId)
	IF(@USERLEVEL<@ITEMLEVEL)BEGIN
		raiserror('level too low',11,1)
	END

SELECT * FROM Users WHERE Username = 'STAMAT'

USE SoftUni

GO

CREATE PROCEDURE usp_AssignProject(@emloyeeId INT, @projectID INT)
AS
BEGIN TRANSACTION
	INSERT INTO EmployeesProjects VALUES(@emloyeeId,@projectID)
	IF (SELECT COUNT(*) FROM EmployeesProjects WHERE EmployeeID = @emloyeeId) > 3 BEGIN 
		ROLLBACK
		RAISERROR('The employee has too many projects!',16,1)
		RETURN
	END
COMMIT

GO

CREATE TABLE Deleted_Employees(
EmployeeId INT PRIMARY KEY FOREIGN KEY REFERENCES EMPLOYEES(EmployeeID),
FirstName NVARCHAR(100),
LastName NVARCHAR(100),
MiddleName NVARCHAR(100),
JobTitle NVARCHAR(100),
DepartmentId INT FOREIGN KEY REFERENCES Departments(DepartmentId),
Salary money)

go

create TRIGGER DEL ON Employees FOR DELETE
AS
	INSERT INTO Deleted_Employees(
		FirstName,
  		LastName,
  		MiddleName,
  		JobTitle,
  		DepartmentId,
  		Salary) SELECT
        	e.FirstName,
            e.LastName,
            e.MiddleName,
            e.JobTitle,
            e.DepartmentID,
            e.Salary
			FROM deleted as e

delete from employees
WHERE employeeid = 1

truncate table Deleted_Employees

select * from Deleted_Employees
