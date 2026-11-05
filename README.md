# Formula 1 SQL

Formula 1 database built from scratch (custom schema, not imported), using Ergast data from 1950–2024.

## Data

The data was taken from the [Formula 1 World Championship dataset on Kaggle](https://www.kaggle.com/datasets/rohanrao/formula-1-world-championship-1950-2020), which sourced it from Ergast and optimized and organized it for SQL work.

The CSVs are not in this repo, only the import script.

## How to run

Download the CSVs from Kaggle into a `data/` folder, then:

```bash
sqlite3 f1.db < schema.sql
sqlite3 f1.db < import.sql
sqlite3 f1.db < queries/q3_qualifying_by_circuit.sql
```

## Schema

14 tables with foreign keys. `results` is the central table, almost every question starts there.

| Table | What it contains | Linking columns |
|---|---|---|
| races | one row per race | race_id, year, round, circuit_id |
| results | one row per driver per race | race_id, driver_id, constructor_id, grid, position_order, status_id |
| qualifying | qualifying times | race_id, driver_id, q1, q2, q3 |
| pit_stops | every pit stop | race_id, driver_id, stop, lap, milliseconds |
| lap_times | every lap (~600k rows) | race_id, driver_id, lap, milliseconds |
| drivers / constructors / circuits | who and where | driver_id, constructor_id, circuit_id |
| status | why a driver retired from the race | status_id |

Plus seasons, sprint_results, driver_standings, constructor_standings and constructor_results.

`results` has no `UNIQUE (race_id, driver_id)`: races between 1950 and 1960 have more than one row for the same driver, because if your car broke down you could drive your teammate's car, and cars could have multiple drivers. More in [docs/notes.md](docs/notes.md).

## The questions

The questions where you can't find the answer on wikipedia or reddit.

1. How competitive did F1 remain through eras? *(not done yet)*
2. In every season which driver really outperformed the car? (measured against their teammate) → [docs/q2_teammates.md](docs/q2_teammates.md)
3. How much does qualifying matter at each circuit? → [docs/q3_qualifying_by_circuit.md](docs/q3_qualifying_by_circuit.md)
4. Which teams improved most within a single season? *(not done yet)*
5. Did the grid really get much younger? → [docs/q5_grid_age.md](docs/q5_grid_age.md)

### A few things I found

**Q2.** The list of drivers who never lost a duel to their teammate is mostly world champions, which is the best sign the metric measures something real. The biggest single season is Fangio 1957: 24 duels, 24 wins, an average of 5.17 positions ahead.

**Q3.** Few overtakes on two circuits doesn't mean overtaking is equally difficult. On high-speed permanent circuits like Monza, the finishing order often matches the grid, so very little overtaking is needed. On tight street circuits like Monaco, the few overtakes come from the fact that overtaking is physically difficult.

**Q5.** The average age peaked in 1950 at 39.2 years and fell to 31.1 by 1961. It hit an all-time low of 27.4 in 2014, then went back up: all 20 drivers who started 2024 had already raced in 2023, and the average rose by a full year, to 29.6, the oldest grid since 1995.

## Optimizing

The teammate query was taking 1.63 seconds. `results` has 26,759 rows and the query joins the table to itself. `EXPLAIN QUERY PLAN` showed it was using the constructor index, which is a bad fit: a big team has hundreds of rows across all seasons, so for every row it checked all of them and only then filtered by race.

```sql
CREATE INDEX idx_results_race_constructor ON results (race_id, constructor_id);
```

1.63s → 0.023s, about 71 times faster. Same query, same data, one extra line in `schema.sql`.

## Known pitfalls

- Ergast uses `\N` for missing values (a MySQL legacy). During import they become literal text, so `IS NULL` does not catch anything. `import.sql` turns them into real NULLs with `NULLIF`.
- In the raw database everything is TEXT, so `ORDER BY grid` sorts alphabetically, putting 10 before 2. Workaround: `CAST(grid AS INTEGER)`.
- `sqlite3` looks for the `.db` relative to the current directory. If the filename does not exist, it creates a new empty database instead of returning an error.

## Repository structure

```
schema.sql     the 14 tables, foreign keys and indexes
import.sql     imports the Kaggle CSVs into the schema
queries/       one file per question
docs/          the analysis for each question + notes
practice/      practice queries (LAG)
```

## Next

- Package the analytical queries as views
- Move to local PostgreSQL + a Python script that fetches the current season from Jolpica
