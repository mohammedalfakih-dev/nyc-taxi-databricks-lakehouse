{{ config(severity='warn') }}

-- Business-rule warning test:
-- returns borough/date rows where the average tip ratio is greater than 1.
-- This means the average tip exceeded the fare amount, which is unusual.

SELECT
    pickup_borough,
    pickup_date,
    avg_tip_pct

FROM {{ ref('fct_trips') }}

WHERE avg_tip_pct > 1