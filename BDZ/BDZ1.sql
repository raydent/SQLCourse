USE Polynomes
GO

DECLARE @n INT, @txt nvarchar(100), @id INT -- ïóíêò 2
SET @n = 1
SET @txt = ' '
SET @id = 1
SELECT @txt = @txt + CAST(coeff as nvarchar(5)) + '*x^' + CAST(pow as nvarchar(5)) + ' + '
FROM Ïîëèíîìû
WHERE id = @id
ORDER BY pow desc
SELECT REVERSE(STUFF(REVERSE(@txt),1,2,''))

SELECT distinct id -- ïóíêò 3
FROM Ïîëèíîìû
WHERE coeff = 0 

DECLARE @num INT, @id INT, @txt nvarchar(100) -- ïóíêò 4
set @txt = ''
set @num = 5
set @id = 2
SELECT @txt = @txt + CAST(coeff * @num as nvarchar(5)) + '*x^' + CAST(pow as nvarchar(5)) + ' + '
FROM Ïîëèíîìû
WHERE id = @id
ORDER BY pow desc
SELECT REVERSE(STUFF(REVERSE(@txt),1,2,''))

DECLARE @num INT, @id INT, @txt nvarchar(100), @pow INT --ïóíêò 5
set @txt = ''
set @num = 1
set @id = 5
set @pow = 3
SELECT TOP 1(CASE WHEN pow = @pow THEN 'YES' ELSE 'NO' END)
FROM Ïîëèíîìû
WHERE coeff != 0 AND id = @id
ORDER BY pow DESC


DECLARE @num INT, @id INT, @id2 INT, @txt nvarchar(1000), @pow INT  --ïóíêò 6 
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
FROM (SELECT * FROM Ïîëèíîìû WHERE id = @id) AS T1 FULL JOIN (SELECT coeff as coeff2, id as id2, pow as pow2 FROM Ïîëèíîìû WHERE id = @id2) AS T2
ON T1.pow = T2.pow2
)AS T3
)AS T4
WHERE coeff != 0
)AS T5
SELECT REVERSE(STUFF(REVERSE(@txt),1,2,''))

 
