# Setup and reproduction

Python 3.12 and [uv](https://docs.astral.sh/uv/) install the dependencies recorded in `task-2/uv.lock`. From the repository root:

```sh
cd task-2
uv sync --frozen --python 3.12
```

The lockfile is preserved. The locally checked combination is dbt-core 1.11.12 and dbt-databricks 1.12.3; this is not a recommendation to upgrade the project or proof of warehouse execution.

## Offline review without Databricks

Use a temporary copy of the profile template with dummy connection values. `dbt deps` downloads the declared dbt package; `dbt parse` validates Jinja/YAML and generates a manifest without connecting to a warehouse. The dummy settings deliberately cannot run a database build. [dbt parse documentation](https://docs.getdbt.com/reference/commands/parse).

PowerShell, from `task-2`, in a separate terminal from any real Databricks session:

```powershell
$parseProfileDir = Join-Path $env:TEMP 'nyc-taxi-dbt-parse'
New-Item -ItemType Directory -Force -Path $parseProfileDir | Out-Null
Copy-Item profiles.yml.example (Join-Path $parseProfileDir 'profiles.yml')
$env:DATABRICKS_HOST = 'offline.invalid'
$env:DATABRICKS_HTTP_PATH = '/sql/1.0/warehouses/offline'
$env:DATABRICKS_TOKEN = 'offline-placeholder'
$env:DBT_SCHEMA = 'portfolio_parse'
$env:DBT_SEND_ANONYMOUS_USAGE_STATS = 'false'
uv run dbt deps --profiles-dir $parseProfileDir
uv run dbt parse --profiles-dir $parseProfileDir --no-partial-parse
```

POSIX shell, from `task-2`, also in a separate terminal:

```sh
parse_profile_dir=$(mktemp -d)
cp profiles.yml.example "$parse_profile_dir/profiles.yml"
export DATABRICKS_HOST=offline.invalid
export DATABRICKS_HTTP_PATH=/sql/1.0/warehouses/offline
export DATABRICKS_TOKEN=offline-placeholder
export DBT_SCHEMA=portfolio_parse
export DBT_SEND_ANONYMOUS_USAGE_STATS=false
uv run dbt deps --profiles-dir "$parse_profile_dir"
uv run dbt parse --profiles-dir "$parse_profile_dir" --no-partial-parse
```

No real credentials are needed for this path. Dependency downloads require internet access on the first run. Generated files in `target/`, `logs/`, `dbt_packages/` and `.venv/` are ignored by Git. A successful parse is not a successful SQL build or data-test run.

## Databricks warehouse run

Required resources:

- A SQL warehouse with connection permissions.
- Read access to `hyf.nyc_yellow.raw_trips` and `hyf.nyc_yellow.raw_zones`.
- Your own writable target schema in catalog `hyf`.

The source tables are preloaded, normalized class tables. dbt requires `pickup_datetime`, `pickup_location_id`, `fare_amount`, `tip_amount` and `trip_distance`; zones require `location_id` and `borough`. The PySpark notebook additionally uses `payment_type` and `total_amount`. Public TLC Parquet files cannot be substituted without first loading and normalizing their field names.

For a different workspace/catalog, adapt `models/staging/_sources.yml`, `profiles.yml.example` and the notebook table names consistently. There is no source-loading or catalog-provisioning script in this repository.

Copy the profile template to ignored `task-2/profiles.yml`. In your real connection terminal, set `DATABRICKS_HOST`, `DATABRICKS_HTTP_PATH`, `DATABRICKS_TOKEN` and `DBT_SCHEMA` using your local connection details. `.env.example` documents these names; dbt does not automatically load the root `.env` file. The host is the hostname without an `https://` prefix; the HTTP path is your warehouse path.

From `task-2`:

```sh
uv run dbt deps --profiles-dir .
uv run dbt debug --profiles-dir .
uv run dbt build --profiles-dir . --select +fct_trips --full-refresh
uv run dbt build --profiles-dir . --select +fct_trips
```

The leading `+` includes upstream staging models, making the first build suitable for a fresh schema. The full refresh rebuilds the lab's target mart. The incremental rerun uses the existing strict newer-date filter. These commands are documented for reproduction; they were not run against a live warehouse for this PR.

Query your own target using the examples in [queries.sql](queries.sql), replacing `dev_yourname` with `DBT_SCHEMA`. [Incremental behavior and recovery limits](../task-2/WRITEUP.md).

## PySpark and Jobs

The notebook needs suitable Spark compute in Databricks and source-table read access. Local dbt parsing does not execute the notebook. The [Job guide](../task-3/README.md) explains recreating the Git-backed dbt task; the saved Job did not include the notebook.

After the repository rename, update any local clone's remote URL and any Databricks Job Git source to the new URL. The `task-2` directory, `main` branch and `fct_trips` model/job selector remain valid because this PR preserves those paths and names.
