USE MDZ3 -- если заменили имя базы при создании, то здесь тоже замените
GO


--пункт 1
DECLARE @volume INT
SET @volume = 500
SELECT Good
FROM Goods
WHERE QtyInStock*Volume > @volume
--

--пункт 2
SELECT CASE WHEN COUNT(DISTINCT Cust_id) < 5 THEN City END
FROM Customers
GROUP BY City
--

--пункт 3
DECLARE @customer nvarchar(50)
SET @customer = 'ООО Технологии'
SELECT City, DocNum, Good, Qty, T2.Price
FROM 
(SELECT T1.City, T1.Cust_id, T1.Customer, T1.Data, T1.DocNum, T1.Total, DD.Good_id, DD.Price, DD.Qty FROM ((SELECT C.Cust_id, D.DocNum, D.Data, D.Total, C.City, C.Customer FROM (Customers C INNER JOIN Docs D ON C.Cust_id = D.Cust_ID)) AS T1 INNER JOIN Docs_Data DD
ON T1.DocNum = DD.DocNum)) AS T2 INNER JOIN Goods G
ON T2.Good_id = G.Good_id
WHERE Customer = @customer
--

--пункт 4
SELECT distinct Good
FROM 
(SELECT D.DocNum, D.Data, DD.Good_id FROM (DOCS D INNER JOIN Docs_data DD
ON D.DocNum = DD.DocNum)) AS T1 INNER JOIN GOODS AS T2
ON T1.Good_id = T2.Good_id
WHERE MONTH(Data) = 10 AND YEAR(DATA) = 2018
--

--пункт 5
DECLARE @good nvarchar(50)
set @good = 'Мышка A4Tech 5 кнопок красная'
SELECT distinct City
FROM 
(SELECT T1.City, T1.Cust_id, T1.Customer, T1.Data, T1.DocNum, T1.Total, DD.Good_id, DD.Price, DD.Qty FROM ((SELECT C.Cust_id, D.DocNum, D.Data, D.Total, C.City, C.Customer FROM (Customers C INNER JOIN Docs D ON C.Cust_id = D.Cust_ID)) AS T1 INNER JOIN Docs_Data DD
ON T1.DocNum = DD.DocNum)) AS T2 INNER JOIN Goods G
ON T2.Good_id = G.Good_id
WHERE Good = @good
--

--пункт 6
DECLARE @max INT
SET @max = 0

SELECT @max = MAX(T2.Price)
FROM 
(SELECT T1.City, T1.Cust_id, T1.Customer, T1.Data, T1.DocNum, T1.Total, DD.Good_id, DD.Price, DD.Qty FROM ((SELECT C.Cust_id, D.DocNum, D.Data, D.Total, C.City, C.Customer FROM (Customers C INNER JOIN Docs D ON C.Cust_id = D.Cust_ID)) AS T1 INNER JOIN Docs_Data DD
ON T1.DocNum = DD.DocNum)) AS T2 INNER JOIN Goods G
ON T2.Good_id = G.Good_id
WHERE MONTH(DATA) = 10 AND YEAR(DATA) = 2018

SELECT T2.Customer
FROM 
(SELECT T1.City, T1.Cust_id, T1.Customer, T1.Data, T1.DocNum, T1.Total, DD.Good_id, DD.Price, DD.Qty FROM ((SELECT C.Cust_id, D.DocNum, D.Data, D.Total, C.City, C.Customer FROM (Customers C INNER JOIN Docs D ON C.Cust_id = D.Cust_ID)) AS T1 INNER JOIN Docs_Data DD
ON T1.DocNum = DD.DocNum)) AS T2 INNER JOIN Goods G
ON T2.Good_id = G.Good_id
WHERE MONTH(DATA) = 10 AND YEAR(DATA) = 2018 AND T2.Price = @max
--

--пункт 7
SELECT SUM(Volume*Qty)
FROM 
(SELECT T1.City, T1.Cust_id, T1.Customer, T1.Data, T1.DocNum, T1.Total, DD.Good_id, DD.Price, DD.Qty FROM ((SELECT C.Cust_id, D.DocNum, D.Data, D.Total, C.City, C.Customer FROM (Customers C INNER JOIN Docs D ON C.Cust_id = D.Cust_ID)) AS T1 INNER JOIN Docs_Data DD
ON T1.DocNum = DD.DocNum)) AS T2 INNER JOIN Goods G
ON T2.Good_id = G.Good_id
WHERE MONTH(Data) = 10 AND YEAR(DATA) = 2018
--

