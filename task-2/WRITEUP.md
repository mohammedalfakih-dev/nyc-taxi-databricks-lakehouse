# Task 2 write-up: incremental build timings & Delta history

## First build (full refresh)

- **Wall-clock time:** 20.404 seconds
- **Result:** Completed successfully against `hyf-dbt-warehouse`.

## Second build (incremental rerun)

- **Wall-clock time:** 16.735 seconds
- **Result:** Completed successfully using a Delta merge.

## Why was the second run faster?

During the full-refresh run, `is_incremental()` was false, so dbt processed the complete source history and recreated the table. During the incremental run, `is_incremental()` was true, and the filter compared incoming pickup dates with the maximum `pickup_date` in `{{ this }}`. This allowed dbt to process only newer data and use a Delta `MERGE`.

## Delta Table History

Command:

`DESCRIBE HISTORY hyf.dev_mohammedalfakih.fct_trips;`

| Version | Timestamp               | Operation                         |
| ------- | ----------------------- | --------------------------------- |
| 3       | 2026-07-30 00:57:53 UTC | MERGE                             |
| 1       | 2026-07-30 00:54:53 UTC | CREATE OR REPLACE TABLE AS SELECT |
