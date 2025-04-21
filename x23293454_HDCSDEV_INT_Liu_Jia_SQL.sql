-- Part2 Q1-- 
CREATE DATABASE JewelryShopDB;
USE JewelryShopDB;
-- part2 Q2 -- 
CREATE TABLE Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Address VARCHAR(255)
);

CREATE TABLE Product (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL,
    Category VARCHAR(50)
);
CREATE TABLE Warehouse (
    WarehouseID INT AUTO_INCREMENT PRIMARY KEY,
    Location VARCHAR(100) NOT NULL,
    Capacity INT NOT NULL
);
CREATE TABLE ProductWarehouse (
    ProductID INT NOT NULL,
    WarehouseID INT NOT NULL,
    Stock INT NOT NULL,
    PRIMARY KEY (ProductID, WarehouseID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouse(WarehouseID)
);
CREATE TABLE `Order` (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
CREATE TABLE OrderDetails (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);
CREATE TABLE Payment (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentDate DATE NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES `Order`(OrderID)
);

-- Part2 Q3 -- 
INSERT INTO Customer (Name, Email, Address)
VALUES
('Alice Johnson', 'alice.johnson@example.com', '123 Main St'),
('Bob Smith', 'bob.smith@example.com', '456 Elm St'),
('Cathy Brown', 'cathy.brown@example.com', '789 Oak St');

INSERT INTO Product (Name, Price, Stock, Category)
VALUES
('Gold Necklace', 199.99, 50, 'Necklace'),
('Silver Bracelet', 99.99, 100, 'Bracelet'),
('Diamond Ring', 499.99, 20, 'Ring');

INSERT INTO Warehouse (Location, Capacity)
VALUES
('Dublin', 1000),
('Cork', 800),
('Galway', 500);

-- Part3 Q1 -- 
SET SQL_SAFE_UPDATES = 0;
ALTER TABLE Product
MODIFY COLUMN Price DECIMAL(10,2);
UPDATE Product
SET Price = Price * 1.05;
-- Part3 Q2 --
ALTER TABLE Product
DROP COLUMN Stock;

-- Part3 03--
SELECT COUNT(*) AS TotalTransactions, ProductID, SUM(Quantity) AS TotalSold
FROM OrderDetails
GROUP BY ProductID
ORDER BY TotalSold DESC
LIMIT 1;

SELECT CustomerID, COUNT(OrderID) AS TotalPurchases
FROM `Order`
GROUP BY CustomerID
ORDER BY TotalPurchases DESC
LIMIT 1;

-- part3 Q4 --
SELECT MONTH(OrderDate) AS OrderMonth, SUM(TotalAmount) AS MonthlySales
FROM `Order`
GROUP BY OrderMonth
ORDER BY MonthlySales DESC;

-- part3 Q5 -- 
SELECT *
FROM Customer
WHERE Address LIKE '% Junction%';

SELECT *
FROM Customer
WHERE Name LIKE '%John%';

-- Part3 Q6 -- 
SELECT o.OrderID, c.Name AS CustomerName, p.Name AS ProductName, od.Quantity
FROM OrderDetails od
JOIN `Order` o ON od.OrderID = o.OrderID
JOIN Customer c ON o.CustomerID = c.CustomerID
JOIN Product p ON od.ProductID = p.ProductID;

-- Part3 Q7 --
CREATE VIEW MostFrequentTransactions AS
SELECT ProductID, SUM(Quantity) AS TotalSold
FROM OrderDetails
GROUP BY ProductID
ORDER BY TotalSold DESC
LIMIT 7;

-- Part3 Q8 -- 
-- Part3 Q8 Shows the total number of transactions with corresponding details every month -- 
SELECT 
    MONTH(OrderDate) AS OrderMonth,
    COUNT(OrderID) AS TotalTransactions,
    SUM(TotalAmount) AS TotalSales
FROM `Order`
GROUP BY OrderMonth
ORDER BY OrderMonth;

-- Part3 Q8 Shows customer purchase value per month --
SELECT 
    CustomerID,
    MONTH(OrderDate) AS OrderMonth,
    SUM(TotalAmount) AS TotalPurchase
FROM `Order`
GROUP BY CustomerID, OrderMonth
ORDER BY CustomerID, OrderMonth;

-- Part3 Q8 Shows name of product and number sold each month -- 
SELECT 
    MONTH(o.OrderDate) AS OrderMonth,
    p.Name AS ProductName,
    SUM(od.Quantity) AS TotalSold
FROM OrderDetails od
JOIN `Order` o ON od.OrderID = o.OrderID
JOIN Product p ON od.ProductID = p.ProductID
GROUP BY OrderMonth, ProductName
ORDER BY OrderMonth, TotalSold DESC;



