-- USE/CREATE airport database for this and use the CSV files from https://ourairports.com/data/ for data COPY
DROP TABLE IF EXISTS airport_frequencies;
CREATE TABLE airport_frequencies(
	id int,
	airport_ref int,
	airport_ident varchar(20),
	type varchar (20),
	description text,
	frequency_mhz real
);

-- execute the following on the terminal (NOTE: not in the pgadmin)
\copy airport_frequencies(id, airport_ref, airport_ident, type, description, frequency_mhz) FROM '/Users/vidyapus/Desktop/projects/postgres/materials/csv_files/airport-frequencies.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM airport_frequencies LIMIT 10;

