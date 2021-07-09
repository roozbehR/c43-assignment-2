INSERT INTO department VALUES ('CSC', 'Computer Science');
INSERT INTO department VALUES ('LIN', 'Linguistics');
INSERT INTO department VALUES ('CLA', 'History');
INSERT INTO department VALUES ('MAT', 'Mathematics');

INSERT INTO student VALUES (1, 'Khan', 'Abdullah', 'M', 21, 'CSC', 4);
INSERT INTO student VALUES (2, 'Ahmed', 'Hassan', 'M', 20, 'CSC', 3);
INSERT INTO student VALUES (3, 'Francis', 'Megan', 'F', 21, 'LIN', 2);
INSERT INTO student VALUES (4, 'Pine', 'Chris', 'M', 22, 'CLA', 2);
INSERT INTO student VALUES (5, 'Watson', 'Emma', 'F', 18, 'MAT', 3);

INSERT INTO instructor VALUES (1, 'Evans', 'Chris', 'PhD', 'CSC');
INSERT INTO instructor VALUES (2, 'Janko', 'George', 'BSc', 'MAT');
INSERT INTO instructor VALUES (3, 'Choy', 'Elliot', 'PhD', 'LIN');
INSERT INTO instructor VALUES (4, 'Wakasa', 'Kelly', 'MS', 'CSC');
INSERT INTO instructor VALUES (5, 'Neistat', 'Casey', 'MS', 'CLA');

INSERT INTO course VALUES (1, 'CSC', 'Intro Programming');
INSERT INTO course VALUES (2, 'MAT', 'Hard Maths');
INSERT INTO course VALUES (3, 'CLA', 'History intro');
INSERT INTO course VALUES (4, 'LIN', 'Language Intro');
INSERT INTO course VALUES (5, 'CSC', 'Adv Programming');

INSERT INTO courseSection VALUES (1, 1, 'CSC', 2020, 9,'ABCDE', 1);  
INSERT INTO courseSection VALUES (2, 2, 'MAT', 2021, 5,'EFGHI', 1);  
INSERT INTO courseSection VALUES (3, 3, 'CLA', 2020, 1,'JKLMN', 2);  
INSERT INTO courseSection VALUES (4, 4, 'LIN', 2021, 9,'OPQRS', 3);  
INSERT INTO courseSection VALUES (5, 1, 'CSC', 2021, 5,'TUVWX', 4); 

INSERT INTO studentCourse VALUES (1, 1, 76);
INSERT INTO studentCourse VALUES (1, 2, 86);
INSERT INTO studentCourse VALUES (2, 3, 66);
INSERT INTO studentCourse VALUES (3, 4, 45);
INSERT INTO studentCourse VALUES (4, 5, 99);

INSERT INTO prerequisites VALUES (1, 'CSC', 2, 'MAT');
INSERT INTO prerequisites VALUES (3, 'CLA', 4, 'LIN');

 




