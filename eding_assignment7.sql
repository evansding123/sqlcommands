/* Assignment7.sql
  Evans Ding
   CS 31A, Spring 2022
*/

/* put the database name into this command */
USE megastore;

/* Query 1
  Display the product ID, product description, and price of the least expensive product in the
  database. (Use a subquery.)
*/

SELECT prod_id, prod_desc, MIN(prod_list_price)
FROM products
GROUP BY prod_id
HAVING MIN(prod_list_price) =
  (SELECT MIN(prod_list_price)
  FROM products);



/*
Question 2: Write a SQL statement that uses the IN operator to find the customer ID, first name, and last name
of each customer for which as order was created on 10/01/2013. (Use a subquery.)
*/

SELECT cust_id, first_name, last_name
FROM customers
WHERE cust_id IN
  (SELECT cust_id
  FROM orders
  WHERE ord_date = '2013-10-01');

/*
Question 3: Repeat query 2, but this time, use the EXISTS operator in your answer.
*/
SELECT cust_id, first_name, last_name
FROM customers
WHERE EXISTS
  (SELECT cust_id
  FROM orders
  WHERE orders.cust_id = customers.cust_id
  AND ord_date = '2013-10-01');

/*
Question 4: Display the order ID and order date for each order created for the customer William Morris. (Use a
subquery.)
*/

SELECT ord_id, ord_date
FROM orders
WHERE ord_id IN
  (SELECT ord_id
  FROM customers
  WHERE first_name = 'William'
  AND last_name = 'Morris');

/*
Question 5: Display the product ID, product description, product price, and category for each product that has a
unit price greater than the unit price of every product in category ID PET. Use either the ALL or ANY operator in
your query. (Hint: Make sure you select the correct operator.)
*/

SELECT prod_id, prod_desc, catg_id, prod_list_price
FROM products
WHERE prod_list_price >
  (SELECT MAX(prod_list_price)
  FROM products
  WHERE catg_id = 'PET');

/*
Question 6: Display all those employees who have a salary greater than that of an employee whose last name is
Ernst and are in the same department as an employee whose last name is Chen.
*/

SELECT *
FROM employees
WHERE salary >
  (SELECT MAX(salary)
  FROM employees
  WHERE last_name = 'Ernst'
 )
AND dept_id = (
    SELECT dept_id
    FROM employees
    WHERE last_name = 'Chen'
  );


/*
Question 7: Display the department ID and minimum salary of all employees, grouped by department ID. This
minimum salary must be greater than the minimum salary of those employees whose department ID is not
equal to 50.
*/

SELECT dept_id, MIN(salary)
FROM employees
GROUP BY dept_id
HAVING MIN(salary) >
  (SELECT MIN(salary)
  FROM employees
  WHERE dept_id != 50);

/*
Question 8: Write a SQL statement that finds the last names of all employees whose salaries are the same as the
minimum salary for any department.
*/

SELECT last_name
FROM employees
WHERE salary IN
  (SELECT MIN(salary)
  FROM employees
  GROUP BY dept_id);


-- SELECT MIN(salary)
-- FROM employees;

/*
Question 9: Write a pair-wise subquery listing the last name, first name, department ID, and manager ID for all
employees that have the same department ID and manager ID as employee with ID 109. Exclude employee 109
from the result set.
*/

SELECT last_name, first_name, dept_id, manager_id
FROM employees
WHERE (dept_id, manager_id) IN
(SELECT dept_id, manager_id
FROM employees
WHERE emp_id = 109);

/*
Question 10: Write a non-pair-wise subquery listing the last name, first name, department ID, and manager ID
for all employees that have the same department ID and manager ID as employee 109.
*/

SELECT last_name, first_name, dept_id, manager_id
FROM employees
WHERE dept_id IN
(SELECT dept_id
FROM employees
WHERE emp_id = 109)
AND manager_id IN
(SELECT manager_id
FROM employees
WHERE emp_id = 109)
AND emp_id != 109;



/*
Question 11: Write a SQL statement that lists the highest earners for each department. Include the last name,
department ID, and the salary for each employee.
*/

SELECT last_name, dept_id, salary
FROM employees
WHERE salary IN
(SELECT MAX(salary)
FROM employees
GROUP BY dept_id);


/*
Question 12: Display all customers who bought product 1050 AND product 1060.
*/
SELECT cust_id, last_name
FROM customers c
WHERE cust_id IN
(SELECT cust_id
FROM orders o
WHERE o.cust_id = c.cust_id
AND o.ord_id IN
(SELECT od.ord_id
FROM order_details od
WHERE od.ord_id = o.ord_id
AND od.prod_id = 1050
));


/*
Question 13: What is the product name and list price for the products that are not selling? These would be
products in the PRODUCTS table that do not appear on any order.
*/

SELECT catg_id, prod_id, prod_desc, prod_list_price
FROM products p
WHERE NOT EXISTS
(SELECT prod_id
FROM order_details od
WHERE od.prod_id = p.prod_id);

