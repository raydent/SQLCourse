USE Polynomes
GO

DECLARE @n INT, @txt nvarchar(100), @id INT -- пункт 2
SET @n = 1
SET @txt = ' '
SET @id = 1
SELECT @txt = @txt + CAST(coeff as nvarchar(5)) + '*x^' + CAST(pow as nvarchar(5)) + ' + '
FROM Полиномы
WHERE id = @id
ORDER BY pow desc
SELECT REVERSE(STUFF(REVERSE(@txt),1,2,''))

SELECT distinct id -- пункт 3
FROM Полиномы
WHERE coeff = 0 

DECLARE @num INT, @id INT, @txt nvarchar(100) -- пункт 4
set @txt = ''
set @num = 5
set @id = 2
SELECT @txt = @txt + CAST(coeff * @num as nvarchar(5)) + '*x^' + CAST(pow as nvarchar(5)) + ' + '
FROM Полиномы
WHERE id = @id
ORDER BY pow desc
SELECT REVERSE(STUFF(REVERSE(@txt),1,2,''))

DECLARE @num INT, @id INT, @txt nvarchar(100), @pow INT --пункт 5
set @txt = ''
set @num = 1
set @id = 5
set @pow = 3
SELECT TOP 1(CASE WHEN pow = @pow THEN 'YES' ELSE 'NO' END)
FROM Полиномы
WHERE coeff != 0 AND id = @id
ORDER BY pow DESC


DECLARE @num INT, @id INT, @id2 INT, @txt nvarchar(1000), @pow INT  --пункт 6 
set @txt = ''
set @num = 1
set @id = 1
set @pow = 3
set @id2 = 5
SELECT @txt = @txt + CAST(coeff as nvarchar(5)) + '*x^' + CAST((pow) as nvarchar(5)) + ' + ' 
FROM(
SELECT *
FROM 
(
SELECT ISNULL(id, 0) + ISNULL(id2, 0) as id, ISNULL(pow,0) + ISNULL(pow2, 0) as pow, ISNULL(coeff, 0) + ISNULL(coeff2, 0) as coeff
FROM 
(SELECT*
FROM (SELECT * FROM Полиномы WHERE id = @id) AS T1 FULL JOIN (SELECT coeff as coeff2, id as id2, pow as pow2 FROM Полиномы WHERE id = @id2) AS T2
ON T1.pow = T2.pow2
)AS T3
)AS T4
WHERE coeff != 0
)AS T5
SELECT REVERSE(STUFF(REVERSE(@txt),1,2,''))

 