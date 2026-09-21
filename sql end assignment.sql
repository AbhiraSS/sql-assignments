use ecomm;
select * from customer_churn limit 10;

-- data cleaning

SELECT
     round(AVG(WarehouseToHome)) AS avg_waretohome,
     round(AVG(HourSpendOnApp)) AS avg_hrspend,
     round(AVG(OrderAmountHikeFromlastYear)) AS avg_oredramount_hike,
     round(AVG(DaySinceLastOrder)) AS avg_daysince_lastorder
FROM customer_churn;

SET SQL_SAFE_UPDATES = 0;

UPDATE customer_churn
SET WarehouseToHome = 16
WHERE WarehouseToHome IS NULL;

UPDATE customer_churn
SET HourSpendOnApp = 3
WHERE HourSpendOnApp IS NULL;

UPDATE customer_churn
SET OrderAmountHikeFromlastYear = 16
WHERE OrderAmountHikeFromlastYear IS NULL;

UPDATE customer_churn
SET DaySinceLastOrder = 5
WHERE DaySinceLastOrder IS NULL;

SELECT Tenure, COUNT(*) AS Frequency FROM customer_churn WHERE Tenure IS NOT NULL GROUP BY Tenure
ORDER BY Frequency DESC LIMIT 1;

SELECT CouponUsed, COUNT(*) AS Frequency FROM customer_churn WHERE CouponUsed IS NOT NULL GROUP BY CouponUsed
ORDER BY Frequency DESC LIMIT 1;

SELECT OrderCount, COUNT(*) AS Frequency FROM customer_churn WHERE OrderCount IS NOT NULL GROUP BY OrderCount
ORDER BY Frequency DESC LIMIT 1;

UPDATE customer_churn
SET Tenure = 1
WHERE Tenure IS NULL;

UPDATE customer_churn
SET CouponUsed = 1
WHERE CouponUsed IS NULL;

UPDATE customer_churn
SET OrderCount = 2
WHERE OrderCount IS NULL;

DELETE FROM customer_churn WHERE WarehouseToHome > 100;

update customer_churn set preferredlogindevice='Mobile Phone' where preferredlogindevice='Phone';
update customer_churn set preferedordercat='Mobile Phone' where preferedordercat='Mobile';

update customer_churn set preferredpaymentmode='Cash on Delivery' where preferredpaymentmode='COD';
update customer_churn set preferredpaymentmode='Credit Card' where preferredpaymentmode='CC';

-- DATA TRANSFORMATION

select * from customer_churn limit 10;

alter table customer_churn rename column preferedordercat to PreferredOrderCat;
alter table customer_churn rename column HourSpendOnApp to HoursSpentOnApp;

ALTER TABLE customer_churn ADD ComplaintReceived VARCHAR(10);
UPDATE customer_churn SET ComplaintReceived = CASE WHEN Complain = 1 THEN 'Yes' ELSE 'No' END;

ALTER TABLE customer_churn ADD ChurnStatus VARCHAR(10);
UPDATE customer_churn SET ChurnStatus = CASE WHEN Churn = 1 THEN 'Churned' ELSE 'Active' END;

ALTER TABLE customer_churn DROP COLUMN Churn, DROP COLUMN Complain;

-- data exploration and analysis

select * from customer_churn limit 10;

SELECT ChurnStatus, COUNT(*) AS CustomerCount FROM customer_churn GROUP BY ChurnStatus;

SELECT avg(Tenure) as Average_Tenure, SUM(CashbackAmount) as Total_Cashback FROM customer_churn WHERE
ChurnStatus = 'Churned';
 
SELECT COUNT(CASE WHEN ComplaintReceived = 'Yes' THEN 1 END) * 100.0 / COUNT(*) as Complaint_Percentage FROM customer_churn
WHERE ChurnStatus = 'Churned';

SELECT CityTier, COUNT(*) AS CustomerCount FROM customer_churn WHERE ChurnStatus = 'Churned' and
PreferredOrderCat = 'Laptop & Accessory' GROUP BY CityTier  ORDER BY CustomerCount DESC LIMIT 1;
 
SELECT PreferredPaymentMode, COUNT(*) AS CustomerCount FROM customer_churn WHERE ChurnStatus = 'Active'
GROUP BY PreferredPaymentMode ORDER BY CustomerCount DESC LIMIT 1;
 
SELECT SUM(OrderAmountHikeFromlastYear) as Total_OrderAmountHike FROM customer_churn
WHERE MaritalStatus = 'Single' AND PreferredOrderCat = 'Mobile Phone';

SELECT AVG(NumberOfDeviceRegistered) AS Average_Devices FROM customer_churn
WHERE PreferredPaymentMode = 'UPI';

SELECT CityTier, COUNT(*) AS CustomerCount FROM customer_churn GROUP BY CityTier
ORDER BY CustomerCount DESC LIMIT 1;

SELECT Gender, SUM(CouponUsed) AS Total_Coupons FROM customer_churn
GROUP BY Gender ORDER BY Total_Coupons DESC LIMIT 1;

SELECT PreferredOrderCat, COUNT(*) AS CustomerCount, MAX(HoursSpentOnApp) AS Max_HoursSpent
FROM customer_churn GROUP BY PreferredOrderCat;

SELECT SUM(OrderCount) AS Total_OrderCount FROM customer_churn WHERE PreferredPaymentMode = 'Credit Card'
AND SatisfactionScore = (SELECT MAX(SatisfactionScore) FROM customer_churn);

SELECT AVG(SatisfactionScore) AS Average_SatisfactionScore FROM customer_churn WHERE ComplaintReceived = 'Yes';

SELECT PreferredOrderCat, COUNT(*) AS CustomerCount FROM customer_churn WHERE CouponUsed > 5
GROUP BY PreferredOrderCat ORDER BY CustomerCount DESC LIMIT 1;

SELECT PreferredOrderCat, AVG(CashbackAmount) AS Average_Cashback FROM customer_churn
GROUP BY PreferredOrderCat ORDER BY Average_Cashback DESC LIMIT 3;

SELECT PreferredPaymentMode FROM customer_churn WHERE OrderCount > 500 GROUP BY PreferredPaymentMode
HAVING AVG(Tenure) = 10;

SELECT CASE
        WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance' END AS DistanceCategory, ChurnStatus, COUNT(*) AS CustomerCount 
FROM customer_churn GROUP BY DistanceCategory, ChurnStatus ORDER BY DistanceCategory, ChurnStatus;

SELECT * FROM customer_churn WHERE MaritalStatus = 'Married' AND CityTier = 1 AND 
OrderCount > ( SELECT AVG(OrderCount) FROM customer_churn);


CREATE TABLE customer_returns (
    ReturnID INT,
    CustomerID INT,
    ReturnDate DATE,
    RefundAmount INT
);

INSERT INTO customer_returns
(ReturnID, CustomerID, ReturnDate, RefundAmount) VALUES
(1001, 50022, '2023-01-01', 2130),
(1002, 50316, '2023-01-23', 2000),
(1003, 51099, '2023-02-14', 2290),
(1004, 52321, '2023-03-08', 2510),
(1005, 52928, '2023-03-20', 3000),
(1006, 53749, '2023-04-17', 1740),
(1007, 54206, '2023-04-21', 3250),
(1008, 54838, '2023-04-30', 1990);

SELECT * from customer_returns;

SELECT * FROM customer_returns r JOIN customer_churn c
ON r.CustomerID = c.CustomerID WHERE c.ChurnStatus = 'Churned'
AND c.ComplaintReceived = 'Yes';

