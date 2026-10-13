use university_db;

-- ============================================================
-- departments  (8 rows)
-- ============================================================
INSERT INTO departments (dept_name, building, budget, established_year) VALUES
('Computer Science',        'Engineering Building', 2500000.00, 1975),
('Mathematics',             'Science Hall',         1800000.00, 1962),
('Physics',                 'Science Hall',         2100000.00, 1960),
('Business Administration', 'Business Tower',       3200000.00, 1968),
('English Literature',      'Arts Building',        1200000.00, 1958),
('Biology',                 'Life Sciences Center', 2800000.00, 1963),
('Economics',               'Business Tower',       1900000.00, 1971),
('Data Science',            'Engineering Building', 2000000.00, 2018);

-- ============================================================
-- rooms  (15 rows — room 15 is intentionally never assigned
--         to any section; useful for RIGHT JOIN demos)
-- ============================================================
INSERT INTO rooms (building, room_number, capacity, room_type) VALUES
('Engineering Building', 'ENG-101', 120, 'Lecture Hall'),
('Engineering Building', 'ENG-102',  80, 'Lecture Hall'),
('Engineering Building', 'ENG-201',  30, 'Lab'),
('Engineering Building', 'ENG-202',  25, 'Lab'),
('Science Hall',         'SCI-101', 100, 'Lecture Hall'),
('Science Hall',         'SCI-102',  30, 'Seminar Room'),
('Science Hall',         'SCI-Lab1', 40, 'Lab'),
('Business Tower',       'BUS-101', 150, 'Lecture Hall'),
('Business Tower',       'BUS-102',  25, 'Seminar Room'),
('Business Tower',       'BUS-103', 100, 'Lecture Hall'),
('Arts Building',        'ART-101',  35, 'Seminar Room'),
('Arts Building',        'ART-102',  20, 'Seminar Room'),
('Life Sciences Center', 'LS-101',   80, 'Lecture Hall'),
('Life Sciences Center', 'LS-Lab1',  35, 'Lab'),
('Library',              'LIB-101',  20, 'Seminar Room');  -- never used

-- ============================================================
-- professors  (20 rows)
-- Department Heads have manager_id = NULL.
-- All other professors report to their Department Head.
-- ============================================================
INSERT INTO professors (first_name, last_name, email, department_id, title, salary, hire_date, manager_id) VALUES
-- Computer Science (dept 1)
('Robert',   'Chen',      'r.chen@university.edu',      1, 'Department Head',    135000.00, '2005-08-15', NULL),
('Jennifer', 'Park',      'j.park@university.edu',      1, 'Associate Professor', 98000.00, '2012-01-10', 1),
('Marcus',   'Johnson',   'm.johnson@university.edu',   1, 'Assistant Professor', 78000.00, '2019-08-20', 1),
-- Mathematics (dept 2)
('Sarah',    'Williams',  's.williams@university.edu',  2, 'Department Head',    128000.00, '2003-01-05', NULL),
('Thomas',   'Brown',     't.brown@university.edu',     2, 'Professor',          110000.00, '2008-08-15', 4),
('Diana',    'Lopez',     'd.lopez@university.edu',     2, 'Lecturer',            65000.00, '2018-01-10', 4),
-- Physics (dept 3)
('James',    'Morrison',  'j.morrison@university.edu',  3, 'Department Head',    140000.00, '1998-09-01', NULL),
('Rachel',   'Adams',     'r.adams@university.edu',     3, 'Associate Professor', 95000.00, '2011-08-15', 7),
-- Business Administration (dept 4)
('Emily',    'Rodriguez', 'e.rodriguez@university.edu', 4, 'Department Head',    145000.00, '2001-07-15', NULL),
('Kevin',    'Zhang',     'k.zhang@university.edu',     4, 'Professor',          118000.00, '2007-08-20', 9),
('Nicole',   'Turner',    'n.turner@university.edu',    4, 'Associate Professor', 92000.00, '2014-01-15', 9),
-- English Literature (dept 5)
('Michael',  'Thompson',  'm.thompson@university.edu',  5, 'Department Head',    115000.00, '2004-09-01', NULL),
('Sophia',   'Martinez',  's.martinez@university.edu',  5, 'Assistant Professor', 72000.00, '2020-08-20', 12),
-- Biology (dept 6)
('Lisa',     'Chen',      'l.chen@university.edu',      6, 'Department Head',    132000.00, '2006-08-15', NULL),
('Andrew',   'Wilson',    'a.wilson@university.edu',    6, 'Associate Professor', 96000.00, '2013-01-10', 14),
-- Economics (dept 7)
('David',    'Kim',       'd.kim@university.edu',       7, 'Department Head',    138000.00, '2002-09-01', NULL),
('Priya',    'Sharma',    'p.sharma@university.edu',    7, 'Assistant Professor', 75000.00, '2021-08-15', 16),
-- Data Science (dept 8)
('Aisha',    'Patel',     'a.patel@university.edu',     8, 'Department Head',    142000.00, '2018-09-01', NULL),
('Carlos',   'Rivera',    'c.rivera@university.edu',    8, 'Associate Professor',100000.00, '2020-01-10', 18),
('Hannah',   'White',     'h.white@university.edu',     8, 'Lecturer',            68000.00, '2022-08-20', 18);

