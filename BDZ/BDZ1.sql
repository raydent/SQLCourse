USE Polynomes
GO
 
-- пункт 2
DECLARE @n INT, @txt nvarchar(100), @id INT
SET @n = 1
SET @txt = ' '
SET @id = 1
SELECT @txt = @txt + CAST(coeff as nvarchar(5)) + '*x^' + CAST(pow as nvarchar(5)) + ' + '
FROM Полиномы
WHERE id = @id
ORDER BY pow desc
SELECT REVERSE(STUFF(REVERSE(@txt),1,2,''))
--

-- пункт 3
SELECT distinct id
FROM Полиномы
WHERE coeff = 0 
--

-- пункт 4
DECLARE @num INT, @id INT, @txt nvarchar(100)
set @txt = ''
set @num = 5
set @id = 2
SELECT @txt = @txt + CAST(coeff * @num as nvarchar(5)) + '*x^' + CAST(pow as nvarchar(5)) + ' + '
FROM Полиномы
WHERE id = @id
ORDER BY pow desc
SELECT REVERSE(STUFF(REVERSE(@txt),1,2,''))
--

--пункт 5
DECLARE @num INT, @id INT, @txt nvarchar(100), @pow INT
set @txt = ''
set @num = 1
set @id = 5
set @pow = 3
SELECT TOP 1(CASE WHEN pow = @pow THEN 'YES' ELSE 'NO' END)
FROM Полиномы
WHERE coeff != 0 AND id = @id
ORDER BY pow DESC
--

--пункт 6 
DECLARE @num INT, @id INT, @id2 INT, @txt nvarchar(1000), @pow INT 
set @txt = ''
set @num = 1
set @id = 1
set @id2 = 4
SELECT @txt = @txt + CAST((pow1) as nvarchar(5)) + '^x' + '*' + CAST(coeff as nvarchar(5)) + ' + ' 
FROM
(
	SELECT *
	FROM 
	(
		SELECT ISNULL(id, 0) + ISNULL(id2, 0) as id, CAST((ISNULL(pow, pow2) + ISNULL(pow2, pow)) / 2 as INT) as pow1, ISNULL(coeff, 0) + ISNULL(coeff2, 0) as coeff
		FROM 
		(
			SELECT*
			FROM (SELECT * FROM Полиномы WHERE id = @id) AS T1 FULL JOIN (SELECT coeff as coeff2, id as id2, pow as pow2 FROM Полиномы WHERE id = @id2) AS T2
			ON T1.pow = T2.pow2
		)AS T3
	)AS T4
	WHERE coeff != 0
) AS T5
SELECT REVERSE(REVERSE(STUFF(REVERSE(@txt),1,2,'')))
--

--пункт 7
DECLARE @num INT, @id INT, @id2 INT, @txt nvarchar(1000), @pow INT
set @txt = ''
set @num = 1
set @id = 1
set @id2 = 2
SELECT @txt = @txt + CAST(coeff as nvarchar(5)) + '*x^' + CAST((pow) as nvarchar(5)) + ' + ' 
FROM
(
	SELECT SUM(coeff) as coeff, pow as pow
	FROM
	(
		SELECT id as id, (ISNULL(coeff, 0) * ISNULL(coeff2, 0)) as coeff, (ISNULL(pow, 0) + ISNULL(pow2, 0)) as pow FROM
		(SELECT*
		FROM 
		(SELECT * FROM Полиномы WHERE id = @id) AS T1 CROSS JOIN (SELECT coeff as coeff2, id as id2, pow as pow2 FROM Полиномы WHERE id = @id2) AS T2
		)AS T3
	)AS T4
	GROUP BY pow
)AS T5
WHERE coeff != 0
ORDER BY pow desc
SELECT REVERSE(STUFF(REVERSE(@txt),1,2,''))
--

 --пункт 8
