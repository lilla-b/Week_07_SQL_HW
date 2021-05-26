/*
Week 07 Homework File
Lilla Bartkó
26 May 2021
*/

/* 1.Create a new column called “status” in the rental table that uses a case statement 
to indicate if a film was returned late, early, or on time. */

/* Here I use three tables and connect using inner joins. In the CASE statement,
I use DATE_PART to extract the days for the conditional/classifying clauses.
*/

SELECT fi.title,rental_id,rental_date,return_date,fi.rental_duration,
	DATE_PART('day',return_date-rental_date) AS actual_duration,
	CASE WHEN re.return_date IS null THEN 'Not returned'
		 WHEN fi.rental_duration > DATE_PART('day',return_date-rental_date) then 'early'
		 WHEN fi.rental_duration < DATE_PART('day',return_date-rental_date) then 'late'
		 ELSE 'ontime' END AS status
FROM film AS fi
INNER JOIN inventory AS inv USING (film_id)
INNER JOIN rental AS re USING (inventory_id);

/****************************************************/

/* 2.Show the total payment amounts for people who live in Kansas City or Saint Louis.
payment, customer, address, city */


SELECT ci.city, SUM(pay.amount) AS total_pay
FROM payment AS pay
INNER JOIN customer AS cu ON pay.customer_id = cu.customer_id
INNER JOIN address AS ad ON cu.address_id = ad.address_id
INNER JOIN city AS ci ON ci.city_id = ad.city_id
WHERE ci.city IN ('Saint Louis', 'Kansas City')
GROUP BY ci.city;

/****************************************************/

/* 3.How many film categories are in each category? Why do you think there is a 
table for category and a table for film category? */

/* There are 16 film categories. I obtained that result by using this query: */

SELECT category_id, COUNT(*) AS film_count FROM film_category
GROUP BY category_id
ORDER BY category_id;

/****************************************************/

/* 4. Show a roster for the staff that includes their email, address, city, and country (not ids),
staff, address, city, country. */

/* For readability, I chose to concatenate first and last names: */

SELECT first_name || ' ' || last_name AS full_name, s.email, ad.address, ci.city, cu.country
FROM staff AS s
INNER JOIN address AS ad ON s.address_id = ad.address_id
INNER JOIN city AS ci ON ci.city_id = ad.city_id
INNER JOIN country AS cu ON cu.country_id = ci.country_id;

/****************************************************/

/* 5. Show the film_id, title, and length for the movies that were returned from May 15 to 
31, 2005 */

/* Distinct movies rented between '2005-05-15' and '2005-05-31': */

SELECT f.film_id, f.title, f.length
FROM film AS f
WHERE film_id IN (SELECT i.film_id FROM rental AS r
				 INNER JOIN inventory AS i ON i.inventory_id = r.inventory_id
				 WHERE return_date BETWEEN '2005-05-15 00:00:00' AND '2005-05-31 23:59:59');
				  
/****************************************************/

/* 6. Write a subquery to show which movies are rented below the average price 
for all movies. */

/* As some movies have been rented more than once, I used "DISTINCT" to filter out 
duplicate titles. */

SELECT DISTINCT f.film_id,f.title,f.rental_rate
FROM film f
INNER JOIN inventory inv ON f.film_id = inv.film_id
INNER JOIN rental r ON inv.inventory_id = r.inventory_id
WHERE f.rental_rate < (SELECT AVG(rental_rate) FROM film)
ORDER BY f.film_id,f.rental_rate DESC;

/****************************************************/

/* 7. Write a join statement to show which movies are rented below the average 
price for all movies. */

SELECT DISTINCT f.film_id,f.title,f.rental_rate
FROM film f
INNER JOIN inventory inv ON f.film_id = inv.film_id
INNER JOIN rental r ON inv.inventory_id = r.inventory_id
JOIN (SELECT AVG(rental_rate) avg_price FROM film) AS flm
ON rental_rate < flm.avg_price;

/****************************************************/

/* 8. Perform an explain plan on 6 and 7, and describe what you're seeing and 
important ways they differ. */

/* Explain plan for question 6: */

EXPLAIN ANALYZE SELECT DISTINCT f.film_id,f.title,f.rental_rate
FROM film f
INNER JOIN inventory inv ON f.film_id = inv.film_id
INNER JOIN rental r ON inv.inventory_id = r.inventory_id
WHERE f.rental_rate < (SELECT AVG(rental_rate) FROM film)
ORDER BY f.film_id,f.rental_rate DESC;

/* Explain plan for question 7: */

EXPLAIN ANALYZE SELECT DISTINCT f.film_id,f.title,f.rental_rate
FROM film f
INNER JOIN inventory inv ON f.film_id = inv.film_id
INNER JOIN rental r ON inv.inventory_id = r.inventory_id
JOIN (SELECT AVG(rental_rate) avg_price FROM film) AS flm
ON rental_rate < flm.avg_price;

/* The subquery method had a lower estimate and actual measurement of cost. The biggest 
difference between the two explain plans was the number of rows in the cost estimate for the JOIN approach. 

If you replace the "ANALYZE" command with FORMAT (JSON), you get a diagram of nodes and 
process flow, which, to me, is a good aid to understanding what the explain plan is doing. In general, 
it seems that the subquery is taking a larger set of data and immediatley chopping out 
the useful stuff, while the joining method is aggregating the useful stuff as needed. The latter
seems like it would cost more in terms of time and storage, especially at scale. I hope to return to this question at a later date and expound,
but in the interest of time, I'm moving ahead, even though I don't fully understand this 
right now. */

/****************************************************/

/* 9. With a window function, write a query that shows the film, 
its duration, and what percentile the duration fits into. */

SELECT f.title,f.length AS duration,
	PERCENT_RANK() OVER(ORDER BY f.length)
FROM film AS f
INNER JOIN film_category AS fi USING (film_id)
ORDER BY PERCENT_RANK DESC;

/****************************************************/

/* 10. In under 100 words, explain what the difference is between set-based and procedural programming.
Be sure to specify which sql and python are. */

/* “Procedural programming” is often what comes to mind when we hear the word "programming". 
In this style of coding, we “tell” the system what to do, and HOW to do it.  We specify the logical 
flow of information by explicitly defining structures like loops, conditional statements, functions, 
etc., to obtain our results. This style can be used effectively in Python, although the object-oriented 
style is widely used.

In set-based programming, we only specify WHAT to do. We specify a set of data (original table or one 
created from joins, etc.) and our desired result. We do not specify how to implement operations (e.g. joins, 
filtering, etc.). The database "engine" determines processing logic. The query optimizer makes an execution 
plan; executing the plan tree is faster than the alternative procedural style (i.e. using user-defined 
functions, resulting in execution plans for each row). In this course, we have been using set-based SQL. */



