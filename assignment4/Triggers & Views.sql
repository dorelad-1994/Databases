
CREATE VIEW ConstructorEmployeeOverFifty AS 
SELECT E.EID , E.FirstName , E.LastName , E.BirthDate , E.Door , E.Number , E.StreetName , E.City , CE.CompanyName , CE.SalaryPerDay
FROM Employee as E JOIN ConstructorEmployee as CE 
ON E.EID = CE.EID 
WHERE ((SELECT (cast(strftime('%Y.%m%d', 'now') - strftime('%Y.%m%d', E.BirthDate) as int)))  >= 50);


CREATE VIEW ApartmentNumberInNeighborhood AS
SELECT N.NID, count(*) As ApartmentNumber
FROM Neighborhood AS N LEFT JOIN Apartment as A
ON N.NID = A.NID
GROUP BY N.NID;


-- Add Triggers Here, do not forget to separate the triggers with ;

CREATE TRIGGER delete_employee
BEFORE DELETE ON Project 
BEGIN
DELETE FROM ProjectConstructorEmployee 
WHERE  ProjectConstructorEmployee.PID = OLD.PID;
DELETE FROM CellPhone WHERE EID not in (SELECT EID FROM ProjectConstructorEmployee);
DELETE FROM ConstructorEmployee WHERE EID not in (SELECT EID FROM ProjectConstructorEmployee);
DELETE FROM Employee WHERE EID not in (SELECT EID FROM ConstructorEmployee UNION SELECT EID FROM OfficialEmployee);
END;

 
CREATE TRIGGER manger_offical_update
BEFORE UPDATE ON Department
BEGIN
  SELECT CASE 
  WHEN new.ManagerID in (SELECT ManagerID FROM(SELECT ManagerID, count(*) as c FROM Department GROUP BY ManagerID Having c>=2))
  THEN RAISE (ABORT , 'violation of maximum mangement department')
  END;  
END;
