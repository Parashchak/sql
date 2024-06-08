/*
Дизайн бази даних:

1. Створіть базу даних для управління курсами. База має включати наступні таблиці:

- students: student_no, teacher_no, course_no, student_name, email, birth_date.

- teachers: teacher_no, teacher_name, phone_no

- courses: course_no, course_name, start_date, end_date


2. Додайте будь-які данні (7-10 рядків) в кожну таблицю.

3. По кожному викладачу покажіть кількість студентів з якими він працював

4. Спеціально зробіть 3 дубляжі в таблиці students (додайте ще 3 однакові рядки) 
5. Напишіть запит який виведе дублюючі рядки в таблиці students
*/

-- 1.
DROP DATABASE IF EXISTS courses_database;
CREATE DATABASE IF NOT EXISTS courses_database;

USE courses_database;

DROP TABLE IF EXISTS courses;
CREATE TABLE IF NOT EXISTS courses (
  course_no INT AUTO_INCREMENT PRIMARY KEY,
  course_name VARCHAR(48) NOT NULL,
  start_date DATE DEFAULT (CURRENT_DATE()),
  end_date DATE NOT NULL
);
ALTER TABLE courses AUTO_INCREMENT = 3001;

DROP TABLE IF EXISTS teachers;
CREATE TABLE IF NOT EXISTS teachers (
  teacher_no INT AUTO_INCREMENT PRIMARY KEY,
  teacher_name VARCHAR(48) NOT NULL,
  phone_no VARCHAR(20) NOT NULL
);
ALTER TABLE teachers AUTO_INCREMENT = 2001;

DROP TABLE IF EXISTS students;
CREATE TABLE IF NOT EXISTS students (
    student_no INT AUTO_INCREMENT PRIMARY KEY,
    teacher_no INT NOT NULL,
    course_no INT NOT NULL,
    student_name VARCHAR(48) NOT NULL,
    email VARCHAR(48) NOT NULL,
    birth_date DATE NOT NULL,    
    FOREIGN KEY (teacher_no) REFERENCES teachers(teacher_no),
    FOREIGN KEY (course_no) REFERENCES courses(course_no)
);
ALTER TABLE students AUTO_INCREMENT = 1001;

-- 2.
START TRANSACTION;

INSERT INTO courses (course_name, start_date, end_date)
VALUES ('PowerBI', '2023-10-01', '2023-11-01');

COMMIT;

START TRANSACTION;

INSERT INTO teachers (teacher_name, phone_no)
VALUES ('Irina', '099-999-77-34');

COMMIT;

START TRANSACTION;

INSERT INTO students (teacher_no, course_no, student_name, email, birth_date)
VALUES (2001, 3001, 'Vasyl', 'v@gmail.com', '1989-11-11');

COMMIT;

START TRANSACTION;

INSERT INTO students (teacher_no, course_no, student_name, email, birth_date)
VALUES (2001, 3001, 'Anastasia', 'nastya@gmail.com', '1992-01-19');

COMMIT;

START TRANSACTION;

INSERT INTO courses (course_name, start_date, end_date)
VALUES ('Excel', '2023-11-01', '2023-12-01');

COMMIT;

START TRANSACTION;

INSERT INTO teachers (teacher_name, phone_no)
VALUES ('Lida', '095-996-77-35');

COMMIT;

START TRANSACTION;

INSERT INTO students (teacher_no, course_no, student_name, email, birth_date)
VALUES (2002, 3002, 'Vasyl', 'v_15@gmail.com', '1996-03-15');

COMMIT;

START TRANSACTION;

INSERT INTO students (teacher_no, course_no, student_name, email, birth_date)
VALUES (2002, 3002, 'Oleksandr', 'ol@gmail.com', '1998-07-12');

COMMIT;

START TRANSACTION;

INSERT INTO students (teacher_no, course_no, student_name, email, birth_date)
VALUES (2002, 3002, 'Anna', 'anna@gmail.com', '1998-05-05');

COMMIT;

START TRANSACTION;

INSERT INTO courses (course_name, start_date, end_date)
VALUES ('Tableau', '2023-12-01', '2024-01-01');

COMMIT;

START TRANSACTION;

INSERT INTO teachers (teacher_name, phone_no)
VALUES ('Kira', '066-906-07-35');

COMMIT;

START TRANSACTION;

INSERT INTO students (teacher_no, course_no, student_name, email, birth_date)
VALUES (2003, 3003, 'Vadim', 'vad@gmail.com', '1992-08-15');

COMMIT;

START TRANSACTION;

INSERT INTO courses (course_name, start_date, end_date)
VALUES ('FrontEnd', '2024-01-01', '2024-02-01');

COMMIT;

START TRANSACTION;

INSERT INTO teachers (teacher_name, phone_no)
VALUES ('Bohdan', '067-666-77-77');

COMMIT;

START TRANSACTION;

INSERT INTO students (teacher_no, course_no, student_name, email, birth_date)
VALUES (2004, 3004, 'Vasyl', 'vas1@gmail.com', '1989-12-15');

COMMIT;

START TRANSACTION;

INSERT INTO courses (course_name, start_date, end_date)
VALUES ('SQL', '2024-02-01', '2024-03-01');

COMMIT;

START TRANSACTION;

INSERT INTO teachers (teacher_name, phone_no)
VALUES ('Dmutro', '066-000-77-77');

COMMIT;

START TRANSACTION;

INSERT INTO students (teacher_no, course_no, student_name, email, birth_date)
VALUES (2005, 3005, 'Olha', 'ola@gmail.com', '1989-04-15');

COMMIT;

START TRANSACTION;

INSERT INTO courses (course_name, start_date, end_date)
VALUES ('Python', '2024-03-01', '2024-04-01');

COMMIT;

START TRANSACTION;

INSERT INTO teachers (teacher_name, phone_no)
VALUES ('Max', '073-000-73-73');

COMMIT;

START TRANSACTION;

INSERT INTO students (teacher_no, course_no, student_name, email, birth_date)
VALUES (2006, 3006, 'Vova', 'vova@gmail.com', '1993-06-02');

COMMIT;

START TRANSACTION;

INSERT INTO courses (course_name, start_date, end_date)
VALUES ('MongoDB', '2024-04-01', '2024-05-01');

COMMIT;

START TRANSACTION;

INSERT INTO teachers (teacher_name, phone_no)
VALUES ('Vlad', '093-007-32-23');

COMMIT;

START TRANSACTION;

INSERT INTO students (teacher_no, course_no, student_name, email, birth_date)
VALUES (2007, 3007, 'Semen', 'sema@gmail.com', '1997-07-09');

COMMIT;

-- 3.
SELECT teacher_name, COUNT(student_no) FROM teachers
JOIN students ON teachers.teacher_no = students.teacher_no
GROUP BY teachers.teacher_no;

-- 4.
START TRANSACTION;

INSERT INTO courses_database.students (teacher_no, course_no, student_name, email, birth_date)
SELECT s.teacher_no, s.course_no, s.student_name, s.email, s.birth_date
FROM courses_database.students AS s
LIMIT 3;
     
COMMIT;

-- 5.
WITH DuplicateStudents AS (
    SELECT email
    FROM courses_database.students
    GROUP BY email
    HAVING COUNT(email) > 1
)
SELECT s.student_no, s.teacher_no, s.course_no, s.student_name, s.email, s.birth_date
FROM courses_database.students AS s
INNER JOIN DuplicateStudents AS ds 
    ON (s.email = ds.email);