WITH DateBounds AS (
    SELECT
        user_id,
        MIN(CAST(view_timestamp AS DATE)) AS start_date,
        MAX(CAST(view_timestamp AS DATE)) AS end_date
    FROM profile_views
    GROUP BY user_id
),

DateSeries AS (
    -- Generate one row per user per day
    SELECT
        user_id,
        start_date AS view_date
    FROM DateBounds

    UNION ALL

    SELECT
        ds.user_id,
        DATEADD(DAY, 1, ds.view_date)
    FROM DateSeries ds
    JOIN DateBounds db
        ON ds.user_id = db.user_id
    WHERE ds.view_date < db.end_date
),

DailyViews AS (
    -- Aggregate actual views
    SELECT
        user_id,
        CAST(view_timestamp AS DATE) AS view_date,
        COUNT(*) AS daily_views
    FROM profile_views
    GROUP BY user_id, CAST(view_timestamp AS DATE)
),

FinalDaily AS (
    -- Fill missing days with zero views
    SELECT
        ds.user_id,
        ds.view_date,
        ISNULL(dv.daily_views, 0) AS daily_views
    FROM DateSeries ds
    LEFT JOIN DailyViews dv
        ON ds.user_id = dv.user_id
       AND ds.view_date = dv.view_date
),

RollingStats AS (
    -- Rolling stats now operate on true daily continuity
    SELECT
        user_id,
        view_date,
        daily_views,
        AVG(daily_views) OVER (
            PARTITION BY user_id
            ORDER BY view_date
            ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
        ) AS moving_avg,
        STDEV(daily_views) OVER (
            PARTITION BY user_id
            ORDER BY view_date
            ROWS BETWEEN 3 PRECEDING AND 1 PRECEDING
        ) AS moving_stddev
    FROM FinalDaily
)

SELECT *
FROM RollingStats
WHERE daily_views > moving_avg + (2 * moving_stddev)
ORDER BY user_id, view_date
OPTION (MAXRECURSION 1000);
