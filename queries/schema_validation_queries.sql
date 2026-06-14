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

-- Indexes that differ from the documented contract
SELECT *
FROM index_contract_report
WHERE contract_status <> 'MATCH'
ORDER BY index_name;

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

-- Complete index contract for performance review
SELECT
    index_name,
    actual_table_name,
    actual_indexed_columns,
    actual_is_unique,
    contract_status
FROM index_contract_report
ORDER BY index_name;
