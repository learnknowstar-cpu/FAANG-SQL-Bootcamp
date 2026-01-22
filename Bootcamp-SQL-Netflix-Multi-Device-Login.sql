
/* 
Step 1:
Order sessions per user by login time.
Use LAG() to look at the immediately previous session.
Overlapping sessions must appear next to each other
when ordered by start time.
*/
WITH ordered_sessions AS (
    SELECT
        session_id,
        user_id,
        device_type,
        login_time,
        logout_time,

        -- Device used in the previous session for the same user
        LAG(device_type) OVER (
            PARTITION BY user_id
            ORDER BY login_time
        ) AS prev_device,

        -- Logout time of the previous session
        LAG(logout_time) OVER (
            PARTITION BY user_id
            ORDER BY login_time
        ) AS prev_logout
    FROM netflix_sessions
)

-- Step 2:
-- Check if the current session overlaps with the previous one
-- AND the devices are different
SELECT DISTINCT
    user_id
FROM ordered_sessions
WHERE
    prev_device IS NOT NULL           -- Ignore first session per user
    AND device_type <> prev_device    -- Ensure multi-device usage
    AND login_time < prev_logout;     -- Time overlap condition

	-------------------------

	SELECT DISTINCT
    s1.user_id,
    s1.device_type AS device_1,
    s2.device_type AS device_2,
    s1.login_time AS device_1_login,
    s1.logout_time AS device_1_logout,
    s2.login_time AS device_2_login,
    s2.logout_time AS device_2_logout
FROM netflix_sessions s1
JOIN netflix_sessions s2
    ON s1.user_id = s2.user_id
   AND s1.device_type <> s2.device_type
   AND s1.login_time < s2.logout_time
   AND s2.login_time < s1.logout_time
   AND s1.session_id < s2.session_id;

