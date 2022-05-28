
USE sakila ;

---------------------- Using CASE WHEN to create customized fields ------------------------------

SELECT * FROM film ;

select distinct rating from film;

/* Rating -
G - General Audience
PG - Parental Guidance
PG-13 - Parental Guidance below 13 years
R - Restricted, Parental Guidance under 17 years
NC-17 - Adults only, above 17 years 
*/

SELECT *,
CASE 

     WHEN rating = 'G' THEN 'General'
	 WHEN rating in ('PG', 'PG-13', 'R') then 'Guided'
     ELSE 'Adults' 
END AS category
FROM film ;

SELECT DISTINCT rating, category
FROM
(
	SELECT *,
	CASE WHEN rating = 'G' THEN 'General'
		 WHEN rating in ('PG', 'PG-13', 'R') then 'Guided'
		 ELSE 'Adults' 
	END AS category
	FROM film 
) a;

SELECT title, replacement_cost,
CASE
    WHEN replacement_cost > 20  THEN 'Premium'
    WHEN replacement_cost <= 20 AND replacement_cost > 10 THEN 'Budget'
    ELSE 'Cheap'
END AS category
FROM film ; 

/* ---------------------------------- Case Study ----------------------------------------------
1. What are the top selling products and categories from Northwind by month and year? 
2. Which countries have the highest shipping in terms of sales?
3. Who are the top 3 Customers and their Contact Titles per country based on purchases
4. Create the reporting hiererchy of Employees
5. Employee and Manager performance in terms of sales
*/

USE northwind ;

/*************** 1. What are the top selling products and categories from Northwind by month and year? *****************************/

-- Creating a merged table with the product and category information merged with the Order Details table

-- drop table ubaid_sandbox.order_product_category ;

create table ubaid_sandbox.order_product_category
select a.*, 
b.unitprice, b.quantity, 
c.productname, 
d.categoryname, d.description,  
year(orderdate) as yr, month(orderdate) as mth
from orders a
left join
`order details` b on a.orderid = b.orderid
left join products c on b.productid = c.productid
left join categories d on c.categoryid = d.categoryid ;

select * from ubaid_sandbox.order_product_category ;

-- Aggregating the data at the required level from the merged table

-- drop table ubaid_sandbox.order_product_category_agg ;

create table ubaid_sandbox.order_product_category_agg
select yr, mth, categoryname, productname,
sum(unitprice*quantity) as sales
from ubaid_sandbox.order_product_category 
group by yr, mth, categoryname, productname
order by yr, mth, categoryname, productname ;

select * from ubaid_sandbox.order_product_category_agg ;

/*************** 2. Which countries have the highest shipping in terms of sales? *****************************/

-- Aggregating the data at the country level from the merged table

-- drop table ubaid_sandbox.order_country_agg ;

create table ubaid_sandbox.order_country_agg
select yr, mth, shipcountry, shipcity,
sum(unitprice*quantity) as sales
from ubaid_sandbox.order_product_category 
group by yr, mth, shipcountry, shipcity
order by yr, mth, shipcountry, shipcity ;

select * from ubaid_sandbox.order_country_agg ;

/**************** 3. Who are the top 3 Customers and their Contact Titles per country based on purchases ************************/

-- Creating a merged table with the Customer information merged with the Order Details table

-- drop table ubaid_sandbox.order_country_customer ;

create table ubaid_sandbox.order_country_customer
select a.*, 
b.unitprice, b.quantity, 
c.companyname, c.contactname, c.contacttitle, c.country,
year(orderdate) as yr, month(orderdate) as mth
from orders a
left join
`order details` b on a.orderid = b.orderid
left join customers c on a.customerid = c.customerid ;

select * from ubaid_sandbox.order_country_customer ;

-- Aggregating and ranking customers at a country level in terms of sales

-- drop table ubaid_sandbox.order_country_customer_top3 ;

create table ubaid_sandbox.order_country_customer_top3
select country, contactname, contacttitle, sales, rnk
from 
(
select country, contactname, contacttitle, 
sum(unitprice*quantity) as sales,
row_number() over (partition by country order by sum(unitprice*quantity) desc) as rnk
from ubaid_sandbox.order_country_customer
group by country, contactname, contacttitle
order by country, contactname, contacttitle 
) a
where rnk<=3 ;

select * from ubaid_sandbox.order_country_customer_top3 ;

/**************** 4. Create the reporting hiererchy of Employees ************************/

-- Performing a self join on the Employees table to get the reporting superior

-- drop table ubaid_sandbox.employee_org_chart ;

create table ubaid_sandbox.employee_org_chart
select a.employeeid, concat(a.lastname, ', ', a.firstname) as empname, a.reportsto,
b.employeeid as supid, concat(b.lastname, ', ', b.firstname) as supname
from employees a
left join employees b on a.reportsto = b.employeeid ;

select * from ubaid_sandbox.employee_org_chart ;

/**************** 5. Employee and Manager performance in terms of sales ************************/

-- Creating a merged table with the Org chart table merged with the Order Details table

-- drop table ubaid_sandbox.order_employee_manager ;

create table ubaid_sandbox.order_employee_manager
select a.*, 
b.unitprice, b.quantity, 
c.empname, c.supname,
year(orderdate) as yr, month(orderdate) as mth
from orders a
left join
`order details` b on a.orderid = b.orderid
left join ubaid_sandbox.employee_org_chart c on a.employeeid = c.employeeid ;

-- Aggregating the data at the employee and superior level from the merged table

-- drop table ubaid_sandbox.order_employee_manager_agg ;

create table ubaid_sandbox.order_employee_manager_agg
select yr, mth, supname, empname,
sum(unitprice*quantity) as sales
from ubaid_sandbox.order_employee_manager
group by yr, mth, supname, empname
order by yr, mth, supname, empname ;

select * from ubaid_sandbox.order_employee_manager_agg ;

Delete from ubaid_sandbox.order_employee_manager_agg 
where empname = 'Davolio, Nancy' ;

select * from ubaid_sandbox.order_employee_manager_agg 
where empname = 'Davolio, Nancy' ;

UPDATE ubaid_sandbox.order_employee_manager_agg 
SET empname = 'Singh, Charan' where empname = 'Dodsworth, Anne' ;


