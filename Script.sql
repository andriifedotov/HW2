--1

select t1.category_id as cat_id, category_name, sum (t1.film_id) as film_cnt 
from 
	(select film_id, category_id 
	 from film_category) t1
left join
	(select category_id, name as category_name
	 from category) t2
on t2.category_id = t1.category_id
group by t1.category_id, category_name
order by film_cnt desc;

--2

select t7.actor_id, first_name,last_name,count(rental_id) rental_cnt
from
	(select film_id
	from film) t2
join 	
	(select inventory_id, film_id
	from inventory) t4
on t4.film_id = t2.film_id 
join 
	(select rental_id, inventory_id
	from rental) t5
on t5.inventory_id = t4.inventory_id
join 
	(select film_id, actor_id
	from film_actor) t6
on t6.film_id = t2.film_id 
join 
	(select actor_id,first_name, last_name 
	from actor) t7
on t7.actor_id = t6.actor_id
group by t7.actor_id, first_name,last_name
order by rental_cnt desc
limit 10;
--3

select t1.category_id , name as category_name,sum(amount) amount
from
	(select film_id, category_id
	from film_category) t1
left join 
	(select film_id
	from film) t2
on t2.film_id = t1.film_id
left join 
	(select category_id, name
	from category) t3
on t3.category_id = t1.category_id
join 	
	(select inventory_id, film_id
	from inventory) t4
on t4.film_id = t2.film_id 
join 
	(select rental_id, inventory_id
	from rental) t5
on t5.inventory_id = t4.inventory_id
join
	(select amount, rental_id 
	from payment) t6
on t6.rental_id = t5.rental_id
group by t1.category_id, name 
order by amount desc
limit 1;
--4

select t2.film_id, title
from 
	(select film_id
	 from inventory) t1
right join
	(select film_id, title
	from film) t2
on t2.film_id = t1.film_id 
where t1.film_id is null

--5

select t1.actor_id, first_name, last_name, count(t1.film_id) as cnt
from 
	(select actor_id, film_id
	from film_actor) t1
join 
	(select actor_id, first_name, last_name
	from actor) t2
on t2.actor_id = t1.actor_id 
join 
	(select film_id, category_id
	from film_category) t3
on t3.film_id = t1.film_id
join 
	(select category_id, name
	from category) t4
on t4.category_id = t3.category_id
where t4.name = 'Children'
group by t1.actor_id, first_name, last_name 
order by cnt desc 
limit 19;

--6

select  t3.city_id, t3.city, sum( case when active = 1 then 1 else 0 end) as active,
sum( case when active != 1 then 1 else 0 end) as inactive
from 
	(select customer_id, address_id, active
	from customer) t1
join 
	(select address_id, city_id
	from address) t2
on t2.address_id = t1.address_id
join 
	(select city_id, city
	from city) t3
on t3.city_id = t2.city_id
group by t3.city, t3.city_id
order by inactive desc;

--7

select city, name, max(return_date - rental_date) as duration
from 
	(select customer_id, inventory_id, rental_date, return_date
	from rental) t1
join 
	(select customer_id, address_id
	from customer) t2
on t2.customer_id = t1.customer_id
join
	(select address_id, city_id
	from address) t3
on t3.address_id = t2.address_id
join
	(select inventory_id, film_id
	from inventory) t4
on t4.inventory_id = t1.inventory_id
join 
	(select film_id, category_id
	from film_category) t5
on t5.film_id = t4.film_id
join 
	(select name, category_id
	from category) t6
on t6.category_id = t5.category_id
join 
	(select city, city_id
	from city) t7
on t7.city_id = t3.city_id
where city ilike 'a%' or city ilike '%-%'
group by city, name
order by duration desc nulls last;