-- ============================================================
-- students  (80 rows)
-- Students 73-77 have NULL department_id (undeclared major)
-- and no enrollments — ideal for LEFT JOIN demos.
-- ============================================================
INSERT INTO students (first_name, last_name, email, department_id, enrollment_date, birth_date, status, advisor_id) VALUES
-- CS students (dept 1)
('Alex',       'Turner',    'a.turner@uni.edu',     1, '2022-08-22', '2003-05-15', 'Active',    2),
('Mei',        'Lin',       'm.lin@uni.edu',         1, '2021-08-23', '2002-09-20', 'Active',    2),
('Jordan',     'Smith',     'j.smith@uni.edu',       1, '2023-08-28', '2004-03-10', 'Active',    3),
('Fatima',     'Hassan',    'f.hassan@uni.edu',      1, '2022-08-22', '2003-07-22', 'Active',    3),
('Ryan',       'Cooper',    'r.cooper@uni.edu',      1, '2023-08-28', '2004-11-08', 'Active',    2),
('Isabella',   'Garcia',    'i.garcia@uni.edu',      1, '2022-08-22', '2003-01-30', 'Active',    3),
('Nathan',     'Brooks',    'n.brooks@uni.edu',      1, '2020-08-24', '2001-06-14', 'Graduated', 2),
('Zoe',        'Mitchell',  'z.mitchell@uni.edu',    1, '2023-08-28', '2005-04-25', 'Active',    3),
('Ethan',      'Clark',     'e.clark@uni.edu',       1, '2022-08-22', '2003-08-16', 'Active',    2),
('Priya',      'Nair',      'p.nair@uni.edu',         1, '2024-08-26', '2006-02-28', 'Active',    3),
-- Math students (dept 2)
('Lucas',      'Martini',   'l.martini@uni.edu',     2, '2022-08-22', '2003-04-12', 'Active',    5),
('Emma',       'Johansson', 'e.johansson@uni.edu',   2, '2021-08-23', '2002-11-05', 'Active',    6),
('Omar',       'Abdullah',  'o.abdullah@uni.edu',    2, '2022-08-22', '2003-09-18', 'Active',    5),
('Chloe',      'Davis',     'c.davis@uni.edu',       2, '2023-08-28', '2004-06-22', 'Active',    6),
('Yuki',       'Tanaka',    'y.tanaka@uni.edu',      2, '2022-08-22', '2003-12-03', 'Active',    5),
('Benjamin',   'Moore',     'b.moore@uni.edu',       2, '2020-08-24', '2001-03-27', 'Graduated', 5),
('Amara',      'Osei',      'a.osei@uni.edu',        2, '2023-08-28', '2005-01-14', 'Active',    6),
('Tyler',      'Reed',      't.reed@uni.edu',         2, '2022-08-22', '2003-06-09', 'Active',    5),
('Nadia',      'Petrov',    'n.petrov@uni.edu',       2, '2023-08-28', '2004-08-31', 'Active',    6),
('Samuel',     'Torres',    's.torres@uni.edu',       2, '2022-08-22', '2003-02-17', 'Active',    5),
-- Physics students (dept 3)
('Christine',  'Wu',        'c.wu@uni.edu',           3, '2022-08-22', '2003-10-25', 'Active',    8),
('Patrick',    'OBrien',    'p.obrien@uni.edu',       3, '2023-08-28', '2004-07-08', 'Active',    8),
('Laila',      'Ahmed',     'l.ahmed@uni.edu',        3, '2022-08-22', '2003-03-19', 'Active',    8),
('Marcus',     'Stone',     'm.stone@uni.edu',        3, '2019-08-26', '2000-05-04', 'Graduated', 8),
('Sophie',     'Laurent',   's.laurent@uni.edu',      3, '2023-08-28', '2004-12-16', 'Active',    8),
('Diego',      'Ramirez',   'd.ramirez@uni.edu',      3, '2022-08-22', '2003-06-28', 'Active',    8),
('Anna',       'Kowalski',  'a.kowalski@uni.edu',     3, '2023-08-28', '2005-02-11', 'Active',    8),
('James',      'Foster',    'j.foster@uni.edu',       3, '2022-08-22', '2003-09-07', 'Active',    8),
-- Business students (dept 4)
('Victoria',   'Chen',      'v.chen@uni.edu',         4, '2022-08-22', '2003-04-20', 'Active',    10),
('Brandon',    'Lee',       'b.lee@uni.edu',           4, '2023-08-28', '2004-01-15', 'Active',    11),
('Melissa',    'Johnson',   'mel.johnson@uni.edu',    4, '2022-08-22', '2003-07-03', 'Active',    10),
('David',      'Nguyen',    'd.nguyen@uni.edu',        4, '2023-08-28', '2004-09-22', 'Active',    11),
('Ashley',     'Brown',     'ash.brown@uni.edu',      4, '2022-08-22', '2003-11-30', 'Active',    10),
('Christopher','White',     'c.white@uni.edu',        4, '2019-08-26', '2000-08-17', 'Graduated', 10),
('Hannah',     'Kim',       'h.kim@uni.edu',           4, '2023-08-28', '2004-05-06', 'Active',    11),
('Matthew',    'Davis',     'matt.davis@uni.edu',     4, '2022-08-22', '2003-02-24', 'Active',    10),
('Sarah',      'Evans',     'sar.evans@uni.edu',      4, '2023-08-28', '2004-10-13', 'Active',    11),
('Joshua',     'Martinez',  'josh.martinez@uni.edu',  4, '2022-08-22', '2003-12-01', 'Active',    10),
('Amanda',     'Wilson',    'a.wilson@uni.edu',        4, '2021-08-23', '2002-03-08', 'Suspended', 11),
('Daniel',     'Thompson',  'dan.thompson@uni.edu',   4, '2023-08-28', '2005-07-19', 'Active',    10),
-- English students (dept 5)
('Rebecca',    'Hall',      'r.hall@uni.edu',          5, '2022-08-22', '2003-06-27', 'Active',    13),
('William',    'Scott',     'w.scott@uni.edu',          5, '2023-08-28', '2004-04-18', 'Active',    13),
('Cassandra',  'Green',     'c.green@uni.edu',         5, '2020-08-24', '2001-09-11', 'Graduated', 13),
('Jonathan',   'Reed',      'jon.reed@uni.edu',        5, '2023-08-28', '2004-02-26', 'Active',    13),
('Emily',      'Morris',    'em.morris@uni.edu',       5, '2022-08-22', '2003-05-14', 'Active',    13),
('Patrick',    'Hughes',    'pat.hughes@uni.edu',      5, '2023-08-28', '2004-11-22', 'Active',    13),
('Rachel',     'Campbell',  'rach.campbell@uni.edu',  5, '2022-08-22', '2003-08-05', 'Active',    13),
-- Biology students (dept 6)
('Kevin',      'Park',      'kev.park@uni.edu',        6, '2022-08-22', '2003-01-17', 'Active',    15),
('Natalie',    'Roberts',   'n.roberts@uni.edu',       6, '2023-08-28', '2004-07-29', 'Active',    15),
('Isaac',      'Robinson',  'i.robinson@uni.edu',      6, '2022-08-22', '2003-10-04', 'Active',    15),
('Stephanie',  'Lewis',     'steph.lewis@uni.edu',    6, '2020-08-24', '2001-04-22', 'Graduated', 15),
('Justin',     'Walker',    'j.walker@uni.edu',        6, '2023-08-28', '2004-03-13', 'Active',    15),
('Monica',     'Allen',     'm.allen@uni.edu',          6, '2022-08-22', '2003-06-30', 'Active',    15),
('Eric',       'Young',     'e.young@uni.edu',          6, '2023-08-28', '2004-12-08', 'Active',    15),
('Brittany',   'Hill',      'brit.hill@uni.edu',       6, '2022-08-22', '2003-09-23', 'Active',    15),
-- Economics students (dept 7)
('Andrew',     'Carter',    'andr.carter@uni.edu',    7, '2022-08-22', '2003-03-05', 'Active',    17),
('Michelle',   'Turner',    'mich.turner@uni.edu',    7, '2023-08-28', '2004-08-14', 'Active',    17),
('Jason',      'Phillips',  'j.phillips@uni.edu',      7, '2022-08-22', '2003-05-21', 'Active',    17),
('Lauren',     'Baker',     'l.baker@uni.edu',          7, '2023-08-28', '2004-10-30', 'Active',    17),
('Ryan',       'Nelson',    'ryan.nelson@uni.edu',     7, '2020-08-24', '2001-07-16', 'Graduated', 17),
('Tiffany',    'Robinson',  'tiff.robinson@uni.edu',  7, '2022-08-22', '2003-02-09', 'Active',    17),
('Kyle',       'Harris',    'k.harris@uni.edu',         7, '2021-08-23', '2002-11-28', 'Suspended', 17),
('Samantha',   'Cox',       's.cox@uni.edu',            7, '2023-08-28', '2004-06-03', 'Active',    17),
-- Data Science students (dept 8)
('Cameron',    'Bell',      'cam.bell@uni.edu',        8, '2023-08-28', '2004-04-07', 'Active',    19),
('Alicia',     'Morgan',    'al.morgan@uni.edu',       8, '2023-08-28', '2004-09-25', 'Active',    20),
('Tyler',      'Price',     'tyl.price@uni.edu',       8, '2023-08-28', '2004-01-18', 'Active',    19),
('Destiny',    'Wood',      'd.wood@uni.edu',           8, '2024-08-26', '2006-03-11', 'Active',    20),
('Austin',     'Butler',    'a.butler@uni.edu',         8, '2023-08-28', '2004-07-24', 'Active',    19),
('Kayla',      'Sanders',   'k.sanders@uni.edu',        8, '2024-08-26', '2005-12-02', 'Active',    20),
('Trevor',     'Coleman',   't.coleman@uni.edu',        8, '2023-08-28', '2004-02-15', 'Active',    19),
('Jasmine',    'Washington','j.washington@uni.edu',    8, '2024-08-26', '2006-05-30', 'Active',    20),
('Blake',      'Ross',      'b.ross@uni.edu',           8, '2023-08-28', '2004-08-19', 'Active',    19),
-- Undeclared students (NULL dept) — no enrollments — perfect for LEFT JOIN demos
('Chris',      'Morgan',    'ch.morgan@uni.edu',       NULL, '2024-08-26', '2006-01-07', 'Active', NULL),
('Taylor',     'Swift',     'tay.swift@uni.edu',       NULL, '2024-08-26', '2006-06-15', 'Active', NULL),
('Casey',      'Jordan',    'c.jordan@uni.edu',        NULL, '2024-08-26', '2005-11-20', 'Active', NULL),
('Sam',        'Patel',     'sam.patel@uni.edu',       NULL, '2024-08-26', '2006-04-08', 'Active', NULL),
('Alex',       'Kim',       'alex.kim@uni.edu',        NULL, '2024-08-26', '2005-09-17', 'Active', NULL),
-- Withdrawn students (have some enrollment history)
('Robert',     'Green',     'rob.green@uni.edu',       1, '2023-08-28', '2004-12-01', 'Withdrawn', 2),
('Diana',      'Prince',    'di.prince@uni.edu',       4, '2023-08-28', '2004-05-22', 'Withdrawn', 11),
('Leonardo',   'Torres',    'leo.torres@uni.edu',      6, '2022-08-22', '2003-08-14', 'Withdrawn', 15);

