SELECT * FROM world.city;
use world;
create view India as (
select * from city 
where countrycode="IND");


select countrycode, name from world.city;

