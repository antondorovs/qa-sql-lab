-- WHERE, IN, BETWEEN, LIKE

-- Basic WHERE examples

SELECT *
FROM users;

SELECT *
FROM users
WHERE id = 1;

SELECT *
FROM users
WHERE status = 'ACTIVE';

SELECT *
FROM users
WHERE created_at > '2025-01-01';

SELECT *
FROM users
WHERE email LIKE '%gmail.com';

SELECT *
FROM users
WHERE age BETWEEN 18 AND 60;

SELECT *
FROM users
WHERE country IN ('USA', 'Canada', 'Germany');

SELECT *
FROM users
WHERE deleted_at IS NULL;

SELECT *
FROM users
ORDER BY created_at DESC;