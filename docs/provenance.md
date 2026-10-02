# Provenance and retained work

This repository is Mohammed Alfakih's personal fork of [HackYourAssignment/c55-data-week-13](https://github.com/HackYourAssignment/c55-data-week-13), completed during HackYourFuture's Data Track. The course supplied the scaffold, tasks and shared Databricks tables. The original assignment guide is preserved in [hyf-assignment.md](hyf-assignment.md).

The portfolio update starts from [original completed snapshot `4996933`](https://github.com/mohammedalfakih-dev/c55-data-week-13/commit/49969330ab22773dc7d42323492a539c2bb5cdbc), titled “complete Databricks job scheduling evidence”. It retains the existing repository and Git history.

## What is preserved

- The complete PySpark notebook, code cells and saved outputs.
- All SQL transformation expressions, incremental configuration and model names.
- The dependency and package lockfiles, profile template and source configuration.
- Original Databricks Job screenshots, including the warning and paused trigger.
- Original recorded timing and Delta history values, with clearer context.
- The earlier PostgreSQL business-answer sheet, with an added origin note. Before that note, its SHA-256 matched the Week 10 solution's answer sheet exactly.
- Existing course support files and their history.

## Portfolio documentation changes

- Replace the assignment landing page with project questions, data flow, output links and setup guidance.
- Replace task instruction placeholders with explanations of the completed work.
- Correct green-taxi descriptions to match the configured yellow-taxi source and explain the daily mart grain.
- Explain the strict incremental date boundary, warning test, inherited numeric-cast precision and reproduction limits.
- Add a locked offline dbt parse check without warehouse credentials.
- Ignore local Python environments alongside existing dbt artifacts.

The planned repository name is `nyc-taxi-databricks-lakehouse`; renaming happens after PR review. Documentation uses relative project links so those links remain usable after the rename. Live Databricks resources are not changed by this PR.
