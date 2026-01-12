
-- Step 1: Use LAG to compare each value with the previous value per user
WITH lagged_data AS (
    SELECT
        user_id,
        activity_date,
        value,

        -- Previous value for the same user ordered by date
        LAG(value) OVER (
            PARTITION BY user_id
            ORDER BY activity_date
        ) AS prev_value
    FROM user_metrics
),

-- Step 2: Flag any violation of a strictly increasing trend
flagged_data AS (
    SELECT
        user_id,
        activity_date,
        value,
        prev_value,

        -- Violation rules:
        -- 1 → flat or decreasing value
        -- 0 → valid increase or first row (NULL prev_value)
        CASE
            WHEN prev_value IS NULL THEN 0        -- First row per user
            WHEN value <= prev_value THEN 1       -- Breaks increasing trend
            ELSE 0                                -- Proper increase
        END AS trend_break_flag
    FROM lagged_data
)

-- Step 3: Keep only users with zero violations and more than one record
SELECT
    user_id
FROM flagged_data
GROUP BY user_id
HAVING
    SUM(trend_break_flag) = 0    -- No flat/decreasing steps
    AND COUNT(*) > 1;          -- Exclude single-row users
