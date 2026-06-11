-- Database schema validation queries

-- Column definitions that differ from the documented contract
SELECT *
FROM column_schema_contract_report
WHERE contract_status <> 'MATCH'
ORDER BY table_name, expected_ordinal_position, actual_ordinal_position;

-- Primary keys that differ from the documented contract
SELECT *
FROM primary_key_contract_report
WHERE contract_status <> 'MATCH'
ORDER BY table_name;

-- Complete column contract for review before a schema migration
SELECT
    table_name,
    column_name,
    actual_ordinal_position,
    actual_data_type,
    actual_character_maximum_length,
    actual_numeric_precision,
    actual_numeric_scale,
    actual_is_nullable,
    contract_status
FROM column_schema_contract_report
ORDER BY table_name, actual_ordinal_position;
