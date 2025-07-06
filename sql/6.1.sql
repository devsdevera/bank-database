SELECT r.City, ROUND(AVG(r.avg), 2) AS Average
FROM (SELECT r.BankName, r.City, r.Date, r.Amount, COUNT(*), 
(r.Amount / COUNT(*)) AS avg
FROM Robberies AS r
JOIN Accomplices AS a ON a.BankName = r.BankName AND 
a.City = r.City AND a.Date = r.Date
GROUP BY r.BankName, r.City, r.Date) AS r
GROUP BY r.City;
