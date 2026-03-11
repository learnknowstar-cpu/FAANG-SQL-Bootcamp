
CREATE TABLE trips
(
    trip_id INT PRIMARY KEY,
    
    driver_id INT NOT NULL,
    
    trip_timestamp DATETIME NOT NULL,
    
    trip_data NVARCHAR(MAX) NOT NULL,
    
    CONSTRAINT chk_valid_json
    CHECK (ISJSON(trip_data) = 1)
);


INSERT INTO trips VALUES
(1, 101, '2025-01-01 08:00:00',
'{
  "distance_km": 10,
  "duration_min": 20,
  "fare": 30,
  "pickup": {"city": "Toronto", "zone": "Downtown"},
  "rating": 4.8
}'),

(2, 101, '2025-01-01 09:00:00',
'{
  "distance_km": 5,
  "duration_min": 10,
  "fare": 18,
  "pickup": {"city": "Toronto", "zone": "Downtown"},
  "rating": 4.7
}'),

(3, 102, '2025-01-01 10:00:00',
'{
  "distance_km": 12,
  "duration_min": 24,
  "fare": 36,
  "pickup": {"city": "Toronto", "zone": "Midtown"},
  "rating": 4.9
}'),

(4, 102, '2025-01-01 11:00:00',
'{
  "distance_km": 8,
  "duration_min": 16,
  "fare": 20,
  "pickup": {"city": "Toronto", "zone": "Midtown"},
  "rating": 4.6
}'),

(5, 103, '2025-01-01 12:00:00',
'{
  "distance_km": 15,
  "duration_min": 30,
  "fare": 60,
  "pickup": {"city": "Vancouver", "zone": "Downtown"},
  "rating": 4.9
}'),

(6, 104, '2025-01-01 13:00:00',
'{
  "distance_km": 20,
  "duration_min": 40,
  "fare": 50,
  "pickup": {"city": "Vancouver", "zone": "Airport"},
  "rating": 4.7
}');