# Database Schema Contracts

Schema contracts make structural database changes visible during regression
testing. The lab checks both column definitions and primary keys before running
view and query tests.

## Column contract

The `column_schema_contract_report` view compares the expected table structure
with PostgreSQL metadata from `information_schema.columns`.

It validates:

- Column presence.
- Column order.
- PostgreSQL data type.
- Character length.
- Numeric precision and scale.
- Nullability.

Possible results include `MATCH`, `MISSING_COLUMN`, `UNEXPECTED_COLUMN`,
`POSITION_MISMATCH`, `TYPE_MISMATCH`, and `NULLABILITY_MISMATCH`.

## Primary key contract

The `primary_key_contract_report` view compares expected primary key columns
with the constraints registered by PostgreSQL. It detects missing, unexpected,
or changed primary keys.

## Review deviations

Run:

```bash
psql -d qa-sql-lab -f queries/schema_validation_queries.sql
```

The first two result sets should be empty. The final result set prints the
complete current column contract for migration review.

## Update after an intentional migration

1. Change the table definition in `datasets/schema.sql`.
2. Update the expected metadata in `datasets/views.sql`.
3. Update the expected contract counts when columns or tables are added.
4. Add representative data and query coverage where needed.
5. Run `tests/run_all.sql` against an empty PostgreSQL database.

Keeping the schema definition and its contract in the same change makes
intentional migrations explicit and accidental drift easy to diagnose.
