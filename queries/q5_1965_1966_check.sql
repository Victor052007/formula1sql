.mode column
.headers on

WITH arrived_in_1966 AS (
  SELECT r.driver_id
  FROM results r
  JOIN races ra ON ra.race_id = r.race_id
  WHERE ra.year = 1966
  EXCEPT
  SELECT r.driver_id
  FROM results r
  JOIN races ra ON ra.race_id = r.race_id
  WHERE ra.year = 1965
)
SELECT
  CASE WHEN r.driver_id IN (SELECT driver_id FROM arrived_in_1966)
       THEN 'arrived' ELSE 'stayed' END AS driver_group,
  ROUND(AVG((julianday(ra.date) - julianday(d.dob)) / 365.25), 2) AS avg_age,
  COUNT(*) AS entries
FROM results r
JOIN races ra  ON ra.race_id  = r.race_id
JOIN drivers d ON d.driver_id = r.driver_id
WHERE ra.year = 1966
GROUP BY driver_group;