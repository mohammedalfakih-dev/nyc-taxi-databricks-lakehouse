# Validation scope

Checked locally on 2 October 2026 (Europe/Amsterdam):

| Check | Result |
|---|---|
| Existing locked environment | Installed with Python 3.12; lockfile unchanged |
| dbt package resolution | Existing `dbt_utils` 1.4.1 installed; package lockfile unchanged |
| Offline dbt parse | Passed with dbt-core 1.11.12 / dbt-databricks 1.12.3 and dummy connection settings |
| Parsed project graph | 3 models and 9 data-test definitions; these tests were parsed, not executed |
| Existing HYF static grader | Passed, 100/100; not a Databricks runtime test |
| Notebook | JSON/code syntax checked; notebook code and saved outputs unchanged |
| Preservation | Git content hashes matched for 15 protected original files, including notebook, mart, macro, lockfiles, source settings and screenshots |
| SQL logic | All tracked transformation/test SQL unchanged after excluding comments |
| Workflow configuration | YAML syntax checked; GitHub execution must be inspected on the PR |

The new workflow repeats the locked install and offline parse without warehouse credentials. [dbt parse](https://docs.getdbt.com/reference/commands/parse) does not connect to a warehouse or execute SQL; it cannot prove that a cloud build or data test will succeed.

No Databricks notebook, warehouse build, cloud Job or schedule was run or changed for this PR. Saved notebook results, July timing/history entries and Job screenshots are historical coursework evidence. The screenshot's warning result is retained and explained, rather than presented as a clean data-quality pass.

Known incremental and numeric-precision limits are documented in [WRITEUP](../task-2/WRITEUP.md) and [metrics](metrics.md). The original implementation remains available for review and later improvements.
