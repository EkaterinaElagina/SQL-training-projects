select product_id, product_name, unit_price 
from products p;

select product_id, product_name, unit_price * units_in_stock 
from products p;

select distinct country 
from employees e;

select distinct country, city 
from employees e;

select contact_name, city
from customers c;

select order_id, shipped_date - order_date 
from orders o;

select distinct city
from customers;

select count(*)
from customers

select count(distinct country)
from customers c 

select company_name, contact_name, phone
from customers c 
where country = 'USA';

select *
from products p 
where unit_price > 20;

select count(*)
from products p 
where unit_price > 20;

select *
from products
where discontinued = 1;

select *
from products
where discontinued = 1;

select *
from customers 
where city != 'Berlin';

select *
from orders
where order_date > '1998-03-01';

select *
from products p 
where unit_price > 25 and units_in_stock > 40;

select *
from customers 
where city = 'Berlin' or city = 'London' or city = 'San Francisco';

select *
from orders o 
where shipped_date > '1998-04-03' and (freight < 75 or freight > 150);

select *
from orders o 
where freight >= 20 and freight <= 40; --- we can use 'between' as well

select  count(*)
from orders o 
where freight between 20 and 40;

select *
from orders o 
where order_date > '1998-03-12' and order_date < '1998-04-01';

select *
from customers c 
where country = 'Mexico' or country = 'Germany' or country = 'USA' or country = 'Canada';

select *
from customers c 
where country in ('Mexico', 'Germany', 'USA', 'Canada'); --- the same but more beautiful

select *
from customers c 
where country not in ('Mexico', 'Germany', 'USA', 'Canada');

select distinct country
from customers c 
order by country;

select distinct country, city
from customers c 
order by country desc, city asc;

select ship_city, order_date
from orders o 
where ship_city = 'London'
order by order_date ;

select min(order_date)
from orders o 
where ship_city = 'London';

select max(order_date)
from orders o 
where ship_city = 'London';

select avg(unit_price)
from products p 
where discontinued <> 1;

select sum(units_in_stock)
from products p 
where discontinued <> 1;

select min(unit_price)
from products p 
where units_in_stock > 30;

select max(unit_price)
from products p 
where units_in_stock > 30;

select avg(shipped_date - order_date)
from orders o 
where ship_country = 'USA';

select sum(units_in_stock*unit_price)
from products p 
where discontinued != 1;

-------------------------------------------------------------------------

select last_name, first_name
from employees
where last_name like '%n';

select last_name, first_name
from employees
where first_name  like '%ven';

select last_name, first_name
from employees
where last_name  like '_uch%';

select product_name, unit_price
from products p 
limit 10;

select ship_region, ship_city, ship_country 
from orders o 
where ship_region is not null;

----------------------------------------------------------------------------

select ship_country, count(*)
from orders o 
where freight > 50
group by ship_country 
order by count(*) desc;

select first_name, last_name, home_phone, region 
from employees e 
where region is null ;

select count(*)
from customers c 
where region is not null;

select country, count(*)
from suppliers s 
group by country 
order by count(*) desc;

select ship_country, sum(freight)
from orders o 
where ship_region is not null 
group by ship_country 
having sum(freight) > 2750
order by sum(freight) desc;
------------------------------------------------------------------------

select country
from customers c 
union
select country 
from suppliers s 
order by country ;

select country
from customers c 
intersect
select country 
from suppliers s 
intersect
select country 
from employees e; 

select country
from customers c 
intersect 
select country 
from suppliers s 
except
select country from employees e;