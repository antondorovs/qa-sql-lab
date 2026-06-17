-- Reusable PostgreSQL views for QA SQL Lab

CREATE OR REPLACE VIEW column_schema_contract_report AS
WITH expected_columns (
    table_name,
    column_name,
    ordinal_position,
    data_type,
    character_maximum_length,
    numeric_precision,
    numeric_scale,
    is_nullable
) AS (
    VALUES
        ('users', 'id', 1, 'integer', NULL, 32, 0, 'NO'),
        ('users', 'first_name', 2, 'character varying', 50, NULL, NULL, 'NO'),
        ('users', 'last_name', 3, 'character varying', 50, NULL, NULL, 'NO'),
        ('users', 'email', 4, 'character varying', 120, NULL, NULL, 'NO'),
        ('users', 'status', 5, 'character varying', 20, NULL, NULL, 'NO'),
        ('users', 'country', 6, 'character varying', 60, NULL, NULL, 'NO'),
        ('users', 'age', 7, 'integer', NULL, 32, 0, 'YES'),
        (
            'users',
            'created_at',
            8,
            'timestamp without time zone',
            NULL,
            NULL,
            NULL,
            'NO'
        ),
        (
            'users',
            'deleted_at',
            9,
            'timestamp without time zone',
            NULL,
            NULL,
            NULL,
            'YES'
        ),
        ('addresses', 'id', 1, 'integer', NULL, 32, 0, 'NO'),
        ('addresses', 'user_id', 2, 'integer', NULL, 32, 0, 'YES'),
        ('addresses', 'city', 3, 'character varying', 80, NULL, NULL, 'NO'),
        ('addresses', 'country', 4, 'character varying', 60, NULL, NULL, 'NO'),
        ('addresses', 'postal_code', 5, 'character varying', 20, NULL, NULL, 'YES'),
        ('addresses', 'is_primary', 6, 'boolean', NULL, NULL, NULL, 'NO'),
        (
            'addresses',
            'created_at',
            7,
            'timestamp without time zone',
            NULL,
            NULL,
            NULL,
            'NO'
        ),
        ('orders', 'id', 1, 'integer', NULL, 32, 0, 'NO'),
        ('orders', 'user_id', 2, 'integer', NULL, 32, 0, 'YES'),
        ('orders', 'order_number', 3, 'character varying', 30, NULL, NULL, 'NO'),
        ('orders', 'status', 4, 'character varying', 20, NULL, NULL, 'NO'),
        ('orders', 'amount', 5, 'numeric', NULL, 10, 2, 'NO'),
        (
            'orders',
            'created_at',
            6,
            'timestamp without time zone',
            NULL,
            NULL,
            NULL,
            'NO'
        ),
        ('payments', 'id', 1, 'integer', NULL, 32, 0, 'NO'),
        ('payments', 'order_id', 2, 'integer', NULL, 32, 0, 'YES'),
        (
            'payments',
            'payment_method',
            3,
            'character varying',
            30,
            NULL,
            NULL,
            'NO'
        ),
        ('payments', 'status', 4, 'character varying', 20, NULL, NULL, 'NO'),
        ('payments', 'amount', 5, 'numeric', NULL, 10, 2, 'NO'),
        (
            'payments',
            'paid_at',
            6,
            'timestamp without time zone',
            NULL,
            NULL,
            NULL,
            'YES'
        )
),
actual_columns AS (
    SELECT
        table_name::TEXT,
        column_name::TEXT,
        ordinal_position::INTEGER,
        data_type::TEXT,
        character_maximum_length::INTEGER,
        numeric_precision::INTEGER,
        numeric_scale::INTEGER,
        is_nullable::TEXT
    FROM information_schema.columns
    WHERE table_schema = CURRENT_SCHEMA()
      AND table_name IN ('users', 'addresses', 'orders', 'payments')
)
SELECT
    COALESCE(e.table_name, a.table_name) AS table_name,
    COALESCE(e.column_name, a.column_name) AS column_name,
    e.ordinal_position AS expected_ordinal_position,
    a.ordinal_position AS actual_ordinal_position,
    e.data_type AS expected_data_type,
    a.data_type AS actual_data_type,
    e.character_maximum_length AS expected_character_maximum_length,
    a.character_maximum_length AS actual_character_maximum_length,
    e.numeric_precision AS expected_numeric_precision,
    a.numeric_precision AS actual_numeric_precision,
    e.numeric_scale AS expected_numeric_scale,
    a.numeric_scale AS actual_numeric_scale,
    e.is_nullable AS expected_is_nullable,
    a.is_nullable AS actual_is_nullable,
    CASE
        WHEN e.column_name IS NULL THEN 'UNEXPECTED_COLUMN'
        WHEN a.column_name IS NULL THEN 'MISSING_COLUMN'
        WHEN e.ordinal_position IS DISTINCT FROM a.ordinal_position
            THEN 'POSITION_MISMATCH'
        WHEN e.data_type IS DISTINCT FROM a.data_type
            OR e.character_maximum_length
                IS DISTINCT FROM a.character_maximum_length
            OR e.numeric_precision IS DISTINCT FROM a.numeric_precision
            OR e.numeric_scale IS DISTINCT FROM a.numeric_scale
            THEN 'TYPE_MISMATCH'
        WHEN e.is_nullable IS DISTINCT FROM a.is_nullable
            THEN 'NULLABILITY_MISMATCH'
        ELSE 'MATCH'
    END AS contract_status
