# PySpark exploration

The completed [notebook](pyspark_exploration.ipynb) reads the course's normalized yellow-taxi tables, joins pickup locations to the zone lookup and groups records by borough. It separately groups raw trips by payment code and averages `total_amount`.

Both queries display small aggregate DataFrames with `show()`; the notebook does not collect the full raw dataset into local Python memory. A concluding note explains when PySpark DataFrame processing or dbt SQL is the better fit.

## Saved outputs

The exported notebook records Manhattan as the highest-count joined pickup borough, with 112,028,489 records. Recorded average total charges:

| Payment code | Average total charge (USD) |
|---|---:|
| 0 | 23.49 |
| 1 | 30.00 |
| 2 | 23.75 |
| 3 | 9.03 |
| 4 | 2.16 |
| 5 | 14.89 |

These are saved coursework outputs; data coverage and counts were not newly reproduced for this documentation update. The raw exploration population differs from the filtered dbt mart population.

## Run it in Databricks

Import the notebook into a Databricks workspace and attach suitable Spark compute with read access to `hyf.nyc_yellow.raw_trips` and `hyf.nyc_yellow.raw_zones`. For another workspace, adapt the two table references to equivalent normalized tables. Running it scans the available source data; it is not a bundled local dataset.

The notebook and its saved cell outputs are preserved unchanged.
