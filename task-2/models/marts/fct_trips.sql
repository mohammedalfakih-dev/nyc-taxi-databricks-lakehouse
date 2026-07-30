{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key=['pickup_borough', 'pickup_date']
    )
}}


WITH trips AS (
    SELECT *
    FROM {{ ref('stg_trips') }}
),

zones AS (
    SELECT *
    FROM {{ ref('stg_zones') }}
)

SELECT
    z.borough AS pickup_borough,
    CAST(t.pickup_datetime AS DATE) AS pickup_date,
    COUNT(*) AS trip_count,
    SUM(t.fare_amount) AS total_fare,
    AVG(t.tip_pct) AS avg_tip_pct,
    AVG(t.trip_distance) AS avg_trip_distance

FROM trips t

INNER JOIN zones z
    ON t.pickup_location_id = z.location_id

{% if is_incremental() %}
WHERE CAST(t.pickup_datetime AS DATE) > (
    SELECT MAX(pickup_date)
    FROM {{ this }}
)
{% endif %}

GROUP BY
    z.borough,
    CAST(t.pickup_datetime AS DATE)