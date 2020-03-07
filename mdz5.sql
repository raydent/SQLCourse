USE �����
GO


--1 
SELECT T1.��������, T2.��������
FROM
(
	SELECT T1.�����_ID_2, T2.��������
	FROM
	(
		SELECT TOP 1 WITH TIES �����_ID_1, �����_ID_2
		FROM ��������
		ORDER BY ���������� desc
	) T1
	INNER JOIN 
	������ T2
	ON T1.�����_ID_1 = T2.�����_ID
) T1
INNER JOIN
������ T2
ON T1.�����_ID_2 = T2.�����_ID
--

--2
SELECT �����_ID_1, �����_ID_2, ����������, �������_ID1
FROM
(
	SELECT �������_ID, min(����������) as ���_����������
	FROM
	(
		SELECT T1.�����_ID_1, T1.�����_ID_2, T1.�������� as ��������_1, T1.�������_ID as �������_1, T1.����������, T2.�������� as ��������_2, T2.�������_ID as �������_2
		FROM
		(
			SELECT *
			FROM
			�������� T1
			INNER JOIN 
			������ T2
			ON T1.�����_ID_1 = T2.�����_ID
		) T1
		INNER JOIN 
		������ T2
		ON T1.�����_ID_2 = T2.�����_ID
	) T1
	INNER JOIN
	������� T2
	ON (T1.�������_1 = T2.�������_ID) AND (T1.�������_2 = T2.�������_ID)
	GROUP BY �������_ID
) T1
INNER JOIN 
(
	SELECT *
	FROM
	(
		SELECT T1.�����_ID_1, T1.�����_ID_2, T1.�������_ID as �������_ID1, T1.����������, T2.�������_ID as �������_ID2
		FROM
		(
			SELECT*
			FROM
			������ T1
			INNER JOIN
			�������� T2
			ON T1.�����_ID = T2.�����_ID_2
		) T1
		INNER JOIN
		������ T2
		ON T1.�����_ID_1 = T2.�����_ID
	) T1
	INNER JOIN
	������� T2
	ON T1.�������_ID1 = T2.�������_ID AND T1.�������_ID2 = T2.�������_ID
) T2
ON T1.�������_ID = T2.�������_ID AND T1.���_���������� = T2.����������
--

--3
SELECT T1.�����_ID as �����_ID1, T2.�����_ID as �����_ID2
FROM
������ T1
INNER JOIN
������ T2
ON T1.�����_ID < T2.�����_ID
EXCEPT
SELECT �����_ID_1, �����_ID_2
FROM
��������
--

--4
SELECT �����_ID 
FROM
������
EXCEPT
SELECT �����_ID_2
FROM
��������
--

--5
SELECT �����_ID 
FROM
������
EXCEPT
SELECT �����_ID_1
FROM
��������
--



--6
DECLARE @city int, @turn int
SET @city = 17
SET @turn = 3

DECLARE @FT TABLE (city1 int, city2 int)
INSERT INTO @FT
SELECT �����_ID_1, �����_ID_2
FROM
��������
WHERE �����_ID_1 = @city OR �����_ID_2 = @city

WHILE @turn > 0
BEGIN
	INSERT INTO @FT
	SELECT T1.�����_ID_1, T1.�����_ID_2
	FROM 
	�������� T1
	INNER JOIN 
	@FT T2 
	ON T1.�����_ID_1 = T2.city2 OR T1.�����_ID_2 = T2.city1

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
SELECT T1.�����_ID_1, T1.�����_ID_2, T1.city as �����_ID, T1.d, T1.d1, T2.d2
FROM
(
	SELECT T1.�����_ID_1, T1.�����_ID_2, T2.�����_ID_1 as city, T1.���������� as d, T2.���������� as d1
	FROM 
	(
		SELECT �����_ID_1, �����_ID_2, ����������
		FROM
		�������� 
		UNION
		SELECT �����_ID_2, �����_ID_1, ����������
		FROM ��������
	) T1
	INNER JOIN
	(
		SELECT �����_ID_1, �����_ID_2, ����������
		FROM
		�������� 
		UNION
		SELECT �����_ID_2, �����_ID_1, ����������
		FROM ��������
	) T2
	ON T1.�����_ID_1 = T2.�����_ID_2
) T1
INNER JOIN
(
	SELECT T1.�����_ID_1, T1.�����_ID_2, T2.�����_ID_2 as city, T1.���������� as d, T2.���������� as d2
	FROM 
	(
		SELECT �����_ID_1, �����_ID_2, ����������
		FROM
		�������� 
		UNION
		SELECT �����_ID_2, �����_ID_1, ����������
		FROM ��������
	) T1
	INNER JOIN
	(
		SELECT �����_ID_1, �����_ID_2, ����������
		FROM
		�������� 
		UNION
		SELECT �����_ID_2, �����_ID_1, ����������
		FROM ��������
	) T2
	ON T1.�����_ID_2 = T2.�����_ID_1
) T2
ON T1.�����_ID_1 = T2.�����_ID_1 AND T1.�����_ID_1 < T1.�����_ID_2 AND T1.city = T2.city AND T1.�����_ID_2 = T2.�����_ID_2
WHERE d1 + d2 < T1.d
--






























