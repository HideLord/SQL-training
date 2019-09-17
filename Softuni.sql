CREATE DATABASE SoftUni

CREATE TABLE Towns(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Name NVarChar(100) NOT NULL UNIQUE(Name)
)
CREATE TABLE Addresses(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	AddressText NVarChar(MAX),
	TownId INT NOT NULL FOREIGN KEY REFERENCES Towns(Id)
)
CREATE TABLE Departments(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Name NVarChar(200) NOT NULL UNIQUE(Name)
)

CREATE TABLE Employees(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	FirstName NVarChar(100) NOT NULL,
	MiddleName NVarChar(100) NOT NULL,
	LastName NVarChar(100) NOT NULL,
	JobTitle NVarChar(100),
	DepartmentId INT NOT NULL FOREIGN KEY REFERENCES Departments(Id),
	HireDate Date DEFAULT CURRENT_TIMESTAMP,
	Salary Decimal(15,10),
	AddressId INT FOREIGN KEY REFERENCES Addresses(Id)
)

INSERT INTO Towns(Name) VALUES('Sofia');
INSERT INTO Towns(Name) VALUES('Plovdiv');
INSERT INTO Towns(Name) VALUES('Varna');
INSERT INTO Towns(Name) VALUES('Burgas');

INSERT INTO Departments(Name) VALUES('Engineering');
INSERT INTO Departments(Name) VALUES('Sales');
INSERT INTO Departments(Name) VALUES('Marketing');
INSERT INTO Departments(Name) VALUES('Software Development');
INSERT INTO Departments(Name) VALUES('Quality Assurance');

INSERT INTO Employees(FirstName,MiddleName,LastName,JobTitle,DepartmentId,HireDate,Salary)
VALUES('Ivan','Ivanov','Ivanov','.NET Developer',4,'02/01/2013',3500.00);
INSERT INTO Employees(FirstName,MiddleName,LastName,JobTitle,DepartmentId,HireDate,Salary)
VALUES('Petar','Petrov','Petrov','Senior Engineer',1,'03/02/2004',4000.00);
INSERT INTO Employees(FirstName,MiddleName,LastName,JobTitle,DepartmentId,HireDate,Salary)
VALUES('Maria','Petrova','Ivanova','Intern',5,'08/28/2016',525.25);
INSERT INTO Employees(FirstName,MiddleName,LastName,JobTitle,DepartmentId,HireDate,Salary)
VALUES('Georgi','Teziev','Ivanov','CEO',2,'12/09/2007',3000.00);
INSERT INTO Employees(FirstName,MiddleName,LastName,JobTitle,DepartmentId,HireDate,Salary)
VALUES('Peter','Pan','Pan','Intern',3,'08/28/2016',599.88);

SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

SELECT * FROM Towns
  ORDER BY Name ASC;
SELECT * FROM Departments
  ORDER BY Name ASC;
SELECT * FROM Employees
  ORDER BY Salary DESC;

SELECT Name FROM Towns
  ORDER BY Name ASC;
SELECT Name FROM Departments
  ORDER BY Name ASC;
SELECT FirstName,LastName,JobTitle,Salary FROM Employees
  ORDER BY Salary DESC;

UPDATE Employees
	SET Salary = Salary*1.1;

SELECT Salary FROM Employees;