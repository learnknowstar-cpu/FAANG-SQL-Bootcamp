
WITH DailyViews AS (
    -- Step 1: Normalize uneven timestamps into daily buckets
    SELECT
        user_id,
        CAST(view_timestamp AS DATE) AS view_date,
        COUNT(*) AS daily_views
    FROM profile_views
    GROUP BY user_id, CAST(view_timestamp AS DATE)
),

RollingStats AS (
    -- Step 2: Compute rolling metrics using a 3-day window
    SELECT
        user_id,
        view_date,
        daily_views,

        -- Moving average of last 3 days 
        AVG(daily_views) OVER (
            PARTITION BY user_id
            ORDER BY view_date
            ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
        ) AS moving_avg,

        -- Standard deviation over same window
        STDEV(daily_views) OVER (
            PARTITION BY user_id
            ORDER BY view_date
            ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
        ) AS moving_stddev
    FROM DailyViews
)

-- Step 3: Detect anomalies using deviation threshold
SELECT
    user_id,
    view_date,
    daily_views,
    moving_avg,
    moving_stddev
FROM RollingStats
WHERE daily_views > moving_avg + (2 * moving_stddev)
ORDER BY user_id, view_date;
