-- 1. Total revenue generated per month 
SELECT 
    MONTHNAME(orderDate), SUM(priceEach * quantityOrdered)
FROM
    `order details` od
        JOIN
    orders ON od.orderNumber = orders.orderNumber
GROUP BY MONTHNAME(orderDate);


-- 2 Determine the top five products  generating the highest revenue. 

SELECT 
   distinct productName, SUM(quantityOrdered * priceEach) Sales
FROM
    orders
        JOIN
    `order details` od ON od.orderNumber = orders.orderNumber
        JOIN
    products ON products.productCode = od.productCode
GROUP BY productName
ORDER BY sales DESC
LIMIT 5;

-- 3 Find the top five customers with the highest total payments.

SELECT 
    customerName, SUM(amount) payments
FROM
    payments
        JOIN
    customers ON customers.customerNumber = payments.customerNumber
GROUP BY customerName
ORDER BY payments DESC
LIMIT 5;

-- 4.  Analyze revenue generated from each office location.

SELECT 
    offices.city,
    SUM(priceEach * quantityOrdered) sales
FROM
    offices
        JOIN
    employees ON offices.officeCode = employees.officeCode
        JOIN
    customers ON customers.salesRepEmployeeNumber = employees.employeeNumber
        JOIN
    orders ON orders.customerNumber = customers.customerNumber
        JOIN
    `order details` od ON od.orderNumber = orders.orderNumber
GROUP BY city
ORDER BY sales DESC;

--  5.Identify the top five most frequently ordered products.

SELECT 
    productName,
    SUM(quantityOrdered) total_quantity
FROM
    `order details` od
        JOIN
    products ON od.productCode = products.productCode
GROUP BY productName 
ORDER BY total_quantity DESC
LIMIT 5;

-- 6. What is the average quantity ordered per products

SELECT 
    productName, AVG(quantityOrdered)
FROM
    `order details` od
        JOIN
    products ON products.productCode = od.productCode
GROUP BY productName
ORDER BY productName;

-- 7. How many costomers are assigned to each sales representative 

with employee as (select employeeNumber,concat(firstName,' ', lastName) Name from employees)
SELECT 
    Name, COUNT(customerNumber) as `Total Customer`
FROM
    employee
        JOIN
    customers ON customers.salesRepEmployeeNumber = employee.employeeNumber
GROUP BY Name; 

--  8.Identify top-performing employees based on revenue

SELECT 
    firstName, SUM(priceEach * quantityOrdered) sales
FROM
    employees
        JOIN
    customers ON employees.employeeNumber = customers.salesRepEmployeeNumber
        JOIN
    orders ON orders.customerNumber = customers.customerNumber
        JOIN
    `order details` od ON od.orderNumber = orders.orderNumber
GROUP BY firstName
ORDER BY sales DESC;

-- 9.Compute average customer credit limit by country

SELECT 
    country, AVG(creditLimit) as `Credit limit`
FROM
    customers
GROUP BY country
order by `Credit limit` desc;

-- 10.What is the payment trend over time

SELECT 
    DATE_FORMAT(paymentDate, '%Y-%m') AS month,
    SUM(amount) AS total_payments
FROM
    payments
GROUP BY month
ORDER BY month;

-- 11 Determine the top five customer generating the highest revenue.

SELECT 
     customerName, SUM(quantityOrdered * priceEach) Sales
FROM
    customers
        JOIN
    orders ON customers.customerNumber = orders.customerNumber
        JOIN
    `order details` od ON od.orderNumber = orders.orderNumber
        
GROUP BY customerName
ORDER BY sales DESC
LIMIT 5;

-- 12 Which product are running low in stock

SELECT 
    productName, quantityInStock
FROM
    products
ORDER BY quantityInStock
LIMIT 1;

-- 13 Identify the month with the highest number of orders

SELECT 
    DATE_FORMAT(orderDate, '%D-%M') dates,
    SUM(quantityOrdered) total
FROM
    `order details` od
        JOIN
    orders ON od.orderNumber = orders.orderNumber
GROUP BY dates
ORDER BY total DESC
LIMIT 1;

-- 14 which city has the highest number of customer

SELECT 
    city, COUNT(customerName) customer
FROM
    customers
GROUP BY city
ORDER BY customer DESC
limit 1;

-- 15 which payment check Number are used most frequently

SELECT 
    checkNumber, MAX(amount)
FROM
    payments
GROUP BY checkNumber
LIMIT 1;

-- 16 How many active customers (who placed at least one order) do we have?

SELECT 
    customerName, COUNT(orders.orderNumber) AS `Total order`
FROM
    customers
        JOIN
    orders ON customers.customerNumber = orders.customerNumber
GROUP BY customerName
ORDER BY `Total order` DESC; 

-- 17.Which customers haven’t made any payments yet?

SELECT 
    customerName
FROM
    customers
        LEFT JOIN
    payments ON customers.customerNumber = payments.customerNumber
WHERE
    payments.customerNumber IS NULL;
    

-- 18.List customers whose credit limit is lower than their total payments.

SELECT 
    customerName, SUM(amount) `Total Payment`
FROM
    customers
        JOIN
    payments ON customers.customerNumber = payments.customerNumber
GROUP BY customerName , creditLimit
HAVING `Total payment` > `creditLimit`;

-- 19. Which product has the highest markup (MSRP - buyPrice)?

SELECT 
    productCode, productName, buyPrice,MSRP,(MSRP - buyPrice) AS markup
FROM
    products
ORDER BY markup DESC
LIMIT 1; 

-- 20.What is the revenue generated by each product line?
SELECT 
    productLine, SUM(quantityOrdered * priceEach)
FROM
    products
        JOIN
    `order details` od ON products.productCode = od.productCode
GROUP BY productLine;

-- 20.Which day of the week receives the most orders?
SELECT 
    DAYNAME(orderDate) days, COUNT(orderNumber) `Total order`
FROM
    orders
GROUP BY days
ORDER BY `TOtal order` DESC;

-- 22.What is the average shipping time (from order date to shipped date)?
SELECT 
    AVG(DATEDIFF(shippedDate, orderDate))
FROM
    `orders`
WHERE
    shippedDate IS NOT NULL;

