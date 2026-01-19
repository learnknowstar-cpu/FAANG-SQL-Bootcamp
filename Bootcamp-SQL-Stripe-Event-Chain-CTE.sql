
/*
Goal:
Detect broken Stripe payment event chains using window functions
and explicit validation logic in a CTE.
Valid flow:
payment_created -> payment_captured -> payment_settled -> (optional) payment_refunded
*/

WITH ordered_events AS (
    SELECT
        payment_id,
        event_type,
        event_time,
        -- Look at the previous event in the timeline for each payment
        LAG(event_type) OVER (
            PARTITION BY payment_id
            ORDER BY event_time
        ) AS prev_event
    FROM payment_events
),

-- Aggregate per payment and check for broken chains
payment_validation AS (
    SELECT
        payment_id,
        -- Presence checks
        MAX(CASE WHEN event_type = 'payment_created' THEN 1 ELSE 0 END) AS has_created,
        MAX(CASE WHEN event_type = 'payment_captured' THEN 1 ELSE 0 END) AS has_captured,
        MAX(CASE WHEN event_type = 'payment_settled' THEN 1 ELSE 0 END) AS has_settled,
        
        -- Detect invalid transitions
        MAX(
            CASE
                WHEN event_type = 'payment_captured' AND prev_event <> 'payment_created' THEN 1
                WHEN event_type = 'payment_settled'  AND prev_event <> 'payment_captured' THEN 1
                WHEN event_type = 'payment_refunded' AND prev_event <> 'payment_settled'  THEN 1
                ELSE 0
            END
        ) AS invalid_transition
    FROM ordered_events
    GROUP BY payment_id
)

-- Final select: return only broken payment chains
SELECT payment_id
FROM payment_validation
WHERE 
    has_created = 0        -- Missing create
    OR has_captured = 0     -- Missing capture
    OR flg_settled = 0      -- Missing settlement
    OR invalid_transition = 1  -- Out-of-order events or refund without settlement
ORDER BY payment_id;
