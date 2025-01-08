-- FUNCTION without parameters and without RETURNing anything
-- write a function to set the default path for missing photopath
CREATE OR REPLACE FUNCTION set_employee_default_photo() RETURNS void AS $$
UPDATE employees
SET photopath = 'http://accweb/emmployees/default.bmp'
WHERE photopath IS NULL
$$ LANGUAGE SQL;

SELECT set_employee_default_photo();  -- run the function
SELECT photopath from employees;  -- check the results


-- FUNCTION with NO parameters but RETURNs single value
-- write a function that returns the largest order in terms of total amount
DROP FUNCTION IF EXISTS biggest_order();

CREATE OR REPLACE FUNCTION biggest_order() RETURNS double precision AS $$
	SELECT SUM(unitprice*quantity) as total_amount
	FROM order_details
	GROUP BY orderid
	ORDER BY total_amount DESC
	LIMIT 1
$$ LANGUAGE SQL;

SELECT biggest_order();


-- FUNCTIONs with parameters and single RETURN value
-- find the most ordered product of a given customer
CREATE OR REPLACE FUNCTION most_ordered_product(cid bpchar) RETURNS varchar(40) AS $$
	SELECT productname
	FROM products
	JOIN order_details USING (productid)
	JOIN orders USING (orderid)
	WHERE customerid = $1
	GROUP BY customerid, productid
	ORDER BY SUM(quantity) DESC
	LIMIT 1
$$ LANGUAGE SQL;

SELECT most_ordered_product('ANATR');
SELECT most_ordered_product('CACTU');


-- FUNCTIONS with COMPOSITE parameters
-- Write a function that takes employees (table) as input and returns the title, firstname and lastname concatenated together
CREATE OR REPLACE FUNCTION full_name(employees)
RETURNS varchar AS $$
	SELECT COALESCE($1.titleofcourtesy,'') || ' ' || $1.firstname || ' ' || $1.lastname  -- you must use $ number based reference
$$ LANGUAGE SQL;

--SELECT employeeid, title, firstname, lastname, full_name(employees) AS full_name  -- this also works
SELECT employeeid, title, firstname, lastname, full_name(employees.*) AS full_name
FROM employees;


-- FUNCTIONs RETURNing a COMPOSITEs
-- create a function that returns the products row with highest money as the inventory
CREATE OR REPLACE FUNCTION highest_inventory()
RETURNS products AS $$
	SELECT *
	FROM products
	ORDER BY unitprice*unitsinstock DESC
	LIMIT 1
$$ LANGUAGE SQL;

SELECT highest_inventory();
SELECT (highest_inventory()).*;
SELECT productname(highest_inventory());  -- functional notation
SELECT (highest_inventory()).productname;  -- same as above


-- FUNCTIONs with OUTPUT parameters: IN, OUT, INOUT, VARIADIC
-- write a function to return the square and cube of a given number
CREATE OR REPLACE FUNCTION square_n_cube(IN n integer,  -- default parameter type is also IN
										OUT square integer, 
										OUT cube integer) AS $$
	SELECT n*n, n*n*n
$$ LANGUAGE SQL;

SELECT (square_n_cube(5)).*;


-- FUNCTION with DEFAULT parameter values
-- write a function to return the square and cube of a given number
CREATE OR REPLACE FUNCTION square_n_cube(IN n integer DEFAULT 10, 
										OUT square integer, 
										OUT cube integer) AS $$
	SELECT n*n, n*n*n
$$ LANGUAGE SQL;

SELECT (square_n_cube(5)).*;
SELECT square(square_n_cube());
SELECT (square_n_cube()).cube;


-- FUNCTIONs AS TABLE SOURCEs
-- get productname and supplier companyname by using highest_inventory function
SELECT productname, companyname 
FROM highest_inventory() AS high_inventory_prodid
JOIN suppliers ON supplierid(high_inventory_prodid) = suppliers.supplierid;
