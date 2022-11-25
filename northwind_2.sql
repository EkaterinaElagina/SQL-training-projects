--внутреннее соединение; вывести наименование продукта, компании, количество продукта в продаже
select p.product_name, p.units_in_stock, s.company_name 
from products p 
inner join suppliers s on p.supplier_id = s.supplier_id  
order by p.units_in_stock desc;

--внутеннее соединение; посчитать, сколько товара в продаже по категориям
select c.category_name, sum(p.units_in_stock)
from products p 
inner join categories c on p.category_id = c.category_id 
group by category_name 
order by sum(p.units_in_stock);

--внутреннее соединенеие; сумма (в деньгах), на которую продается товаров по каждой категории, 
--кроме товаров, которых больше не будет в продаже, и удалить категории, где товаров продано менее, чем на 5000 у.е.
select c.category_name, sum(p.unit_price*p.units_in_stock)
from categories c 
inner join products p on c.category_id = p.category_id 
where p.discontinued <> 1
group by c.category_name
having sum(p.unit_price*p.units_in_stock) > 5000
order by sum(p.unit_price*p.units_in_stock) desc;

--на каких работниках "завязаны" заказы
select o.order_id, o.customer_id, e.first_name, e.last_name, e.title  
from orders o 
inner join employees e on o.employee_id = e.employee_id ;


--вывести дату, когда был сделан заказ, какой товар был заказан, в какую страну доставить, цену, количество и скидку
select o.order_id, o.order_date, p.product_name, o.ship_country,  p.unit_price, od.quantity, p.unit_price*od.quantity as total, od.discount 
from orders o 
inner join order_details od on o.order_id = od.order_id 
inner join products p on p.product_id = od.product_id ;

--вывести компании, у которых нет заказов
select c.company_name, o.order_id 
from customers c 
left join orders o on c.customer_id = o.customer_id 
where o.order_id is null;

--
select category_id, sum(units_in_stock) as units_in_stock 
from products p 
group by category_id 
order by sum(units_in_stock) desc
limit 5;

--
select category_id, sum(unit_price * units_in_stock) as total_price
from products p 
group by category_id 
having sum(unit_price *units_in_stock) > 5000;

--Найти заказчиков и обслуживающих их заказы сотрудников таких, что и заказчики и сотрудники из города London, 
--а доставка идёт компанией Speedy Express. Вывести компанию заказчика и ФИО сотрудника.

select c.company_name as customer, concat(e.first_name, ' ', e.last_name) as employee, s.company_name as shipper
from customers c 
left join orders o on c.customer_id = o.customer_id 
left join employees e on o.employee_id = e.employee_id 
join shippers s on o.ship_via  = s.shipper_id 
where s.company_name = 'Speedy Express' and c.city = 'London' and e.city = 'London';


--Найти активные (см. поле discontinued) продукты из категории Beverages и Seafood, которых в продаже менее 20 единиц. 
--Вывести наименование продуктов, кол-во единиц в продаже, имя контакта поставщика и его телефонный номер.

select p.product_name, p.units_in_stock, s.contact_name, s.phone 
from products p 
join suppliers s on p.supplier_id = s.supplier_id 
join categories c on p.category_id = c.category_id 
where c.category_name in ('Beverages', 'Seafood') and p.discontinued = 0 and p.units_in_stock < 20;

--Найти заказчиков, не сделавших ни одного заказа. Вывести имя заказчика и order_id.

select o.order_id, c.company_name 
from customers c 
left join orders o on o.customer_id = c.customer_id 
where o.order_id is null;

--Переписать предыдущий запрос, использовав симметричный вид джойна (подсказка: речь о LEFT и RIGHT).

select o.order_id, c.company_name 
from orders o  
right join customers c on o.customer_id = c.customer_id 
where o.order_id is null;