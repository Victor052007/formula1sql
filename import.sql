-- Import Ergast CSVs into the normalized schema.
-- Run after schema.sql:  sqlite3 f1.db < import.sql

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
-- CSV-ul are 18 coloane; sesiunile FP/quali/sprint nu sunt in schema.

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

-- ---------- results ----------
-- Sarim positionText (redundant cu status_id) si time (format inconsistent).

CREATE TABLE raw_results (
  resultId TEXT, raceId TEXT, driverId TEXT, constructorId TEXT,
  number TEXT, grid TEXT, position TEXT, positionText TEXT,
  positionOrder TEXT, points TEXT, laps TEXT, time TEXT,
  milliseconds TEXT, fastestLap TEXT, rank TEXT,
  fastestLapTime TEXT, fastestLapSpeed TEXT, statusId TEXT
);
.import --skip 1 data/results.csv raw_results

INSERT INTO results (result_id, race_id, driver_id, constructor_id, number, grid,
                     position, position_order, points, laps, milliseconds,
                     fastest_lap, rank, fastest_lap_time, fastest_lap_speed, status_id)
SELECT
  CAST(resultId AS INTEGER),
  CAST(raceId AS INTEGER),
  CAST(driverId AS INTEGER),
  CAST(constructorId AS INTEGER),
  CAST(NULLIF(number, '\N') AS INTEGER),
  CAST(grid AS INTEGER),
  CAST(NULLIF(position, '\N') AS INTEGER),
  CAST(positionOrder AS INTEGER),
  CAST(points AS REAL),
  CAST(laps AS INTEGER),
  CAST(NULLIF(milliseconds, '\N') AS INTEGER),
  CAST(NULLIF(fastestLap, '\N') AS INTEGER),
  CAST(NULLIF(rank, '\N') AS INTEGER),
  NULLIF(fastestLapTime, '\N'),
  CAST(NULLIF(fastestLapSpeed, '\N') AS REAL),
  CAST(statusId AS INTEGER)
FROM raw_results;

DROP TABLE raw_results;

-- ---------- sprint_results ----------

CREATE TABLE raw_sprint_results (
  resultId TEXT, raceId TEXT, driverId TEXT, constructorId TEXT,
  number TEXT, grid TEXT, position TEXT, positionText TEXT,
  positionOrder TEXT, points TEXT, laps TEXT, time TEXT,
  milliseconds TEXT, fastestLap TEXT, fastestLapTime TEXT, statusId TEXT
);
.import --skip 1 data/sprint_results.csv raw_sprint_results

INSERT INTO sprint_results (sprint_result_id, race_id, driver_id, constructor_id,
                            number, grid, position, position_order, points, laps,
                            milliseconds, fastest_lap, fastest_lap_time, status_id)
SELECT
  CAST(resultId AS INTEGER),
  CAST(raceId AS INTEGER),
  CAST(driverId AS INTEGER),
  CAST(constructorId AS INTEGER),
  CAST(NULLIF(number, '\N') AS INTEGER),
  CAST(grid AS INTEGER),
  CAST(NULLIF(position, '\N') AS INTEGER),
  CAST(positionOrder AS INTEGER),
  CAST(points AS REAL),
  CAST(laps AS INTEGER),
  CAST(NULLIF(milliseconds, '\N') AS INTEGER),
  CAST(NULLIF(fastestLap, '\N') AS INTEGER),
  NULLIF(fastestLapTime, '\N'),
  CAST(statusId AS INTEGER)
FROM raw_sprint_results;

DROP TABLE raw_sprint_results;

-- ---------- qualifying ----------
-- Q1/Q2/Q3 pot fi \N sau sir gol pentru pilotii eliminati mai devreme.

CREATE TABLE raw_qualifying (
  qualifyId TEXT, raceId TEXT, driverId TEXT, constructorId TEXT,
  number TEXT, position TEXT, q1 TEXT, q2 TEXT, q3 TEXT
);
.import --skip 1 data/qualifying.csv raw_qualifying

INSERT INTO qualifying (qualify_id, race_id, driver_id, constructor_id,
                        number, position, q1, q2, q3)