-- ============================================================
-- courses  (25 rows)
-- ============================================================
INSERT INTO courses (course_code, course_name, department_id, credits, level) VALUES
('CS101',   'Introduction to Programming',     1, 3, 100),
('CS201',   'Data Structures & Algorithms',    1, 3, 200),
('CS301',   'Database Systems',                1, 3, 300),
('CS401',   'Operating Systems',               1, 3, 400),
('CS501',   'Machine Learning',                1, 3, 500),
('MATH101', 'Calculus I',                      2, 4, 100),
('MATH201', 'Calculus II',                     2, 4, 200),
('MATH301', 'Linear Algebra',                  2, 3, 300),
('MATH401', 'Real Analysis',                   2, 3, 400),
('PHYS101', 'General Physics I',               3, 4, 100),
('PHYS201', 'General Physics II',              3, 4, 200),
('PHYS301', 'Electromagnetism',                3, 3, 300),
('BUS101',  'Introduction to Business',        4, 3, 100),
('BUS201',  'Principles of Marketing',         4, 3, 200),
('BUS301',  'Corporate Finance',               4, 3, 300),
('BUS401',  'Strategic Management',            4, 3, 400),
('ENG101',  'Academic Writing & Composition',  5, 3, 100),
('ENG201',  'World Literature',                5, 3, 200),
('ENG301',  'Creative Writing Workshop',       5, 3, 300),
('BIO101',  'General Biology',                 6, 4, 100),
('BIO201',  'Cell Biology',                    6, 3, 200),
('BIO301',  'Genetics & Heredity',             6, 3, 300),
('ECON101', 'Microeconomics',                  7, 3, 100),
('ECON201', 'Macroeconomics',                  7, 3, 200),
('DS201',   'Python for Data Science',         8, 3, 200);

-- ============================================================
-- scholarships  (10 rows)
-- NULL department_id = university-wide scholarship
-- ============================================================
INSERT INTO scholarships (scholarship_name, amount, department_id, criteria) VALUES
('Dean''s Excellence Award',           5000.00, NULL, 'Cumulative GPA >= 3.8, any department'),
('STEM Merit Scholarship',             3500.00, NULL, 'GPA >= 3.5, enrolled in STEM major'),
('CS Innovation Grant',                4000.00,    1, 'CS major, GPA >= 3.6'),
('Mathematics Achievement Award',      3000.00,    2, 'Math major, GPA >= 3.7'),
('Physics Research Fellowship',        4500.00,    3, 'Physics major, research involvement'),
('Business Leadership Scholarship',    3000.00,    4, 'Business major, leadership activities'),
('Humanities Excellence Award',        2500.00,    5, 'English major, GPA >= 3.5'),
('Biological Sciences Grant',          3500.00,    6, 'Biology major, lab participation'),
('Economics Policy Award',             3000.00,    7, 'Economics major, GPA >= 3.6'),
('Financial Need Assistance Fund',     2000.00, NULL, 'Demonstrated financial need, any major');

