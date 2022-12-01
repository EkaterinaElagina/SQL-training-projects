create table salary (
	id serial not null,
	first_name varchar (50) not null,
	department varchar (50) not null,
	gross_salary decimal not null
);

insert into salary 
values 
(1,'Kolya','Sales',100000),
(2,'Ira','Marketing',100000),
(3,'Nina','HR',150000),
(4,'Arkadiy','IT',300000),
(5,'Innokentiy','IT',100000),
(6,'Kollbek','IT',133000),
(7,'Nastya','HR',60000),
(8,'Lena','IT',98000),
(9,'Masha','IT',98000),
(10,'Masha','Marketing',98000),
(11,'Igor','Marketing',50000),
(12,'Masha','Sales',98000),
(13,'Mayya','Sales',20000);


---какой сотрудник получает больше всех в каждом департаменте с помощью подзапроса

select s.id, s.first_name, s.department, s.gross_salary
from salary s
join (
	select s.department, max(s.gross_salary) as max_salary
	from salary s
	group by s.department) as max_s
on s.department = max_s.department 
where s.gross_salary = max_s.max_salary;

--- решить эту задачу с помощью оконных функций 

select s.id, s.first_name, s.department, s.gross_salary, max(gross_salary) over (partition by s.department) as max_department_salary
from salary s;

--- вывод только тех, у кого самая большая зарплата в депертаменте

select 
	max_s.id, 
	max_s.first_name, 
	max_s.department, 
	max_s.gross_salary
from 
	(select 
		s.id, 
		s.first_name, 
		s.department, 
		s.gross_salary,
		max(gross_salary) over (partition by s.department) as max_department_salary
	from 
	salary s) as max_s
where max_s.gross_salary = max_department_salary;

--- показать пропорцию зарплат каждого сотрудника, относительно суммы всех зарплат в этом отделе

with gross_department as (
select 
	s.department,
	sum(s.gross_salary) as sum_department_salary
from 
	salary s
group by 
	s.department )
select 
	s.id, 
	s.first_name, 
	s.department, 
	s.gross_salary,
	round(s.gross_salary / gd.sum_department_salary,3)*100 as department_ratio
from 
	salary s	
join 
	gross_department gd 
	using (department)
order by 
	s.department,
	ratio desc;

--- показать пропорцию зарплат каждого сотрудника, относительно всего фонда зп

select 
	s.id, 
	s.first_name, 
	s.department, 
	s.gross_salary,
	round(s.gross_salary / (select sum(s.gross_salary) from salary s), 3)*100 as ratio
from 
	salary s	
order by 
	s.department,
	ratio desc

--- решить эту же задачу с помощью оконных функций

select 
	s.id, 
	s.first_name, 
	s.department, 
	s.gross_salary,
	round(s.gross_salary / sum(s.gross_salary) over (partition by s.department), 3)*100 as department_ratio,
	round(s.gross_salary / sum(s.gross_salary) over (), 3)*100 as total_ratio
from 
	salary s	
order by 
	s.department;

--- вывести имя сотрудника, у которого самая высокая зарплата

select 
	s.id, 
	s.first_name, 
	s.department, 
	s.gross_salary,
	first_value(s.first_name) over(partition by s.department order by s.gross_salary desc) as highest_dep_salary
from 
	salary s

--- вывести имя сотрудника, у которого самая низкая зарплата
	
select 
	s.id, 
	s.first_name, 
	s.department, 
	s.gross_salary,
	last_value(s.first_name) over(partition by s.department) as lowest_dep_salary
from 
	salary s


