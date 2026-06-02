-- Find duplicate emails

SELECT email, COUNT(*)
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- Orders without user

SELECT o.*
FROM orders o
LEFT JOIN users u
ON o.user_id = u.id
WHERE u.id IS NULL;

-- Payments without orders

SELECT p.*
FROM payments p
LEFT JOIN orders o
ON p.order_id = o.id
WHERE o.id IS NULL;

-- Users created today

SELECT *
FROM users
WHERE created_at::date = CURRENT_DATE;

-- Orders with negative amount

SELECT *
FROM orders
WHERE amount < 0;