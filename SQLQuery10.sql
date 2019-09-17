CREATE TABLE Employees(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	FirstName NVarChar(200) NOT NULL UNIQUE(FirstName),
	LastName NVarChar(200) NOT NULL UNIQUE(FirstName),
	Title NVarChar(100),
	Notes NVarChar(MAX)
)

INSERT INTO Employees(FirstName,LastName) VALUES('Alexander0', 'Hristov0');
INSERT INTO Employees(FirstName,LastName) VALUES('Alexander1', 'Hristov1');
INSERT INTO Employees(FirstName,LastName) VALUES('Alexander2', 'Hristov2');

CREATE TABLE Customers(
	AccountNumber INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	FirstName NVarChar(200) NOT NULL UNIQUE(FirstName),
	LastName NVarChar(200) NOT NULL UNIQUE(FirstName),
	PhoneNumber BigInt,
	EmergencyNumber BigInt,
	EmergencyName NVarChar(100),
	Notes NVarChar(MAX)
)

INSERT INTO Customers(FirstName,LastName) VALUES('Hristo0','Stoychev0');
INSERT INTO Customers(FirstName,LastName) VALUES('Hristo1','Stoychev1');
INSERT INTO Customers(FirstName,LastName) VALUES('Hristo2','Stoychev2');

CREATE TABLE RoomStatus(
	RoomStatus INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Notes NVarChar(MAX)
)

INSERT INTO RoomStatus(Notes)VALUES('Note for room status 1');
INSERT INTO RoomStatus(Notes)VALUES('Note for room status 2');
INSERT INTO RoomStatus(Notes)VALUES('Note for room status 3');

CREATE TABLE RoomTypes(
	RoomType INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Notes NVarChar(MAX)
)

INSERT INTO RoomTypes(Notes) VALUES('Note for room type 1');
INSERT INTO RoomTypes(Notes) VALUES('Note for room type 2');
INSERT INTO RoomTypes(Notes) VALUES('Note for room type 3');

CREATE TABLE BedTypes(
	BedType INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Notes NVarChar(MAX)
)

INSERT INTO BedTypes(Notes) VALUES('This one is stinky');
INSERT INTO BedTypes(Notes) VALUES('This two is stinky');
INSERT INTO BedTypes(Notes) VALUES('This three is stinky');

CREATE TABLE Rooms(
	RoomNumber INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	RoomType INT NOT NULL FOREIGN KEY REFERENCES RoomTypes(RoomType),
	BedType INT NOT NULL FOREIGN KEY REFERENCES BedTypes(BedType),
	Rate Decimal,
	RoomStatus INT NOT NULL FOREIGN KEY REFERENCES RoomStatus(RoomStatus),
	Notes NVarChar(MAX)
)

INSERT INTO Rooms(RoomType,BedType,RoomStatus)VALUES(1,1,1);
INSERT INTO Rooms(RoomType,BedType,RoomStatus)VALUES(2,2,2);
INSERT INTO Rooms(RoomType,BedType,RoomStatus)VALUES(3,3,3);

CREATE TABLE Payments(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	EmployeeId INT NOT NULL FOREIGN KEY REFERENCES Employees(Id),
	PaymentDate Date,
	AccountNumber BIGINT,
	FirstDateOccupied Date Default CURRENT_TIMESTAMP,
	LastDateOccupied Date Default CURRENT_TIMESTAMP,
	TotalDays INT,
	AmountCharged Decimal(15,10),
	TaxRate Decimal(15,10),
	TaxAmount Decimal(15,10),
	PaymentTotal Decimal(15,10),
	Notes NVarChar(MAX)
)

TRUNCATE TABLE Payments

INSERT INTO Payments(EmployeeId, AccountNumber,PaymentTotal,TaxRate) VALUES(1,1231231,523.44, 10);
INSERT INTO Payments(EmployeeId, AccountNumber,PaymentTotal,TaxRate) VALUES(2,8654245,153.44, 100);
INSERT INTO Payments(EmployeeId, AccountNumber,PaymentTotal,TaxRate) VALUES(3,2342342,235.44, 1000);

CREATE TABLE Occupancies(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	EmployeeId INT NOT NULL FOREIGN KEY REFERENCES Employees(Id),
	DateOccupied Date,
	AccountNumber BIGINT,
	RoomNumber INT NOT NULL FOREIGN KEY REFERENCES Rooms(RoomNumber), 
	RateApplied Decimal(15,10),
	PhoneCharge Decimal(15,10),
	Notes NVarChar(MAX)
)

INSERT INTO Occupancies(EmployeeId,RoomNumber,DateOccupied) VALUES(1,1,'2000-04-24');
INSERT INTO Occupancies(EmployeeId,RoomNumber,DateOccupied) VALUES(2,2,'2001-04-24');
INSERT INTO Occupancies(EmployeeId,RoomNumber,DateOccupied) VALUES(3,3,'2002-04-24');


SELECT * FROM Occupancies

UPDATE Payments
	SET TaxRate = TaxRate*0.97

SELECT TaxRate FROM Payments

TRUNCATE TABLE Occupancies;