--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing

--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

select class, count(*)
from ships
where name in 
	(
	select ship
	from outcomes 
	where result = 'sunk'
	)
group by class;


--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

select class, min(launched)
from ships
group by class;


--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

select class, count(*)
from ships
where name in --определяем корабли, которые были потоплены
		(
		select ship
		from outcomes
		where result = 'sunk'
		) 
and class in -- определяем классы, у которые более 3 кораблей в БД
		(
		select class
		from ships
		group by class
		having count(class) >= 3 
		)
group by class;


--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

with all_ships as --определяем выборку наименований кораблей
	(
	select name
	from ships
	join classes
	on ships.class = classes.class
union 
	select ship from outcomes where ship not in (select name from ships) 
	)
select name
from all_ships
where name in -- определяем условие по числу оружий
		(	
		select name
		from ships
		join classes
		on ships.class = classes.class
		where numguns =
			(select max(numguns) 
			from classes)
		);
		
-- условие с водоизмещением не понял как можно использовать



--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

select maker
from product 
where type = 'Printer' --фильтрация по типу продукта
and maker in 
			(
			select maker --находим производителя с самым минимальным обьемом RAM
			from pc
			join product
			on pc.model = product.model
			where ram = (select min(ram) from pc)
		union all
			select maker --находим производителя самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM.
			from pc
			join product
			on pc.model = product.model
			where speed = 
				(
				select max(speed) 
				from pc
				join product
				on pc.model = product.model
				where ram = (select min(ram) from pc)
				) 
			) ;
