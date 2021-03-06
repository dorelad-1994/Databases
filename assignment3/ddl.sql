CREATE TABLE IF NOT EXISTS Employee
(
	EID INTEGER PRIMARY KEY,
	LastName VARCHAR (25) NOT NULL,
	FirstName VARCHAR(25) NOT NULL,
	BirthDate DATETIME,
	StreetName VARCHAR (50) NOT NULL,
	Number INTEGER NOT NULL,
	Door INTEGER,
	City VARCHAR(25) NOT NULL 
);

CREATE TABLE IF NOT EXISTS CellPhone
(
	EID INTEGER,
	Number VARCHAR(11),
	PRIMARY KEY (EID, Number),
	FOREIGN KEY (EID) REFERENCES Employee(EID) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS OfficialEmployee
(
	EID INTEGER PRIMARY KEY,
	StartWorkingDate DATETIME, 
	Degree VARCHAR(25), 
	Department INTEGER,
	FOREIGN KEY (EID) REFERENCES Employee(EID) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (Department) REFERENCES Department(DID) ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE IF NOT EXISTS Department
(
	DID INTEGER PRIMARY KEY,
	Name VARCHAR(50) NOT NULL UNIQUE,
	Description VARCHAR(50),
	ManagerID INTEGER,
	FOREIGN KEY (ManagerID) REFERENCES OfficialEmployee(EID) ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE IF NOT EXISTS ConstructorEmployee
(
	EID INTEGER PRIMARY KEY,
	CompanyName VARCHAR(25) NOT NULL,
	SalaryPerDay FLOAT NOT NULL, 
	FOREIGN KEY (EID) REFERENCES Employee(EID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Neighborhood
(
	NID INTEGER PRIMARY KEY,
	Name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS Project
(
	PID INTEGER PRIMARY KEY,
	Name VARCHAR(25) NOT NULL,
	Description VARCHAR(50),
	Budget INTEGER NOT NULL, 
	NID INTEGER,
	FOREIGN KEY (NID) REFERENCES Neighborhood(NID) ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS ProjectConstructorEmployee
(
	PID INTEGER,
	EID INTEGER,
	StartWorkingDate DATETIME,
	EndWorkingDate DATETIME,
	JobDescription VARCHAR(30),
	PRIMARY KEY (PID, EID),
	FOREIGN KEY (EID) REFERENCES ConstructorEmployee(EID) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (PID) REFERENCES Project(PID) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT check_start_end_working_date CHECK(EndWorkingDate >= StartWorkingDate)
);


CREATE TABLE IF NOT EXISTS Apartment
(
	StreetName VARCHAR(50), 
	Number INTEGER, 
	Door INTEGER,
	Type VARCHAR(30) NOT NULL,
	SizeSquareMeter INTEGER CHECK(SizeSquareMeter>=0),
	NID INTEGER,
	PRIMARY KEY (StreetName, Number, Door),
	FOREIGN KEY (NID) REFERENCES Neighborhood(NID) ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS Resident
(
	RID INTEGER PRIMARY KEY,
	LastName VARCHAR(50) NOT NULL, 
	FirstName VARCHAR(50) NOT NULL, 
	BirthDate DATETIME NOT NULL,
	StreetName VARCHAR(50), 
	Number INTEGER, 
	Door INTEGER,
	CONSTRAINT fk_apartment FOREIGN KEY (StreetName, Number, Door) REFERENCES Apartment(StreetName, Number, Door) ON UPDATE RESTRICT ON DELETE RESTRICT
	
);


CREATE TABLE IF NOT EXISTS TrashCan
(
	TCID INTEGER PRIMARY KEY,
	NID  INTEGER,
	FOREIGN KEY (NID) REFERENCES Neighborhood(NID) ON UPDATE RESTRICT ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS GarbageCollectionCompany
(
	GCID INTEGER PRIMARY KEY,
	Name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS GarbageCollection
(
	TCID INTEGER, 
	GCID INTEGER,
	StartTime DATETIME NOT NULL, 
	EndTime DATETIME NOT NULL, 
	PRIMARY KEY (TCID, GCID, StartTime),
	FOREIGN KEY (TCID) REFERENCES TrashCan(TCID) ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (GCID) REFERENCES GarbageCollectionCompany(GCID) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT check_garbage_collection_dates CHECK(EndTime >= StartTime)
);



CREATE TABLE IF NOT EXISTS ParkingArea
(
	AID INTEGER PRIMARY KEY,
	Name VARCHAR(30) NOT NULL UNIQUE,
	PricePerHour FLOAT NOT NULL,
	MaxPricePerDay FLOAT NOT NULL,
	NID INTEGER,
	FOREIGN KEY (NID) REFERENCES Neighborhood(NID) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT check_car_parking_cost CHECK(MaxPricePerDay >= PricePerHour)

);



CREATE TABLE IF NOT EXISTS Cars
(
	CID INTEGER PRIMARY KEY,
	CellPhoneNumber VARCHAR(12) NOT NULL,
	CreditCard VARCHAR(20) NOT NULL,
	ExpirationDate DATETIME NOT NULL,
	ThreeDigits VARCHAR(3) NOT NULL,
	ID VARCHAR(9)
);

CREATE TABLE IF NOT EXISTS CarParking
(
	CID INTEGER, 
	StartTime DATETIME NOT NULL, 
	EndTime DATETIME NOT NULL,
	AID INTEGER,
	Cost FLOAT NOT NULL,
	PRIMARY KEY (CID, StartTime),
	FOREIGN KEY (CID) REFERENCES Cars(CID) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT pa_fk FOREIGN KEY (AID) REFERENCES ParkingArea(AID) ON UPDATE SET NULL ON DELETE SET NULL,
	CONSTRAINT check_car_parking_dates CHECK(EndTime >= StartTime)
);
