
-- Sol2 - Recursive CTE

WITH base AS (
    SELECT DISTINCT order_id, product_id
    FROM orders
),
combinations AS (
    -- Start with single items
    SELECT 
        order_id,
        CAST(product_id AS VARCHAR(MAX)) AS combo,
        product_id,
        1 AS level
    FROM base

    UNION ALL

    -- Build combinations recursively
    SELECT 
        c.order_id,
        CONCAT(c.combo, ',', b.product_id),
        b.product_id,
        c.level + 1
    FROM combinations c
    JOIN base b
        ON c.order_id = b.order_id
        AND c.product_id < b.product_id
)

--SELECT * FROM combinations order by order_id;

SELECT 
    combo,
    COUNT(*) AS frequency
FROM combinations
WHERE level >= 3
GROUP BY combo
HAVING COUNT(*) >= 2
ORDER BY frequency DESC;