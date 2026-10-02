# Model grain, metrics and quality

`fct_trips` contains one row per pickup borough and pickup date. Its composite merge key is `(pickup_borough, pickup_date)`. Despite the inherited model name, it is a daily borough aggregate, not a record of individual trips.

| Metric | Meaning |
|---|---|
| `trip_count` | Count of source records that pass staging and match a pickup zone |
| `total_fare` | Sum of meter fares in USD; not total payments or profit |
| `avg_tip_pct` | Mean of the implemented per-record tip/fare ratios; ratio rather than percent |
| `avg_trip_distance` | Mean recorded distance in miles |

Staging drops missing pickup IDs and negative/NULL fares. The zone join drops unmatched pickup IDs; a matching lookup row labeled `Unknown` still remains. Missing pickup timestamps are reported by a not-null test rather than filtered explicitly. There is no additional distance, tip or physical-trip deduplication policy in this lab.

The inherited `safe_divide` macro casts operands to `numeric` and uses `NULLIF` for zero denominators. On Databricks, bare `NUMERIC` defaults to `DECIMAL(10,0)`, so fractional dollar values can lose precision before division. The current SQL is preserved; a future correction should set an explicit decimal scale and validate fractional-cent/zero-denominator cases. Recorded tip ratios should not be treated as a newly verified exact-money calculation. [Databricks decimal type](https://docs.databricks.com/aws/en/sql/language-manual/data-types/decimal-type).

TLC's public yellow-taxi dictionary states that recorded tips exclude cash tips. The course tables are provided separately, so the public field definitions are context rather than independently verified provenance of every loaded row. [TLC yellow-taxi field dictionary](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf).

The warning test returns groups whose mean tip ratio exceeds 1. The saved Job run returned 158 such groups with warning severity. A warning does not fail that run and does not prove the underlying values are correct or incorrect; it identifies groups to investigate.

The PySpark notebook answers different raw-data questions. Its borough query joins raw trips to zones without the dbt fare filter; its payment query averages raw `total_amount`. These outputs must not be equated with the mart's fare sum or trip counts. When combining daily rows, sum counts/fares; do not average daily averages without the relevant contributing counts.
