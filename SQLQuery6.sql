CREATE TABLE Directors(Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
DirectorName NVarChar(100) NOT NULL CHECK(LEN(DirectorName)>=5) Unique(DirectorName),
Notes NVarChar(MAX));
CREATE TABLE Genres(Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
GenreName NVarChar(100) NOT NULL Unique(GenreName),
Notes NVarChar(MAX));
CREATE TABLE Categories(Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
CategoryName NVarChar(100) NOT NULL Unique(CategoryName),
Notes NVarChar(MAX));
CREATE TABLE Movies(Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Title NVarChar(100) NOT NULL Unique(Title),
DirectorId INT NOT NULL FOREIGN KEY REFERENCES Directors(Id),
CopyrightYear Date,
Length Time Default '1:0:0',
GenreId INT NOT NULL FOREIGN KEY REFERENCES Genres(Id),
CategoryId INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
Rating INT CHECK(Rating<=10 AND Rating>0),
Notes NVarChar(MAX));

INSERT INTO Directors(DirectorName)
VALUES('stephan');
INSERT INTO Directors(DirectorName)
VALUES('bobine');
INSERT INTO Directors(DirectorName)
VALUES('vagane');
INSERT INTO Directors(DirectorName)
VALUES('alexander');
INSERT INTO Directors(DirectorName)
VALUES('somebody');

INSERT INTO Genres(GenreName)
VALUES('Drama');
INSERT INTO Genres(GenreName)
VALUES('Romance');
INSERT INTO Genres(GenreName)
VALUES('Action');
INSERT INTO Genres(GenreName)
VALUES('Anime');
INSERT INTO Genres(GenreName)
VALUES('Musical');

INSERT INTO Categories(CategoryName)
VALUES('C1');
INSERT INTO Categories(CategoryName)
VALUES('C2');
INSERT INTO Categories(CategoryName)
VALUES('C3');
INSERT INTO Categories(CategoryName)
VALUES('C4');
INSERT INTO Categories(CategoryName)
VALUES('C5');


INSERT INTO Movies(Title,DirectorId,GenreId,CategoryId)
VALUES('Titanic',1,2,5);
INSERT INTO Movies(Title,DirectorId,GenreId,CategoryId)
VALUES('Titanic 1',2,1,1);
INSERT INTO Movies(Title,DirectorId,GenreId,CategoryId)
VALUES('Titanic 2',3,3,2);
INSERT INTO Movies(Title,DirectorId,GenreId,CategoryId)
VALUES('Titanic the return of the iceberg',4,4,4);
INSERT INTO Movies(Title,DirectorId,GenreId,CategoryId)
VALUES('Titanic 2020',5,5,3);