-- ============================================================
-- course_sections  (35 rows)
-- Room 15 (LIB-101) is never referenced — RIGHT JOIN demo.
-- Sections 32-35 are Fall 2024 (grades still NULL in enrollments).
-- ============================================================
INSERT INTO course_sections (course_id, professor_id, room_id, semester, year, max_capacity, current_enrolled) VALUES
-- CS sections
( 1, 2,  1, 'Fall',   2023, 40, 35),   -- section  1: CS101
( 1, 3,  2, 'Spring', 2024, 35, 30),   -- section  2: CS101
( 2, 2,  1, 'Spring', 2024, 35, 28),   -- section  3: CS201
( 3, 1,  2, 'Fall',   2023, 30, 24),   -- section  4: CS301
( 5, 1,  6, 'Fall',   2023, 20, 12),   -- section  5: CS501
-- Math sections
( 6, 5,  5, 'Fall',   2023, 45, 40),   -- section  6: MATH101
( 6, 6,  5, 'Spring', 2024, 45, 38),   -- section  7: MATH101
( 7, 5,  5, 'Spring', 2024, 40, 32),   -- section  8: MATH201
( 8, 4,  6, 'Fall',   2023, 25, 18),   -- section  9: MATH301
-- Physics sections
(10, 7,  5, 'Fall',   2023, 50, 45),   -- section 10: PHYS101
(10, 8,  5, 'Spring', 2024, 50, 42),   -- section 11: PHYS101
(11, 8,  5, 'Fall',   2023, 40, 30),   -- section 12: PHYS201
-- Business sections
(13,10,  8, 'Fall',   2023, 60, 55),   -- section 13: BUS101
(13,11, 10, 'Spring', 2024, 60, 50),   -- section 14: BUS101
(14,10,  8, 'Spring', 2024, 50, 45),   -- section 15: BUS201
(15, 9,  9, 'Fall',   2023, 30, 22),   -- section 16: BUS301
(16, 9,  9, 'Spring', 2024, 25, 18),   -- section 17: BUS401
-- English sections
(17,13, 11, 'Fall',   2023, 30, 28),   -- section 18: ENG101
(17,12, 11, 'Spring', 2024, 30, 25),   -- section 19: ENG101
(18,12, 12, 'Fall',   2023, 25, 20),   -- section 20: ENG201
(19,13, 12, 'Spring', 2024, 20, 15),   -- section 21: ENG301
-- Biology sections
(20,14, 13, 'Fall',   2023, 40, 38),   -- section 22: BIO101
(20,15, 13, 'Spring', 2024, 40, 35),   -- section 23: BIO101
(21,15, 14, 'Fall',   2023, 30, 25),   -- section 24: BIO201
(22,14, 14, 'Spring', 2024, 25, 20),   -- section 25: BIO301
-- Economics sections
(23,16,  8, 'Fall',   2023, 50, 48),   -- section 26: ECON101
(23,17, 10, 'Spring', 2024, 50, 45),   -- section 27: ECON101
(24,17,  9, 'Fall',   2023, 40, 35),   -- section 28: ECON201
-- Data Science sections
(25,18,  3, 'Fall',   2023, 25, 22),   -- section 29: DS201
(25,19,  3, 'Spring', 2024, 25, 20),   -- section 30: DS201
(25,18,  4, 'Spring', 2024, 20, 14),   -- section 31: DS201 (advanced)
-- Fall 2024 sections (grades will be NULL — in progress)
( 4, 2,  2, 'Fall',   2024, 30, 28),   -- section 32: CS401
( 9, 5,  6, 'Fall',   2024, 20, 15),   -- section 33: MATH401
(12, 7,  7, 'Fall',   2024, 25, 20),   -- section 34: PHYS301
( 2, 3,  1, 'Fall',   2024, 35, 30);   -- section 35: CS201

