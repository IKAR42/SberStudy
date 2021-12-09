--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонко

--разбиралось на уроке

--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

select Email from
(
  select Email, count(Email) as num
  from Person
  group by Email
) a
where num > 1;

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

SELECT a.name as Employee
FROM Employee a,Employee d
WHERE a.managerId=d.Id
AND a.salary > d.salary;

--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/

select score,
dense_rank() over(order by score desc) as rank
from Scores;

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

select 
    p.firstName as firstName, 
    p.lastName as lastName,
    a.city as city, 
    a.state as state 
from Person p 
left join Address a 
on p.personId=a.personId;