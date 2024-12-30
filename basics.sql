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

