INSERT INTO Customer (customerID, name, billingInformation, email, phoneNumber)
VALUES ('123456789', 'Anna Anaconda', 'FI12-3456789', 'anna.anaconda@gmail.com', 0501234123); 

INSERT INTO Customer (customerID, name, billingInformation, email, phoneNumber)
VALUES ('234567891', 'Berit Bäver', 'FI23-4567891', 'berit.baver@hotmail.com', 0401234123); 

INSERT INTO Customer (customerID, name, billingInformation, email, phoneNumber)
VALUES ('123456781', 'Conrad Cat', 'FI23-4567892', 'conrad.cat@hotmail.com', 0501234567); 

INSERT INTO Maintenance (maintenanceID, startTime, endTime)
VALUES ('123456781', '09-05-2022-0800', '09-05-2022-1000'); 

INSERT INTO Maintenance (maintenanceID, startTime, endTime)
VALUES ('111456781', '07-05-2022-1000', '07-05-2022-1200'); 

INSERT INTO Maintenance (maintenanceID, startTime, endTime)
VALUES ('211456781', '01-05-2022-1000', '02-05-2022-1200'); 

INSERT INTO Maintenance (maintenanceID, startTime, endTime)
VALUES ('112456781', '01-05-2021-1000', '01-05-2021-1200'); 

INSERT INTO BookedBy (mainID, custID)
VALUES ('111456781', '234567891'); 

INSERT INTO BookedBy(mainID, custID)
VALUES ('123456781','123456789'); 

INSERT INTO Employee (employeeID, workingHours, name)
VALUES ('987654321', 40, 'Daniel Daffodil'); 

INSERT INTO DoneBy (empID, maintID)
VALUES ('987654321', '112456781'); 

INSERT INTO Absence (date, reason)
VALUES ('01-05-2022', 'Wappu'); 

INSERT INTO hasAbsence (absenceDate, absEmpID)
VALUES ('01-05-2022', 987654321); 

INSERT INTO Car(licenceNumber, kmDriven)
VALUES ('ABC-123', 80000); 

INSERT INTO Car(licenceNumber, kmDriven)
VALUES ('DEF-456', 80000); 

INSERT INTO DoneOn (licenceNr, mID)
VALUES ('DEF-456', '111456781'); 

INSERT INTO DoneOn (licenceNr, mID)
VALUES ('ABC-123', '123456781'); 

INSERT INTO Owner(socialSecurityNumber, name, email, phoneNumber)
VALUES ('123456-A12', 'Erik Elefant','erik.elefant@mail.net' , 0458274613); 

INSERT INTO Owner( socialSecurityNumber, name, email, phoneNumber)
VALUES ('123456-A11', 'Fredrik Fredriksson', 'fredrick.fredriksson@mail.net' , 0458274612); 

INSERT INTO OwnedBy( ssnr, licNr)
VALUES ('123456-A11','ABC-123'); 

INSERT INTO OwnedBy( ssnr, licNr)
VALUES ('123456-A12','ABC-123'); 

INSERT INTO SparePart(partID, type, cost)
VALUES ('11111111', 'exhaust pipe', 50); 

INSERT INTO SparePart(partID, type, cost)
VALUES ('222222','wrap', 500); 

INSERT INTO NeededFor(spareID,maintSpareID,amount)
VALUES ('11111111','111456781', 1); 

INSERT INTO Invoice(paymentID,paymentDueDate,beenPayed, costOfWork) 
VALUES ('A1111','01-06-2022', FALSE, 300); 

INSERT INTO BilledBy(payID, maintPayID) 
VALUES ('A1111','111456781'); 

INSERT INTO Operation(operationID, duration, operationType) 
VALUES ('111AA',2,'general'); 

INSERT INTO ConsistsOf(mainOpID, opID) 
VALUES ('111456781','111AA'); 

INSERT INTO DeviceType(manufID,type)
VALUES ('AAA111','lift'); 

INSERT INTO Uses( manufacturerID, operID)
VALUES ('AAA111','111AA'); 

INSERT INTO Device( deviceID,startTime, endTime)
VALUES ('ABC','07-05-2022-1000', '07-05-2022-1200'); 


INSERT INTO KindOf(manuID,devID, devStartTime)
VALUES('AAA111', 'ABC', '07-05-2022-1000'); 

 
CREATE INDEX OperationIndex ON Operation(operationType); 

CREATE INDEX EmployeeIndex ON Employee(workingHours); 


CREATE VIEW CarUnit AS
SELECT licenceNumber, kmDriven, maintenanceID, startTime, endTime, operationID, operationType
FROM Car, Maintenance, DoneOn, Operation, ConsistsOf
WHERE Car.licenceNumber = DoneOn.licenceNr AND Maintenance.maintenanceID = DoneOn.mID AND Maintenance.maintenanceID = ConsistsOf.mainOpID AND ConsistsOf.opID = Operation.operationID; 