--пункт 8
SELECT City
FROM 
(SELECT T1.City, T1.Cust_id, T1.Customer, T1.Data, T1.DocNum, T1.Total, DD.Good_id, DD.Price, DD.Qty FROM ((SELECT C.Cust_id, D.DocNum, D.Data, D.Total, C.City, C.Customer FROM (Customers C INNER JOIN Docs D ON C.Cust_id = D.Cust_ID)) AS T1 INNER JOIN Docs_Data DD
ON T1.DocNum = DD.DocNum)) AS T2 INNER JOIN Goods G
ON T2.Good_id = G.Good_id
GROUP BY City
HAVING COUNT(DocNum) = 
(SELECT TOP 1 (Count(DocNum))
FROM 
(SELECT T1.City, T1.Cust_id, T1.Customer, T1.Data, T1.DocNum, T1.Total, DD.Good_id, DD.Price, DD.Qty FROM ((SELECT C.Cust_id, D.DocNum, D.Data, D.Total, C.City, C.Customer FROM (Customers C INNER JOIN Docs D ON C.Cust_id = D.Cust_ID)) AS T1 INNER JOIN Docs_Data DD
ON T1.DocNum = DD.DocNum)) AS T2 INNER JOIN Goods G
ON T2.Good_id = G.Good_id GROUP BY City)
--

--пункт 9 -- 1 половина
SELECT Customer, SUM(Qty) as 'Общее кол-во', SUM(T2.Price * Qty) as 'Сумма затрат', Sum(Mass) as 'Общая масса', SUM(Volume * Qty) as 'Общий объем'
FROM 
(SELECT T1.City, T1.Cust_id, T1.Customer, T1.Data, T1.DocNum, T1.Total, DD.Good_id, DD.Price, DD.Qty FROM ((SELECT C.Cust_id, D.DocNum, D.Data, D.Total, C.City, C.Customer FROM (Customers C INNER JOIN Docs D ON C.Cust_id = D.Cust_ID)) AS T1 INNER JOIN Docs_Data DD
ON T1.DocNum = DD.DocNum)) AS T2 INNER JOIN Goods G
ON T2.Good_id = G.Good_id
GROUP BY Customer
--пункт 9 -- 2 половина
SELECT Customer, SUM(Qty) as 'Общее кол-во', SUM(Price * Qty) as 'Сумма затрат', Sum(Mass) as 'Общая масса', SUM(Volume * Qty) FROM
(SELECT T2.Customer, T2.Qty, T2.Price, G.Good, G.Mass, G.Volume 
FROM 
(SELECT T1.City, T1.Cust_id, T1.Customer, T1.Data, T1.DocNum, T1.Total, DD.Good_id, DD.Price, DD.Qty FROM ((SELECT C.Cust_id, D.DocNum, D.Data, D.Total, C.City, C.Customer FROM (Customers C INNER JOIN Docs D ON C.Cust_id = D.Cust_ID)) AS T1 INNER JOIN Docs_Data DD
ON T1.DocNum = DD.DocNum)) AS T2 INNER JOIN Goods G
ON T2.Good_id = G.Good_id
WHERE Good Like '%монитор%') AS Tlast
GROUP BY Customer
--

--пункт 10
SELECT DocNum
FROM 
(SELECT T1.City, T1.Cust_id, T1.Customer, T1.Data, T1.DocNum, T1.Total, DD.Good_id, DD.Price, DD.Qty FROM ((SELECT C.Cust_id, D.DocNum, D.Data, D.Total, C.City, C.Customer FROM (Customers C INNER JOIN Docs D ON C.Cust_id = D.Cust_ID)) AS T1 INNER JOIN Docs_Data DD
ON T1.DocNum = DD.DocNum)) AS T2 INNER JOIN Goods G
ON T2.Good_id = G.Good_id
GROUP BY DocNum
HAVING SUM(Total) / COUNT(TOTAL) !=  SUM(T2.Price * Qty)
--
