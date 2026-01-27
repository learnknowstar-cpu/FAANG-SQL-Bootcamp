WITH inventory_movement AS (
    SELECT
        product_id,
        event_time,
        event_type,
        quantity,

        -- Convert inventory events into + / - movements
        CASE 
            WHEN event_type = 'IN'  THEN quantity
            WHEN event_type = 'OUT' THEN -quantity
        END AS inventory_change
    FROM inventory_events
),

running_inventory AS (
    SELECT
        product_id,
        event_time,
        event_type,
        quantity,
        inventory_change,

        -- Running inventory per product ordered by time
        SUM(inventory_change) OVER (
            PARTITION BY product_id
            ORDER BY event_time
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_stock
    FROM inventory_movement
)

SELECT
    product_id,
    event_time,
    event_type,
    quantity,
    running_stock
FROM running_inventory
WHERE running_stock < 0
ORDER BY product_id, event_time;
