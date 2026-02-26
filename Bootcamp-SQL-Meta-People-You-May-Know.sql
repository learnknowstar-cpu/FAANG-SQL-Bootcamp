WITH all_friends AS (
    SELECT user_id_1 AS user_id,
           user_id_2 AS friend_id,
           created_at
    FROM friendships
    UNION ALL
    SELECT user_id_2,
           user_id_1,
           created_at
    FROM friendships
),
direct_friends AS (
    SELECT friend_id
    FROM all_friends
    WHERE user_id = 1
),
friends_of_friends AS (
    SELECT 
        af.friend_id AS candidate_user,
        af.user_id AS mutual_friend,
        af.created_at
    FROM all_friends af
    JOIN direct_friends df
        ON af.user_id = df.friend_id
),
filtered_candidates AS (
    SELECT *
    FROM friends_of_friends
    WHERE candidate_user <> 1
      AND candidate_user NOT IN (
          SELECT friend_id FROM direct_friends
      )
),
scored_candidates AS (
    SELECT
        candidate_user,
        COUNT(*) AS mutual_count,
        MAX(created_at) AS latest_connection,
        COUNT(*) * 5 
          + DATEDIFF(DAY, MAX(created_at), GETDATE()) * -0.1 
          AS ranking_score
    FROM filtered_candidates
    GROUP BY candidate_user
)
SELECT TOP 10
    candidate_user,
    mutual_count,
    latest_connection,
    ranking_score
FROM scored_candidates
ORDER BY ranking_score DESC;