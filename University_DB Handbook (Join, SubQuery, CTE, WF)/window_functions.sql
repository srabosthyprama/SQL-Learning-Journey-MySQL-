use university_db;

-- ROW_NUMBER() -- 
-- Problem: Rank students by GPA within each department. Assign each student a unique sequential rank

with student_gpa as (
	select sg1.student_id,
    max(sg1.cumulative_gpa) as cumulative_gpa
    from semester_gpa sg1
    group by 1
)

select
	s.student_id,
    concat(s.first_name, ' ', s.last_name) as student_name,
    d.dept_name,
    sg.cumulative_gpa,
    row_number() over (
		partition by s.department_id
        order by sg.cumulative_gpa desc
	) as dept_rank
from students as s
join departments d on s.department_id = d.department_id
join student_gpa sg on s.student_id = sg.student_id
where s.department_id is not null
order by d.dept_name, dept_rank;

-- ================================================================================================================================

-- Problem: Write a SQL query to find the top 2 highest-performing students (based on cumulative GPA) from each department -- 

with student_gpa as (
	select sg1.student_id,
    max(sg1.cumulative_gpa) as cumulative_gpa
    from semester_gpa sg1
    group by 1
),

ranked_student as (
	select
		s.student_id,
		concat(s.first_name, ' ', s.last_name) as student_name,
		d.dept_name,
		sg.cumulative_gpa,
		row_number() over (
			partition by s.department_id
			order by sg.cumulative_gpa desc
		) as dept_rank
	from students as s
	join departments d on s.department_id = d.department_id
	join student_gpa sg on s.student_id = sg.student_id
	where s.department_id is not null
)

select * 
from ranked_student
where dept_rank <=2
order by dept_name, dept_rank;

-- ==========================================================================================================================

-- RANK() vs DENSE_RANK() -- 
-- Problem: Rank all courses by total enrollments. Handle ties so the difference between RANK and DENSE_RANK is visible.

select
	c.course_code,
    c.course_name,
    count(e.enrollment_id) as total_enrollments,
    rank() over (
		order by count(e.enrollment_id) desc
	) as rank_,
    dense_rank() over (
		order by count(e.enrollment_id) desc
	) as dense_rank_
from courses c 
join course_sections cs on c.course_id = cs.course_id
join enrollments e on cs.section_id = e.section_id	
group by c.course_code, c.course_name
order by total_enrollments desc;

-- ==========================================================================================================================

-- NTILE(4) — Dividing into Quartiles
-- Problem: Divide all students into 4 equal GPA quartiles. Quartile 1 = highest achievers.

with student_gpa as (
	select 
	sg.student_id,
    max(sg.cumulative_gpa) as cumulative_gpa
	from semester_gpa as sg
	group by 1
)

select 
    concat(s.first_name, ' ', s.last_name) as student_name,
    sg.cumulative_gpa,
    d.dept_name,
    ntile(4) over (order by sg.cumulative_gpa desc) as quartile
from students as s
join departments d on s.department_id = d.department_id
join student_gpa sg on s.student_id = sg.student_id
where s.department_id is not null
order by cumulative_gpa desc;

-- ==========================================================================================================================

-- LAG() and LEAD() -- 
-- Problem: For each student, compare their current semester GPA to the previous semester (LAG) and peek at the next
-- semester (LEAD).

select
	concat(s.first_name, ' ', s.last_name) as student_name,
    sg.year,
    sg.semester,
    sg.cumulative_gpa,
    lag(sg.cumulative_gpa) over (
		partition by s.student_id
        order by sg.year, sg.semester
	) as prev_cumulative_gpa,
    lead(sg.cumulative_gpa) over (
		partition by s.student_id
        order by sg.year, sg.semester
	) as next_cumulative_gpa,
   sg.cumulative_gpa - lag(sg.cumulative_gpa) over(
		partition by s.student_id
        order by sg.year, sg.semester
    ) as gpa_delta
from semester_gpa sg
join students s on sg.student_id = s.student_id
order by 1,2,3;

-- ==========================================================================================================================

-- FIRST_VALUE() + AVG() OVER() -- 
-- Problem: Show every professor alongside their department average salary and the name of the highest-paid person
-- in their department.

select
	concat(p.first_name, ' ', p.last_name) as  professor_name,
    d.dept_name,
    p.salary,
    avg(p.salary) over (
		partition by p.department_id
	) as dept_avg_salary,
    first_value(concat(p.first_name, ' ', p.last_name)) over (
		partition by p.department_id
        order by p.salary desc
	) as highest_paid,
    round(p.salary - avg(p.salary) over (
		partition by p.department_id
    ),2) as vs_avg
from professors p
join departments d on p.department_id = d.department_id
order by 2,3 desc;

-- ==========================================================================================================================

-- SUM() OVER() — Running Total -- 
-- Problem: For each student, show a running total of scholarship money received, ordered by year.

select 
	concat(s.first_name, ' ', s.last_name) as student_name,
    sc.scholarship_name,
    ss.academic_year,
    ss.amount_awarded,
    sum(ss.amount_awarded) over (
		partition by ss.student_id
        order by ss.academic_year, sc.scholarship_name
    ) as running_total
