
-- Sol1 - Self Join

WITH items AS (
    SELECT 
        o1.order_id,
        o1.product_id AS item1,
        o2.product_id AS item2,
        o3.product_id AS item3
    FROM orders o1
    INNER JOIN orders o2 
        ON o1.order_id = o2.order_id 
        AND o1.product_id < o2.product_id
    INNER JOIN orders o3 
        ON o2.order_id = o3.order_id 
        AND o2.product_id < o3.product_id
)
SELECT 
    item1,
    item2,
    item3,
    COUNT(*) AS frequency
FROM items
GROUP BY item1, item2, item3
HAVING COUNT(*) >= 2
ORDER BY frequency DESC;

-- Sol2 - String Aggregation

