
delimiter ;
DROP DATABASE megastore;
CREATE DATABASE megastore;
USE megastore;
-- remove any prior version of tables

DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS shipping_modes;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS credit_ratings;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS warehouses;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS jobs;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS locations;

-- Creare locations table
CREATE TABLE locations(
    loc_id              INT NOT NULL  
  , loc_postal_code     VARCHAR(12)  NOT NULL
  , loc_street_address  VARCHAR(25)  NOT NULL
  , loc_city            VARCHAR(25)  NOT NULL
  , loc_state_province  VARCHAR(25)  NOT NULL
  , loc_country_id      CHAR(2)      NOT NULL
  , loc_type            VARCHAR(25)  NULL
  , CONSTRAINT loc_pk   PRIMARY KEY(loc_id)
  , CONSTRAINT loc_id_range CHECK(loc_id >= 1000)
)ENGINE = INNODB;

-- Creare departments table
CREATE TABLE  departments
   (dept_id DECIMAL(4,0),
    department_name VARCHAR(30) NOT NULL ,
    manager_id DECIMAL(6,0),
    loc_id INT,
     CONSTRAINT dept_id_pk PRIMARY KEY (dept_id),
     CONSTRAINT dept_loc_fk FOREIGN KEY (loc_id) 
        REFERENCES locations (loc_id) 
   );

-- Creare jobs table
CREATE TABLE jobs
   (job_id VARCHAR(10),
    job_title VARCHAR(35)  NOT NULL,
    min_salary DECIMAL(6,0),
    max_salary DECIMAL(6,0),
     CONSTRAINT job_id_pk PRIMARY KEY (job_id)
   )ENGINE = INNODB;

-- Creare employess table
CREATE TABLE  employees
   (emp_id INT NOT NULL,
    first_name VARCHAR(20),
    last_name VARCHAR(25)  NOT NULL,
    email VARCHAR(25)  NOT NULL,
    phone_number VARCHAR(20),
    hire_date DATE  NOT NULL,
    job_id VARCHAR(10)  NOT NULL,
    salary DECIMAL(8,2),
    commission_pct DECIMAL(2,2),
    manager_id INT,
    dept_id DECIMAL(4,0),
    bonus VARCHAR(5)
 , CONSTRAINT emp_pk               PRIMARY KEY(emp_id)
  , CONSTRAINT dept_emp_fk          FOREIGN KEY (dept_id) 
        REFERENCES departments(dept_id)
  , CONSTRAINT mng_emp_fk           FOREIGN KEY ( manager_id) 
        REFERENCES employees(emp_id)
  , CONSTRAINT job_emp_fk           FOREIGN KEY (job_id)  
        REFERENCES jobs(job_id)
  , CONSTRAINT emp_id_range CHECK (emp_id >= 100)
)ENGINE = INNODB;


-- Creare categories table
CREATE TABLE categories(
    catg_id             VARCHAR(6)      NOT NULL  
  , catg_desc           VARCHAR(25)     NOT NULL 
  , CONSTRAINT catg_pk  PRIMARY KEY(catg_id) 
  , CONSTRAINT catg_dec_un UNIQUE(catg_desc)
  )ENGINE = INNODB;

-- Creare products table
CREATE TABLE products( 
    prod_id             INT  NOT NULL                 
  , prod_name           VARCHAR(25)    NOT NULL
  , prod_desc           VARCHAR(50)    NULL
  , prod_list_price     DECIMAL(6,2) NOT NULL
  , catg_id             VARCHAR(6)     NOT NULL
  , CONSTRAINT prod_pk             PRIMARY KEY(prod_id)
  , CONSTRAINT prod_catg_fk        FOREIGN KEY (catg_id) 
        REFERENCES categories(catg_id)
  , CONSTRAINT prod_id_range CHECK (prod_id >= 100)
 )ENGINE = INNODB;


-- Creare warehouses table
CREATE TABLE warehouses(
    warehouse_id        INT NOT NULL   
  , loc_id              INT NOT NULL 
  , CONSTRAINT wrhs_pk             PRIMARY KEY(warehouse_id)
  , CONSTRAINT wrhs_loc_fk         FOREIGN KEY(loc_id )
        REFERENCES locations(loc_id)
  , CONSTRAINT warehouse_id_range CHECK (warehouse_id > 10)
 )ENGINE = INNODB;


