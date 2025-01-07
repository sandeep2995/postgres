-- create a view supplier_order_details to join the tables orders, order_details and suppliers
DROP VIEW IF EXISTS supplier_order_details;  -- DROP VIEW

CREATE OR REPLACE VIEW supplier_order_details AS
SELECT suppliers.*, p.productname, orders.*, od.productid, od.unitprice, od.quantity, od.discount
FROM orders
FULL JOIN order_details od USING (orderid)
JOIN products p USING (productid)
JOIN suppliers USING (supplierid);

SELECT * FROM supplier_order_details WHERE supplierid=5;

ALTER VIEW supplier_order_details RENAME TO supplier_orders;  -- ALTER VIEW name

-- Updatable Views
-- create an updatable view for all the diary products (categoryids are 4, 6, 8)
CREATE VIEW protein_products AS
SELECT *
FROM products
WHERE categoryid IN (4, 6, 8);

SELECT * FROM protein_products;

INSERT INTO protein_products(productid, productname, categoryid, discontinued)
VALUES(78, 'dummy', 6, 0);
SELECT * FROM products ORDER BY productid DESC;
UPDATE protein_products
SET productname = 'not dummy' WHERE productid=78;
SELECT * FROM products ORDER BY productid DESC;
DELETE FROM protein_products WHERE productid=78;
SELECT * FROM products ORDER BY productid DESC;


-- WITH LOCAL CHECK OPTION
CREATE OR REPLACE VIEW protein_products AS
SELECT *
FROM products
WHERE categoryid IN (4, 6, 8)
WITH LOCAL CHECK OPTION;  -- checks that the categoryid in the WHERE condition is validated before data insertion

SELECT * FROM protein_products;

INSERT INTO protein_products(productid, productname, categoryid, discontinued)
VALUES(78, 'dummy', 5, 0);  -- violates check option

DROP VIEW IF EXISTS supplier_orders;  -- DROP VIEW
