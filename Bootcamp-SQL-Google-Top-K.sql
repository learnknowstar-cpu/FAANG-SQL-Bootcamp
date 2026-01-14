
-- Step 1: Define K dynamically
DECLARE @K INT = 2;

-- Step 2: Rank results per query AFTER applying filters
WITH RankedResults AS (
    SELECT
        query,
        url,
        score,

        -- Assign rank per query based on highest score
        ROW_NUMBER() OVER (
            PARTITION BY query          -- Reset ranking for each search query
            ORDER BY score DESC          -- Highest score gets rank = 1
        ) AS rn

    FROM SearchResults
    WHERE
        is_active = 1                   -- Dynamic filter #1: only active results
        AND created_at >= DATEADD(DAY, -30, GETDATE())  -- Dynamic filter #2: recent data
)

-- Step 3: Pick only Top K per query
SELECT
    query,
    url,
    score
FROM RankedResults
WHERE rn <= @K
ORDER BY query, score DESC;
