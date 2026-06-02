-- COUNT, SUM, AVG, GROUP BY

-- Aggregation examples

SELECT COUNT(*)
FROM users;

SELECT status, COUNT(*)
FROM users
GROUP BY status;

SELECT country, COUNT(*)
FROM users
GROUP BY country;

SELECT AVG(amount)
FROM orders;

SELECT SUM(amount)
FROM orders;

SELECT MAX(created_at)
FROM orders;