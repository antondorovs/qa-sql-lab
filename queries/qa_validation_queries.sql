-- QA database validation queries
-- Each query returns suspicious rows that should be investigated.

-- Baseline summary for all reusable data quality rules
SELECT
    rule_id,
    severity,
    expected_issue_count,
    actual_issue_count,
    issue_count_delta,
    baseline_status
FROM data_quality_rule_report
ORDER BY
    CASE severity
        WHEN 'CRITICAL' THEN 1
        WHEN 'HIGH' THEN 2
        WHEN 'MEDIUM' THEN 3
        ELSE 4
    END,
    rule_id;

-- Duplicate emails
SELECT email, COUNT(*) AS duplicate_count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- Orders without existing users
SELECT
    o.id,
    o.order_number,
    o.user_id,
    o.status,
    o.amount
FROM orders o
LEFT JOIN users u
    ON o.user_id = u.id
WHERE u.id IS NULL;

-- Payments without existing orders
SELECT
    p.id,
    p.order_id,
    p.status,
    p.amount
FROM payments p
LEFT JOIN orders o
    ON p.order_id = o.id
WHERE o.id IS NULL;

-- Addresses without existing users
SELECT
    a.id,
    a.user_id,
    a.city,
    a.country
FROM addresses a
LEFT JOIN users u
    ON a.user_id = u.id
WHERE u.id IS NULL;

-- Users created today
SELECT id, email, created_at
FROM users
WHERE created_at::date = CURRENT_DATE;

-- Orders with negative amount
SELECT id, order_number, amount
FROM orders
WHERE amount < 0;

-- Users without age
SELECT id, email, age
FROM users
WHERE age IS NULL;

-- Successful payments without paid timestamp
SELECT id, order_id, status, paid_at
FROM payments
WHERE status = 'SUCCESS'
  AND paid_at IS NULL;

-- Paid orders without successful payment
SELECT
    o.id,
    o.order_number,
    o.status AS order_status,
    p.status AS payment_status
FROM orders o
LEFT JOIN payments p
    ON o.id = p.order_id
   AND p.status = 'SUCCESS'
WHERE o.status = 'PAID'
  AND p.id IS NULL;

-- Order and payment amount mismatch
SELECT
    o.id AS order_id,
    o.order_number,
    o.amount AS order_amount,
    p.amount AS payment_amount
FROM orders o
INNER JOIN payments p
    ON o.id = p.order_id
WHERE o.amount <> p.amount;

-- Users deleted before they were created
SELECT id, email, created_at, deleted_at
FROM users
WHERE deleted_at < created_at;

-- Addresses created before their users
SELECT
    a.id AS address_id,
    a.user_id,
    u.created_at AS user_created_at,
    a.created_at AS address_created_at
FROM addresses a
INNER JOIN users u
    ON a.user_id = u.id
WHERE a.created_at < u.created_at;

-- Orders created before their users
SELECT
    o.id AS order_id,
    o.order_number,
    o.user_id,
    u.created_at AS user_created_at,
    o.created_at AS order_created_at
FROM orders o
INNER JOIN users u
    ON o.user_id = u.id
WHERE o.created_at < u.created_at;

-- Payments recorded before their orders
SELECT
    p.id AS payment_id,
    p.order_id,
    o.created_at AS order_created_at,
    p.paid_at
FROM payments p
INNER JOIN orders o
    ON p.order_id = o.id
WHERE p.paid_at < o.created_at;

-- Users with unsupported status values
SELECT id, email, status
FROM users
WHERE status NOT IN ('ACTIVE', 'INACTIVE', 'DELETED');

-- Orders with unsupported status values
SELECT id, order_number, status
FROM orders
WHERE status NOT IN ('NEW', 'PAID', 'SHIPPED', 'CANCELLED');

-- Payments with unsupported status values
SELECT id, order_id, status
FROM payments
WHERE status NOT IN ('SUCCESS', 'PENDING', 'REFUNDED', 'FAILED');

-- Payments with unsupported method values
SELECT id, order_id, payment_method
FROM payments
WHERE payment_method NOT IN ('CARD', 'PAYPAL', 'BANK_TRANSFER');
