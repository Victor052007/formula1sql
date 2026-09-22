.mode column
.headers on

WITH left_after_1965 AS (
  SELECT r.driver_id
  FROM results r
  JOIN races ra ON ra.race_id = r.race_id
  WHERE ra.year = 1965
  EXCEPT
  SELECT r.driver_id
  FROM results r
  JOIN races ra ON ra.race_id = r.race_id
  WHERE ra.year = 1966
)
SELECT
  CASE WHEN r.driver_id IN (SELECT driver_id FROM left_after_1965)
       THEN 'left' ELSE 'stayed' END AS driver_group,
  ROUND(AVG((julianday(ra.date) - julianday(d.dob)) / 365.25), 2) AS avg_age,
  COUNT(*) AS entries
FROM results r
JOIN races ra  ON ra.race_id  = r.race_id
JOIN drivers d ON d.driver_id = r.driver_id
WHERE ra.year = 1965
GROUP BY driver_group;