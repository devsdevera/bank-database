SELECT h.RobberID, r.Nickname, s.Description
FROM (SELECT * FROM HasSkills WHERE Preference = 1) AS h
JOIN Robbers AS r ON r.RobberID = h.RobberID
JOIN Skills AS s ON s.SkillID = h.SkillID
WHERE h.RobberID IN (
    SELECT RobberID
    FROM HasSkills
    GROUP BY RobberID
    HAVING COUNT(*) >= 2
);
