CREATE TABLE friendships (
    user_id_1 INT,
    user_id_2 INT,
    created_at DATETIME
);

INSERT INTO friendships VALUES
(1,2,'2024-01-01'),
(1,3,'2024-01-02'),
(2,3,'2024-01-03'),
(2,4,'2024-02-01'),
(3,4,'2024-02-02'),
(3,5,'2024-03-01'),
(4,5,'2024-03-05'),
(5,6,'2024-04-01');