DROP SCHEMA IF EXISTS A2 CASCADE;
CREATE SCHEMA A2;
SET search_path TO A2;
CREATE TABLE department (dcode CHAR(3) PRIMARY KEY, dname VARCHAR(20) NOT NULL);
CREATE TABLE student (sid INTEGER PRIMARY KEY, slastname CHAR(20) NOT NULL, sfirstname CHAR(20) NOT NULL, sex CHAR(1) NOT NULL, age INTEGER NOT NULL, dcode CHAR(3) NOT NULL, yearofstudy INTEGER NOT NULL, FOREIGN KEY (dcode) REFERENCES department(dcode) ON DELETE RESTRICT);
CREATE TABLE instructor (iid INTEGER PRIMARY KEY, ilastname CHAR(20) NOT NULL, ifirstname CHAR(20) NOT NULL, idegree CHAR (5) NOT NULL, dcode CHAR(3) NOT NULL, FOREIGN KEY (dcode) REFERENCES department(dcode) ON DELETE RESTRICT);
CREATE TABLE course (cid INTEGER, dcode CHAR(3) REFERENCES DEPARTMENT(dcode) ON DELETE RESTRICT, cname CHAR(20) NOT NULL, PRIMARY KEY (cid, dcode));
CREATE TABLE courseSection (csid INTEGER PRIMARY KEY, cid INTEGER NOT NULL, dcode CHAR(3) NOT NULL, year INTEGER NOT NULL, semester INTEGER NOT NULL, section CHAR(5) NOT NULL, iid INTEGER REFERENCES instructor(iid), FOREIGN KEY (cid, dcode) REFERENCES course(cid, dcode), UNIQUE (cid, dcode, year, semester, section));
CREATE TABLE studentCourse (sid INTEGER REFERENCES student(sid), csid INTEGER REFERENCES courseSection(csid), grade NUMERIC(5,2) NOT NULL DEFAULT 0.00, PRIMARY KEY (sid, csid));
CREATE TABLE prerequisites (cid INTEGER NOT NULL, dcode CHAR (3) NOT NULL, pcid INTEGER NOT NULL, pdcode CHAR(3) NOT NULL, FOREIGN KEY (cid, dcode) REFERENCES course(cid, dcode), FOREIGN KEY (pcid, pdcode) REFERENCES course(cid, dcode), PRIMARY KEY (cid, dcode,pcid, pdcode));