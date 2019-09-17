Create Table Minions(
	Id INT NOT NULL PRIMARY KEY,
	Name NVarChar(100),
	Age INT
)

Create Table Towns(
	Id INT NOT NULL PRIMARY KEY,
	Name NVarChar(100)
)

ALTER TABLE Minions
ADD TownId INT

ALTER TABLE Minions
ADD FOREIGN KEY (TownId) REFERENCES Towns(Id);

INSERT INTO Towns(Id, Name)
VALUES (1,'Sofia');
INSERT INTO Towns(Id, Name)
VALUES (2,'Plovdiv');
INSERT INTO Towns(Id, Name)
VALUES (3,'Varna');

SELECT * FROM Towns;

INSERT INTO Minions(Id, Name, Age, TownId)
VALUES (1,'Kevin',22, 1);
INSERT INTO Minions(Id, Name, Age, TownId)
VALUES (2,'Bob',15, 3);
INSERT INTO Minions(Id, Name, Age, TownId)
VALUES (3,'Steward',NULL, 2);

SELECT * FROM Minions;

TRUNCATE TABLE Minions;

DROP TABLE Minions;
DROP TABLE Towns;

CREATE TABLE People(
	Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Name NVarChar(200) NOT NULL,
	Picture Image ,
	Height Decimal(10,2),
	Weight Decimal(10,2),
	Gender Char(1) NOT NULL CHECK(Gender = 'm' OR Gender = 'f'),
	Birthdate Date NOT NULL,
	Biography NVarChar(Max)
);

INSERT INTO People(Name,Height,Weight,Gender,Birthdate)
VALUES ('Alexander',1.82,64.5,'m','2000-04-13');
INSERT INTO People(Name,Height,Weight,Gender,Birthdate)
VALUES ('Alexander1',1.82,64.5,'m','2000-04-13');
INSERT INTO People(Name,Height,Weight,Gender,Birthdate)
VALUES ('Alexander2',1.82,64.5,'m','2000-04-13');
INSERT INTO People(Name,Height,Weight,Gender,Birthdate)
VALUES ('Alexander3',1.82,64.5,'m','2000-04-13');
INSERT INTO People(Name,Height,Weight,Gender,Birthdate)
VALUES ('Alexander4',1.82,64.5,'m','2000-04-13');

SELECT * FROM People;

CREATE TABLE Users(
	Id BIGINT NOT NULL PRIMARY KEY IDENTITY(1,1),
	Username VarChar(30) NOT NULL,
	Password VarChar(26) NOT NULL,
	ProfilePicture Image,
	LastLoginTime DateTime,
	IsDeleted Bit
);

INSERT INTO Users(Username,Password)
VALUES ('Alexander', '12773718823');
INSERT INTO Users(Username,Password)
VALUES ('Alexander1','177013');
INSERT INTO Users(Username,Password)
VALUES ('Alexander2','201dasda728');
INSERT INTO Users(Username,Password)
VALUES ('Alexander3','ryuijdahsgdt');
INSERT INTO Users(Username,Password)
VALUES ('Bob','Basd63asd33');

SELECT * FROM Users;

ALTER TABLE Users
DROP CONSTRAINT PK__Users__3214EC0777208C2E;

ALTER TABLE Users
ADD CONSTRAINT PK_USER PRIMARY KEY (Id,Username);

ALTER TABLE Users
ADD CHECK(LEN(Password)>=5);

ALTER TABLE Users
ADD DEFAULT CURRENT_TIMESTAMP FOR LastLoginTime

ALTER TABLE Users
DROP CONSTRAINT PK_USER;

ALTER TABLE Users
ADD PRIMARY KEY (Id);

ALTER TABLE Users
ADD CONSTRAINT USERNAME_LEN CHECK(LEN(Username)>=3)

ALTER TABLE Users
ADD CONSTRAINT UNIQUE_USERNAME UNIQUE(Username);