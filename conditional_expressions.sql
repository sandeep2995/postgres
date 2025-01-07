-- CASE WHEN
-- list productnames, unit price and label (<10: inexpensive; 10-50: mid-range; >50: expensive)
SELECT productname, unitprice,
	CASE WHEN unitprice<10 THEN 'inexpensive'
		 WHEN unitprice BETWEEN 10 AND 50 THEN 'mid-range'
		 WHEN unitprice>50 THEN 'expensive'
	END label
FROM products;

-- label the orders in year 1996 as year1, 1997 as year2 and 1998 as year3
SELECT orderid, customerid, 
	CASE date_part('year', orderdate) 
		WHEN 1996 THEN 'year1'
		WHEN 1997 THEN 'year2'
		WHEN 1998 THEN 'year3'
		ELSE 'unknown'
	END AS year_label
FROM orders;

-- COALESCE (return the first NON-NULL value)
SELECT companyname, COALESCE(homepage, 'Call to find') AS homepage
FROM suppliers;

-- NULLIF (returns NULL if its two arguments are equal, and returns the first argument if not equal)
UPDATE customers SET fax='' WHERE fax IS NULL;
SELECT customerid, companyname, 
    COALESCE(NULLIF(fax,''), phone) AS confirmation
FROM customers;
SELECT * FROM customers;
