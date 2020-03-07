USE Карта
GO


--1 
SELECT T1.Название, T2.Название
FROM
(
	SELECT T1.Город_ID_2, T2.Название
	FROM
	(
		SELECT TOP 1 WITH TIES Город_ID_1, Город_ID_2
		FROM Маршруты
		ORDER BY Расстояние desc
	) T1
	INNER JOIN 
	Города T2
	ON T1.Город_ID_1 = T2.Город_ID
) T1
INNER JOIN
Города T2
ON T1.Город_ID_2 = T2.Город_ID
--

--2
SELECT Город_ID_1, Город_ID_2, Расстояние, Область_ID1
FROM
(
	SELECT Область_ID, min(Расстояние) as Мин_расстояние
	FROM
	(
		SELECT T1.Город_ID_1, T1.Город_ID_2, T1.Название as Название_1, T1.Область_ID as Область_1, T1.Расстояние, T2.Название as Название_2, T2.Область_ID as Область_2
		FROM
		(
			SELECT *
			FROM
			Маршруты T1
			INNER JOIN 
			Города T2
			ON T1.Город_ID_1 = T2.Город_ID
		) T1
		INNER JOIN 
		Города T2
		ON T1.Город_ID_2 = T2.Город_ID
	) T1
	INNER JOIN
	Области T2
	ON (T1.Область_1 = T2.Область_ID) AND (T1.Область_2 = T2.Область_ID)
	GROUP BY Область_ID
) T1
INNER JOIN 
(
	SELECT *
	FROM
	(
		SELECT T1.Город_ID_1, T1.Город_ID_2, T1.Область_ID as Область_ID1, T1.Расстояние, T2.Область_ID as Область_ID2
		FROM
		(
			SELECT*
			FROM
			Города T1
			INNER JOIN
			Маршруты T2
			ON T1.Город_ID = T2.Город_ID_2
		) T1
		INNER JOIN
		Города T2
		ON T1.Город_ID_1 = T2.Город_ID
	) T1
	INNER JOIN
	Области T2
	ON T1.Область_ID1 = T2.Область_ID AND T1.Область_ID2 = T2.Область_ID
) T2
ON T1.Область_ID = T2.Область_ID AND T1.Мин_расстояние = T2.Расстояние
--

--3
SELECT T1.Город_ID as Город_ID1, T2.Город_ID as Город_ID2
FROM
Города T1
INNER JOIN
Города T2
ON T1.Город_ID < T2.Город_ID
EXCEPT
SELECT Город_ID_1, Город_ID_2
FROM
Маршруты
--

--4
SELECT Город_ID 
FROM
Города
EXCEPT
SELECT Город_ID_2
FROM
Маршруты
--

--5
SELECT Город_ID 
FROM
Города
EXCEPT
SELECT Город_ID_1
FROM
Маршруты
--



--6
DECLARE @city int, @turn int
SET @city = 17
SET @turn = 3

DECLARE @FT TABLE (city1 int, city2 int)
INSERT INTO @FT
SELECT Город_ID_1, Город_ID_2
FROM
Маршруты
WHERE Город_ID_1 = @city OR Город_ID_2 = @city

WHILE @turn > 0
BEGIN
	INSERT INTO @FT
	SELECT T1.Город_ID_1, T1.Город_ID_2
	FROM 
	Маршруты T1
	INNER JOIN 
	@FT T2 
	ON T1.Город_ID_1 = T2.city2 OR T1.Город_ID_2 = T2.city1

	SET @turn = @turn - 1
END

SELECT distinct city1 
FROM @FT
WHERE city1 != @city
UNION
SELECT distinct city2
FROM @FT
WHERE city2 != @city
--

--7
SELECT T1.Город_ID_1, T1.Город_ID_2, T1.city as Город_ID, T1.d, T1.d1, T2.d2
FROM
(
	SELECT T1.Город_ID_1, T1.Город_ID_2, T2.Город_ID_1 as city, T1.Расстояние as d, T2.Расстояние as d1
	FROM 
	(
		SELECT Город_ID_1, Город_ID_2, Расстояние
		FROM
		Маршруты 
		UNION
		SELECT Город_ID_2, Город_ID_1, Расстояние
		FROM Маршруты
	) T1
	INNER JOIN
	(
		SELECT Город_ID_1, Город_ID_2, Расстояние
		FROM
		Маршруты 
		UNION
		SELECT Город_ID_2, Город_ID_1, Расстояние
		FROM Маршруты
	) T2
	ON T1.Город_ID_1 = T2.Город_ID_2
) T1
INNER JOIN
(
	SELECT T1.Город_ID_1, T1.Город_ID_2, T2.Город_ID_2 as city, T1.Расстояние as d, T2.Расстояние as d2
	FROM 
	(
		SELECT Город_ID_1, Город_ID_2, Расстояние
		FROM
		Маршруты 
		UNION
		SELECT Город_ID_2, Город_ID_1, Расстояние
		FROM Маршруты
	) T1
	INNER JOIN
	(
		SELECT Город_ID_1, Город_ID_2, Расстояние
		FROM
		Маршруты 
		UNION
		SELECT Город_ID_2, Город_ID_1, Расстояние
		FROM Маршруты
	) T2
	ON T1.Город_ID_2 = T2.Город_ID_1
) T2
ON T1.Город_ID_1 = T2.Город_ID_1 AND T1.Город_ID_1 < T1.Город_ID_2 AND T1.city = T2.city AND T1.Город_ID_2 = T2.Город_ID_2
WHERE d1 + d2 < T1.d
--






























