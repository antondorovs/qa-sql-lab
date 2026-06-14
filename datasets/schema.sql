-- QA SQL Lab PostgreSQL schema

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(120) NOT NULL,
    status VARCHAR(20) NOT NULL,
    country VARCHAR(60) NOT NULL,
    age INTEGER,
    created_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP
);

CREATE TABLE addresses (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    city VARCHAR(80) NOT NULL,
    country VARCHAR(60) NOT NULL,
    postal_code VARCHAR(20),
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    user_id INTEGER,
    order_number VARCHAR(30) NOT NULL,
    status VARCHAR(20) NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    created_at TIMESTAMP NOT NULL
);

CREATE TABLE payments (
    id INTEGER PRIMARY KEY,
    order_id INTEGER,
    payment_method VARCHAR(30) NOT NULL,
    status VARCHAR(20) NOT NULL,
    amount NUMERIC(10, 2) NOT NULL,
    paid_at TIMESTAMP
);

CREATE INDEX users_email_idx
    ON users (email);

CREATE INDEX addresses_user_id_idx
    ON addresses (user_id);

CREATE INDEX orders_user_id_idx
    ON orders (user_id);

CREATE INDEX payments_order_id_idx
    ON payments (order_id);
