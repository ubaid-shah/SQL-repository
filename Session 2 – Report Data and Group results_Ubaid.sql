
/* Session 2 – Report Data and Group results

•	Filter results with WHERE
•	Sort results with ORDER BY
•	Transform results with STRING functions
•	Change result headings with alias
•	SQL WHERE with DATE functions
•	Aggregate results with GROUP BY and Numeric functions
•	Unique values with DISTINCT
•	Merge rows with GROUP BY and STRING functions
•	Rank results with RANK and ROW NUMBER
	
*/

------------------ Filtering results using WHERE -----------------------------------

SELECT first_name, last_name 
FROM actor 
WHERE first_name = 'penelope' ;

SELECT first_name, last_name 
FROM actor 
WHERE first_name <> 'PENELOPE' ;

SELECT actor_id, first_name, last_name 
FROM actor 
WHERE actor_id >5 and actor_id <20 ;

SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name = 'penelope' and actor_id <20 ;

SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name = 'penelope' or first_name = 'nick' ;

SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name = 'penelope' or actor_id <20  or first_name = 'ed' ;

SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name IN ('penelope','nick','ed') ;

SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name NOT IN ('penelope','nick','ed') ;

--------------- LIKE and Wildcards --------------------------------

SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name LIKE 'john%' ; -- starts with john

SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name LIKE 'k%' ; -- Starts with k

SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name LIKE '%l%' ; -- having l anywhere in name

SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name LIKE '_l' ; -- having l at second position

SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name LIKE '___n' ; -- having n at fourth position

SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name LIKE 'j%__n' ; -- starts with j and after that at third position n will be there

SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name LIKE 'j%n' ; -- starts with j and ends with n

SELECT actor_id, first_name, last_name 
FROM actor 
WHERE first_name NOT LIKE 'j%n' ; -- not (starts with j and ends with n)

-------------------- USING AND and OR together - Address table ----------------------

SELECT * from address ;

SELECT * 
FROM address 
WHERE district = 'Buenos Aires'
AND (address LIKE '%El%' or address LIKE '%Al%') ;

--------------------- Sorting results using ORDER BY --------------------------

SELECT first_name, last_name 
FROM actor 
WHERE first_name = 'PENELOPE' 
ORDER BY last_name;

SELECT first_name, last_name 
FROM actor 
WHERE first_name = 'PENELOPE' 
ORDER BY last_name DESC;

-- Write a Query to diplay the top 30 results in descending order of First Name 



---------------------------------- Transform results with STRING functions -------------------------------------

SELECT first_name, LENGTH(first_name) 
FROM actor ;

SELECT first_name, last_name, CONCAT(last_name,', ',first_name) , LENGTH(CONCAT(last_name,', ',first_name))
FROM actor ;

SELECT first_name, last_name, CONCAT(last_name,', ',first_name) , LENGTH(CONCAT(last_name,', ',first_name))
FROM actor 
ORDER BY LENGTH(CONCAT(last_name,', ',first_name)) DESC;

SELECT first_name, last_name, LOWER(CONCAT(last_name,', ',first_name)), UPPER(CONCAT(last_name,', ',first_name))
FROM actor ;

SELECT first_name, LEFT(first_name,3), RIGHT(first_name,5)
FROM actor ;

SELECT first_name, SUBSTRING(first_name,1,5) 
FROM actor ;

SELECT *,
SUBSTRING_INDEX(title, ' ', 1) as first_half, 
SUBSTRING_INDEX(title, ' ', -1) as second_half 
FROM sakila.film_text; -- SUBSTRING_INDEX(str,delim,count)

-- Write a Query to Capitalize only the first letter of the First Name


SELECT first_name, TRIM(first_name) 
FROM actor ;

SELECT first_name, last_name  
FROM actor 
WHERE TRIM(first_name) = 'GRACE';

SELECT description, TRIM(LEADING 'A ' from description)
FROM film_text ;

SELECT description, TRIM(TRAILING 'A ' from description)
FROM film_text ;

SELECT description, TRIM(BOTH 'A ' from description)
FROM film_text ;

SELECT first_name, LOCATE('LOPE', first_name) 
FROM actor ;

--------------------------------------------- Change result headings with alias ---------------------------------

SELECT first_name, last_name, CONCAT(last_name,', ',first_name) as full_name , LENGTH(CONCAT(last_name,', ',first_name)) as len
FROM actor ;

-- Can aliases be used for ORDER BY and WHERE?


--------------------------------------------- SQL WHERE with DATE functions -------------------------------------

SELECT *, YEAR(last_update) as Year, MONTH(last_update) as Month, DAY(last_update) as Day, TIME(last_update) as Time, DATE(last_update) as Date  
FROM actor ;

SELECT 
last_update, 
concat(DAY(last_update),'/',MONTH(last_update),'/',YEAR(last_update)) as newDate, 
DATE(last_update) as Date  
FROM actor ;


SELECT *
FROM actor 
WHERE YEAR(last_update) = 2006 ;

--------------------------------------------- Aggregate results with GROUP BY and Numeric functions -----------------------------------

SELECT * FROM address;

SELECT COUNT(*)
FROM address;

SELECT COUNT(*), COUNT(address), COUNT(address2)
FROM address;

SELECT district, COUNT(*) as cnt
FROM address 
GROUP BY district 
ORDER BY cnt desc ;

SELECT district, COUNT(*) as cnt
FROM address 
GROUP BY district
HAVING cnt>5 
ORDER BY cnt desc ;

SELECT * FROM film ;

SELECT MIN(rental_duration), MAX(rental_duration), SUM(rental_duration), AVG(rental_duration)
FROM film ;

SELECT rating, SUM(rental_duration), AVG(rental_duration)
FROM film 
GROUP BY rating ;

---------------------------------- Unique values with DISTINCT ----------------------------------------

SELECT DISTINCT district
FROM address ;

SELECT DISTINCT district, address
FROM address 
ORDER BY district ;

SELECT DISTINCT CONCAT(first_name,'//',last_update)
FROM actor ;

------------------------------------ Merge rows with GROUP BY and STRING functions -----------------------------------

SELECT district, GROUP_CONCAT(phone)
FROM address 
group by DISTRICT ;

SELECT district, GROUP_CONCAT(phone ORDER BY phone ASC SEPARATOR ';')
FROM address 
group by DISTRICT ;

---------------------------------- Rank results with RANK and ROW NUMBER --------------------------------------------------

SELECT * FROM film ;

SELECT title, rental_duration, rental_rate, (rental_duration*rental_rate) AS rental_amount
FROM film ;

SELECT title, rental_duration,
RANK() OVER (ORDER BY rental_duration desc) as Rnk
FROM film ;

SELECT title, (rental_duration*rental_rate) AS rental_amount ,
RANK() OVER (ORDER BY (rental_duration*rental_rate) desc) as Rnk
FROM film ;

SELECT title, rental_duration,
DENSE_RANK() OVER (ORDER BY rental_duration desc) as Rnk
FROM film ;

SELECT title, rental_duration,
ROW_NUMBER() OVER (ORDER BY rental_duration desc) as Rnk
FROM film ;

SELECT title, rating, (rental_duration*rental_rate) AS rental_amount ,
ROW_NUMBER() OVER (PARTITION BY rating ORDER BY (rental_duration*rental_rate) desc) as Rnk
FROM film ;