-- ============================================================
-- enrollments  (~240 rows)
-- grade = NULL means Fall 2024 (in progress).
-- ============================================================
INSERT INTO enrollments (student_id, section_id, enrollment_date, grade, grade_points) VALUES
-- Student 1 - Alex Turner (CS Junior)
(1,  1, '2023-08-28', 'A',  4.00),
(1,  4, '2023-08-28', 'B+', 3.30),
(1,  6, '2023-08-28', 'B',  3.00),
(1, 13, '2023-08-28', 'C+', 2.30),
-- Student 2 - Mei Lin (CS Senior)
(2,  1, '2023-08-28', 'A-', 3.70),
(2,  3, '2024-01-15', 'A',  4.00),
(2,  4, '2023-08-28', 'B+', 3.30),
(2, 32, '2024-08-26',  NULL, NULL),
-- Student 3 - Jordan Smith (CS Sophomore)
(3,  1, '2023-08-28', 'B+', 3.30),
(3,  4, '2023-08-28', 'C+', 2.30),
(3, 35, '2024-08-26',  NULL, NULL),
-- Student 4 - Fatima Hassan (CS Junior)
(4,  1, '2023-08-28', 'A',  4.00),
(4,  3, '2024-01-15', 'A-', 3.70),
(4,  6, '2023-08-28', 'B+', 3.30),
(4, 32, '2024-08-26',  NULL, NULL),
-- Student 5 - Ryan Cooper (CS Sophomore)
(5,  2, '2024-01-15', 'B',  3.00),
(5,  3, '2024-01-15', 'B-', 2.70),
(5, 13, '2023-08-28', 'C',  2.00),
-- Student 6 - Isabella Garcia (CS Junior)
(6,  2, '2024-01-15', 'A-', 3.70),
(6,  5, '2023-08-28', 'B+', 3.30),
(6, 18, '2023-08-28', 'A',  4.00),
-- Student 7 - Nathan Brooks (CS Graduated)
(7,  1, '2023-08-28', 'A',  4.00),
(7,  4, '2023-08-28', 'A-', 3.70),
(7,  5, '2023-08-28', 'A-', 3.70),
(7, 16, '2023-08-28', 'B',  3.00),
-- Student 8 - Zoe Mitchell (CS Sophomore)
(8,  1, '2023-08-28', 'B',  3.00),
(8,  3, '2024-01-15', 'B+', 3.30),
(8, 35, '2024-08-26',  NULL, NULL),
-- Student 9 - Ethan Clark (CS Junior)
(9,  1, '2023-08-28', 'B+', 3.30),
(9,  2, '2024-01-15', 'B',  3.00),
(9,  4, '2023-08-28', 'C+', 2.30),
-- Student 10 - Priya Nair (CS Freshman)
(10, 2, '2024-01-15', 'A',  4.00),
(10, 3, '2024-01-15', 'A-', 3.70),
(10,32, '2024-08-26',  NULL, NULL),
-- Student 11 - Lucas Martini (Math Junior)
(11, 6, '2023-08-28', 'A-', 3.70),
(11, 8, '2024-01-15', 'A',  4.00),
(11, 1, '2023-08-28', 'B+', 3.30),
-- Student 12 - Emma Johansson (Math Senior)
(12, 6, '2023-08-28', 'B+', 3.30),
(12, 7, '2024-01-15', 'B',  3.00),
(12, 9, '2023-08-28', 'A-', 3.70),
-- Student 13 - Omar Abdullah (Math Junior)
(13, 6, '2023-08-28', 'A',  4.00),
(13, 8, '2024-01-15', 'B+', 3.30),
(13,33, '2024-08-26',  NULL, NULL),
-- Student 14 - Chloe Davis (Math Sophomore)
(14, 7, '2024-01-15', 'A',  4.00),
(14, 9, '2023-08-28', 'B+', 3.30),
(14,10, '2023-08-28', 'C+', 2.30),
-- Student 15 - Yuki Tanaka (Math Junior)
(15, 6, '2023-08-28', 'B',  3.00),
(15, 8, '2024-01-15', 'B-', 2.70),
(15, 9, '2023-08-28', 'A',  4.00),
-- Student 16 - Benjamin Moore (Math Graduated)
(16, 6, '2023-08-28', 'A',  4.00),
(16, 8, '2024-01-15', 'A',  4.00),
(16, 9, '2023-08-28', 'A',  4.00),
-- Student 17 - Amara Osei (Math Sophomore)
(17, 7, '2024-01-15', 'B+', 3.30),
(17, 9, '2023-08-28', 'B',  3.00),
(17,13, '2023-08-28', 'C',  2.00),
-- Student 18 - Tyler Reed (Math Junior)
(18, 6, '2023-08-28', 'A-', 3.70),
(18, 8, '2024-01-15', 'A',  4.00),
(18,33, '2024-08-26',  NULL, NULL),
-- Student 19 - Nadia Petrov (Math Sophomore)
(19, 7, '2024-01-15', 'B',  3.00),
(19, 9, '2023-08-28', 'B+', 3.30),
(19,26, '2023-08-28', 'C+', 2.30),
-- Student 20 - Samuel Torres (Math Junior)
(20, 6, '2023-08-28', 'B+', 3.30),
(20, 8, '2024-01-15', 'B',  3.00),
(20, 9, '2023-08-28', 'B-', 2.70),
-- Student 21 - Christine Wu (Physics Junior)
(21,10, '2023-08-28', 'A-', 3.70),
(21,12, '2023-08-28', 'A',  4.00),
(21, 6, '2023-08-28', 'B+', 3.30),
-- Student 22 - Patrick OBrien (Physics Sophomore)
(22,10, '2023-08-28', 'B',  3.00),
(22,11, '2024-01-15',  NULL, NULL),
(22,12, '2023-08-28', 'B+', 3.30),
-- Student 23 - Laila Ahmed (Physics Junior)
(23,10, '2023-08-28', 'A',  4.00),
(23,12, '2023-08-28', 'A-', 3.70),
(23,34, '2024-08-26',  NULL, NULL),
-- Student 24 - Marcus Stone (Physics Graduated)
(24,10, '2023-08-28', 'A',  4.00),
(24,11, '2024-01-15', 'A',  4.00),
(24,12, '2023-08-28', 'A-', 3.70),
-- Student 25 - Sophie Laurent (Physics Sophomore)
(25,11, '2024-01-15', 'B+', 3.30),
(25,12, '2023-08-28', 'B',  3.00),
(25, 9, '2023-08-28', 'A-', 3.70),
-- Student 26 - Diego Ramirez (Physics Junior)
(26,10, '2023-08-28', 'C+', 2.30),
(26,12, '2023-08-28', 'B-', 2.70),
(26, 6, '2023-08-28', 'C',  2.00),
-- Student 27 - Anna Kowalski (Physics Sophomore)
(27,11, '2024-01-15', 'A-', 3.70),
(27,34, '2024-08-26',  NULL, NULL),
(27, 8, '2024-01-15', 'B+', 3.30),
-- Student 28 - James Foster (Physics Junior)
(28,10, '2023-08-28', 'B+', 3.30),
(28,12, '2023-08-28', 'C+', 2.30),
(28,13, '2023-08-28', 'B',  3.00),
-- Student 29 - Victoria Chen (Business Junior)
(29,13, '2023-08-28', 'A-', 3.70),
(29,15, '2024-01-15', 'A',  4.00),
(29,16, '2023-08-28', 'B+', 3.30),
-- Student 30 - Brandon Lee (Business Sophomore)
(30,13, '2023-08-28', 'B',  3.00),
(30,14, '2024-01-15',  NULL, NULL),
(30,15, '2024-01-15', 'B+', 3.30),
-- Student 31 - Melissa Johnson (Business Junior)
(31,13, '2023-08-28', 'A',  4.00),
(31,16, '2023-08-28', 'A-', 3.70),
(31,23, '2024-01-15', 'B',  3.00),
-- Student 32 - David Nguyen (Business Sophomore)
(32,14, '2024-01-15', 'B+', 3.30),
(32,15, '2024-01-15', 'B',  3.00),
(32,17, '2024-01-15',  NULL, NULL),
-- Student 33 - Ashley Brown (Business Junior)
(33,13, '2023-08-28', 'B-', 2.70),
(33,15, '2024-01-15', 'C+', 2.30),
(33,17, '2024-01-15', 'B',  3.00),
-- Student 34 - Christopher White (Business Graduated)
(34,13, '2023-08-28', 'A',  4.00),
(34,15, '2024-01-15', 'A-', 3.70),
(34,16, '2023-08-28', 'A',  4.00),
(34,17, '2024-01-15', 'B+', 3.30),
-- Student 35 - Hannah Kim (Business Sophomore)
(35,14, '2024-01-15', 'A',  4.00),
(35,17, '2024-01-15',  NULL, NULL),
(35,26, '2023-08-28', 'B',  3.00),
-- Student 36 - Matthew Davis (Business Junior)
(36,13, '2023-08-28', 'C+', 2.30),
(36,15, '2024-01-15', 'B-', 2.70),
(36,26, '2023-08-28', 'C',  2.00),
-- Student 37 - Sarah Evans (Business Sophomore)
(37,14, '2024-01-15', 'B+', 3.30),
(37,17, '2024-01-15', 'B',  3.00),
(37,20, '2023-08-28', 'A-', 3.70),
-- Student 38 - Joshua Martinez (Business Junior)
(38,13, '2023-08-28', 'B',  3.00),
(38,16, '2023-08-28', 'B+', 3.30),
(38,23, '2024-01-15', 'C+', 2.30),
-- Student 39 - Amanda Wilson (Business Suspended)
(39,13, '2023-08-28', 'W',  NULL),
(39,15, '2024-01-15', 'F',  0.00),
-- Student 40 - Daniel Thompson (Business Sophomore)
(40,14, '2024-01-15', 'A-', 3.70),
(40,15, '2024-01-15', 'B',  3.00),
(40,17, '2024-01-15',  NULL, NULL),
-- Student 41 - Rebecca Hall (English Junior)
(41,18, '2023-08-28', 'A',  4.00),
(41,20, '2023-08-28', 'A-', 3.70),
(41, 6, '2023-08-28', 'B',  3.00),
-- Student 42 - William Scott (English Sophomore)
(42,18, '2023-08-28', 'B+', 3.30),
(42,19, '2024-01-15',  NULL, NULL),
(42,21, '2024-01-15',  NULL, NULL),
-- Student 43 - Cassandra Green (English Graduated)
(43,18, '2023-08-28', 'A',  4.00),
(43,20, '2023-08-28', 'A',  4.00),
(43,21, '2024-01-15', 'A-', 3.70),
-- Student 44 - Jonathan Reed (English Sophomore)
(44,19, '2024-01-15', 'B',  3.00),
(44,21, '2024-01-15',  NULL, NULL),
(44,13, '2023-08-28', 'C+', 2.30),
-- Student 45 - Emily Morris (English Junior)
(45,18, '2023-08-28', 'A-', 3.70),
(45,20, '2023-08-28', 'B+', 3.30),
(45,19, '2024-01-15',  NULL, NULL),
-- Student 46 - Patrick Hughes (English Sophomore)
(46,19, '2024-01-15', 'B+', 3.30),
(46,21, '2024-01-15', 'B',  3.00),
-- Student 47 - Rachel Campbell (English Junior)
(47,18, '2023-08-28', 'B',  3.00),
(47,20, '2023-08-28', 'A-', 3.70),
(47,21, '2024-01-15',  NULL, NULL),
-- Student 48 - Kevin Park (Biology Junior)
(48,22, '2023-08-28', 'A-', 3.70),
(48,24, '2023-08-28', 'A',  4.00),
(48, 6, '2023-08-28', 'B+', 3.30),
-- Student 49 - Natalie Roberts (Biology Sophomore)
(49,22, '2023-08-28', 'B+', 3.30),
(49,23, '2024-01-15',  NULL, NULL),
(49,24, '2023-08-28', 'A-', 3.70),
-- Student 50 - Isaac Robinson (Biology Junior)
(50,22, '2023-08-28', 'A',  4.00),
(50,25, '2024-01-15',  NULL, NULL),
(50,10, '2023-08-28', 'B',  3.00),
-- Student 51 - Stephanie Lewis (Biology Graduated)
(51,22, '2023-08-28', 'A',  4.00),
(51,24, '2023-08-28', 'A',  4.00),
(51,25, '2024-01-15', 'A-', 3.70),
-- Student 52 - Justin Walker (Biology Sophomore)
(52,23, '2024-01-15', 'B',  3.00),
(52,25, '2024-01-15',  NULL, NULL),
(52, 1, '2023-08-28', 'C+', 2.30),
-- Student 53 - Monica Allen (Biology Junior)
(53,22, '2023-08-28', 'B+', 3.30),
(53,24, '2023-08-28', 'B',  3.00),
(53,25, '2024-01-15', 'B-', 2.70),
-- Student 54 - Eric Young (Biology Sophomore)
(54,23, '2024-01-15', 'A-', 3.70),
(54,25, '2024-01-15',  NULL, NULL),
(54,13, '2023-08-28', 'B',  3.00),
-- Student 55 - Brittany Hill (Biology Junior)
(55,22, '2023-08-28', 'B',  3.00),
(55,24, '2023-08-28', 'A-', 3.70),
(55,13, '2023-08-28', 'C+', 2.30),
-- Student 56 - Andrew Carter (Economics Junior)
(56,26, '2023-08-28', 'A',  4.00),
(56,28, '2023-08-28', 'A-', 3.70),
(56,13, '2023-08-28', 'B+', 3.30),
-- Student 57 - Michelle Turner (Economics Sophomore)
(57,26, '2023-08-28', 'B+', 3.30),
(57,27, '2024-01-15',  NULL, NULL),
(57,28, '2023-08-28', 'B',  3.00),
-- Student 58 - Jason Phillips (Economics Junior)
(58,26, '2023-08-28', 'A-', 3.70),
(58,28, '2023-08-28', 'A',  4.00),
(58,16, '2023-08-28', 'B',  3.00),
-- Student 59 - Lauren Baker (Economics Sophomore)
(59,27, '2024-01-15', 'B',  3.00),
(59,28, '2023-08-28', 'B+', 3.30),
(59, 8, '2024-01-15', 'A-', 3.70),
-- Student 60 - Ryan Nelson (Economics Graduated)
(60,26, '2023-08-28', 'A',  4.00),
(60,27, '2024-01-15', 'A',  4.00),
(60,28, '2023-08-28', 'A-', 3.70),
-- Student 61 - Tiffany Robinson (Economics Junior)
(61,26, '2023-08-28', 'B-', 2.70),
(61,28, '2023-08-28', 'C+', 2.30),
(61, 7, '2024-01-15', 'B',  3.00),
-- Student 62 - Kyle Harris (Economics Suspended)
(62,26, '2023-08-28', 'W',  NULL),
(62,27, '2024-01-15', 'F',  0.00),
-- Student 63 - Samantha Cox (Economics Sophomore)
(63,27, '2024-01-15', 'A-', 3.70),
(63,28, '2023-08-28', 'B',  3.00),
(63, 3, '2024-01-15',  NULL, NULL),
-- Student 64 - Cameron Bell (DS Sophomore)
(64,29, '2023-08-28', 'A-', 3.70),
(64,31, '2024-01-15',  NULL, NULL),
(64, 1, '2023-08-28', 'B+', 3.30),
-- Student 65 - Alicia Morgan (DS Sophomore)
(65,29, '2023-08-28', 'A',  4.00),
(65,30, '2024-01-15',  NULL, NULL),
(65, 8, '2024-01-15', 'A-', 3.70),
-- Student 66 - Tyler Price (DS Sophomore)
(66,29, '2023-08-28', 'B+', 3.30),
(66,31, '2024-01-15',  NULL, NULL),
(66, 3, '2024-01-15',  NULL, NULL),
-- Student 67 - Destiny Wood (DS Freshman)
(67,30, '2024-01-15', 'B',  3.00),
(67,31, '2024-01-15', 'B+', 3.30),
(67,13, '2023-08-28', 'A-', 3.70),
-- Student 68 - Austin Butler (DS Sophomore)
(68,29, '2023-08-28', 'A-', 3.70),
(68,30, '2024-01-15',  NULL, NULL),
(68, 6, '2023-08-28', 'B',  3.00),
-- Student 69 - Kayla Sanders (DS Freshman)
(69,30, '2024-01-15', 'B+', 3.30),
(69,31, '2024-01-15', 'B',  3.00),
(69,20, '2023-08-28', 'A',  4.00),
-- Student 70 - Trevor Coleman (DS Sophomore)
(70,29, '2023-08-28', 'B',  3.00),
(70,31, '2024-01-15',  NULL, NULL),
(70,26, '2023-08-28', 'B-', 2.70),
-- Student 71 - Jasmine Washington (DS Freshman)
(71,30, '2024-01-15', 'A',  4.00),
(71,31, '2024-01-15', 'A-', 3.70),
(71, 1, '2023-08-28', 'B',  3.00),
-- Student 72 - Blake Ross (DS Sophomore)
(72,29, '2023-08-28', 'B+', 3.30),
(72,30, '2024-01-15',  NULL, NULL),
(72, 3, '2024-01-15', 'B-', 2.70),
-- Students 73-77 intentionally have NO enrollments (for LEFT JOIN demo)
-- Student 78 - Robert Green (Withdrawn from CS)
(78, 2, '2024-01-15', 'W',  NULL),
-- Student 79 - Diana Prince (Withdrawn from Business)
(79,13, '2023-08-28', 'C-', 1.70),
-- Student 80 - Leonardo Torres (Withdrawn from Biology)
(80,22, '2023-08-28', 'B',  3.00);

