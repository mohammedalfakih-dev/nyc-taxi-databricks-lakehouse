# Incremental design, recorded timings and Delta history

The `fct_trips` model is materialized as an incremental Delta table using `incremental_strategy='merge'`. Its grain and `unique_key` are `(pickup_borough, pickup_date)`. The assignment name is retained, although this is a daily borough mart rather than a trip-level fact.

## First build and incremental boundary

During the first build or a full refresh, `is_incremental()` is false and the model aggregates the available source history. On an existing incremental target, the model applies:

```sql
WHERE CAST(t.pickup_datetime AS DATE) > (
    SELECT MAX(pickup_date)
    FROM {{ this }}
)
```

`{{ this }}` resolves to the model's target relation. The strict `>` boundary selects only dates after its global maximum pickup date. Incoming borough/day aggregates are then merged by the composite key. A merge strategy does not independently recover rows excluded by this filter.

## Historical timing observations

The original coursework write-up recorded:

| Run | Wall-clock observation | Recorded outcome |
|---|---:|---|
| Full refresh | 20.404 seconds | Completed against `hyf-dbt-warehouse` |
| Incremental rerun | 16.735 seconds | Completed using Delta merge |

The rerun can aggregate fewer dates, including none if no newer date exists. These two observations do not prove how many new rows were processed, isolate cache/warehouse effects or establish a repeatable performance improvement. They were not remeasured for this documentation update. The later scheduled-job screenshot has a different run duration and is separate evidence.

## Recorded Delta history

Original command:

```sql
DESCRIBE HISTORY hyf.dev_mohammedalfakih.fct_trips;
```

| Version | Timestamp (UTC) | Recorded operation |
|---|---|---|
| 3 | 2026-07-30 00:57:53 | MERGE |
| 1 | 2026-07-30 00:54:53 | CREATE OR REPLACE TABLE AS SELECT |

These entries were copied into the original write-up; the live table/history is not queried by local parsing or CI.

## Limits of the current filter

- Late arrivals for an earlier date, updates to an existing date and additional records on the latest loaded day are skipped.
- A missing borough/day below another borough's maximum date is also skipped; the watermark is global.
- If an existing target is empty, `MAX(pickup_date)` is NULL and the predicate selects no records. A full refresh rebuilds that target.
- Source deletions are not propagated by the append-only filter.

A full refresh re-aggregates all available source rows and is the current recovery option. For a production adaptation, use an inclusive lookback window, re-aggregate all source records in that window and merge complete borough/day groups. Handle deleted or now-empty groups explicitly. The lookback design is a proposed improvement, not an implemented feature of this lab.

[dbt incremental model documentation](https://docs.getdbt.com/docs/build/incremental-models).