DECLARE @num INT, @id INT, @id2 INT, @txt nvarchar(1000), @pow INT, @sum INT
set @txt = ''
set @num = 2
set @id = 3
set @pow = 3
set @id2 = 2
set @sum = 0
SELECT @sum = @sum + coeff * cast(POWER(@num, pow) as INT)
FROM Полиномы
WHERE id = @id
ORDER BY pow desc
SELECT @sum
--

--пункт 9
DECLARE @num INT, @id INT, @id2 INT, @txt nvarchar(1000), @pow INT, @sum INT
set @txt = ''
set @num = 2
set @id = 6
set @pow = 3
set @id2 = 2
set @sum = 0
SELECT 
(CASE WHEN SUM(pow) = 3 
AND (select coeff FROM Полиномы WHERE id = @id and pow = 2) * 2 * (select coeff FROM Полиномы where id = @id and pow = 0) =
(select coeff FROM Полиномы where id = @id and pow = 1)
THEN 
	'YES' 
ELSE 
	'NO' 
END)
FROM
Полиномы
WHERE (id = @id)
--

--пункт 10
DECLARE @id INT, @max INT, @plus INT, @minus INT, @zero INT 
set @id = 8
set @zero = 0
set @minus = 0
set @plus = 0
SELECT @plus = @plus + (CASE WHEN coeff > 0 THEN 1 ELSE 0 END),
@minus = @minus + (CASE WHEN coeff < 0 THEN 1 ELSE 0 END), 
@zero = (SELECT max(pow) - count(pow) + 1 FROM Полиномы WHERE id = @id AND coeff != 0) 
FROM
(
	SELECT *
	FROM 
	Полиномы
	WHERE (id = @id) AND coeff != 0
)AS T
ORDER BY pow DESC
SELECT @plus as plus, @minus as minus, @zero as zero
--

-- пункт 11
DECLARE @id INT
set @id = 1
SELECT (CASE WHEN (SELECT COUNT(coeff) FROM [Полиномы 1] WHERE id = @id AND CEILING(coeff) != FLOOR(coeff)) != 0 THEN 'NO' ELSE 'YES' END)
--

-- пункт 12
DECLARE @id INT
set @id = 4
SELECT (CASE WHEN 
(SELECT MAX(pow) FROM [Полиномы 1] WHERE id = @id and coeff != 0) = 1 
THEN 
	CAST(ISNULL((SELECT coeff * (-1) FROM [Полиномы 1] WHERE id = @id AND pow = 0), 0) / (SELECT coeff FROM [Полиномы 1] WHERE id = @id AND pow = 1) 
	as varchar(10))
ELSE 
	'NO'
END)
--


-- пункт 13
DECLARE @id INT, @a INT, @b INT, @c INT, @D INT, @max INT
set @id = 3
set @a = 0
set @b = 0
set @c = 0
set @max = 0
SELECT @a = @a + (CASE WHEN pow = 2 THEN coeff ELSE 0 END), @b = @b + (CASE WHEN pow = 1 THEN coeff ELSE 0 END), @c = @c + (CASE WHEN pow = 0 THEN coeff ELSE 0 END),
@D = @b * @b - 4 * @a * @c, @max = @max + (CASE WHEN pow > @max THEN pow - @max ELSE 0 END)
FROM [Полиномы 1]
WHERE id = @id
IF (@max = 2)
	IF @c = 0
		SELECT CAST((-@b / @a) as nvarchar(10)) + ' AND ' + CAST(0 as nvarchar(10))
	ELSE
		IF @b = 0
			IF @c > 0
				SELECT(CAST(SQRT(@c) as nvarchar(10)))
			ELSE
				SELECT 'NO ROOTS'
		ELSE
			IF @D >= 0
				SELECT CAST((SQRT(@D) - @b) / (2 *@a) as nvarchar(10)) + ' AND ' + CAST((-SQRT(@D) - @b) / (2 *@a) as nvarchar(10))
			ELSE
				SELECT 'NO ROOTS'
ELSE
	SELECT 'NOT A 2nd POWER POLYNOM'
--