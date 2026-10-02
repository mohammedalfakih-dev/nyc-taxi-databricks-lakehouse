-- Review examples for the CURRENT daily borough mart, not recorded query outputs.
-- Replace dev_yourname with your configured DBT_SCHEMA.

-- Total meter fare by pickup borough.
SELECT pickup_borough, SUM(total_fare) AS total_meter_fare
FROM hyf.dev_yourname.fct_trips
GROUP BY pickup_borough
ORDER BY total_meter_fare DESC;

-- Busiest pickup date by accepted record count.
SELECT pickup_date, SUM(trip_count) AS accepted_trip_records
FROM hyf.dev_yourname.fct_trips
GROUP BY pickup_date
ORDER BY accepted_trip_records DESC
LIMIT 1;

-- The daily groups flagged by the warning-level tip-ratio test.
SELECT pickup_borough, pickup_date, avg_tip_pct
FROM hyf.dev_yourname.fct_trips
WHERE avg_tip_pct > 1
ORDER BY avg_tip_pct DESC;

-- Recorded daily volume distribution; approximate median, not an exact median.
SELECT pickup_borough,
    percentile_approx(trip_count, 0.5) AS approximate_median_daily_records
FROM hyf.dev_yourname.fct_trips
WHERE pickup_borough IN ('Manhattan', 'Brooklyn')
GROUP BY pickup_borough;

-- Verify loaded date coverage and table history in the connected workspace.
SELECT MIN(pickup_date) AS first_pickup_date, MAX(pickup_date) AS last_pickup_date,
    COUNT(*) AS daily_borough_rows
FROM hyf.dev_yourname.fct_trips;

DESCRIBE HISTORY hyf.dev_yourname.fct_trips;
