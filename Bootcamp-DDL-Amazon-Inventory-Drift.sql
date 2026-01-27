
CREATE TABLE inventory_events (
    event_id INT IDENTITY PRIMARY KEY,
    product_id VARCHAR(10),
    event_time DATETIME,
    event_type VARCHAR(10), -- 'IN' or 'OUT'
    quantity INT
);

INSERT INTO inventory_events (product_id, event_time, event_type, quantity)
VALUES
('P100', '2025-01-01 09:00', 'IN', 50),
('P100', '2025-01-02 10:00', 'OUT', 30),
('P100', '2025-01-03 11:00', 'OUT', 40), -- ❌ Phantom stock
('P200', '2025-01-01 08:00', 'OUT', 10), -- ❌ Shipped before receiving
('P200', '2025-01-02 09:00', 'IN', 20),
('P200', '2025-01-03 12:00', 'OUT', 5),
('P300', '2025-01-01 10:00', 'IN', 100),
('P300', '2025-01-04 15:00', 'OUT', 60);
