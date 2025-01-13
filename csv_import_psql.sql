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

CREATE DATABASE airport;

CREATE TABLE airports (
	id int NOT NULL,
	ident varchar(10),
	type text,
	name text,
	latitude_deg float,
	longitude_deg float,
	elevation_ft int,
	continent text,
	iso_country varchar(10),
	iso_region varchar(10),
	municipality text,
	scheduled_service text,
	gps_code varchar(10),
	iata_code varchar(20),
	local_code varchar(20),
	home_link text,
	wikipedia_link text,
	keywords text
);

-- this won't work in pgAdmin (even in the psql tool inside the pgadmin)
COPY airports (id,ident,type,name,latitude_deg,longitude_deg,elevation_ft,
				continent,iso_country,iso_region,municipality,scheduled_service,
				gps_code,iata_code,local_code,home_link,wikipedia_link,keywords)
FROM '/Users/vidyapus/Desktop/projects/postgres/materials/csv_files/airports.csv' DELIMITER ',' CSV HEADER;

-- execute the following on the terminal (NOTE: not in the pgadmin)
\copy airports (id,ident,type,name,latitude_deg,longitude_deg,elevation_ft,
				continent,iso_country,iso_region,municipality,scheduled_service,
				gps_code,iata_code,local_code,home_link,wikipedia_link,keywords)
FROM '/Users/vidyapus/Desktop/projects/postgres/materials/csv_files/airports.csv' DELIMITER ',' CSV HEADER;

