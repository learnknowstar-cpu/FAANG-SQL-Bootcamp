
CREATE TABLE payment_events (
    payment_id INT,
    event_type VARCHAR(30),
    event_time DATETIME
);

INSERT INTO payment_events VALUES
-- Valid payment
(101, 'payment_created',  '2024-01-01 10:00'),
(101, 'payment_captured', '2024-01-01 10:01'),
(101, 'payment_settled',  '2024-01-01 10:05'),

-- Missing capture
(102, 'payment_created',  '2024-01-01 11:00'),
(102, 'payment_settled',  '2024-01-01 11:10'),

-- Missing settlement
(103, 'payment_created',  '2024-01-01 12:00'),
(103, 'payment_captured', '2024-01-01 12:01'),

-- Refund without settlement
(104, 'payment_created',  '2024-01-01 13:00'),
(104, 'payment_captured', '2024-01-01 13:01'),
(104, 'payment_refunded', '2024-01-01 13:02'),

-- Out-of-order events
(105, 'payment_captured', '2024-01-01 14:00'),
(105, 'payment_created',  '2024-01-01 14:01');
