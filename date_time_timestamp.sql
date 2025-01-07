SHOW DateStyle;  -- shows the current format of the date; eg. 'ISO,MDY' (MDY: Month, Date, Year)

SET DateStyle = 'ISO,DMY';  -- set the DateStyle
Show datestyle;

CREATE TABLE test_time (
	startdate DATE,
	startstamp TIMESTAMP,
	starttime TIME
);

INSERT INTO test_time (startdate, startstamp,starttime)
VALUES ('epoch'::timestamp(0) with time zone,'infinity'::timestamp(0) with time zone,'allballs'),
('epoch'::timestamp,'infinity'::timestamp,'allballs'),  -- is equivalent to above typecast
('epoch'::timestamptz,'infinity'::timestamptz,'allballs');  -- is equivalent to above typecast


-- TIME ZONEs
SHOW TIME ZONE;

ALTER TABLE test_time
ADD COLUMN endtime TIME WITH TIME ZONE,
ADD COLUMN endstamp TIMESTAMP WITH TIME ZONE;

INSERT INTO test_time(endstamp, endtime)
VALUES('01/20/2018 10:30:00 US/Pacific', '10:30:00+5'),
('06/20/2018 10:30:00 US/Pacific', '10:30:00+5');  --  day/light saving applied to US/Pacific

SELECT * FROM test_time;

-- INTERVAL
SHOW IntervalStyle;  -- eg. postgres 

DELETE FROM test_time;
ALTER TABLE test_time
ADD COLUMN span interval;

INSERT INTO test_time(span)
VALUES('5 DECADES 7 YEAR 5 MONTHS 9 DAYS'),
	('5 DECADES 7 YEAR 5 MONTHS 9 DAYS AGO'),
	('9 32:14:20'),  -- days hours:minutes:seconds
	('1-2'),  -- year-month format
	('P5Y7MT6H25M'),
	('P25-2-30T17:34:56');

SET IntervalStyle='sql_standard';
SELECT span FROM test_time;
SET IntervalStyle='iso_8601';
SELECT span FROM test_time;
SET IntervalStyle='postgres';
SELECT span FROM test_time;


-- DATE Arithmetic
SELECT age(TIMESTAMP '1997-08-21');  -- INTERVAL between given timestamp and current date
SELECT age(TIMESTAMP '1997-08-21', TIMESTAMP '1990-09-21');  -- INTERVAL as difference between two timestamps
SELECT INTERVAL '1997 years 10 months 20 hours 3 seconds' * 2;
SELECT INTERVAL '1997 years 10 months 20 hours 3 seconds' / 2;
SELECT INTERVAL '1997 years 10 months 20 hours 3 seconds' + 2;  -- not supported
SELECT INTERVAL '1997 years 10 months 20 hours 3 seconds' - 2;  -- not supported

SELECT TIMESTAMP '1997-08-21 10:01:02.123' - TIMESTAMP '1990-08-21 5:04:03.31'; -- returns INTERVAL
SELECT TIME '10:01:02.123' - TIME '5:04:03.31'; -- returns INTERVAL
SELECT DATE '1997-08-21' - DATE '1990-08-21'; -- returns DAYS between the dates as INTEGER

-- pulling out parts from date and time
-- EXTRACT()
SELECT birthdate from employees;
SELECT employeeid, firstname, lastname, birthdate,
	EXTRACT(MILLENNIUM FROM birthdate) millennium_of_birth,
	EXTRACT(DECADE FROM birthdate) decade_of_birth,
	EXTRACT(YEAR FROM birthdate) year_of_birth,
	EXTRACT(MONTH FROM birthdate) month_of_birth,
	EXTRACT(DAY FROM birthdate) day_of_birth,
	age(birthdate) age,
	EXTRACT(YEAR FROM age(birthdate)) age_in_years
FROM employees;

-- date_part()
SELECT date_part('DECADE', birthdate)
FROM employees;
SELECT employeeid, firstname, lastname, birthdate,
	date_part('MILLENNIUM', birthdate) millennium_of_birth,
	date_part('DECADE', birthdate) decade_of_birth,
	date_part('YEAR', birthdate) year_of_birth,
	date_part('MONTH', birthdate) month_of_birth,
	date_part('DAY', birthdate) day_of_birth,
	age(birthdate) age,
	date_part('YEAR', age(birthdate)) age_in_years
FROM employees;

-- Datatype CASTing
SELECT CAST('2015-10-03' AS DATE), 375::TEXT;






