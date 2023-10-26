CREATE TABLE Maintenance (
maintenanceID CHAR(30) NOT NULL,
startTime CHAR(15) NOT NULL, 
endTime CHAR(15) NOT NULL,
PRIMARY KEY (maintenanceID)
);

CREATE TABLE Customer (
customerID CHAR(30) NOT NULL, 
name TEXT NOT NULL, 
billingInformation CHAR(30) NOT NULL, 
email CHAR(30) NOT NULL,
phoneNumber INTEGER NOT NULL,
PRIMARY KEY (customerID)
);

CREATE TABLE BookedBy (
mainID CHAR(30) NOT NULL, 
custID CHAR(30) NOT NULL,
FOREIGN KEY (mainID) REFERENCES Maintenance(maintenanceID)
FOREIGN KEY (custID) REFERENCES Customer(customerID)
);


CREATE TABLE Employee(
employeeID CHAR(30) NOT NULL,
workingHours INTEGER NOT NULL,
name TEXT NOT NULL,
PRIMARY KEY (employeeID)
);

CREATE TABLE DoneBy (
maintID CHAR(30) NOT NULL,
empID CHAR(30) NOT NULL,
FOREIGN KEY (maintID) REFERENCES Maintenance(maintenanceID)
FOREIGN KEY (empID) REFERENCES Employee(employeeID)
);

CREATE TABLE Absence(
date CHAR(30) NOT NULL,
reason TEXT, 
PRIMARY KEY (date)
);

CREATE TABLE hasAbsence(
absenceDate CHAR(30) NOT NULL,
absEmpID CHAR(30) NOT NULL,
FOREIGN KEY (absenceDate) REFERENCES Absence(date)
FOREIGN KEY (absEmpID) REFERENCES Employee(employeeID)
);


CREATE TABLE Car(
licenceNumber CHAR(30) NOT NULL,
kmDriven INTEGER, 
PRIMARY KEY (licenceNumber)
);

CREATE TABLE DoneOn(
licenceNr CHAR(30) NOT NULL,
mID CHAR(30) NOT NULL,
FOREIGN KEY (licenceNr) REFERENCES Car(licenceNumber)
FOREIGN KEY (mID) REFERENCES Maintenance(maintenanceID)
);


CREATE TABLE Owner(
socialSecurityNumber CHAR(10) NOT NULL,
name TEXT NOT NULL,
email CHAR(30) NOT NULL,
phoneNumber INTEGER NOT NULL, 
PRIMARY KEY (socialSecurityNumber)
);


CREATE TABLE OwnedBy(
ssnr CHAR(10) NOT NULL,
licNr CHAR(10) NOT NULL,
FOREIGN KEY (ssnr) REFERENCES Owner(socialSecurityNumber)
FOREIGN KEY (licNr) REFERENCES Car(licenceNumber)
);


CREATE TABLE SparePart(
partID CHAR(30) NOT NULL,
type TEXT NOT NULL, 
cost INTEGER NOT NULL,
PRIMARY KEY (partID)
);

CREATE TABLE NeededFor(
spareID CHAR(30) NOT NULL,
maintSpareID CHAR(30) NOT NULL,
amount INTEGER,
FOREIGN KEY (spareID) REFERENCES SparePart(partID)
FOREIGN KEY (maintSpareID) REFERENCES Maintenance(maintenanceID)
);


CREATE TABLE Invoice(
paymentID CHAR(30) NOT NULL,
paymentDueDate CHAR(10) NOT NULL,
beenPayed BOOLEAN NOT NULL,
costOfWork INTEGER NOT NULL,
PRIMARY KEY (paymentID)
);

CREATE TABLE BilledBy(
payID CHAR(30) NOT NULL,
maintPayID CHAR(30) NOT NULL,
FOREIGN KEY (payID) REFERENCES Invoice(paymentID)
FOREIGN KEY (maintPayID) REFERENCES Maintenance(maintenanceID)
);


CREATE TABLE PaymentRemainder(
billingInformation CHAR(30) NOT NULL,
newPrice INTEGER NOT NULL,
newPaymentDueDate CHAR(10) NOT NULL,
amountOfRemainders INTEGER NOT NULL,
amountOfLatePayments INTEGER NOT NULL,
PRIMARY KEY (billingInformation)
);

CREATE TABLE RemainderOf(
remPayID CHAR(30) NOT NULL, 
billInfo CHAR(30) NOT NULL,
FOREIGN KEY (remPayID) REFERENCES Invoice(paymentID),
FOREIGN KEY (billInfo) REFERENCES PaymentRemainder(billingInformation)
);

CREATE TABLE Operation(
operationID CHAR(30) NOT NULL,
duration INTEGER NOT NULL,
operationType TEXT NOT NULL, 
PRIMARY KEY (operationID)
);

CREATE TABLE ConsistsOf(
mainOpID CHAR(30) NOT NULL,
opID CHAR(30) NOT NULL,
FOREIGN KEY (mainOpID) REFERENCES Maintenance(maintenanceID)
FOREIGN KEY (opID) REFERENCES Operation(operationID)
);


CREATE TABLE DeviceType(
manufID CHAR(30) NOT NULL,
type TEXT NOT NULL, 
PRIMARY KEY (manufID)
);

CREATE TABLE Uses(
manufacturerID CHAR(30) NOT NULL,
operID CHAR(30) NOT NULL,
FOREIGN KEY (manufacturerID) REFERENCES DeviceType(manufID)
FOREIGN KEY (operID) REFERENCES Operation(operationID)
);


CREATE TABLE Device(
deviceID CHAR(30) NOT NULL,
startTime CHAR(15) NOT NULL, 
endTime CHAR(15) NOT NULL,
PRIMARY KEY (deviceID, startTime)
);


CREATE TABLE KindOf(
manuID CHAR(30) NOT NULL,
devID CHAR(30)  NOT NULL,
devStartTime CHAR(30) NOT NULL, 
FOREIGN KEY (manuID) REFERENCES DeviceType(manufID)
FOREIGN KEY (devID,devStartTime ) REFERENCES Device(deviceID, startTime)
);