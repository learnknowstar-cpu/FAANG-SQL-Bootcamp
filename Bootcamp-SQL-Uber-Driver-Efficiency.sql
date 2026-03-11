WITH extracted AS (
-- Step 1: Extract JSON fields using OPENJSON
    SELECT
        t.driver_id,
        j.city,
        j.duration_min,
        j.fare,

        j.fare * 1.0 / NULLIF(j.duration_min, 0) AS efficiency_score

    FROM trips t

    CROSS APPLY OPENJSON(t.trip_data)
    WITH (
        city VARCHAR(100) '$.pickup.city',
        duration_min FLOAT '$.duration_min',
        fare FLOAT '$.fare'
    ) j
),

driver_efficiency AS (
-- Step 2: Calculate average efficiency per driver per city
    SELECT

        city,
        driver_id,

        AVG(efficiency_score) AS avg_efficiency_score

    FROM extracted

    GROUP BY
        city,
        driver_id
),

ranked AS (
-- Step 3: Rank drivers per city using Window Function
    SELECT
        city,
        driver_id,
        avg_efficiency_score,

        RANK() OVER (
            PARTITION BY city
            ORDER BY avg_efficiency_score DESC
        ) AS rank

    FROM driver_efficiency
)
-- Step 4: Select Top 3 Drivers per City
SELECT
    city,
    driver_id,
    avg_efficiency_score,
    rank

FROM ranked

WHERE rank <= 3

ORDER BY city, rank;