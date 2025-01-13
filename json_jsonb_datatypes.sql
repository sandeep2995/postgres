DROP TABLE IF EXISTS books;
CREATE TABLE books(
	id serial,
	bookinfo jsonb
);

INSERT INTO books(bookinfo)
VALUES ('{"title": "Artificial Intellignece with Uncertainty", 
		"author": ["Deyi Li", "Yi Du"],
		"publisher": "Chapman and Hill",
		"date": 2008}');

SELECT bookinfo FROM books;
-- -> Operator to access the json fields from the column
SELECT bookinfo -> 'author' FROM books;
SELECT bookinfo -> 'title' FROM books;


-- to_jsonb(): building jsonb object
SELECT jsonb_build_object(
	'id', air.id,
	'ident', air.ident,
	'name', air.name,
	'latitude_deg', air.latitude_deg,
	'elevation_ft', air.elevation_ft,
	'continent', air.continent,
	'iso_country', air.iso_country,
	'iso_region', air.iso_region,
	'airport_home_link', air.home_link,
	'airport_wikipedia_link', air.wikipedia_link,
	'municipality', air.municipality,
	'scheduled_service', air.scheduled_service,
	'gps_code', air.gps_code,
	'iata_code', air.iata_code,
	'airport_local_code', air.local_code,
	'airport_keywords', to_jsonb(string_to_array(air.keywords, ','))  -- string --> array --> jsonb
)
FROM airports AS air;


-- jsonb_agg: aggregate the jsonb rows into an array
SELECT jsonb_agg(to_jsonb(us_airports)) FROM
(SELECT id, ident, name, iso_country
FROM airports WHERE iso_country = 'US') us_airports;


-- selecting from json
SELECT * FROM airports_json;
SELECT airports FROM airports_json;
SELECT airports -> 'airport_keywords' FROM airports_json;
SELECT airports -> 'airport_keywords' -> 0 FROM airports_json -- -> select as jsonb
WHERE airports -> 'airport_keywords' -> 0 IS NOT NULL;  -- select as jsonb
SELECT airports -> 'airport_keywords' ->> 0 FROM airports_json   -- -> select as text
WHERE airports -> 'airport_keywords' ->> 0 IS NOT NULL;  -- select as text

-- recursive json search
SELECT '{"a": {"b": [3, 2, 1]}}';
SELECT '{"a": {"b": [3, 2, 1]}}'::jsonb;
SELECT '{"a": {"b": [3, 2, 1]}}'::jsonb #> '{a}';  -- #> returns json object at the path
SELECT '{"a": {"b": [3, 2, 1]}}'::jsonb #> '{a,b}';
SELECT '{"a": {"b": [3, 2, 1]}}'::jsonb #> '{a,b,0}';  --  array elements are accessed through indices
SELECT '{"a": {"b": [3, 2, 1], "c": {"d": 5}}}'::jsonb #> '{a, c, d}';
SELECT '{"a": {"b": [3, 2, 1]}}'::jsonb #>> '{a,b,0}';  -- #>> returns the json object at the path as text

-- searching in json
SELECT * FROM airports_json;
SELECT * FROM airports_json WHERE airports @> '{"id": 6523}';  -- @>: right-side contained in left-side
SELECT * FROM airports_json WHERE airports @> '{"iso_country": "US"}';
SELECT * FROM airports_json WHERE airports ->> 'iso_country' = 'US';

