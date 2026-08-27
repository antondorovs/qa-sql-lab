-- Data quality baseline contract tests

DO $$
DECLARE
    actual_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report;

    IF actual_count <> 61 THEN
        RAISE EXCEPTION 'Expected 61 data quality rules, found %', actual_count;
    END IF;

    SELECT SUM(expected_issue_count)
    INTO actual_count
    FROM data_quality_rule_report;

    IF actual_count <> 17 THEN
        RAISE EXCEPTION
            'Expected 17 baseline issues across all data quality rules, found %',
            actual_count;
    END IF;

    SELECT SUM(actual_issue_count)
    INTO actual_count
    FROM data_quality_rule_report;

    IF actual_count <> 17 THEN
        RAISE EXCEPTION
            'Expected 17 actual issues across all data quality rules, found %',
            actual_count;
    END IF;

    SELECT SUM(issue_count_delta)
    INTO actual_count
    FROM data_quality_rule_report;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no net issue count delta across all data quality rules, found %',
            actual_count;
    END IF;

    SELECT COUNT(*) - COUNT(DISTINCT rule_id)
    INTO actual_count
    FROM data_quality_rule_report;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected unique data quality rule identifiers, found % duplicates',
            actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id !~ '^[a-z][a-z0-9]*(_[a-z0-9]+)*$';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected lowercase snake_case rule identifiers, found % invalid',
            actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE severity IS NULL
       OR severity NOT IN ('CRITICAL', 'HIGH', 'MEDIUM', 'LOW');

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected supported data quality severity values, found % invalid',
            actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_description IS NULL
       OR BTRIM(rule_description) = '';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected non-blank data quality rule descriptions, found % invalid',
            actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE actual_issue_count IS NULL
       OR actual_issue_count < 0;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected non-negative actual issue counts, found % invalid',
            actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE expected_issue_count IS NULL
       OR expected_issue_count < 0;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected non-negative baseline issue counts, found % invalid',
            actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE baseline_status IS NULL
       OR baseline_status NOT IN ('MATCH', 'REGRESSION', 'IMPROVEMENT');

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected supported data quality baseline statuses, found % invalid',
            actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE issue_count_delta IS NULL
       OR issue_count_delta <> actual_issue_count - expected_issue_count;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected accurate data quality issue count deltas, found % invalid',
            actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE baseline_status <> CASE
        WHEN issue_count_delta = 0 THEN 'MATCH'
        WHEN issue_count_delta > 0 THEN 'REGRESSION'
        ELSE 'IMPROVEMENT'
    END;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected baseline statuses to match issue count deltas, found % invalid',
            actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE baseline_status <> 'MATCH';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected every data quality rule to match its baseline, found % deviations',
            actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE severity = 'CRITICAL';

    IF actual_count <> 13 THEN
        RAISE EXCEPTION 'Expected 13 critical data quality rules, found %', actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE severity = 'HIGH';

    IF actual_count <> 35 THEN
        RAISE EXCEPTION 'Expected 35 high severity data quality rules, found %', actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE severity = 'MEDIUM';

    IF actual_count <> 11 THEN
        RAISE EXCEPTION 'Expected 11 medium severity data quality rules, found %', actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE severity = 'LOW';

    IF actual_count <> 2 THEN
        RAISE EXCEPTION 'Expected 2 low severity data quality rules, found %', actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'non_positive_order_amount';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION
            'Expected 1 order with a non-positive amount, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'orphan_payment';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION
            'Expected 1 payment without an existing order, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'orphan_order';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION
            'Expected 1 order without an existing user, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'orphan_address';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION
            'Expected 1 address without an existing user, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'non_positive_payment_amount';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no payments with non-positive amounts, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'payment_amount_mismatch';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION
            'Expected 1 successful payment amount mismatch, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'duplicate_user_email';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION
            'Expected 1 duplicated user email value, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'invalid_user_email_format';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no users with invalid email format, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'blank_user_name';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no users with blank names, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'blank_address_city';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no addresses with blank cities, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'blank_address_country';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no addresses with blank countries, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'blank_user_country';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no users with blank countries, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'blank_order_number';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no orders with blank order numbers, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'blank_payment_method';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no payments with blank methods, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'blank_payment_status';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no payments with blank statuses, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'blank_order_status';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no orders with blank statuses, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'blank_user_status';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no users with blank statuses, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'successful_payment_without_timestamp';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no successful payments without timestamps, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'successful_payment_for_non_payable_order';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no successful payments for non-payable orders, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'refunded_payment_without_timestamp';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no refunded payments without timestamps, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'refunded_payment_for_non_cancelled_order';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no refunded payments for non-cancelled orders, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'failed_payment_with_timestamp';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no failed payments with timestamps, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'failed_payment_for_non_new_order';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no failed payments for non-new orders, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'pending_payment_with_timestamp';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no pending payments with timestamps, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'pending_payment_for_non_new_order';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no pending payments for non-new orders, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'missing_address_postal_code';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no addresses without postal codes, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'missing_user_age';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION
            'Expected 1 user without an age, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'non_positive_user_age';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no users with non-positive ages, found %',
            actual_count;
    END IF;

    SELECT SUM(actual_issue_count)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id IN (
        'deleted_user_without_timestamp',
        'non_deleted_user_with_timestamp',
        'deleted_user_with_orders',
        'deleted_user_with_addresses',
        'user_deleted_before_created',
        'address_created_before_user',
        'order_created_before_user',
        'payment_created_before_order'
    );

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no temporal consistency issues, found %',
            actual_count;
    END IF;

    SELECT SUM(actual_issue_count)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id IN (
        'invalid_user_status',
        'invalid_order_status',
        'invalid_payment_status',
        'invalid_payment_method'
    );

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no domain value issues, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'payment_method_without_success';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION
            'Expected 1 payment method without successful payments, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'successful_payment_without_order';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION
            'Expected 1 successful payment without an order, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'refunded_payment_without_order';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no refunded payments without orders, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'failed_payment_without_order';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no failed payments without orders, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'pending_payment_without_order';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no pending payments without orders, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'duplicate_primary_address';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no users with multiple primary addresses, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'multiple_payments_for_order';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no orders with multiple payments, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'address_country_mismatch';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no address country mismatches, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'active_user_under_minimum_age';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION
            'Expected 1 active user under the minimum age, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'active_user_without_primary_address';

    IF actual_count <> 2 THEN
        RAISE EXCEPTION
            'Expected 2 active users without primary addresses, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'active_user_without_orders';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION
            'Expected 1 active user without orders, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'country_without_orders';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no countries without order coverage, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'country_with_user_order_gap';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION
            'Expected 1 country with users without orders, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'country_without_primary_addresses';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no countries without primary address coverage, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'active_country_primary_address_gap';

    IF actual_count <> 2 THEN
        RAISE EXCEPTION
            'Expected 2 countries with incomplete primary address coverage, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'duplicate_order_number';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no duplicate order numbers, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'cancelled_order_with_successful_payment';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no cancelled orders with successful payments, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'cancelled_order_without_refunded_payment';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no cancelled orders without refunded payments, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'new_order_with_successful_payment';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no new orders with successful payments, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'paid_order_without_successful_payment';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION
            'Expected 1 paid order without a successful payment, found %',
            actual_count;
    END IF;

    SELECT actual_issue_count
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id = 'shipped_order_without_successful_payment';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no shipped orders without successful payments, found %',
            actual_count;
    END IF;

    WITH expected_columns(column_name, ordinal_position) AS (
        VALUES
            ('rule_id', 1),
            ('rule_description', 2),
            ('severity', 3),
            ('expected_issue_count', 4),
            ('actual_issue_count', 5),
            ('issue_count_delta', 6),
            ('baseline_status', 7)
    ),
    actual_columns AS (
        SELECT column_name, ordinal_position
        FROM information_schema.columns
        WHERE table_schema = CURRENT_SCHEMA()
          AND table_name = 'data_quality_rule_report'
    )
    SELECT COUNT(*)
    INTO actual_count
    FROM expected_columns AS expected
    FULL JOIN actual_columns AS actual
        USING (column_name, ordinal_position)
    WHERE expected.column_name IS NULL
       OR actual.column_name IS NULL;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected the data quality rule report column layout, found % invalid',
            actual_count;
    END IF;

    WITH expected_types(column_name, data_type) AS (
        VALUES
            ('rule_id', 'text'),
            ('rule_description', 'text'),
            ('severity', 'text'),
            ('expected_issue_count', 'bigint'),
            ('actual_issue_count', 'bigint'),
            ('issue_count_delta', 'bigint'),
            ('baseline_status', 'text')
    ),
    actual_types AS (
        SELECT column_name, data_type
        FROM information_schema.columns
        WHERE table_schema = CURRENT_SCHEMA()
          AND table_name = 'data_quality_rule_report'
    )
    SELECT COUNT(*)
    INTO actual_count
    FROM expected_types AS expected
    FULL JOIN actual_types AS actual USING (column_name, data_type)
    WHERE expected.column_name IS NULL
       OR actual.column_name IS NULL;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected the data quality rule report column types, found % invalid',
            actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_summary;

    IF actual_count <> 4 THEN
        RAISE EXCEPTION
            'Expected 4 severity summary rows, found %',
            actual_count;
    END IF;

    SELECT SUM(rule_count)
    INTO actual_count
    FROM data_quality_rule_summary;

    IF actual_count <> 61 THEN
        RAISE EXCEPTION
            'Expected 61 rules across all severity summaries, found %',
            actual_count;
    END IF;

    WITH expected_severities(severity) AS (
        VALUES ('CRITICAL'), ('HIGH'), ('MEDIUM'), ('LOW')
    )
    SELECT COUNT(*)
    INTO actual_count
    FROM expected_severities AS expected
    FULL JOIN data_quality_rule_summary AS summary USING (severity)
    WHERE expected.severity IS NULL
       OR summary.severity IS NULL;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected every supported severity in the summary, found % invalid',
            actual_count;
    END IF;

    WITH expected_columns(column_name, ordinal_position) AS (
        VALUES
            ('severity', 1),
            ('rule_count', 2),
            ('expected_issue_count', 3),
            ('actual_issue_count', 4),
            ('issue_count_delta', 5),
            ('deviation_count', 6)
    ),
    actual_columns AS (
        SELECT column_name, ordinal_position
        FROM information_schema.columns
        WHERE table_schema = CURRENT_SCHEMA()
          AND table_name = 'data_quality_rule_summary'
    )
    SELECT COUNT(*)
    INTO actual_count
    FROM expected_columns AS expected
    FULL JOIN actual_columns AS actual
        USING (column_name, ordinal_position)
    WHERE expected.column_name IS NULL
       OR actual.column_name IS NULL;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected the data quality summary column layout, found % invalid',
            actual_count;
    END IF;

    WITH expected_types(column_name, data_type) AS (
        VALUES
            ('severity', 'text'),
            ('rule_count', 'bigint'),
            ('expected_issue_count', 'numeric'),
            ('actual_issue_count', 'numeric'),
            ('issue_count_delta', 'numeric'),
            ('deviation_count', 'bigint')
    ),
    actual_types AS (
        SELECT column_name, data_type
        FROM information_schema.columns
        WHERE table_schema = CURRENT_SCHEMA()
          AND table_name = 'data_quality_rule_summary'
    )
    SELECT COUNT(*)
    INTO actual_count
    FROM expected_types AS expected
    FULL JOIN actual_types AS actual USING (column_name, data_type)
    WHERE expected.column_name IS NULL
       OR actual.column_name IS NULL;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected the data quality summary column types, found % invalid',
            actual_count;
    END IF;

    WITH report_summary AS (
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
        GROUP BY severity
    )
    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_summary AS summary
    FULL JOIN report_summary AS report USING (severity)
    WHERE summary.rule_count IS DISTINCT FROM report.rule_count
       OR summary.expected_issue_count IS DISTINCT FROM report.expected_issue_count
       OR summary.actual_issue_count IS DISTINCT FROM report.actual_issue_count
       OR summary.issue_count_delta IS DISTINCT FROM report.issue_count_delta
       OR summary.deviation_count IS DISTINCT FROM report.deviation_count;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected severity summary aggregates to match the rule report, found % invalid',
            actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_summary
    WHERE rule_count IS NULL
       OR rule_count <= 0
       OR expected_issue_count IS NULL
       OR expected_issue_count < 0
       OR actual_issue_count IS NULL
       OR actual_issue_count < 0
       OR issue_count_delta IS NULL
       OR deviation_count IS NULL
       OR deviation_count < 0
       OR deviation_count > rule_count;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected valid severity summary counts, found % invalid',
            actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_summary
    WHERE issue_count_delta IS DISTINCT FROM
        actual_issue_count - expected_issue_count;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected accurate severity summary issue count deltas, found % invalid',
            actual_count;
    END IF;

    SELECT rule_count
    INTO actual_count
    FROM data_quality_rule_summary
    WHERE severity = 'CRITICAL';

    IF actual_count <> 13 THEN
        RAISE EXCEPTION
            'Expected 13 critical summary rules, found %',
            actual_count;
    END IF;

    SELECT rule_count
    INTO actual_count
    FROM data_quality_rule_summary
    WHERE severity = 'HIGH';

    IF actual_count <> 35 THEN
        RAISE EXCEPTION
            'Expected 35 high severity summary rules, found %',
            actual_count;
    END IF;

    SELECT rule_count
    INTO actual_count
    FROM data_quality_rule_summary
    WHERE severity = 'MEDIUM';

    IF actual_count <> 11 THEN
        RAISE EXCEPTION
            'Expected 11 medium severity summary rules, found %',
            actual_count;
    END IF;

    SELECT rule_count
    INTO actual_count
    FROM data_quality_rule_summary
    WHERE severity = 'LOW';

    IF actual_count <> 2 THEN
        RAISE EXCEPTION
            'Expected 2 low severity summary rules, found %',
            actual_count;
    END IF;

    WITH expected_counts(severity, expected_issue_count) AS (
        VALUES
            ('CRITICAL', 6::NUMERIC),
            ('HIGH', 2::NUMERIC),
            ('MEDIUM', 8::NUMERIC),
            ('LOW', 1::NUMERIC)
    )
    SELECT COUNT(*)
    INTO actual_count
    FROM expected_counts AS expected
    FULL JOIN data_quality_rule_summary AS summary USING (severity)
    WHERE expected.severity IS NULL
       OR summary.severity IS NULL
       OR summary.expected_issue_count IS DISTINCT FROM
          expected.expected_issue_count;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected severity baseline issue counts, found % invalid',
            actual_count;
    END IF;

    WITH expected_counts(severity, actual_issue_count) AS (
        VALUES
            ('CRITICAL', 6::NUMERIC),
            ('HIGH', 2::NUMERIC),
            ('MEDIUM', 8::NUMERIC),
            ('LOW', 1::NUMERIC)
    )
    SELECT COUNT(*)
    INTO actual_count
    FROM expected_counts AS expected
    FULL JOIN data_quality_rule_summary AS summary USING (severity)
    WHERE expected.severity IS NULL
       OR summary.severity IS NULL
       OR summary.actual_issue_count IS DISTINCT FROM
          expected.actual_issue_count;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected severity actual issue counts, found % invalid',
            actual_count;
    END IF;

    WITH expected_deltas(severity, issue_count_delta) AS (
        VALUES
            ('CRITICAL', 0::NUMERIC),
            ('HIGH', 0::NUMERIC),
            ('MEDIUM', 0::NUMERIC),
            ('LOW', 0::NUMERIC)
    )
    SELECT COUNT(*)
    INTO actual_count
    FROM expected_deltas AS expected
    FULL JOIN data_quality_rule_summary AS summary USING (severity)
    WHERE expected.severity IS NULL
       OR summary.severity IS NULL
       OR summary.issue_count_delta IS DISTINCT FROM
          expected.issue_count_delta;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected severity issue count deltas, found % invalid',
            actual_count;
    END IF;

    SELECT SUM(deviation_count)
    INTO actual_count
    FROM data_quality_rule_summary;

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no summary deviations, found %',
            actual_count;
    END IF;
END
$$;