-- Creare inventory table
CREATE TABLE inventory(
    prod_id              INT NOT NULL 
  , warehouse_id         INT NOT NULL 
  , quantity_on_hand     INT NOT NULL
  , CONSTRAINT invent_pk           PRIMARY KEY( prod_id, warehouse_id) 
  , CONSTRAINT inv_wrhs_fk         FOREIGN KEY (warehouse_id) 
        REFERENCES warehouses(warehouse_id)
  , CONSTRAINT inv_prod_fk        FOREIGN KEY (prod_id) 
        REFERENCES products(prod_id)
)ENGINE = INNODB;


-- Creare credit_ratings table
CREATE TABLE credit_ratings (
    low_limit            INT NOT NULL UNIQUE
  , high_limit           INT NOT NULL UNIQUE
  , rating               VARCHAR(15)  NOT NULL UNIQUE
  , CONSTRAINT high_limit_range CHECK (high_limit >=low_limit)
 )ENGINE = INNODB;


-- Creare customers table
CREATE TABLE customers(
    cust_id              INT  NOT NULL  
  , last_name       VARCHAR(25)     NOT NULL
  , first_name      VARCHAR(25)     NULL
  , credit_limit         INT  NULL
  , CONSTRAINT cust_pk              PRIMARY KEY(cust_id)
  , CONSTRAINT cust_id_range CHECK (cust_id >= 100000)
)ENGINE = INNODB;

-- Create cust_address table
CREATE TABLE cust_address (
    id VARCHAR(6)  NOT NULL,
    address_line_1 VARCHAR(30) NOT NULL,
    address_line_2 VARCHAR(30),
    city VARCHAR(15) NOT NULL,
    zip_code VARCHAR(7) NOT NULL,
    customer_id INT NOT NULL,
    CONSTRAINT customer_address_pk PRIMARY KEY (id),
    CONSTRAINT customer_address_customer_fk FOREIGN KEY (customer_id)
        REFERENCES customers(cust_id)
)ENGINE = INNODB;

-- Create shipping_modes table
CREATE TABLE shipping_modes (
    shipping_mode_id     CHAR(6)     NOT NULL 
  , shipping_mode_desc   VARCHAR(25) NOT NULL 
  , CONSTRAINT shp_mode_pk         PRIMARY KEY(shipping_mode_id)
  , CONSTRAINT shp_desc_un UNIQUE (shipping_mode_desc)
)ENGINE = INNODB;

-- Creare orders table
CREATE TABLE orders(
    ord_id               INT NOT NULL               
  , ord_date             DATETIME    NOT NULL
  , cust_id              INT  NOT NULL 
  , ord_mode             VARCHAR(25)   NOT NULL
  , shipping_mode        CHAR(6)       NULL
  , ord_status           INT NOT NULL 
  , sales_rep_id         INT NOT NULL 
  , CONSTRAINT ord_pk              PRIMARY KEY(ord_id)
  , CONSTRAINT shp_mode_fk         FOREIGN KEY (shipping_mode) 
        REFERENCES shipping_modes(shipping_mode_id)
  , CONSTRAINT ord_cust_fk         FOREIGN KEY (cust_id) 
        REFERENCES customers(cust_id)
  , CONSTRAINT ord_sales_rep_fk    FOREIGN KEY (sales_rep_id) 
        REFERENCES employees(emp_id)
  , CONSTRAINT ord_status_ck       CHECK (ord_status BETWEEN 1 AND 9)
  , CONSTRAINT ord_mode_ck         CHECK (ord_mode IN ('PHONE','ONLINE','DIRECT'))
  , CONSTRAINT ord_id_range CHECK(ord_id > 0)
)ENGINE = INNODB;

-- Creare order_details table
CREATE TABLE order_details(
    ord_id               INT NOT NULL 
  , line_item_id         INT NOT NULL 
  , prod_id              INT NOT NULL 
  , quoted_price         DECIMAL (6,2) NOT NULL 
  , quantity_ordered     INT  NOT NULL
  , CONSTRAINT ord_details_pk      PRIMARY KEY(ord_id, line_item_id)
  , CONSTRAINT ord_ord_fk          FOREIGN KEY (ord_id) 
        REFERENCES orders(ord_id)
  , CONSTRAINT ord_prod_fk        FOREIGN KEY (prod_id) 
        REFERENCES products(prod_id)
  , CONSTRAINT line_item_id_range CHECK (line_item_id >0)
)ENGINE = INNODB;