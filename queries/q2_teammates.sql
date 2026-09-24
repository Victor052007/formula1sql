.mode column
.headers on

SELECT
  ra.year,
  d1.surname,
  COUNT(*) AS duels,
  SUM(CASE WHEN r1.position < r2.position THEN 1 ELSE 0 END) AS wins,
  ROUND(SUM(CASE WHEN r1.position < r2.position THEN 1 ELSE 0 END) * 1.0 / COUNT(*), 2) AS win_rate,
  ROUND(AVG(r2.position - r1.position), 2) AS avg_gap
FROM results r1
JOIN results r2  ON r1.race_id = r2.race_id
                AND r1.constructor_id = r2.constructor_id
                AND r1.driver_id != r2.driver_id
JOIN drivers d1  ON d1.driver_id = r1.driver_id
JOIN races ra    ON ra.race_id = r1.race_id
JOIN circuits c  ON c.circuit_id = ra.circuit_id
WHERE r1.position IS NOT NULL
  AND r2.position IS NOT NULL
  AND c.circuit_ref != 'indianapolis'
GROUP BY ra.year, d1.driver_id
HAVING COUNT(*) >= 7
ORDER BY win_rate DESC;