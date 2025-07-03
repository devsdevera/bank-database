SELECT a.RobberID, rb.Nickname, SUM(a.Share) AS TotalEarnings
FROM Accomplices AS a
JOIN Robbers AS rb ON rb.RobberID = a.RobberID
JOIN (
    SELECT a.RobberID
    FROM Accomplices AS a
    JOIN Robbers AS rb ON rb.RobberID = a.RobberID
    JOIN (
        SELECT BankName, City, Date
        FROM Robberies r
        WHERE r.Amount = (SELECT MAX(Amount) FROM Robberies)
    ) AS b ON b.BankName = a.BankName AND b.City = a.City AND b.Date = a.Date
) AS r ON r.RobberID = a.RobberID
GROUP BY a.RobberID, rb.Nickname
ORDER BY TotalEarnings DESC;
