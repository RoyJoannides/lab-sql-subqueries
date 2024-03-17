-- Challenge
-- Write SQL queries to perform the following tasks using the Sakila database:
-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
SELECT 
    (SELECT COUNT(*) 
     FROM inventory 
     WHERE film_id = 
         (SELECT film_id 
          FROM film 
          WHERE title = 'Hunchback Impossible')
    ) AS num_copies;

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT 
    title,
    length
FROM 
    film
WHERE 
    length > (SELECT AVG(length) FROM film);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
SELECT 
    actor_id, 
    first_name, 
    last_name
FROM 
    actor
WHERE 
    actor_id IN (SELECT actor_id FROM film_actor WHERE film_id 
    = (SELECT film_id FROM film WHERE title = 'Alone Trip'));

-- Bonus:
-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. Identify all movies categorized as family films.
SELECT * 
FROM film 
WHERE film_id IN 
    (SELECT film_id 
     FROM film_category 
     WHERE category_id = 
         (SELECT category_id 
          FROM category 
          WHERE name = 'Family'));

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.
-- SUNQUERIES
SELECT 
    first_name, 
    last_name, 
    email 
FROM 
    customer 
WHERE 
    address_id IN 
        (SELECT 
            address_id 
         FROM 
            address 
         WHERE 
            city_id IN 
                (SELECT 
                    city_id 
                 FROM 
                    city 
                 WHERE 
                    country_id = 
                        (SELECT 
                            country_id 
                         FROM 
                            country 
                         WHERE 
                            country = 'Canada')
                )
        );

-- JOINS
SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.
-- 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.
SELECT title 
FROM film 
WHERE film_id IN 
    (SELECT film_id 
     FROM rental 
     WHERE rental_id IN 
         (SELECT rental_id 
          FROM payment 
          WHERE customer_id = 
              (SELECT customer_id 
               FROM (SELECT customer_id, SUM(amount) AS total_payments 
                     FROM payment 
                     GROUP BY customer_id 
                     ORDER BY total_payments DESC 
                     LIMIT 1) AS most_profitable_customer)));

-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.
SELECT customer_id, SUM(amount) AS total_amount_spent 
FROM payment 
GROUP BY customer_id 
HAVING SUM(amount) > 
    (SELECT AVG(total_amount_spent) 
     FROM (SELECT customer_id, SUM(amount) AS total_amount_spent 
           FROM payment 
           GROUP BY customer_id) AS avg_total_amount_spent);
