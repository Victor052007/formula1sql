.mode column
.headers on

SELECT d1.surname, r1.position, d2.surname, r2.position
FROM results r1
JOIN results r2 ON r1.race_id = r2.race_id
               AND r1.constructor_id = r2.constructor_id
               AND r1.driver_id != r2.driver_id
JOIN drivers d1 ON d1.driver_id = r1.driver_id
JOIN drivers d2 ON d2.driver_id = r2.driver_id
JOIN races ra  ON ra.race_id  = r1.race_id
WHERE ra.year = 2024
  AND r1.position IS NOT NULL
  AND r2.position IS NOT NULL;