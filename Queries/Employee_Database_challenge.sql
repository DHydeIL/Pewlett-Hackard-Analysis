SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
INTO retirement_titles
FROM employees AS e
JOIN titles AS t
ON e.emp_no = t.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY e.emp_no;

SELECT * FROM retirement_titles;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no, to_date DESC;

-- Use COUNT with GROUP BY to determine the number of upcoming retirees per title
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC;

-- Create a table of eligible mentors
SELECT DISTINCT ON (e.emp_no) 
	e.emp_no, 
	e.first_name, 
	e.last_name, 
	e.birth_date, 
	de.from_date,
	de.to_date,
	t.title
INTO mentorship_eligibility
FROM employees AS e
JOIN dept_emp AS de
	ON e.emp_no = de.emp_no
JOIN titles AS t
	ON e.emp_no = t.emp_no
WHERE (de.to_date = '9999-01-01') AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;

-- Show the number of eligible mentors grouped by title
SELECT COUNT(title), title
FROM mentorship_eligibility
GROUP BY title
ORDER BY COUNT(title) DESC;

-- Create a table of the retiring employees born in 1952
SELECT DISTINCT ON (e.emp_no) e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date, de.dept_no
INTO first_wave
FROM employees AS e
JOIN titles AS t
ON e.emp_no = t.emp_no
JOIN dept_emp AS de
ON e.emp_no = de.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1952-12-31') AND (t.to_date = '9999-01-01')
ORDER BY emp_no, to_date DESC;

-- Show the number of retirees in the first wave grouped by department number
SELECT COUNT(emp_no), dept_no
FROM first_wave
GROUP BY dept_no
ORDER BY dept_no;

-- show the number of retirees eligible for a retirement plan
SELECT COUNT(emp_no) FROM current_emp;

-- Mentorship qualification based on hire date
SELECT DISTINCT ON (e.emp_no) e.emp_no, 
	e.first_name, 
	e.last_name, 
	e.hire_date, 
	t.title, 
	t.to_date,
	de.dept_no
INTO qualified_mentors
FROM employees AS e
JOIN titles AS t
	ON e.emp_no = t.emp_no
JOIN dept_emp AS de
	ON e.emp_no = de.emp_no
WHERE (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31') AND
	(t.to_date = '9999-01-01')
ORDER BY e.emp_no, t.to_date DESC;

-- Find total number of qualified mentors grouped by department
SELECT COUNT(emp_no), dept_no
FROM qualified_mentors
GROUP BY dept_no
ORDER BY dept_no;

SELECT COUNT(emp_no)
FROM qualified_mentors;




