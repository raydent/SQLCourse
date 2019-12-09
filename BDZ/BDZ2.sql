--Бдз 2, практическая часть
USE BookStore
Go

--пункт 1
SELECT Book,
Sum(t3.Price_RUR * t3.Qty_ord) as 'Цена заказанного',
SUM(CASE WHEN t3.Pmnt_RUR = t3.Sum_RUR THEN t3.Price_RUR * t3.Qty_ord END) as 'Цена купленного',
Sum(t3.Price_RUR * t3.Qty_out) as 'Цена отгруженного',
Sum(Month(Date_of_order)) / Count(Date_of_order) as 'Месяц'
FROM
(
	SELECT 
	t2.Book_ID, t2.Price_RUR, t2.Qty_ord, t2.Qty_out, t1.Pmnt_RUR, t1.Sum_RUR, t1.Date_of_Order FROM
	Orders t1 
		INNER JOIN
	Orders_data t2
	ON t1.ndoc = t2.ndoc
	WHERE YEAR(Date_of_Order) = 2019
) t3
	INNER JOIN
Books t4
ON t3.Book_ID = t4.Book_ID
GROUP BY t4.Book, Month(Date_of_order)
ORDER BY t4.Book
--

--пункт 2
SELECT Section, 
CAST(SUM(Qty_ord * Price_RUR) as float) / 
(
	SELECT COUNT(DISTINCT Date_of_Order) FROM Orders 
	WHERE
	DATEDIFF(MONTH, Date_of_Order, GETDATE()) <= 1
) as 'Средняя стоимость заказанного в день'
FROM
(
	SELECT t1.Book_ID, t2.Section, t2.Section_ID
	FROM
	Books t1
		INNER JOIN
	Sections t2
	ON t1.Section_ID = t2.Section_ID
) t1
	INNER JOIN
(
	SELECT t1.Date_of_Order, t2.Qty_ord, t2.Price_RUR, t2.Book_ID
	FROM 
	Orders t1
		INNER JOIN
	Orders_data t2
	ON t1.ndoc = t2.ndoc
	WHERE 
	DATEDIFF(MONTH, Date_of_Order, GETDATE()) <= 1
) t2
ON t1.Book_ID = t2.Book_ID
GROUP BY t1.Section
--

--пункт 3
SELECT t1.Name, t1.Surname, COUNT(*) as 'Рейтинг'
FROM
(
	SELECT t1.Name, t1.Surname, SUM(t2.Price_RUR * t2.Qty_ord) as sum_paid FROM
	(
		SELECT t1.Author_ID, t1.Book_ID, t2.Name, t2.Surname 
		FROM
		Books t1
		INNER JOIN
		Authors t2
		ON
		t1.Author_ID = t2.Author_ID
	) t1
	INNER JOIN
	(
		SELECT t1.Date_of_Order, t2.Qty_ord, t2.Price_RUR, t2.Book_ID
		FROM 
		Orders t1
			INNER JOIN
		Orders_data t2
		ON t1.ndoc = t2.ndoc
		WHERE 
		DATEDIFF(MONTH, Date_of_Order, GETDATE()) <= 1
	) t2
	ON t1.Book_ID = t2.Book_ID
	WHERE 
	DATEDIFF(MONTH, Date_of_Order, GETDATE()) <= 1
	GROUP BY t1.Name, t1.Surname
) as t1
INNER JOIN
(
	SELECT t1.Name, t1.Surname, SUM(t2.Price_RUR * t2.Qty_ord) as sum_paid FROM
	(
		SELECT t1.Author_ID, t1.Book_ID, t2.Name, t2.Surname 
		FROM
		Books t1
		INNER JOIN
		Authors t2
		ON
		t1.Author_ID = t2.Author_ID
	) t1
	INNER JOIN
	(
		SELECT t1.Date_of_Order, t2.Qty_ord, t2.Price_RUR, t2.Book_ID
		FROM 
		Orders t1
			INNER JOIN
		Orders_data t2
		ON t1.ndoc = t2.ndoc
		WHERE 
		DATEDIFF(MONTH, Date_of_Order, GETDATE()) <= 1
	) t2
	ON t1.Book_ID = t2.Book_ID
	WHERE 
	DATEDIFF(MONTH, Date_of_Order, GETDATE()) <= 1
	GROUP BY t1.Name, t1.Surname
) as t2
ON t1.sum_paid <= t2.sum_paid
GROUP BY t1.Name, t1.Surname
ORDER BY COUNT(*)
--

