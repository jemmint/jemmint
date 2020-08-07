---Candiate Table---
CREATE TABLE Candidate
(
CandidateId INTEGER NOT NULL PRIMARY KEY,
CFName VARCHAR(40) NOT NULL,
CLName VARCHAR(40) NOT NULL,
CPhone VARCHAR(20) NOT NULL,
CStreetNo VARCHAR(30) NOT NULL,
CStreetName VARCHAR(30) NOT NULL,
CCity VARCHAR(30) NOT NULL,
CState VARCHAR(30) NOT NULL,
CZip VARCHAR(10) NOT NULL,
CExperience Text,
CRelExperience Text,
);

---Interviewer Table
CREATE TABLE Interviewer
(
InterviewerId INTEGER NOT NULL PRIMARY KEY,
IFName VARCHAR(40) NOT NULL,
ILName VARCHAR(40) NOT NULL,
IPhone VARCHAR(20) NOT NULL,
IEmail VARCHAR(40) NOT NULL,
IStreetNo VARCHAR(30) NOT NULL,
IStreetName VARCHAR(30) NOT NULL,
ICity VARCHAR(30) NOT NULL,
IState VARCHAR(30) NOT NULL,
IZip VARCHAR(10) NOT NULL,
ISchedule Text
);

---Company Table---
CREATE TABLE Company
(
CompanyId INTEGER NOT NULL PRIMARY KEY,
CompanyName VARCHAR(40) NOT NULL,
CompanyPhone VARCHAR(20) NOT NULL,
CompanyWebsite VARCHAR(20) NOT NULL,
CoStreetNo VARCHAR(30) NOT NULL,
CoStreetName VARCHAR(30) NOT NULL,
CoCity VARCHAR(30) NOT NULL,
CoState VARCHAR(30) NOT NULL,
CoZip VARCHAR(10) NOT NULL,
);

---Position Table---
CREATE TABLE Position
(
PositionId INTEGER NOT NULL PRIMARY KEY,
PositionName VARCHAR(40) NOT NULL,
PositionLevel VARCHAR(20) NOT NULL,
PositionAvailable VARCHAR(5) NOT NULL,
CompanyId INTEGER NOT NULL FOREIGN KEY REFERENCES Company(CompanyId),
CONSTRAINT chk_PositionLevel CHECK (PositionLevel='Internship' OR
PositionLevel='Entry' OR PositionLevel='Executive' OR
PositionLevel='Managerial' OR PositionLevel='Staff'),
CONSTRAINT chk_generic CHECK (PositionAvailable='yes' OR
PositionAvailable='no')
);

---Interview Table---
CREATE TABLE Interview
(
InterviewId INTEGER NOT NULL PRIMARY KEY,
RoundNumber INTEGER NOT NULL,
InterviewDate DATETIME NOT NULL DEFAULT GETDATE(),
CandidateId INTEGER NOT NULL FOREIGN KEY REFERENCES Candidate(CandidateId),
InterviewerId INTEGER NOT NULL FOREIGN KEY REFERENCES
Interviewer(InterviewerId),
PositionId INTEGER NOT NULL FOREIGN KEY REFERENCES Position(PositionId)
);

---Insert data - Candidate table---
INSERT INTO Candidate (CandidateId, CFName, CLName, CPhone, CStreetNo,
CStreetName, CCity, CState, CZip, CExperience, CRelExperience)
VALUES (1, 'Nathan', 'Kerr', '315-555-5555', '112', 'Lafayette Rd',
'Syracuse', 'New York', '13205', 'Database, Business Analysis', 'Database')
INSERT INTO Candidate (CandidateId, CFName, CLName, CPhone, CStreetNo,
CStreetName, CCity, CState, CZip, CExperience, CRelExperience)
VALUES (2, 'Sebastian', 'Chapman', '315-555-6666', '17', 'James St',
'Syracuse', 'New York', '13210', 'Consultant, Business Analysis',
'Consultant')
INSERT INTO Candidate (CandidateId, CFName, CLName, CPhone, CStreetNo,
CStreetName, CCity, CState, CZip, CExperience, CRelExperience)
VALUES (3, 'Heather', 'Cameron', '315-555-7777', '410', 'Comstock Ave',
'Syracuse', 'New York', '13210', 'Developer, Business Analysis', 'Developer')
INSERT INTO Candidate (CandidateId, CFName, CLName, CPhone, CStreetNo,
CStreetName, CCity, CState, CZip, CExperience, CRelExperience)
VALUES (4, 'Olivia','Wallace', '315-555-8888', '4248', 'Nottingham Rd',
'Syracuse', 'New York', '13244', 'Database, Business Analysis', 'Database')
INSERT INTO Candidate (CandidateId, CFName, CLName, CPhone, CStreetNo,
CStreetName, CCity, CState, CZip, CExperience, CRelExperience)
VALUES (5, 'Lily', 'Turner', '315-556-9999', '3', 'Ostrom Ave', 'Syracuse',
'New York', '13225', 'Database, Business Analysis, Developer, Analyst',
'Database');

