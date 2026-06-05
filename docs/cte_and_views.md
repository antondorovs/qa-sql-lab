# CTEs and Views for QA

Common table expressions and views help turn complex validation logic into readable, reusable SQL.

## Common table expressions

A CTE is a named result set available to one SQL statement:

```sql
WITH paid_orders AS (
    SELECT *
    FROM orders
    WHERE status = 'PAID'
)
SELECT *
FROM paid_orders
WHERE amount > 100;
```

Use CTEs to split multi-step validation into understandable stages. A recursive CTE can generate rows such as a date range, which is useful for detecting days with missing activity.

## Views

A view stores a query definition and exposes it like a table:

```sql
SELECT *
FROM order_payment_validation
WHERE qa_status <> 'CONSISTENT';
```

Views are useful when the same QA report is run repeatedly. `CREATE OR REPLACE VIEW` updates the definition without requiring a separate drop statement.

The lab provides:

- `active_user_order_summary` for active-user order metrics.
- `order_payment_validation` for missing orders or users, payment status, and amount checks.

Views do not store independent copies of these rows. Their results reflect the current data in the underlying tables.
