-- Data quality baseline contract tests

DO $$
DECLARE
    actual_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO actual_count
    FROM data_quality_rule_report;

    IF actual_count <> 20 THEN
        RAISE EXCEPTION 'Expected 20 data quality rules, found %', actual_count;
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

    IF actual_count <> 7 THEN
        RAISE EXCEPTION 'Expected 7 critical data quality rules, found %', actual_count;
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

    SELECT SUM(actual_issue_count)
    INTO actual_count
    FROM data_quality_rule_report
    WHERE rule_id IN (
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

    IF actual_count <> 7 THEN
        RAISE EXCEPTION
            'Expected 7 critical summary rules, found %',
            actual_count;
    END IF;

    SELECT rule_count
    INTO actual_count
    FROM data_quality_rule_summary
    WHERE severity = 'HIGH';

    IF actual_count <> 9 THEN
        RAISE EXCEPTION
            'Expected 9 high severity summary rules, found %',
            actual_count;
    END IF;

    SELECT rule_count
    INTO actual_count
    FROM data_quality_rule_summary
    WHERE severity = 'MEDIUM';

    IF actual_count <> 3 THEN
        RAISE EXCEPTION
            'Expected 3 medium severity summary rules, found %',
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
