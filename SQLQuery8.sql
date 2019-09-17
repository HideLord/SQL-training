CREATE TABLE Categories(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	CategoryName NVarChar(200),
	DailyRate Decimal(15,10),
	WeeklyRate Decimal(15,10),
	MonthlyRate Decimal(15,10),
	WeekendRate Decimal(15,10)
)

INSERT INTO Categories(CategoryName)VALUES('C1');
INSERT INTO Categories(CategoryName)VALUES('C2');
INSERT INTO Categories(CategoryName)VALUES('C3');

CREATE TABLE Cars(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	PlateNumber NVarChar(200),
	Manufacturer NVarChar(200),
	Model NVarChar(200),
	CaryYear Date,
	CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
	Doors INT,
	Picture Image,
	Condition NVarChar(20),
	Available Bit DEFAULT 1
)

INSERT INTO Cars(PlateNumber, Available, CategoryId)VALUES('CB 1723', 1, 1);
INSERT INTO Cars(PlateNumber, Available, CategoryId)VALUES('VR 1323', 0, 2);
INSERT INTO Cars(PlateNumber, Available, CategoryId)VALUES('CB 5163', 0, 3);

CREATE TABLE Employees(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	FirstName NVarChar(200) NOT NULL UNIQUE(FirstName),
	LastName NVarChar(200) NOT NULL UNIQUE(FirstName),
	Title NVarChar(100),
	Notes NVarChar(100)
)

INSERT INTO Employees(FirstName,LastName)VALUES('Alexander', 'Hristov');
INSERT INTO Employees(FirstName,LastName)VALUES('Alex', 'Ivanova');
INSERT INTO Employees(FirstName,LastName)VALUES('Alexandra', 'Savova');

CREATE TABLE Customers(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	DriverLicenceNumber VarChar(30),
	FullName NVarChar(200),
	Address NVarChar(Max),
	City NVarChar(50),
	ZIPCode Char(5),
	Notes NVarChar(MAX)
)

INSERT INTO Customers(DriverLicenceNumber,FullName)VALUES('21qbf4rqwe','Alexander Hristov');
INSERT INTO Customers(DriverLicenceNumber,FullName)VALUES('ver5231asd','Alex Ivanova');
INSERT INTO Customers(DriverLicenceNumber,FullName)VALUES('1v264b1gf5','Alexandra Savova');

CREATE TABLE RentalOrders(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	EmployeeId INT NOT NULL FOREIGN KEY REFERENCES Employees(Id),
	CustomerId INT NOT NULL FOREIGN KEY REFERENCES Customers(Id),
	CarId INT NOT NULL FOREIGN KEY REFERENCES Cars(Id),
	TankLevel Decimal(10,5),
	KilometrageStart INT,
	KilometrageEnd INT,
	TotalKilometrage INT,
	StartDate Date,
	EndDate Date,
	TotalDays Date,
	RateApplied Decimal(10,10),
	TaxRate Decimal(10,10),
	OrderStatus VarChar(10),
	Notes NVarChar(MAX)
)

INSERT INTO RentalOrders(EmployeeId,CustomerId,CarId)
VALUES(1,1,1);
INSERT INTO RentalOrders(EmployeeId,CustomerId,CarId)
VALUES(2,2,2);
INSERT INTO RentalOrders(EmployeeId,CustomerId,CarId)
VALUES(3,3,3);