FROM expected_columns e
FULL OUTER JOIN actual_columns a
    ON e.table_name = a.table_name
   AND e.column_name = a.column_name;

CREATE OR REPLACE VIEW primary_key_contract_report AS
WITH expected_primary_keys (table_name, column_name, ordinal_position) AS (
    VALUES
        ('users', 'id', 1),
        ('addresses', 'id', 1),
        ('orders', 'id', 1),
        ('payments', 'id', 1)
),
actual_primary_keys AS (
    SELECT
        tc.table_name::TEXT,
        kcu.column_name::TEXT,
        kcu.ordinal_position::INTEGER
    FROM information_schema.table_constraints tc
    INNER JOIN information_schema.key_column_usage kcu
        ON tc.constraint_catalog = kcu.constraint_catalog
       AND tc.constraint_schema = kcu.constraint_schema
       AND tc.constraint_name = kcu.constraint_name
    WHERE tc.table_schema = CURRENT_SCHEMA()
      AND tc.constraint_type = 'PRIMARY KEY'
      AND tc.table_name IN ('users', 'addresses', 'orders', 'payments')
)
SELECT
    COALESCE(e.table_name, a.table_name) AS table_name,
    e.column_name AS expected_column_name,
    a.column_name AS actual_column_name,
    e.ordinal_position AS expected_ordinal_position,
    a.ordinal_position AS actual_ordinal_position,
    CASE
        WHEN e.table_name IS NULL THEN 'UNEXPECTED_PRIMARY_KEY'
        WHEN a.table_name IS NULL THEN 'MISSING_PRIMARY_KEY'
        WHEN e.column_name IS DISTINCT FROM a.column_name
            OR e.ordinal_position IS DISTINCT FROM a.ordinal_position
            THEN 'PRIMARY_KEY_MISMATCH'
        ELSE 'MATCH'
    END AS contract_status
FROM expected_primary_keys e
FULL OUTER JOIN actual_primary_keys a
    ON e.table_name = a.table_name
   AND e.column_name = a.column_name;

