DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS students;

-- таблица students
CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    full_name TEXT NOT NULL,
    birth_year INTEGER NOT NULL
);

-- таблица grades
CREATE TABLE grades (
    id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    subject TEXT NOT NULL,
    grade INTEGER NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(id)
);

INSERT INTO students (id, full_name, birth_year) VALUES
(1, 'Alice Johnson', 2005),
(2, 'Brian Smith', 2004),
(3, 'Carla Reyes', 2006),
(4, 'Daniel Kim', 2005),
(5, 'Eva Thompson', 2003),
(6, 'Felix Nguyen', 2007),
(7, 'Grace Patel', 2005),
(8, 'Henry Lopez', 2004),
(9, 'Isabella Martinez', 2006);

INSERT INTO grades (id, student_id, subject, grade) VALUES
(1, 1, 'Math', 88),
(2, 1, 'English', 92),
(3, 1, 'Science', 85),
(4, 2, 'Math', 75),
(5, 2, 'History', 83),
(6, 2, 'English', 79),
(7, 3, 'Science', 95),
(8, 3, 'Math', 91),
(9, 3, 'Art', 89),
(10, 4, 'Math', 84),
(11, 4, 'Science', 88),
(12, 4, 'Physical Education', 93),
(13, 5, 'English', 90),
(14, 5, 'History', 85),
(15, 5, 'Math', 88),
(16, 6, 'Science', 72),
(17, 6, 'Math', 78),
(18, 6, 'English', 81),
(19, 7, 'Art', 94),
(20, 7, 'Science', 87),
(21, 7, 'Math', 90),
(22, 8, 'History', 77),
(23, 8, 'Math', 83),
(24, 8, 'Science', 80),
(25, 9, 'English', 96),
(26, 9, 'Math', 89),
(27, 9, 'Art', 92);

-- все оценки Alice Johnson
SELECT                      
    s.full_name,         
    g.subject,              
    g.grade                 
FROM students s             
JOIN grades g ON s.id = g.student_id
WHERE s.full_name = 'Alice Johnson';

-- средний балл каждого студента
SELECT 
    s.full_name,                          
    ROUND(AVG(g.grade), 2) as average_grade
FROM students s
JOIN grades g ON s.id = g.student_id    
GROUP BY s.id, s.full_name
ORDER BY average_grade DESC;

-- родившиеся после 2004
SELECT 
     full_name,
     birth_year
FROM students
WHERE birth_year > 2004
ORDER BY birth_year;

-- средний балл по предметам
SELECT
     subject,
     ROUND(AVG(grade), 2) as average_grade
FROM grades
GROUP BY subject
ORDER BY average_grade DESC;

-- ТОП 3
SELECT
     s.full_name,
     ROUND(AVG(g.grade), 2) as average_grade
FROM students s
JOIN grades g ON s.id = g.student_id
GROUP BY s.id, s.full_name
ORDER BY average_grade DESC
LIMIT 3;

-- плохие отметки 
SELECT DISTINCT
     s.full_name,
     g.subject,
     g.grade
FROM students s
JOIN grades g ON s.id = g.student_id
WHERE g.grade < 80
ORDER BY s.full_name, g.grade;

-- индексы для быстрого поиска
CREATE INDEX IF NOT EXISTS idx_student_id ON grades(student_id);
CREATE INDEX IF NOT EXISTS idx_birth_year ON students(birth_year);
CREATE INDEX IF NOT EXISTS idx_grade ON grades(grade);
CREATE INDEX IF NOT EXISTS idx_subject ON grades(subject);