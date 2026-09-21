--Change years to see different pilots from year to year
.mode column
.headers on
select  distinct d.forename,d.surname from results r
JOIN drivers d ON d.driver_id = r.driver_id
JOIN races ra  ON ra.race_id  = r.race_id
where ra.year=2013
except
select  distinct d.forename,d.surname from results r
JOIN drivers d ON d.driver_id = r.driver_id
JOIN races ra  ON ra.race_id  = r.race_id
where ra.year=2012;
