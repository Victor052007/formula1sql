-- =====================================================
-- F1 Database — schema curată
-- Portabil: rulează pe SQLite (etapa 3) și PostgreSQL (etapa 6)
-- Importabil în DrawSQL / drawDB / dbdiagram (File -> Import -> SQL)
-- Salvează în ~/dev/f1db/sql/schema.sql
-- =====================================================

-- ---------- Tabele de referință ----------

CREATE TABLE seasons (
  year    INTEGER PRIMARY KEY,
  url     VARCHAR(255)
);

CREATE TABLE circuits (
  circuit_id   INTEGER PRIMARY KEY,
  circuit_ref  VARCHAR(50)  NOT NULL UNIQUE,
  name         VARCHAR(100) NOT NULL,
  location     VARCHAR(100),
  country      VARCHAR(100),
  lat          NUMERIC(9,6),
  lng          NUMERIC(9,6),
  alt          INTEGER,
  url          VARCHAR(255)
);

CREATE TABLE constructors (
  constructor_id   INTEGER PRIMARY KEY,
  constructor_ref  VARCHAR(50)  NOT NULL UNIQUE,
  name             VARCHAR(100) NOT NULL,
  nationality      VARCHAR(50),
  url              VARCHAR(255)
);

CREATE TABLE drivers (
  driver_id    INTEGER PRIMARY KEY,
  driver_ref   VARCHAR(50) NOT NULL UNIQUE,
  number       INTEGER,
  code         VARCHAR(3),
  forename     VARCHAR(50) NOT NULL,
  surname      VARCHAR(50) NOT NULL,
  dob          DATE,
  nationality  VARCHAR(50),
  url          VARCHAR(255)
);

CREATE TABLE status (
  status_id  INTEGER PRIMARY KEY,
  status     VARCHAR(100) NOT NULL UNIQUE
);

-- ---------- Evenimente ----------

CREATE TABLE races (
  race_id     INTEGER PRIMARY KEY,
  year        INTEGER      NOT NULL,
  round       INTEGER      NOT NULL,
  circuit_id  INTEGER      NOT NULL,
  name        VARCHAR(100) NOT NULL,
  date        DATE         NOT NULL,
  time        TIME,
  url         VARCHAR(255),
  CONSTRAINT uq_races_year_round UNIQUE (year, round),
  CONSTRAINT fk_races_season  FOREIGN KEY (year)       REFERENCES seasons (year),
  CONSTRAINT fk_races_circuit FOREIGN KEY (circuit_id) REFERENCES circuits (circuit_id)
);

-- ---------- Rezultate ----------

CREATE TABLE results (
  result_id          INTEGER PRIMARY KEY,
  race_id            INTEGER NOT NULL,
  driver_id          INTEGER NOT NULL,
  constructor_id     INTEGER NOT NULL,
  number             INTEGER,
  grid               INTEGER NOT NULL,
  position           INTEGER,               -- NULL = n-a terminat
  position_order     INTEGER NOT NULL,
  points             NUMERIC(5,2) NOT NULL,
  laps               INTEGER NOT NULL,
  milliseconds       INTEGER,
  fastest_lap        INTEGER,
  rank               INTEGER,
  fastest_lap_time   TIME,
  fastest_lap_speed  NUMERIC(6,3),
  status_id          INTEGER NOT NULL,
  CONSTRAINT uq_results_race_driver UNIQUE (race_id, driver_id),
  CONSTRAINT fk_results_race        FOREIGN KEY (race_id)        REFERENCES races (race_id),
  CONSTRAINT fk_results_driver      FOREIGN KEY (driver_id)      REFERENCES drivers (driver_id),
  CONSTRAINT fk_results_constructor FOREIGN KEY (constructor_id) REFERENCES constructors (constructor_id),
  CONSTRAINT fk_results_status      FOREIGN KEY (status_id)      REFERENCES status (status_id)
);

CREATE TABLE sprint_results (
  sprint_result_id  INTEGER PRIMARY KEY,
  race_id           INTEGER NOT NULL,
  driver_id         INTEGER NOT NULL,
  constructor_id    INTEGER NOT NULL,
  number            INTEGER,
  grid              INTEGER NOT NULL,
  position          INTEGER,
  position_order    INTEGER NOT NULL,
  points            NUMERIC(5,2) NOT NULL,
  laps              INTEGER NOT NULL,
  milliseconds      INTEGER,
  fastest_lap       INTEGER,
  fastest_lap_time  TIME,
  status_id         INTEGER NOT NULL,
  CONSTRAINT uq_sprint_race_driver UNIQUE (race_id, driver_id),
  CONSTRAINT fk_sprint_race        FOREIGN KEY (race_id)        REFERENCES races (race_id),
  CONSTRAINT fk_sprint_driver      FOREIGN KEY (driver_id)      REFERENCES drivers (driver_id),
  CONSTRAINT fk_sprint_constructor FOREIGN KEY (constructor_id) REFERENCES constructors (constructor_id),
  CONSTRAINT fk_sprint_status      FOREIGN KEY (status_id)      REFERENCES status (status_id)
);

