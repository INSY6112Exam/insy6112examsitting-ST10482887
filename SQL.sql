
CREATE SCHEMA IF NOT EXISTS MedicalPractice;
USE MedicalPractice;

-- 2. Drop tables if they already exist (to avoid errors)
DROP TABLE IF EXISTS Appointments;
DROP TABLE IF EXISTS Doctor;
DROP TABLE IF EXISTS MedicalPatient;


CREATE TABLE MedicalPatient (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    PatientName VARCHAR(50),
    PatientSurname VARCHAR(50),
    DateOfBirth DATE
);

CREATE TABLE Doctor (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    DoctorName VARCHAR(50),
    DoctorSurname VARCHAR(50)
);

CREATE TABLE Appointments (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    AppointmentDate DATE,
    AppointmentTime TIME,
    Duration SMALLINT,
    DoctorID INT,
    PatientID INT,
    FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
    FOREIGN KEY (PatientID) REFERENCES MedicalPatient(PatientID)
);

INSERT INTO MedicalPatient (PatientName, PatientSurname, DateOfBirth)
VALUES
('Debbie', 'Theart', '1980-03-17'),
('Thomas', 'Duncan', '1976-08-12');

INSERT INTO Doctor (DoctorName, DoctorSurname)
VALUES
('Zintle', 'Nukani'),
('Ravi', 'Maharaj');

INSERT INTO Appointments (AppointmentDate, AppointmentTime, Duration, DoctorID, PatientID)
VALUES
('2024-01-15', '09:00:00', 15, 2, 1),
('2024-01-18', '15:00:00', 30, 2, 2),
('2024-01-20', '10:00:00', 15, 1, 1),
('2024-01-21', '11:00:00', 15, 2, 1);

-- 5. Example queries

-- Appointments between two dates
SELECT *
FROM Appointments
WHERE AppointmentDate BETWEEN '2024-01-16' AND '2024-01-20';


SELECT 
    p.PatientName,
    p.PatientSurname,
    COUNT(a.AppointmentID) AS TotalAppointments
FROM MedicalPatient p
JOIN Appointments a ON p.PatientID = a.PatientID
GROUP BY p.PatientName, p.PatientSurname
ORDER BY TotalAppointments DESC;


SELECT 
    a.AppointmentDate,
    a.AppointmentTime,
    d.DoctorName,
    d.DoctorSurname,
    p.PatientName,
    p.PatientSurname
FROM Appointments a
JOIN Doctor d ON a.DoctorID = d.DoctorID
JOIN MedicalPatient p ON a.PatientID = p.PatientID
ORDER BY a.AppointmentDate DESC, a.AppointmentTime;


CREATE OR REPLACE VIEW Doctor2Patients AS
SELECT DISTINCT 
    p.PatientName,
    p.PatientSurname
FROM Appointments a
JOIN MedicalPatient p ON a.PatientID = p.PatientID
WHERE a.DoctorID = 2
ORDER BY p.PatientSurname ASC;


DELIMITER $$
CREATE PROCEDURE get_appointments(IN appt_date DATE)
BEGIN
    SELECT 
        a.AppointmentTime,
        a.Duration,
        d.DoctorName,
        d.DoctorSurname,
        p.PatientName,
        p.PatientSurname
    FROM Appointments a
    JOIN Doctor d ON a.DoctorID = d.DoctorID
    JOIN MedicalPatient p ON a.PatientID = p.PatientID
    WHERE a.AppointmentDate = appt_date
    ORDER BY a.AppointmentTime ASC;
END$$
DELIMITER ;
