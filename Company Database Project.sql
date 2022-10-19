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

/*Inserting employees from Corporate branch*/

INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;


INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

/*Inserting employees from Scranton branch*/

INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;


INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

/*Inserting employees from Stamford branch*/

INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);


-- PRACTICING QUERIES -------------------------------------------------------

SELECT*
FROM branch_supplier;


-- Find all employees ordered by salary--

SELECT employee.first_name, employee.last_name, employee.salary
FROM employee
ORDER BY salary DESC;

-- Find all employees ordered by sex then name

SELECT employee.sex, employee.first_name, employee.last_name
FROM employee
ORDER BY sex, first_name, last_name;

-- Find first 5 employees from employee table

SELECT employee.emp_id, employee.first_name, employee.last_name
FROM employee
LIMIT 5;

-- Find forenames and surnames of employees

SELECT employee.first_name AS forenames, employee.last_name AS surnames
FROM employee;

-- Find out all the different genders

SELECT DISTINCT sex
FROM employee;

-- Find the number of employees
SELECT COUNT(emp_id)
FROM employee;

-- Find the number of female employees born after 1970
SELECT COUNT(emp_id)
FROM employee
WHERE sex = 'F' AND birth_day >= '1970-01-01';

-- Find the average of all employee's salaries
SELECT AVG(salary)
FROM employee;

-- Find the sum of all employee's salaries (for male that have supervisors) 
SELECT SUM(salary)
FROM employee
WHERE sex = 'M' AND super_id IS NOT NULL;

-- Find out how many males and females there are

SELECT COUNT(sex), sex
FROM employee
GROUP BY sex;

-- Find the total sales of each salesman

SELECT SUM(total_sales), emp_id
FROM works_with
GROUP BY emp_id;

-- Find any client's who are an LLC

SELECT*
FROM client
WHERE client_name LIKE '%LLC';

-- Find any employee born in february

SELECT*
FROM employee
WHERE birth_day LIKE '____-02-__';

-- ----UNIONS---------

-- Find a list of employees and branch names

SELECT first_name AS List_of_employess_and_branches
FROM employee
UNION
SELECT branch_name
FROM branch;

-- Find a list of all clients/branch supplier's names

SELECT client_name, client.branch_id
FROM client
UNION
SELECT supplier_name, branch_supplier.branch_id
FROM branch_supplier
ORDER BY branch_id;

 -- -------JOIN-------- joining rows from different tables based on the same column

-- Find all branches and the names of their managers

SELECT employee.emp_id, employee.first_name, employee.last_name, branch.branch_name
FROM employee
JOIN branch
ON employee.emp_id = branch.mgr_id;

-- The same thing but with LEFT JOIN----(all the rows from the employee table are included)

SELECT employee.emp_id, employee.first_name, employee.last_name, branch.branch_name
FROM employee
LEFT JOIN branch  
ON employee.emp_id = branch.mgr_id;

INSERT INTO branch VALUES('4', 'Buffalo', NULL, NULL);

-- The same as LEFT JOIN but RIGHT JOIN are including every row from branch now--

SELECT employee.emp_id, employee.first_name, employee.last_name, branch.branch_name
FROM employee
RIGHT JOIN branch  
ON employee.emp_id = branch.mgr_id;


-- -----_____-NESTED QUERIES-_____-----------


-- Find names of all employees who have   sold over 30,000 to a single clinet

SELECT employee.first_name, employee.last_name
FROM employee
WHERE employee.emp_id IN (
    SELECT works_with.emp_id
    FROM works_with
    WHERE works_with.total_sales > 30000
);

-- Find all clients who are handled by the branch THAT Michael Scott manages, assume you know Michael's ID

SELECT client.client_name
FROM client
WHERE client.branch_id IN (
    SELECT branch.branch_id
    FROM branch
    WHERE branch.mgr_id = 102
);

-- ---___ON DELETE SET NULL(Set NULL in place of the key)___ON DELETE CASCADE--------(Delete whole row where the key was)


-- _______________________CREATING TRIGGER TO AN EMPLOYEE TABLE___________________________

 -- Creating table when triggers will accrue

CREATE TABLE trigger_test(
    forename VARCHAR(30),
    surname VARCHAR(30),
    message VARCHAR(30)
);

-- ---------------

DELIMITER $$
CREATE 
	TRIGGER my_trigger BEFORE INSERT 
    ON employee 
    FOR EACH ROW BEGIN
		INSERT INTO trigger_test(forename, surname, message) VALUES(NEW.first_name,NEW.last_name,'added new employee');
	END $$
 DELIMITER ;   
 -- ________________________________________________________________________________________
 
 /* 
 DELETE FROM employee WHERE emp_id = 109 OR emp_id = 110;;
 DROP TABLE trigger_test; 
 SELECT * FROM employee;
 */

INSERT INTO employee VALUES(109,'Viktor','Grzegorczyk','1990-03-30','M',62000,106,3);
INSERT INTO employee VALUES(110,'Raf','Zęgota','2001-05-20','M',69000,106,3);

SELECT * FROM trigger_test;

SELECT * FROM employee;
 



