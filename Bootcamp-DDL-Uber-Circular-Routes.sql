
CREATE TABLE Routes (
    source_city VARCHAR(50),
    destination_city VARCHAR(50)
);

INSERT INTO Routes VALUES
('San Francisco', 'San Jose'),
('San Jose', 'Palo Alto'),
('Palo Alto', 'San Francisco'), -- cycle

('New York', 'Boston'),
('Boston', 'Chicago'),
('Chicago', 'New York'), -- cycle

('Los Angeles', 'San Diego'),
('San Diego', 'Las Vegas'); -- no cycle