-- INNER/LEFT/RIGHT JOIN

-- JOIN examples

SELECT *
FROM users u
INNER JOIN orders o
ON u.id = o.user_id;

SELECT *
FROM users u
LEFT JOIN orders o
ON u.id = o.user_id;

SELECT *
FROM orders o
LEFT JOIN payments p
ON o.id = p.order_id;

SELECT *
FROM users u
INNER JOIN addresses a
ON u.id = a.user_id;