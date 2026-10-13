use techmart_analytics;

-- Purchase Frequency Distribution -- 
-- Problem: Are most customers one-time buyers, or do they come back?

with customer_orders as (
	select
		c.id,
        count(distinct o.id) as order_count,
        case
			when count(distinct o.id) =  1 then "1 order"
            when count(distinct o.id) between 2 and 3 then "2-3 orders"
            when count(distinct o.id) between 4 and 6 then "4-6 orders"
            else "7+ orders (loyal)"
		end as frequency_bucket
	from customers c
    join orders o on c.id = o.customer_id
    where o.current_status_id not in (6)
    group by  c.id
)

select 
	frequency_bucket,
    count(id) as customers,
    round(count(id) * 100 / sum(count(id)) over(),1) as pct_of_customers
from customer_orders
group by frequency_bucket
order by min(order_count);

-- ====================================================================================================

-- Days Between Purchases -- 
-- Problem: How long does each customer typically wait before ordering again?

with ordered as (
	select
		o.customer_id,
        o.order_date,
        lag(o.order_date) over(
			partition by o.customer_id
			order by o.order_date
        ) as prev_order_date
	from orders o
    where o.current_status_id not in (6)
)

select
	c.full_name,
    c.segment,
    count(o.customer_id) as repeat_purchase,
    round(avg(datediff(order_date,prev_order_date)),0) as avg_days_between,
    max(datediff(order_date,prev_order_date)) as slowest_days,
    min(datediff(order_date,prev_order_date)) as fastest_days
from ordered as o
join customers c on o.customer_id = c.id
where prev_order_date is not null
group by c.id, c.full_name, c.segment
order by avg_days_between;

-- ====================================================================================================

-- Customer Lifetime Value -- 
-- Problem: What is each customer worth in total, and how long have they been active?

select
	c.full_name,
    c.segment,
    c.city,
	count(distinct o.id) as total_orders,
	round(sum(oi.quantity * oi.unit_price * (1-oi.discount)),2) as clv,
    round(sum(oi.quantity * oi.unit_price * (1-oi.discount)) / nullif(count(distinct o.id),0),2) as avg_order_value,
    datediff(max(o.order_date), min(o.order_date)) as lifespan_days,
    min(o.order_date) as first_order,
    max(o.order_date) as last_order
from customers c
join orders o on c.id = o.customer_id
join order_items oi on o.id = oi.order_id
where o.current_status_id not in (6,7,8,9)
group by c.id, c.full_name, c.segment, c.city
order by clv desc;

-- ====================================================================================================

-- New vs Returning Customers -- 
-- Problem: Is growth coming from new customers or from existing ones buying again?

with first_orders as (
	select
		customer_id,
        min(order_date) as first_order_date
	from orders
    where current_status_id not in (6)
    group by customer_id
)

select
	date_format(o.order_date, "%Y-%m") as month,
    count(distinct o.customer_id) as total_customers,
    count(distinct 
		case
			when date_format(fo.first_order_date, "%Y-%m") = date_format(o.order_date, "%Y-%m")
			then o.customer_id
	end) as new_customer,
	count(distinct 
		case
			when date_format(fo.first_order_date, "%Y-%m") < date_format(o.order_date, "%Y-%m")
			then o.customer_id
	end) as returning_customer

from orders o
join first_orders fo on o.customer_id = fo.customer_id
where o.current_status_id not in (6)
group by date_format(o.order_date, "%Y-%m") 
order by month;

-- ====================================================================================================

-- Top Category per Customer -- 
-- Problem: What is each customer's number one spending category?

with category_spend as (
	select
		c.id as customer_id,
        c.full_name,
        c.segment,
        p.category,
        round(sum(oi.quantity * oi.unit_price * (1-oi.discount)),2) as spend,
        rank() over(
			partition by c.id
            order by sum(oi.quantity * oi.unit_price * (1-oi.discount)) desc
        ) as category_rank
	from customers c
    join orders o on c.id = o.customer_id
    join order_items oi on o.id = oi.order_id
    join products p on oi.product_id = p.id
    where o.current_status_id not in (6,7,8,9)
    group by c.id, c.full_name, c.segment, p.category
)

