USE sakila;

-- 1 --

# Self join the table film_actor as well as the table actor. Connect first self join of actor to first film_actor and second self join of actor to second film_actor
SELECT f1.film_id, concat(a1.first_name, ' ', a1.last_name)  AS actor1, concat(a2.first_name, ' ', a2.last_name) AS actor2
# SELECT f1.film_id, f1.actor_id  AS actor1, f2.actor_id AS actor2
FROM film_actor f1
	inner join film_actor f2 on f1.actor_id > f2.actor_id
	and f1.film_id = f2.film_id
    join actor a1 on f1.actor_id = a1.actor_id
    join actor a2 on f2.actor_id = a2.actor_id
#where f1.film_id = '1'
order by f1.film_id, actor1, actor2;

-- 2 --
# Test the order of joins and try with temporary tables
/*drop table if exists rental_customer;
CREATE temporary table rental_customer
SELECT r1.customer_id, r2.customer_id AS customer2, r1.rental_date 
	FROM rental r1
		join rental r2 on r1.customer_id > r2.customer_id
		and r1.rental_date = r2.rental_date
order by r1.rental_date, r1.customer_id, r2.customer_id;

SELECT * FROM rental_customer;
*/

# As one query. First get film rentals of customer 1, then roll back to check the film rentals for customer 2
SELECT concat(c1.first_name, ' ', c1.last_name)  AS customer1, concat(c2.first_name, ' ', c2.last_name)  AS customer2, count(f.title) AS nr_of_same_movies
FROM customer c1
	join rental r1 on c1.customer_id = r1.customer_id
    join inventory i1 on r1.inventory_id = i1.inventory_id
    join film f on i1.film_id = f.film_id
    join inventory i2 on f.film_id = i2.film_id
	join rental r2 on r2.inventory_id = i2.inventory_id
    join customer c2 on r2.customer_id = c2.customer_id
where c1.customer_id > c2.customer_id
group by customer1, customer2
having count(f.film_id) > 3
order by nr_of_same_movies DESC, customer1, customer2;

-- 3 --
SELECT f.title AS film_title, concat(a1.first_name, ' ', a1.last_name)  AS actor1, concat(a2.first_name, ' ', a2.last_name) AS actor2
FROM film_actor f1
	join film_actor f2 on f1.actor_id > f2.actor_id
    and f1.film_id = f2.film_id
    join actor a1 on f1.actor_id = a1.actor_id
    join actor a2 on f2.actor_id = a2.actor_id
    join film f on f1.film_id = f.film_id 
order by f.title, actor1, actor2;    
