-- Database schema contract tests

DO $$
DECLARE
    actual_count INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO actual_count
    FROM column_schema_contract_report;

    IF actual_count <> 28 THEN
        RAISE EXCEPTION 'Expected 28 column contracts, found %', actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM column_schema_contract_report
    WHERE contract_status <> 'MATCH';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected every column contract to match, found % deviations',
            actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM primary_key_contract_report;

    IF actual_count <> 4 THEN
        RAISE EXCEPTION 'Expected 4 primary key contracts, found %', actual_count;
    END IF;

    SELECT COUNT(*)
    INTO actual_count
    FROM primary_key_contract_report
    WHERE contract_status <> 'MATCH';

    IF actual_count <> 0 THEN
        RAISE EXCEPTION
            'Expected every primary key contract to match, found % deviations',
            actual_count;
    END IF;
END
$$;
