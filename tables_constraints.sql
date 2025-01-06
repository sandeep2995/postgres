-- CREATE a returns table
CREATE TABLE returns(
	returnid serial,
	customerid char(5),
	datereturned timestamp,
	productid int,
	qunatity smallint,
	orderid int
);

-- ALTER table
-- rename a column datereturned to return_date
ALTER TABLE returns RENAME datereturned TO return_date;
ALTER TABLE returns RENAME TO bad_orders; -- RENAME a table
ALTER TABLE bad_orders ADD COLUMN reason text; -- ADD COLUMN 
ALTER TABLE bad_orders DROP COLUMN reason; -- DROP COLUMN
ALTER TABLE bad_orders RENAME qunatity TO quantity;
ALTER TABLE bad_orders ALTER COLUMN quantity SET DATA TYPE int;

DROP TABLE bad_orders; -- DROP the table


-- constraints
CREATE TABLE practice(
	practiceid int NOT NULL,  -- NOT NULL
	practice_field varchar(50) NOT NULL
);
ALTER TABLE employees ALTER COLUMN lastname SET NOT NULL;
CREATE TABLE pets(
	petid int UNIQUE,  -- UNIQUE
	name varchar(25) NOT NULL
);
ALTER TABLE shippers ADD CONSTRAINT companyname_shippers UNIQUE (companyname); -- ADD CONSTRAINT
CREATE TABLE pets(
	petid int PRIMARY KEY,  -- PRIMARY KEY
	name varchar(25) NOT NULL
);
ALTER TABLE pets DROP CONSTRAINT pets_pkey;  -- DROP CONSTRAINT 
ALTER TABLE pets ADD PRIMARY KEY(petid);

CREATE TABLE pets (
	petid int PRIMARY KEY,
	name VARCHAR(25) NOT NULL,
	customerid CHAR(5) NOT NULL,
	FOREIGN KEY(customerid) REFERENCES customers(customerid)  -- FOREIGN KEY
);
ALTER TABLE pets DROP CONSTRAINT pets_customerid_fkey;
ALTER TABLE pets ADD CONSTRAINT pets_customerid_fkey FOREIGN KEY(customerid) REFERENCES customers(customerid);

CREATE TABLE pets (
	petid int PRIMARY KEY,
	name VARCHAR(25) NOT NULL,
	customerid CHAR(5) NOT NULL,
	FOREIGN KEY(customerid) REFERENCES customers(customerid),
	weight int CONSTRAINT weight_pets CHECK (weight BETWEEN 0 AND 200)  -- CHECK constraint
);

ALTER TABLE products ADD CONSTRAINT unitprice_products CHECK(unitprice>0);

CREATE TABLE pets (
	petid int PRIMARY KEY,
	name VARCHAR(25) NOT NULL,
	customerid CHAR(5) NOT NULL,
	FOREIGN KEY(customerid) REFERENCES customers(customerid),
	weight int CONSTRAINT weight_pets CHECK (weight>0 AND weight<200) DEFAULT 50  -- DEFAULT
);
ALTER TABLE products ALTER COLUMN reorderlevel SET DEFAULT 5;

ALTER TABLE suppliers ALTER COLUMN homepage SET DEFAULT 'N/A';
ALTER TABLE suppliers ALTER COLUMN homepage DROP DEFAULT;  -- DROP DEFAULT

