--Бдз 2, практическая часть, выполнили Захар Пылайкин И Андрей Гаврилов
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

--пункт 2 --предполагается, что последний месяц - последний месяц, по которому есть записи в базе данных
SELECT Section, 
CAST(SUM(Qty_ord * Price_RUR) as float) / 
(
	SELECT COUNT(DISTINCT Date_of_Order) FROM Orders 
	WHERE
	Year(Date_of_Order) = (SELECT DISTINCT Year(MAX(Date_of_Order)) FROM Orders) 
	AND 
	MONTH(Date_of_order) = (SELECT DISTINCT MONTH(MAX(Date_of_Order)) FROM Orders)
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
	Year(Date_of_Order) = (SELECT DISTINCT Year(MAX(Date_of_Order)) FROM Orders) 
	AND 
	MONTH(Date_of_order) = (SELECT DISTINCT MONTH(MAX(Date_of_Order)) FROM Orders)
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
		Year(Date_of_Order) = (SELECT DISTINCT Year(MAX(Date_of_Order)) FROM Orders) 
		AND 
		MONTH(Date_of_order) = (SELECT DISTINCT MONTH(MAX(Date_of_Order)) FROM Orders)
	) t2
	ON t1.Book_ID = t2.Book_ID
	WHERE 
	Year(Date_of_Order) = (SELECT DISTINCT Year(MAX(Date_of_Order)) FROM Orders) 
	AND 
	MONTH(Date_of_order) = (SELECT DISTINCT MONTH(MAX(Date_of_Order)) FROM Orders)
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
		Year(Date_of_Order) = (SELECT DISTINCT Year(MAX(Date_of_Order)) FROM Orders) 
		AND 
		MONTH(Date_of_order) = (SELECT DISTINCT MONTH(MAX(Date_of_Order)) FROM Orders)
	) t2
	ON t1.Book_ID = t2.Book_ID
	WHERE 
	Year(Date_of_Order) = (SELECT DISTINCT Year(MAX(Date_of_Order)) FROM Orders) 
	AND 
	MONTH(Date_of_order) = (SELECT DISTINCT MONTH(MAX(Date_of_Order)) FROM Orders)
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
		Year(Date_of_Order) = (SELECT DISTINCT Year(MAX(Date_of_Order)) FROM Orders) 
		AND 
		MONTH(Date_of_order) = (SELECT DISTINCT MONTH(MAX(Date_of_Order)) FROM Orders)
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
	t4.Date_of_Order > '01.10.2019'
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
		WHERE t2.Date_of_Order < '01.10.19'
	) t2
	ON t1.Cust_ID = t2.Cust_ID
) t1
INNER JOIN
Stock t2
ON t1.Book_ID = t2.Book_ID
WHERE
t2.Qty_in_Stock > 0
AND 
t1.Cust_ID != ALL(SELECT Cust_ID FROM Orders WHERE Date_of_Order > '01.10.2019')
--

--пункт 7 --некоторые книги, зарезервированные в Orders_data, не зарезервированы в Stock, так и должно быть?
SELECT Book, cast(Qty_rsrv as float) / ISNULL(NULLIF(Qty_in_Stock, 0), 1) as 'Доля в штуках', reserved_price / ISNULL(NULLIF(Qty_in_Stock * Price_RUR, 0), 1) as 'Доля в стоимости'
FROM
Stock t1
INNER JOIN
(
	SELECT t1.Book_ID, sum(t2.Qty_ord * t2.Price_RUR) * (SUM(Qty_ord) - SUM(Qty_out)) / SUM(Qty_ord) as reserved_price, t1.Book, t1.Price_RUR
	FROM 
	Books t1
	LEFT JOIN 
	Orders_data t2
	On t1.Book_ID = t2.Book_Id
	WHERE Qty_out = 0 
	GROUP BY t1.Book_ID, t1.Book, t1.Price_RUR
	--HAVING Qty_ord != Qty_out
) t2
ON t1.Book_ID = t2.Book_ID
--