CREATE OR REPLACE VIEW index_contract_report AS
WITH expected_indexes (
    index_name,
    table_name,
    indexed_columns,
    is_unique
) AS (
    VALUES
        ('users_email_idx', 'users', ARRAY['email']::TEXT[], FALSE),
        (
            'addresses_user_id_idx',
            'addresses',
            ARRAY['user_id']::TEXT[],
            FALSE
        ),
        ('orders_user_id_idx', 'orders', ARRAY['user_id']::TEXT[], FALSE),
        (
            'payments_order_id_idx',
            'payments',
            ARRAY['order_id']::TEXT[],
            FALSE
        )
),
actual_indexes AS (
    SELECT
        index_class.relname::TEXT AS index_name,
        table_class.relname::TEXT AS table_name,
        ARRAY_AGG(
            attribute.attname::TEXT
            ORDER BY index_column.ordinality
        ) AS indexed_columns,
        index_metadata.indisunique AS is_unique
    FROM pg_index index_metadata
    INNER JOIN pg_class table_class
        ON table_class.oid = index_metadata.indrelid
    INNER JOIN pg_namespace table_namespace
        ON table_namespace.oid = table_class.relnamespace
    INNER JOIN pg_class index_class
        ON index_class.oid = index_metadata.indexrelid
    CROSS JOIN LATERAL UNNEST(index_metadata.indkey)
        WITH ORDINALITY AS index_column(attribute_number, ordinality)
    INNER JOIN pg_attribute attribute
        ON attribute.attrelid = table_class.oid
       AND attribute.attnum = index_column.attribute_number
    WHERE table_namespace.nspname = CURRENT_SCHEMA()
      AND table_class.relname IN ('users', 'addresses', 'orders', 'payments')
      AND index_metadata.indisprimary = FALSE
    GROUP BY
        index_class.relname,
        table_class.relname,
        index_metadata.indisunique
)
SELECT
    COALESCE(e.index_name, a.index_name) AS index_name,
    e.table_name AS expected_table_name,
    a.table_name AS actual_table_name,
    e.indexed_columns AS expected_indexed_columns,
    a.indexed_columns AS actual_indexed_columns,
    e.is_unique AS expected_is_unique,
    a.is_unique AS actual_is_unique,
    CASE
        WHEN e.index_name IS NULL THEN 'UNEXPECTED_INDEX'
        WHEN a.index_name IS NULL THEN 'MISSING_INDEX'
        WHEN e.table_name IS DISTINCT FROM a.table_name
            OR e.indexed_columns IS DISTINCT FROM a.indexed_columns
            OR e.is_unique IS DISTINCT FROM a.is_unique
            THEN 'INDEX_DEFINITION_MISMATCH'
        ELSE 'MATCH'
    END AS contract_status
FROM expected_indexes e
FULL OUTER JOIN actual_indexes a
    ON e.index_name = a.index_name;

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

