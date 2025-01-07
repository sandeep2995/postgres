-- WITH
-- find the customers who ordered the products that are the top-2 least ordered products
WITH least_2_ordered_products AS (
	SELECT productid, SUM(quantity) as number_of_orders
	FROM order_details
	GROUP BY productid
	ORDER BY number_of_orders ASC 
	LIMIT 2
)

SELECT DISTINCT customerid, companyname 
FROM least_2_ordered_products
JOIN order_details USING (productid)
JOIN orders USING (orderid)
JOIN customers USING (customerid)
ORDER BY companyname;

-- insert an employee record. Then, use its return id to insert a record into orders table
SELECT MAX(employeeid) FROM employees;
CREATE SEQUENCE employees_employeeid_seq START WITH 10;
ALTER TABLE employees ALTER COLUMN employeeid SET DEFAULT nextval('employees_employeeid_seq');
ALTER SEQUENCE employees_employeeid_seq OWNED BY employees.employeeid;

WITH new_record AS (
	INSERT INTO employees(lastname, firstname) 
	VALUES('Vid', 'San') RETURNING employeeid
)
INSERT INTO orders(employeeid, orderdate, shippeddate)
SELECT employeeid, '2024-01-01', '2024-01-06'
FROM new_record RETURNING employeeid;
SELECT * FROM orders ORDER BY orderid DESC;

-- write a RECURSIVE CTE that starts at 500 and prints all the even numbers upto 2
WITH RECURSIVE even(n) AS (
	SELECT 500
	UNION ALL
	SELECT n-2 FROM even
	WHERE n>2
)
SELECT * FROM even;

-- chain of command from employeeid = 218 (Dudley Kiona) up to the CEO
WITH RECURSIVE command_chain(firstname, lastname, title, reportsto, employeeid, level) AS (
	SELECT firstname, lastname, title, reportsto, employeeid, 0
	FROM employees WHERE employeeid=218
	UNION ALL
	SELECT reportedemp.firstname, reportedemp.lastname, reportedemp.title, reportedemp.reportsto, reportedemp.employeeid, level+1
	FROM employees reportedemp 
	JOIN command_chain ON command_chain.reportsto = reportedemp.employeeid
)
SELECT * FROM command_chain;
