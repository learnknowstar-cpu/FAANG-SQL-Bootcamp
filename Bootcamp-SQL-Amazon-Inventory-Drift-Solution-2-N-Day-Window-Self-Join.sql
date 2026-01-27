WITH inventory_movement AS (
    SELECT
        product_id,
        event_time,
        event_type,
        quantity,

        -- Convert events to inventory delta
        CASE 
            WHEN event_type = 'IN'  THEN quantity
            WHEN event_type = 'OUT' THEN -quantity
        END AS inventory_change
    FROM inventory_events
)
, sliding_inventory AS (
    SELECT
        a.product_id,
        a.event_time,
        a.event_type,
        a.quantity,
        a.inventory_change,

        -- Sliding window inventory sum over last N days
        SUM(b.inventory_change) AS window_inventory
    FROM inventory_movement a
    JOIN inventory_movement b
        ON a.product_id = b.product_id
       AND b.event_time <= a.event_time
       AND b.event_time > DATEADD(DAY, -2, a.event_time) -- N = 2 days
    GROUP BY
        a.product_id,
        a.event_time,
        a.event_type,
        a.quantity,
        a.inventory_change
)
SELECT
    product_id,
    event_time,
    event_type,
    quantity,
    window_inventory
FROM sliding_inventory
WHERE window_inventory < 0
ORDER BY product_id, event_time;
