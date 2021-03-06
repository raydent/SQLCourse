USE Polynomes
GO

--пункт1
--Таблица находится в 1НФ, потому что она удоволетворяет условиям: нет одинаковых кортежей, кортежи не упорядочены, атрибуты не упорядочены и различаются по имениванию, все значения атрибутов атомарны.
--


-- пункт 2
DECLARE @txt nvarchar(100), @id INT
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
DECLARE @num real, @id INT, @txt nvarchar(100)
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
DECLARE @id INT, @txt nvarchar(100), @pow INT
set @txt = ''
set @id = 5
set @pow = 3
SELECT TOP 1(CASE WHEN pow = @pow THEN 'YES' ELSE 'NO' END)
FROM Полиномы
WHERE coeff != 0 AND id = @id
ORDER BY pow DESC
--

--пункт 6 
DECLARE @id INT, @id2 INT, @txt nvarchar(1000), @pow INT 
set @txt = ''
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
DECLARE @id INT, @id2 INT, @txt nvarchar(1000), @pow INT
set @txt = ''
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
DECLARE @num real, @id INT, @id2 INT, @sum real
set @num = 2
set @id = 3
set @id2 = 2
set @sum = 0
SELECT @sum = @sum + coeff * cast(POWER(@num, pow) as real)
FROM Полиномы
WHERE id = @id
ORDER BY pow desc
SELECT @sum
--

--пункт 9
DECLARE @id INT, @maxpow real, @a real, @b real, @c real 
set @id = 6
set @a = 0
set @b = 0
set @c = 0
set @maxpow = 0
SELECT @a = @a + (CASE WHEN pow = 2 THEN coeff ELSE 0 END),  
@b = @b + (CASE WHEN pow = 1 THEN coeff ELSE 0 END),  
@c = @c + (CASE WHEN pow = 0 THEN coeff ELSE 0 END),
@maxpow = @maxpow + (CASE WHEN pow > @maxpow THEN pow - @maxpow ELSE 0 END)
FROM
Полиномы
WHERE (id = @id) AND coeff != 0
IF (@maxpow = 2)
	IF(@c >= 0)
		IF (@a > 0)
			IF (2 * sqrt(@a) * sqrt(@c) = ABS(@b))
				SELECT 'YES'
			ELSE
				SELECT 'NO'
		ELSE
			SELECT 'NO'
	ELSE
		SELECT 'NO'
ELSE
	SELECT 'NO'
--

--пункт 10
DECLARE @id INT, @plus INT, @minus INT, @zero INT 
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
SELECT (CASE WHEN (SELECT COUNT(coeff) FROM Полиномы WHERE id = @id AND CEILING(coeff) != FLOOR(coeff)) != 0 THEN 'NO' ELSE 'YES' END)
--

-- пункт 12
DECLARE @id INT
set @id = 4
SELECT (CASE WHEN 
(SELECT MAX(pow) FROM Полиномы  WHERE id = @id and coeff != 0) = 1 
THEN 
	CAST(ISNULL((SELECT coeff * (-1) FROM Полиномы WHERE id = @id AND pow = 0), 0) / (SELECT coeff FROM Полиномы WHERE id = @id AND pow = 1) 
	as varchar(10))
ELSE 
	'NO'
END)
--


-- пункт 13
DECLARE @id INT, @a real, @b real, @c real, @D real, @max INT
set @id = 15
set @a = 0
set @b = 0
set @c = 0
set @max = 0
SELECT @a = @a + (CASE WHEN pow = 2 THEN coeff ELSE 0 END), @b = @b + (CASE WHEN pow = 1 THEN coeff ELSE 0 END), @c = @c + (CASE WHEN pow = 0 THEN coeff ELSE 0 END),
@D = @b * @b - 4 * @a * @c, @max = @max + (CASE WHEN pow > @max THEN pow - @max ELSE 0 END)
FROM Полиномы
WHERE id = @id
IF (@max = 2)
	IF @c = 0
		SELECT CAST((-@b / @a) as nvarchar(10)) + ' AND ' + CAST(0 as nvarchar(10))
	ELSE
		IF @b = 0
			IF @c < 0
				SELECT(CAST(SQRT(-@c) as nvarchar(10)) + ' AND ' + (CAST(-SQRT(-@c) as nvarchar(10))))
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

--пункт 14
DECLARE @idresult INT, @id1multiplier INT, @id2multiplier INT, @txt nvarchar(1000), @pow INT, @firstpolynome nvarchar(1000)
set @txt = ''
set @firstpolynome = ''
set @idresult = 14
set @id1multiplier = 13
set @id2multiplier = 11
SELECT @txt = @txt + CAST(coeff as nvarchar(5)) + '*x^' + CAST((pow) as nvarchar(5)) + ' + ' 
FROM
(
	SELECT SUM(coeff) as coeff, pow as pow
	FROM
	(
		SELECT id as id, (ISNULL(coeff, 0) * ISNULL(coeff2, 0)) as coeff, (ISNULL(pow, 0) + ISNULL(pow2, 0)) as pow FROM
		(SELECT*
		FROM 
		(SELECT * FROM Полиномы WHERE id = @id1multiplier) AS T1 CROSS JOIN (SELECT coeff as coeff2, id as id2, pow as pow2 FROM Полиномы WHERE id = @id2multiplier) AS T2
		)AS T3
	)AS T4
	GROUP BY pow
)AS T5
WHERE coeff != 0
ORDER BY pow desc

SELECT @firstpolynome = @firstpolynome + CAST(coeff as nvarchar(5)) + '*x^' + CAST(pow as nvarchar(5)) + ' + '
FROM Полиномы
WHERE id = @idresult AND coeff != 0
ORDER BY pow desc

SELECT (CASE WHEN (REVERSE(STUFF(REVERSE(@txt),1,2,'')) = REVERSE(STUFF(REVERSE(@firstpolynome),1,2,''))) THEN 1 ELSE 0 END)
--

--пункт 15
DECLARE @iddividend INT, @iddivider INT, @idquotient INT, @txt nvarchar(1000), @pow INT, @dividendtxt nvarchar(1000)
set @txt = ''
set @dividendtxt = ''
set @iddividend = 14
set @iddivider = 13
set @idquotient = 11
SELECT @txt = @txt + CAST(coeff as nvarchar(5)) + '*x^' + CAST((pow) as nvarchar(5)) + ' + ' 
FROM
(
	SELECT SUM(coeff) as coeff, pow as pow
	FROM
	(
		SELECT id as id, (ISNULL(coeff, 0) * ISNULL(coeff2, 0)) as coeff, (ISNULL(pow, 0) + ISNULL(pow2, 0)) as pow FROM
		(SELECT*
		FROM 
		(SELECT * FROM Полиномы WHERE id = @iddivider) AS T1 CROSS JOIN (SELECT coeff as coeff2, id as id2, pow as pow2 FROM Полиномы WHERE id = @idquotient) AS T2
		)AS T3
	)AS T4
	GROUP BY pow
)AS T5
WHERE coeff != 0
ORDER BY pow desc

SELECT @dividendtxt = @dividendtxt + CAST(coeff as nvarchar(5)) + '*x^' + CAST(pow as nvarchar(5)) + ' + '
FROM Полиномы
WHERE id = @iddividend AND coeff != 0
ORDER BY pow desc

SELECT (CASE WHEN (REVERSE(STUFF(REVERSE(@txt),1,2,'')) = REVERSE(STUFF(REVERSE(@dividendtxt),1,2,''))) THEN 1 ELSE 0 END)
--
