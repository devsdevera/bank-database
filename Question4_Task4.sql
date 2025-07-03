SELECT DISTINCT h.BankName, h.City
FROM HasAccounts h
JOIN Robbers AS r ON r.RobberID = h.RobberID
WHERE r.Nickname = 'Al Capone';
