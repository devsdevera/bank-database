SELECT s.Description, h.RobberID, r.Nickname
FROM Hasskills AS h
JOIN Skills AS s ON s.SkillID = h.SkillID
JOIN Robbers AS r ON r.RobberID = h.RobberID
ORDER BY s.Description ASC;
