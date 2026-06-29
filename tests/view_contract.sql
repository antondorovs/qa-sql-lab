-- View contract tests

DO $$
DECLARE
    actual_count INTEGER;
    actual_total NUMERIC(10, 2);
BEGIN
    SELECT COUNT(*)
    INTO actual_count
    FROM active_user_order_summary;

    IF actual_count <> 6 THEN
        RAISE EXCEPTION 'Expected 6 active users in summary, found %', actual_count;
    END IF;

    SELECT order_count, total_order_amount
    INTO actual_count, actual_total
    FROM active_user_order_summary
    WHERE user_id = 1;

    IF actual_count <> 2 OR actual_total <> 195.50 THEN
        RAISE EXCEPTION
            'Unexpected summary for user 1: order_count=%, total=%',
            actual_count,
            actual_total;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM active_user_order_summary
    WHERE order_count = 0;

    IF actual_count <> 1 THEN
        RAISE EXCEPTION 'Expected 1 active user without orders, found %', actual_count;
    END IF;
END
$$;

DO $$
DECLARE
    actual_count INTEGER;
    actual_with_payment_count INTEGER;
    actual_successful_payment_count INTEGER;
    actual_without_payment_count INTEGER;
    actual_total NUMERIC(10, 2);
BEGIN
    SELECT COUNT(*)
    INTO actual_count
    FROM order_status_payment_summary;

    IF actual_count <> 4 THEN
        RAISE EXCEPTION
            'Expected 4 order status payment summary rows, found %',
            actual_count;
    END IF;

    SELECT
        order_count,
        total_order_amount,
        orders_with_payment_count,
        orders_with_successful_payment_count,
        orders_without_payment_count
    INTO
        actual_count,
        actual_total,
        actual_with_payment_count,
        actual_successful_payment_count,
        actual_without_payment_count
    FROM order_status_payment_summary
    WHERE order_status = 'PAID';

    IF actual_count <> 4
        OR actual_total <> 365.50
        OR actual_with_payment_count <> 3
        OR actual_successful_payment_count <> 3
        OR actual_without_payment_count <> 1 THEN
        RAISE EXCEPTION
            'Unexpected PAID summary: orders=%, total=%, with_payment=%, successful=%, without_payment=%',
            actual_count,
            actual_total,
            actual_with_payment_count,
            actual_successful_payment_count,
            actual_without_payment_count;
    END IF;

    SELECT
        order_count,
        total_order_amount,
        orders_with_successful_payment_count
    INTO actual_count, actual_total, actual_successful_payment_count
    FROM order_status_payment_summary
    WHERE order_status = 'NEW';

    IF actual_count <> 2
        OR actual_total <> 85.89
        OR actual_successful_payment_count <> 0 THEN
        RAISE EXCEPTION
            'Unexpected NEW summary: orders=%, total=%, successful=%',
            actual_count,
            actual_total,
            actual_successful_payment_count;
    END IF;
END
$$;

DO $$
DECLARE
    actual_count INTEGER;
    actual_active_count INTEGER;
    actual_primary_count INTEGER;
    actual_missing_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO actual_count
    FROM primary_address_coverage_summary;

    IF actual_count <> 4 THEN
        RAISE EXCEPTION
            'Expected 4 primary address coverage summary rows, found %',
            actual_count;
    END IF;

    SELECT active_user_count, primary_address_count, users_without_primary_address_count
    INTO actual_active_count, actual_primary_count, actual_missing_count
    FROM primary_address_coverage_summary
    WHERE country = 'Hungary';

    IF actual_active_count <> 2
        OR actual_primary_count <> 1
        OR actual_missing_count <> 1 THEN
        RAISE EXCEPTION
            'Unexpected Hungary address coverage: active=%, primary=%, missing=%',
            actual_active_count,
            actual_primary_count,
            actual_missing_count;
    END IF;

    SELECT active_user_count, primary_address_count, users_without_primary_address_count
    INTO actual_active_count, actual_primary_count, actual_missing_count
    FROM primary_address_coverage_summary
    WHERE country = 'USA';

    IF actual_active_count <> 2
        OR actual_primary_count <> 2
        OR actual_missing_count <> 0 THEN
        RAISE EXCEPTION
            'Unexpected USA address coverage: active=%, primary=%, missing=%',
            actual_active_count,
            actual_primary_count,
            actual_missing_count;
    END IF;
