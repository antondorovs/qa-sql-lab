# Data Quality Baselines

The `data_quality_rule_report` view turns reusable QA checks into a single
regression report. Each row represents one business rule and includes:

- A stable rule identifier and description.
- A severity level.
- The expected number of known issues in the training dataset.
- The current number of issues.
- The difference between current and expected results.
- A baseline status: `MATCH`, `REGRESSION`, or `IMPROVEMENT`.

## Why the baseline contains known issues

The sample dataset intentionally includes invalid records for SQL practice.
A clean result is therefore not always zero. The baseline records the expected
fixture count so that tests detect accidental changes without removing useful
QA scenarios.

The report also includes zero-tolerance temporal rules. These checks ensure
that creation, payment, and deletion timestamps follow a valid business-event
sequence. See `docs/temporal_data_validation.md` for the investigation
workflow.

Domain value rules validate status and payment-method fields against approved
sets. See `docs/domain_value_validation.md` for the allowed values and review
workflow.

## Review the report

Load the schema, data, and views, then run:

```sql
SELECT *
FROM data_quality_rule_report
ORDER BY severity, rule_id;
```

A `REGRESSION` means more suspicious records exist than expected. An
`IMPROVEMENT` means a known fixture disappeared. Both results require review
because either can make exercises and regression tests unreliable.

## Add a rule

1. Add a new branch to the `rule_results` CTE in `datasets/views.sql`.
2. Use a stable lowercase `rule_id`.
3. Set an explicit severity and expected issue count.
4. Add or update assertions in `tests/quality_report_contract.sql`.
5. Run `tests/run_all.sql` against an empty PostgreSQL database.

Keep detailed row-level investigation queries in
`queries/qa_validation_queries.sql`. The report is intended for fast triage;
the investigation queries provide the evidence behind each count.
