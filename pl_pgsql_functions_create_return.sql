-- ROUTINE: refers to FUNCTIONs as well as PROCEDUREs
DROP ROUTINE IF EXISTS biggest_order();


-- CREATE PLPGSQL Function
-- write a function that returns the largest order in terms of total amount
CREATE OR REPLACE FUNCTION biggest_order() RETURNS double precision AS $$
BEGIN  -- beginning of the block
	RETURN SUM(unitprice*quantity) as total_amount  -- must use RETURN instead of SELECT
	FROM order_details
	GROUP BY orderid
	ORDER BY total_amount DESC
	LIMIT 1;  -- semicolon is must at the end of each statement
END;  -- end of the block; semicolon is must
$$ LANGUAGE plpgsql;

SELECT biggest_order();


-- FUNCTIONs with OUTPUT variables
DROP ROUTINE IF EXISTS square_n_cube;

CREATE OR REPLACE FUNCTION square_n_cube(n int, OUT square int, OUT cube int) AS $$
BEGIN
	square := n*n;
	cube := n*n*n;
	RETURN;
END;
$$ LANGUAGE plpgsql;

SELECT (square_n_cube(5)).*;


-- RETURN QUERY: RETURNing QUERY Result
-- return suppliers that have unitsinstock+unitsonorder < reorderlevel
DROP FUNCTION IF EXISTS suppliers_to_reorder_from();

CREATE OR REPLACE FUNCTION suppliers_to_reorder_from() 
RETURNS SETOF suppliers AS $$
BEGIN
	RETURN QUERY SELECT *   -- RETURN QUERY
	FROM suppliers
	WHERE supplierid IN
		(SELECT supplierid 
		FROM products
		WHERE unitsinstock+unitsonorder < reorderlevel);
END;
$$ LANGUAGE plpgsql;

SELECT (suppliers_to_reorder_from()).*;


-- RETURN NEXT expression
-- change the price of the products after christmas_sale
SELECT * FROM products ORDER BY categoryid;
CREATE OR REPLACE FUNCTION after_christmas_sale()
RETURNS SETOF products AS $$
DECLARE
	product record;
BEGIN
	FOR product IN SELECT * FROM products ORDER BY categoryid LOOP
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


