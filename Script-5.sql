--=============== МОДУЛЬ 5. РАБОТА С POSTGRESQL =======================================
--= ПОМНИТЕ, ЧТО НЕОБХОДИМО УСТАНОВИТЬ ВЕРНОЕ СОЕДИНЕНИЕ И ВЫБРАТЬ СХЕМУ PUBLIC===========
SET search_path TO public;

--======== ОСНОВНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1

--Сделайте запрос к таблице payment и с помощью оконных функций добавьте вычисляемые колонки согласно условиям:
select 
	*
from 
	payment p ;

--Пронумеруйте все платежи от 1 до N по дате
select 
	p.payment_id,
	p.customer_id,
	p.staff_id,
	p.rental_id,
	p.amount,
	p.payment_date,
	row_number () over(order by p.payment_date) as paymert_number
from 
	payment p ;
	
--Пронумеруйте платежи для каждого покупателя, сортировка платежей должна быть по дате
	
select 
	p.payment_id,
	p.customer_id,
	p.staff_id,
	p.rental_id,
	p.amount,
	p.payment_date,
	row_number () over(partition by customer_id order by p.payment_date) as paymert_number_for_customer
from 
	payment p ;
	
--Посчитайте нарастающим итогом сумму всех платежей для каждого покупателя, сортировка должна 
--быть сперва по дате платежа, а затем по сумме платежа от наименьшей к большей
	
select 
	p.payment_id,
	p.customer_id,
	p.staff_id,
	p.rental_id,
	p.amount,
	p.payment_date,
	sum (p.amount) over(partition by p.customer_id order by p.payment_date, p.amount) as total_amount
from 
	payment p ;
	
--Пронумеруйте платежи для каждого покупателя по стоимости платежа от наибольших к меньшим 
--так, чтобы платежи с одинаковым значением имели одинаковое значение номера.

select 
	p.payment_id,
	p.customer_id,
	p.staff_id,
	p.rental_id,
	p.amount,
	p.payment_date,
	dense_rank () over(partition by p.customer_id order by p.amount) as num
from 
	payment p ;

--Можно составить на каждый пункт отдельный SQL-запрос, а можно объединить все колонки в одном запросе.

--ЗАДАНИЕ №2
--С помощью оконной функции выведите для каждого покупателя стоимость платежа и стоимость 
--платежа из предыдущей строки со значением по умолчанию 0.0 с сортировкой по дате.

select 
	p.payment_id,
	p.customer_id,
	p.staff_id,
	p.rental_id,
	p.amount,
	p.payment_date,
	lag (p.amount, 1, 0.0) over(partition by p.customer_id order by p.payment_date) as prev
from 
	payment p ;


--ЗАДАНИЕ №3
--С помощью оконной функции определите, на сколько каждый следующий платеж покупателя больше или меньше текущего.

select 
	p.payment_id,
	p.customer_id,
	p.staff_id,
	p.rental_id,
	p.amount,
	p.payment_date,
	lead (p.amount) over(partition by p.customer_id order by p.payment_date) - p.amount  as diff
from 
	payment p ;


--ЗАДАНИЕ №4
--С помощью оконной функции для каждого покупателя выведите данные о его последней оплате аренды.

with last_pay as (select 
	p.payment_id,
	p.customer_id,
	p.staff_id,
	p.rental_id,
	p.amount,
	p.payment_date,
	last_value (p.payment_date) over(partition by p.customer_id) as last_payment
from 
	payment p)
select 
*
from 
last_pay
where 
payment_date = last_payment;


--======== ДОПОЛНИТЕЛЬНАЯ ЧАСТЬ ==============

--ЗАДАНИЕ №1
--С помощью оконной функции выведите для каждого сотрудника сумму продаж за август 2005 года 
--с нарастающим итогом по каждому сотруднику и по каждой дате продажи (без учёта времени) 
--с сортировкой по дате.

select 
	p.payment_id,
	p.customer_id,
	p.staff_id,
	p.rental_id,
	p.amount,
	p.payment_date,
	sum (p.amount) over(partition by p.customer_id) as total_payment
from 
	payment p 
where 
	p.payment_date > 2005-07-31 23:59:59.000 and p.payment_date < 2005-09-01 00:00:00.000;


--ЗАДАНИЕ №2
--20 августа 2005 года в магазинах проходила акция: покупатель каждого сотого платежа получал
--дополнительную скидку на следующую аренду. С помощью оконной функции выведите всех покупателей,
--которые в день проведения акции получили скидку  

with row_n as (select 
	p.payment_id,
	p.customer_id,
	p.staff_id,
	p.rental_id,
	p.amount,
	p.payment_date,
	row_number () over (order by p.payment_date) as row_num
from 
	payment p )
select * 
from row_n
where 
	row_num % 100=0
	and (payment_date >= 2005-08-20 00:00:00 and payment_date < 2005-08-21 00:00:00);