--пункт 4
SELECT Customer, SUM(ISNULL(Pmnt_RUR, 0)) as 'Сумма'
FROM
CUSTOMERS t1
LEFT JOIN
(
		SELECT t1.Date_of_Order, t2.Qty_ord, t2.Price_RUR, t2.Book_ID, t1.Cust_ID, t1.Pmnt_RUR
		FROM 
		Orders t1
			INNER JOIN
		Orders_data t2
		ON t1.ndoc = t2.ndoc
		WHERE 
		DATEDIFF(MONTH, Date_of_Order, GETDATE()) <= 1
) t2
ON t1.Cust_ID = t2.Cust_ID
GROUP BY t1.Customer
--

--пункт 5
SELECT Book
FROM
Books t1
INNER JOIN
Stock t2
ON t1.Book_ID = t2.Book_ID
WHERE 
NOT EXISTS
(
	SELECT* FROM 
	Orders_data t3
	INNER JOIN
	Orders t4
	ON t3.ndoc = t4.ndoc
	WHERE 
	t3.Book_ID = t1.Book_ID 
	AND
	t4.Date_of_Order > '2019.10.01'
) 
AND t2.Qty_in_Stock != 0
--

--пункт 6
SELECT t1.Customer, t1.Book_ID
FROM
(
	SELECT t1.Cust_ID, t1.Customer, t2.Book_ID, t2.ndoc
	FROM
	Customers t1
	INNER JOIN
	(
		SELECT t1.ndoc, t2.Cust_ID, t1.Book_ID
		FROM
		Orders_data t1
		INNER JOIN
		Orders t2
		ON t1.ndoc = t2.ndoc
		WHERE t2.Date_of_Order < '2019.10.01'
	) t2
	ON t1.Cust_ID = t2.Cust_ID
) t1
INNER JOIN
Stock t2
ON t1.Book_ID = t2.Book_ID
WHERE
t2.Qty_in_Stock > 0
AND 
t1.Cust_ID != ALL(SELECT Cust_ID FROM Orders WHERE Date_of_Order > '2019.10.01')
--

--пункт 7 
SELECT CAST(SUM(Qty_rsrv) as float) / ISNULL(NULLIF(SUM(Qty_in_Stock), 0), 1) as 'Доля в штуках', CAST(SUM(Qty_rsrv * Price_RUR) as float) / ISNULL(NULLIF(SUM(Qty_in_Stock * Price_RUR), 0), 1) as 'Доля в штуках'
FROM 
STOCK t1
INNER JOIN
Books t2
ON t1.Book_ID = t2.Book_ID
--

--пункт 8
SELECT Customer, t1.Sum_RUR, (CASE WHEN t1.Pmnt_RUR != t1.Sum_RUR THEN 'Забрал, не оплатил' ELSE 'Оплатил, не забрал' END) as 'Статус' 
FROM
(	
	SELECT t1.Cust_ID, t2.Customer, t1.Pmnt_RUR, t1.Sum_RUR, t1.ndoc
	FROM
	Orders t1
	INNER JOIN
	Customers t2
	ON t1.Cust_ID = t2.Cust_ID
) t1
Inner join
Orders_data t2
ON t1.ndoc = t2.ndoc
WHERE (t1.Pmnt_RUR = 0 AND t2.Qty_out = t2.Qty_ord) OR (t1.Pmnt_RUR = t1.Sum_RUR AND t2.Qty_out = 0)
GROUP BY t1.Customer, t1.Cust_ID, t1.Pmnt_RUR, t1.Sum_RUR
--

--пункт 9
DECLARE @BOOK_ID int, @Qty int, @Cust_id int
SET @BOOK_ID = 3 
SET @Qty = 100000
SET @Cust_id = 1
IF (SELECT TOP 1 Qty_in_Stock from Stock WHERE Book_ID = @BOOK_ID) >= @Qty 
AND
(SELECT TOP 1 BALANCE FROM Customers WHERE Cust_ID = @Cust_id) >= (SELECT @Qty * Price_RUR FROM Books WHERE Book_ID = @BOOK_ID) 
	SELECT 1
