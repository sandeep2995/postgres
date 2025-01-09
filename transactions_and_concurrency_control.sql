-- create a transaction to increase the requireddate by 1 day for orders in 1997 December and decrease by 1 day for 1997 November
SELECT orderid, customerid, requireddate 
FROM orders
WHERE EXTRACT(YEAR FROM orderdate) = 1997 AND 
	EXTRACT(MONTH FROM orderdate) IN (11, 12)
ORDER BY orderdate;

START TRANSACTION;  --  START of TRANSACTION
	UPDATE orders
	SET requireddate = requireddate + INTERVAL '1 DAY'
	WHERE EXTRACT(YEAR FROM orderdate) = 1997 AND
		EXTRACT(MONTH FROM orderdate) = 12;

	UPDATE orders
	SET requireddate = requireddate - INTERVAL '1 DAY'
	WHERE EXTRACT(YEAR FROM orderdate) = 1997 AND
		EXTRACT(MONTH FROM orderdate) = 11;
COMMIT;  -- END of TRANSACTION

SELECT orderid, customerid, requireddate 
FROM orders
WHERE EXTRACT(YEAR FROM orderdate) = 1997 AND 
	EXTRACT(MONTH FROM orderdate) IN (11, 12)
ORDER BY orderdate;


-- ROLLBACK: abort all the changes in the current transaction
-- ROLLBACK TO <SAVEPOINT-name>: perform partial rollback up to the given savepoint
