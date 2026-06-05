-- Reusable PostgreSQL views for QA SQL Lab

CREATE OR REPLACE VIEW active_user_order_summary AS
SELECT
    u.id AS user_id,
    u.email,
    u.country,
    COUNT(o.id) AS order_count,
    COALESCE(SUM(o.amount), 0.00) AS total_order_amount,
    MAX(o.created_at) AS latest_order_at
FROM users u
LEFT JOIN orders o
    ON u.id = o.user_id
WHERE u.status = 'ACTIVE'
  AND u.deleted_at IS NULL
GROUP BY u.id, u.email, u.country;

CREATE OR REPLACE VIEW order_payment_validation AS
SELECT
    COALESCE(o.id, p.order_id) AS order_id,
    o.order_number,
    o.user_id,
    u.email AS user_email,
    o.status AS order_status,
    o.amount AS order_amount,
    p.id AS payment_id,
    p.status AS payment_status,
    p.amount AS payment_amount,
    CASE
        WHEN o.id IS NULL THEN 'MISSING_ORDER'
        WHEN u.id IS NULL THEN 'MISSING_USER'
        WHEN p.id IS NULL THEN 'MISSING_PAYMENT'
        WHEN o.amount <> p.amount THEN 'AMOUNT_MISMATCH'
        WHEN o.status = 'PAID' AND p.status <> 'SUCCESS' THEN 'PAYMENT_NOT_SUCCESSFUL'
        WHEN o.status <> 'PAID' AND p.status = 'SUCCESS' THEN 'ORDER_NOT_MARKED_PAID'
        ELSE 'CONSISTENT'
    END AS qa_status
FROM orders o
LEFT JOIN users u
    ON o.user_id = u.id
FULL OUTER JOIN payments p
    ON o.id = p.order_id;
