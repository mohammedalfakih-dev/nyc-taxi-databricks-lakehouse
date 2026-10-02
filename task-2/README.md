# dbt and Delta daily mart

This project reads normalized yellow-taxi trip and zone tables from `hyf.nyc_yellow`, creates staging views and builds a Delta incremental mart called `fct_trips`.

Despite its inherited name, the mart has one row per **pickup borough and pickup date**. Its composite merge key matches that grain. SQL transformations and the original model name are preserved.

| Resource | Purpose |
|---|---|
| `stg_trips` | Retain required trip fields, filter missing pickup IDs and negative fares, derive tip ratio |
| `stg_zones` | Expose location IDs and borough labels |
| `fct_trips` | Join pickup zones and aggregate daily counts, fares, tip ratios and distances |
| `safe_divide` | Return NULL for zero/NULL denominator using the inherited numeric casts |

Checks cover staging pickup timestamps/IDs, lookup ID uniqueness and essential lookup fields, the mart's composite grain and reporting keys. A singular warning test returns daily groups where average tip/fare ratio exceeds 1.

[Setup and offline parsing](../docs/setup.md) · [Incremental design and historical timings](WRITEUP.md) · [Metric definitions](../docs/metrics.md).

`reports/answers.md` is retained from the earlier PostgreSQL assignment. Its source table, population and recorded values are not results of this Databricks model. Use [current-model query examples](../docs/queries.sql) when reviewing this mart.
