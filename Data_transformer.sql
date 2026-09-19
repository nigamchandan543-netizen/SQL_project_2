-- Optional: start clean
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Employees;

-- ---------- Schema ----------
CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  FirstName VARCHAR(80) NOT NULL,
  LastName VARCHAR(80) NOT NULL,
  Email VARCHAR(160) NOT NULL,
  RegistrationDate DATE NOT NULL
);

CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT NOT NULL,
  OrderDate DATE NOT NULL,
  TotalAmount DECIMAL(12,2) NOT NULL
);

CREATE TABLE Employees (
  EmployeeID INT PRIMARY KEY,
  FirstName VARCHAR(80) NOT NULL,
  LastName VARCHAR(80) NOT NULL,
  Department VARCHAR(80) NOT NULL,
  HireDate DATE NOT NULL,
  Salary DECIMAL(12,2) NOT NULL
);

-- ---------- Seed (assignment rows + extras) ----------
INSERT INTO Customers (CustomerID, FirstName, LastName, Email, RegistrationDate) VALUES
  (1, 'John', 'Doe', 'john.doe@email.com', '2022-03-15'),
  (2, 'Jane', 'Smith', 'jane.smith@email.com', '2021-11-02'),
  (3, 'Robert', 'Chen', 'r.chen@email.com', '2023-01-20'),
  (4, 'Priya', 'Patel', 'priya.patel@email.com', '2020-08-11'),
  (5, 'Michael', 'Torres', '  m.torres@email.com  ', '2023-06-01'),
  (6, 'Elena', 'Vargas', 'elena.vargas@email.com', '2024-02-14'),
  (7, 'David', 'Kim', 'd.kim@email.com', '2022-12-05'),
  (8, 'John', 'Park', 'john.park@email.com', '2023-04-18');

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
  (101, 1, '2023-07-01', 150.50),
  (102, 2, '2023-07-03', 200.75),
  (103, 1, '2023-08-15', 1250.00),
  (104, 3, '2023-09-02', 680.40),
  (105, 4, '2023-10-21', 89.99),
  (106, 4, '2024-01-08', 2100.00),
  (107, 5, '2024-03-12', 540.00),
  (108, 7, '2024-05-19', 45.25),
  (109, 2, '2024-11-30', 999.00),
  (110, 3, '2025-02-14', 320.00),
  (111, 8, '2025-06-01', 1575.80),
  (112, 5, '2025-08-22', 410.00);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, HireDate, Salary) VALUES
  (1, 'Mark', 'Johnson', 'Sales', '2020-01-15', 50000.00),
  (2, 'Susan', 'Lee', 'HR', '2021-03-20', 55000.00),
  (3, 'James', 'Okonkwo', 'Engineering', '2019-06-10', 92000.00),
  (4, 'Aisha', 'Rahman', 'Sales', '2022-09-01', 48000.00),
  (5, 'Thomas', 'Bradley', 'Finance', '2018-04-22', 78000.00),
  (6, 'Nina', 'Volkov', 'Marketing', '2023-11-15', 42000.00),
  (7, 'Grace', 'Park', 'Engineering', '2021-07-08', 88000.00),
  (8, 'Leo', 'Santos', 'HR', '2024-01-09', 51000.00);

-- =========================================================
-- 1. INNER JOIN
-- =========================================================
SELECT
  o.OrderID,
  o.OrderDate,
  o.TotalAmount,
  c.CustomerID,
  c.FirstName,
  c.LastName,
  c.Email
FROM Orders o
INNER JOIN Customers c
  ON o.CustomerID = c.CustomerID
ORDER BY o.OrderID;

-- =========================================================
-- 2. LEFT JOIN
-- =========================================================
SELECT
  c.CustomerID,
  c.FirstName,
  c.LastName,
  o.OrderID,
  o.OrderDate,
  o.TotalAmount
FROM Customers c
LEFT JOIN Orders o
  ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerID, o.OrderID;

-- =========================================================
-- 3. RIGHT JOIN
-- =========================================================
SELECT
  o.OrderID,
  o.OrderDate,
  o.TotalAmount,
  c.CustomerID,
  c.FirstName,
  c.LastName
FROM Customers c
RIGHT JOIN Orders o
  ON c.CustomerID = o.CustomerID
ORDER BY o.OrderID;

-- =========================================================
-- 4. FULL OUTER JOIN (MySQL: LEFT UNION RIGHT)
-- =========================================================
SELECT
  c.CustomerID,
  c.FirstName,
  c.LastName,
  o.OrderID,
  o.OrderDate,
  o.TotalAmount
FROM Customers c
LEFT JOIN Orders o
  ON c.CustomerID = o.CustomerID
UNION
SELECT
  c.CustomerID,
  c.FirstName,
  c.LastName,
  o.OrderID,
  o.OrderDate,
  o.TotalAmount
FROM Customers c
RIGHT JOIN Orders o
  ON c.CustomerID = o.CustomerID
ORDER BY CustomerID, OrderID;

