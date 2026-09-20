# Notes

Decisions and data quirks found while building the database.

## 2026-09-20 — Duplicate driver entries in `results`

Races between 1950 and 1960 have multiple rows for the same driver in the
same race. My first assumption was poor record-keeping. The real cause:
shared drives were legal then — a driver whose car failed could take over a
teammate's car, and some entries had multiple drivers by design.

The import failed with `UNIQUE constraint failed: results.race_id,
results.driver_id` until I found this.

**Consequence:** dropped the `UNIQUE (race_id, driver_id)` constraint from
`results`. Any query counting finishes per driver has to account for it.
