use techmart_analytics;

-- ===== Monthly Revenue Summary =====-- 
-- Problem: How much did we sell each month, in orders, units and net revenue?

select
	date_format(o.order_date, '%Y-%m') as month,
    count(distinct o.id) as total_orders,
    sum(oi.quantity) as units_sold,
    round(sum(oi.quantity * oi.unit_price * (1-oi.discount)),2) as revenue,
    round(avg(oi.quantity * oi.unit_price * (1-oi.discount)),2) as avg_line_value
from orders o
join order_items oi on o.id = oi.order_id
where o.current_status_id not in (6,7,8,9)
group by date_format(o.order_date, '%Y-%m')
order by 1;

-- ====================================================================================================

-- ===== Month-over-Month Growth ===== -- 
-- Problem: Is revenue growing or shrinking, and by how much each month?

with monthly as (
	select
		date_format(o.order_date, '%Y-%m') as month,
        round(sum(oi.quantity * oi.unit_price * (1-oi.discount)),2) as revenue
	from orders o 
    join order_items oi on o.id = oi.order_id
    where o.current_status_id not in (6,7,8,9)
    group by date_format(o.order_date, '%Y-%m')
)	

select 
	month, revenue,
    lag(revenue) over (
		order by month
    ) as prev_month_revenue,
    round((revenue - lag(revenue) over (order by month)) * 100
    /
    nullif(lag(revenue) over (order by month),0),1) as mom_growth_pct
from monthly
order by month;

-- ====================================================================================================

-- Cumulative Revenue (Running Total) -- 
-- Problem: What is our year-to-date revenue after each month, and what share did each month contribute?

with monthly as (
	select 
		date_format(o.order_date, '%Y-%m') as month,
		round(sum(oi.quantity * oi.unit_price * (1-oi.discount)),2) as monthly_revenue
	from orders o
    join order_items oi on o.id = oi.order_id
    where o.current_status_id not in (6,7,8,9)
    group by date_format(o.order_date, '%Y-%m')
)

select
	month, monthly_revenue,
    sum(monthly_revenue) over(
		order by month
        rows between unbounded preceding and current row
        ) as cumulative_revenue,
	round(monthly_revenue * 100
    /
    sum(monthly_revenue) over(),1) as pct_od_ytd
from monthly
order by month;

-- ====================================================================================================

-- Top Customers by Revenue -- 
-- Problem: Which customers generate the most revenue, and how concentrated is that at the top?

select 
	c.full_name,
    c.segment,
    c.city,
    count(distinct o.id) as orders,
    round(sum(oi.quantity * oi.unit_price * (1-oi.discount)),2) as total_revenue,
    rank() over( order by sum(oi.quantity * oi.unit_price * (1-oi.discount)) desc) as revenue_rank
from customers c
join orders o on c.id = o.customer_id
join order_items oi on o.id = oi.order_id
group by c.id, c.full_name, c.segment, c.city
order by total_revenue desc
limit 10;

-- ====================================================================================================

-- Category Performance: Revenue vs Margin -- 
-- Problem: Which categories bring in revenue, and which actually make money after cost?

select
	p.category,
    count(distinct o.id) as orders,
    sum(oi.quantity) as units_sold,
    round(sum(oi.quantity * oi.unit_price * (1-oi.discount)),2) as revenue,
    round(sum(oi.quantity * oi.unit_price * (1-oi.discount) - (oi.quantity * p.cost_price)), 2) as gross_profit,
	round(sum(oi.quantity * oi.unit_price * (1-oi.discount) - (oi.quantity * p.cost_price)) * 100
    /
    NULLIF(SUM(oi.quantity * oi.unit_price * (1 - oi.discount)), 0),1) as margin_pct
from products p
join order_items oi on p.id = oi.product_id
join orders o on oi.order_id = o.id
where o.current_status_id not in (6,7,8,9)
group by p.category
order by revenue desc;

-- ====================================================================================================

-- Best-Selling Products -- 
-- Problem: Which individual products drive revenue and profit?

select
	p.product_name,
    p.category,
    sum(oi.quantity) as units_sold,
    round(sum(oi.quantity * oi.unit_price * (1-oi.discount)),2) as revenue,
	round(sum(oi.quantity * oi.unit_price * (1-oi.discount) - (oi.quantity * p.cost_price)), 2) as profit,
    rank() over(
    order by sum(oi.quantity * oi.unit_price * (1-oi.discount)) desc
    ) as rank_by_revenue
from products p
join order_items oi on p.id = oi.product_id
join orders o on o.id = oi.order_id
where o.current_status_id not in (6,7,8,9)
group by p.id, p.product_name, p.category
order by revenue desc
limit 12;

-- ====================================================================================================

-- Revenue Concentration by Segment -- 
-- Problem: What share of revenue does each customer segment produce, and what does a typical order look like in each?

with segment_revenue as (
	select
		c.segment,
        count(distinct c.id) as total_customers,
        count(distinct o.id) as total_orders,
        round(sum(oi.quantity * oi.unit_price * (1-oi.discount)),2) as revenue
	from customers c
    join orders o on c.id = o.customer_id
    join order_items oi on o.id = oi.order_id
    where o.current_status_id not in (6,7,8,9)
    group by c.segment
)

select
	segment,
    total_customers,
    total_orders,
    revenue,
    round(revenue * 100 / sum(revenue) over(), 1) as pct_od_revenue,
    round(revenue / nullif(total_orders,0), 1) as avg_order_value
from segment_revenue
order by revenue desc;

-- ====================================================================================================

-- Employee Sales Leaderboard -- 
-- Problem: Who is closing the most revenue, and what commission has each rep earned at 3%?

select
	e.full_name,
	e.role,
	r.region_name,
	count(distinct o.id) as order_closed,
	round(sum(oi.quantity * oi.unit_price * (1-oi.discount)),2) as revenue,
	round(sum(oi.quantity * oi.unit_price * (1-oi.discount)) * 0.03,2) as commision_est,
	rank() over(
	order by sum(oi.quantity * oi.unit_price * (1-oi.discount)) desc
	) as rank_overall
from employees e
join regions r on e.region_id = r.id
join orders o on e.id = o.employee_id
join order_items oi on o.id = oi.order_id
group by e.id, e.full_name, e.role, r.region_name
order by revenue desc;
    
-- ====================================================================================================
    
-- Products Frequently Bought Together / Market Basket Analysis / Product Pair Analysis -- 
-- Problem: Which product pairs appear in the same order most often? This is the basis of a recommendation engine.

select
	p1.product_name as product_a,
    p2.product_name as product_b,
    count(distinct oi1.order_id) as times_bought_together
from order_items oi1
join order_items oi2 
	on oi1.order_id = oi2.order_id
    and 
    oi1.product_id < oi2.product_id
join products p1 on oi1.product_id = p1.id
join products p2 on oi2.product_id = p2.id
group by p1.product_name, p2.product_name
having count(distinct oi1.order_id) >= 3
order by times_bought_together desc
limit 12;
    
