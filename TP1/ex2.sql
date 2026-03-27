-- Exercice 2
-- 1

DESC section;
SELECT *
FROM section;

-- 2

SELECT *
FROM course;

-- 3

SELECT title, dept_name
FROM department;

-- 4

SELECT dept_name, budget
FROM department;

-- 5

SELECT name, dept_name
FROM teacher;

-- 7

SELECT name
FROM teacher
WHERE salary between 55000 AND 85000;

--6
SELECT name
FROM teacher
WHERE salary > 65000;

--8
-- DISTINCT para eliminar duplicados
SELECT DISTINCT dept_name
FROM teacher;

-- 9

SELECT name
FROM teacher
WHERE dept_name = 'Comp. Sci.' AND salary > 65000;

-- 10
SELECT *
FROM section
WHERE semester = 'Spring';

-- 11

SELECT title
FROM course
WHERE dept_name = 'Comp. Sci. ' AND credits> 3;

-- 12
-- Temos que adicionar a foreign key

SELECT t.name, t.dept_name, d.building
FROM teacher t, department d
WHERE t.dept_name = d.name;

-- 13

SELECT DISTINCT s.ID, s.name
FROM student s
JOIN takes ta ON s.ID = ta.ID
JOIN course c ON ta.course_id = c.course_id
WHERE c.dept_name = 'Comp. Sci.';

-- 14

SELECT DISTINCT s.name
FROM student s
JOIN takes ta ON s.ID = ta.ID
JOIN teaches te ON ta.course_id = te.course_id
 AND ta.sec_id = te.sec_id
 AND ta.semester = te.semester
 AND ta.year = te.year
JOIN teacher t ON te.ID = t.ID
WHERE t.name = 'Einstein';

-- 15

SELECT te.course_id, t.name
FROM teaches te
JOIN teacher t ON te.ID = t.ID;

-- 16

SELECT course_id, sec_id, semester, year, COUNT(*) AS nb_insc
FROM takes
WHERE semester = 'Spring' AND year = 2010
GROUP BY course_id, sec_id, semester, year;

-- 17

SELECT dept_name, MAX(salary) AS max_salary
FROM teacher
GROUP BY dept_name;

-- 18

SELECT course_id, sec_id, semester, year, COUNT(*) AS nb_insc
FROM takes
GROUP BY course_id, sec_id, semester, year;

--19

SELECT building, COUNT(*) AS nb_cours
FROM section
WHERE (semester = 'Fall' AND year = 2009) OR (semester = 'Spring' AND year = 2010)
GROUP BY building;

--20

SELECT c.dept_name, COUNT(*) AS nb_cours
FROM course c
JOIN section s ON c.course_id = s.course_id
JOIN department d ON c.dept_name = d.dept_name
WHERE s.building = d.building
GROUP BY c.dept_name;

--21

SELECT c.title, t.name
FROM course c
JOIN section s ON c.course_id = s.course_id
JOIN teaches te ON s.course_id = te.course_id
 AND s.sec_id = te.sec_id
 AND s.semester = te.semester
 AND s.year = te.year
JOIN teacher t ON te.ID = t.ID;

-- 22
SELECT semester, COUNT(*) AS nb_cours
FROM section
WHERE semester IN ('Summer', 'Fall', 'Spring')
GROUP BY semester;

-- 23

SELECT s.ID, s.name, SUM(c.credits) AS total_creds
FROM student s
JOIN takes ta ON s.ID = ta.ID
JOIN course c ON ta.course_id = c.course_id
WHERE s.dept_name <> c.dept_name
GROUP BY s.ID, s.name;

-- 24

SELECT c.dept_name, SUM(c.credits) AS total_creds
FROM course c
JOIN section s ON c.course_id = s.course_id
JOIN department d ON c.dept_name = d.dept_name
WHERE s.building = d.building
GROUP BY c.dept_name;