-- ============================================================
-- student_scholarships  (40 rows)
-- ============================================================
INSERT INTO student_scholarships (student_id, scholarship_id, academic_year, awarded_date, amount_awarded) VALUES
(2,  1, '2023-24', '2023-09-15', 5000.00),
(2,  3, '2023-24', '2023-09-15', 4000.00),
(4,  2, '2023-24', '2023-09-20', 3500.00),
(4,  3, '2023-24', '2023-09-20', 4000.00),
(6,  3, '2023-24', '2023-10-01', 4000.00),
(7,  1, '2022-23', '2022-09-12', 5000.00),
(7,  3, '2022-23', '2022-09-12', 4000.00),
(10, 2, '2024-25', '2024-09-10', 3500.00),
(11, 2, '2023-24', '2023-09-18', 3500.00),
(12, 4, '2023-24', '2023-09-22', 3000.00),
(13, 2, '2023-24', '2023-09-25', 3500.00),
(15, 4, '2023-24', '2023-10-05', 3000.00),
(16, 1, '2022-23', '2022-09-14', 5000.00),
(16, 4, '2022-23', '2022-09-14', 3000.00),
(18, 4, '2023-24', '2023-10-08', 3000.00),
(21, 2, '2023-24', '2023-09-19', 3500.00),
(21, 5, '2023-24', '2023-09-19', 4500.00),
(23, 5, '2023-24', '2023-09-28', 4500.00),
(24, 1, '2022-23', '2022-09-11', 5000.00),
(24, 5, '2022-23', '2022-09-11', 4500.00),
(29, 6, '2023-24', '2023-09-17', 3000.00),
(31, 6, '2023-24', '2023-10-02', 3000.00),
(31,10, '2023-24', '2023-10-02', 2000.00),
(34, 1, '2022-23', '2022-09-13', 5000.00),
(34, 6, '2022-23', '2022-09-13', 3000.00),
(41, 7, '2023-24', '2023-09-16', 2500.00),
(43, 1, '2022-23', '2022-09-10', 5000.00),
(43, 7, '2022-23', '2022-09-10', 2500.00),
(48, 8, '2023-24', '2023-09-21', 3500.00),
(50, 8, '2023-24', '2023-09-24', 3500.00),
(51, 1, '2022-23', '2022-09-15', 5000.00),
(51, 8, '2022-23', '2022-09-15', 3500.00),
(56, 9, '2023-24', '2023-09-26', 3000.00),
(58, 9, '2023-24', '2023-09-30', 3000.00),
(60, 1, '2022-23', '2022-09-09', 5000.00),
(60, 9, '2022-23', '2022-09-09', 3000.00),
(65, 2, '2023-24', '2023-10-03', 3500.00),
(71,10, '2024-25', '2024-09-12', 2000.00),
(36,10, '2023-24', '2023-10-10', 2000.00),
(44,10, '2023-24', '2023-10-15', 2000.00);

