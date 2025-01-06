CREATE SEQUENCE test_sequence_4 START WITH 33 INCREMENT 7;
SELECT nextval('test_sequence_4');

CREATE SEQUENCE IF NOT EXISTS orders_orderid_seq START WITH 11078 OWNED BY orders.orderid;
ALTER TABLE orders ALTER COLUMN orderid SET DEFAULT nextval('orders_orderid_seq');  -- take the default value from the sequence
INSERT INTO orders(customerid, employeeid, requireddate, shippeddate) VALUES('VINET', 5, '1996-08-01', '1996-08-06') RETURNING orderid;
SELECT * FROM orders ORDER BY orderid DESC;  -- check the inserted values

ALTER SEQUENCE orders_orderid_seq RESTART WITH 200_000;  --  restart sequence with 200_000
SELECT nextval('orders_orderid_seq');  -- test it

DROP SEQUENCE test_sequence_four;  -- DROP SEQUENCE

DROP TABLE IF EXISTS pets;
CREATE TABLE pets (
	id serial,
	name text
);
INSERT INTO pets(name) VALUES('Cat') RETURNING id;