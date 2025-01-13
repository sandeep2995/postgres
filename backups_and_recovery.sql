-- execute the following on the psql terminal
\copy employees TO 'employees.csv' WITH (HEADER, FORMAT CSV, QUOTE '"')  -- quotes only the special columns (eg. column with comma in it)
\copy employees TO 'employees_forcequote.csv' WITH (HEADER, FORMAT CSV, QUOTE '"', FORCE_QUOTE(employeeid)) -- quotes the given column(s list)

-- copy the selected data
\copy (SELECT * FROM employees WHERE employeeid BETWEEN 1 AND 5) TO 'employees_5.csv' WITH (HEADER, FORMAT CSV, QUOTE '"', FORCE_QUOTE(employeeid))


-- pg_dump (create a dump of the selected database)
pg_dump northwind > northwind.sql  -- execute this on the terminal
-- your postgres version on the server and the version of pg_dump should match above command to work.
-- In my case, server has 17.2 version but pg_dump has 14.13 version.
-- So, In installed the postgresql 17.2 version through tap.
-- That is executed the following commands
brew tap petere/postgresql  -- get the postgres versions from the git user petere
brew install postgresql@17  -- install the specific version
brew services start postgresql@17  --  start the corresponding service
/opt/homebrew/opt/postgresql@17/bin/postgres --version  -- now, check the version of the newly installed postgresql

-- execute the pg_dump using the postgres user. Otherwise, pg_dump uses the user of the system as the user of the postgres
/opt/homebrew/opt/postgresql@17/bin/pg_dump --username=postgres  northwind > northwind.sql


-- restoration (execute the following on the terminal)
createdb --username=postgres northwind_bak   --  create the database to restore the backup
psql --username=postgres northwind_bak < northwind.sql


-- custom format dumps (allows partial restore and occupies lower memory)
/opt/homebrew/opt/postgresql@17/bin/pg_restore --list northwind.fc   -- list the contents of the backup
/opt/homebrew/opt/postgresql@17/bin/pg_restore --username=postgres -j 4 -d northwind_bak northwind.fc  -- j: number of cores to use

-- restore a specific table (delete the table test_time from northwind and restore it as below)
/opt/homebrew/opt/postgresql@17/bin/pg_restore --username=postgres -j 4 -d northwindnorthwind.fc  -- j: number of cores to use





