create database load_data;
use load_data;

-- Table Data Import Wizard
CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    sale_date DATE NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    product_category VARCHAR(50) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('Paid', 'Pending', 'Refunded') DEFAULT 'Paid',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

select * from sales_data;

 /*------------------------------------------------------------------------------------------*/
 
/* How many total sales records are available 
in the sales_data table? */
select count(*) from sales_data;

 /*------------------------------------------------------------------------------------------*/
 
 -- Find the customers who made purchases during February 2026.
 select customer_name, sale_date
 from sales_data
 where sale_date between '2026-02-01' and '2026-02-28'