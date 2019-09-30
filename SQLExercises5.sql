CREATE DATABASE RelationalBase

USE RelationalBase

CREATE TABLE Passports(
	PassportID INT PRIMARY KEY,
	PassportNumber NVARCHAR(50)
)

CREATE TABLE Persons(
	PersonID INT PRIMARY KEY IDENTITY(1,1),
	FirstName NVarChar(50),
	Salary Decimal(10,2),
	PassportID INT FOREIGN KEY REFERENCES Passports(PassportID)
)

INSERT INTO	Passports VALUES(101,'N34FG21B'),(102,'K65LO4R7'),(103,'ZE657QP2')
INSERT INTO	Persons VALUES('Roberto',43300.00,102),('Tom',56100.00,102),('Yana',60200.00,102)

CREATE TABLE Manufacturers(
	ManufacturerID INT PRIMARY KEY,
	[Name] NVarChar(50),
	EstablishedOn Date,
)

CREATE TABLE Models(
	ModelID INT PRIMARY KEY,
	[Name] NVarChar(50),
	ManufacturerID INT FOREIGN KEY REFERENCES Manufacturers(ManufacturerID)
)

INSERT INTO	Manufacturers VALUES(1,'BMW', '07/03/1913'), (2, 'Tesla', '01/01/2003'), (3, 'Lada', '01/05/1966')
INSERT INTO Models VALUES(101,'X1',1),(102,'i6',1),(103,'Model S',2),(104,'Model X',2),(105,'Model 3', 2),(106,'Nova',1)

CREATE TABLE Students(
	StudentID INT PRIMARY KEY,
	[Name] NVARCHAR(50)
)

CREATE TABLE Exams(
	ExamID INT PRIMARY KEY,
	[Name] NVarChar(50)
)

CREATE TABLE StudentsExams(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
	ExamID INT FOREIGN KEY REFERENCES Exams(ExamID)
)

ALTER TABLE StudentsExams
ALTER COLUMN StudentID INT NOT NULL; 

ALTER TABLE StudentsExams
ALTER COLUMN ExamID INT NOT NULL; 

DROP TABLE Students
DROP TABLE Exams
DROP TABLE StudentsExams

--SELECT * FROM Students

--ALTER TABLE StudentsExams
--DROP CONSTRAINT PK__Students__5052786334733264

INSERT INTO Students
VALUES(1,'Mila'),(2,'Toni'),(3,'Ron')

INSERT INTO Exams
VALUES(101,'SpringMVC'),(102,'Neo4j'),(103,'Oracle 11g')

INSERT INTO StudentsExams
VALUES(1,101),(1,102),(2,101),(3,103),(2,102),(2,103)

ALTER TABLE StudentsExams
ADD PRIMARY KEY (StudentID,ExamID)

CREATE TABLE Teachers(
	TeacherID INT PRIMARY KEY,
	[Name] NVarChar(50),
	ManagerID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
)

INSERT INTO Teachers VALUES(101,'John', NULL),(102,'Maya', 106),(103,'Silvia', 106),
(104,'Ted', 105),(105,'Mark', 101),(106,'Greta', 101)


CREATE TABLE Cities(
	CityID INT PRIMARY KEY,
	[Name] Varchar(50)
)

CREATE TABLE Customers(
	CustomerID INT PRIMARY KEY,
	[Name] VarCHar(50),
	Birthday date,
	CityID INT FOREIGN KEY REFERENCES Cities(CityID)
)

CREATE TABLE Orders(
	OrderID INT Primary Key,
	CustomerID INT  FOREIGN KEY REFERENCES Customers(CustomerID)
)


CREATE TABLE ItemTypes(
	ItemTypeID INT PRIMARY KEY,
	[Name] VarChar(50)
)

CREATE TABLE Items(
	ItemID INT PRIMARY KEY,
	[Name] VarChar(50),
	ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID),
)

CREATE TABLE OrderItems(
	OrderID INT FOREIGN KEY REFERENCES Orders(OrderID) NOT NULL,
	ItemID INT  FOREIGN KEY REFERENCES Items(ItemID) NOT NULL,
)

ALTER TABLE OrderItems
ADD CONSTRAINT PK_ORDERS_ITEMS PRIMARY KEY (OrderID,ItemID)

CREATE TABLE Majors(
	MajorID INT PRIMARY KEY,
	[Name] NVarChar(50)
)

CREATE TABLE Students(
	StudentID int PRIMARY KEY,
	StudentNumber INT,
	StudentName VarChar(50),
	MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
)

CREATE TABLE Payments(
	PaymentID INT PRIMARY KEY,
	PaymentDate Date,
	PaymentAmount Decimal(15,2),
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID)
)

CREATE TABLE Subjects(
	SubjectID INT PRIMARY KEY,
	SubjectName	VarChar(50)
)

CREATE TABLE Agenda(
	StudentID INT FOREIGN KEY REFERENCES Students(StudentID) NOT NULL,
	SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID) NOT NULL
)

ALTER TABLE Agenda
ADD CONSTRAINT PK_STUDENTID_SUBJECTID PRIMARY KEY (StudentID,SubjectID)

USE Geography

SELECT m.MountainRange, p.PeakName, p.Elevation FROM Peaks as p
JOIN Mountains as m
ON p.MountainId = m.Id
WHERE m.MountainRange = 'Rila'
ORDER BY Elevation DESC