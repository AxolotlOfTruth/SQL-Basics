/* Basic Data Types 
INT -- Whole Numbers
DECIMAL(M,N)  -- Decimal Numbers - Exact Value
VARCHAR(1)   -- String with text length 1
BLOB  -- Binary Large Object for large ammounts of data
DATE  -- 'YYYY-MM-DD'
TIMESTAMP  -- 'YYYY-MM-DD HH:MM:SS' - Used for recording exact time.
*/

/*Create a Table*/
CREATE TABLE Fish (
    species VARCHAR(50) PRIMARY KEY,
    popular_name VARCHAR(20),
    avg_size_cm INT
);

/*Get info on Table*/
DESCRIBE Fish;

/*Delete Table*/
DROP TABLE Fish;

/*Modify Table*/
ALTER TABLE Fish ADD biome VARCHAR(20);

/*Delete Column*/
ALTER TABLE Fish DROP COLUMN biome;

/*Inserting Data*/
INSERT INTO Fish VALUES('Thunnus alalunga', 'Albacore Tuna', 100);
INSERT INTO Fish VALUES('Carassius auratus', 'Goldfish', 15);


/*Inserting Partial Data*/
INSERT INTO Fish(species, popular_name) VALUES('Arapaima gigas', 'Pirarucu');

/*Drag all Information from table*/
SELECT * FROM Fish;

/*Create a more detailed table*/
CREATE TABLE Cetaceans (
    species VARCHAR(50) PRIMARY KEY,
    popular_name VARCHAR(20) UNIQUE,  -- Unique only doesn't allow the entry to be repeated in this column
    avg_size_cm INT NOT NULL -- NOT NULL Requires the Entry to have something in it
);

/*Creating a Default value*/
ALTER TABLE Cetaceans ADD biome VARCHAR(20) DEFAULT 'Ocean';

INSERT INTO Cetaceans(species, popular_name, avg_size_cm) VALUES('Orcinus orca', 'Killer Whale', 600);
INSERT INTO Cetaceans(species, popular_name, avg_size_cm) VALUES('Balaenoptera musculus', 'Blue Whale', 3000);
INSERT INTO Cetaceans VALUES('Inia geoffrensis', 'Boto-cor-de-rosa', 200, 'Amazonas River');
INSERT INTO Cetaceans VALUES('Phocoena sinus', 'Vaquita', 130, 'California Gulf');

DROP TABLE Cetaceans;

/*Update and Delete*/
UPDATE Cetaceans
SET popular_name = 'Orca'
WHERE popular_name = 'Killer Whale';  -- WHERE is optional

DELETE FROM Cetaceans
WHERE species = 'Phocoena sinus';

/*Basic Queries*/
SELECT * FROM Cetaceans;
SELECT species FROM Cetaceans;
SELECT species, avg_size_cm FROM Cetaceans;
SELECT species, avg_size_cm FROM Cetaceans ORDER BY avg_size_cm;
SELECT species, avg_size_cm FROM Cetaceans ORDER BY avg_size_cm DESC;  -- The opposite of DESC is ASC
SELECT species, avg_size_cm FROM Cetaceans ORDER BY avg_size_cm DESC LIMIT 3; 

--Vertical Version
SELECT species, avg_size_cm 
FROM Cetaceans 
WHERE avg_size_cm >= 300 
ORDER BY avg_size_cm 
DESC LIMIT 3; 


/*Complex Schema*/
CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    birth_day DATE,
    sex VARCHAR(1),
    salary INT,
    super_id INT,
    branch_id INT
);

CREATE TABLE branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(40),
    mgr_id INT,
    mgr_start_date DATE,
    FOREIGN KEY(mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
);

ALTER TABLE employee
ADD FOREIGN KEY(branch_id)
REFERENCES branch(branch_id)
ON DELETE SET NULL;

ALTER TABLE employee
ADD FOREIGN KEY(super_id)
REFERENCES employee(emp_id)
ON DELETE SET NULL;

CREATE TABLE client (
    client_id INT PRIMARY KEY,
    client_name VARCHAR(40),
    branch_id INT,
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE SET NULL
);

