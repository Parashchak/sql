-- 1. Покажіть середню зарплату співробітників за кожен рік, до 2005 року.
SELECT YEAR(from_date) as report_year , ROUND(AVG(salary),0) as avg_salary FROM salaries
GROUP BY 1
HAVING report_year BETWEEN MIN(YEAR(from_date)) AND 2005
ORDER BY 1;

-- 2. Покажіть середню зарплату співробітників по кожному відділу.
-- Примітка: потрібно розрахувати по поточній зарплаті, та поточному відділу співробітників
SELECT dept_name, ROUND(AVG(salary),0) as avg_salary FROM dept_emp
JOIN salaries ON dept_emp.emp_no = salaries.emp_no AND CURDATE() BETWEEN salaries.from_date AND salaries.to_date
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE CURDATE() BETWEEN dept_emp.from_date AND dept_emp.to_date
GROUP BY 1
ORDER BY 2 DESC;

-- 3. Покажіть середню зарплату співробітників по кожному відділу за кожний рік
-- V_1
SELECT dept_name, dept.years, dept.dept_avg_salary FROM departments
JOIN (SELECT dept_no, sal_year.year_s as years, ROUND(AVG(sal_year.avg_sal),0) as dept_avg_salary  FROM dept_emp
		JOIN (SELECT EXTRACT(YEAR FROM salaries.from_date) as year_s, emp_no, ROUND(AVG(salary),0) as avg_sal FROM salaries
		GROUP BY year_s, emp_no) as sal_year ON dept_emp.emp_no = sal_year.emp_no
		GROUP BY sal_year.year_s, dept_no) as dept ON departments.dept_no = dept.dept_no
ORDER BY dept_name, dept.years;

-- V2
WITH dept_salaries as (SELECT dept_no, sal_year.year_s as years, ROUND(AVG(sal_year.avg_sal),0) as dept_avg_salary  FROM dept_emp
						JOIN (SELECT EXTRACT(YEAR FROM salaries.from_date) as year_s, emp_no, ROUND(AVG(salary),0) as avg_sal FROM salaries
						GROUP BY year_s, emp_no) as sal_year ON dept_emp.emp_no = sal_year.emp_no
						GROUP BY sal_year.year_s, dept_no)

SELECT dept_name, dept_salaries.years, dept_salaries.dept_avg_salary FROM dept_salaries
JOIN departments ON dept_salaries.dept_no = departments.dept_no
ORDER BY dept_name, dept_salaries.years;

-- 4. Покажіть відділи в яких зараз працює більше 15000 співробітників.
-- V1
SELECT dept_name, COUNT(emp_no) as emp_total FROM dept_emp
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE CURDATE() BETWEEN from_date AND to_date
GROUP BY dept_name
HAVING emp_total > 15000
ORDER BY emp_total DESC;

-- V2
SELECT dept_name FROM departments
JOIN (SELECT dept_no, COUNT(emp_no) as emp_total FROM dept_emp
		WHERE CURDATE() BETWEEN from_date AND to_date 
        GROUP BY dept_no 
        HAVING COUNT(emp_no) > 15000) as dept ON departments.dept_no = dept.dept_no;
        
-- 5. Для менеджера який працює найдовше покажіть його номер, відділ, дату прийому на роботу, прізвище
SELECT dept_manager.emp_no, dept_name, hire_date, last_name FROM dept_manager
JOIN employees ON dept_manager.emp_no = employees.emp_no AND (CURDATE() BETWEEN dept_manager.from_date AND dept_manager.to_date)
JOIN departments ON dept_manager.dept_no = departments.dept_no
ORDER BY TIMESTAMPDIFF(day, hire_date, CURDATE()) DESC
LIMIT 1;

-- 6. Покажіть топ-10 діючих співробітників компанії з найбільшою різницею між їх зарплатою і середньою зарплатою в їх відділі.
WITH avg_sal AS (SELECT dept_emp.dept_no, AVG(salary) as dept_avg_sal FROM dept_emp
				JOIN salaries ON dept_emp.emp_no = salaries.emp_no AND (CURDATE() BETWEEN salaries.from_date AND salaries.to_date)
                WHERE CURDATE() BETWEEN dept_emp.from_date AND dept_emp.to_date
                GROUP BY dept_emp.dept_no)

SELECT employees.emp_no, first_name, last_name, ROUND(salary - dept_avg_sal,0) as dif_sal FROM avg_sal
JOIN dept_emp ON avg_sal.dept_no = dept_emp.dept_no AND (CURDATE() BETWEEN dept_emp.from_date AND dept_emp.to_date)
JOIN salaries ON dept_emp.emp_no = salaries.emp_no AND (CURDATE() BETWEEN salaries.from_date AND salaries.to_date)
JOIN employees ON dept_emp.emp_no = employees.emp_no
ORDER BY dif_sal DESC
LIMIT 10;

-- 7. Для кожного відділу покажіть другого по порядку менеджера. 
-- Необхідно вивести відділ, прізвище ім’я менеджера, дату прийому на роботу менеджера 
-- і дату коли він став менеджером відділу
SELECT dept_name, first_name, last_name, hire_date, manag.from_date as manag_from FROM
(SELECT *, ROW_NUMBER() OVER (PARTITION BY dept_no ORDER BY from_date) AS row_manag FROM dept_manager) as manag
JOIN departments ON manag.dept_no = departments.dept_no
JOIN employees ON manag.emp_no = employees.emp_no
WHERE manag.row_manag = 2;