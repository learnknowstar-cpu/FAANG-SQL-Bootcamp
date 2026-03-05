WITH RoutePaths AS (

    -- Anchor
    SELECT
        source_city,
        destination_city,
        source_city AS start_city,
        CAST(source_city + ' -> ' + destination_city AS VARCHAR(MAX)) AS path,
        0 AS is_cycle
    FROM Routes

    UNION ALL

    -- Recursive
    SELECT
        rp.source_city,
        r.destination_city,
        rp.start_city,
        CAST(rp.path + ' -> ' + r.destination_city AS VARCHAR(MAX)),

        -- Detect cycle
        CASE
            WHEN r.destination_city = rp.start_city THEN 1
            ELSE 0
        END
    FROM RoutePaths rp
    JOIN Routes r
        ON rp.destination_city = r.source_city

    -- Stop only AFTER cycle is found
    WHERE rp.is_cycle = 0
)

SELECT
    start_city,
    path
FROM RoutePaths
WHERE is_cycle = 1;