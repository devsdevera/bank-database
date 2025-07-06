SELECT DISTINCT p.BankName, p.City
FROM Plans p
WHERE NOT EXISTS (
SELECT * FROM Robberies r
WHERE r.BankName = p.BankName AND r.City = p.City
AND EXTRACT(YEAR FROM r.Date) = EXTRACT(YEAR FROM p.PlannedDate)
);
