--=============== МОДУЛЬ 3. ОСНОВЫ SQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Выведите для каждого покупателя его адрес проживания, 
--город и страну проживания.

select concat(c2.first_name, ' ', c2.last_name) as "name", c.city, a.address, c3.country
from address a 
left join city c on a.city_id = c.city_id
left join customer c2 on a.address_id = c2.address_id 
left join country c3 on c.country_id =c3.country_id 


--ЗАДАНИЕ №2
--С помощью SQL-запроса посчитайте для каждого магазина количество его покупателей.

select store_id, count(customer_id) number_of_customers
from customer c
group by store_id 


--Доработайте запрос и выведите только те магазины, 
--у которых количество покупателей больше 300-от.
--Для решения используйте фильтрацию по сгруппированным строкам 
--с использованием функции агрегации.

select store_id, count(customer_id) as "more than 300 customers"
from customer c
group by store_id 
having count(customer_id) > 300



-- Доработайте запрос, добавив в него информацию о городе магазина, 
--а также фамилию и имя продавца, который работает в этом магазине.

select s.store_id, a.address, count(c.customer_id) as number_of_sales, concat (s2.first_name, ' ', s2.last_name) as name
from store s 
left join address a on s.address_id = a.address_id 
left join customer c on s.store_id  = c.store_id  
left join staff s2 on s2.store_id = s.store_id 
group by s.store_id, a.address, concat (s2.first_name, ' ', s2.last_name)
having count(c.customer_id)>300


--ЗАДАНИЕ №3
--Выведите ТОП-5 покупателей, 
--которые взяли в аренду за всё время наибольшее количество фильмов

select r.customer_id, concat(c.first_name, ' ', c.last_name), count (r.customer_id) 
from rental r 
left join customer c on r.customer_id = c.customer_id
left join payment p on r.rental_id = p.rental_id  
group by r.customer_id, concat(c.first_name, ' ', c.last_name)
order by count desc
limit 5

--ЗАДАНИЕ №4
--Посчитайте для каждого покупателя 4 аналитических показателя:
--  1. количество фильмов, которые он взял в аренду
--  2. общую стоимость платежей за аренду всех фильмов (значение округлите до целого числа)
--  3. минимальное значение платежа за аренду фильма
--  4. максимальное значение платежа за аренду фильма

select concat(c.first_name, ' ', c.last_name) , count (p.customer_id) as amount_of_films, sum(round( p.amount)) as total_cost, min(p.amount), max(p.amount) 
from customer c 
join payment p on c.customer_id = p.customer_id 
group by c.customer_id 



--ЗАДАНИЕ №5
--Используя данные из таблицы городов составьте одним запросом всевозможные пары городов таким образом,
 --чтобы в результате не было пар с одинаковыми названиями городов. 
 --Для решения необходимо использовать декартово произведение.
 
select c.city, c2.city
from city c
cross join city c2
where c.city != c2.city



--ЗАДАНИЕ №6
--Используя данные из таблицы rental о дате выдачи фильма в аренду (поле rental_date)
--и дате возврата фильма (поле return_date), 
--вычислите для каждого покупателя среднее количество дней, за которые покупатель возвращает фильмы.
 
select concat(c.first_name, ' ', c.last_name), avg (r.return_date - r.rental_date)
from rental r 
left join customer c on r.customer_id = c.customer_id 
group by concat(c.first_name, ' ', c.last_name)


--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--Посчитайте для каждого фильма сколько раз его брали в аренду и значение общей стоимости аренды фильма за всё время.

select f.title, f.release_year, f.language_id, count (r.inventory_id) frequency, sum (p.amount) total_cost
from rental r 
left join inventory i on r.inventory_id  = i.inventory_id 
left join film f on i.film_id = f.film_id 
left join payment p on r.rental_id = p.payment_id
group by f.title, f.release_year, f.language_id 


--ЗАДАНИЕ №2
--Доработайте запрос из предыдущего задания и выведите с помощью запроса фильмы, которые ни разу не брали в аренду.

select f.title, f.release_year, f.language_id, count (r.inventory_id) frequency, sum (p.amount) total_cost
from rental r 
left join inventory i on r.inventory_id  = i.inventory_id 
left join film f on i.film_id = f.film_id 
left join payment p on r.rental_id = p.payment_id
group by f.title, f.release_year, f.language_id 
having count (r.inventory_id) = 0



--ЗАДАНИЕ №3
--Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку "Премия".
--Если количество продаж превышает 7300, то значение в колонке будет "Да", иначе должно быть значение "Нет".

select concat(s.first_name, ' ', s.last_name), count(p.amount) "премия"
	case
		when count(p.amount) > 7300 then 'да' 
		when count(p.amount) < 7300 then 'нет'
	end
from payment p 
left join staff s on p.staff_id = s.staff_id 
group by concat(s.first_name, ' ', s.last_name)