-- =========================================================
-- 5. Subquery — orders above average amount
-- =========================================================
SELECT
  c.CustomerID,
  c.FirstName,
  c.LastName,
  o.OrderID,
  o.TotalAmount
FROM Customers c
INNER JOIN Orders o
  ON c.CustomerID = o.CustomerID
WHERE o.TotalAmount > (
  SELECT AVG(TotalAmount) FROM Orders
)
ORDER BY o.TotalAmount DESC;

-- =========================================================
-- 6. Subquery — salaries above average
-- =========================================================
SELECT
  EmployeeID,
  FirstName,
  LastName,
  Department,
  Salary
FROM Employees
WHERE Salary > (
  SELECT AVG(Salary) FROM Employees
)
ORDER BY Salary DESC;

-- =========================================================
-- 7. Year and month from OrderDate
-- =========================================================
SELECT
  OrderID,
  OrderDate,
  YEAR(OrderDate) AS OrderYear,
  MONTH(OrderDate) AS OrderMonth,
  MONTHNAME(OrderDate) AS MonthName
FROM Orders
ORDER BY OrderDate;

-- =========================================================
-- 8. Days between order date and current date
-- =========================================================
SELECT
  OrderID,
  OrderDate,
  CURRENT_DATE AS Today,
  DATEDIFF(CURRENT_DATE, OrderDate) AS DaysSinceOrder
FROM Orders
ORDER BY DaysSinceOrder DESC;

-- =========================================================
-- 9. Format OrderDate as DD-Mon-YYYY
-- =========================================================
SELECT
  OrderID,
  OrderDate,
  DATE_FORMAT(OrderDate, '%d-%b-%Y') AS FormattedDate
FROM Orders
ORDER BY OrderDate;

-- =========================================================
-- 10. Concatenate FirstName + LastName
-- =========================================================
SELECT
  CustomerID,
  FirstName,
  LastName,
  CONCAT(FirstName, ' ', LastName) AS FullName
FROM Customers
ORDER BY CustomerID;

-- =========================================================
-- 11. Replace 'John' with 'Jonathan'
-- =========================================================
SELECT
  CustomerID,
  FirstName AS OriginalFirstName,
  REPLACE(FirstName, 'John', 'Jonathan') AS UpdatedFirstName,
  LastName
FROM Customers
ORDER BY CustomerID;

-- =========================================================
-- 12. Upper FirstName, lower LastName
-- =========================================================
SELECT
  CustomerID,
  UPPER(FirstName) AS FirstNameUpper,
  LOWER(LastName) AS LastNameLower
FROM Customers
ORDER BY CustomerID;

-- =========================================================
-- 13. Trim Email
-- =========================================================
SELECT
  CustomerID,
  Email AS OriginalEmail,
  TRIM(Email) AS TrimmedEmail,
  LENGTH(Email) AS OriginalLength,
  LENGTH(TRIM(Email)) AS TrimmedLength
FROM Customers
ORDER BY CustomerID;

-- =========================================================
-- 14. Running total of TotalAmount (MySQL 8+ window)
-- =========================================================
SELECT
  OrderID,
  OrderDate,
  TotalAmount,
  SUM(TotalAmount) OVER (ORDER BY OrderDate, OrderID) AS RunningTotal
FROM Orders
ORDER BY OrderDate, OrderID;

-- =========================================================
-- 15. RANK() by TotalAmount (MySQL 8+)
-- =========================================================
SELECT
  OrderID,
  CustomerID,
  TotalAmount,
  RANK() OVER (ORDER BY TotalAmount DESC) AS AmountRank
FROM Orders
ORDER BY AmountRank, OrderID;

-- =========================================================
-- 16. CASE — discount by TotalAmount
-- =========================================================
SELECT
  OrderID,
  TotalAmount,
  CASE
    WHEN TotalAmount > 1000 THEN '10% off'
    WHEN TotalAmount > 500 THEN '5% off'
    ELSE 'No discount'
  END AS DiscountLabel,
  CASE
    WHEN TotalAmount > 1000 THEN ROUND(TotalAmount * 0.10, 2)
    WHEN TotalAmount > 500 THEN ROUND(TotalAmount * 0.05, 2)
    ELSE 0
  END AS DiscountAmount,
  CASE
    WHEN TotalAmount > 1000 THEN ROUND(TotalAmount * 0.90, 2)
    WHEN TotalAmount > 500 THEN ROUND(TotalAmount * 0.95, 2)
    ELSE TotalAmount
  END AS NetAmount
FROM Orders
ORDER BY TotalAmount DESC;

-- =========================================================
-- 17. CASE — salary band
-- =========================================================
SELECT
  EmployeeID,
  FirstName,
  LastName,
  Department,
  Salary,
  CASE
    WHEN Salary >= 75000 THEN 'High'
    WHEN Salary >= 50000 THEN 'Medium'
    ELSE 'Low'
  END AS SalaryBand
FROM Employees
ORDER BY Salary DESC;
