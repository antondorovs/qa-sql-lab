-- Reset QA SQL Lab views and tables before reloading sample data.

DROP VIEW IF EXISTS data_quality_rule_summary;
DROP VIEW IF EXISTS data_quality_rule_report;
DROP VIEW IF EXISTS order_payment_validation;
DROP VIEW IF EXISTS active_user_order_summary;
DROP VIEW IF EXISTS primary_key_contract_report;
DROP VIEW IF EXISTS column_schema_contract_report;
DROP VIEW IF EXISTS index_contract_report;

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS users;
