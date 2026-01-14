
CREATE TABLE SearchResults (
    query       VARCHAR(100),
    url         VARCHAR(200),
    score       INT,
    is_active   BIT,
    created_at DATE
);


INSERT INTO SearchResults VALUES
('sql tutorial', 'siteA.com', 95, 1, DATEADD(DAY, -5, GETDATE())),
('sql tutorial', 'siteB.com', 90, 1, DATEADD(DAY, -10, GETDATE())),
('sql tutorial', 'siteC.com', 85, 1, DATEADD(DAY, -15, GETDATE())),
('sql tutorial', 'siteD.com', 80, 0, DATEADD(DAY, -5, GETDATE())), -- inactive
('python tutorial', 'siteE.com', 92, 1, DATEADD(DAY, -3, GETDATE())),
('python tutorial', 'siteF.com', 88, 1, DATEADD(DAY, -40, GETDATE())); -- old
