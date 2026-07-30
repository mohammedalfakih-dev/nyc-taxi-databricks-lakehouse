# Business Question Answers

Queries run against `dev_mohammedalfakih.fct_daily_borough_stats`.

## Q1: Highest total `total_fare` across the whole loaded dataset

**SQL:**

```sql
SELECT
    pickup_borough,
    SUM(total_fare) AS total_fare_all_days
FROM dev_mohammedalfakih.fct_daily_borough_stats
GROUP BY pickup_borough
ORDER BY total_fare_all_days DESC
LIMIT 1;
```

**Result:** | pickup_borough | total_fare_all_days |
| Manhattan | 493,955.62 |

**Interpretation:** Manhattan generated the highest total fare across the loaded dataset, with $493,955.62 in total fare revenue.

---

## Q2: Day with the highest overall `trip_count`

**SQL:**

```sql
SELECT
    pickup_date,
    SUM(trip_count) AS overall_trip_count
FROM dev_mohammedalfakih.fct_daily_borough_stats
GROUP BY pickup_date
ORDER BY overall_trip_count DESC
LIMIT 1;
```

**Result:** | pickup_date | overall_trip_count |
| 2024-01-17 | 2,221 |

**Interpretation:** January 17, 2024 had the highest total trip volume across all pickup boroughs, with 2,221 trips.

---

## Q3: Highest `avg_tip_pct` for any (borough, day) combination

**SQL:**

```sql
SELECT
    pickup_borough,
    pickup_date,
    avg_tip_pct
FROM dev_mohammedalfakih.fct_daily_borough_stats
ORDER BY avg_tip_pct DESC
LIMIT 5;
```

**Result:** | pickup_borough | pickup_date | avg_tip_pct |

            | Unknown        | 2024-01-30  |     2.500125 |
            | Unknown        | 2024-01-07  | 1.3396296296 |
            | Unknown        | 2024-01-11  |  1.104495614 |
            | Unknown        | 2024-01-16  |            1 |
            | Unknown        | 2024-01-18  | 0.6111111111 |

**Interpretation:** The highest average tip percentage was for the Unknown borough on 2024-01-30, where the average tip was more than twice the fare; this matches the warning test and is likely caused by unusual trips in a small Unknown borough group rather than a model failure.

The warning-level singular test returned these rows where avg_tip_pct > 1:

| pickup_borough | pickup_date |  avg_tip_pct |
| -------------- | ----------- | -----------: |
| Unknown        | 2024-01-30  |     2.500125 |
| Unknown        | 2024-01-07  | 1.3396296296 |
| Unknown        | 2024-01-11  |  1.104495614 |

## These are data quality warnings, not build errors.

## Q4: Median daily `trip_count` for Manhattan vs Brooklyn

**SQL:**

```sql
SELECT
    pickup_borough,
    percentile_cont(0.5) WITHIN GROUP (ORDER BY trip_count) AS median_daily_trip_count
FROM dev_mohammedalfakih.fct_daily_borough_stats
WHERE pickup_borough IN ('Manhattan', 'Brooklyn')
GROUP BY pickup_borough
ORDER BY pickup_borough;
```

**Result:** | pickup_borough | median_daily_trip_count |
| Brooklyn | 248 |
| Manhattan | 1,169.5 |

**Interpretation:** Manhattan’s median daily trip count was much higher than Brooklyn’s, at about 4.7 times as many trips per day.
