--- 1. Создать таблицу teacher с полями teacher_id serial, first_name varchar, last_name varchar, birthday date, phone varchar, title varchar
CREATE TABLE teacher
(
	teacher_id serial,
	first_name varchar,
	last_name varchar,
	birthday date,
	phone varchar,
	title varchar
);

--- 2. Добавить в таблицу после создания колонку middle_name varchar
ALTER TABLE teacher
ADD COLUMN middle_name varchar;

--- 3. Удалить колонку middle_name
ALTER TABLE teacher
DROP COLUMN middle_name;

--- 4. Переименовать колонку birthday в birth_date
ALTER TABLE teacher
RENAME birthday TO birth_date;

--- 5. Изменить тип данных колонки phone на varchar(32)
ALTER TABLE teacher
ALTER COLUMN phone SET DATA TYPE varchar(32);

--- 6. Создать таблицу exam с полями exam_id serial, exam_name varchar(256), exam_date date
CREATE TABLE exam
(
	exam_id serial,
	exam_name varchar(256),
	exam_date date
);

--- 7. Вставить три любых записи с автогенерацией идентификатора
INSERT INTO exam
VALUES(exam_name, exam_date)
('exam 1', '2018-01-10')
('exam 2', '2018-02-10')
('exam 3', '2018-03-10');

--- 8. Посредством полной выборки убедиться, что данные были вставлены нормально и идентификаторы были сгенерированы с инкрементом
SELECT * FROM exam;

--- 9. Удалить все данные из таблицы со сбросом идентификатор в исходное состояние
TRUNCATE TABLE exam RESTART IDENTITY;

--- 10. Создать таблицу exam с полями:

-- идентификатора экзамена - автоинкрементируемый, уникальный, запрещает NULL;- наименования экзамена- даты экзамена

drop table if exists exam;

create table exam (
				exam_id serial unique not null,
				exam_name varchar(256),
				exam_date date
);

--- 11. Удалить ограничение уникальности с поля идентификатора

alter table exam 
drop constraint exam_exam_id_key ;

--- 12. Добавить ограничение первичного ключа на поле идентификатора

alter table exam 
add primary key (exam_id);


--- 13. Создать таблицу person с полями

-- идентификатора личности (простой int, первичный ключ)- имя- фамилия
drop table if exists person;

create table person (
					person_id int not null,
					first_name varchar(50) not null,
					last_name varchar(50) not null,
			constraint PK_person_person_id primary key (person_id)
);


--- 14. Создать таблицу паспорта с полями:

-- идентификатора паспорта (простой int, первичный ключ)- серийный номер (простой int, запрещает NULL)- регистрация- ссылка на идентификатор личности (внешний ключ)
drop table if exists passport;
create table passport (
			passport_id int,
			serial_number int not null,
			registration varchar(150) not null,
			person_id int not null,
			constraint PK_passport_passport_id primary key (passport_id),
			constraint FK_passport_person foreign key (person_id) references person(person_id)
);

--- 15. Добавить колонку веса в таблицу book (создавали ранее) с ограничением, проверяющим вес (больше 0 но меньше 100)
create table book (
		book_id serial,
		book_name varchar(100) not null,
		isbn varchar(100) not null
);

alter table book
add column weight decimal constraint chk_book_weight check (weight > 0 and weight < 100);


--- 16. Убедиться в том, что ограничение на вес работает (попробуйте вставить невалидное значение)

insert into book 
values (2, 'War and Peace', 23456932-3883, 232)


--- 17. Подключиться к БД northwind и добавить ограничение на поле unit_price таблицы products (цена должна быть больше 0)

alter table products
add constraint chk_product_price check (unit_price > 0);

--- 18. Создать таблицу student с полями:

--- -идентификатора (автоинкремент)- полное имя- курс (по умолчанию 1)

create table student 
(
			student_id serial,
			name varchar,
			grade int default 1
)

--- 19. Вставить запись в таблицу студентов и убедиться, что ограничение на вставку значения по умолчанию работает

insert into student
values (1, 'Bill Stone');


select * from student;

--- 20. Удалить ограничение "по умолчанию" из таблицы студентов

alter table student 
alter column grade drop default;

insert into student
values (1, 'Bill Stone')
returning student;
