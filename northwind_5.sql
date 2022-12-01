select *
from orders
limit 10;

-- вместо NULL оставить UNKNOWN

select order_id,  order_date, coalesce (ship_region, 'unknown') as ship_region 
from orders o 
limit 10;

select * 
from employees e;

select last_name, title, coalesce (region, 'N\A') as region
from employees e ;

--- выбрать все из customers, если город не указан, замениеть его на 'unknown'

select *
from customers c ;

select contact_name, coalesce (nullif(city, ''), 'unknown') as city 
from customers c;

---- 1. Выполните следующий код (записи необходимы для тестирования корректности выполнения ДЗ):

insert into customers(customer_id, contact_name, city, country, company_name)
values 
('AAAAA', 'Alfred Mann', NULL, 'USA', 'fake_company'),
('BBBBB', 'Alfred Mann', NULL, 'Austria','fake_company');

--- После этого выполните задание:
--- Вывести имя контакта заказчика, его город и страну, отсортировав по возрастанию по имени контакта и городу,
--- а если город равен NULL, то по имени контакта и стране. Проверить результат, используя заранее вставленные строки. 

select customer_id, contact_name, city, country 
from customers c 
order by  contact_name, (
	case when city is null then country 
	else city 
	end
)

--- 2. Вывести наименование продукта, цену продукта и столбец со значениями

--- too expensive если цена >= 100
--- average если цена >=50 но < 100
--- low price если цена < 50

select product_name, unit_price, case when unit_price >= 100 then 'expensive'
										when unit_price >= 50 and unit_price < 100 then 'average'
										else 'low price'
										end as "characteristics" 
from products p 
order by unit_price desc;

coalesce (to_char((nullif (o.order_id), 'no orders')))

--- 3. Найти заказчиков, не сделавших ни одного заказа. Вывести имя заказчика и значение 'no orders' если order_id = NULL.

select c.company_name, c.contact_name, coalesce (order_id::text, 'no_orders') as orders
from customers c 
left join orders o using (customer_id);

--- 4. Вывести ФИО сотрудников и их должности. В случае если должность = Sales Representative вывести вместо неё Sales Stuff.

select e.last_name, e.first_name, coalesce (nullif (e.title , 'Sales Representative'), 'Sales Stuf')
from employees e ;




