-- Indexes and Performance Tuning
--CREATE INDEX
CREATE INDEX idx_orders_orderid_customerid
ON orders(orderid, customer);
--DROP INDEX
DROP INDEX idx_orders_customerid_orderid;


-- Stopping Runaway Queries
-- create sample table for testing
CREATE TABLE performance_test(
	id serial,
	location text
);
-- write a query to write huge data into it
INSERT INTO performance_test(location)
SELECT 'Frankfurt, Germany' FROM generate_series(1,500_000_000);
-- get the PID of the above runaway query
SELECT * FROM pg_stat_activity WHERE state='active';
-- stop the process that is executing the runaway query
SELECT pg_cancel_backend(PID); -- polite: stop the process with pid
SELECT pg_terminate_backend(PID); -- forced: stop at all costs; can lead to full database restart

-- EXPLAIN (illustrates the query execution plan)
INSERT INTO performance_test(location)
SELECT md5(random()::text) FROM generate_series(1,10_000_000);
SELECT * FROM performance_test WHERE id=2_000_000; -- check the retrieval time before INDEX creation
EXPLAIN SELECT * FROM performance_test WHERE id=2_000_000; -- check the query execution plan before INDEX creation
CREATE INDEX idx_performance_test_location ON performance_test(location);
SELECT * FROM performance_test WHERE id=2_000_000; -- check the retrieval time after INDEX creation
EXPLAIN SELECT * FROM performance_test WHERE id=2_000_000; -- check the query execution plan after INDEX creation
EXPLAIN SELECT COUNT(*) FROM performance_test; -- verify that the created INDEX does not have influence on this query performance

-- ANALYZE (helps to update table statistics)
ANALYZE performance_test; -- adjust the table statistics
-- EXPLAIN ANALYZE runs the actual query to generate the execution plan, so it is more accurate than EXPLAIN
EXPLAIN ANALYZE SELECT * FROM performance_test WHERE id=2_000_000; -- get execution plan of the ANALYZE

-- expression indexes (create indices after applying a function or operator on the columns)
-- create an index after concatenating a first name and last name
EXPLAIN SELECT firstname || ' '||lastname FROM person.person;
CREATE INDEX idx_person_firstname_lastname ON person.person((firstname || ' ' || lastname));
EXPLAIN SELECT * FROM person.person WHERE firstname || ' '||lastname = 'Terri Duffy';

-- text matching using GIN (Generalized Inverted Index) index
EXPLAIN ANALYZE SELECT location FROM performance_test WHERE location LIKE 'dfe%';
CREATE EXTENSION pg_trgm; -- enable the extension (postgres trigram) per each database
CREATE INDEX trgm_idx_performance_test_location ON performance_test USING gin(location gin_trgm_ops); -- create gin index which is better suited for text searches
EXPLAIN ANALYZE SELECT location FROM performance_test WHERE location LIKE 'dfe%';
DROP INDEX IF EXISTS trgm_idx_performance_test_location;

