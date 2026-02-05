
DROP TABLE IF EXISTS servers;
CREATE TABLE servers (
    server_id VARCHAR(10) PRIMARY KEY,
    weight    INT NOT NULL
);

INSERT INTO servers (server_id, weight)
VALUES
('S1', 5),
('S2', 3),
('S3', 2);


DROP TABLE IF EXISTS requests;
CREATE TABLE requests (
    request_id   INT PRIMARY KEY,
    request_time DATETIME2(0) NOT NULL,
    user_id      INT NOT NULL
);

INSERT INTO requests (request_id, request_time, user_id)
VALUES
( 1, '2026-01-01 10:00:01', 101),
( 2, '2026-01-01 10:00:02', 102),
( 3, '2026-01-01 10:00:03', 103),
( 4, '2026-01-01 10:00:04', 104),
( 5, '2026-01-01 10:00:05', 105),
( 6, '2026-01-01 10:00:06', 106),
( 7, '2026-01-01 10:00:07', 107),
( 8, '2026-01-01 10:00:08', 108),
( 9, '2026-01-01 10:00:09', 109),
(10, '2026-01-01 10:00:10', 110),
(11, '2026-01-01 10:00:11', 111),
(12, '2026-01-01 10:00:12', 112),
(13, '2026-01-01 10:00:13', 113),
(14, '2026-01-01 10:00:14', 114),
(15, '2026-01-01 10:00:15', 115);
