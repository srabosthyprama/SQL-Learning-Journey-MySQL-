use load_data;

CREATE TABLE transactions (
    transaction_id INT,
    transaction_date DATE,
    transaction_time TIME,
    transaction_qty INT,
    store_id INT,
    store_location VARCHAR(100),
    product_id INT,
    unit_price DECIMAL(10, 2),
    product_category VARCHAR(50),
    product_type VARCHAR(100),
    product_detail VARCHAR(100)
);

select * from transactions;

 /*------------------------------------------------------------------------------------------*/
 
 /* How many total transactions are available 
 in the transactions table? */
 select count(transaction_id) as total_transaction
 from transactions;
 
  /*------------------------------------------------------------------------------------------*/
 
 /* 
 Find the top 5 product categories with the 
 highest number of transactions in January 2023.
 */
select 
	product_category, count(transaction_id) as order_count
from transactions
where transaction_date between '2023-01-01' and '2023-01-31'
group by product_category
order by order_count desc
limit 5;

 /*------------------------------------------------------------------------------------------*/
 
 /* 
 Find the top 5 product categories that 
 had more than 5,000 transactions in January 2023.
 */
 select
	product_category, count(transaction_id) as order_count
from transactions
where transaction_date between '2023-01-01' and '2023-01-31'
group by product_category
having order_count > 5000
order by order_count desc
limit 5;

 /*------------------------------------------------------------------------------------------*/
 
/*  How many unique product categories are available 
in the transactions table? */
select count(distinct product_category) as product_count
from transactions;

 /*------------------------------------------------------------------------------------------*/
 
-- Find the total number of transactions for each product category.
select 
	product_category,
    count(*) as transaction_count
from transactions
group by product_category;

 /*------------------------------------------------------------------------------------------*/
 
/*
Calculate total revenue for each product category 
within each store location, and display the 
highest-revenue categories first within each location.*/
select 
	store_location, 
    product_category,
    round(sum(transaction_qty * unit_price)) as revenue
from transactions
group by 1,2
order by 1 asc, 3 desc;

 /*------------------------------------------------------------------------------------------*/
 
 -- What are the total sales, total number of transactions, and total units sold?
 select 
	round(sum(transaction_qty * unit_price)) as total_sales,
    count(distinct transaction_id) as transaction_count,
    sum(transaction_qty) as total_units
from transactions;

 /*------------------------------------------------------------------------------------------*/
 
 -- Which store locations generate the highest total sales revenue?
 select 
	store_location, 
    round(sum(transaction_qty * unit_price)) as total_sales
from transactions
group by 1
order by 2 desc;

 /*------------------------------------------------------------------------------------------*/
 
 -- Which product category generates the highest revenue?
 select 
	product_category,
	round(sum(transaction_qty * unit_price)) as revenue
from transactions
group by 1
order by 2 desc;

 /*------------------------------------------------------------------------------------------*/
 
 -- Show the monthly sales performance by calculating total revenue for each month.
 select 
	date_format(transaction_date, '%Y-%m') as sales_month,
	round(sum(transaction_qty * unit_price)) as revenue
from transactions
group by 1;

 /*------------------------------------------------------------------------------------------*/
 
-- Which Day of the Week Performs Best?
select 
	dayname(transaction_date) as day_name,
    count(*) as transaction_count
from transactions
group by 1
order by 2 desc;

 /*------------------------------------------------------------------------------------------*/
 
 -- Which hour of the day has the highest number of transactions?
 select
	hour(transaction_time) as hours,
    count(*) as transaction_count
from transactions
group by 1
order by 2 desc;

 /*------------------------------------------------------------------------------------------*/
 
 -- Show the total units sold for each product category in each store location.
 select
    store_location,
    product_category,
    sum(transaction_qty) as unit_sold
from transactions
group by 1,2
order by 1, 3 desc;

/*------------------------------------------------------------------------------------------*/

-- What is the average transaction value for each store location?
select 
	store_location,
    round(avg(transaction_qty * unit_price)) as avg_transaction_value
from transactions
group by 1
order by 2 desc;

/*------------------------------------------------------------------------------------------*/

/* Compare the number of transactions and total revenue across 
Low, Medium, and Premium priced products. */
select 
    case
		when unit_price <=5 then "Low Price"
        when unit_price >5 and unit_price <=10 then "Medium Price" 
        else "Premium"
	end as pricing,
	count(*) as total_transaction,
    round(sum(transaction_qty * unit_price)) as revenue
from transactions
group by 1;

/*------------------------------------------------------------------------------------------*/

-- How many transactions were made for each product category?
select 
	product_category,
    count(*) as transaction_count
from transactions
group by 1;

/*------------------------------------------------------------------------------------------*/

/*
CASE 1: TOP 3 SELLING PRODUCTS
CASE 2: STOREWISE SALES OF THOSE TOP 3 PRODUCTS
*/
-- top 3 selling products:
select 
	product_category,
    count(*) as transation_count
from transactions
group by 1
order by 2 desc;
-- output: Coffee, Tea, Bakery

-- storewise sales
select 
	store_location,
    count(case 
			when product_category = 'Coffee' then transaction_id
		  end) as coffee_sold,
	count(case 
			when product_category = 'Tea' then transaction_id
		  end) as tea_sold,
	count(case 
			when product_category = 'Bakery' then transaction_id
		  end) as bakery_sold
from transactions
group by 1;