CREATE VIEW Humans AS
SELECT socialSecurityNumber, Owner.name AS ownersName, licenceNumber, customerID, Customer.name AS customersName
FROM Owner, OwnedBy, Car, DoneOn, Maintenance, BookedBy, Customer
WHERE Owner.socialSecurityNumber = OwnedBy.ssnr AND OwnedBy.licNr = Car.licenceNumber AND Car.licenceNumber = DoneOn.licenceNr AND DoneOn.mID = Maintenance.maintenanceID AND Maintenance.maintenanceID = BookedBy.mainID AND BookedBy.custID = Customer.customerID; 


CREATE VIEW Machines AS
SELECT maintenanceID, Maintenance.startTime AS reperationStart, Maintenance.endTime AS reperationEnd, operationID, operationType, duration, manufID, type, deviceID, Device.startTime AS deviceStart, Device.endTime AS deviceEnd
FROM Maintenance, ConsistsOf, Operation, Uses, DeviceType, KindOf, Device
WHERE Maintenance.maintenanceID = ConsistsOf.mainOpID AND ConsistsOf.opID = Operation.operationID AND Operation.operationID = Uses.operID AND Uses.manufacturerID = DeviceType.manufID AND DeviceType.manufID = KindOf.manuID AND KindOf.devID = Device.deviceID; 


SELECT *, COUNT(licenceNumber)
FROM CarUnit
WHERE endTime LIKE '%2022%'; 

SELECT COUNT (*)
FROM Employee; 

SELECT ownersName, licenceNumber
FROM Humans; 

SELECT ownersName AS name
FROM Humans
WHERE ownersName = customersName; 

SELECT licenceNumber, kmDriven
FROM Car
ORDER BY kmDriven DESC; 

SELECT employeeID, name, startTime, endTime
FROM Employee, DoneBy, Maintenance
WHERE Employee.employeeID = DoneBy.empID AND DoneBy.maintID = Maintenance.maintenanceID; 
 
SELECT customerID, name, COUNT(*)
FROM Car, DoneOn, Maintenance, BookedBy, Customer
WHERE licenceNumber = licenceNr AND mID = maintenanceID AND maintenanceID = mainID AND custID = customerID
GROUP BY customerID
ORDER BY COUNT(customerID) DESC; 

SELECT customersName, type
FROM Machines, Humans; 

UPDATE  Maintenance 
SET endTime = '09-05-2022-1200'
WHERE (maintenanceID = '123456781' AND startTime = '09-05-2022-0800'); 

INSERT INTO Operation(operationID, duration, operationType)
VALUES ('222BBB', 0.5, 'cleaning'); 

INSERT INTO DeviceType(manufID, type)
VALUES ('BBB222', 'vacuum'); 

INSERT INTO Uses( manufacturerID, operID)
VALUES ('BBB222','222BBB'); 

SELECT operationType, type
FROM Operation, DeviceType, Uses
WHERE Operation.operationID = Uses.operID AND Uses.manufacturerID = DeviceType.manufID; 

SELECT type, deviceID, startTime, endTime
FROM DeviceType, Device, KindOf; 

INSERT INTO Device(deviceID, startTime, endTime)
VALUES ('ABC', '07-05-2022-1200', '07-05-2022-1400'); 

SELECT licenceNr, costOfWOrk, MAX(cost)
FROM SparePart, NeededFor, Maintenance, BilledBy, Invoice, DoneOn
WHERE SparePart.partID = NeededFor.spareID AND NeededFor.maintSpareID = Maintenance.maintenanceID AND BilledBy.maintPayID = Maintenance.maintenanceID AND BilledBy.payID = Invoice.paymentID  AND DoneOn.mID = Maintenance.maintenanceID; 

SELECT * 
FROM Invoice
WHERE beenPayed = FALSE; 

SELECT Customer.name, paymentID
FROM Customer, BookedBy, Maintenance, BilledBy, Invoice, RemainderOf, PaymentRemainder
WHERE Customer.customerID = BookedBy.custID AND BookedBy.mainID = Maintenance.maintenanceID AND
Maintenance.maintenanceID = BilledBy.maintPayID AND BilledBy.payID = Invoice.paymentID AND 
Invoice.paymentID = RemainderOf.remPayID AND RemainderOf.billInfo = PaymentRemainder.billingInformation
AND Invoice.beenPayed = FALSE; 

SELECT CarUnit.licenceNumber, maintenanceID, partID, SUM(cost)
FROM CarUnit, NeededFor, SparePart
WHERE CarUnit.maintenanceID = NeededFor.maintSpareID AND NeededFor.spareID = SparePart.partID; 