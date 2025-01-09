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

