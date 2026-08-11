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

    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_summary;

    IF actual_count <> 4 THEN
        RAISE EXCEPTION
            'Expected 4 severity summary rows, found %',
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