select
    full_name,
    segment,
    category as top_category,
    spend
from category_spend
where category_rank = 1
order by spend desc;

	-- ====================================================================================================

-- Basket Size Analysis -- 
-- Problem: How many items are in a typical order, and how much is it worth?

with order_basket as (
	select
		order_id,
        count(order_id) as items_in_order,
        sum(quantity * unit_price * (1-discount)) as order_value
	from order_items
    group by order_id
)

select
	c.full_name,
    c.segment,
    count(distinct o.id) as orders,
    round(avg(ob.items_in_order),1) as avg_items_per_order,
    round(avg(ob.order_value),2) as avg_order_value,
    round(max(ob.order_value),2) as largest_order,
    round(min(ob.order_value),2) as smallest_order
from customers c
join orders o on c.id = o.customer_id
join order_basket ob on o.id = ob.order_id
where o.current_status_id not in (6)
group by c.id, c.full_name, c.segment
order by avg_order_value desc;

-- ====================================================================================================

-- Discount Sensitivity -- 
-- Problem: Do bigger discounts actually produce bigger orders?

with order_discount as (
	select
		o.id as order_id,
        c.segment,
        avg(oi.discount) as avg_discount,
        sum(oi.quantity * oi.unit_price * (1-oi.discount)) as order_value
	from customers c
    join orders o on c.id = o.customer_id
    join order_items oi on o.id =  oi.order_id
    where o.current_status_id not in (6,7,8,9) 
    group by o.id, c.segment
)

select
	segment,
    case
		when avg_discount = 0 then "no discount"
        when avg_discount < 0.10 then "low (1-9%)"
        when avg_discount < 0.20 then "mid (10-19%)"
        else "high (20%+)"
	end as discount_tier,
    count(order_id) as orders,
    round(avg(order_value),2) as avg_order_value,
    round(sum(order_value),2) as total_revenue
from order_discount
group by segment, discount_tier
order by segment, avg_order_value desc;

-- ====================================================================================================

-- Order Pattern by Day of Week -- 
-- Problem: Which days do customers actually buy on?

select
	dayname(o.order_date) as day_of_week,
    dayofweek(o.order_date) as day_num,
    count(distinct o.id) as total_orders,
    count(distinct o.customer_id) as unique_customer,
    round(sum(oi.quantity * oi.unit_price * (1-oi.discount)),2) as revenue
from orders o
join order_items oi on o.id = oi.order_id
where o.current_status_id not in (6)
group by day_of_week, day_num
order by day_num;

-- ====================================================================================================

-- First Product Purchased -- 
-- Problem: What do customers buy on their very first order? This is the entry point into the catalogue

with first_order as (
	select
		o.customer_id,
        o.id as order_id,
        o.order_date,
        rank() over(
			partition by o.customer_id
            order by o.order_date
        ) as order_rank
	from orders o
    where o.current_status_id not in (6)
)

select
	p.category,
    p.product_name,
    count(oi.product_id) as first_purchase_count,
    round(count(oi.product_id) * 100 / sum(count(oi.product_id)) over(),1) as pct_of_first_purchases
from first_order fo
join order_items oi on fo.order_id = oi.order_id
join products p on oi.product_id = p.id
where fo.order_rank = 1
group by p.category, p.product_name
order by first_purchase_count desc;

-- ====================================================================================================

-- Second-Order Category Path -- 
-- Problem: After their first order, what do customers buy next?

with ranked_order as (
	select
		customer_id,
		id as order_id,
		row_number() over(
			partition by customer_id
			order by order_date
		) as order_num
	from orders 
	where current_status_id not in (6)
),

order_categories as 
(
	select
		ro.customer_id,
		ro.order_num,
		group_concat(distinct p.category order by p.category) as categories
	from ranked_order ro
	join order_items oi on ro.order_id = oi.order_id
	join products p on oi.product_id = p.id
	group by ro.customer_id, ro.order_num
)

select
	a.categories as first_order_category,
    b.categories as second_order_category,
    count(a.customer_id) as customers_with_this_path
from order_categories a
join order_categories b on a.customer_id = b.customer_id
where a.order_num = 1 and b.order_num = 2
GROUP BY a.categories, b.categories
order by customers_with_this_path desc;