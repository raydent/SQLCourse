USE �������
GO

SELECT distinct CONVERT(date,����) AS ����--����� 2
FROM �������

SELECT distinct ����������--����� 3
FROM �������
ORDER BY ����������


SELECT distinct ����� -- ����� 4
FROM �������
WHERE (���� > 100)

SELECT distinct ����������
FROM �������
WHERE (CONVERT(int, GETDATE()) - CONVERT(int, ����) < 7) -- ����� 5


SELECT  ����, ����, ����������, �����, �����, ����, ����*����� As ��������� --����� 6
From �������


SELECT MONTH(GETDATE())

SELECT  ����, ����, ����������, �����, �����, ���� -- ����� 7
FROM �������
WHERE (���������� LIKE '�%' AND MONTH(����) = 1 AND YEAR(����) = YEAR(GETDATE())) OR (����� > 5 AND ���� < 10)
ORDER BY ���� ASC, ���� DESC

SELECT distinct TOP 5 ���������� -- ����� 8
FROM �������
WHERE (MONTH(����) = 9 AND YEAR(GETDATE()) - YEAR(����) = 1)
ORDER BY ����������

DECLARE @param nvarchar(30) -- ����� 9
SET @param = '����%'
SELECT distinct ���������� 
FROM �������
Where (����� LIKE @param)


SELECT ���� --����� 10
FROM   �������
WHERE  ���� * ����� = (SELECT MAX(���� * �����) FROM �������)


SELECT  ���� , SUM(����*�����) as ����� from ������� group by ���� -- ����� 11

