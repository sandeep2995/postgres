-- build a function to determine the average order size and then return all the orders that are between 75% and 130%
CREATE OR REPLACE FUNCTION average_orders()
RETURNS SETOF orders AS $$
	DECLARE 		-- DECLARE BLOCK to declare the variables
		min_order real;
		avg_order real;
		max_order real;
	BEGIN
		SELECT AVG(per_order_quantity) INTO avg_order
		FROM
		(SELECT orderid, SUM(quantity*unitprice) AS per_order_quantity
		FROM order_details
		GROUP BY orderid);

		min_order := avg_order*75/100;  --  SQL way of assignment. Better for interoperability
		max_order := avg_order*130/100;  -- For PGSQL, the assignment operator is =

		RETURN QUERY SELECT * 
		FROM orders 
		WHERE orderid IN (SELECT orderid
			FROM
				(SELECT orderid, SUM (quantity*unitprice) AS per_order_quantity
				FROM order_details
				GROUP BY orderid)
			WHERE per_order_quantity BETWEEN min_order AND max_order);
	END;
$$ LANGUAGE plpgsql;

SELECT (average_orders()).*;


-- write a function to return the average of squared product unitprices
CREATE OR REPLACE FUNCTION average_squared_product_unitprices()
RETURNS double precision AS $$
DECLARE
	record_count int := 0;
	squared_sum double precision := 0;
	product record;
BEGIN
	FOR product IN SELECT unitprice FROM products LOOP
		record_count := record_count + 1;
		squared_sum := squared_sum + (product.unitprice)*(product.unitprice);
	END LOOP;
	RETURN squared_sum/record_count;
END;
$$ LANGUAGE PLPGSQL;

SELECT average_squared_product_unitprices();


-- IF condition
-- write a function to return the season of the year
CREATE OR REPLACE FUNCTION time_of_year(date timestamp) 
RETURNS text AS $$
DECLARE
	month int;
BEGIN
	month := EXTRACT(MONTH FROM $1);
	IF month BETWEEN 3 AND 5 THEN
		RETURN 'Spring';
	ELSIF month BETWEEN 6 AND 8 THEN
		RETURN 'Summer';
	ELSIF month BETWEEN 9 AND 11 THEN
		RETURN 'Fall';
	ELSIF month=12 OR month<=2 THEN
		RETURN 'Winter';
	ELSE
		RETURN 'UNKNOWN Season';
	END IF;
END;
$$ LANGUAGE plpgsql;

SELECT time_of_year('2025-01-10 10:36:00');
SELECT time_of_year('2025-04-10 10:36:00');
SELECT time_of_year('2025-06-10 10:36:00');
SELECT time_of_year('2025-10-10 10:36:00');

SELECT orderid, customerid, orderdate, time_of_year(orderdate) AS order_season FROM orders;

-- change the price of the products after christmas_sale
SELECT * FROM products ORDER BY categoryid;
CREATE OR REPLACE FUNCTION after_christmas_sale()
RETURNS SETOF products AS $$
DECLARE
	product record;
BEGIN
	FOR product IN SELECT * FROM products ORDER BY categoryid LOOP   -- FOR LOOP
		IF product.categoryid <= 3 THEN
			product.unitprice = product.unitprice*0.85;
		ELSIF product.categoryid <= 6 THEN
			product.unitprice = product.unitprice*2;
		ELSIF product.categoryid <= 9 THEN
			product.unitprice = product.unitprice*1.35;
		ELSE
			RAISE EXCEPTION 'UNKNOWN categoryid FOUND: %', product.categoryid;
		END IF;
		RETURN NEXT product;
	END LOOP;
	RETURN;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM after_christmas_sale();
SELECT * FROM products ORDER BY categoryid;


-- write a function for factorial using WHILE LOOP
DROP FUNCTION IF EXISTS factorial(float);
CREATE OR REPLACE FUNCTION factorial(num float)
RETURNS float AS $$
DECLARE
	fact float=1;
	tmp float=1;
BEGIN
	WHILE tmp <= num LOOP
		fact = fact*tmp;
		tmp = tmp+1;
	END LOOP;
	RETURN fact;
END;
$$ LANGUAGE plpgsql;

SELECT factorial(5);


-- FOREACH: iterate over each element
-- return the first element of the array that the given divisor divides
CREATE OR REPLACE FUNCTION first_multiple(num_list int[], divisor int)
RETURNS int AS $$
DECLARE
	n int;
BEGIN
	FOREACH n IN ARRAY num_list LOOP
		IF n%divisor = 0 THEN
			RETURN n;
		END IF;
	END LOOP;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

SELECT first_multiple(ARRAY[2,3,4,5,6,7,8,9], 7);
SELECT first_multiple(ARRAY[2,3,4,5,6,7,8,9], 3);
