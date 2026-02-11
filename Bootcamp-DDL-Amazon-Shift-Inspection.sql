
CREATE TABLE orders (
    order_id   INT PRIMARY KEY,
    order_date DATETIME
);

INSERT INTO orders (order_id, order_date) VALUES
(1, '2024-01-01 10:30:00'), -- Monday
(2, '2024-01-02 14:00:00'), -- Tuesday
(3, '2024-01-03 11:00:00'), -- Wednesday
(4, '2024-01-04 16:00:00'), -- Thursday
(5, '2024-01-05 09:15:00'); -- Friday

CREATE TABLE holidays (
    holiday_date DATE PRIMARY KEY
);

INSERT INTO holidays VALUES
('2024-01-09'); -- Tuesday holiday

CREATE TABLE dim_calendar (
    calendar_date       DATE PRIMARY KEY,
    is_weekend           BIT,
    is_holiday           BIT,
    business_start_time  TIME,
    business_end_time    TIME
);

-- Populate Calendar Dimension

DECLARE @d DATE = '2024-01-01';

WHILE @d <= '2024-01-31'
BEGIN
    INSERT INTO dim_calendar
    SELECT
        @d,
        CASE WHEN DATENAME(weekday, @d) IN ('Saturday', 'Sunday') THEN 1 ELSE 0 END,
        CASE WHEN EXISTS (
            SELECT 1 FROM holidays h WHERE h.holiday_date = @d
        ) THEN 1 ELSE 0 END,
        '09:00',
        '17:00';

    SET @d = DATEADD(day, 1, @d);
END;


