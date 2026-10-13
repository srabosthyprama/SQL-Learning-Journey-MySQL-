create database university_db;
use university_db;

DROP TABLE IF EXISTS student_scholarships;
DROP TABLE IF EXISTS semester_gpa;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS course_sections;
DROP TABLE IF EXISTS scholarships;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS professors;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS departments;

-- ============================================================
-- TABLE 1: departments
-- Core lookup table. Parent of students, professors, courses.
-- ============================================================

CREATE TABLE departments (
    department_id    INT            NOT NULL AUTO_INCREMENT,
    dept_name        VARCHAR(100)   NOT NULL,
    building         VARCHAR(100)   NOT NULL,
    budget           DECIMAL(12,2)  NOT NULL,
    established_year INT            NOT NULL,
    PRIMARY KEY (department_id)
);

-- ============================================================
-- TABLE 2: rooms
-- Physical classrooms. Room 15 is intentionally unused
-- in course_sections — useful for RIGHT JOIN demos.
-- ============================================================
CREATE TABLE rooms (
    room_id     INT            NOT NULL AUTO_INCREMENT,
    building    VARCHAR(100)   NOT NULL,
    room_number VARCHAR(10)    NOT NULL,
    capacity    INT            NOT NULL,
    room_type   ENUM('Lecture Hall','Lab','Seminar Room') NOT NULL,
    PRIMARY KEY (room_id)
);

-- ============================================================
-- TABLE 3: professors
-- manager_id is a self-referencing FK pointing to the
-- Department Head. Department Heads have manager_id = NULL.
-- Useful for SELF JOIN demos.
-- ============================================================
CREATE TABLE professors (
    professor_id  INT            NOT NULL AUTO_INCREMENT,
    first_name    VARCHAR(50)    NOT NULL,
    last_name     VARCHAR(50)    NOT NULL,
    email         VARCHAR(100)   NOT NULL,
    department_id INT            NOT NULL,
    title         ENUM(
                      'Lecturer',
                      'Assistant Professor',
                      'Associate Professor',
                      'Professor',
                      'Department Head'
                  ) NOT NULL,
    salary        DECIMAL(10,2)  NOT NULL,
    hire_date     DATE           NOT NULL,
    manager_id    INT            NULL,   -- NULL for Department Heads
    PRIMARY KEY (professor_id),
    UNIQUE KEY uq_prof_email (email),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (manager_id)    REFERENCES professors(professor_id)
);

-- ============================================================
-- TABLE 4: students
-- department_id is nullable — undeclared-major students have
-- NULL here, useful for LEFT JOIN demos.
-- ============================================================
CREATE TABLE students (
    student_id      INT            NOT NULL AUTO_INCREMENT,
    first_name      VARCHAR(50)    NOT NULL,
    last_name       VARCHAR(50)    NOT NULL,
    email           VARCHAR(100)   NOT NULL,
    department_id   INT            NULL,   -- NULL = undeclared major
    enrollment_date DATE           NOT NULL,
    birth_date      DATE           NOT NULL,
    status          ENUM('Active','Graduated','Suspended','Withdrawn')
                    NOT NULL DEFAULT 'Active',
    advisor_id      INT            NULL,
    PRIMARY KEY (student_id),
    UNIQUE KEY uq_student_email (email),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (advisor_id)    REFERENCES professors(professor_id)
);

-- ============================================================
-- TABLE 5: courses
-- Each course belongs to one department.
-- Level: 100=Intro, 200=Sophomore, 300=Junior, 400=Senior,
--        500=Graduate
-- ============================================================
CREATE TABLE courses (
    course_id     INT            NOT NULL AUTO_INCREMENT,
    course_code   VARCHAR(10)    NOT NULL,
    course_name   VARCHAR(150)   NOT NULL,
    department_id INT            NOT NULL,
    credits       INT            NOT NULL,
    level         INT            NOT NULL,
    PRIMARY KEY (course_id),
    UNIQUE KEY uq_course_code (course_code),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    CONSTRAINT chk_credits CHECK (credits BETWEEN 1 AND 4),
    CONSTRAINT chk_level   CHECK (level IN (100,200,300,400,500))
);

-- ============================================================
-- TABLE 6: scholarships
-- department_id is nullable — university-wide scholarships
-- are not tied to a specific department.
-- ============================================================
CREATE TABLE scholarships (
    scholarship_id   INT            NOT NULL AUTO_INCREMENT,
    scholarship_name VARCHAR(150)   NOT NULL,
    amount           DECIMAL(10,2)  NOT NULL,
    department_id    INT            NULL,   -- NULL = university-wide
    criteria         VARCHAR(255)   NOT NULL,
    PRIMARY KEY (scholarship_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- ============================================================
-- TABLE 7: course_sections
-- One row = one offering of a course in a specific semester.
-- A course can have multiple sections per semester.
-- ============================================================
CREATE TABLE course_sections (
    section_id       INT            NOT NULL AUTO_INCREMENT,
    course_id        INT            NOT NULL,
    professor_id     INT            NOT NULL,
    room_id          INT            NOT NULL,
    semester         ENUM('Fall','Spring','Summer') NOT NULL,
    year             INT            NOT NULL,
    max_capacity     INT            NOT NULL,
    current_enrolled INT            NOT NULL DEFAULT 0,
    PRIMARY KEY (section_id),
    FOREIGN KEY (course_id)    REFERENCES courses(course_id),
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id),
    FOREIGN KEY (room_id)      REFERENCES rooms(room_id)
);

-- ============================================================
-- TABLE 8: enrollments
-- Many-to-many: students <-> course_sections.
-- grade = NULL means the course is still in progress.
-- ============================================================
CREATE TABLE enrollments (
    enrollment_id   INT            NOT NULL AUTO_INCREMENT,
    student_id      INT            NOT NULL,
    section_id      INT            NOT NULL,
    enrollment_date DATE           NOT NULL,
    grade           ENUM('A','A-','B+','B','B-','C+','C','C-','D','F','W') NULL,
    grade_points    DECIMAL(3,2)   NULL,
    PRIMARY KEY (enrollment_id),
    UNIQUE KEY uq_student_section (student_id, section_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (section_id) REFERENCES course_sections(section_id)
);

-- ============================================================
-- TABLE 9: student_scholarships
-- Many-to-many: students <-> scholarships.
-- ============================================================
CREATE TABLE student_scholarships (
    id             INT            NOT NULL AUTO_INCREMENT,
    student_id     INT            NOT NULL,
    scholarship_id INT            NOT NULL,
    academic_year  VARCHAR(10)    NOT NULL,   -- e.g. '2023-24'
    awarded_date   DATE           NOT NULL,
    amount_awarded DECIMAL(10,2)  NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (student_id)     REFERENCES students(student_id),
    FOREIGN KEY (scholarship_id) REFERENCES scholarships(scholarship_id)
);

-- ============================================================
-- TABLE 10: semester_gpa
-- Tracks each student's GPA per semester.
-- Primary source for LAG, LEAD, and running SUM demos.
-- ============================================================
CREATE TABLE semester_gpa (
    id                INT           NOT NULL AUTO_INCREMENT,
    student_id        INT           NOT NULL,
    semester          ENUM('Fall','Spring') NOT NULL,
    year              INT           NOT NULL,
    semester_gpa      DECIMAL(4,3)  NOT NULL,
    cumulative_gpa    DECIMAL(4,3)  NOT NULL,
    credits_attempted INT           NOT NULL,
    credits_earned    INT           NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_student_term (student_id, semester, year),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

/* Insert into Table */

