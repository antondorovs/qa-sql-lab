-- Data quality baseline contract tests

DO $$
DECLARE
    actual_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report;

    IF actual_count <> 32 THEN
        RAISE EXCEPTION 'Expected 32 data quality rules, found %', actual_count;
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

    IF actual_count <> 8 THEN
        RAISE EXCEPTION 'Expected 8 critical data quality rules, found %', actual_count;
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
    WHERE rule_id = 'refunded_payment_without_timestamp';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no refunded payments without timestamps, found %',
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
    WHERE rule_id = 'pending_payment_with_timestamp';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no pending payments with timestamps, found %',
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

    SELECT SUM(actual_issue_count)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id IN (
        'deleted_user_without_timestamp',
        'non_deleted_user_with_timestamp',
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
    WHERE rule_id = 'duplicate_primary_address';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected no users with multiple primary addresses, found %',
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

    IF actual_count <> 8 THEN
        RAISE EXCEPTION
            'Expected 8 critical summary rules, found %',
            actual_count;
    END IF;

    SELECT rule_count
    INTO actual_count
    FROM data_quality_rule_summary
    WHERE severity = 'HIGH';

    IF actual_count <> 18 THEN
        RAISE EXCEPTION
            'Expected 18 high severity summary rules, found %',
            actual_count;
    END IF;

    SELECT rule_count
    INTO actual_count
    FROM data_quality_rule_summary
    WHERE severity = 'MEDIUM';

    IF actual_count <> 4 THEN
        RAISE EXCEPTION
            'Expected 4 medium severity summary rules, found %',
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
