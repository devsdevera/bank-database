SELECT a.RobberID, r.Nickname, SUM(a.Share) AS Earnings
FROM Accomplices AS a
JOIN Robbers AS r ON r.RobberID = a.RobberID
GROUP BY a.RobberId, r.Nickname
HAVING SUM(a.Share) >= 50000
ORDER BY Earnings DESC;
