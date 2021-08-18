--Q1
SELECT DISTINCT FirstName, SalaryPerDay, Name AS ProjectName, Description AS ProjectDescription
FROM Project JOIN
(SELECT PID AS Res3PID, SalaryPerDay , FirstName
FROM ProjectConstructorEmployee JOIN(
SELECT Employee.EID AS Res2EID, Employee.FirstName, ConstructorEmployee.SalaryPerDay
FROM ConstructorEmployee JOIN Employee
ON Employee.EID = ConstructorEmployee.EID) 
ON ProjectConstructorEmployee.EID = Res2EID)
ON Project.PID = Res3PID

--Q2
SELECT E.* , D.Name
FROM
OfficialEmployee AS OE JOIN Employee AS E ON OE.EID = E.EID
JOIN
Department AS D ON D.DID = OE.Department
WHERE OE.Department IS NOT NUll
UNION
SELECT E.*, P.Name 
FROM 
ConstructorEmployee AS CE JOIN ProjectConstructorEmployee AS PCE ON CE.EID = PCE.EID
JOIN 
Employee AS E ON E.EID = CE.EID
JOIN
Project AS P ON P.PID = PCE.PID
WHERE PCE.EndWorkingDate =
(SELECT MAX(EndWorkingDate) FROM ProjectConstructorEmployee AS PCE2 WHERE E.EID = PCE2.EID)


--Q3
SELECT N.Name, COUNT(*) AS NumberOfApartments
FROM Apartment AS A JOIN Neighborhood AS N ON A.NID = N.NID
GROUP BY N.Name, N.NID
ORDER BY NumberOfApartments ASC

--Q4
SELECT R.FirstName, R.LastName, A.StreetName , A.Number , A.Door
FROM 
Apartment AS A LEFT OUTER JOIN Resident AS R 
ON (R.StreetName = A.StreetName AND R.Number = A.Number AND R.Door = A.Door)

--Q5
SELECT *
FROM ParkingArea
WHERE MaxPricePerDay = (
SELECT min(MaxPricePerDay)
FROM ParkingArea)


--Q6
SELECT DISTINCT C.CID, C.ID
FROM Cars AS C JOIN ( CarParking AS CP JOIN
(SELECT AID AS minAID FROM ParkingArea AS PA
WHERE MaxPricePerDay = (SELECT min(MaxPricePerDay) FROM ParkingArea))
ON CP.AID = minAID)
ON C.CID = CP.CID

--Q7
SELECT R.RID, R.FirstName, R.LastName
FROM 
Resident AS R JOIN Apartment AS A ON R.StreetName=A.StreetName AND R.Number=A.Number AND R.Door=A.Door
JOIN Cars AS C ON C.ID = RID
JOIN CarParking AS CP ON CP.CID = C.CID
JOIN ParkingArea AS PA ON PA.AID = CP.AID AND A.NID = PA.NID
WHERE R.RID NOT IN (
SELECT R2.RID
FROM Resident AS R2 JOIN Cars AS C2 ON R2.RID = C2.ID
JOIN CarParking AS CP2 ON CP2.CID = C2.CID
JOIN Apartment AS A2 ON R2.StreetName=A2.StreetName AND R2.Number=A2.Number AND R2.Door=A2.Door
JOIN ParkingArea AS PA2 ON A2.NID <> PA2.NID AND PA2.AID = CP2.AID
GROUP BY R2.RID
)
GROUP BY R.RID 

--Q8
SELECT RID,FirstName,LastName
FROM
(SELECT RID,FirstName,LastName,count(RID) as counter
FROM
(SELECT DISTINCT RID,FirstName,LastName,C.CID, AID
FROM Resident AS R JOIN Cars AS C ON R.RID=C.ID JOIN CarParking AS CP ON CP.CID=C.CID)
GROUP BY RID)
WHERE counter= (SELECT count(AID) FROM ParkingArea)


--Q9
CREATE VIEW r_ngbrhd AS 
SELECT * FROM Neighborhood
WHERE Name LIKE 'R%';