-- ============================================================
-- semester_gpa  (155 rows)
-- Each row = one student's GPA for one semester.
-- Used for LAG, LEAD, and running SUM demos.
-- ============================================================
INSERT INTO semester_gpa (student_id, semester, year, semester_gpa, cumulative_gpa, credits_attempted, credits_earned) VALUES
-- Student 1 - Alex Turner
(1,  'Fall',   2022, 3.450, 3.450, 15, 15),
(1,  'Spring', 2023, 3.600, 3.533, 12, 12),
(1,  'Fall',   2023, 3.300, 3.458, 15, 15),
-- Student 2 - Mei Lin
(2,  'Fall',   2021, 3.700, 3.700, 15, 15),
(2,  'Spring', 2022, 3.800, 3.750, 15, 15),
(2,  'Fall',   2022, 3.600, 3.700, 15, 15),
(2,  'Spring', 2023, 3.750, 3.713, 12, 12),
(2,  'Fall',   2023, 3.850, 3.740, 15, 15),
-- Student 3 - Jordan Smith
(3,  'Fall',   2023, 3.100, 3.100, 12, 12),
-- Student 4 - Fatima Hassan
(4,  'Fall',   2022, 3.800, 3.800, 15, 15),
(4,  'Spring', 2023, 3.900, 3.850, 12, 12),
(4,  'Fall',   2023, 3.750, 3.833, 15, 15),
-- Student 5 - Ryan Cooper
(5,  'Fall',   2023, 2.900, 2.900, 12, 12),
-- Student 6 - Isabella Garcia
(6,  'Fall',   2022, 3.650, 3.650, 15, 15),
(6,  'Spring', 2023, 3.700, 3.675, 12, 12),
(6,  'Fall',   2023, 3.800, 3.717, 15, 15),
-- Student 7 - Nathan Brooks (Graduated)
(7,  'Fall',   2020, 3.900, 3.900, 15, 15),
(7,  'Spring', 2021, 4.000, 3.950, 15, 15),
(7,  'Fall',   2021, 3.800, 3.900, 15, 15),
(7,  'Spring', 2022, 3.850, 3.888, 15, 15),
(7,  'Fall',   2022, 3.950, 3.900, 15, 15),
(7,  'Spring', 2023, 3.800, 3.883, 15, 15),
-- Student 8 - Zoe Mitchell
(8,  'Fall',   2023, 3.150, 3.150, 12, 12),
-- Student 9 - Ethan Clark
(9,  'Fall',   2022, 3.200, 3.200, 15, 15),
(9,  'Spring', 2023, 3.000, 3.100, 12, 12),
(9,  'Fall',   2023, 3.100, 3.100, 15, 15),
-- Student 10 - Priya Nair
(10, 'Spring', 2024, 3.850, 3.850, 9, 9),
-- Student 11 - Lucas Martini
(11, 'Fall',   2022, 3.650, 3.650, 15, 15),
(11, 'Spring', 2023, 3.750, 3.700, 12, 12),
(11, 'Fall',   2023, 3.800, 3.733, 15, 15),
-- Student 12 - Emma Johansson
(12, 'Fall',   2021, 3.400, 3.400, 15, 15),
(12, 'Spring', 2022, 3.200, 3.300, 15, 15),
(12, 'Fall',   2022, 3.500, 3.367, 15, 15),
(12, 'Spring', 2023, 3.300, 3.350, 12, 12),
(12, 'Fall',   2023, 3.350, 3.350, 12, 12),
-- Student 13 - Omar Abdullah
(13, 'Fall',   2022, 3.700, 3.700, 15, 15),
(13, 'Spring', 2023, 3.800, 3.750, 12, 12),
(13, 'Fall',   2023, 3.650, 3.717, 15, 15),
-- Student 14 - Chloe Davis
(14, 'Fall',   2023, 3.500, 3.500, 9, 9),
-- Student 15 - Yuki Tanaka
(15, 'Fall',   2022, 3.300, 3.300, 15, 15),
(15, 'Spring', 2023, 3.100, 3.200, 12, 12),
(15, 'Fall',   2023, 3.400, 3.267, 15, 15),
-- Student 16 - Benjamin Moore (Graduated)
(16, 'Fall',   2020, 3.900, 3.900, 15, 15),
(16, 'Spring', 2021, 4.000, 3.950, 15, 15),
(16, 'Fall',   2021, 4.000, 3.967, 15, 15),
(16, 'Spring', 2022, 3.950, 3.963, 15, 15),
(16, 'Fall',   2022, 4.000, 3.970, 15, 15),
(16, 'Spring', 2023, 4.000, 3.975, 15, 15),
-- Student 17 - Amara Osei
(17, 'Fall',   2023, 3.000, 3.000, 9, 9),
-- Student 18 - Tyler Reed
(18, 'Fall',   2022, 3.600, 3.600, 15, 15),
(18, 'Spring', 2023, 3.750, 3.675, 12, 12),
(18, 'Fall',   2023, 3.850, 3.733, 15, 15),
-- Student 19 - Nadia Petrov
(19, 'Fall',   2023, 3.100, 3.100, 9, 9),
-- Student 20 - Samuel Torres
(20, 'Fall',   2022, 3.200, 3.200, 15, 15),
(20, 'Spring', 2023, 3.100, 3.150, 12, 12),
(20, 'Fall',   2023, 3.050, 3.117, 15, 15),
-- Student 21 - Christine Wu
(21, 'Fall',   2022, 3.750, 3.750, 15, 15),
(21, 'Spring', 2023, 3.800, 3.775, 12, 12),
(21, 'Fall',   2023, 3.850, 3.800, 15, 15),
-- Student 22 - Patrick OBrien
(22, 'Fall',   2023, 3.150, 3.150, 9, 9),
-- Student 23 - Laila Ahmed
(23, 'Fall',   2022, 3.850, 3.850, 15, 15),
(23, 'Spring', 2023, 3.900, 3.875, 12, 12),
(23, 'Fall',   2023, 3.800, 3.850, 15, 15),
-- Student 24 - Marcus Stone (Graduated)
(24, 'Fall',   2019, 3.700, 3.700, 15, 15),
(24, 'Spring', 2020, 3.850, 3.775, 15, 15),
(24, 'Fall',   2020, 3.900, 3.817, 15, 15),
(24, 'Spring', 2021, 4.000, 3.863, 15, 15),
(24, 'Fall',   2021, 3.950, 3.880, 15, 15),
(24, 'Spring', 2022, 4.000, 3.900, 15, 15),
-- Student 25 - Sophie Laurent
(25, 'Fall',   2023, 3.200, 3.200, 9, 9),
-- Student 26 - Diego Ramirez
(26, 'Fall',   2022, 2.500, 2.500, 15, 15),
(26, 'Spring', 2023, 2.700, 2.600, 12, 12),
(26, 'Fall',   2023, 2.550, 2.583, 15, 15),
-- Student 27 - Anna Kowalski
(27, 'Fall',   2023, 3.700, 3.700, 9, 9),
-- Student 28 - James Foster
(28, 'Fall',   2022, 3.000, 3.000, 15, 15),
(28, 'Spring', 2023, 2.900, 2.950, 12, 12),
(28, 'Fall',   2023, 2.800, 2.900, 15, 15),
-- Student 29 - Victoria Chen
(29, 'Fall',   2022, 3.600, 3.600, 15, 15),
(29, 'Spring', 2023, 3.700, 3.650, 12, 12),
(29, 'Fall',   2023, 3.800, 3.700, 15, 15),
-- Student 30 - Brandon Lee
(30, 'Fall',   2023, 3.150, 3.150, 9, 9),
-- Student 31 - Melissa Johnson
(31, 'Fall',   2022, 3.850, 3.850, 15, 15),
(31, 'Spring', 2023, 3.900, 3.875, 12, 12),
(31, 'Fall',   2023, 3.800, 3.850, 15, 15),
-- Student 32 - David Nguyen
(32, 'Fall',   2023, 3.150, 3.150, 9, 9),
-- Student 33 - Ashley Brown
(33, 'Fall',   2022, 2.700, 2.700, 15, 15),
(33, 'Spring', 2023, 2.900, 2.800, 12, 12),
(33, 'Fall',   2023, 2.800, 2.800, 15, 15),
-- Student 34 - Christopher White (Graduated)
(34, 'Fall',   2019, 3.700, 3.700, 15, 15),
(34, 'Spring', 2020, 3.800, 3.750, 15, 15),
(34, 'Fall',   2020, 3.850, 3.783, 15, 15),
(34, 'Spring', 2021, 3.900, 3.813, 15, 15),
(34, 'Fall',   2021, 3.800, 3.810, 15, 15),
(34, 'Spring', 2022, 3.750, 3.800, 15, 15),
-- Student 41 - Rebecca Hall
(41, 'Fall',   2022, 3.700, 3.700, 15, 15),
(41, 'Spring', 2023, 3.800, 3.750, 12, 12),
(41, 'Fall',   2023, 3.850, 3.783, 15, 15),
-- Student 43 - Cassandra Green (Graduated)
(43, 'Fall',   2020, 3.950, 3.950, 15, 15),
(43, 'Spring', 2021, 4.000, 3.975, 15, 15),
(43, 'Fall',   2021, 3.900, 3.950, 15, 15),
(43, 'Spring', 2022, 4.000, 3.963, 15, 15),
-- Student 48 - Kevin Park
(48, 'Fall',   2022, 3.750, 3.750, 15, 15),
(48, 'Spring', 2023, 3.800, 3.775, 12, 12),
(48, 'Fall',   2023, 3.850, 3.800, 15, 15),
-- Student 51 - Stephanie Lewis (Graduated)
(51, 'Fall',   2020, 3.800, 3.800, 15, 15),
(51, 'Spring', 2021, 4.000, 3.900, 15, 15),
(51, 'Fall',   2021, 3.900, 3.900, 15, 15),
(51, 'Spring', 2022, 3.950, 3.913, 15, 15),
-- Student 56 - Andrew Carter
(56, 'Fall',   2022, 3.700, 3.700, 15, 15),
(56, 'Spring', 2023, 3.850, 3.775, 12, 12),
(56, 'Fall',   2023, 3.900, 3.817, 15, 15),
-- Student 58 - Jason Phillips
(58, 'Fall',   2022, 3.600, 3.600, 15, 15),
(58, 'Spring', 2023, 3.750, 3.675, 12, 12),
(58, 'Fall',   2023, 3.800, 3.717, 15, 15),
-- Student 60 - Ryan Nelson (Graduated)
(60, 'Fall',   2020, 3.850, 3.850, 15, 15),
(60, 'Spring', 2021, 4.000, 3.925, 15, 15),
(60, 'Fall',   2021, 3.900, 3.917, 15, 15),
(60, 'Spring', 2022, 4.000, 3.938, 15, 15),
-- Student 64 - Cameron Bell
(64, 'Fall',   2023, 3.550, 3.550, 9, 9),
-- Student 65 - Alicia Morgan
(65, 'Fall',   2023, 3.700, 3.700, 9, 9),
-- Student 71 - Jasmine Washington
(71, 'Spring', 2024, 3.850, 3.850, 9, 9);