-- Reset QA SQL Lab views and tables before reloading sample data.

DROP VIEW IF EXISTS order_payment_validation;
DROP VIEW IF EXISTS active_user_order_summary;

DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS users;
