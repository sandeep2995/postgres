DROP TYPE IF EXISTS fullname CASCADE;  -- deletes the corresponding column from friends table
DROP TYPE IF EXISTS address CASCADE;  -- deletes the corresponding column from friends table
DROP TYPE IF EXISTS specialdate CASCADE;
DROP TABLE IF EXISTS friends;

CREATE TYPE fullname AS (
	firstname varchar(50),
	middlename varchar(50),
	lastname varchar(50)
);
CREATE TYPE address AS (
	streetname varchar(50),
	housenumber varchar(10),  --  to accommodate house numbers like 59A
	city varchar (25),
	state varchar (25),
	country varchar (25),
	plz char(5)
);
CREATE TYPE specialdate AS (
	birthdate date,
	age smallint -- in years
);
CREATE TABLE friends(
	full_name fullname,
	home_address address,
	special_date specialdate
);

-- ROW()
INSERT INTO friends(full_name, home_address, special_date)
--VALUES('("San", "No Middle", "Vid")', '("Heinstrasse", "3B", "Bonn", "NRW", "DE", "12345")', '("1991-01-02", "34")'),  -- this did not work though course suggested it
VALUES(('San', 'No Middle', 'Vid'), ('Heinstrasse', '3B', 'Bonn', 'NRW', 'DE', '12345'), ('1991-01-02', 34)),
(('Mar', 'John', 'Gregory'), ('Peinstr.', '10', 'Berlin', 'Berlin', 'DE', '54321'), ('1997-01-02', 27)),
(ROW('Ding', 'Dong', 'Gregory'), ROW('PingPongStr.', '99', 'Frankfurt', 'Hessen', 'DE', '67890'), ROW('2007-05-06', 17));

SELECT * FROM friends;
SELECT full_name FROM friends;
SELECT (full_name).firstname FROM friends;

-- select state, middle name, age of everyone with the lastname 'Gregory'
SELECT (home_address).city, (full_name).middlename, (special_date).age
FROM friends
WHERE (full_name).lastname = 'Gregory';