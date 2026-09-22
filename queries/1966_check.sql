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
SELECT ra.name, COUNT(*) AS entries
FROM results r
JOIN races ra ON ra.race_id = r.race_id
WHERE ra.year = 1965
  AND r.driver_id IN (SELECT driver_id FROM left_after_1965)
GROUP BY ra.name
ORDER BY entries DESC;