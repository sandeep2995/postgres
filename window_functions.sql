-- find all orders of the product 'Alice Mutton' compared to average order
SELECT od.*, p.productname, 
	AVG(quantity) OVER (PARTITION BY productid) avg_quantity
FROM order_details od
JOIN products p USING (productid)
WHERE p.productname = 'Alice Mutton'
ORDER BY quantity DESC;

-- compare each product's order quantity compared to the average order of that product
SELECT productid, productname, quantity, AVG(quantity) OVER (PARTITION BY productid)
FROM order_details
JOIN products USING (productid)
ORDER BY quantity DESC;

-- Window functions with subqueries
-- find all the suppliers with 3 times the normal quanatity of orders over all their products versus the average order per month
-- find all the suppliers with 3 times the normal quanatity of orders over all their products versus the average order per month
SELECT * 
FROM 
(SELECT companyname, ordered_year, ordered_month, total_per_supplier_quantity, 
	AVG(total_per_supplier_quantity) OVER (PARTITION BY companyname) AS avg_per_supplier_quantity
	FROM
	(SELECT companyname, SUM(quantity) AS total_per_supplier_quantity, 
		EXTRACT(YEAR FROM orderdate) ordered_year,
		EXTRACT(MONTH FROM orderdate) ordered_month
	FROM suppliers
	JOIN products USING (supplierid)
	JOIN order_details USING (productid)
	JOIN orders USING (orderid)
	GROUP BY companyname, ordered_year, ordered_month
	) AS supplier_orders
) AS supplier_orders_average_monthly
WHERE total_per_supplier_quantity > 3*avg_per_supplier_quantity

-- RANK()
-- find the 3 least expensive products from each supplier
SELECT * FROM
(SELECT companyname, productid, productname, unitprice,
rank() OVER (PARTITION BY supplierid ORDER BY unitprice ASC) expensive_rank
FROM suppliers
JOIN products USING (supplierid)
)
WHERE expensive_rank <= 3
ORDER BY companyname, expensive_Rank

