-- ARRAYs creation
DROP TABLE IF EXISTS salary_employees;
CREATE TABLE salary_employees (
	name fullname,
	pay_by_quarter integer ARRAY[4],
	--pay_by_quarter integer[4], -- same as above
	schedule text[][]
);

INSERT INTO salary_employees(name, pay_by_quarter, schedule)
VALUES(ROW('Bill','',''), 
	ARRAY[20_000, 20_000, 20_000, 20_000],
	ARRAY[['meeting', 'training'], ['lunch', 'sales call']]);

SELECT * FROM salary_employees;


-- ARRAY access
SELECT pay_by_quarter[2:3] FROM salary_employees;
SELECT schedule[1] FROM salary_employees;  -- NULL
SELECT schedule[1][1] FROM salary_employees; -- first elementfrom first ARRAY
SELECT schedule[1:][1] FROM salary_employees;
SELECT schedule[1][:2] FROM salary_employees;
SELECT array_dims(schedule) FROM salary_employees;  -- array_dims()
SELECT array_length(schedule, 1) FROM salary_employees;   -- array_length()


-- ARRAY modification
UPDATE salary_employees
SET pay_by_quarter[1:4] = ARRAY[22000, 25000, 27000, 22000]
WHERE (name).firstname = 'Bill';

UPDATE salary_employees
SET pay_by_quarter[2:3] = ARRAY[32000, 35000]
WHERE (name).firstname = 'Bill';

UPDATE salary_employees
SET pay_by_quarter[4] = 50000
WHERE (name).firstname = 'Bill';

SELECT * FROM salary_employees WHERE (name).firstname = 'Bill';


-- ARRAY searching
SELECT schedule FROM salary_employees;
SELECT schedule[1][2] FROM salary_employees;
SELECT array_dims(schedule) FROM salary_employees;

SELECT * FROM salary_employees
WHERE 'sales call' = ANY(schedule);
SELECT * FROM salary_employees
WHERE 'sales call' = ANY(schedule[2][:]);
SELECT * FROM salary_employees
WHERE 'sales call' = ANY(schedule[:][2]);


-- ARRAY operators
SELECT *
FROM salary_employees
WHERE schedule && ARRAY['sales call'];  -- &&: Overlap operator

SELECT ARRAY[1,2,3,4] && ARRAY[3,4,5,6];  -- TRUE due to the overlap
SELECT ARRAY[1,2,3,4] <@ ARRAY[3,4,5,6]; -- FALSE; left array is not contained in the right
SELECT ARRAY[3,4] <@ ARRAY[3,4,5,6]; -- TRUE; left array is contained in the right
SELECT ARRAY[1,2,3,4] @> ARRAY[3,4,5,6]; -- FALSE; right array is not contained in the left
SELECT ARRAY[1,2,3,4] @> ARRAY[3,4]; -- TRUE; right array is contained in the left
SELECT ARRAY[1,2,3,4] < ARRAY[3,1,2,3]; -- TRUE; first element satisfies
SELECT ARRAY[3,2,3,4] < ARRAY[1,4,5,6]; -- FALSE: first element itself satisfies
SELECT ARRAY[1,2,3] < ARRAY[1,2,4]; -- TRUE; Surprisingly, it checks the next element if the elements are equal.