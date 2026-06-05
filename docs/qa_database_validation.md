# QA Database Validation Notes

Database validation checks whether stored data matches expected application behavior and business rules.

## Common QA checks

- Duplicate business identifiers, such as repeated emails or order numbers.
- Orphan records, such as orders without existing users.
- Missing required values, such as users without age or payments without payment dates.
- Invalid numeric values, such as negative order amounts.
- Status mismatches, such as a paid order without a successful payment.
- Amount mismatches, such as payment totals that differ from order totals.
- Unexpected lifecycle transitions, such as `PAID` orders without successful payments.
- Test data cleanup risks, such as manual updates made outside a transaction.

## Practical workflow

1. Understand the expected rule.
2. Identify the source tables and join keys.
3. Write a query that returns only suspicious rows.
4. Confirm whether each result is a real defect, expected test data, or a data setup issue.
5. Save useful validation queries so they can be reused in regression testing.

## Query types worth practicing

- Filters for single-table checks.
- JOINs for relationship checks.
- Aggregations for duplicate and total checks.
- Subqueries for existence and threshold checks.
- CTEs for readable multi-stage validation.
- Views for reusable QA reports.
- CASE expressions for categorizing risky records.
- Window functions for ordering, ranking, and sequence validation.
