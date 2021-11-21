--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing


--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

select *
from product;


--task14 (lesson3)----------------------------------------------------------------------------------------------
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *,
case 
	when price > (select avg(price) from pc) then 1
	else 0
end flag
from printer;


--task15 (lesson3)----------------------------------------------------------------------------------------------
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

select *
from ships 
join classes
on classes.class = ships.class
where classes.class is null;
-- после исполнения кода не вернулось ни одной строки (при отдельных селектах по таблицах обнаружил, 
--что у всех кораблей проставлен класс)


--task16 (lesson3)----------------------------------------------------------------------------------------------
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.

with battle_top as 
	(
	select name, extract(year from date) as year
	from battles
	)
select * 
from battle_top
where year not in (select launched from ships);


--task17 (lesson3)----------------------------------------------------------------------------------------------
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select battle
from outcomes
where ship in (select name from ships where class = 'Kongo');


--task1  (lesson4)----------------------------------------------------------------------------------------------
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag

create view all_products_flag_300 as
select model, price, flag
from (
	select *,
	case
	when price > 300 then 1
	else 0
	end flag
	from (
		select product.model, price
		from product 
		join pc 
		on pc.model = product.model
	union all
		select product.model, price
		from product 
		join laptop 
		on laptop.model = product.model
	union all
		select product.model, price
		from product 
		join printer 
		on printer.model = product.model
	) a
) b
group by flag, model, price;

select *
from all_products_flag_300;


--task2  (lesson4)----------------------------------------------------------------------------------------------
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

create view all_products_flag_avg_price as
with all_products_flag_avg_price_1 as -- определяем выборку
(
		select product.model, price
		from product 
		join pc 
		on pc.model = product.model
	union all
		select product.model, price
		from product 
		join laptop 
		on laptop.model = product.model
	union all
		select product.model, price
		from product 
		join printer 
		on printer.model = product.model
	)
select model, price,
case -- определяем условие проставления флага
	when price > (select avg(price) from all_products_flag_avg_price_1) then 1
	else 0	
end flag
from all_products_flag_avg_price_1
group by flag, model, price;


select *
from all_products_flag_avg_price;


--task3  (lesson4)----------------------------------------------------------------------------------------------
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

select printer.model
from printer
join product 
on product.model = printer.model
where maker = 'A' 
and price > 
(
	select avg(price) 
	from printer 
	join product 
	on product.model = printer.model
	where maker = 'D' --производителя 'C' не добавил в условие, так как у него нет моделей принтеров (проверка ниже)

);

-- проверка, что у производителя 'C' нет принтеров
select *
from printer 
join product 
on product.model = printer.model
where maker = 'C';


--task4 (lesson4)----------------------------------------------------------------------------------------------
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

with table_1 as --определяю выборку
(
		select product.model, price, maker
		from product 
		join pc 
		on pc.model = product.model
	union all
		select product.model, price, maker
		from product 
		join laptop 
		on laptop.model = product.model
	union all
		select product.model, price, maker
		from product 
		join printer 
		on printer.model = product.model
)
select model
from table_1 -- выборка выше
where price > -- определение условия фильтрации по средней цене других производителей
(
	select avg(price) 
	from printer 
	join product 
	on product.model = printer.model
	where maker = 'D' --производителя 'C' не добавил в условие, так как у него нет моделей принтеров
)
and maker = 'A';


--task5 (lesson4)----------------------------------------------------------------------------------------------
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

with table_2 as -- определяем выборку
		(
		select product.model, price, maker
		from product 
		join pc 
		on pc.model = product.model
	union all
		select product.model, price, maker
		from product 
		join laptop 
		on laptop.model = product.model
	union all
		select product.model, price, maker
		from product 
		join printer 
		on printer.model = product.model
		)
select model, avg(price)
from table_2
where model in -- определяем параметр фильтрации по уникальным продуктам производителя 'A'
		(
		select distinct(model)
		from product 
		where maker = 'A' 
		)
group by model;


--task6 (lesson4)----------------------------------------------------------------------------------------------
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

create view count_products_by_makers as
select maker, count(*) 
from product
group by maker
order by maker;

select *
from count_products_by_makers;


--task8 (lesson4)----------------------------------------------------------------------------------------------
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

create table printer_updated as table printer;

DELETE from printer_updated
WHERE model in 
(
select model
from product
where maker = 'D'
);

select *
from printer_updated;


--task9 (lesson4)----------------------------------------------------------------------------------------------
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create view printer_updated_with_makers as
select code, printer_updated.model, color, printer_updated.type, price, maker
from printer_updated
join product 
on product.model = printer_updated.model;

select *
from printer_updated_with_makers;


--task10 (lesson4)----------------------------------------------------------------------------------------------
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

create view sunk_ships_by_classes as -- создаем view
with all_ships as -- собираем выборку по именам и классам кораблей даже там где class null
(
		select name, class
		from ships
	union all
		select distinct ship, NULL as class
		from Outcomes
		where ship not in (select name from ships) 
)
select class, count(*) from all_ships where name in --прописываем в условии фильтр по названиям потопленных кораблей
	(
	select ship
	from outcomes
	where result = 'sunk'
	) group by class;

select *
from sunk_ships_by_classes;

-- не удалось обнвоить значения is null - выдает ошибку что поле агрегировано группировкой


--task12 (lesson4)----------------------------------------------------------------------------------------------
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

create table classes_with_flag as 
select *,
case 
	when numguns >= 1 then 1
	else 0
end flag
from classes;

select *
from classes_with_flag;


--task14 (lesson4)----------------------------------------------------------------------------------------------
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

with names as
	( 
	select name
	from ships 
	where name like 'O%' or name like 'M%'
	)
select count(*) from names;


--task15 (lesson4)----------------------------------------------------------------------------------------------
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

with names_1 as
	( 
	select *
	from ships
	where name like '% %'
	)
select count(*) from names_1;

