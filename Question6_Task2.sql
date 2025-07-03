SELECT b.security, COUNT(*), 
ROUND(AVG(Amount), 2) AS Average
FROM Robberies AS r
JOIN Banks AS b ON b.BankName = r.BankName 
AND b.City = r.City
GROUP BY b.security;
