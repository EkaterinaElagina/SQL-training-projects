select company_name
from suppliers s 
where country in (select distinct country
				from customers c );
				
--- то же самое, только без подзапроса:
			
select distinct s.company_name
from suppliers s 
join customers c using (country);

----

select c.category_name, sum(p.units_in_stock)
from products p 
inner join categories c using (category_id)
group by c.category_name
order by sum(p.units_in_stock)desc
limit (select min(p.product_id) + 4 from products p)


--- вывести количество товара в наличии, кот. больше, чем в среднем

select p.product_name, p.units_in_stock
from products p 
where p.units_in_stock > (select avg(p.units_in_stock)
from products p )
order by p.units_in_stock;

--- компании и имена заказчиков, которые делали заказ, весом от 50 до 100 кг

select c.company_name, c.contact_name 
from customers c 
where exists (select o.customer_id
			from orders o 
			where o.customer_id = c.customer_id
			and o.freight between 50 and 100
			);


--- выбрать компании, которые не делали заказ между 01.02.1995 и 25.02.1995 (с подзапросом)
select c.company_name, c.contact_name 
from customers c 
where exists (select o.customer_id
			from orders o 
			where o.customer_id = c.customer_id
			and o.order_date not between '1995-02-01' and'1995-02-25'
			);

--- выбрать продукты, которые не покупались в период с 01.02.1995 по 25.02.1995 (с подзапросом)
		
select p.product_name 
from products p 
where not exists (select od.product_id 
			from order_details od 
			join orders o on o.order_id = od.order_id
			where o.order_date between '1995-02-01' and'1995-02-25');
		
		
--- выбрать все уникальные компании, которыеделали заказ более чем на 40тыс ед. (двумя способами: подзапрос и join)

select distinct company_name 
from customers c
join orders o using (customer_id)
join order_details od using (order_id)
where od.quantity > 40;		
		
		
select distinct company_name 
from customers c
where customer_id = any (select o.customer_id 
						from orders o
						join order_details od using (order_id)
						where od.quantity > 40);	

					
---	выбрать продукты, которых заказано в каждом заказе больше среднего		

select distinct p.product_name, od.quantity 
from products p 
join order_details od using (product_id)
where od.quantity > (select avg(od.quantity)	
from order_details od )
order by od.quantity ;

--- вывести те продукты, в которых количество больше среднего начения количество заказов товаров из групп, полученных группированием по product_id (all)

select distinct product_name, od.quantity 
from products p 
join order_details od using (product_id)
where od.quantity > all(select avg (quantity)
						from order_details od 
						group by od.product_id)
order by od.quantity;


--- Вывести продукты количество которых в продаже меньше самого малого среднего количества продуктов в деталях заказов (группировка по product_id). 
---Результирующая таблица должна иметь колонки product_name и units_in_stock.

select p.product_name, p.units_in_stock 
from products p 
where p.units_in_stock < all(select avg(od.quantity)
						from order_details od 
						group by product_id )
order by p.units_in_stock desc;



--- Напишите запрос, который выводит общую сумму фрахтов заказов для компаний-заказчиков для заказов, 
--- стоимость фрахта которых больше или равна средней величине стоимости фрахта всех заказов, 
--- а также дата отгрузки заказа должна находится во второй половине июля 1996 года. 
--- Результирующая таблица должна иметь колонки customer_id и freight_sum, строки которой должны быть отсортированы по сумме фрахтов заказов.




select customer_id, sum(freight) as freight_sum
from orders 
inner join (select customer_id, avg (freight) as freight_avg
			from orders 
			group by customer_id ) oa 
using (customer_id)
where freight > freight_avg and shipped_date between '07-15-1996' and '08-01-1996' 
group by customer_id 
order by freight_sum;


--- Напишите запрос, который выводит 3 заказа с наибольшей стоимостью, 
--- которые были созданы после 1 сентября 1997 года включительно и были доставлены в страны Южной Америки. 
--- Общая стоимость рассчитывается как сумма стоимости деталей заказа с учетом дисконта. 
--- Результирующая таблица должна иметь колонки customer_id, ship_country и order_price, 
--- строки которой должны быть отсортированы по стоимости заказа в обратном порядке.

select customer_id, ship_country, order_price
from orders 
left join (select order_id, sum(unit_price * quantity - unit_price * quantity*discount) as order_price
			from order_details
			group by order_id) oa 
using (order_id)
where ship_country in ('Brazil', 'Mexico', 'Venezuela', 'Argentina', 'Columbia') and order_date > '09-01-1997' 
order by order_price desc
limit 3


--- Вывести все товары (уникальные названия продуктов), которых заказано ровно 10 единиц (конечно же, это можно решить и без подзапроса).
























