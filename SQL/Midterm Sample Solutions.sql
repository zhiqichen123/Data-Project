USE db_University_basic;

-- 1.	Fetch the name of all the instructors using as column alias professor_name.
SELECT name AS professor_name
FROM instructor;

-- 2.	Fetch the name of all the instructors using the alias PROFESSOR_NAME. Names of the faculty should be all CAPITAL LETTERS.
# solution1
SELECT UCASE(name) AS PROFESSOR_NAME
FROM instructor;
# solution2
SELECT UPPER(name) AS PROFESSOR_NAME
FROM instructor;

-- 3.	Fetch the name of all the different departments from that appear in the table course.
SELECT DISTINCT dept_name
FROM course;

-- 4.	Write a query to recover the first 4 characters (including white spaces) from the name of each instructor. Do not worry if the outcome is meaningless. Just make sure the 4 characters appear.
# solution1
SELECT SUBSTRING(name, 1, 4) as Name
FROM instructor;
# solution2
SELECT LEFT(name, 4)
FROM instructor;

-- 5.	Write a query to recover all the instructors whose names start with the letter E.
# solution1
SELECT name
FROM instructor
WHERE name REGEXP '^e';
# solution2
SELECT name
FROM instructor
WHERE SUBSTRING(name, 1, 1) IN ('E', 'e');

-- 6.	Write a query to print the title of all the courses removing all the any extra white spaces from the left (in case those actually existed).
SELECT LTRIM(title)
FROM course;

-- 7.	Print the length of all the names of the instructors. For example, the length of Einstein is 8.
SELECT name, LENGTH(name)
FROM instructor;

-- 8.	Write a query to write, on a single column named IS_LOCATED the following string
# a. ‘the department: ’, +  name_of_the_department+ ,  ‘is located at:’  + name of the building.
SELECT CONCAT('the department: ', dept_name, ' is located at: ', building) AS IS_LOCATED
FROM department;

-- 9.	Write a query to recover all the information of the table instructor ordered by department and salary.
SELECT *
FROM instructor
ORDER BY dept_name, salary;

-- 10.	Write a query that recovers the information of all the instructor in the departments of History and Finance.
# solution1
SELECT * 
FROM instructor
WHERE dept_name IN ('History', 'Finance');
# solution2
select *
from instructor
where dept_name = 'History' or dept_name = 'Finance';

-- 11.	Write a query that recovers all the instructor in departments other than of history and Finance.
# solution1
SELECT * 
FROM instructor
WHERE dept_name NOT IN ('History', 'Finance');
# solution2
select *
from instructor
where dept_name != 'History' and dept_name != 'Finance';

-- 12.	List all the departments whose name has 7 letters.
SELECT dept_name
FROM department
WHERE CHAR_LENGTH(dept_name) = 7;

-- 13.	List all the instructors that have taught at least once in the Packard building.
# solution1
select distinct instructor.name
from instructor
inner join teaches
on instructor.ID = teaches.ID
inner join section
on teaches.course_id = section.course_id and teaches.sec_id = section.sec_id and teaches.semester = section.semester and teaches.year = section.year
where section.building = 'Packard';
# solution2
SELECT DISTINCT name
FROM instructor, teaches, section
WHERE instructor.ID=teaches.ID AND teaches.course_id=section.course_id AND
	  teaches.sec_id=section.sec_id AND teaches.semester=section.semester AND
      teaches.year=section.year AND building='Packard';

-- 14.	List all the instructors with a wage between $70 and $90K.
SELECT name, salary
FROM instructor
WHERE salary BETWEEN 70e3 AND 90e3;

-- 15.	Write a query that reports the names of all the faculty of the courses in the computer science department.
# solution1
SELECT DISTINCT name
FROM instructor, teaches, course
WHERE instructor.ID=teaches.ID AND teaches.course_id=course.course_id AND
	  course.dept_name='Comp. Sci.';
# solution2
select instructor.name
from instructor
inner join teaches
on instructor.ID = teaches.ID
inner join course
on teaches.course_id = course.course_id
where course.dept_name = 'Comp. Sci.';

-- 16.	Write a query to show only the even rows from the student table.
# solution1
select * from
(select *, row_number() over() as rowNumber 
FROM student) tb1
WHERE tb1.rowNumber % 2 = 0;
# solution2
SET @row_number = 0;
SELECT row_num, name
FROM (SELECT @row_number:=@row_number+1 AS row_num, name
	  FROM instructor) AS row_num
WHERE row_num % 2 = 0;

-- 17.	Write a query to show only odd rows from the student table.
# solution1
select * from
(select *, row_number() over() as rowNumber 
FROM student) tb1
WHERE tb1.rowNumber % 2 = 1;
# solution2
SET @row_number = 0;
SELECT row_num, name
FROM (SELECT @row_number:=@row_number+1 AS row_num, name
	  FROM instructor) AS row_num
WHERE row_num % 2 = 1;

-- 18.	Write a query to recover the current date.
SELECT CURDATE();

-- 19.	Write a query to recover the 3rd highest salary.
SELECT name, salary
FROM instructor
ORDER BY salary DESC
LIMIT 2, 1;

-- 20.	Write a query to recover the top 3 salaries of the instructors.
SELECT name, salary
FROM instructor
ORDER BY salary DESC
LIMIT 3;

-- 21.	Write a query to recover the bottom 3 salaries of the instructors.
SELECT name, salary
FROM instructor
ORDER BY salary
LIMIT 3;

-- 22. Write a query to recover the name of all the faculty with a salary above the mean of their department.
SELECT name, salary, avg_salary
FROM instructor
LEFT JOIN (SELECT dept_name, AVG(salary) AS avg_salary
		   FROM instructor
		   GROUP BY dept_name) AS dept_avg
ON instructor.dept_name = dept_avg.dept_name
WHERE salary > avg_salary;