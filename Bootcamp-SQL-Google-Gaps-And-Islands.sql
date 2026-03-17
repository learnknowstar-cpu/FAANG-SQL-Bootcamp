
WITH daily_logins AS (
    -- Remove multiple logins on the same day
    SELECT DISTINCT
        user_id,
        CAST(login_time AS DATE) AS login_date
    FROM logins
),

first_login AS (
    -- Find first login date for each user
    SELECT
        user_id,
        MIN(login_date) AS first_login_date
    FROM daily_logins
    GROUP BY user_id
),

logins_7days AS (
    -- Keep only logins within 7 days of the first login
    SELECT
        d.user_id,
        d.login_date
    FROM daily_logins d
    JOIN first_login f
        ON d.user_id = f.user_id
    WHERE d.login_date <= DATEADD(day, 7, f.first_login_date)
),

streaks AS (
    -- Identify consecutive login streaks
    SELECT
        user_id,
        login_date,
        DATEADD(day, -ROW_NUMBER() OVER(
            PARTITION BY user_id
            ORDER BY login_date
        ), login_date) AS grp
    FROM logins_7days
)

-- Find users with streak >= 3
SELECT DISTINCT user_id
FROM (
    SELECT
        user_id,
        COUNT(*) AS streak_length
    FROM streaks
    GROUP BY user_id, grp
) s
WHERE streak_length >= 3;