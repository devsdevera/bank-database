SELECT RobberID, Nickname, (Age - NoYears) AS YearsNotPrison
FROM Robbers
WHERE NoYears > Age / 2;
