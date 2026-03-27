-- 1
SELECT dept_name
FROM department
WHERE budget = (SELECT MAX(budget) FROM department);

-- 2

SELECT name, salary
FROM teacher
WHERE salary > (SELECT AVG(salary) FROM teacher);

-- 3
SELECT t.name AS teacher_name, s.name AS student_name, COUNT(*) AS nb_cours
FROM teacher t
JOIN teaches te ON t.ID = te.ID
JOIN takes ta ON te.course_id = ta.course_id
 AND te.sec_id = ta.sec_id
 AND te.semester = ta.semester
 AND te.year = ta.year
JOIN student s ON ta.ID = s.ID
GROUP BY t.name, s.name
HAVING COUNT(*) > 2;


-- 4
SELECT *
FROM (
    SELECT t.name AS teacher_name, s.name AS student_name, COUNT(*) AS nb_cours
    FROM teacher t
    JOIN teaches te ON t.ID = te.ID
    JOIN takes ta
      ON te.course_id = ta.course_id
     AND te.sec_id = ta.sec_id
     AND te.semester = ta.semester
     AND te.year = ta.year
    JOIN student s ON ta.ID = s.ID
    GROUP BY t.name, s.name
)
WHERE nb_cours > 2;

-- 5

SELECT s.ID, s.name
FROM student s
WHERE s.ID NOT IN (
    SELECT DISTINCT ID
    FROM takes
    WHERE year < 2010
);

-- 6

SELECT *
FROM teacher
WHERE name LIKE 'E%';

-- 7

SELECT name, salary
FROM (
    SELECT name, salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM teacher
)
WHERE rnk = 4;

--8

SELECT name, salary
FROM (
    SELECT name, salary
    FROM teacher
    ORDER BY salary ASC
)
WHERE ROWNUM <= 3
ORDER BY salary DESC;

-- 9

SELECT name
FROM student
WHERE ID IN (
    SELECT ID
    FROM takes
    WHERE semester = 'Fall' AND year = 2009
);

-- 10

SELECT name
FROM student
WHERE ID = SOME (
    SELECT ID
    FROM takes
    WHERE semester = 'Fall' AND year = 2009
);

-- 11

SELECT DISTINCT name
FROM student
NATURAL INNER JOIN takes
WHERE semester = 'Fall' AND year = 2009;

-- 12

SELECT s.name
FROM student s
WHERE EXISTS (
    SELECT 1
    FROM takes t
    WHERE t.ID = s.ID AND t.semester = 'Fall' AND t.year = 2009
);

-- 13
SELECT DISTINCT s1.name AS etudiant1, s2.name AS etudiant2
FROM takes t1
JOIN takes t2 ON t1.course_id = t2.course_id
 AND t1.sec_id = t2.sec_id
 AND t1.semester = t2.semester
 AND t1.year = t2.year
 AND t1.ID < t2.ID
JOIN student s1 ON t1.ID = s1.ID
JOIN student s2 ON t2.ID = s2.ID;

-- 14

SELECT t.name, COUNT(*) AS nb_total_etudiants
FROM teacher t
JOIN teaches te ON t.ID = te.ID
JOIN takes ta ON te.course_id = ta.course_id
 AND te.sec_id = ta.sec_id
 AND te.semester = ta.semester
 AND te.year = ta.year
GROUP BY t.name
ORDER BY nb_total_etudiants DESC;

-- 15
SELECT t.name, COUNT(ta.ID) AS nb_total_etudiants
FROM teacher t
LEFT JOIN teaches te ON t.ID = te.ID
LEFT JOIN takes ta ON te.course_id = ta.course_id
 AND te.sec_id = ta.sec_id
 AND te.semester = ta.semester
 AND te.year = ta.year
GROUP BY t.name
ORDER BY nb_total_etudiants DESC;

-- 16

SELECT t.name, COUNT(*) AS nb_A
FROM teacher t
JOIN teaches te ON t.ID = te.ID
JOIN takes ta ON te.course_id = ta.course_id
 AND te.sec_id = ta.sec_id
 AND te.semester = ta.semester
 AND te.year = ta.year
WHERE ta.grade = 'A'
GROUP BY t.name;

--  17

SELECT t.name AS teacher_name, s.name AS student_name, COUNT(*) AS nb_times
FROM teacher t
JOIN teaches te ON t.ID = te.ID
JOIN takes ta ON te.course_id = ta.course_id
 AND te.sec_id = ta.sec_id
 AND te.semester = ta.semester
 AND te.year = ta.year
JOIN student s ON ta.ID = s.ID
GROUP BY t.name, s.name;

-- 18

SELECT t.name AS teacher_name, s.name AS student_name, COUNT(*) AS nb_fois
FROM teacher t
JOIN teaches te ON t.ID = te.ID
JOIN takes ta ON te.course_id = ta.course_id
 AND te.sec_id = ta.sec_id
 AND te.semester = ta.semester
 AND te.year = ta.year
JOIN student s ON ta.ID = s.ID
GROUP BY t.name, s.name
HAVING COUNT(*) >= 2;
