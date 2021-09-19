use master
go
if exists (
			select * from sys.sysdatabases
			where name = 'Learning_To_Teach')
drop database Learning_To_Teach
go

create database Learning_To_Teach
go

-----"Learning_To_Teach" Teachers' College----------
use Learning_To_Teach
go


--------------------Departments Table---------------------------
create table Department(
DepartmentNumber int identity (1,1) constraint ds_p_k Primary Key,
DepartmentName varchar(15)
);
go

-------------------Teachers Table---------------------------------
create table Teachers(
TeacherID int constraint tid_p_k Primary Key,
TitleOfCourtesy varchar (10) not null constraint CK_TOC_title check (TitleOfCourtesy in ('Dr', 'professor')),
FirstName varchar(15) Not null,
LastName varchar(15) Not null,
Address varchar(35),
City varchar(15),
Phone varchar(12) not null constraint ts_phone_uq  unique constraint ts_phone_len check  (phone like '___-_______'),
Email varchar (50),
HireDate date not null constraint CK_HD_notm check (YEAR(HireDate)< year(getdate())),
Seniority int,
Salary money default 10000 not null
);
go

--------------------Students Table---------------------------
create table Students(
StudentID int constraint sid_p_k Primary Key,
FirstName varchar(15) not null,
LastName varchar(15) not null,
Address varchar(35),
City varchar(15),
Phone varchar(12) not null constraint st_phone_uq  unique constraint st_phone_len check  (phone like '___-_______'),
Email varchar (50) 
);
go

--------------------Courses Table---------------------------
create table Courses(
CoursesDepartmentNumber int foreign key references Department (DepartmentNumber),
CourseID int Primary Key identity (1,1),
CourseName varchar (30) unique not null, 
TeacherID int foreign key references teachers (TeacherID), 
FirstTask varchar(11) constraint CK_FT_tp check (FirstTask in ('test', 'paperwark')),
SecondTask varchar(11) constraint CK_ST_tp check (SecondTask in ('test', 'paperwark'))
);
go

--------------------Semester Table---------------------------
create table Semester(
NumberID  int identity (1,1) constraint st_p_k Primary Key,
SchoolYear int,
SemesterType varchar(11)  check (SemesterType in ('Winter', 'Summer')),
StartDate date not null ,
FirstTaskDate date,
SecondTaskDate date,
SemesterEnd Date 
);
go

--------------------Student Degree Table---------------------------
create table StudentDegree(
DegreeID  int identity (1,1) constraint sd_p_k Primary Key,
StudentID int foreign key references Students(StudentID),
StudentsDepartmentNumber int foreign key references Department(DepartmentNumber),
StartDate date not null,
finishdate date not null
);
go

--------------------Student Degree Table---------------------------
create table DegreeDetails(
DegreeDetailsID  int identity (1,1) constraint DD_p_k Primary Key,
StudentID int foreign key references Students(StudentID),
courseID int foreign key references  courses (CourseID),
SemesterNumberID  int foreign key references Semester(NumberID),
FirstTaskMark int,
SecondTaskMark  int,
courseMark  int 
);
go



-----------Insert Departments Table-----------------------------------------
insert into Department(DepartmentName) VALUES ('Mathematics'),('English'),('Language')
go

-----------Insert Teachers Table-----------------------------------------
INSERT INTO Teachers([TeacherID],TitleOfCourtesy,[FirstName],[LastName],Address, City, Phone,[HireDate]) VALUES
('339676690','Dr','Colleen','Clayton', 'David Flusser 14','jerusalem','058-4751224','2019-09-17'),
('398959884','Dr','Ifeoma','Rowland','moshe sharet 12','tel-aviv','058-4137045','2018-12-29 '),
('376303004','professor','Aspen','Ellis','david elazar 23', 'netnya','054-9224200','2019-04-21'),
('147152477','professor','Caldwell','cohen','meir dagan 45', 'netnya','054-8085053','2020-11-04 '),
('449640616','Dr','Yvette','Frost','yasmin 46', 'jaffo','054-6785471','2020-01-01 '),
('387407839','Dr','Laith','Talley','vered 61', 'jaffo','054-3125504','2020-11-28 '),
('76688435', 'professor','Amos','Hoffman','haliya 29', 'rosh-hain','054-2551773','2020-05-22 '),
('273099042', 'professor','Lucy','Bryan','hamaapilim 20', 'rosh-hain','052-8456010','2020-05-29 '),
('111189056','Dr','Stone','Brennan','moshe dayan 12','tel-aviv','052-6260500','2020-09-27 '),
('417727787', 'professor','Stewart','Buckner','yigal yadin 12','tel-aviv','052-2952380','2020-07-11 ');
go
-------------update Teachers Table-----------------------------------------
update Teachers set email=FirstName+left(lastname,1)+'@gmail.com'
update Teachers set Seniority=datediff(y,YEAR(HireDate), year(getdate()))
update Teachers set salary=10000+(Seniority*3000)
go