SELECT
  CAST(qualifyId AS INTEGER),
  CAST(raceId AS INTEGER),
  CAST(driverId AS INTEGER),
  CAST(constructorId AS INTEGER),
  CAST(NULLIF(number, '\N') AS INTEGER),
  CAST(NULLIF(position, '\N') AS INTEGER),
  NULLIF(NULLIF(q1, '\N'), ''),
  NULLIF(NULLIF(q2, '\N'), ''),
  NULLIF(NULLIF(q3, '\N'), '')
FROM raw_qualifying;

DROP TABLE raw_qualifying;

-- ---------- pit_stops ----------
-- Sarim duration: text derivabil din milliseconds.

CREATE TABLE raw_pit_stops (
  raceId TEXT, driverId TEXT, stop TEXT, lap TEXT,
  time TEXT, duration TEXT, milliseconds TEXT
);
.import --skip 1 data/pit_stops.csv raw_pit_stops

INSERT INTO pit_stops (race_id, driver_id, stop, lap, time, milliseconds)
SELECT
  CAST(raceId AS INTEGER),
  CAST(driverId AS INTEGER),
  CAST(stop AS INTEGER),
  CAST(lap AS INTEGER),
  time,
  CAST(milliseconds AS INTEGER)
FROM raw_pit_stops;

DROP TABLE raw_pit_stops;

-- ---------- lap_times ----------
-- Sarim time: text derivabil din milliseconds.

CREATE TABLE raw_lap_times (
  raceId TEXT, driverId TEXT, lap TEXT, position TEXT,
  time TEXT, milliseconds TEXT
);
.import --skip 1 data/lap_times.csv raw_lap_times

INSERT INTO lap_times (race_id, driver_id, lap, position, milliseconds)
SELECT
  CAST(raceId AS INTEGER),
  CAST(driverId AS INTEGER),
  CAST(lap AS INTEGER),
  CAST(NULLIF(position, '\N') AS INTEGER),
  CAST(milliseconds AS INTEGER)
FROM raw_lap_times;

DROP TABLE raw_lap_times;

-- ---------- driver_standings ----------

CREATE TABLE raw_driver_standings (
  driverStandingsId TEXT, raceId TEXT, driverId TEXT,
  points TEXT, position TEXT, positionText TEXT, wins TEXT
);
.import --skip 1 data/driver_standings.csv raw_driver_standings

INSERT INTO driver_standings (driver_standings_id, race_id, driver_id, points, position, wins)
SELECT
  CAST(driverStandingsId AS INTEGER),
  CAST(raceId AS INTEGER),
  CAST(driverId AS INTEGER),
  CAST(points AS REAL),
  CAST(NULLIF(position, '\N') AS INTEGER),
  CAST(wins AS INTEGER)
FROM raw_driver_standings;

DROP TABLE raw_driver_standings;

-- ---------- constructor_standings ----------

CREATE TABLE raw_constructor_standings (
  constructorStandingsId TEXT, raceId TEXT, constructorId TEXT,
  points TEXT, position TEXT, positionText TEXT, wins TEXT
);
.import --skip 1 data/constructor_standings.csv raw_constructor_standings

INSERT INTO constructor_standings (constructor_standings_id, race_id, constructor_id, points, position, wins)
SELECT
  CAST(constructorStandingsId AS INTEGER),
  CAST(raceId AS INTEGER),
  CAST(constructorId AS INTEGER),
  CAST(points AS REAL),
  CAST(NULLIF(position, '\N') AS INTEGER),
  CAST(wins AS INTEGER)
FROM raw_constructor_standings;

DROP TABLE raw_constructor_standings;

-- ---------- constructor_results ----------

CREATE TABLE raw_constructor_results (
  constructorResultsId TEXT, raceId TEXT, constructorId TEXT,
  points TEXT, status TEXT
);
.import --skip 1 data/constructor_results.csv raw_constructor_results

INSERT INTO constructor_results (constructor_results_id, race_id, constructor_id, points, status)
SELECT
  CAST(constructorResultsId AS INTEGER),
  CAST(raceId AS INTEGER),
  CAST(constructorId AS INTEGER),
  CAST(NULLIF(points, '\N') AS REAL),
  NULLIF(status, '\N')
FROM raw_constructor_results;

DROP TABLE raw_constructor_results;