CREATE TABLE works_with (
    emp_id INT,
    client_id INT,
    total_sales INT,
    PRIMARY KEY(emp_id, client_id),
    FOREIGN KEY(emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY(client_id) REFERENCES client(client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier (
    branch_id INT,
    supplier_name VARCHAR(40),
    supply_type VARCHAR(40),
    PRIMARY KEY(branch_id, supplier_name),
    FOREIGN KEY(branch_id) REFERENCES branch(branch_id) ON DELETE CASCADE
);

INSERT INTO employee VALUES(100, 'Lord', 'Business', '1966-11-23', 'M', 999999, NULL, NULL);
INSERT INTO branch VALUES(1, 'Corporate', 100, '2014-02-19');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Bad', 'Cop', '1986-01-17', 'M', 7000, 100, 1);

--Bricksburg 
INSERT INTO branch VALUES(2, 'Bricksburg', NULL, '2016-09-02');
INSERT INTO employee VALUES(102, 'Emmet', 'Brickowski', '1996-10-12', 'M', 12, 101, 2);
INSERT INTO employee VALUES(103, 'Wild', 'Style', '1997-07-07', 'F', 6, 102, 2);
INSERT INTO employee VALUES(104, 'Benny', 'Spaceman', '1980-05-04', 'M', 2400, 102, 2);

UPDATE branch
SET mgr_id = 102
where branch_id = 2; 

--Mata Nui
INSERT INTO branch VALUES(3, 'Mata Nui', NULL, '2002-08-06');
INSERT INTO employee VALUES(105, 'Turaga', 'Vakama', '2001-03-24', 'M', 6500, 101, 3);
INSERT INTO employee VALUES(106, 'Tahu', 'Nuva', '2001-07-22', 'M', 1500, 105, 3);
INSERT INTO employee VALUES(107, 'Kee', 'Tongu', '2004-05-05', 'M', 500, 105, 3);

UPDATE branch
SET mgr_id = 105
where branch_id = 3; 

SELECT * FROM employee;

--BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, "Castle", 'Swords');
INSERT INTO branch_supplier VALUES(2, "Pirates", 'Gunpowder');
INSERT INTO branch_supplier VALUES(3, "System", 'Gears');
INSERT INTO branch_supplier VALUES(3, "Aqua Raiders", 'Harpoons');
INSERT INTO branch_supplier VALUES(2, "Town", 'Bricks');

--CLIENT
INSERT INTO client VALUES(400, 'Bricksburg Construction Company', 2);
INSERT INTO client VALUES(401, 'Metru Nui Rebuilders', 3);
INSERT INTO client VALUES(402, 'Cloud Cuckoo land', 2);
INSERT INTO client VALUES(403, 'NERV', 3);
INSERT INTO client VALUES(404, 'Definitely Not Master Builders.inc', 2);

--WORKS_WITH
INSERT INTO works_with VALUES(102, 400, 50990);
INSERT INTO works_with VALUES(105, 401, 160000);
INSERT INTO works_with VALUES(103, 402, 9999999);
INSERT INTO works_with VALUES(106, 403, 85000);
INSERT INTO works_with VALUES(104, 404, 22);

/*Another Basic Query*/
-- Find out all the different genders
SELECT DISTINCT sex
FROM employee;

/*Function*/
--Find the number of employees
SELECT COUNT(emp_id)
FROM employee;
--Find the number of male employees born after 2000
SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'M' and birth_day > 2000-01-01;
--Find the average of all employee's salaries
SELECT AVG(salary)
FROM employee;
--Find the sum of all employee's salaries
SELECT SUM(salary)
FROM employee;
--Find out how many males and females there are
SELECT COUNT(sex), sex
FROM employee
GROUP BY sex;

/*Wildcards*/
--Find any clients who are Incorporated(inc)
SELECT * 
FROM client
WHERE client_name LIKE '%inc';
--Find a branch supplier that sells gunpowder
SELECT *
FROM branch_supplier
WHERE supply_type LIKE '%powder';
--Find an employee born in October
SELECT *
FROM employee
WHERE birth_day LIKE '____-10%';
--Find a supplier with a 4 letter name
SELECT *
FROM branch_supplier
WHERE supplier_name LIKE '____';

/*Unions*/
--Find a list of employee and branch names
SELECT first_name
FROM employee
UNION
SELECT branch_name
FROM branch; -- Unions must have the same number of columns and same datatypes

-- Find a list of all clients and branch suppliers' names and branch associations
SELECT client_name, branch_id
FROM client
UNION
SELECT supplier_name, branch_id
FROM branch_supplier;

-- Find a list of all money spent or earned by the company
SELECT salary
FROM employee
UNION
SELECT total_sales
FROM works_with;

/*Joins*/
INSERT INTO branch VALUES(4, 'New York', NULL, NULL);

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
JOIN branch
ON employee.emp_id = branch.mgr_id;

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
LEFT JOIN branch
ON employee.emp_id = branch.mgr_id;

SELECT employee.emp_id, employee.first_name, branch.branch_name
FROM employee
RIGHT JOIN branch
ON employee.emp_id = branch.mgr_id;

/*Nested Queries*/
--Find the names of all employees who have sold over 30.000 to a single client
SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN(
    SELECT works_with.emp_id
    FROM works_with
    WHERE works_with.total_sales > 30000
);
--Find all clients who are handled by the branch that Emmet Brickowski manages.
SELECT client.client_name
FROM client
WHERE client.branch_id = (
    SELECT branch.branch_id
    FROM branch
    WHERE branch.mgr_id = 102
    LIMIT 1
);

/*Triggers*/

CREATE TABLE trigger_test (
    message VARCHAR(100)
);

DELIMETER $$
CREATE
    TRIGGER my_trigger BEFORE INSERT
    ON employee
    FOR EACH ROW BEGIN
        INSERT INTO trigger_test VALUES('added new employee');
    END$$
DELIMITER ;

INSERT INTO employee
VALUES(145, 'Lewa', 'Mahri', '2008-03-19', 'M', 6700, 105, 3);

SELECT * FROM trigger_test