from student_scholarships ss
join scholarships sc on ss.scholarship_id = sc.scholarship_id
join students s on ss.student_id = s.student_id
order by ss.student_id, ss.academic_year;

-- ==========================================================================================================================

	-- Simple CTE -- 
	-- Problem: Find professors who earn above their department average and show by how much.

	with dept_avg as (
		select department_id,
		round(avg(salary)) as avg_salary
		from professors
		group by 1
	)

	select
		concat(p.first_name, ' ', p.last_name) as professor_name,
		d.dept_name,
		p.salary,
		da.avg_salary as avg_salary,
		round(p.salary - da.avg_salary,2)  as above_avg_by
	from professors p
	join departments d on p.department_id = d.department_id
	join dept_avg da on p.department_id = da.department_id
	where p.salary > da.avg_salary
	order by above_avg_by desc;

-- ==========================================================================================================================

-- Problem: Find students whose GPA is above their department average — compare each student to their own
-- department's average.

with dept_avg as
(
	select 
		s.department_id,
        avg(sg.cumulative_gpa) as avg_gpa
	from students s 
	join semester_gpa sg on s.student_id = sg.student_id
    where s.department_id is not null
    group by s.department_id
) 

select 
	concat(s.first_name,' ',s.last_name) as student_name,
    d.dept_name,
    sg.cumulative_gpa,
    round(da.avg_gpa,3) as dept_avg_gpa
from students s 
join departments d on s.department_id = d.department_id
join semester_gpa sg on s.student_id = sg.student_id
join dept_avg da on s.department_id = da.department_id
where sg.cumulative_gpa > da.avg_gpa
group by s.student_id, d.dept_name, sg.cumulative_gpa, da.avg_gpa
order by d.dept_name, sg.cumulative_gpa desc;

-- ==========================================================================================================================
-- Multi-CTE -- 
-- Problem: Find students with a GPA 3.85 & above, and also show how many courses each of them is enrolled in —
-- combining two independent calculations.

with top_student as (
	select 
		student_id,
		max(cumulative_gpa) as cumulative_gpa
	from semester_gpa
	group by student_id
	having max(cumulative_gpa) >= 3.85
),

enroll_count as (
	select 
		student_id,
		count(distinct section_id) as total_course
	from enrollments
	group by student_id
)

select 
	concat(s.first_name, ' ', s.last_name) as student_name,
	d.dept_name,
	ts.cumulative_gpa,
	ec.total_course
from students s 
join top_student ts on s.student_id =  ts.student_id
join enroll_count ec on ts.student_id = ec.student_id
join departments d on s.department_id = d.department_id
order by ts.cumulative_gpa desc;

-- ==========================================================================================================================

-- Scalar Subquery -- 
-- Problem: Show each professor's salary alongside their department average — computed as a scalar subquery in SELECT.

select
	concat(p2.first_name, ' ', p2.last_name) as professor_name,
    d.dept_name,
    p2.salary,
    (
		select 
			round(avg(p1.salary),2)
            from professors p1
            where p1.department_id = p2.department_id
    ) as dept_avg_salary
from professors p2
join departments d on p2.department_id = d.department_id
order by d.dept_name, p2.salary desc;
    
-- ==========================================================================================================================

-- IN Subqueries — Students with a scholarship

select 
	student_id,
	concat(first_name, ' ',last_name) as student_name,
    status
from students 
where student_id in(
	select distinct student_id
    from student_scholarships
);

-- NOT IN Subqueries — Students never enrolled

select
	student_id,
    concat(first_name, ' ',last_name) as student_name,
    department_id
from students
where student_id not in(
	select distinct student_id
    from enrollments
);

-- ==========================================================================================================================

-- EXISTS Subquery -- 
-- Problem: Find departments that have at least one professor earning over $130,000 — list the department with
-- professor headcount.

select
	d.dept_name,
    count(p.professor_id) as professor
from departments d
join professors p on d.department_id = p.department_id
where exists (
	select 1
    from professors p2
    where 
		p2.department_id = d.department_id
        and
		p2.salary > 130000
)
group by d.dept_name
order by professor desc;

-- ==========================================================================================================================

-- Problem Solving
-- 1) Rank professors by salary within each department — show top 2 per department.

with rank_professor as (
	select 
		concat(p.first_name,' ',p.last_name) as professor_name,
		p.salary,
		d.dept_name,
		row_number() over(
			partition by d.dept_name
			order by p.salary desc
		) as salary_rank
	from professors p
	join departments d on p.department_id = d.department_id
)

select
	professor_name,
    dept_name,
    salary,
    salary_rank
from rank_professor
where salary_rank <= 2
order by dept_name, salary_rank;

-- ==========================================================================================================================

-- Correlated Subquery -- 
-- 2) Find rooms that have never been assigned to any course section.

select
	r.room_id,
    r.building,
    r.room_number,
    r.room_type,
    r.capacity
from rooms r 
where not exists (
	select 1
    from course_sections cs
    where cs.room_id = r.room_id
);

