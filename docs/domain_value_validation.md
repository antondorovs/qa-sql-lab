# Domain Value Validation

Domain value validation checks whether text fields use the small set of values
that the application and tests expect. These checks are useful when a database
does not enforce enum-like values with constraints yet.

## Allowed values

The data quality baseline checks these domains:

| Field | Allowed values |
| --- | --- |
| `users.status` | `ACTIVE`, `INACTIVE`, `DELETED` |
| `orders.status` | `NEW`, `PAID`, `SHIPPED`, `CANCELLED` |
| `payments.status` | `SUCCESS`, `PENDING`, `REFUNDED`, `FAILED` |
| `payments.payment_method` | `CARD`, `PAYPAL`, `BANK_TRANSFER` |

Each rule has an expected issue count of zero. Any unsupported value is a
regression because it can break filters, reports, and status-based assertions.

## Run the checks

Load the lab and review domain rule results:

```sql
SELECT
    rule_id,
    severity,
    actual_issue_count,
    baseline_status
FROM data_quality_rule_report
WHERE rule_id IN (
    'invalid_user_status',
    'invalid_order_status',
    'invalid_payment_status',
    'invalid_payment_method'
)
ORDER BY rule_id;
```

The detailed queries in `queries/qa_validation_queries.sql` return the affected
record identifiers and unsupported values.

## Testing guidance

When adding a new domain value:

1. Update the seed data only when the new value is intentional.
2. Update the expected allowed-value list in `datasets/views.sql`.
3. Add an investigation query when a new field needs domain validation.
4. Keep the expected issue count explicit.
5. Run `tests/run_all.sql` against an empty PostgreSQL database.
