# Q1
# How much higher is the average salary of instructors in the top 5 than the bottom 5?
# 29000
-- method 1
select round(tb3.top_5-tb4.bottom_5)
from
(select avg(salary) as top_5
from 
(select salary from instructor
order by salary desc
limit 5) as tb1) as tb3,
(select avg(salary) as bottom_5
from
(select salary from instructor
order by salary
limit 5) as tb2) as tb4;

-- method 2
select round(avg(a.salary) - avg(b.salary)) from
(select * from instructor order by salary desc limit 5) as a,
(select * from instructor order by salary limit 5) as b;

# Q2
# From all the instructors whose salary is lower than the mean, which % of them whose names start with the letter C?
# 40
select tb2.col2/tb1.col1 #col2/col1
from
(select count(*) as col1
from instructor
where salary < (select avg(salary) from instructor)) as tb1,
(select count(*) as col2
from instructor
where salary < (select avg(salary) from instructor) and name regexp '^c') as tb2;

# Q3
# Which letter(s) is the most popular first letter among all the students?
# S and B
select first_letter, count(*)
from
(select *, left(name, 1) as first_letter
from student) tb1
group by 1
order by 2 desc;

# Q4
# Which course(s) is taught in both summer 2009 and summer 2010? (Please list the course name)
# Intro. to Bio
-- method 1
select course.title from
(select course_id
from teaches
where semester = 'summer' and year = 2009) tb1
inner join
(select course_id
from teaches
where semester = 'summer' and year = 2010) tb2
on tb1.course_id = tb2.course_id
inner join course
where tb1.course_id = course.course_id;

-- method 2
select course.title from
(select course_id from teaches
where semester = 'summer' and year = 2009
and course_id in
(select course_id from teaches
where semester = 'summer' and year = 2010)) tb1
inner join course
where tb1.course_id = course.course_id;

# Q5
# Among the professors who works in Taylor building, what is their average salary? 
# 78000
SELECT AVG(salary)
FROM instructor
INNER JOIN department
ON instructor.dept_name=department.dept_name
WHERE building='Taylor';

# Q6
# Which of the following sets of rooms had professor Srinivasan used?
# 101,120,3128
SELECT room_number
FROM instructor, teaches, section
WHERE instructor.ID = teaches.ID AND teaches.course_id = section.course_id AND
	  teaches.sec_id = section.sec_id AND teaches.semester = section.semester AND
      teaches.year = section.year AND name = 'Srinivasan';

# Q7
# For students whose ID starts with 7 or 9, who took the least classes?
# Aoi
SELECT name, COUNT(course_id) AS class_number
FROM student, takes
WHERE student.ID = takes.ID AND student.ID REGEXP '^7|^9'
GROUP BY student.ID;

# Q8
# How many different students have taken a Computer Science course?
# 6
SELECT COUNT(DISTINCT ID)
FROM takes
WHERE course_id LIKE 'CS%';

# Q9
# What is the average class size in each building?
select building, round(avg(capacity)) as avg_capacity
from classroom
group by 1;
