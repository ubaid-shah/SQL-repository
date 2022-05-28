/* Session 3 – Merge Data from multiple tables

•	Speed up queries by limiting report size
•	Merge data from multiple tables with JOIN – Inner, Outer, Left and Right
•	Combine rows with UNION
•	Return data from multiple tables with IN
•	Selecting data using SUBQUERIES
•	Create SQL tables to store data
*/

USE sakila ;

------------------------------- Speed up queries by limiting report size ------------------------------------

SELECT * FROM payment LIMIT 50 ;

-------------------------------- Merge data from multiple tables with JOIN – Inner, Outer, Left and Right -----------------------------------

SELECT c.first_name, c.last_name, a.address
FROM customer c
INNER JOIN address a
ON c.address_id = a.address_id 
WHERE a.district = 'Buenos Aires' ;

------------------------- Combine rows with UNION ----------------------------------

SELECT 'actor' as tbl, DATE(last_update) FROM actor
UNION 
SELECT 'address' as tbl, DATE(last_update) FROM address ;

SELECT 'actor' as tbl, DATE(last_update) FROM actor
UNION ALL
SELECT 'address' as tbl, DATE(last_update) FROM address ;

-------------------------- Return data from multiple tables with IN ---------------------------

SELECT * 
FROM rental
WHERE customer_id IN 
(
	SELECT customer_id FROM customer
	WHERE first_name = 'jennifer'
) ;

--------------------------- Selecting data using SUBQUERIES ------------------------------------

SELECT title, rating, (rental_duration*rental_rate) AS rental_amount ,
ROW_NUMBER() OVER (PARTITION BY rating ORDER BY (rental_duration*rental_rate) desc) as Rnk
FROM film ;

SELECT a.title, a.rating, a.rental_amount, a.rnk
FROM
(
	SELECT title, rating, (rental_duration*rental_rate) AS rental_amount ,
	ROW_NUMBER() OVER (PARTITION BY rating ORDER BY (rental_duration*rental_rate) desc) as Rnk
	FROM film 
) a
WHERE a.Rnk = 1 ;

------------------------------------- Create SQL tables to store data ------------------------------------------

CREATE SCHEMA test_db ;

DROP SCHEMA test_db ;

USE ayush_sandbox ;

DROP TABLE film_top_rnk ;

CREATE TABLE film_top_rnk
SELECT a.title, a.rating, a.rental_amount, a.rnk
FROM
(
	SELECT title, rating, (rental_duration*rental_rate) AS rental_amount ,
	ROW_NUMBER() OVER (PARTITION BY rating ORDER BY (rental_duration*rental_rate) desc) as Rnk
	FROM sakila.film 
) a
WHERE a.Rnk = 1 ;

----------------------------- Import and Export of CSV files -------------------------------------------
