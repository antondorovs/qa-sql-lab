# QA SQL Lab

SQL learning repository focused on QA Engineering and PostgreSQL database validation practice.

## Purpose

This project is a small hands-on lab for learning SQL through realistic QA scenarios. It uses an e-commerce style dataset with users, addresses, orders, and payments.

The sample data includes both valid rows and intentional data quality problems, such as duplicate emails, orphan records, missing values, and invalid amounts.

## Structure

```text
datasets/
  reset.sql       -- drop lab views and tables
  schema.sql      -- create PostgreSQL tables
  seed_data.sql   -- insert sample data
  views.sql       -- create reusable QA views

docs/
  sql_basics.md
  qa_database_validation.md
  postgresql_qa_tips.md
  cte_and_views.md

queries/
  filters.sql
  aggregations.sql
  assertions.sql
  case_expressions.sql
  cte.sql
  joins.sql
  subqueries.sql
  tasks.sql
  solutions.sql
  transactions.sql
  window_functions.sql
  qa_validation_queries.sql
```

## How to Run

From a PostgreSQL database:

```bash
psql -d qa_sql_lab -f datasets/reset.sql
psql -d qa_sql_lab -f datasets/schema.sql
psql -d qa_sql_lab -f datasets/seed_data.sql
psql -d qa_sql_lab -f datasets/views.sql
```

Then run examples or validation checks:

```bash
psql -d qa_sql_lab -f queries/qa_validation_queries.sql
```

## Topics

- SQL basics
- Filtering and sorting
- Aggregations
- JOINs
- Subqueries
- Common table expressions
- Recursive CTEs
- PostgreSQL views
- CASE expressions
- Window functions
- Transaction safety
- Data quality checks
- QA database validation
- PostgreSQL practice

## Git Workflow

After completing a task:

```bash
git add .
git commit -m "Describe the SQL lab change"
git push origin main
git push gitlab main
```
