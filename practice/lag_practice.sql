.mode column
.headers on

WITH season_ages AS (
  SELECT
    ra.year,
    AVG((julianday(ra.date) - julianday(d.dob)) / 365.25) AS age
  FROM results r
  JOIN drivers d ON d.driver_id = r.driver_id
  JOIN races ra  ON ra.race_id  = r.race_id
  GROUP BY ra.year
)
SELECT
  year,
  age,
  LAG(age) OVER (ORDER BY year) AS previous_age,
  round(age - LAG(age) OVER (ORDER BY year),2) AS change
FROM season_ages
ORDER BY change DESC;