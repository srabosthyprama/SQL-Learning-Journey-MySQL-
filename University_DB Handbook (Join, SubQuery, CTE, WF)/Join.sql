use university_db;

/* Inner Join */
-- The registrar wants a clean list of every completed enrollment who took what, in which semester, 
-- and what grade they received. Enrollments that are still in progress should not appear, 
-- and neither should students who never enrolled.

select 
	concat(s.first_name, ' ', s.last_name) as full_name,
    cs.year,
    c.course_code,
    c.course_name,
    e.grade
from enrollments e
join students s on e.student_id = s.student_id
join course_sections cs	on e.section_id = cs.section_id
join courses c on cs.course_id = c.course_id
where grade is not null;

-- ==========================================================================================================================

/* Left join */
-- An academic advisor asks: "Give me every student, and next to each one their enrollments. Students who have not
-- registered for anything must still be on the list, because those are the ones I need to call."

select 
	*,
    case 
		when e.student_id is null 
        then "Not Enrolled"
        else "Enrolled"
	end as enrollment_status
from students s
left join enrollments e on s.student_id = e.student_id;

-- =========================================================================================================================
/* Full Outer Join */
-- An auditor wants everything on one screen: all students, all enrollments, and any record on either side 
-- that has no partner. Students who never enrolled must be visible, and so must any enrollment 
-- that points at a student who does not exist. Nothing may be dropped from either table.

select 
	s.student_id,
    concat(s.first_name, ' ', s.last_name) as full_name,
    e.enrollment_id,
    e.section_id,
    e.grade
from students s
left join enrollments e on s.student_id = e.student_id

union all

select 
	s.student_id,
    concat(s.first_name, ' ', s.last_name) as full_name,
    e.enrollment_id,
    e.section_id,
    e.grade
from students s
right join enrollments e on s.student_id = e.student_id;

-- =========================================================================================================================

/* CROSS JOIN */
-- The financial aid office is building an eligibility worksheet. They want every student paired with every scholarship, 
-- so an officer can go down the list and tick which pairs meet the criteria. There is no key linking the two tables. 
-- We are not matching anything; we want every combination.

select
	s.student_id,
    concat(s.first_name, ' ', s.last_name) as student_name,
    sc.scholarship_id,
    sc.scholarship_name,
    sc.amount
from students s
cross join scholarships sc
order by s.student_id, sc.scholarship_id;

-- =========================================================================================================================

/* SELF JOIN */
-- HR wants an org chart: each professor next to the name and title of the Department Head they report to. 
-- The catch is that both people live in the same professors table. A professor's manager_id is simply 
-- another professor's professor_id.

select 
		p.professor_id,
        concat(p.first_name, ' ', p.last_name) as professor_name,
        p.title,
        p.salary,
        concat(m.first_name, ' ',m.last_name) as department_head,
        coalesce(m.title, 'Manager') as head_title
	from professors p
    left join professors m on p.manager_id = m.professor_id;
    
-- =========================================================================================================================
    
-- 1) The facilities office is printing a course board for the Engineering Building lobby. They want every course 
-- that belongs to a department housed in that building. Show course_code , course_name , dept_name and building , 
-- sorted by course code.

select
		c.course_code,
        c.course_name,
        d.dept_name,
        d.building
from courses c
inner join departments d on c.department_id = d.department_id
where d.building = "Engineering Building"
order by c.course_code;

-- =========================================================================================================================

-- 2) The dean's office needs a staff list for Business Tower, the building shared by Business Administration and Economics.
-- List each professor's full name as professor_name , plus title , dept_name and building . Sort by department
-- name, then by last name.

select 
	concat(p.first_name, ' ', p.last_name) as professor_name,
    p.title,
    d.dept_name,
    d.building
from professors p 
inner join departments d on p.department_id = d.department_id
where d.building = 'Business Tower'
order by d.dept_name, p.last_name;
    
-- =========================================================================================================================

-- 3) An advisor is checking who looks after the students whose last name starts with M. She wants every one of those
-- students, even the ones who have not been assigned an advisor yet. Show student_id , student_name ,
-- advisor_name and the advisor's title , sorted by student id.

select 
	s.student_id,
    concat(s.first_name, ' ', s.last_name) as student_name,
    concat(p.first_name, ' ', p.last_name) as advisor_name,
    p.title
from students as s
left join professors as p on s.advisor_id = p.professor_id
where s.last_name like 'M%'
order by s.student_id;

-- =========================================================================================================================

-- 4) The financial aid office wants to reach out to Economics students who have never received any scholarship, 
-- not even once. Show student_id , student_name and status , sorted by student id.

select 
	s.student_id,
    concat(s.first_name, ' ', s.last_name) as student_name,
    s.status