-----------Insert Students Table-----------------------------------------
INSERT INTO Students([StudentID],[FirstName],[LastName],[Address], City,Phone) 
VALUES('424165743','Orson','Rivers','hagefen 20', 'rosh-hain', '054-4821123'), ('969130284','Zephania','Knight', 'hadas 2', 'tel-aviv', '054-5551123'), 
('175974652','Dominic','Maldonado','haetzel 6', 'jaffo', '054-7773512'),('275959634','Rama','Dudley','nili 23', 'netnya', '052-6801245'),
('439268557','Grady','Finch','hagefen 9', 'jerusalem', '054-7771028'),('186444280','Galvin','Simpson','habrosh 52', 'tel-aviv', '054-1234567'),
('186673816','Gloria','Craig','hrimon 43','haifa', '052-7654321'),('449372255','Breanna','Bryan','hapalmach 54','tel-aviv', '053-7774511'),
('348552295','Bianca','Sanders','golani 98', 'tevrya', '054-9876543'), ('401408371','Quyn','Mcintyre','givati 11','jerusalem','054-3989385')
go
-------------update Students Table-----------------------------------------
update Students set Email=FirstName+left(lastname,1)+'@gmail.com'
go

-----------Insert courses Table-----------------------------------------
INSERT INTO  courses (CoursesDepartmentNumber,courseName, TeacherID, FirstTask,SecondTask) values
(1,'differential calculus','339676690', 'test','test' ),(1,'algebra','339676690', 'test','test' ), 
(1,'geometry','398959884', 'test','test' ), (1,'statistics','339676690', 'test','test' ),
(2,'grammar','376303004', 'test','test' ), (2,'VerbsAndNouns','376303004', 'test','test' ), (2,'book report','147152477', 'paperwark','paperwark' ), 
(3,'syntax','449640616', 'test','test' ), (3,'HebrewVerbs','449640616', 'test','test' ), (3,'argument text','273099042', 'paperwark','paperwark' )
go

-----------Insert courses Table-----------------------------------------
insert into Semester (SemesterType,StartDate,SemesterEnd) values
('Winter','2018-10-14','2019-01-18'), ('Summer','2019-03-10','2019-06-28'),
('Winter','2019-10-19','2020-01-20'), ('Summer','2020-03-15','2021-06-30'),
('Winter','2020-10-18','2021-01-22'), ('Summer','2021-03-14','2021-06-30')
go
-------------alter Semester Table-----------------------------------------
alter table Semester add constraint semesterEnd check (StartDate< SemesterEnd)
go
-------------update courses Table-----------------------------------------
update Semester set SchoolYear=year(StartDate)
update Semester set FirstTaskDate= DATEADD(d, 40,StartDate)
update Semester set SecondTaskDate= DATEADD(d, 80,StartDate)


-----------Insert StudentDegree Table-----------------------------------------
insert into StudentDegree (StudentID,StudentsDepartmentNumber,StartDate, finishdate) values
(175974652,1,'2018-10-14', '2019-01-18'),(969130284,1,'2020-10-18', '2021-01-22'),
(186444280,1,'2018-10-14', '2019-01-18'),(186673816,2,'2020-10-18', '2021-01-22'),
(275959634,2,'2019-03-10', '2019-06-28'),(348552295,2,'2020-03-15', '2021-06-30'),
(401408371,3,'2019-03-10', '2019-06-28'),(424165743,3,'2020-03-15', '2021-06-30'),
(439268557,3,'2019-10-19', '2020-01-20'),(449372255,3,'2019-10-19', '2020-01-20')
go

-----------Insert DegreeDetails Table-----------------------------------------
insert into DegreeDetails(StudentID,courseID,SemesterNumberID,FirstTaskMark,SecondTaskMark) values
(175974652,1,1, 82,90), (175974652,2,1, 75,70), (175974652,3,2, 69,70), (175974652,4,2, 75,71), 
(969130284,1,1, 68,91), (969130284,2,1, 66,70), (969130284,3,2, 69,80), (969130284,4,2, 87,92), 
(186444280,1,1, 87,67), (186444280,2,1, 90,80), (186444280,3,2, 89,90), (186444280,4,2, 67,77), 
(186673816,5,1, 81,69), (186444280,6,1, 75,70), (186444280,7,2, 89,90), 
(275959634,5,1, 87,67), (275959634,6,1, 69,70), (275959634,7,2, 89,90),
(348552295,5,1, 75,70), (348552295,6,1, 70,80), (348552295,7,2, 69,70),
(401408371,8,1, 67,77), (401408371,9,1, 90,80), (401408371,10,2, 69,70),
(424165743,8,1, 100,70), (424165743,9,1, 68,77), (424165743,10,2, 69,70),
(439268557,8,1, 80,75), (439268557,9,1, 68,91), (439268557,10,2, 67,77),
(449372255,8,1, 79,72), (449372255,9,1, 90,80), (449372255,10,2, 68,91)
go
update DegreeDetails set courseMark=(FirstTaskMark+SecondTaskMark)/2
go

