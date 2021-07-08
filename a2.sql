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
INSERT INTO query1 (SELECT dname
FROM departmentWithTotalIns 
WHERE inum IN (SELECT MAX(INUM) from departmentWithTotalIns));

--Dropping the view that we created above
DROP VIEW departmentWithTotalIns;

--Query 2

INSERT INTO query2 (SELECT count(sid) AS num
FROM student
WHERE sex = 'F' AND dcode = 'CSC' AND yearofstudy = 4);

--Query 3

--Create view for the total enrolment of the CSC department corressponding to each year between the years 2016 and 2020 inclusive
CREATE VIEW totalenr AS (SELECT year, COUNT(*) AS enrnum
FROM coursesection cs INNER JOIN studentCourse sc
    ON cs.csid = sc.csid
WHERE year >= 2016 AND year <= 2020 AND dcode = 'CSC' 
GROUP BY year);

--Inserting the answer to the query3 table
INSERT INTO query3 (SELECT year
FROM totalenr
WHERE enrnum IN
(SELECT MAX(enrnum) FROM totalenr));

--Dropping the view that we created above
DROP VIEW totalenr;

--Query 4

-- Create a view for all CS course sections
CREATE VIEW cscoursesections AS (
    SELECT DISTINCT cname, semester
    FROM coursesection cs
    INNER JOIN course c
    ON c.cid = cs.cid
    WHERE c.dcode = 'CSC'
);

-- Insert into query 4 all CS courses taught in Summer minus all courses NOT (yes, Roozbeh, NOT...) taught in summer
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

INSERT INTO query5 (
    SELECT dname AS dept, sgi.sid, sfirstname, slastname, avg AS avgGrade
    FROM studentGradeInfo sgi
    INNER JOIN deptmaxavg dma
    ON sgi.dcode = dma.dcode AND sgi.avg = dma.avg
    INNER JOIN department d
    ON d.dcode = sgi.dcode
    INNER JOIN student s
    ON s.sid = sgi.sid
);

--Make a view for max average in each department
-- CREATE VIEW deptmaxavg AS (
--     SELECT s.sid, sg2.dcode, sg2.avg
--     FROM studentgrd sg
--     INNER JOIN student s
--     ON s.sid = sg.sid
--     INNER JOIN (
--         SELECT dcode, MAX(avg) AS avg
--         FROM studentgrd sg
--         INNER JOIN student s
--         ON sg.sid = s.sid
--         GROUP BY dcode
--     ) sg2
--     ON sg.avg = sg2.avg AND s.dcode = sg2.dcode
-- );

--Inserting the answer into the query5 table
-- INSERT INTO query5 (
--         SELECT dname AS dept, s.sid AS sid, sfirstname, slastname, avg as avgGrade
--         FROM deptmaxavg dma
--         INNER JOIN student s
--         ON dma.sid = s.sid
--         INNER JOIN department d
--         ON s.dcode = d.dcode
-- );

--Dropping the view that we created above
DROP VIEW currentc;
DROP VIEW studentgrd;
DROP VIEW studentGradeInfo;
DROP VIEW deptmaxavg;

--Query 6
INSERT INTO query6

--Query 7

--Creating a view for the courses belonging to CS department and with at least 3 students enrolled on them
CREATE VIEW validCsCourse AS (SELECT cid, sc.csid AS csid FROM courseSection cs INNER JOIN studentCourse sc
    ON cs.csid = sc.csid
WHERE dcode = 'CSC'
GROUP BY cid, sc.csid
HAVING COUNT(DISTINCT sid) >= 3);

--Getting the valid cs courses with the average grade correspondig to each
CREATE VIEW validCsCourseInfo AS (SELECT cid, vc.csid, AVG(grade) AS avgmark
FROM validCsCourse vc INNER JOIN studentCourse sc
    ON vc.csid = sc.csid
GROUP BY cid, vc.csid);

--Inserting the answer into query7 table
INSERT INTO query7 (SELECT cname, semester, year, avgmark
FROM validCsCourseInfo vci INNER JOIN courseSection cs 
        ON vci.csid = cs.csid AND vci.cid = cs.cid
    INNER JOIN course c 
        ON  c.cid = cs.cid
WHERE avgmark = (SELECT MIN(avgmark) AS avgmark FROM validCsCourseInfo) OR avgmark = (SELECT MAX(avgmark) AS avgmark FROM validCsCourseInfo));

