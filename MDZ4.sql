USE MDZ4
GO



--пункт 1
SELECT T1.Покупатель_id, Count(distinct ндок) as 'Кол-во документов'
FROM
Покупатели as T1 LEFT JOIN Документы as T2
ON T1.Покупатель_ID = T2.Покупатель_ID
GROUP BY T1.Покупатель_id
--

--пункт 2
SELECT T1.Товар_id
FROM
Товары as T1 LEFT JOIN Документы_данные as T2
ON T1.Товар_ID = T2.Товар_id
GROUP BY T1.Товар_ID
HAVING COUNT(T2.Ндок) = 0
--

--пункт 3
SELECT T4.Товар_ID
FROM 
Товары as T4
LEFT JOIN
(SELECT T1.Ндок, T1.Товар_id, T2.Покупатель_ID, T2.Фамилия
FROM
Документы_данные as T1
LEFT JOIN 
	(SELECT T1.Покупатель_ID, T1.Фамилия, T2.Ндок
	FROM 
	Покупатели as T1 
	INNER JOIN
	Документы as T2
	ON T1.Покупатель_ID = T2.Покупатель_ID
	WHERE T1.Фамилия = 'Иванов') as T2
ON T1.Ндок = T2.Ндок) as T3
ON T4.Товар_ID = T3.Товар_id
GROUP BY T4.Товар_ID
HAVING Count(Фамилия) = 0
--


--пункт 4
SELECT T6.Товар_ID, Фамилия
FROM
ТОВАРЫ AS T6
CROSS JOIN
(SELECT T4.Товар_ID, Фамилия
FROM 
Товары as T4
FULL JOIN
(SELECT T1.Ндок, T1.Товар_id, T2.Покупатель_ID, T2.Фамилия
FROM
Документы_данные as T1
RIGHT JOIN 
	(SELECT T1.Покупатель_ID, T1.Фамилия, T2.Ндок
	FROM 
	Покупатели as T1 
	LEFT JOIN
	Документы as T2
	ON T1.Покупатель_ID = T2.Покупатель_ID
	) as T2
ON T1.Ндок = T2.Ндок) as T3
ON T4.Товар_ID = T3.Товар_id
GROUP BY Фамилия, T4.Товар_ID
HAVING ISNULL(Фамилия, 'NULL_EXCEPTION_ERROR') != 'NULL_EXCEPTION_ERROR') AS T5
GROUP BY Фамилия, T6.Товар_ID
HAVING SUM(CASE WHEN T6.Товар_ID = T5.Товар_ID THEN 1 ELSE 0 END) = 0
--

--пункт 5
SELECT T6.Товар_ID, Фамилия
FROM
ТОВАРЫ AS T6
CROSS JOIN
(SELECT T4.Товар_ID, Фамилия, T3.Дата
FROM 
Товары as T4
FULL JOIN
(SELECT T1.Ндок, T1.Товар_id, T7.Покупатель_ID, T7.Фамилия, T7.Дата
FROM
Документы_данные as T1
RIGHT JOIN 
	(SELECT T1.Покупатель_ID, T1.Фамилия, T2.Ндок, T2.Дата
	FROM 
	Покупатели as T1 
	LEFT JOIN
	Документы as T2
	ON T1.Покупатель_ID = T2.Покупатель_ID
	) as T7
ON T1.Ндок = T7.Ндок) as T3
ON T4.Товар_ID = T3.Товар_id
WHERE ISNULL(Фамилия, 'NULL_EXCEPTION_ERROR') != 'NULL_EXCEPTION_ERROR') AS T5
GROUP BY Фамилия, T6.Товар_ID
HAVING SUM(CASE WHEN T6.Товар_ID = T5.Товар_ID AND Дата > '01.01.2019' THEN 1 ELSE 0 END) = 0
--

--пункт 6
SELECT T1.Покупатель_ID
FROM
Документы as T1
INNER JOIN
Документы_данные as T2
ON T1.ндок = T2.Ндок
GROUP BY Покупатель_ID
HAVING COUNT(distinct T2.Товар_id) >= 5
--

--пункт 7
SELECT T3.Покупатель_ID, T6.Покупатель_ID
FROM
(SELECT Sum(Колво) as sum1, Покупатель_ID
FROM
Документы as T1
INNER JOIN
Документы_данные as T2
ON T1.ндок = T2.Ндок
GROUP BY Покупатель_ID) AS T3
INNER JOIN
(SELECT Sum(Колво) as sum1, Покупатель_ID
FROM
Документы as T4
INNER JOIN
Документы_данные as T5
ON T4.ндок = T5.Ндок
GROUP BY Покупатель_ID) AS T6
ON T3.Покупатель_ID != T6.Покупатель_ID
WHERE T3.sum1 = T6.sum1 and T3.Покупатель_ID < T6.Покупатель_ID
ORDER BY T3.Покупатель_ID ASC, T6.Покупатель_ID ASC
--
