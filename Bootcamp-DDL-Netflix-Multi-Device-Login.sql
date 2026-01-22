
CREATE TABLE netflix_sessions (
    session_id INT PRIMARY KEY,
    user_id INT,
    device_type VARCHAR(20),
    login_time DATETIME,
    logout_time DATETIME
);

INSERT INTO netflix_sessions VALUES
(1, 101, 'Mobile',  '2025-01-01 10:00', '2025-01-01 11:00'),
(2, 101, 'TV',      '2025-01-01 10:30', '2025-01-01 12:00'),
(3, 101, 'Laptop', '2025-01-01 13:00', '2025-01-01 14:00'),

(4, 102, 'Mobile', '2025-01-02 09:00', '2025-01-02 10:00'),
(5, 102, 'TV',     '2025-01-02 10:00', '2025-01-02 11:00'),

(6, 103, 'Tablet', '2025-01-03 08:00', '2025-01-03 09:30'),
(7, 103, 'Mobile', '2025-01-03 09:00', '2025-01-03 10:00');
