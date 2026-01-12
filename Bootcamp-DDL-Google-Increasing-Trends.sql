
CREATE TABLE user_metrics (
    user_id INT,
    activity_date DATE,
    value INT
);

INSERT INTO user_metrics VALUES
-- User 1 (Increasing trend)
(1, '2024-01-01', 10),
(1, '2024-01-02', 20),
(1, '2024-01-03', 30),

-- User 2 (Not increasing)
(2, '2024-01-01', 10),
(2, '2024-01-02', 8),
(2, '2024-01-03', 15),

-- User 3 (Flat value - trap)
(3, '2024-01-01', 10),
(3, '2024-01-02', 10),
(3, '2024-01-03', 20),

-- User 4 (Single row - trap)
(4, '2024-01-01', 50);