-- ==========================================================================================================================

-- 3) List students who have received at least one scholarship

select
	s.student_id,
    concat(s.first_name,' ',s.last_name) as student_name,
    s.status
from students s 
where s.student_id in (
	select distinct student_id
    from student_scholarships
)
order by s.student_id;

-- ==========================================================================================================================

-- Correlated Subquery -- 
-- 4) Find professors who have never taught a course section.

select
	concat(p.first_name,' ',p.last_name) as professor_name,
    p.title,
    d.dept_name
from professors p 
join departments d on p.department_id = d.department_id
where not exists (
	select cs.professor_id
    from course_sections cs
    where cs.professor_id = p.professor_id
);

-- ==========================================================================================================================

-- 5) Find students whose cumulative GPA dropped compared to their previous semester entry.

with cumulative_tracking as (
	select
	concat(s.first_name,' ',s.last_name) as student_name,
	sg.year,
	sg.semester,
	sg.cumulative_gpa as current_gpa,
	lag(sg.cumulative_gpa) over (
		partition by s.student_id
		order by sg.year, sg.semester
	) as prev_gpa
from students s 
join semester_gpa sg on s.student_id = sg.student_id
)

select *
from cumulative_tracking
where current_gpa < prev_gpa
order by semester;

-- ==========================================================================================================================

-- 6) For each department, compare the average scholarship amount to the university overall average.

with dept_avg as (
	select 
		d.dept_name,
        avg(sc.amount) as avg_dept_amount
    from departments d
    left join scholarships sc on d.department_id = sc.department_id
    group by d.dept_name
    
),

uni_overall_avg as (
	select avg(amount) as avg_uni_amount
    from scholarships
)

select 
	da.dept_name,
    round(da.avg_dept_amount,2) as dept_avg_amount,
    round(uo.avg_uni_amount,2) as uni_avg_amount,
    round(uo.avg_uni_amount - da.avg_dept_amount,2) as diff_from_overall
from dept_avg da
cross join uni_overall_avg uo;

-- ==========================================================================================================================

-- 7) Divide all professors into 3 salary tiers using NTILE: High, Mid, Low.

with rank_professor as (
	select
		concat(p.first_name, ' ', p.last_name) as professor_name,
		d.dept_name,
		p.salary,
		ntile(3) over(
			order by salary desc
		) as tier
	from professors p
	join departments d on p.department_id = d.department_id
)

select 
	professor_name,
	dept_name,
	salary,
	case
		when tier = 1 then "High"
		when tier = 2 then "Mid"
		when tier = 3 then "Low"
	end as salary_tier
from rank_professor;

-- ==========================================================================================================================

-- Correlated Subquery --  
-- 8) Find students who are both enrolled in a course section AND hold at least one scholarship.

select
	s.student_id,
    concat(s.first_name,' ',s.last_name) as student_name,
    d.dept_name
from students s
join departments d on s.department_id = d.department_id
where exists (
	select 1
    from enrollments e
    where e.student_id = s.student_id
)
and exists (
	select 1
    from student_scholarships sc
    where sc.student_id = s.student_id
)
order by d.dept_name, s.student_id;

-- -- ==========================================================================================================================

-- -- Correlated Subquery --  
-- 9) For each department, find the most expensive scholarship that any of its students received

select
	d.dept_name,
    (
		select sc.scholarship_name
		from scholarships sc
        where sc.department_id = d.department_id
        order by sc.amount desc
        limit 1
    ) as max_scholarship_name,
    (
		select max(sc.amount)
        from scholarships sc
        where sc.department_id = d.department_id
    ) as max_amount
from departments d
order by max_amount desc;

-- MULTI-CTE + WF -- 
-- 10) Student performance report: latest GPA, GPA rank within department, total scholarships earned.

with latest_gpa_rank as (
	select 
		student_id,
        semester_gpa,
	row_number() over (
		partition by student_id
        order by year desc, semester_gpa desc
    ) as rank_gpa
    from semester_gpa
),

student_latest_gpa as (
	select 
		student_id,
        semester_gpa
	from latest_gpa_rank
    where rank_gpa = 1
),

dept_gpa_rank as (
	select 
		s.student_id,
        concat(s.first_name,' ',s.last_name) as student_name,
        slg.semester_gpa,
        rank() over(
			partition by s.department_id
            order by slg.semester_gpa desc
        ) as gpa_rank
	from students s 
    join student_latest_gpa slg on s.student_id = slg.student_id
),

scholarship_amount_earned as (
	select 
		student_id,
        sum(amount_awarded) as scholarship_earned
	from student_scholarships
    group by student_id
)

select 
	s.student_id,
    concat(s.first_name,' ',s.last_name) as student_name,
    d.dept_name,
    dgr.semester_gpa as latest_gpa,
    dgr.gpa_rank,
    coalesce(sae.scholarship_earned,0) as scholarship_earned
from students s
join departments d on s.department_id = d.department_id
join dept_gpa_rank dgr on s.student_id = dgr.student_id
left join scholarship_amount_earned sae on s.student_id = sae.student_id
order by d.dept_name, dgr.gpa_rank;