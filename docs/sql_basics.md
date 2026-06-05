# SQL Basics for QA

SQL is used by QA engineers to inspect application data, confirm business rules, and find data quality issues that are hard to see through the UI.

## Core query flow

```sql
SELECT column_name
FROM table_name
WHERE condition
GROUP BY column_name
HAVING aggregate_condition
ORDER BY column_name;
```

Key concepts:

- `SELECT` chooses the columns returned by the query.
- `WHERE` filters rows before grouping.
- `GROUP BY` groups rows for aggregate checks.
- `HAVING` filters grouped results.
- `ORDER BY` sorts the final result.
- `JOIN` combines related data from multiple tables.
- `CASE` creates conditional labels or categories.
- Subqueries let one query use the result of another query.
- Common table expressions name intermediate query results with `WITH`.
- Views expose reusable queries as virtual tables.
- Window functions calculate values across related rows without collapsing the result set.

## QA mindset

When validating data, do not only check happy paths. Look for missing records, duplicate values, invalid statuses, incorrect totals, orphan records, and impossible dates or amounts.

Useful QA habit: write validation queries so they return suspicious rows. Empty result sets are easier to treat as passing checks.
