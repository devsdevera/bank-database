SELECT DISTINCT h.RobberID, r.NickName
FROM HasAccounts AS h
JOIN Robbers AS r ON r.RobberID = h.RobberID
WHERE h.RobberID NOT IN (
SELECT DISTINCT h.RobberID
FROM HasAccounts AS h
JOIN Accomplices AS a ON a.RobberID = h.RobberID AND a.BankName = h.BankName AND a.City = h.City);
