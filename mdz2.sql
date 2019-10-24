USE Titanic
GO

SELECT COUNT(PassengerId) as Всего, SUM(Survived) as Выжило, CAST(SUM(Survived)/COUNT(PassengerId) as real) as Доля --пункт 1
FROM Titanic 

SELECT Pclass, COUNT(PassengerId) as 'Число пассажиров',  SUM(Survived) as Выжило, CAST(SUM(Survived)/COUNT(PassengerId) as real) as Доля -- пункт 2
FROM Titanic
Group By Pclass

SELECT Pclass, Sex, COUNT(PassengerId) as 'Число пассажиров',  SUM(Survived) as Выжило, CAST(SUM(Survived)/COUNT(PassengerId) as real) as Доля -- пункт 3
FROM Titanic
Group By Pclass, Sex

SELECT Embarked, COUNT(PassengerId) as 'Число пассажиров',  SUM(Survived) as Выжило, CAST(SUM(Survived)/COUNT(PassengerId) as real) as Доля -- пункт 4
FROM Titanic
Group By Embarked

SELECT Embarked -- пункт 5
FROM Titanic
GROUP BY Embarked
HAVING Count(PassengerId) = (SELECT TOP 1 COUNT(PassengerId) FROM Titanic GROUP BY Embarked)

SELECT Pclass, Sex, AVG(Age) as 'Средний возраст', SUM(CASE WHEN Survived = 1 THEN Age ELSE 0 END) / COUNT(CASE WHEN Survived = 1 THEN PassengerId ELSE NULL END) as 'Средний возраст выжившего' --пункт 6
FROM Titanic
GROUP BY Pclass, Sex

SELECT distinct TOP 10 Fare, Ticket --пункт 7
FROM Titanic
ORDER BY Fare DESC


SELECT Ticket -- пункт 8, цены
From Titanic
GROUP BY Ticket
HAVING COUNT(distinct FARE) > 1

SELECT Ticket -- пункт 8, порты
From Titanic
GROUP BY Ticket
HAVING COUNT(distinct Embarked) > 1

SELECT Ticket, Pclass, Fare, Embarked, COUNT(PassengerId) as 'Число пассажиров', SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as 'Число выживших' --пункт 9
FROM Titanic
GROUP BY Ticket, Pclass, Fare, Embarked

SELECT Ticket, COUNT(PassengerId) as 'Число пассажиров', SUM(CASE WHEN Survived = 1 THEN 1 ELSE 0 END) as 'Число выживших'--пункт 10
FROM Titanic
GROUP BY Ticket
HAVING SUM(Survived) = COUNT(distinct PassengerId) AND COUNT(DISTINCT PassengerId) > 1


SELECT CAST(SUM (Case When Name Like '%Mary%' THEN Survived ELSE 0 END) / COUNT(Case When Name Like '%Mary%' THEN Name ELSE NULL END) as real) as 'Шансы выжить у Mary',  CAST(SUM (Case When Name Like '%Elizabeth%' THEN Survived ELSE 0 END) / COUNT(Case When Name Like '%Elizabeth%' THEN Name ELSE NULL END) as real) as 'Шансы выжить у Elizabeth' --пункт 11
FROM Titanic
Where Name Like '%Elizabeth%' or Name Like '%Mary%'

