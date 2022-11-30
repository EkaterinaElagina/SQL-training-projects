create view product_suppliers_categories as
select product_name, quantity_per_unit, unit_price, units_in_stock, company_name, contact_name, phone, category_name, description 
from products 
join suppliers using (supplier_id)
join categories using (category_id) ;


select * 
from product_suppliers_categories
where unit_price > 20;

drop view if exists product_suppliers_categories;


create view heavy_orders as
select *
from orders
where freight > 50;

select * 
from heavy_orders
order by freight;

--- 1. Создать представление, которое выводит следующие колонки:

--order_date, required_date, shipped_date, ship_postal_code, company_name, contact_name, phone, last_name, first_name, title из таблиц orders, customers и employees.

--Сделать select к созданному представлению, выведя все записи, где order_date больше 1го января 1997 года.

create view order_info as
select o.order_date, o.required_date, o.shipped_date, o.ship_postal_code, c.company_name, c.contact_name, c.phone, e.last_name, e.first_name, e.title 
from orders o  
left join customers c using (customer_id)
left join employees e using (employee_id);

select * from order_info
where order_date > '1997-01-01';

--- 2. Создать представление, которое выводит следующие колонки:

--order_date, required_date, shipped_date, ship_postal_code, ship_country, company_name, contact_name, phone, last_name, first_name, 
--title из таблиц orders, customers, employees.

create view order_info_2 as
select order_date, required_date, shipped_date, ship_postal_code, ship_country, company_name, contact_name, phone, last_name, first_name, title 
from orders o  
left join customers c using (customer_id)
left join employees e using (employee_id);

select * from order_info_2;

--Попробовать добавить к представлению (после его создания) колонки ship_country, postal_code и reports_to. 
--Убедиться, что проихсодит ошибка. Переименовать представление и создать новое уже с дополнительными колонками.

alter view order_info_2 rename to do_not_need;

create or replace view order_info_2 as
select order_date, required_date, shipped_date, ship_postal_code, company_name, contact_name, phone, last_name, first_name, title, ship_country, c.postal_code, reports_to
from orders o  
left join customers c using (customer_id)
left join employees e using (employee_id);


--Сделать к нему запрос, выбрав все записи, отсортировав их по ship_county.

select * 
from order_info_2
order by ship_country desc;

--Удалить переименованное представление.

drop view if exists do_not_need;

--- 3.  Создать представление "активных" (discontinued = 0) продуктов, содержащее все колонки. 
--Представление должно быть защищено от вставки записей, в которых discontinued = 1.
--Попробовать сделать вставку записи с полем discontinued = 1 - убедиться, что не проходит.

create view active_products as
select * from products 
where discontinued = 0
with local check option;

insert into active_products 
values (677, 'dfg', 1, 1, 'rdt', 1, 1, 1, 1, 1);
