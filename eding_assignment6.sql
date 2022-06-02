/* Assignment6.sql
  Evans Ding
   CS 31A, Spring 2022
*/

/* put the database name into this command */
USE megastore;

/* Query 1 */
-- Question 1: Write a SELECT statement that finds the average salary for Mega Store (MS) employees whose
-- manager ID is 100.

SELECT AVG(salary)
FROM employees
WHERE manager_id = 100;

-- Query 2:
-- Display the lowest salary, the most recent hire date, the last name who is first in an alphabetical list
-- of employees, and the last name who is last of an alphabetical list of employees. Select only employees who are
-- in departments 30 or 60.

SELECT MIN(salary) AS lowest_salary, MIN(hire_date) AS recent_hire, MIN(last_name) AS f_last_name, MAX(last_name) AS l_last_name
FROM employees
WHERE dept_id = 30 OR dept_id = 60;

-- Query 3
-- Create a list including each employee's first name concatenated to a space and the employee's last
-- name, and the salary of all employees where the last name contains the string 'ar'.

SELECT CONCAT(first_name, ' ', last_name) AS 'employee name', salary
FROM employees
WHERE last_name LIKE '%ar%';

-- Query 4
-- Display the last name who is first in an alphabetical list of employees in the employees table, and
-- the last name who is last in that an alphabetical list.

SELECT MIN(last_name) AS 'first last name', MAX(Last_name) AS 'last last name'
FROM employees;

-- Query 5
-- Create a list of weekly salaries from the employees. The salaries should be formatted to include a $-
-- sign and have two decimal points like: $9999.99.

SELECT emp_id, CONCAT('$', salary) AS 'weekly salary'
FROM employees;

-- Query 6
-- Display the product ID and product description for all products. The product descriptions should
-- appear in uppercase letters.

SELECT prod_id, UPPER(prod_desc) AS Prod_description
FROM products;


-- Query 7
-- Display the customer ID, first name, last name, and credit limit for all customers. The credit limit
-- should be rounded to the nearest dollar.

SELECT cust_id, first_name, last_name, ROUND(credit_limit) as credit_limit
FROM customers;

-- Query 8
-- The Mega Store is running a promotion that is valid for up to 20 days after an order is placed.
-- Write a SQL statement that lists the order ID, customer ID, first name, and last name. The promotion date is 20
-- days after the order was placed.

SELECT ord_id, c.cust_id, first_name, last_name, ord_date, DATE_ADD(ord_date, INTERVAL 20 DAY) AS promotion_date
FROM orders AS o
JOIN customers AS c ON o.cust_id = c.cust_id
GROUP BY ord_id;

-- Query 9
-- Display the product ID and the number of orders placed for each product. Show the results in
-- decreasing order and label result column NumOrders.


SELECT p.prod_id, SUM(quantity_ordered) AS NumOrders
FROM products AS p
JOIN order_details AS d ON p.prod_id = d.prod_id
GROUP BY prod_id
ORDER BY NumOrders DESC;


-- Query 10
-- Write a SELECT statement that answers this question: Which customers have ordered more
-- than one product? Return these columns:
-- • The customer ID from the CUSTOMERS table
-- • The count of distinct products from the customer’s orders

SELECT c.cust_id, COUNT(DISTINCT d.prod_id) AS number_of_items
FROM customers AS c
JOIN orders AS o ON c.cust_id = o.cust_id
JOIN order_details AS d ON o.ord_id = d.ord_id
GROUP BY c.cust_id;

-- Query 11
-- Consider the groups of products where each group contains the products that are from the same
-- category. For each such group that has more than 5 products, display category ID, number of products in the
-- group, and average price of the products in the group.

SELECT catg_id, COUNT(DISTINCT prod_id) AS number_of_products, AVG(prod_list_price) AS average
FROM products
GROUP BY catg_id
HAVING number_of_products > 5;

-- Query 12
-- Display the average price and category ID for each product category.

SELECT AVG(prod_list_price) AS avgPrice, catg_id
FROM products
GROUP BY catg_id;


-- Query 13
-- Use UNION ALL to return orders with either a Sporting goods product or a pet supply product or
-- both.

SELECT p.prod_id, catg_id, prod_name
FROM orders AS o
JOIN order_details AS d ON o.ord_id = d.ord_id
JOIN products AS p ON d.prod_id = p.prod_id
WHERE catg_id = 'SPG'

UNION ALL

SELECT p.prod_id, catg_id, prod_name
FROM orders AS o
JOIN order_details AS d ON o.ord_id = d.ord_id
JOIN products AS p ON d.prod_id = p.prod_id
WHERE catg_id = 'PET';


-- Query 14
-- USE UNION to return HW products purchased with either a Nov or Dec date.

SELECT p.prod_id, catg_id, prod_name
FROM products AS p
JOIN order_details AS d ON p.prod_id = d.prod_id
JOIN orders AS o ON d.ord_id = o.ord_id
WHERE ord_date LIKE '%-11-%'

UNION

SELECT p.prod_id, catg_id, prod_name
FROM products AS p
JOIN order_details AS d ON p.prod_id = d.prod_id
JOIN orders AS o ON d.ord_id = o.ord_id
WHERE ord_date LIKE '%-12-%'
