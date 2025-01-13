DROP ROLE IF EXISTS sales;
DROP ROLE IF EXISTS jill;
CREATE ROLE sales NOLOGIN NOCREATEDB NOSUPERUSER;   -- create role
CREATE USER jill LOGIN NOCREATEDB NOSUPERUSER PASSWORD 'abc123';  -- create user
GRANT sales TO jill;

-- DATABASE-level security
GRANT CREATE ON DATABASE northwind TO sales;  -- enables schema creation on sales role
GRANT CONNECT ON DATABASE northwind TO sales;  -- enable database connection to sales role

-- SCHEMA-level security
GRANT USAGE ON SCHEMA public TO sales;
CREATE TABLE public.a_test_table(id int);
GRANT CREATE ON SCHEMA public TO sales;
CREATE TABLE public.a_test_table(id int);

-- TABLE-level security
SELECT * FROM employees;
GRANT SELECT ON TABLE employees to sales;
SELECT * FROM employees;

GRANT INSERT ON TABLE customers to sales;
GRANT UPDATE ON TABLE customers to sales;
GRANT SELECT ON TABLE employees to sales;

-- COLUMN-level security
REVOKE SELECT ON ALL TABLES IN SCHEMA public FROM sales;
SELECT contactname, contacttitle, phone FROM customers;
GRANT SELECT (contactname, contacttitle, phone) ON customers TO sales;  -- GRANT SELECT on specific columns
SELECT contactname, contacttitle, phone FROM customers;

GRANT UPDATE (contactname, contacttitle, phone) ON customers TO sales;  -- GRANT UPDATE on specific columns
GRANT INSERT (contactname, contacttitle, phone) ON customers TO sales;  -- GRANT INSERT on specific columns


-- ROW-level security
-- we need to enable this explicitly
-- as soon as you enable this, no one would be able to see any rows. That is, denies all
GRANT SELECT ON orders TO sales;
SELECT * FROM orders WHERE shippeddate IS NULL; -- returns 21 rows
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
SELECT * FROM orders WHERE shippeddate IS NULL;  -- returns 0 rows
ALTER TABLE orders DISABLE ROW LEVEL SECURITY;
SELECT * FROM orders WHERE shippeddate IS NULL;  -- returns 21 rows
SELECT * FROM orders;  -- returns 839 rows


ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY sales_orders ON orders
FOR SELECT TO sales
USING (shippeddate IS NULL);

SELECT * FROM orders WHERE shippeddate IS NULL;  -- returns 21 rows
SELECT * FROM orders WHERE shippeddate IS NOT NULL;  -- returns 0 rows
SELECT * FROM orders;  -- returns 21 rows








