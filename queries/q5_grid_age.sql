-- Did the grid really get younger?

.mode column
.headers on

SELECT
  ra.year,
  AVG((julianday(ra.date) - julianday(d.dob)) / 365.25) AS age
FROM results r
JOIN drivers d ON d.driver_id = r.driver_id
JOIN races ra  ON ra.race_id  = r.race_id
GROUP BY ra.year
ORDER BY ra.year;