---Insert data - Interviewer table---
INSERT INTO Interviewer (InterviewerId, IFName, ILName, IPhone, IEmail,
IStreetNo, IStreetName, ICity, IState, IZip, ISchedule)
VALUES (1, ' Dorothy', ' Paige', '315-555-0126', 'dorothy.paige@syr.edu',
'137', 'Sumner Ave', 'Syracuse', 'New York', '13210', '9am-5pm Monday –
Friday')
INSERT INTO Interviewer (InterviewerId, IFName, ILName, IPhone, IEmail,
IStreetNo, IStreetName, ICity, IState, IZip)
VALUES (2, 'Amy', 'May', '315-5555', 'amy.may@syr.edu', '777', 'Ackerman
Ave', 'Syracuse', 'New York', '13210')
INSERT INTO Interviewer (InterviewerId, IFName, ILName, IPhone, IEmail,
IStreetNo, IStreetName, ICity, IState, IZip, ISchedule)
VALUES (3, 'Charles', 'Duncan', '315-444-5555', 'charles.duncan@syr.edu',
'345', 'Lancaster Ave', 'Syracuse', 'New York', '13210', '8am-6pm Monday –
Saturday')
INSERT INTO Interviewer (InterviewerId, IFName, ILName, IPhone, IEmail,
IStreetNo, IStreetName, ICity, IState, IZip)
VALUES (4, 'Victor', 'Miller', '315-333-5565', 'victor.miller@syr.edu',
'7116', 'Lafayette Rd', 'Syracuse', 'New York', '13205')
INSERT INTO Interviewer (InterviewerId, IFName, ILName, IPhone, IEmail,
IStreetNo, IStreetName, ICity, IState, IZip, ISchedule)
VALUES (5, 'Ray', 'Mysterio', '315-129-5677', 'raymesterio@syr.edu', '234',
'Lafayette Rd', 'Syracuse', 'New York', '13205', '9:30am-5:30pm Monday –
Friday');

---Insert data - Company table---
INSERT INTO Company (CompanyId, CompanyName, CompanyPhone, CompanyWebsite,
CoStreetNo, CoStreetName, CoCity, CoState, CoZip)
VALUES (1, 'Ernst & Young', '315-129-5677', 'www.ey.com', '234', 'Lafayette
Rd', 'New York', 'New York', '13205')
INSERT INTO Company (CompanyId, CompanyName, CompanyPhone, CompanyWebsite,
CoStreetNo, CoStreetName, CoCity, CoState, CoZip)
VALUES (2, 'Deloitte', '315-356-5887', 'www.deloitte.com', '456', 'Summer
Ave', 'New York', 'New York', '13100')
INSERT INTO Company (CompanyId, CompanyName, CompanyPhone, CompanyWebsite,
CoStreetNo, CoStreetName, CoCity, CoState, CoZip)
VALUES (3, 'PWC', '315-894-4787', 'www.pwc.com', '791', 'Maryland Ave',
'New York', 'New York', '13801')
INSERT INTO Company (CompanyId, CompanyName, CompanyPhone, CompanyWebsite,
CoStreetNo, CoStreetName, CoCity, CoState, CoZip)
VALUES (4, 'KPMG', '315-129-5677', 'www.kpmg.com', '437', 'Lanchaster Ave',
'New York', 'New York', '12147')
INSERT INTO Company (CompanyId, CompanyName, CompanyPhone, CompanyWebsite,
CoStreetNo, CoStreetName, CoCity, CoState, CoZip)
VALUES (5, 'Cognizant', '315-479-5182', 'www.cognizant.com', '825',
'Ackerman Street', 'New York', 'New York', '10071');

---Insert data - Position table---
INSERT INTO Position (PositionId, PositionName, PositionLevel,
PositionAvailable, CompanyId)
VALUES (1, 'Techology Analyst', 'Internship', 'yes', '1')
INSERT INTO Position (PositionId, PositionName, PositionLevel,
PositionAvailable, CompanyId)
VALUES (2, 'Business Analyst', 'Entry', 'yes', '1')
INSERT INTO Position (PositionId, PositionName, PositionLevel,
PositionAvailable, CompanyId)
VALUES (3, 'Database Analyst', 'Executive', 'yes', '2')
INSERT INTO Position (PositionId, PositionName, PositionLevel,
PositionAvailable, CompanyId)
VALUES (4, 'Risk Manager', 'Executive', 'no', '3')
INSERT INTO Position (PositionId, PositionName, PositionLevel,
PositionAvailable, CompanyId)
VALUES (5, 'Advisory Consultant', 'Staff', 'yes', '4')
INSERT INTO Position (PositionId, PositionName, PositionLevel,
PositionAvailable, CompanyId)
VALUES (6, 'Project Manager', 'Managerial', 'no', '5');

---Insert data - Interview table---
INSERT INTO Interview(InterviewId, RoundNumber, InterviewDate, CandidateId,
InterviewerId, PositionId)
VALUES (1,2,'2013-09-27 00:00:00.000',1,1,1);
INSERT INTO Interview(InterviewId, RoundNumber, InterviewDate, CandidateId,
InterviewerId, PositionId)
VALUES (2,1,'2013-09-28 00:00:00.000',2,2,2);
INSERT INTO Interview(InterviewId, RoundNumber, InterviewDate, CandidateId,
InterviewerId, PositionId)
VALUES (3,3,'2013-09-17 00:00:00.000',3,3,1);
INSERT INTO Interview(InterviewId, RoundNumber, CandidateId, InterviewerId,
PositionId)
VALUES (4,2,1,2,1);
INSERT INTO Interview(InterviewId, RoundNumber, InterviewDate, CandidateId,
InterviewerId, PositionId)
VALUES (5,5,'2013-09-17 00:00:00.000',5,5,5);

---Candidates in round 2---
SELECT c.CandidateId, c.CFName, c.CLName, c.CPhone, c.CExperience, c.CRelExperience
FROM Candidate c
FULL OUTER JOIN Interview iw ON c.CandidateId = iw.CandidateId
WHERE iw.RoundNumber = 2;

---Positions conducted by "Amy May"---
SELECT p.PositionId,PositionName, p.PositionLevel,p.PositionAvailable
FROM Position p
FULL OUTER JOIN Interview iw ON p.PositionId = iw. PositionId
FULL OUTER JOIN Interviewer iwr ON iw.InterviewerId = iwr.InterviewerId
WHERE iwr.IFName='Amy' AND iwr.ILName='May';


---Interviewers conducted one or more second round interviews---
SELECT  iwr.InterviewerId, iwr.IPhone, iwr.IEmail, iwr.IStreetNo, 
	iwr.IStreetName, iwr.ICity, iwr.IState, iwr.IZip, iwr.ISchedule
FROM Interviewer iwr
JOIN Interview iw ON iwr.InterviewerId=iw.InterviewerId
WHERE iw.RoundNumber=2;

---Candidates for "Advisory Consultant"---
SELECT *
FROM Candidate c
FULL OUTER JOIN Interview iw ON c.CandidateId = iw.CandidateId
INNER JOIN Position p ON p.PositionId=iw.PositionId
WHERE PositionName = 'Advisory Consultant';

---Position on Sept 28th 2013---
SELECT p.PositionId,PositionName, p.PositionLevel,p.PositionAvailable
FROM Position AS p,Interview AS iw
WHERE p.PositionId = iw.PositionId AND iw.InterviewDate='2013-09-28 00:00:00.000';

SELECT p.PositionId,p.PositionLevel,PositionName, p.PositionAvailable
FROM Position p
JOIN Interview iw ON p.PositionId = iw.PositionId
WHERE iw.InterviewDate='2013-09-28 00:00:00.000';