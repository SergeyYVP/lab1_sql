SELECT ('ФИО: ПЕРЕСЫПКИН СЕРГЕЙ ВЯЧЕСЛАВОВИЧ');


CREATE TABLE departament(
department_id integer PRIMARY KEY,
name VARCHAR(100)
);


CREATE TABLE employee(
id integer PRIMARY KEY,
department_id integer REFERENCES departament(department_id),
chief_doc_id integer,
name VARCHAR(100),
num_public integer
);


INSERT INTO departament
VALUES 
('1', 'Therapy'),select * from  
('2', 'Neurology'), 
('3', 'Cardiology'), 
('4', 'Gastroenterology'), 
('5', 'Hematology'), 
('6', 'Oncology');

INSERT INTO employee
VALUES
('1', '1', '1', 'Kate', 4), ('2', '1', '1', 'Lidia', 2), 
('3', '1', '1', 'Alexey', 1), ('4', '1', '2', 'Pier', 7), 
('5', '1', '2', 'Aurel', 6), ('6', '1', '2', 'Klaudia', 1), 
('7', '2', '3', 'Klaus', 12), ('8', '2', '3', 'Maria', 11), 
('9', '2', '4', 'Kate', 10), ('10', '3', '5', 'Peter', 8), 
('11', '3', '5', 'Sergey', 9), ('12', '3', '6', 'Olga', 12), 
('13', '3', '6', 'Maria', 14), ('14', '4', '7', 'Irina', 2), 
('15', '4', '7', 'Grit', 10), ('16', '4', '7', 'Vanessa', 16), 
('17', '5', '8', 'Sascha', 21), ('18', '5', '8', 'Ben', 22), 
('19', '6', '9', 'Jessy', 19), ('20', '6', '9', 'Ann', 18);

-- Запрос 1
SELECT departament.name, COUNT(DISTINCT chief_doc_id)
FROM departament
JOIN employee ON departament.department_id = employee.department_id
GROUP BY departament.name;

-- Запрос 2
SELECT department_id, COUNT(name) AS num_of_employee
FROM employee
GROUP BY department_id
HAVING COUNT(DISTINCT name)>=3;


-- Запрос 3
WITH tmp AS (
    SELECT department_id, SUM(num_public) AS num_of_public, DENSE_RANK() OVER(ORDER BY SUM(num_public) DESC) AS rating
    FROM employee
    GROUP BY department_id
    ORDER BY SUM(num_public) DESC
)
SELECT department_id, num_of_public
FROM tmp
WHERE rating=1;


SUM(num_public)

-- Запрос 4
WITH tmp AS (
    SELECT DISTINCT department_id, MIN(num_public) OVER (PARTITION BY department_id) 
    AS min_num_public
    FROM employee
    )
SELECT employee.department_id, name, num_public 
FROM employee
JOIN tmp ON employee.department_id = tmp.department_id AND num_public = min_num_public;


-- Запрос 5
WITH tmp AS
    (
    SELECT departament.name, departament.department_id, 
    COUNT(DISTINCT chief_doc_id), AVG(num_public) AS average_num_public
    FROM departament
    JOIN employee ON departament.department_id = employee.department_id
    GROUP BY departament.department_id
    HAVING COUNT(DISTINCT chief_doc_id)>1
    )
SELECT name, average_num_public FROM tmp;



COPY (
SELECT departament.name, COUNT(DISTINCT chief_doc_id)
FROM departament
JOIN employee ON departament.department_id = employee.department_id
GROUP BY departament.name
) 
TO '/var/lib/postgresql/data/pg_data/zapros_1.sql' WITH CSV DELIMITER ',';



COPY (
SELECT department_id, COUNT(name) AS num_of_employee
FROM employee
GROUP BY department_id
HAVING COUNT(DISTINCT name)>=3
) 
TO '/var/lib/postgresql/data/pg_data/zapros_2.sql' WITH CSV DELIMITER ',';


COPY (
WITH tmp AS (
    SELECT department_id, SUM(num_public) AS num_of_public, DENSE_RANK() OVER(ORDER BY SUM(num_public) DESC) AS rating
    FROM employee
    GROUP BY department_id
    ORDER BY SUM(num_public) DESC
)
SELECT department_id, num_of_public
FROM tmp
WHERE rating=1
) 
TO '/var/lib/postgresql/data/pg_data/zapros_3.sql' WITH CSV DELIMITER ',';



COPY (
WITH tmp AS (
    SELECT DISTINCT department_id, MIN(num_public) OVER (PARTITION BY department_id) 
    AS min_num_public
    FROM employee
    )
SELECT employee.department_id, name, num_public 
FROM employee
JOIN tmp ON employee.department_id = tmp.department_id AND num_public = min_num_public
) 
TO '/var/lib/postgresql/data/pg_data/zapros_4.sql' WITH CSV DELIMITER ',';



COPY (
WITH tmp AS
    (
    SELECT departament.name, departament.department_id, 
    COUNT(DISTINCT chief_doc_id), AVG(num_public) AS average_num_public
    FROM departament
    JOIN employee ON departament.department_id = employee.department_id
    GROUP BY departament.department_id
    HAVING COUNT(DISTINCT chief_doc_id)>1
    )
SELECT name, average_num_public FROM tmp
) 
TO '/var/lib/postgresql/data/pg_data/zapros_5.sql' WITH CSV DELIMITER ',';






























