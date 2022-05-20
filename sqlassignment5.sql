/* Assignment5.sql
  Evans Ding
   CS 31A, Spring 2022
*/

/* put the database name into this command */
USE megastore;

/* Query 1 */
-- For  each  order,  write  a  SQL  statement  that  displays  the  order  ID  and  order  date  along  with  the
-- customer ID, first name, and last name of the customer for which the order was created.

SELECT orders.ord_id, orders.ord_date, customers.cust_id, customers.first_name, customers.last_name
FROM orders
INNER JOIN customers
ON orders.cust_id = customers.cust_id;

/* Query 2 */
-- For each order placed on 04/04/2014, write a SQL statement that lists the order ID, customer ID, first
-- name, and last name of the customer for which the order was created.

SELECT orders.ord_id, customers.cust_id, customers.first_name, customers.last_name, orders.ord_date
FROM ORDERS
INNER JOIN CUSTOMERS
ON orders.cust_id = customers.cust_id
AND orders.ord_date = '2014-04-04';

-- Question  3:  Display  the  customer  ID,  first  name,  and last  name  of  each customer  for  which an  order  was  NOT
-- created on 04/04/2014.

SELECT customers.cust_id, customers.first_name, customers.last_name
FROM orders
INNER JOIN customers
ON orders.cust_id = customers.cust_id
AND orders.ord_date != '2014-04-04';

-- Question 4: For each order, write a SQL statement that lists the product ID, order date, order ID, item description,
-- and category for each product that make up the order. Order the rows by category and then by order ID.

SELECT products.prod_id, orders.ord_date, order_details.ord_id, products.prod_desc, products.catg_id
FROM ((orders
INNER JOIN order_details ON order_details.ord_id = orders.ord_id)
INNER JOIN products ON order_details.prod_id = products.prod_id)
ORDER BY products.catg_id, orders.ord_id;

-- Question  5:  Display  the  order  ID,  order  date, customer  first  name,  and customer  last  name  for  each order  that
-- was created for Samuel Morse but does not contain the item description “Electric Pancake griddle”.

SELECT orders.ord_id, orders.ord_date, customers.first_name, customers.last_name, products.prod_desc
FROM orders
INNER JOIN customers ON orders.cust_id = customers.cust_id
INNER JOIN order_details ON orders.ord_id = order_details.ord_id
INNER JOIN products ON order_details.prod_id = products.prod_id
WHERE customers.first_name = 'Samuel' AND customers.last_name = 'Morse'
AND products.prod_desc != 'Electric Pancake griddle';


-- Question  6:  Display  the  order  ID,  customer  ID,  customer  last  name,  all  products  ID  in  each  order,  and  product
-- names. Display the first 10 rows in the result set.

-- SELECT customers.cust_id, customers.last_name, orders.ord_id, products.prod_id, products.prod_name
-- FROM orders, order_details, customers, products
-- WHERE orders.cust_id = customers.cust_id
-- AND orders.ord_id = order_details.ord_id
-- ORDER BY products.prod_id
-- LIMIT 10;

SELECT c.cust_id, c.last_name, o.ord_id, p.prod_id, p.prod_name
FROM orders AS o
JOIN customers c ON o.cust_id = c.cust_id
JOIN order_details d ON o.ord_id = d.ord_id
RIGHT OUTER JOIN products p ON p.prod_id = d.prod_id
LIMIT 10;

-- Question  7:  Display  the  order  ID,  customer  ID,  customer  last  name,  all  products  ID  in  each  order,  and  product
-- names. Display only the products in the ‘MUS’ category.

SELECT c.cust_id, c.last_name, o.ord_id, p.prod_id, p.prod_name
FROM orders AS o
JOIN customers c ON o.cust_id = c.cust_id
JOIN order_details d ON o.ord_id = d.ord_id
RIGHT OUTER JOIN products p ON p.prod_id = d.prod_id
WHERE p.catg_id = 'MUS';

-- Question 8:
-- Display the rating for customers. Display the customer ID, credit limit, and rating of the customer. +---------+--------------+-----------+

SELECT c.cust_id, c.credit_limit, cr.rating
FROM customers as c, credit_ratings as cr;


-- Question 9: Display both ordered and un-ordered products. Display product ID, product description, and order ID
-- in the category ‘MUS’

SELECT p.prod_id, p.prod_desc, d.ord_id
FROM products AS p
LEFT OUTER JOIN order_details AS d ON p.prod_id = d.prod_id
WHERE p.catg_id = 'MUS';

-- Question 10: Display customers with and without orders. Display customer ID, last name, and order ID.
-- We get customers with orders. If the customer has several orders, that customer gets multiple lines in the result
-- set. We also get rows  for the two customers in this cust_id range who have no orders and the column for their
-- order ID value is null—these customers each get one row.


SELECT c.cust_id, c.last_name, o.ord_id
FROM customers AS c
LEFT OUTER JOIN orders AS o ON c.cust_id = o.cust_id;


-- Question  11:  Display  all  products  sold  at  more  than their  list  price.  This  does  not  use  a  WHERE  clause.  Display
-- product ID, quoted price, list price, and order ID.

SELECT p.prod_id, d.quoted_price, p.prod_list_price, d.ord_id
FROM products AS p
JOIN order_details as d ON p.prod_list_price < d.quoted_price
LIMIT 20;


-- Question 12: Display all employees who have the same job ID. Display job ID and employee ID.

SELECT j.job_id, e.emp_id
FROM employees as e
JOIN jobs as j ON e.job_id = j.job_id




