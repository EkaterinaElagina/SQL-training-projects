select 
	*
from 
	state_climate sc 
	
--Посмотрим как изменяется средняя температура с течением времени в каждом штате		

select
	state,
	year,
	tempf,
	avg(tempf) over(partition by state) as avg_f,
	tempc,
	avg(tempc) over(partition by state) as avg_c
from 
	state_climate sc ;
	
-- Найти самую низкую температуру по каждому штату

select
	state,
	year,
	tempf,
	min (tempf) over(partition by state order by tempf) as min_f,
	tempc,
	min (tempc) over(partition by state order by tempc) as min_c
from 
	state_climate sc ;

-- Найти самую высокую температуру по каждому штату

select
	state,
	year,
	tempf,
	max (tempf) over(partition by state order by tempf desc) as max_f,
	tempc,
	max (tempc) over(partition by state order by tempc desc) as max_c
from 
	state_climate sc ;

--Посмотрим на сколько меняется температура каждый год в каждом штате	

select
	state,
	year,
	tempf,
	tempf - lag (tempf, 1, tempf) over(partition by state order by year ) as temp_change_f,
	tempc,
	tempc - lag (tempc, 1, tempc) over(partition by state order by year) as temp_change_c
from 
	state_climate sc ;

-- Найти самую низкую температуру за всю историю

select 
	state,
	year,
	tempf,
	rank () OVER(ORDER BY tempf) AS coldest_rankf,
	tempc,
	rank () OVER(ORDER BY tempc) AS coldest_rankc
from 
	state_climate
limit(1);

-- Найти самую высокую температуру в разбивке по штатам	

select 
	state,
	year,
	tempf,
	rank () over(order by tempf desc) AS hottest_rankf,
	tempc,
	rank () over(order by tempc desc) AS hottest_rankc
from 
	state_climate;

--Выведем среднегодовые температуры в квартилях и квантилях, а не в рейтингах для каждого штата

select 
	state,
	year,
	tempf,
	ntile (4) over(partition by state order by tempf) AS quartile_f, --квартиль
	ntile (5) over(partition by state order by tempf) AS quantile_f, --квантиль
	tempc,
	ntile (4) over(partition by state order by tempc) AS quartile_c, --квартиль
	ntile (5) over(partition by state order by tempc) AS quantile_c --квантиль
from 
	state_climate;












