SET search_path TO A2;

--If you define any views for a question (you are encouraged to), you must drop them
--after you have populated the answer table for that question.
--Good Luck!

--Query 1

--Creating a view containing the department with the total number of their instuctors

CREATE VIEW departmentWithTotalIns AS (SELECT dname, COUNT(*) AS inum
FROM department d INNER JOIN instructor i 
    ON d.dcode = i.dcode
WHERE idegree <> 'PhD'
GROUP BY dname);

--Inserting the answer into the query1 table
CREATE TABLE query1 (dname VARCHAR(20));
INSERT INTO query1 (SELECT dname
FROM departmentWithTotalIns 
WHERE inum IN (SELECT MAX(INUM) from departmentWithTotalIns));

--Dropping the view that we created above
DROP VIEW departmentWithTotalIns;

--Query 2
CREATE TABLE query2 (num INTEGER);
INSERT INTO query2 (SELECT count(sid) AS num 
FROM student, department 
WHERE student.dcode=department.dcode 
AND yearofstudy=4 and dname= 'Computer Science' AND sex='F');

--Query 3

--Create view for the total enrolment of the CSC department corressponding to each year between the years 2016 and 2020 inclusive
CREATE VIEW totalenr AS (SELECT year, COUNT(*) AS enrnum
FROM coursesection cs, studentCourse sc, department d
WHERE cs.csid=sc.csid AND cs.dcode=d.dcode AND year >= 2016 AND year <= 2020 AND dname = 'Computer Science'
GROUP BY year);

--Inserting the answer to the query3 table
CREATE TABLE query3 (num year INTEGER, enrollment INTEGER);
INSERT INTO query3 (SELECT year, enrnum AS enrollment
FROM totalenr
WHERE enrnum IN
(SELECT MAX(enrnum) FROM totalenr));

--Dropping the view that we created above
DROP VIEW totalenr;

--Query 4

-- Create a view for all CS course sections
CREATE VIEW cscoursesections AS (
    SELECT DISTINCT cname, semester
    FROM coursesection cs, course c, department d
    WHERE cs.cid=c.cid AND cs.dcode=d.dcode AND dname='Computer Science'
);

-- Insert into query 4 all CS courses taught in Summer minus all courses NOT (yes, Roozbeh, NOT...) taught in summer
CREATE TABLE query4 (cname VARCHAR(20));
INSERT INTO query4 (
    (SELECT cname
     FROM cscoursesections
     WHERE semester = 5)
    EXCEPT
    (SELECT cname
     FROM cscoursesections
     WHERE semester <> 5)
);

-- Drop the view created above
DROP VIEW cscoursesections;

--Query 5

--Make a view for the last year, semester pair that courses have been offered at (current course)
CREATE VIEW currentc AS (SELECT year, MAX(semester) AS semester
FROM coursesection
WHERE year = (SELECT MAX(year) 
              FROM coursesection)
GROUP BY year);
--Make a view for all students with their average over all thier non current courses
CREATE VIEW studentgrd AS (SELECT sid, AVG(grade) AS avg 
FROM studentcourse sc INNER JOIN coursesection cs
    ON sc.csid = cs.csid
WHERE (year, semester) NOT IN (SELECT year, semester 
                               FROM currentc)
                               GROUP BY sid);

-- Make a view for students with their grade and the department they belong to
CREATE VIEW studentGradeInfo AS (
    SELECT sg.sid, avg, dcode
    FROM studentgrd sg INNER JOIN student s
    ON sg.sid = s.sid
);

-- Make a view for max average in each department
CREATE VIEW deptmaxavg AS (
    SELECT dcode, MAX(avg) AS avg
    FROM studentgrd sg
    INNER JOIN student s
    ON sg.sid = s.sid
    GROUP BY dcode
);

CREATE TABLE query5 (dept VARCHAR(20), sid INTEGER, sfirstname VARCHAR(20), slastname VARCHAR(20), avgGrade FLOAT);
INSERT INTO query5 (
    SELECT dname AS dept, sgi.sid, sfirstname, slastname, sgi.avg AS avgGrade
    FROM studentGradeInfo sgi
    INNER JOIN deptmaxavg dma
    ON sgi.dcode = dma.dcode AND sgi.avg = dma.avg
    INNER JOIN department d
    ON d.dcode = sgi.dcode
    INNER JOIN student s
    ON s.sid = sgi.sid
);

--Dropping the view that we created above
DROP VIEW deptmaxavg;
DROP VIEW studentGradeInfo;
DROP VIEW studentgrd;
DROP VIEW currentc;