END
$$;

DO $$
DECLARE
    actual_count INTEGER;
    actual_active_count INTEGER;
    actual_order_count INTEGER;
    actual_without_orders_count INTEGER;
    actual_total NUMERIC(10, 2);
BEGIN
    SELECT COUNT(*)
    INTO actual_count
    FROM country_user_order_summary;

    IF actual_count <> 4 THEN
        RAISE EXCEPTION
            'Expected 4 country user order summary rows, found %',
            actual_count;
    END IF;

    SELECT user_count, active_user_count, order_count, total_order_amount
    INTO actual_count, actual_active_count, actual_order_count, actual_total
    FROM country_user_order_summary
    WHERE country = 'USA';

    IF actual_count <> 2
        OR actual_active_count <> 2
        OR actual_order_count <> 3
        OR actual_total <> 175.50 THEN
        RAISE EXCEPTION
            'Unexpected USA country summary: users=%, active=%, orders=%, total=%',
            actual_count,
            actual_active_count,
            actual_order_count,
            actual_total;
    END IF;

    SELECT active_user_count, users_without_orders_count
    INTO actual_active_count, actual_without_orders_count
    FROM country_user_order_summary
    WHERE country = 'Canada';

    IF actual_active_count <> 2 OR actual_without_orders_count <> 1 THEN
        RAISE EXCEPTION
            'Unexpected Canada country summary: active=%, without_orders=%',
            actual_active_count,
            actual_without_orders_count;
    END IF;
END
$$;

DO $$
DECLARE
    actual_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO actual_count
    FROM order_payment_validation;

    IF actual_count <> 9 THEN
        RAISE EXCEPTION 'Expected 9 validation rows, found %', actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM order_payment_validation
    WHERE qa_status = 'CONSISTENT';

    IF actual_count <> 5 THEN
        RAISE EXCEPTION 'Expected 5 consistent rows, found %', actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM order_payment_validation
    WHERE qa_status = 'MISSING_ORDER';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION 'Expected 1 missing order result, found %', actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM order_payment_validation
    WHERE qa_status = 'MISSING_USER';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION 'Expected 1 missing user result, found %', actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM order_payment_validation
    WHERE qa_status = 'AMOUNT_MISMATCH';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION 'Expected 1 amount mismatch result, found %', actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM order_payment_validation
    WHERE qa_status = 'ORDER_NOT_MARKED_PAID';

    IF actual_count <> 1 THEN
        RAISE EXCEPTION
            'Expected 1 order status mismatch result, found %',
            actual_count;
    END IF;
END
$$;

DO $$
DECLARE
    actual_count INTEGER;
    actual_missing_count INTEGER;
    actual_total NUMERIC(10, 2);
BEGIN
    SELECT COUNT(*)
    INTO actual_count
    FROM payment_method_summary;

    IF actual_count <> 3 THEN
        RAISE EXCEPTION
            'Expected 3 payment method summary rows, found %',
            actual_count;
    END IF;

    SELECT payment_count, total_payment_amount
    INTO actual_count, actual_total
    FROM payment_method_summary
    WHERE payment_method = 'CARD';

    IF actual_count <> 6 OR actual_total <> 515.40 THEN
        RAISE EXCEPTION
            'Unexpected CARD payment summary: count=%, total=%',
            actual_count,
            actual_total;
    END IF;

    SELECT pending_count, missing_paid_at_count
    INTO actual_count, actual_missing_count
    FROM payment_method_summary
    WHERE payment_method = 'BANK_TRANSFER';

    IF actual_count <> 1 OR actual_missing_count <> 1 THEN
        RAISE EXCEPTION
            'Unexpected BANK_TRANSFER payment summary: pending=%, missing_paid_at=%',
            actual_count,
            actual_missing_count;
    END IF;
END
$$;
