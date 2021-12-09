--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

SELECT Students.Name, Grades.Grade, Students.Marks
FROM Students INNER JOIN Grades 
ON Students.Marks 
BETWEEN Grades.Min_Mark AND Max_Mark 
WHERE Grades.Grade > 7 
ORDER BY Grades.Grade DESC, Students.Name ASC;
SELECT 'NULL', Grades.Grade, Students.Marks 
FROM Students INNER JOIN Grades 
ON Students.Marks 
BETWEEN Grades.Min_Mark AND Max_Mark 
WHERE Grades.Grade <= 7 
ORDER BY Grades.Grade DESC, Students.Marks ASC;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

-- решение однозначно через case и оконку rank. финальный код не получился, оставил себе на дальнейший разбор

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

Select Distinct city
From station
WHERE city not like 'A%' 
    and city not like 'E%'
    and city not like 'I%'
    and city not like 'O%'
    and city not like 'U%';

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

Select Distinct city
From station
WHERE city not like '%a' 
    and city not like '%e'
    and city not like '%i'
    and city not like '%o'
    and city not like '%u';

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

Select Distinct city
From station
WHERE city in 
    (select Distinct city 
     from station where city not like '%a' 
    and city not like '%e'
    and city not like '%i'
    and city not like '%o'
    and city not like '%u')
    union 
    (select Distinct city 
     from station where city not like 'A%' 
    and city not like 'E%'
    and city not like 'I%'
    and city not like 'O%'
    and city not like 'U%');

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

Select Distinct city
From   station
Where  city not Like 'A%'
       and city not Like 'E%'
       and city not Like 'I%'
       and city not Like 'O%'
       and city not Like 'U%'
       and city not Like '%a'
       and city not Like '%e'
       and city not Like '%i'
       and city not Like '%o'
       and city not Like '%u';


--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name 
from Employee
where salary > '2000' and
months < '10'
order by employee_id asc;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

SELECT Students.Name, Grades.Grade, Students.Marks
FROM Students INNER JOIN Grades 
ON Students.Marks 
BETWEEN Grades.Min_Mark AND Max_Mark 
WHERE Grades.Grade > 7 
ORDER BY Grades.Grade DESC, Students.Name ASC;
SELECT 'NULL', Grades.Grade, Students.Marks 
FROM Students INNER JOIN Grades 
ON Students.Marks 
BETWEEN Grades.Min_Mark AND Max_Mark 
WHERE Grades.Grade <= 7 
ORDER BY Grades.Grade DESC, Students.Marks ASC;