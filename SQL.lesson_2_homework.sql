--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--Долг с занятия

-- Задание 20: Найдите средний размер hd PC каждого из тех производителей, которые выпускают и принтеры. 
-- Вывести: maker, средний размер HD.

-- подзапросом определяем производителей которые производят и PC и Printer +
-- среднее значение hd запрашиваем в выводимом значении и группируем по maker
	
select maker, avg(hd)
from pc
join product
on pc.model = product.model
where maker in
	(
	select maker
	from product
	where type = 'Printer' 
	intersect
	select maker
	from product
	where type = 'PC'
	)
group by product.maker;
	

-- Домашняя работа
-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920

select name, class
from ships 
where launched > 1920
order by name;


-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942

select name, class
from ships 
where launched > 1920 and launched < 1942
order by name;


-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class

select count(name), class 
from ships
group by class;


-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)

select class, country
from classes
where bore >= 16;


-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.

select ship
from Outcomes
where battle = 'North Atlantic' and result = 'sunk';

-- Задание 6: Вывести название (ship) последнего потопленного корабля

-- подзапросом вычислил самую позднюю битву
-- основным запросом отфильтровал значения по атрибуту sunk (потоплен)

select *
from outcomes
join battles
on outcomes.battle = battles.name
where result = 'sunk' 
and name = (select name from battles where name = 'Surigao Strait');

-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля

-- согласно схеме БД таблицы Ships и Outcomes не связаны ни одним ключом (здесь немного не понял как join'ить значения)
-- обнаружил, что полученные значения потопленных кораблей совсем отсутствуют в таблице ships
-- проверить это можно выполнив следующий запрос / результат задания 6 -> корабли Fuso и Ymashiro
-- select name, class
-- from ships 

-- предполагал выполнять задачу следующим запросом 
select name, class
from ships 
where name =
	(
	select ship
	from outcomes
	join battles
	on outcomes.battle = battles.name
	where result = 'sunk' 
	and name = (select name from battles where name = 'Surigao Strait')
	)
;

-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и 
--которые потоплены. Вывод: ship, class

-- отдельными запросами получаю результаты для ответа на общий вопрос, но
-- полученные результаты не имеют совместимости (при этом таблички не связаны общим ключом - classes и outcomes)

-- вот что сделал
-- названия кораблей, которые имеют необходимый по условию задачи калибр
select name, ships.class
from ships
join classes
on ships.class = classes.class
where bore >= 16;

-- названия кораблей, которые
select ship
from outcomes
where result = 'sunk';


-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class

select class
from classes
where country = 'USA'
order by class;


-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class

select name, Ships.class
from Ships
join Classes
on Ships.class = Classes.class
where Classes.country = 'USA'
order by name;