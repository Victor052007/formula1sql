.mode csv

-- ---------- seasons ----------

CREATE TABLE raw_seasons (year TEXT, url TEXT);
.import --skip 1 data/seasons.csv raw_seasons

INSERT INTO seasons (year, url)
SELECT CAST(year AS INTEGER), url FROM raw_seasons;

DROP TABLE raw_seasons;

-- ---------- circuits ----------

CREATE TABLE raw_circuits (
  circuitId TEXT, circuitRef TEXT, name TEXT, location TEXT,
  country TEXT, lat TEXT, lng TEXT, alt TEXT, url TEXT
);
.import --skip 1 data/circuits.csv raw_circuits

INSERT INTO circuits (circuit_id, circuit_ref, name, location, country, lat, lng, alt, url)
SELECT
  CAST(circuitId AS INTEGER),
  circuitRef,
  name,
  NULLIF(location, '\N'),
  NULLIF(country, '\N'),
  CAST(NULLIF(lat, '\N') AS REAL),
  CAST(NULLIF(lng, '\N') AS REAL),
  CAST(NULLIF(alt, '\N') AS INTEGER),
  url
FROM raw_circuits;

DROP TABLE raw_circuits;

-- ---------- constructors ----------

CREATE TABLE raw_constructors (
  constructorId TEXT, constructorRef TEXT, name TEXT, nationality TEXT, url TEXT
);
.import --skip 1 data/constructors.csv raw_constructors

INSERT INTO constructors (constructor_id, constructor_ref, name, nationality, url)
SELECT
  CAST(constructorId AS INTEGER),
  constructorRef,
  name,
  NULLIF(nationality, '\N'),
  url
FROM raw_constructors;

DROP TABLE raw_constructors;

-- ---------- status ----------

CREATE TABLE raw_status (statusId TEXT, status TEXT);
.import --skip 1 data/status.csv raw_status

INSERT INTO status (status_id, status)
SELECT CAST(statusId AS INTEGER), status FROM raw_status;

DROP TABLE raw_status;

-- ---------- drivers ----------

CREATE TABLE raw_drivers (
  driverId TEXT, driverRef TEXT, number TEXT, code TEXT,
  forename TEXT, surname TEXT, dob TEXT, nationality TEXT, url TEXT
);
.import --skip 1 data/drivers.csv raw_drivers

INSERT INTO drivers (driver_id, driver_ref, number, code, forename, surname, dob, nationality, url)
SELECT
  CAST(driverId AS INTEGER),
  driverRef,
  CAST(NULLIF(number, '\N') AS INTEGER),
  NULLIF(code, '\N'),
  forename,
  surname,
  NULLIF(dob, '\N'),
  NULLIF(nationality, '\N'),
  url
FROM raw_drivers;

DROP TABLE raw_drivers;

-- ---------- races ----------
-- CSV-ul are 18 coloane: sesiunile FP/quali/sprint au fost
-- adăugate după ce s-a scris schema originală Ergast.
-- Le citim pe toate, dar păstrăm doar primele 8.

CREATE TABLE raw_races (
  raceId TEXT, year TEXT, round TEXT, circuitId TEXT, name TEXT,
  date TEXT, time TEXT, url TEXT,
  fp1_date TEXT, fp1_time TEXT, fp2_date TEXT, fp2_time TEXT,
  fp3_date TEXT, fp3_time TEXT, quali_date TEXT, quali_time TEXT,
  sprint_date TEXT, sprint_time TEXT
);
.import --skip 1 data/races.csv raw_races

INSERT INTO races (race_id, year, round, circuit_id, name, date, time, url)
SELECT
  CAST(raceId AS INTEGER),
  CAST(year AS INTEGER),
  CAST(round AS INTEGER),
  CAST(circuitId AS INTEGER),
  name,
  date,
  NULLIF(time, '\N'),
  NULLIF(url, '\N')
FROM raw_races;

DROP TABLE raw_races;