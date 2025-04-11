CREATE TABLE Person (
	PersonID int IDENTITY(1,1) PRIMARY KEY,
	RoseID int,
	CHECK(RoseID LIKE ('[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')),
	PhoneNumber int
	CHECK(PhoneNumber LIKE ('[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')),
	LastName VARCHAR(12) NOT NULL,
	FirstName VARCHAR(12) NOT NULL,
	Email VARCHAR(20) NOT NULL
	CHECK (Email LIKE ('%@%.%'))
);
 
CREATE TABLE Driver (
	DriverID int PRIMARY KEY REFERENCES Person(PersonID),
	DLN VARCHAR(20) NOT NULL,
);
 
CREATE TABLE Vehicle (
	VehicleID int IDENTITY(1,1) PRIMARY KEY,
	PlateNumber VARCHAR(10) NOT NULL,
	Make VARCHAR(15) NOT NULL,
	Model VARCHAR(15) NOT NULL,
	Capacity int NOT NULL
);

CREATE TABLE Owns(
	DriverID int REFERENCES Driver(DriverID),
	VehicleID int REFERENCES Vehicle(VehicleID),
	PRIMARY KEY(DriverID, VehicleID)
);

CREATE TABLE Color (
	ColorID int IDENTITY(1,1) PRIMARY KEY,
	[Name] VARCHAR(30) UNIQUE
);
 
CREATE TABLE CarColor (
	DriverID int REFERENCES Driver(DriverID),
	ColorID int REFERENCES Color(ColorID),
	PRIMARY KEY(DriverID, ColorID)
);
 
CREATE TABLE Rider (
	RiderID int PRIMARY KEY REFERENCES Person(PersonID),
	NumRides int NULL
);

CREATE TABLE [Location](
	LocationID int IDENTITY(1,1) PRIMARY KEY,
	[Name] nvarchar(50) NOT NULL,
	Street nvarchar(50) NOT NULL,
	City nvarchar(25) NOT NULL,
	[State] char(2) NOT NULL
		CHECK([State] IN ('IN', 'IL', 'OH', 'KY')),
	isRose bit NOT NULL 
);

CREATE TABLE Ride(
	RideID int IDENTITY(1, 1) PRIMARY KEY,
	DriverID int REFERENCES Driver(DriverID),
	StartTime datetime NOT NULL
		CHECK(StartTime >= GETDATE()),
	--RoundTime is ONLY for Round trips
	--the user will put in a time they expect to be picked up 
	--then they are brought back to their initial location at that time
	RoundTime datetime NULL
		CHECK(RoundTime IS NULL OR RoundTime >= GETDATE()),
	--derived, Driver will mark when he has completed the ride
	EndTime datetime NULL,
	isOneWay bit NOT NULL,
	StartLocationID int REFERENCES [Location](LocationID),
	BringToLocationID int REFERENCES [Location](LocationID)
);

CREATE TABLE Rides(
	RiderID int REFERENCES Rider(RiderID),
	RideID int REFERENCES Ride(RideID),
	PRIMARY KEY(RiderID, RideID)
);