CREATE TABLE qualifying (
  qualify_id      INTEGER PRIMARY KEY,
  race_id         INTEGER NOT NULL,
  driver_id       INTEGER NOT NULL,
  constructor_id  INTEGER NOT NULL,
  number          INTEGER,
  position        INTEGER,
  q1              TIME,
  q2              TIME,
  q3              TIME,
  CONSTRAINT uq_qualifying_race_driver UNIQUE (race_id, driver_id),
  CONSTRAINT fk_qualifying_race        FOREIGN KEY (race_id)        REFERENCES races (race_id),
  CONSTRAINT fk_qualifying_driver      FOREIGN KEY (driver_id)      REFERENCES drivers (driver_id),
  CONSTRAINT fk_qualifying_constructor FOREIGN KEY (constructor_id) REFERENCES constructors (constructor_id)
);

-- ---------- Date tur cu tur ----------

CREATE TABLE pit_stops (
  race_id       INTEGER NOT NULL,
  driver_id     INTEGER NOT NULL,
  stop          INTEGER NOT NULL,
  lap           INTEGER NOT NULL,
  time          TIME    NOT NULL,   -- ora din zi
  milliseconds  INTEGER NOT NULL,   -- durata opririi
  CONSTRAINT pk_pit_stops PRIMARY KEY (race_id, driver_id, stop),
  CONSTRAINT fk_pit_stops_race   FOREIGN KEY (race_id)   REFERENCES races (race_id),
  CONSTRAINT fk_pit_stops_driver FOREIGN KEY (driver_id) REFERENCES drivers (driver_id)
);

CREATE TABLE lap_times (
  race_id       INTEGER NOT NULL,
  driver_id     INTEGER NOT NULL,
  lap           INTEGER NOT NULL,
  position      INTEGER,
  milliseconds  INTEGER NOT NULL,
  CONSTRAINT pk_lap_times PRIMARY KEY (race_id, driver_id, lap),
  CONSTRAINT fk_lap_times_race   FOREIGN KEY (race_id)   REFERENCES races (race_id),
  CONSTRAINT fk_lap_times_driver FOREIGN KEY (driver_id) REFERENCES drivers (driver_id)
);

-- ---------- Clasamente (snapshot după fiecare cursă) ----------

CREATE TABLE driver_standings (
  driver_standings_id  INTEGER PRIMARY KEY,
  race_id              INTEGER NOT NULL,
  driver_id            INTEGER NOT NULL,
  points               NUMERIC(6,2) NOT NULL,
  position             INTEGER,
  wins                 INTEGER NOT NULL,
  CONSTRAINT uq_driver_standings UNIQUE (race_id, driver_id),
  CONSTRAINT fk_driver_standings_race   FOREIGN KEY (race_id)   REFERENCES races (race_id),
  CONSTRAINT fk_driver_standings_driver FOREIGN KEY (driver_id) REFERENCES drivers (driver_id)
);

CREATE TABLE constructor_standings (
  constructor_standings_id  INTEGER PRIMARY KEY,
  race_id                   INTEGER NOT NULL,
  constructor_id            INTEGER NOT NULL,
  points                    NUMERIC(6,2) NOT NULL,
  position                  INTEGER,
  wins                      INTEGER NOT NULL,
  CONSTRAINT uq_constructor_standings UNIQUE (race_id, constructor_id),
  CONSTRAINT fk_cstandings_race        FOREIGN KEY (race_id)        REFERENCES races (race_id),
  CONSTRAINT fk_cstandings_constructor FOREIGN KEY (constructor_id) REFERENCES constructors (constructor_id)
);

CREATE TABLE constructor_results (
  constructor_results_id  INTEGER PRIMARY KEY,
  race_id                 INTEGER NOT NULL,
  constructor_id          INTEGER NOT NULL,
  points                  NUMERIC(5,2),
  status                  VARCHAR(10),      -- 'D' sau NULL
  CONSTRAINT uq_constructor_results UNIQUE (race_id, constructor_id),
  CONSTRAINT fk_cresults_race        FOREIGN KEY (race_id)        REFERENCES races (race_id),
  CONSTRAINT fk_cresults_constructor FOREIGN KEY (constructor_id) REFERENCES constructors (constructor_id)
);

-- ---------- Indexuri ----------

CREATE INDEX idx_results_driver       ON results (driver_id);
CREATE INDEX idx_results_constructor  ON results (constructor_id);
CREATE INDEX idx_results_status       ON results (status_id);
CREATE INDEX idx_races_year           ON races (year);
CREATE INDEX idx_lap_times_driver     ON lap_times (driver_id);
CREATE INDEX idx_pit_stops_driver     ON pit_stops (driver_id);
