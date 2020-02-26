# Q1
select course_id, title
from course
where dept_name = 'Comp. Sci.' and credits = 3;

# Q2
select student.name
from student
inner join takes
on student.ID = takes.ID
inner join teaches
on takes.course_id = teaches.course_id
inner join instructor
on teaches.ID = instructor.ID
where instructor.name = 'Einstein';

# Q3
-- method 1
select instructor.name, instructor.dept_name, department.building
from instructor
inner join department
on instructor.dept_name = department.dept_name
order by salary desc
limit 1;

-- method 2
select name, instructor.dept_name, building
FROM instructor
inner join department
on instructor.dept_name = department.dept_name
where salary = (select max(salary) from instructor);

# Q4
select distinct instructor.name, course.title
from instructor
inner join teaches
on instructor.ID = teaches.ID
inner join course
on teaches.course_id = course.course_id;

# Q5
select name
from instructor
where salary between 90000 and 100000;

# Q6
select distinct course_id
from teaches
where semester = 'fall' and year = '2009';

# Q7
select distinct course_id
from teaches
where semester = 'spring' and year = '2010';

# Q8
select distinct course.title
from teaches
inner join course
on teaches.course_id = course.course_id
where (semester = 'fall' and year = '2009') or (semester = 'spring' and year = '2010');

# Q9
-- method 1
select course.title from
(select course_id
from teaches
where semester = "fall" and year = 2009) as tb1
inner join
(select course_id
from teaches
where semester = "spring" and year = 2010) as tb2
on tb1.course_id = tb2.course_id
inner join course
on course.course_id = tb2.course_id;

-- method 2
select distinct course.title
from teaches
inner join course
on teaches.course_id = course.course_id
where semester = "fall" and year = 2009
and teaches.course_id in (select course_id from teaches where semester = "spring" and year = 2010);

# Q10
select distinct instructor.name, instructor.dept_name, salary
from instructor
inner join teaches
on instructor.ID = teaches.ID
where year = '2009';

# Q11
select avg(salary)
from instructor
where dept_name = 'Comp. Sci.';

# Q12
select dept_name, sum(capacity)
from classroom
inner join section
on classroom.room_number = section.room_number
inner join course
on section.course_id = course.course_id
group by dept_name;

# Q13
select distinct student.*, course.title
from student
inner join takes
on student.ID = takes.ID
inner join course
on takes.course_id = course.course_id;
