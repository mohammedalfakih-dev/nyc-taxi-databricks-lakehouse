# Git-backed Databricks Job

The saved coursework configuration runs dbt from this repository's `main` branch and project directory `task-2`, using `hyf-dbt-warehouse`. [Scheduling details and screenshots](SCHEDULING.md) record a successful manual run and a paused daily trigger.

To recreate it in your own Databricks workspace:

1. Make the source tables and target-schema permissions available; follow [setup](../docs/setup.md).
2. Create a Job with a dbt task, a Git provider source pointing to your fork, the desired Git reference and project directory `task-2`.
3. Choose your SQL warehouse and configure your target catalog/schema.
4. Use `dbt deps`, then `dbt build --select +fct_trips` so a fresh schema also builds the staging views.
5. Run manually and inspect model/test outcomes before enabling a schedule.

The historical job selected `fct_trips` without `+`; its upstream staging views had already been created. The notebook is a separate exploration and is not a task in that saved dbt Job.

After renaming the GitHub repository, update the Job's Git source to the new URL before running it again. No live Job or schedule is changed by this PR. [Databricks dbt task documentation](https://docs.databricks.com/aws/en/jobs/tasks/dbt).
