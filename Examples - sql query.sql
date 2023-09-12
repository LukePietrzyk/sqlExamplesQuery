-- Query (1,2) below show information about managers on 2 ways. Using join and subquery

-- #1
select e.* from dept_manager dm join employees e
on e.emp_no = dm.emp_no;

-- #2
select e.* from employees e
where emp_no in (select emp_no from dept_manager);

-- #3 Query to find all employees who have last name Markovitch and check if someone with it are manager.

SELECT 
    *
FROM
    employees e
        left JOIN
    dept_manager dm ON dm.emp_no = e.emp_no
WHERE
    e.last_name = 'Markovitch'
order by dm.dept_no desc, dm.emp_no desc;

-- #4 Show list of managers with first name 'Isamu'
SELECT 
    *
FROM
    employees e
WHERE
    e.first_name = 'Isamu' and e.emp_no in (select emp_no from dept_manager);

-- #5 Example of using cross join  - list of all managers (24) with department no.9 

SELECT 
    *
FROM
    dept_manager dm
        CROSS JOIN
    departments d
WHERE
    d.dept_no = 'd009'
ORDER BY dm.emp_no , d.dept_no;

-- #6 Show list of 10 employees with list of all departments. . 
SELECT 
    e.*,d.*
FROM
    employees e
        CROSS JOIN
    departments d
WHERE
     e.emp_no > 10010 and e.emp_no < 10021
ORDER BY e.emp_no , d.dept_no;

-- #7 Checking how many people are assigned to each department & order desc

SELECT 
    d.dept_name, COUNT(dept_name) AS department_count
FROM
    dept_emp de
        JOIN
    departments d ON d.dept_no = de.dept_no
GROUP BY d.dept_name
ORDER BY department_count desc;

-- #8 Show information about managers hire bettwen 1989-01-01 and 2000-01-01

SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no IN (SELECT 
            emp_no
        FROM
            employees
        WHERE
            hire_date BETWEEN '1989-01-01' AND '2000-01-01');
            

            
            
            
