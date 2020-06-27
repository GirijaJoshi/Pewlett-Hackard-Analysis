--create a table containing the number of employees who are about to retire (those born 1952-1955)
SELECT e.emp_no, e.first_name,
       e.last_name, ti.title,
       ti.from_date, ti.to_date, s.salary
INTO number_of_employees
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
INNER JOIN salaries as s
ON (ti.emp_no = s.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- checking number_of_employeess table
SELECT * FROM number_of_employees;

-- filter duplicates with PARTITION
SELECT  emp_no,
        first_name,
        last_name,
        title,
        to_date
INTO most_recent_title_per_employee
FROM
 ( SELECT emp_no,
        first_name,
        last_name,
        title,
        to_date, ROW_NUMBER() OVER
         (PARTITION BY (emp_no)
         ORDER BY to_date DESC) rn
         FROM number_of_employees
 ) tmp WHERE rn = 1
 ORDER BY emp_no;

SELECT * FROM most_recent_title_per_employee;

-- number of retiring
SELECT COUNT(emp_no) as count_num_ri_emp
FROM most_recent_title_per_employee;

-- total number of going to retire by per title
SELECT COUNT(title) as title_count, title
INTO employees_per_title
FROM most_recent_title_per_employee
GROUP BY title
ORDER BY title_count
;

--checking table
SELECT * FROM employees_per_title;

-- Deliverable 2: Mentorship Eligibility
 -- To be eligible to participate in the mentorship program, 
 -- employees will need to have a date of birth that falls between January 1, 1965 and December 31, 1965.
SELECT e.emp_no, e.first_name,
       e.last_name, ti.title,
       de.from_date, de.to_date
INTO mentorship_program
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as ti
ON (de.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND(de.to_date = '9999-01-01')
ORDER by emp_no;

SELECT * FROM mentorship_program;

-- number of mentors
SELECT COUNT(DISTINCT emp_no)
FROM mentorship_program;
