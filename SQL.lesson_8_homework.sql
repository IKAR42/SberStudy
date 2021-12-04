--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

with agg as (
select DepartmentId, Name, Salary, dense_rank() over (partition by DepartmentId order by Salary desc) as rank
from Employee)

select d.Name as "Department", a.Name as "Employee", a.Salary as "Salary"
from agg a 
join Department d on a.DepartmentId = d.Id
where a.rank < 4;

--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17
--Определить, сколько потратил в 2005 году каждый из членов семьи

select member_name, status, sum(amount*unit_price) as costs
from FamilyMembers F
join Payments P
on F.member_id = P.family_member
where P.date BETWEEN '2005-01-01' and '2006-01-01'
group by member_name, status;


--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13
--Вывести имена людей, у которых есть полный тёзка среди пассажиров

select name
from Passenger
group by name
having count(*) > 1;

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
--Сколько Анн (Anna) учится в школе ?

select count(first_name) as count
from Student
where first_name = 'Anna';

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35
--Сколько различных кабинетов школы использовались 2.09.2019 в образовательных целях ?

select COUNT(classroom) as count
from Schedule
where date like '2019-09-02';

--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
--Сколько Анн (Anna) учится в школе ?

--Дубль task4

select count(first_name) as count
from Student
where first_name = 'Anna';


--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

with table_2 as
    (SELECT member_id, TIMESTAMPDIFF(YEAR, birthday, curdate()) as count_age 
    from FamilyMembers)
select round(avg(count_age)) as age
from table_2;


--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27
--Узнать, сколько потрачено на каждую из групп товаров в 2005 году. Вывести название группы и сумму

with good_amount as 
    (select type, good, sum(amount*unit_price) as cost --определяем выборку по дате и по сумме трат на группу
    from Payments
    join Goods
    on Payments.good = Goods.good_id
    where Payments.date BETWEEN '2005-01-01' and '2006-01-01'
    group by good, type)
select good_type_name, sum(cost) as costs --определяем название группы и сумму трат
		from good_amount
		join GoodTypes
		on good_amount.type = GoodTypes.good_type_id   
	group by good_type_name;


--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

select min(max_year_1) as year
from 
(
with table_1 as
    (SELECT sc.student, class, TIMESTAMPDIFF(YEAR, birthday, curdate()) as max_year_1 
    from Student st
    join Student_in_class sc
    on st.id = sc.student)
select max_year_1 from table_1 
) a;

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44
-- Найдите максимальный возраст (колич. лет) среди обучающихся 10 классов ?

select max(max_year_1) as max_year
from 
(
with table_1 as
    (SELECT sc.student, class, TIMESTAMPDIFF(YEAR, birthday, curdate()) as max_year_1 --рассчитываем количество лет
    from Student st
    join Student_in_class sc
    on st.id = sc.student)
select max_year_1 from table_1 --добавляем условие фильтрации по причастности к 10 классу
    where class in
        (select class
        from Class cl
        join Student_in_class sic
        on cl.id = sic.class
        where name like '10%')
) a;


--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20
-- Сколько и кто из семьи потратил на развлечения (entertainment). Вывести статус в семье, имя, сумму

select member_name, status, sum(amount*unit_price) as costs
	from FamilyMembers F
	join Payments P
	on F.member_id = P.family_member
where good = 
    (select good_id --определяем какой из товаров относится к категории развлечения
    from Goods g
    join GoodTypes gt
    on g.type = gt.good_type_id
    where good_type_id = '4')
group by member_name, status;

--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55
-- Удалить компании, совершившие наименьшее количество рейсов.

select company, count(*)
from Trip
group by company
order by company ASC;


--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45
--Какой(ие) кабинет(ы) пользуются самым большим спросом?

with class_1 as 
	(select classroom, count(*) as count -- определяем выборку и считаем рейтинг классов
	from Schedule
    group by classroom
    order by count(*) desc)
select classroom 
from class_1 
where count = (select max(count) from class_1); 


--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43
--Выведите фамилии преподавателей, которые ведут физическую культуру (Physical Culture). Остортируйте преподавателей по фамилии.

select last_name
from Teacher
join Schedule
on Teacher.id = Schedule.teacher
where subject =
    (select id from Subject where id = '11')
order by last_name;


--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63
--Выведите отсортированный список (по возрастанию) имен студентов в виде Фамилия.И.О.

select 
    concat(
    last_name, '.', 
    substring(first_name from 1 for 1), '.',
    substring(middle_name from 1 for 1)
    ) as name
from Student
order by first_name asc;


