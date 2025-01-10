-- TRIGGER for whole table
-- create a trigger for products to store the last update time of products
ALTER TABLE products ADD COLUMN last_updated timestamp;
SELECT last_updated, * FROM products WHERE productid = 78;

DROP FUNCTION IF EXISTS products_timestamp;

CREATE OR REPLACE FUNCTION products_timestamp() 
RETURNS TRIGGER AS $$
BEGIN
	NEW.last_updated := now();
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS products_last_updated ON products;

CREATE OR REPLACE TRIGGER products_last_updated 
BEFORE INSERT OR UPDATE 
ON products
FOR EACH ROW EXECUTE FUNCTION products_timestamp();

SELECT last_updated, * FROM products WHERE productid = 78;
UPDATE products SET productname = 'trigger test' WHERE productid=78;
SELECT last_updated, * FROM products WHERE productid = 78;
UPDATE products SET productname = 'trigger test2' WHERE productid=78;
SELECT last_updated, * FROM products WHERE productid = 78;
INSERT INTO products(productid, productname, unitprice, discontinued) VALUES (79, 'insert trigger', 20, 0);
SELECT last_updated, * FROM products WHERE productid >= 78;


-- TRIGGER for single STATEMENT
-- CREATE a audit trail for orders
DROP TABLE IF EXISTS orders_audit_trail;

CREATE TABLE orders_audit_trail (
	operation char(1) NOT NULL,
	userid text NOT NULL,
	stamp timestamp NOT NULL,
	orderid smallint NOT NULL,
    customerid bpchar,
    employeeid smallint,
    orderdate date,
    requireddate date,
    shippeddate date,
    shipvia smallint,
    freight real,
    shipname character varying(40),
    shipaddress character varying(60),
    shipcity character varying(15),
    shipregion character varying(15),
    shippostalcode character varying(10),
    shipcountry character varying(15)
);

DROP FUNCTION IF EXISTS audit_trail_orders;
CREATE OR REPLACE FUNCTION audit_trail_orders() 
RETURNS TRIGGER AS $$
BEGIN
	IF (TG_OP = 'INSERT') THEN
		INSERT INTO orders_audit_trail
		SELECT 'I', USER, now(), o.* FROM new_table o;
	ELSIF (TG_OP = 'UPDATE') THEN
		INSERT INTO orders_audit_trail
		SELECT 'U', USER, now(), o.* FROM new_table o;
	ELSIF (TG_OP = 'DELETE') THEN
		INSERT INTO orders_audit_trail
		SELECT 'D', USER, now(), o.* FROM old_table o;
	ELSE
		RAISE EXCEPTION 'UNKNOWN TG_OP: %', TG_OP;
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS orders_audit_trail_insert ON orders_audit_trail;
DROP TRIGGER IF EXISTS orders_audit_trail_update ON orders_audit_trail;
DROP TRIGGER IF EXISTS orders_audit_trail_delete ON orders_audit_trail;

CREATE OR REPLACE TRIGGER orders_audit_trail_insert 
AFTER INSERT ON orders
REFERENCING NEW TABLE new_table
FOR EACH STATEMENT EXECUTE FUNCTION audit_trail_orders();

CREATE OR REPLACE TRIGGER orders_audit_trail_update 
AFTER UPDATE ON orders
REFERENCING NEW TABLE new_table
FOR EACH STATEMENT EXECUTE FUNCTION audit_trail_orders();

CREATE OR REPLACE TRIGGER orders_audit_trail_delete 
AFTER DELETE ON orders
REFERENCING OLD TABLE old_table
FOR EACH STATEMENT EXECUTE FUNCTION audit_trail_orders();

SELECT * FROM orders ORDER BY orderid DESC;
INSERT INTO orders(orderid, customerid) VALUES (11086, 'VINET');
SELECT * FROM orders_audit_trail;
UPDATE orders SET customerid = 'BONAP' WHERE orderid = 11086;
SELECT * FROM orders_audit_trail;
DELETE FROM orders WHERE orderid = 11086;
SELECT * FROM orders_audit_trail;

