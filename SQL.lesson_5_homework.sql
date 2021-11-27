--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

create view pages_all_products as
select code, model, speed, ram, hd, price, screen, 
    case when num % 2 = 0 
      	then num/2 
      	else num/2 + 1 
	end as page_num, 
    case when total % 2 = 0 
    	then total/2 
    	else total/2 + 1 
    end as num_of_pages
from (
      select *, row_number(*) over(order by model desc) as num, 
             count(*) over() as total 
      from Laptop
) a;

select *
from pages_all_products;

--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)

create view distribution_by_type as
select maker, type, count(*) * 100.0 / (select count(*) from product) as percent
from product
group by maker, type
order by maker;

select * 
from distribution_by_type;


--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов

create table ships_two_words as
select *
from ships
where name like '% %'
order by name;

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

select *
from ships
where class is null 
and name like 'S%'; 

--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model

(select pr.model
from product p
join printer pr
on p.model = pr.model
where 
	maker = 'A'  -- определяем критерий фильтрации по производителю 'А'
	and price > -- определяем критерий фильтрации по цене
		(
		select avg(price) from product p
		join printer pr
		on p.model = pr.model
		where maker = 'D'
		) 
) 
union all
(select model
from -- извлекаем выборку для запроса окнной функцией
	(
	select p.model, row_number(*) over(partition by p.type order by price desc) as money
	from product p
	join printer pr
	on p.model = pr.model
	) a
	where money <= 3);