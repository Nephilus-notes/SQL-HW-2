-- 1. List all customers who live in Texas(use Joins)
SELECT *
FROM customer 
JOIN address 
ON address.address_id = customer.address_id 
WHERE district = 'Texas';

-- 2. Get all payments above $6.99 with the customer's full name
SELECT amount, first_name, last_name, payment_date
FROM payment 
JOIN customer 
ON payment.customer_id = customer.customer_id 
WHERE amount > 6.99



-- 3. Show all customers' names who have made payments over $175(Use subqueries)
--
--SELECT customer_id, sum(amount)
--FROM payment 
--GROUP BY customer_id
--HAVING sum(amount) > 175;

SELECT first_name, last_name
FROM customer 
WHERE customer_id IN (
	SELECT customer_id
	FROM payment 
	GROUP BY customer_id
	HAVING sum(amount) > 175
);


-- 4. List all customers that live in Nepal(use the city Table)

SELECT first_name, last_name
FROM city 
JOIN country 
ON country.country_id = city.country_id 
JOIN address 
ON address.city_id =city.city_id 
JOIN customer 
ON customer.address_id = address.address_id 
WHERE country.country = 'Nepal'



-- 5. Which staff member had the most transactions? staff_id 1, Mike Hillyer
--
--SELECT first_name, last_name, count(*)
--FROM rental
--JOIN staff 
--ON staff.staff_id = rental.staff_id 
--GROUP BY (first_name, last_name );
--
--SELECT max(count)
--FROM (
--	SELECT staff.staff_id, count(*)
--		FROM rental
--		JOIN staff 
--		ON staff.staff_id = rental.staff_id 
--		GROUP BY staff.staff_id 
--) AS staff_max_transactions;

SELECT staff_id
FROM (
	SELECT staff.staff_id, count(*)
	FROM rental
	JOIN staff 
	ON staff.staff_id = rental.staff_id 
	GROUP BY staff.staff_id 
	) staff_transactions
WHERE count = (
	SELECT max(count)
FROM (
	SELECT staff.staff_id, count(*)
		FROM rental
		JOIN staff 
		ON staff.staff_id = rental.staff_id 
		GROUP BY staff.staff_id 
) AS staff_max_transactions
);

SELECT first_name, last_name
FROM (
	SELECT first_name, last_name, count(*)
	FROM rental
	JOIN staff 
	ON staff.staff_id = rental.staff_id 
	GROUP BY (first_name, last_name )
	) staff_transactions
WHERE count = (
	SELECT max(count)
FROM (
	SELECT staff.staff_id, count(*)
		FROM rental
		JOIN staff 
		ON staff.staff_id = rental.staff_id 
		GROUP BY staff.staff_id 
) AS staff_max_transactions
);


--
--
--CREATE OR REPLACE VIEW staff_trans
--AS 
--	SELECT staff.staff_id, count(*)
--	FROM rental
--	JOIN staff 
--	ON staff.staff_id = rental.staff_id 
--	GROUP BY staff.staff_id 
;
-- 6. How many movies of each rating are there?
SELECT rating, count(*)
FROM film
GROUP BY rating 

-- 7. Show all customers who have made a single payment above $6.99 (Use Subqueries)
--SELECT *
--FROM payment
--JOIN customer 
--ON customer.customer_id = payment.customer_id 
--WHERE amount > 6.99;

SELECT FIRST_name, last_name, count(amount)
FROM (
	SELECT *
	FROM payment
	JOIN customer 
	ON customer.customer_id = payment.customer_id 
	WHERE amount > 6.99
) AS customerabove7
GROUP BY (first_name, last_name)
having count(amount) = 1;

-- 8. How many free rentals did our stores give away?
SELECT count(*)
FROM payment 
WHERE amount = 0.00