--Query 6

-- Get all student courses taken with their corresponding sections
CREATE VIEW coursesectionstaken AS (
    SELECT sc.sid, cs.cid, cs.dcode, cs.csid, cs.year, cs.semester
    FROM studentcourse sc
    INNER JOIN coursesection cs
    ON sc.csid = cs.csid
);

-- Get all student courses taken with an entry for each corresponding prerequisite
CREATE VIEW studentscourseprereqs AS (
    SELECT cst.sid, cst.dcode, cst.cid, cst.year, cst.semester, p.pdcode, p.pcid
    FROM coursesectionstaken cst
    INNER JOIN prerequisites p
    ON cst.dcode = p.dcode AND cst.cid = p.cid
);

-- Get all student courses taken with a count of how many prerequisites each has
CREATE VIEW studentscourseprereqscount AS (
    SELECT scpr.sid, scpr.dcode, scpr.cid, scpr.year, scpr.semester, COUNT(*) AS numofprerequisites
    FROM studentscourseprereqs scpr
    GROUP BY scpr.sid, scpr.dcode, scpr.cid, scpr.year, scpr.semester
);

-- Get all student courses taken with a count of how many prerequisites of each were taken by the same student at a prior time
CREATE VIEW studentscourseprereqstakencount AS (
    SELECT scpr.sid, scpr.dcode, scpr.cid, scpr.year, scpr.semester, COUNT(*) AS numofprerequisites
    FROM studentscourseprereqs scpr
    INNER JOIN coursesectionstaken cst
    ON scpr.sid = cst.sid AND scpr.pdcode = cst.dcode AND scpr.pcid = cst.cid
    WHERE cst.year < scpr.year OR cst.year = scpr.year AND cst.semester < scpr.semester
    GROUP BY scpr.sid, scpr.dcode, scpr.cid, scpr.year, scpr.semester
);

-- Get the student courses taken with prerequisite count equal to number of prerequisites completed count
CREATE VIEW studentcourseswithprereqstaken AS (
    (SELECT * FROM studentscourseprereqscount)
    EXCEPT
    (SELECT * FROM studentscourseprereqstakencount)
);

CREATE TABLE query6 (fname VARCHAR(20), lname VARCHAR(20), cname VARCHAR(20), year INTEGER, semester INTEGER);
INSERT INTO query6 (
    SELECT s.sfirstname AS fname, s.slastname AS lname, c.cname, scpt.year, scpt.semester
    FROM studentcourseswithprereqstaken scpt
    INNER JOIN student s
    ON scpt.sid = s.sid
    INNER JOIN course c
    ON scpt.dcode = c.dcode AND scpt.cid = c.cid
);

DROP VIEW studentcourseswithprereqstaken;
DROP VIEW studentscourseprereqstakencount;
DROP VIEW studentscourseprereqscount;
DROP VIEW studentscourseprereqs;
DROP VIEW coursesectionstaken;

--Query 7

--Creating a view for the courses belonging to CS department and with at least 3 students enrolled on them
CREATE VIEW validCsCourse AS (SELECT cid, sc.csid AS csid FROM courseSection cs INNER JOIN studentCourse sc
    ON cs.csid = sc.csid
    INNER JOIN department d
    ON d.dcode = cs.dcode 
WHERE dname = 'Computer Science'
GROUP BY cid, sc.csid
HAVING COUNT(DISTINCT sid) >= 3);

--Getting the valid cs courses with the average grade correspondig to each
CREATE VIEW validCsCourseInfo AS (SELECT cid, vc.csid, AVG(grade) AS avgmark
FROM validCsCourse vc INNER JOIN studentCourse sc
    ON vc.csid = sc.csid
GROUP BY cid, vc.csid);

--Inserting the answer into query7 table
CREATE TABLE query7 (cname VARCHAR(20), semester INTEGER, year INTEGER, avgmark FLOAT);
INSERT INTO query7 (SELECT cname, semester, year, avgmark
FROM validCsCourseInfo vci INNER JOIN courseSection cs 
        ON vci.csid = cs.csid AND vci.cid = cs.cid
    INNER JOIN course c 
        ON  c.cid = cs.cid
WHERE avgmark = (SELECT MIN(avgmark) AS avgmark FROM validCsCourseInfo) OR avgmark = (SELECT MAX(avgmark) AS avgmark FROM validCsCourseInfo));

DROP VIEW validCsCourseInfo;
DROP VIEW validCsCourse;