CREATE OR REPLACE VIEW data_quality_rule_report AS
WITH rule_results (
    rule_id,
    rule_description,
    severity,
    expected_issue_count,
    actual_issue_count
) AS (
    SELECT
        'duplicate_user_email',
        'User email addresses should be unique',
        'HIGH',
        1::BIGINT,
        (
            SELECT COUNT(*)
            FROM (
                SELECT email
                FROM users
                GROUP BY email
                HAVING COUNT(*) > 1
            ) duplicate_emails
        )

    UNION ALL

    SELECT
        'orphan_address',
        'Addresses should reference existing users',
        'HIGH',
        1::BIGINT,
        (
            SELECT COUNT(*)
            FROM addresses a
            LEFT JOIN users u
                ON a.user_id = u.id
            WHERE u.id IS NULL
        )

    UNION ALL

    SELECT
        'orphan_order',
        'Orders should reference existing users',
        'CRITICAL',
        1::BIGINT,
        (
            SELECT COUNT(*)
            FROM orders o
            LEFT JOIN users u
                ON o.user_id = u.id
            WHERE u.id IS NULL
        )

    UNION ALL

    SELECT
        'orphan_payment',
        'Payments should reference existing orders',
        'CRITICAL',
        1::BIGINT,
        (
            SELECT COUNT(*)
            FROM payments p
            LEFT JOIN orders o
                ON p.order_id = o.id
            WHERE o.id IS NULL
        )

    UNION ALL

    SELECT
        'non_positive_order_amount',
        'Order amounts should be greater than zero',
        'CRITICAL',
        1::BIGINT,
        (
            SELECT COUNT(*)
            FROM orders
            WHERE amount <= 0
        )

    UNION ALL

    SELECT
        'missing_user_age',
        'User age should be available for validation',
        'LOW',
        1::BIGINT,
        (
            SELECT COUNT(*)
            FROM users
            WHERE age IS NULL
        )

    UNION ALL

    SELECT
        'payment_amount_mismatch',
        'Successful payment amount should match order amount',
        'CRITICAL',
        1::BIGINT,
        (
            SELECT COUNT(*)
            FROM orders o
            INNER JOIN payments p
                ON o.id = p.order_id
            WHERE p.status = 'SUCCESS'
              AND o.amount <> p.amount
        )

    UNION ALL

    SELECT
        'successful_payment_without_timestamp',
        'Successful payments should include a payment timestamp',
        'HIGH',
        0::BIGINT,
        (
            SELECT COUNT(*)
            FROM payments
            WHERE status = 'SUCCESS'
              AND paid_at IS NULL
        )

    UNION ALL

    SELECT
        'active_user_without_primary_address',
        'Active users should have a primary address',
        'MEDIUM',
        2::BIGINT,
        (
            SELECT COUNT(*)
            FROM users u
            LEFT JOIN addresses a
                ON u.id = a.user_id
               AND a.is_primary = TRUE
            WHERE u.status = 'ACTIVE'
              AND u.deleted_at IS NULL
              AND a.id IS NULL
        )

    UNION ALL

    SELECT
        'paid_order_without_successful_payment',
        'Paid orders should have a successful payment',
        'CRITICAL',
        1::BIGINT,
        (
            SELECT COUNT(*)
            FROM orders o
            LEFT JOIN payments p
                ON o.id = p.order_id
               AND p.status = 'SUCCESS'
            WHERE o.status = 'PAID'
              AND p.id IS NULL
        )

    UNION ALL

    SELECT
        'user_deleted_before_created',
        'User deletion timestamps should not precede creation timestamps',
        'HIGH',
        0::BIGINT,
        (
            SELECT COUNT(*)
            FROM users
            WHERE deleted_at < created_at
        )

    UNION ALL

    SELECT
        'address_created_before_user',
        'Addresses should not be created before their users',
        'HIGH',
        0::BIGINT,
        (
            SELECT COUNT(*)
            FROM addresses a
            INNER JOIN users u
                ON a.user_id = u.id
            WHERE a.created_at < u.created_at
        )

    UNION ALL

    SELECT
        'order_created_before_user',
        'Orders should not be created before their users',
        'CRITICAL',
        0::BIGINT,
        (
            SELECT COUNT(*)
            FROM orders o
            INNER JOIN users u
                ON o.user_id = u.id
            WHERE o.created_at < u.created_at
        )

    UNION ALL

    SELECT
        'payment_created_before_order',
        'Payment timestamps should not precede order creation timestamps',
        'CRITICAL',
        0::BIGINT,
        (
            SELECT COUNT(*)
            FROM payments p
            INNER JOIN orders o
                ON p.order_id = o.id
            WHERE p.paid_at < o.created_at
        )

    UNION ALL

    SELECT
        'invalid_user_status',
        'User status should use an approved domain value',
        'HIGH',
        0::BIGINT,
        (
            SELECT COUNT(*)
            FROM users
            WHERE status NOT IN ('ACTIVE', 'INACTIVE', 'DELETED')
        )

    UNION ALL

    SELECT
        'invalid_order_status',
        'Order status should use an approved domain value',
        'HIGH',
        0::BIGINT,
        (
            SELECT COUNT(*)
            FROM orders
            WHERE status NOT IN ('NEW', 'PAID', 'SHIPPED', 'CANCELLED')
        )

    UNION ALL

    SELECT
        'invalid_payment_status',
        'Payment status should use an approved domain value',
        'HIGH',
        0::BIGINT,
        (
            SELECT COUNT(*)
            FROM payments
            WHERE status NOT IN ('SUCCESS', 'PENDING', 'REFUNDED', 'FAILED')
        )

    UNION ALL

    SELECT
        'invalid_payment_method',
        'Payment method should use an approved domain value',
        'MEDIUM',
        0::BIGINT,
        (
            SELECT COUNT(*)
            FROM payments
            WHERE payment_method NOT IN ('CARD', 'PAYPAL', 'BANK_TRANSFER')
        )
)
SELECT
    rule_id,
    rule_description,
    severity,
    expected_issue_count,
    actual_issue_count,
    actual_issue_count - expected_issue_count AS issue_count_delta,
    CASE
        WHEN actual_issue_count = expected_issue_count THEN 'MATCH'
        WHEN actual_issue_count > expected_issue_count THEN 'REGRESSION'
        ELSE 'IMPROVEMENT'
    END AS baseline_status
FROM rule_results;

CREATE OR REPLACE VIEW data_quality_rule_summary AS
SELECT
    severity,
    COUNT(*) AS rule_count,
    SUM(expected_issue_count) AS expected_issue_count,
    SUM(actual_issue_count) AS actual_issue_count,
    SUM(issue_count_delta) AS issue_count_delta,
    COUNT(*) FILTER (
        WHERE baseline_status <> 'MATCH'
    ) AS deviation_count
FROM data_quality_rule_report
GROUP BY severity;
