-- Create the database
CREATE DATABASE IF NOT EXISTS `online_exam_db`;

USE `online_exam_db`;

-- Create `Student` table (for storing student details)
CREATE TABLE IF NOT EXISTS `Student` (
    studentID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL
);

-- Create `Quiz` table (for storing quiz details)
CREATE TABLE IF NOT EXISTS `Quiz` (
    quizID INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL
);

-- Create `Question` table (for storing quiz questions)
CREATE TABLE IF NOT EXISTS `Question` (
    questionID INT AUTO_INCREMENT PRIMARY KEY,
    quizID INT NOT NULL,
    text VARCHAR(255) NOT NULL,
    FOREIGN KEY (quizID) REFERENCES `Quiz`(quizID)
);

-- Create `Answer` table (for storing possible answers for each question)
CREATE TABLE IF NOT EXISTS `Answer` (
    answerID INT AUTO_INCREMENT PRIMARY KEY,
    questionID INT NOT NULL,
    text VARCHAR(255) NOT NULL,
    FOREIGN KEY (questionID) REFERENCES `Question`(questionID)
);

-- Create `Scoreboard` table (for storing student scores)
CREATE TABLE IF NOT EXISTS `Scoreboard` (
    scoreID INT AUTO_INCREMENT PRIMARY KEY,
    studentID INT NOT NULL,
    quizID INT NOT NULL,
    score INT NOT NULL,
    FOREIGN KEY (studentID) REFERENCES `Student`(studentID),
    FOREIGN KEY (quizID) REFERENCES `Quiz`(quizID)
);

-- CRUD Operations: Insert a new student
INSERT INTO `Student` (name, email, password) VALUES ('John Doe', 'johndoe@example.com', 'password123');

-- Insert a new quiz
INSERT INTO `Quiz` (title) VALUES ('General Knowledge Quiz');

-- Insert a new question into a quiz (assume quizID=1)
INSERT INTO `Question` (quizID, text) VALUES (1, 'What is the capital of France?');

-- Insert possible answers for the question (assume questionID=1)
INSERT INTO `Answer` (questionID, text,is_correct) VALUES (1, 'Paris',True);
INSERT INTO `Answer` (questionID, text) VALUES (1, 'London');
INSERT INTO `Answer` (questionID, text) VALUES (1, 'Berlin');
INSERT INTO `Answer` (questionID, text) VALUES (1, 'Madrid');

-- Insert a score for a student (assume studentID=1, quizID=1)
INSERT INTO `Scoreboard` (studentID, quizID, score) VALUES (1, 1, 85);

-- --- CRUD Operations ---

-- 1. Select all students
SELECT * FROM `Student`;

-- 2. Select a student by ID
SELECT * FROM `Student` WHERE studentID = 1;

-- 3. Update a student's details (update the name and email)
UPDATE `Student` 
SET name = 'John Smith', email = 'johnsmith@example.com' 
WHERE studentID = 1;

-- 4. Delete a student by ID
DELETE FROM `Student` WHERE studentID = 1;

-- 5. Select all quizzes
SELECT * FROM `Quiz`;

-- 6. Select questions for a specific quiz (quizID=1)
SELECT * FROM `Question` WHERE quizID = 1;

-- 7. Select answers for a specific question (questionID=1)
SELECT * FROM `Answer` WHERE questionID = 1;

-- 8. Update a quiz title
UPDATE `Quiz` 
SET title = 'Science Quiz' 
WHERE quizID = 1;

-- 9. Delete a quiz (quizID=1) and associated data (cascade delete)
DELETE FROM `Quiz` WHERE quizID = 1;

-- 10. Select all scores from the scoreboard
SELECT * FROM `Scoreboard`;

-- 11. Select a score by student and quiz (studentID=1, quizID=1)
SELECT * FROM `Scoreboard` WHERE studentID = 1 AND quizID = 1;

-- 12. Update a score (studentID=1, quizID=1)
UPDATE `Scoreboard` 
SET score = 90 
WHERE studentID = 1 AND quizID = 1;

-- 13. Delete a score (studentID=1, quizID=1)
DELETE FROM `Scoreboard` WHERE studentID = 1 AND quizID = 1;

-- --- Advanced SQL Operations ---

-- 1. Join the Student table with Scoreboard to find scores of students
SELECT s.name, s.email, sc.score 
FROM `Student` s 
JOIN `Scoreboard` sc ON s.studentID = sc.studentID;

-- 2. Get the total score for each student across all quizzes
SELECT s.name, SUM(sc.score) AS total_score 
FROM `Student` s 
JOIN `Scoreboard` sc ON s.studentID = sc.studentID 
GROUP BY s.studentID;

-- 3. Get the quiz with the highest average score
SELECT q.title, AVG(sc.score) AS avg_score 
FROM `Quiz` q 
JOIN `Scoreboard` sc ON q.quizID = sc.quizID 
GROUP BY q.quizID 
ORDER BY avg_score DESC LIMIT 1;

-- 4. Get the top 5 students with the highest scores
SELECT s.name, MAX(sc.score) AS max_score 
FROM `Student` s 
JOIN `Scoreboard` sc ON s.studentID = sc.studentID 
GROUP BY s.studentID 
ORDER BY max_score DESC LIMIT 5;

-- 5. Count the number of questions in each quiz
SELECT q.title, COUNT(qs.questionID) AS total_questions 
FROM `Quiz` q 
JOIN `Question` qs ON q.quizID = qs.quizID 
GROUP BY q.quizID;

-- 6. Get the answers to a question with correct answers (assume correct answers have a flag)
SELECT a.text 
FROM `Answer` a 
WHERE a.questionID = 1 AND a.is_correct = 1;
