-- COUNT and DISTINCT
-- pagila database
SELECT COUNT(first_name), COUNT(DISTINCT first_name) FROM actor;

-- WHERE clause
SELECT companyname, contactname FROM customers WHERE country = 'Mexico'; -- text
SELECT COUNT(*) FROM orders WHERE freight >= 250; -- numeric
SELECT COUNT(*) FROM orders WHERE shippeddate < '1997-07-05'; -- date

-- Operators
-- logical operators
SELECT DISTINCT customerid FROM orders WHERE shipvia = 2 AND shipcountry = 'Brazil'; -- AND
SELECT COUNT(supplierid) FROM suppliers WHERE country='Germany' OR country='Spain';  -- OR
SELECT COUNT(*) FROM orders WHERE shipcountry='USA' OR shipcountry='Argentina' OR shipcountry='Brazil';
SELECT COUNT(*) FROM suppliers WHERE NOT country = 'USA'; -- NOT
SELECT COUNT(*) FROM orders WHERE (shipcountry='Canada' OR shipcountry='Spain') AND shippeddate> '1997-05-01'; -- combine logical operators

SELECT COUNT(*) FROM orders WHERE shippeddate BETWEEN '1996-06-01' AND '1996-09-30'; -- BETWEEN
SELECT COUNT(*) FROM products WHERE categoryid IN (1,4,6,7); -- IN

-- Schema
SELECT * FROM purchasing.vendor; -- purchasing schema

-- psql
psql --port=5432 --host=localhost --dbname=pagila --username=postgres -- execute this on commandline
\l -- list of databases
\! clear -- clear screen
\c northwind -- connect to database northwind
\dn -- list of schemas
\dt sales. -- list of tables in schema sales (do not forget the dot at the end)
-- semicolon is mandatory for statements executed inside psql


-- Intermediate Select Statements
SELECT productname, unitprice FROM products ORDER BY unitprice DESC, productname ASC; -- OREDER BY
SELECT MAX(shippeddate - orderdate) FROM orders WHERE shipcountry = 'France'; -- MIN and MAX
SELECT AVG(quantity) FROM order_details WHERE productid=35; -- AVG
SELECT companyname FROM customers WHERE companyname LIKE '_%er' -- %: match 0 or more chars; _: match one char
-- FROM part and WHERE part are evaluated before the SELECT part.
-- Therefore, Column Aliases (defined using AS keyword) can only be used in ORDER BY and GROUP BY (but not in WHERE, FROM, HAVING)
SELECT unitsinstock*unitprice AS totalinventory FROM products ORDER BY totalinventory DESC;
SELECT productname, unitsinstock*unitprice AS totalinventory FROM products ORDER BY totalinventory, productname ASC LIMIT 2; -- LIMIT
-- NULL does not mean, the value is empty, but UNKOWN.
SELECT COUNT(*) FROM orders WHERE shipregion IS NULL;


-- JOINS
-- INNER JOIN
SELECT companyname, productname, categoryname, orderdate, order_details.unitprice, quantity 
FROM orders 
JOIN order_details ON orders.orderid=order_details.orderid
JOIN customers ON customers.customerid=orders.customerid
JOIN products ON products.productid=order_details.productid
JOIN categories ON categories.categoryid=products.categoryid
WHERE categoryname = 'Seafood' AND 
	order_details.unitprice*quantity >= 500;

-- LEFT JOIN
SELECT productname, orderid 
FROM products
LEFT JOIN order_details ON products.productid=order_details.productid
WHERE orderid IS NULL;

-- RIGHT JOIN
SELECT companyname, customercustomerdemo.customerid
FROM customercustomerdemo
RIGHT JOIN customers ON customercustomerdemo.customerid=customers.customerid;

-- FULL JOIN
SELECT categoryname, productname
FROM categories
FULL JOIN products ON categories.categoryid=products.categoryid;

-- SELF JOIN (NOTE: there is no keyword as SELF JOIN)
SELECT s1.companyname AS SupplierCompany1, s2.companyname AS SupplierCompany2, s1.country
FROM suppliers s1
JOIN suppliers s2 ON s1.country=s2.country
WHERE s1.supplierid <> s2.supplierid
ORDER BY s1.country;

-- USING
SELECT * 
FROM orders
JOIN order_details USING (orderid)
JOIN products USING (productid);

-- NATURAL JOIN (check on all matching column names)
SELECT * 
FROM order_details
NATURAL JOIN orders
NATURAL JOIN customers;


