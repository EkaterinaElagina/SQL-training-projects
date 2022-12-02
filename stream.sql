select 	
	*
from 
	streams s ;

--- вывести в отдельной колонке предыдущие значения по streams_millions в отдельном столбце для Lady Gaga
select 
	s.artist,
	s.week,
	s.streams_millions,
	s.streams_millions - lag(s.streams_millions, 1, s.streams_millions) over (order by week asc) as stream_change
from 
	streams s 
where 
	s.artist = 'Lady Gaga'
	
--- рассчет изменения chart_position от недели к неделе для всех артистов с помощью LAG
	
select 
	s.artist,
	s.week,
	s.chart_position ,
	lag(s.chart_position , 1, s.chart_position) over (order by week asc) - s.chart_position as position_change
from 
	streams s 

-- Расчет изменения streams_millions и chart_position от недели к недели для всех артистов с помощью оконной функции LEAD:
	
select 
	s.artist,
	s.week,
	s.chart_position ,
	lead(s.chart_position , 1) over (order by s.artist asc) - s.chart_position as position_change
from 
	streams s 	
	
	
select 
	s.artist,
	s.week,
	s.chart_position ,
	s.streams_millions - lead(s.streams_millions, 1) over (order by week asc) as stream_change
from 
	streams s 	
	
-- Пример использования оконной функции ROW_NUMBER:
	
select 
	s.artist,
	s.week,
	s.streams_millions,
	row_number () over (order by s.streams_millions asc) as "row number" 
from 
	streams s; 	
		
-- Пример использования оконной функции ROW_NUMBER c фильтрацией (вывод 30-ой строки):	

with my_rows as 
	(select 
		s.artist,
		s.week,
		s.streams_millions,
		row_number () over (order by s.streams_millions asc) as row_n 
	from 
		streams s
		) 	
select 
	* 
from 
	my_rows
where 
	row_n = 30;
	
--Пример использования оконной функции ROW_NUMBER c фильтрацией (вывод с 1 по 10 строку): WITH name AS	
	
with my_rows as 
	(select 
		s.artist,
		s.week,
		s.streams_millions,
		row_number () over (order by s.streams_millions asc) as row_n 
	from 
		streams s
		) 	
select 
	* 
from 
	my_rows
where 
	row_n between 1 and 10;	

-- Пример использования оконных функции RANK и DENSE_RANK:

select 
	s.artist,
	s.week,
	s.streams_millions,
	rank () over (order by s.streams_millions asc) as "rank", 
	dense_rank () over (order by s.streams_millions asc) as d_rank 
from 
	streams s; 	

-- Пример использования оконных функции RANK и DENSE_RANK с группировкой по неделям:

select 
	s.artist,
	s.week,
	s.streams_millions,
	rank () over (partition by week order by streams_millions) as "rank", 
	dense_rank () over (partition by week order by streams_millions) as d_rank 
from 
	streams s; 	

-- Пример использования оконной функции NTILE:

select 
	s.artist,
	s.week,
	s.streams_millions,
	ntile(5) over (order by streams_millions desc) as weekly_stream_group 
from 
	streams s; 	

-- Пример использования использования оконной функции NTILE с группировкой по неделям :
select 
	s.artist,
	s.week,
	s.streams_millions,
	ntile(4) over (partition by week order by streams_millions desc) as weekly_stream_group 
from 
	streams s; 	