ELSE
	SELECT 0
--

--пункт 10
Declare @ndoc int
set @ndoc = 1337
UPDATE Orders
SET Orders.Sum_RUR = (SELECT TOP 1 SUM(Qty_ord * Price_RUR) FROM Orders_data WHERE ndoc = @ndoc GROUP BY ndoc)
WHERE ndoc = @ndoc
--

--пункт 11
DECLARE @ndoc int
SET @ndoc = 14321992
IF EXISTS(SELECT Balance, Sum_RUR FROM Orders t1 INNER JOIN Customers t2 ON t1.Cust_ID = t2.Cust_ID WHERE ndoc = @ndoc AND Balance >= Sum_RUR)
	SELECT 1
ELSE
	SELECT 0
--

--пункт 12
DECLARE @ndoc int
SET @ndoc = 1337
IF EXISTS(SELECT Balance, Sum_RUR FROM Orders t1 INNER JOIN Customers t2 ON t1.Cust_ID = t2.Cust_ID WHERE ndoc = @ndoc AND Balance >= Sum_RUR AND Pmnt_RUR != Sum_RUR)
BEGIN
	UPDATE Orders
	SET Pmnt_RUR = SUM_RUR
	WHERE ndoc = @ndoc
	UPDATE Customers
	SET Balance = Balance - (SELECT Pmnt_RUR from Orders WHERE ndoc = @ndoc)
	WHERE Cust_ID = (SELECT TOP 1 t1.Cust_ID from Orders t1 INNER JOIN Customers t2 on t1.Cust_ID = t2.Cust_ID WHERE ndoc = @ndoc)
END
--

--пункт 13
DECLARE @ndoc int
SET @ndoc = 1338
UPDATE Stock
SET Qty_rsrv = Qty_rsrv + t2.summ
FROM Stock INNER JOIN
(
    SELECT ndoc, Book_ID, SUM(Qty_ord) as summ
    FROM Orders_data
    GROUP BY Book_ID, ndoc
) t2 ON Stock.Book_ID = t2.Book_ID
WHERE ndoc = @ndoc
--


--пункт 14
DECLARE @ndoc int
SET @ndoc = 1338
UPDATE Stock
SET Qty_in_Stock = Qty_in_Stock - t2.summ, Qty_rsrv = Qty_rsrv - t2.summ
FROM Stock INNER JOIN
(
    SELECT ndoc, Book_ID, SUM(Qty_out) as summ
    FROM Orders_data
    GROUP BY Book_ID, ndoc
) t2 ON Stock.Book_ID = t2.Book_ID
WHERE ndoc = @ndoc AND Qty_in_Stock >= t2.summ AND Qty_rsrv >= t2.summ
--

--пункт 15
UPDATE Stock
SET Qty_rsrv = Qty_rsrv - t2.summ
FROM Stock INNER JOIN
(
	SELECT t1.ndoc, t1.summ, t1.Book_ID, t2.Pmnt_RUR, t2.Date_of_Order
	FROM
	(
		SELECT ndoc, Book_ID, SUM(Qty_ord - Qty_out) as summ
		FROM Orders_data
		GROUP BY Book_ID, ndoc
	) t1
	INNER JOIN
	Orders t2
	ON t1.ndoc = t2.ndoc
) t2 ON Stock.Book_ID = t2.Book_ID
WHERE Pmnt_RUR = 0 AND DATEDIFF(day, Date_Of_order, GETDATE()) = 1 AND summ != 0
UPDATE Orders_data
SET Qty_ord = 0
FROM Orders_data t1 INNER JOIN
(
	SELECT ndoc, Date_of_Order, Pmnt_RUR
	FROM Orders
) t2
ON t1.ndoc = t2.ndoc 
WHERE Pmnt_RUR = 0 AND DATEDIFF(day, Date_Of_order, GETDATE()) = 1 AND Qty_ord != Qty_out
--
