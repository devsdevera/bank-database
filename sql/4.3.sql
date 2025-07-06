SELECT r.RobberID, r.Nickname, r.Age, s.Description
FROM Hasskills AS h
JOIN Robbers AS r ON r.RobberID = h.RobberID
JOIN Skills AS s ON s.SkillID = h.SkillID
WHERE r.Age >= 35;