from students as s
inner join departments d on s.department_id = d.department_id
left join student_scholarships ss on s.student_id = ss.student_id
where 
	d.dept_name = 'Economics'
    and
    ss.student_id is null
order by s.student_id;

-- =========================================================================================================================

-- 5) The timetabling team wants to know how many course sections each seminar room has hosted across all semesters.
-- Rooms that have never been used must still appear, showing zero. Show room_number , building , capacity and
-- sections_hosted , busiest room first, then by room number.

select
	r.room_number,
    r.capacity,
    r.building,
    count(cs.section_id) as section_hosted
from rooms as r
left join course_sections cs on r.room_id = cs.room_id
where r.room_type = 'Seminar Room'
group by r.room_number, r.capacity, r.building
order by section_hosted desc, r.room_number;

-- =========================================================================================================================

-- 6) The head of Data Science wants a list of every professor in her department alongside each section 
-- they have taught, and she insists on seeing professors who have not taught anything yet. Show professor_name , 
-- title , course_code , semester and year . Start the query from course_sections and write it as a RIGHT JOIN so
-- professors are the side that is fully kept. Sort by professor id, then year, then semester.

select 
    concat(p.first_name, ' ', p.last_name) as professor_name,
    p.title,
    c.course_code,
    cs.semester,
    cs.year
from course_sections cs
right join professors p on cs.professor_id = p.professor_id
inner join departments d on p.department_id = d.department_id
left join courses c on cs.course_id = c.course_id
where d.dept_name = 'Data Science'
order by p.professor_id, cs.year, cs.semester;

-- =========================================================================================================================

-- 7) Human Resources is reviewing spans of control. For every Department Head, show how many professors report
-- directly to them. Output head_name , dept_name and direct_reports , largest team first, then by the head's last name.

select 
	concat(h.first_name, ' ', h.last_name) as head_name,
    d.dept_name,
    count(p.professor_id) as direct_reports
from professors h
left join professors p on h.professor_id = p.manager_id
inner join departments d on h.department_id = d.department_id
where h.manager_id is null
group by h.professor_id, head_name, d.dept_name
order by direct_reports desc, h.last_name;

-- =========================================================================================================================

-- 8) The provost is comparing grading across the two departments in Science Hall, Mathematics and Physics. For each professor there, 
-- show professor_name , dept_name , sections_taught , graded_enrollments (enrollments with a grade) and 
-- avg_grade_points rounded to 2 decimals. Highest average first.

select 
	concat(p.first_name, ' ', p.last_name) as professor_name,
	d.dept_name,
	count(cs.section_id) as section_taught,
	count(e.grade) as graded_enrollments,
	round(avg(e.grade_points),2) as avg_grade_points
from professors p
join departments d on p.department_id = d.department_id
join course_sections cs on p.professor_id = cs.professor_id
join enrollments e on cs.section_id = e.section_id
where 
	d.building = 'Science Hall'
	and
	d.dept_name in ('Mathematics', 'Physics')
group by p.professor_id, professor_name, d.dept_name
order by avg_grade_points  desc;

-- =========================================================================================================================

-- 9) The Physics department wants a registration check for Fall 2024. For every Physics student, show how many Fall 2024
-- sections they are enrolled in. Students with nothing this term are the whole point of the report, so they must appear
-- with a zero. Output student_id , student_name , status and fall_2024_courses , sorted by student id.

select
	s.student_id,
    concat(s.first_name, ' ', s.last_name) as student_name,
    s.status,
	count(cs.section_id) as fall_2024_courses
from students as s
join departments d on s.department_id = d.department_id
left join enrollments e on s.student_id = e.student_id
left join course_sections cs on 
	e.section_id = cs.section_id
    and
    cs.semester = 'Fall'
    and
    cs.year = 2024
where d.dept_name = 'Physics'
group by 
	s.student_id,
	concat(s.first_name, ' ', s.last_name),
    s.status
order by s.student_id;

-- =========================================================================================================================

-- 10) The scholarship committee wants one complete picture: every department next to the scholarship that belongs to it,
-- plus departments that have no scholarship of their own, plus scholarships that are open to the whole university and
-- belong to no department. Nothing from either table may be left out. Show dept_name , scholarship_name and
-- amount . Put the department rows first in alphabetical order, then the university-wide rows.

select
	d.dept_name,
    sc.scholarship_name,
    sc.amount
from departments d 
left join scholarships sc on d.department_id = sc.department_id

union all

select
	d.dept_name,
    sc.scholarship_name,
    sc.amount
from departments d 
right join scholarships sc on d.department_id = sc.department_id
where d.department_id is null
order by
	dept_name IS NULL,
    dept_name,
    scholarship_name;    