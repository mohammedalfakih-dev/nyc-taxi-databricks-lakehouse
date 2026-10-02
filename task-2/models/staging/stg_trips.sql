-- Staging model: one retained source record from hyf.nyc_yellow.raw_trips.
-- Selects source fields, derives the tip ratio, and applies staging filters.
-- Downstream: the daily borough mart fct_trips joins this to stg_zones.

SELECT
    pickup_datetime,
    pickup_location_id,
    fare_amount,
    tip_amount,
    trip_distance,
    {{ safe_divide('tip_amount', 'fare_amount') }} AS tip_pct

FROM {{ source('nyc_taxi', 'raw_trips') }}

WHERE
    pickup_location_id IS NOT NULL
    AND fare_amount >= 0
