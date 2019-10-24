USE Продажи
GO

SELECT distinct CONVERT(date,Дата) AS Дата--пункт 2
FROM Продажи

SELECT distinct Покупатель--пункт 3
FROM Продажи
ORDER BY Покупатель


SELECT distinct Товар -- пункт 4
FROM ПРОДАЖИ
WHERE (Цена > 100)

SELECT distinct Покупатель
FROM Продажи
WHERE (CONVERT(int, GETDATE()) - CONVERT(int, Дата) < 7) -- пункт 5


SELECT  нДок, Дата, Покупатель, Товар, Колво, Цена, Цена*Колво As Стоимость --пункт 6
From Продажи


SELECT MONTH(GETDATE())

SELECT  нДок, Дата, Покупатель, Товар, Колво, Цена -- пункт 7
FROM Продажи
WHERE (Покупатель LIKE 'А%' AND MONTH(Дата) = 1 AND YEAR(Дата) = YEAR(GETDATE())) OR (Колво > 5 AND Цена < 10)
ORDER BY Дата ASC, Цена DESC

SELECT distinct TOP 5 Покупатель -- пункт 8
FROM ПРОДАЖИ
WHERE (MONTH(Дата) = 9 AND YEAR(GETDATE()) - YEAR(Дата) = 1)
ORDER BY Покупатель

DECLARE @param nvarchar(30) -- пункт 9
SET @param = 'Конф%'
SELECT distinct Покупатель 
FROM Продажи
Where (Товар LIKE @param)


SELECT нДок --пункт 10
FROM   Продажи
WHERE  Цена * Колво = (SELECT MAX(Цена * Колво) FROM Продажи)


SELECT  нДок , SUM(Цена*КОЛВО) as Итого from Продажи group by нДок -- пункт 11

