-- How much does qualifying matter at each circuit?

.mode column
.headers on

SELECT c.name, AVG(ABS(r.position - r.grid)) AS movement
FROM results r
JOIN races ra ON ra.race_id = r.race_id
JOIN circuits c ON c.circuit_id = ra.circuit_id
WHERE r.position IS NOT NULL
  AND r.grid > 0
  AND ra.year >= 2010
GROUP BY c.circuit_id
having count(*) >=100
ORDER BY movement;